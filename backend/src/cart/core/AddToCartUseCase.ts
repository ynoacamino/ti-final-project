import type { IAddToCartUseCase, AddToCartDTO } from "../ports/in/IAddToCartUseCase.ts";
import type { ICartRepository } from "../ports/out/ICartRepository.ts";
import type { IProductRepository } from "../../catalog/ports/out/IProductRepository.ts";
import { Cart } from "./Cart.ts";
import { CartItem } from "./CartItem.ts";

/**
 *
 */
export class AddToCartUseCase implements IAddToCartUseCase {
  /**
   *
   */
  constructor(
    private readonly cartRepository: ICartRepository,
    private readonly productRepository: IProductRepository,
  ) {}

  /**
   *
   */
  async execute(dto: AddToCartDTO): Promise<Cart> {
    // 1. Fetch variant to check stock and price
    const variant = await this.productRepository.findVariantById(dto.productVariantId);
    if (!variant) {
      throw new Error("Variant not found");
    }

    const product = await this.productRepository.findById(variant.productId);
    if (!product) {
      throw new Error("Product not found");
    }

    // 2. Fetch or create active cart
    let cart: Cart | null = null;
    if (dto.customerId) {
      cart = await this.cartRepository.findActiveByCustomerId(dto.customerId);
    } else if (dto.sessionId) {
      cart = await this.cartRepository.findActiveBySessionId(dto.sessionId);
    }

    if (!cart) {
      cart = Cart.create({
        id: crypto.randomUUID(),
        customerId: dto.customerId,
        sessionId: dto.sessionId,
        status: "active",
        items: [],
      });
      await this.cartRepository.save(cart);
    }

    // 3. Find if item already exists in cart
    const existingItem = cart.items.find((item) => item.productVariantId === dto.productVariantId);
    const newQuantity = existingItem ? existingItem.quantity + dto.quantity : dto.quantity;

    // 4. Validate stock
    if (newQuantity > variant.stock) {
      throw new Error(
        `Insuficient stock for variant ${variant.color.toLowerCase()}-${variant.size}: ${variant.stock} available`,
      );
    }

    // 5. Compute price snapshot (base price of product + variant additional price)
    const unitPriceSnapshot = product.basePrice + variant.additionalPrice;

    // 6. Save or update item
    if (existingItem) {
      const updatedItem = CartItem.create({
        ...existingItem,
        quantity: newQuantity,
        unitPriceSnapshot,
        updatedAt: new Date().toISOString(),
      });
      await this.cartRepository.saveItem(updatedItem);
    } else {
      const newItem = CartItem.create({
        id: crypto.randomUUID(),
        cartId: cart.id,
        productVariantId: dto.productVariantId,
        quantity: dto.quantity,
        unitPriceSnapshot,
      });
      await this.cartRepository.saveItem(newItem);
    }

    // 7. Return refreshed cart
    const refreshedCart = await this.cartRepository.findById(cart.id);
    if (!refreshedCart) {
      throw new Error("Failed to load updated cart");
    }
    return refreshedCart;
  }
}
