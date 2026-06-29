import { Hono } from "hono";
import { db } from "../../shared/infrastructure/database/client.ts";
import {
  orders,
  orderItems,
  productVariants,
} from "../../shared/infrastructure/database/schema.ts";
import { eq, sql } from "drizzle-orm";
import { authMiddleware } from "../../shared/infrastructure/middleware/auth.ts";

export const dashboardRouter = new Hono();

// Secure all dashboard endpoints for admin users
dashboardRouter.use("*", authMiddleware(["admin"]));

/**
 * 1. Summary Metrics
 * GET /api/dashboard/metrics
 */
dashboardRouter.get("/metrics", async (c) => {
  try {
    // Total Sales & Average Ticket from paid/enviado/entregado orders
    const [salesRow] = await db
      .select({
        totalSales: sql`sum(${orders.total})`,
        count: sql`count(*)`,
        avgTicket: sql`avg(${orders.total})`,
      })
      .from(orders)
      .where(sql`${orders.status} IN ('pagado', 'enviado', 'entregado')`);

    // Low stock count (stock < 5)
    const [lowStockRow] = await db
      .select({ count: sql`count(*)` })
      .from(productVariants)
      .where(sql`${productVariants.stock} < 5`);

    return c.json({
      success: true,
      metrics: {
        totalSales: Number(salesRow?.totalSales || 0),
        orderCount: Number(salesRow?.count || 0),
        averageTicket: Math.round(Number(salesRow?.avgTicket || 0)),
        lowStockCount: Number(lowStockRow?.count || 0),
      },
    });
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 500);
  }
});

/**
 * 2. Top-Selling Products
 * GET /api/dashboard/top-products
 */
dashboardRouter.get("/top-products", async (c) => {
  try {
    // Join order_items with orders and product_variants to get top sales
    const list = await db
      .select({
        productId: productVariants.productId,
        productName: orderItems.productNameSnapshot,
        totalQuantity: sql`sum(${orderItems.quantity})`,
        revenue: sql`sum(${orderItems.subtotal})`,
      })
      .from(orderItems)
      .innerJoin(orders, eq(orderItems.orderId, orders.id))
      .innerJoin(productVariants, eq(orderItems.productVariantId, productVariants.id))
      .where(sql`${orders.status} IN ('pagado', 'enviado', 'entregado')`)
      .groupBy(productVariants.productId, orderItems.productNameSnapshot)
      .orderBy(sql`sum(${orderItems.quantity}) DESC`)
      .limit(5);

    const formatted = list.map((item) => ({
      productId: item.productId,
      productName: item.productName,
      totalQuantity: Number(item.totalQuantity || 0),
      revenue: Number(item.revenue || 0),
    }));

    return c.json({ success: true, topProducts: formatted });
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 500);
  }
});

/**
 * 3. Orders By Status Distribution
 * GET /api/dashboard/orders-by-status
 */
dashboardRouter.get("/orders-by-status", async (c) => {
  try {
    const list = await db
      .select({
        status: orders.status,
        count: sql`count(*)`,
      })
      .from(orders)
      .groupBy(orders.status);

    const result: Record<string, number> = {
      pendiente: 0,
      pagado: 0,
      enviado: 0,
      entregado: 0,
      cancelado: 0,
      fallido: 0,
    };

    for (const item of list) {
      if (item.status && item.status in result) {
        result[item.status] = Number(item.count || 0);
      }
    }

    return c.json({ success: true, statusDistribution: result });
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 500);
  }
});

/**
 * 4. Sales Timeline Series
 * GET /api/dashboard/sales-timeline
 */
dashboardRouter.get("/sales-timeline", async (c) => {
  try {
    const interval = c.req.query("interval") || "daily"; // daily, weekly, monthly

    // Grouping string based on SQLite date formatting
    let dateGroup = sql`strftime('%Y-%m-%d', ${orders.createdAt})`;
    if (interval === "monthly") {
      dateGroup = sql`strftime('%Y-%m', ${orders.createdAt})`;
    } else if (interval === "weekly") {
      // Grouping by year and week number
      dateGroup = sql`strftime('%Y-W%W', ${orders.createdAt})`;
    }

    const list = await db
      .select({
        period: dateGroup,
        revenue: sql`sum(${orders.total})`,
        count: sql`count(*)`,
      })
      .from(orders)
      .where(sql`${orders.status} IN ('pagado', 'enviado', 'entregado')`)
      .groupBy(dateGroup)
      .orderBy(dateGroup);

    const formatted = list.map((item) => ({
      period: item.period,
      revenue: Number(item.revenue || 0),
      count: Number(item.count || 0),
    }));

    return c.json({ success: true, timeline: formatted });
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 500);
  }
});
