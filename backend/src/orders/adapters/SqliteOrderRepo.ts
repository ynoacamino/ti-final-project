import type { IOrderRepository, ListOrdersParams } from "../ports/out/IOrderRepository.ts";
import { Order } from "../core/Order.ts";
import { OrderItem } from "../core/OrderItem.ts";
import { Payment } from "../core/Payment.ts";
import { db } from "../../shared/infrastructure/database/client.ts";
import { orders, orderItems, payments } from "../../shared/infrastructure/database/schema.ts";
import { eq, and, sql, inArray } from "drizzle-orm";

/**
 *
 */
export class SqliteOrderRepo implements IOrderRepository {
  private toDomain(
    row: typeof orders.$inferSelect,
    itemRows: Array<typeof orderItems.$inferSelect>,
    paymentRows: Array<typeof payments.$inferSelect>,
  ): Order {
    const items = itemRows.map(
      (item) =>
        new OrderItem(
          item.id,
          item.orderId,
          item.productVariantId,
          item.productNameSnapshot,
          item.variantDetailsSnapshot,
          item.quantity,
          item.unitPrice,
          item.subtotal,
          item.createdAt,
        ),
    );

    const payList = paymentRows.map(
      (p) =>
        new Payment(
          p.id,
          p.orderId,
          p.amount,
          p.currency,
          p.status as "pending" | "succeeded" | "failed" | "refunded",
          p.method as "card" | "yape" | "plin" | "cash",
          p.stripeChargeId,
          p.stripePaymentIntentId,
          p.errorMessage,
          p.createdAt,
          p.updatedAt,
        ),
    );

    return new Order(
      row.id,
      row.customerId,
      row.guestEmail,
      row.guestName,
      row.guestPhone,
      row.shippingAddress,
      row.subtotal,
      row.total,
      row.currency,
      row.status as any,
      row.stripePaymentIntentId,
      row.notes,
      row.createdAt,
      row.updatedAt,
      items,
      payList,
    );
  }

  /**
   *
   */
  async findById(id: string): Promise<Order | null> {
    const [row] = await db.select().from(orders).where(eq(orders.id, id)).limit(1);
    if (!row) return null;

    const itemRows = await db.select().from(orderItems).where(eq(orderItems.orderId, id));
    const paymentRows = await db.select().from(payments).where(eq(payments.orderId, id));

    return this.toDomain(row, itemRows, paymentRows);
  }

  /**
   *
   */
  async findByPaymentIntentId(paymentIntentId: string): Promise<Order | null> {
    const [row] = await db
      .select()
      .from(orders)
      .where(eq(orders.stripePaymentIntentId, paymentIntentId))
      .limit(1);

    if (!row) return null;

    const itemRows = await db.select().from(orderItems).where(eq(orderItems.orderId, row.id));
    const paymentRows = await db.select().from(payments).where(eq(payments.orderId, row.id));

    return this.toDomain(row, itemRows, paymentRows);
  }

  /**
   *
   */
  async save(order: Order): Promise<void> {
    await db.transaction(async (tx) => {
      // 1. Insert/Update Order
      await tx
        .insert(orders)
        .values({
          id: order.id,
          customerId: order.customerId,
          guestEmail: order.guestEmail,
          guestName: order.guestName,
          guestPhone: order.guestPhone,
          shippingAddress: order.shippingAddress,
          subtotal: order.subtotal,
          total: order.total,
          currency: order.currency,
          status: order.status,
          stripePaymentIntentId: order.stripePaymentIntentId,
          notes: order.notes,
          createdAt: order.createdAt,
          updatedAt: order.updatedAt,
        })
        .onConflictDoUpdate({
          target: orders.id,
          set: {
            status: order.status,
            updatedAt: new Date().toISOString(),
          },
        });

      // 2. Insert order items
      for (const item of order.items) {
        await tx
          .insert(orderItems)
          .values({
            id: item.id,
            orderId: item.orderId,
            productVariantId: item.productVariantId,
            productNameSnapshot: item.productNameSnapshot,
            variantDetailsSnapshot: item.variantDetailsSnapshot,
            quantity: item.quantity,
            unitPrice: item.unitPrice,
            subtotal: item.subtotal,
            createdAt: item.createdAt,
          })
          .onConflictDoNothing(); // OrderItems are immutable, insert once
      }
    });
  }

  /**
   *
   */
  async savePayment(payment: Payment): Promise<void> {
    await db
      .insert(payments)
      .values({
        id: payment.id,
        orderId: payment.orderId,
        amount: payment.amount,
        currency: payment.currency,
        status: payment.status,
        method: payment.method,
        stripeChargeId: payment.stripeChargeId,
        stripePaymentIntentId: payment.stripePaymentIntentId,
        errorMessage: payment.errorMessage,
        createdAt: payment.createdAt,
        updatedAt: payment.updatedAt,
      })
      .onConflictDoUpdate({
        target: payments.id,
        set: {
          status: payment.status,
          stripeChargeId: payment.stripeChargeId,
          errorMessage: payment.errorMessage,
          updatedAt: new Date().toISOString(),
        },
      });
  }

  /**
   *
   */
  async list(params: ListOrdersParams): Promise<{ orders: Order[]; total: number }> {
    const limit = params.limit ?? 10;
    const offset = params.offset ?? 0;

    const conditions = [];
    if (params.customerId) {
      conditions.push(eq(orders.customerId, params.customerId));
    }
    if (params.status) {
      conditions.push(eq(orders.status, params.status));
    }

    const whereClause = conditions.length > 0 ? and(...conditions) : undefined;

    // Get total count
    const [countRow] = await db
      .select({ count: sql`count(*)` })
      .from(orders)
      .where(whereClause);
    const total = Number(countRow?.count || 0);

    if (total === 0) {
      return { orders: [], total: 0 };
    }

    // Get orders list
    const orderRows = await db
      .select()
      .from(orders)
      .where(whereClause)
      .limit(limit)
      .offset(offset)
      .orderBy(sql`${orders.createdAt} DESC`);

    const orderIds = orderRows.map((o) => o.id);

    // Batch load items and payments
    const itemRows = await db
      .select()
      .from(orderItems)
      .where(inArray(orderItems.orderId, orderIds));

    const paymentRows = await db.select().from(payments).where(inArray(payments.orderId, orderIds));

    const mappedOrders = orderRows.map((row) => {
      const oItems = itemRows.filter((i) => i.orderId === row.id);
      const oPayments = paymentRows.filter((p) => p.orderId === row.id);
      return this.toDomain(row, oItems, oPayments);
    });

    return {
      orders: mappedOrders,
      total,
    };
  }
}
