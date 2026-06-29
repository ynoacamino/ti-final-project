import type {
  CheckoutResult,
  CreateCheckoutDTO,
  ICreateCheckoutUseCase,
} from "../ports/in/ICreateCheckoutUseCase.ts";
import type { IOrderRepository } from "../ports/out/IOrderRepository.ts";
import type { IPaymentGateway } from "../ports/out/IPaymentGateway.ts";
import type { ICartRepository } from "../../cart/ports/out/ICartRepository.ts";
import type { IProductRepository } from "../../catalog/ports/out/IProductRepository.ts";
import { Order } from "./Order.ts";
import { OrderItem } from "./OrderItem.ts";

export class CreateCheckoutUseCase implements ICreateCheckoutUseCase {
  constructor(
    private readonly orderRepository: IOrderRepository,
    private readonly cartRepository: ICartRepository,
    private readonly productRepository: IProductRepository,
    private readonly paymentGateway: IPaymentGateway,
  ) {}

  async execute(dto: CreateCheckoutDTO): Promise<CheckoutResult> {
    // 1. Fetch active cart
    const cart = await this.cartRepository.findById(dto.cartId);
    if (!cart || cart.items.length === 0) {
      throw new Error("Cannot checkout an empty cart");
    }

    // 2. Calculate subtotal and total (in cents)
    const subtotal = cart.getSubtotal();
    const total = subtotal; // No shipping cost or discounts in MVP

    // 3. Create unique Order ID
    const orderId = crypto.randomUUID();

    // 4. Generate Stripe PaymentIntent
    const paymentIntent = await this.paymentGateway.createPaymentIntent(total, "PEN", {
      orderId,
      customerId: dto.customerId || "guest",
    });

    // 5. Create OrderItem instances with snapshots
    const orderItems: OrderItem[] = [];
    for (const item of cart.items) {
      const variant = await this.productRepository.findVariantById(item.productVariantId);
      if (!variant) {
        throw new Error(`Variant ${item.productVariantId} not found during checkout`);
      }

      const product = await this.productRepository.findById(variant.productId);
      if (!product) {
        throw new Error(`Product for variant ${variant.sku} not found during checkout`);
      }

      const variantDetailsSnapshot = JSON.stringify({
        size: variant.size,
        color: variant.color,
        sku: variant.sku,
      });

      const orderItem = OrderItem.create({
        id: crypto.randomUUID(),
        orderId,
        productVariantId: item.productVariantId,
        productNameSnapshot: product.name,
        variantDetailsSnapshot,
        quantity: item.quantity,
        unitPrice: item.unitPriceSnapshot,
        subtotal: item.quantity * item.unitPriceSnapshot,
      });

      orderItems.push(orderItem);
    }

    // 6. Create Order entity
    const addressJson = JSON.stringify(dto.shippingAddress);

    const newOrder = Order.create({
      id: orderId,
      customerId: dto.customerId,
      guestEmail: dto.guestEmail,
      guestName: dto.guestName,
      guestPhone: dto.guestPhone,
      shippingAddress: addressJson,
      subtotal,
      total,
      currency: "PEN",
      status: "pendiente",
      stripePaymentIntentId: paymentIntent.id,
      notes: dto.notes,
      items: orderItems,
    });

    // 7. Save Order to Database
    await this.orderRepository.save(newOrder);

    return {
      order: newOrder,
      clientSecret: paymentIntent.clientSecret,
    };
  }
}
