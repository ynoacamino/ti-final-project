import type { ICartRepository } from "../ports/out/ICartRepository.ts";
import { Cart } from "../core/Cart.ts";
import { CartItem } from "../core/CartItem.ts";
import { db } from "../../shared/infrastructure/database/client.ts";
import { carts, cartItems } from "../../shared/infrastructure/database/schema.ts";
import { eq, and } from "drizzle-orm";

/**
 *
 */
export class SqliteCartRepo implements ICartRepository {
  private toDomain(
    row: typeof carts.$inferSelect,
    itemRows: Array<typeof cartItems.$inferSelect>,
  ): Cart {
    const items = itemRows.map(
      (item) =>
        new CartItem(
          item.id,
          item.cartId,
          item.productVariantId,
          item.quantity,
          item.unitPriceSnapshot,
          item.createdAt,
          item.updatedAt,
        ),
    );

    return new Cart(
      row.id,
      row.customerId,
      row.sessionId,
      row.status as "active" | "abandoned" | "converted",
      row.createdAt,
      row.updatedAt,
      items,
    );
  }

  /**
   *
   */
  async findById(id: string): Promise<Cart | null> {
    const [row] = await db.select().from(carts).where(eq(carts.id, id)).limit(1);
    if (!row) return null;

    const itemRows = await db.select().from(cartItems).where(eq(cartItems.cartId, id));
    return this.toDomain(row, itemRows);
  }

  /**
   *
   */
  async findActiveByCustomerId(customerId: string): Promise<Cart | null> {
    const [row] = await db
      .select()
      .from(carts)
      .where(and(eq(carts.customerId, customerId), eq(carts.status, "active")))
      .limit(1);

    if (!row) return null;

    const itemRows = await db.select().from(cartItems).where(eq(cartItems.cartId, row.id));
    return this.toDomain(row, itemRows);
  }

  /**
   *
   */
  async findActiveBySessionId(sessionId: string): Promise<Cart | null> {
    const [row] = await db
      .select()
      .from(carts)
      .where(and(eq(carts.sessionId, sessionId), eq(carts.status, "active")))
      .limit(1);

    if (!row) return null;

    const itemRows = await db.select().from(cartItems).where(eq(cartItems.cartId, row.id));
    return this.toDomain(row, itemRows);
  }

  /**
   *
   */
  async save(cart: Cart): Promise<void> {
    await db
      .insert(carts)
      .values({
        id: cart.id,
        customerId: cart.customerId,
        sessionId: cart.sessionId,
        status: cart.status,
        createdAt: cart.createdAt,
        updatedAt: cart.updatedAt,
      })
      .onConflictDoUpdate({
        target: carts.id,
        set: {
          customerId: cart.customerId,
          sessionId: cart.sessionId,
          status: cart.status,
          updatedAt: new Date().toISOString(),
        },
      });
  }

  /**
   *
   */
  async saveItem(item: CartItem): Promise<void> {
    await db
      .insert(cartItems)
      .values({
        id: item.id,
        cartId: item.cartId,
        productVariantId: item.productVariantId,
        quantity: item.quantity,
        unitPriceSnapshot: item.unitPriceSnapshot,
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
      })
      .onConflictDoUpdate({
        target: cartItems.id,
        set: {
          quantity: item.quantity,
          unitPriceSnapshot: item.unitPriceSnapshot,
          updatedAt: new Date().toISOString(),
        },
      });
  }

  /**
   *
   */
  async deleteItem(id: string): Promise<void> {
    await db.delete(cartItems).where(eq(cartItems.id, id));
  }

  /**
   *
   */
  async deleteItemsByCartId(cartId: string): Promise<void> {
    await db.delete(cartItems).where(eq(cartItems.cartId, cartId));
  }

  /**
   *
   */
  async findCartByItemId(itemId: string): Promise<Cart | null> {
    const [row] = await db.select().from(cartItems).where(eq(cartItems.id, itemId)).limit(1);
    if (!row) return null;
    return this.findById(row.cartId);
  }

  /**
   *
   */
  async findActiveCartByVariantId(variantId: string): Promise<Cart | null> {
    const [row] = await db
      .select({ cartId: cartItems.cartId })
      .from(cartItems)
      .innerJoin(carts, eq(cartItems.cartId, carts.id))
      .where(and(eq(cartItems.productVariantId, variantId), eq(carts.status, "active")))
      .limit(1);

    if (!row) return null;
    return this.findById(row.cartId);
  }
}
