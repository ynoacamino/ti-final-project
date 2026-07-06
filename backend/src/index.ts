import { Hono } from "hono";
import { authRouter } from "./auth/adapters/AuthController.ts";
import { catalogRouter } from "./catalog/adapters/CatalogController.ts";
import { cartRouter } from "./cart/adapters/CartController.ts";
import { ordersRouter } from "./orders/adapters/OrdersController.ts";
import { dashboardRouter } from "./dashboard/adapters/DashboardController.ts";
import { inventoryRouter } from "./inventory/adapters/InventoryController.ts";

export const app = new Hono();

if (typeof Bun !== "undefined") {
  // @ts-ignore
  const { serveStatic } = await import("hono/bun");
  app.use("/uploads/*", serveStatic({ root: "./public" }));
}

// Health check endpoint
app.get("/api/health", (c) => {
  return c.json({ status: "ok" });
});

// Register routers
app.route("/api/auth", authRouter);
app.route("/api/cart", cartRouter);
app.route("/api/dashboard", dashboardRouter);
app.route("/api/inventory", inventoryRouter);
app.route("/api", catalogRouter);
app.route("/api", ordersRouter);

export default {
  port: process.env.PORT || 3000,
  fetch: app.fetch,
};
