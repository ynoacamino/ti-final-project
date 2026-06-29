import { Hono } from "hono";
import { serveStatic } from "hono/bun";
import { authRouter } from "./auth/adapters/AuthController.ts";
import { catalogRouter } from "./catalog/adapters/CatalogController.ts";

const app = new Hono();

// Serve local static uploads if R2 fallback is used
app.use("/uploads/*", serveStatic({ root: "./public" }));

// Health check endpoint
app.get("/api/health", (c) => {
  return c.json({ status: "ok" });
});

// Register routers
app.route("/api/auth", authRouter);
app.route("/api", catalogRouter);

export default {
  port: process.env.PORT || 3000,
  fetch: app.fetch,
};
