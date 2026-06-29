import { Hono } from "hono";
import { authRouter } from "./auth/adapters/AuthController.ts";

const app = new Hono();

// Health check endpoint
app.get("/api/health", (c) => {
  return c.json({ status: "ok" });
});

// Register routes
app.route("/api/auth", authRouter);

export default {
  port: process.env.PORT || 3000,
  fetch: app.fetch,
};
