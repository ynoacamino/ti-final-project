import type { Cart } from "../../core/Cart.ts";
import type { CartItem } from "../../core/CartItem.ts";

export interface ICartRepository {
  findById(id: string): Promise<Cart | null>;
  findActiveByCustomerId(customerId: string): Promise<Cart | null>;
  findActiveBySessionId(sessionId: string): Promise<Cart | null>;
  save(cart: Cart): Promise<void>;
  saveItem(item: CartItem): Promise<void>;
  deleteItem(id: string): Promise<void>;
  deleteItemsByCartId(cartId: string): Promise<void>;
  findCartByItemId(itemId: string): Promise<Cart | null>;
  findActiveCartByVariantId(variantId: string): Promise<Cart | null>;
}
