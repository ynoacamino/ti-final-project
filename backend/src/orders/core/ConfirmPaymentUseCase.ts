import type {
  ConfirmPaymentDTO,
  IConfirmPaymentUseCase,
} from "../ports/in/IConfirmPaymentUseCase.ts";
import type { IOrderRepository } from "../ports/out/IOrderRepository.ts";
import type { IPaymentGateway } from "../ports/out/IPaymentGateway.ts";
import type { ICartRepository } from "../../cart/ports/out/ICartRepository.ts";
import type { IDecrementStockUseCase } from "../../inventory/ports/in/IDecrementStockUseCase.ts";
import { Order } from "./Order.ts";
import { Payment } from "./Payment.ts";
import { Cart } from "../../cart/core/Cart.ts";

export class ConfirmPaymentUseCase implements IConfirmPaymentUseCase {
  constructor(
    private readonly orderRepository: IOrderRepository,
    private readonly cartRepository: ICartRepository,
    private readonly paymentGateway: IPaymentGateway,
    private readonly decrementStockUseCase: IDecrementStockUseCase,
  ) {}

  async execute(dto: ConfirmPaymentDTO): Promise<Order> {
    // 1. Fetch order by payment intent ID
    const order = await this.orderRepository.findByPaymentIntentId(dto.stripePaymentIntentId);
    if (!order) {
      throw new Error(`Order not found for PaymentIntent: ${dto.stripePaymentIntentId}`);
    }

    // Idempotency: If already paid, return it directly
    if (order.status === "pagado") {
      return order;
    }

    // 2. Fetch payment status from gateway
    const paymentStatus = await this.paymentGateway.retrievePaymentIntentStatus(
      dto.stripePaymentIntentId,
    );

    if (paymentStatus.status === "succeeded") {
      // 3. Create Payment record
      const payment = Payment.create({
        id: crypto.randomUUID(),
        orderId: order.id,
        amount: order.total,
        currency: order.currency,
        status: "succeeded",
        method: "card",
        stripeChargeId: paymentStatus.chargeId,
        stripePaymentIntentId: dto.stripePaymentIntentId,
      });

      await this.orderRepository.savePayment(payment);

      // 4. Update order status to paid
      const updatedOrder = Order.create({
        ...order,
        status: "pagado",
        updatedAt: new Date().toISOString(),
      });

      await this.orderRepository.save(updatedOrder);

      // 5. Atomic Stock Decrement & Movement Logging
      for (const item of order.items) {
        await this.decrementStockUseCase.execute({
          productVariantId: item.productVariantId,
          quantity: item.quantity,
          referenceType: "order",
          referenceId: order.id,
        });
      }

      // 6. Convert and Empty Active Cart
      let cart: Cart | null = null;
      if (order.customerId) {
        cart = await this.cartRepository.findActiveByCustomerId(order.customerId);
      } else if (order.items.length > 0 && order.items[0]) {
        cart = await this.cartRepository.findActiveCartByVariantId(order.items[0].productVariantId);
      }

      if (cart) {
        const convertedCart = Cart.create({
          ...cart,
          status: "converted",
          updatedAt: new Date().toISOString(),
        });
        await this.cartRepository.save(convertedCart);
        await this.cartRepository.deleteItemsByCartId(cart.id);
      }

      // Return fully updated order
      const finalOrder = await this.orderRepository.findById(order.id);
      if (!finalOrder) {
        throw new Error("Failed to load updated order");
      }
      return finalOrder;
    } else if (paymentStatus.status === "failed") {
      // Create Failed Payment log
      const failedPayment = Payment.create({
        id: crypto.randomUUID(),
        orderId: order.id,
        amount: order.total,
        status: "failed",
        stripePaymentIntentId: dto.stripePaymentIntentId,
        errorMessage: paymentStatus.errorMessage || "Payment failed",
      });

      await this.orderRepository.savePayment(failedPayment);

      const failedOrder = Order.create({
        ...order,
        status: "fallido",
        updatedAt: new Date().toISOString(),
      });

      await this.orderRepository.save(failedOrder);
      throw new Error(`Payment failed: ${paymentStatus.errorMessage || "Unknown error"}`);
    } else {
      throw new Error(`Payment is in an unconfirmable state: ${paymentStatus.status}`);
    }
  }
}
