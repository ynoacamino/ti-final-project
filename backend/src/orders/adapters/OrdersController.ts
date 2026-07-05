import { Hono } from "hono";
import { z } from "zod";
import Stripe from "stripe";
import { CreateCheckoutUseCase } from "../core/CreateCheckoutUseCase.ts";
import { ConfirmPaymentUseCase } from "../core/ConfirmPaymentUseCase.ts";
import { DecrementStockUseCase } from "../../inventory/core/DecrementStockUseCase.ts";
import { SqliteOrderRepo } from "./SqliteOrderRepo.ts";
import { SqliteCartRepo } from "../../cart/adapters/SqliteCartRepo.ts";
import { SqliteProductRepo } from "../../catalog/adapters/SqliteProductRepo.ts";
import { SqliteInventoryRepo } from "../../inventory/adapters/SqliteInventoryRepo.ts";
import { StripePaymentGateway } from "./StripePaymentGateway.ts";
import { authMiddleware } from "../../shared/infrastructure/middleware/auth.ts";
import { Order } from "../core/Order.ts";

export const ordersRouter = new Hono();

// Repositories & Gateways
const orderRepo = new SqliteOrderRepo();
const cartRepo = new SqliteCartRepo();
const productRepo = new SqliteProductRepo();
const inventoryRepo = new SqliteInventoryRepo();
const paymentGateway = new StripePaymentGateway();

// Sub-use cases
const decrementStockUseCase = new DecrementStockUseCase(productRepo, inventoryRepo);

// Main Use Cases
const createCheckoutUseCase = new CreateCheckoutUseCase(
  orderRepo,
  cartRepo,
  productRepo,
  paymentGateway,
);
const confirmPaymentUseCase = new ConfirmPaymentUseCase(
  orderRepo,
  cartRepo,
  paymentGateway,
  decrementStockUseCase,
);

// Zod schemas
const addressSchema = z.object({
  street: z.string().min(3, "La calle es obligatoria"),
  city: z.string().min(2, "La ciudad es obligatoria"),
  state: z.string().min(2, "El departamento/estado es obligatorio"),
  zip: z.string().min(3, "El código postal es obligatorio"),
  country: z.string().min(2, "El código de país de 2 letras es obligatorio"),
  references: z.string().optional(),
});

const checkoutSchema = z.object({
  cartId: z.string().uuid("El id del carrito debe ser un UUID válido"),
  guestEmail: z.string().email("Debe ser un correo válido").optional(),
  guestName: z.string().optional(),
  guestPhone: z.string().optional(),
  shippingAddress: addressSchema,
  notes: z.string().optional(),
});

const confirmSchema = z.object({
  stripePaymentIntentId: z.string().min(1, "El stripePaymentIntentId es obligatorio"),
});

const updateStatusSchema = z.object({
  status: z.enum(["pendiente", "pagado", "enviado", "entregado", "cancelado", "fallido"]),
});

// Helper: JWT authentication retrieval if optional
async function getCustomerId(authHeader?: string): Promise<string | undefined> {
  if (!authHeader || !authHeader.startsWith("Bearer ")) return undefined;
  try {
    const token = authHeader.substring(7);
    const secret = new TextEncoder().encode(
      process.env.JWT_SECRET || "supersecretjwtkey1234567890!",
    );
    const { payload } = await jwtVerify(token, secret);
    return payload.id as string;
  } catch {
    return undefined;
  }
}
import { jwtVerify } from "jose";

/**
 * 1. Checkout
 * POST /api/checkout
 */
ordersRouter.post("/checkout", async (c) => {
  try {
    const customerId = await getCustomerId(c.req.header("Authorization"));
    const body = await c.req.json().catch(() => ({}));
    const validation = checkoutSchema.safeParse(body);

    if (!validation.success) {
      return c.json({ success: false, errors: validation.error.flatten().fieldErrors }, 400);
    }

    const { cartId, guestEmail, guestName, guestPhone, shippingAddress, notes } = validation.data;

    if (!customerId && !guestEmail) {
      return c.json(
        { success: false, error: "Debe iniciar sesión o rellenar el correo de invitado" },
        400,
      );
    }

    const result = await createCheckoutUseCase.execute({
      cartId,
      customerId,
      guestEmail,
      guestName,
      guestPhone,
      shippingAddress,
      notes,
    });

    return c.json(
      {
        success: true,
        order: result.order,
        clientSecret: result.clientSecret,
      },
      201,
    );
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 400);
  }
});

/**
 * 2. Confirm Payment
 * POST /api/payments/confirm
 */
ordersRouter.post("/payments/confirm", async (c) => {
  try {
    const body = await c.req.json().catch(() => ({}));
    const validation = confirmSchema.safeParse(body);

    if (!validation.success) {
      return c.json({ success: false, errors: validation.error.flatten().fieldErrors }, 400);
    }

    const order = await confirmPaymentUseCase.execute(validation.data);
    return c.json({ success: true, order }, 200);
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 400);
  }
});

/**
 * 3. List Orders (Admin Only)
 * GET /api/orders
 */
ordersRouter.get("/orders", authMiddleware(["admin"]), async (c) => {
  try {
    const status = c.req.query("status");
    const limit = c.req.query("limit") ? parseInt(c.req.query("limit")!) : 10;
    const offset = c.req.query("offset") ? parseInt(c.req.query("offset")!) : 0;

    const result = await orderRepo.list({ status, limit, offset });
    return c.json({ success: true, ...result }, 200);
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 500);
  }
});

/**
 * 4. List Customer's own orders (Customer Only)
 * GET /api/customers/me/orders
 */
ordersRouter.get("/customers/me/orders", authMiddleware(["customer"]), async (c) => {
  try {
    const user = c.get("user");
    const limit = c.req.query("limit") ? parseInt(c.req.query("limit")!) : 10;
    const offset = c.req.query("offset") ? parseInt(c.req.query("offset")!) : 0;

    const result = await orderRepo.list({ customerId: user.id, limit, offset });
    return c.json({ success: true, ...result }, 200);
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 500);
  }
});

/**
 * 5. Get Order Details
 * GET /api/orders/:id
 */
ordersRouter.get("/orders/:id", async (c) => {
  try {
    const id = c.req.param("id");
    const order = await orderRepo.findById(id);
    if (!order) {
      return c.json({ success: false, error: "Order not found" }, 404);
    }

    // Security check: if not admin, verify ownership if it is customer
    const authHeader = c.req.header("Authorization");
    const customerId = await getCustomerId(authHeader);

    // We can also retrieve the payload to check if it's admin
    let isAdmin = false;
    if (authHeader && authHeader.startsWith("Bearer ")) {
      try {
        const token = authHeader.substring(7);
        const secret = new TextEncoder().encode(
          process.env.JWT_SECRET || "supersecretjwtkey1234567890!",
        );
        const { payload } = await jwtVerify(token, secret);
        isAdmin = payload.role === "admin";
      } catch {
        // ignore
      }
    }

    if (!isAdmin && order.customerId && order.customerId !== customerId) {
      return c.json({ success: false, error: "Forbidden: You do not own this order" }, 403);
    }

    return c.json({ success: true, order }, 200);
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 500);
  }
});

/**
 * 6. Update Order Status (Admin Only)
 * PATCH /api/orders/:id/status
 */
ordersRouter.patch("/orders/:id/status", authMiddleware(["admin"]), async (c) => {
  try {
    const id = c.req.param("id");
    const body = await c.req.json().catch(() => ({}));
    const validation = updateStatusSchema.safeParse(body);

    if (!validation.success) {
      return c.json({ success: false, errors: validation.error.flatten().fieldErrors }, 400);
    }

    const order = await orderRepo.findById(id);
    if (!order) {
      return c.json({ success: false, error: "Order not found" }, 404);
    }

    const currentStatus = order.status;
    const newStatus = validation.data.status;

    // Define allowed transitions sequential flow and cancellation checks
    const allowedTransitions: Record<string, string[]> = {
      pendiente: ["pagado", "cancelado", "fallido"],
      pagado: ["enviado", "cancelado"],
      enviado: ["entregado"],
      entregado: [],
      cancelado: [],
      fallido: [],
    };

    if (!allowedTransitions[currentStatus]?.includes(newStatus)) {
      return c.json(
        {
          success: false,
          error: `Transición de estado inválida: de '${currentStatus}' a '${newStatus}'`,
        },
        400,
      );
    }

    const updatedOrder = Order.create({
      ...order,
      status: newStatus,
      updatedAt: new Date().toISOString(),
    });

    await orderRepo.save(updatedOrder);

    // If order is cancelled, we should ideally restore the stock!
    if (newStatus === "cancelado" && currentStatus === "pagado") {
      // Re-increment stock
      for (const item of order.items) {
        // Restocking via update variant stock (which is inverse of decrement)
        const variant = await productRepo.findVariantById(item.productVariantId);
        if (variant) {
          const restoredStock = variant.stock + item.quantity;
          await productRepo.updateVariantStock(item.productVariantId, restoredStock);

          // Log stock movement
          const restoreMovement = {
            id: crypto.randomUUID(),
            productVariantId: item.productVariantId,
            type: "cancellation" as const,
            quantity: item.quantity,
            previousStock: variant.stock,
            newStock: restoredStock,
            referenceType: "order" as const,
            referenceId: order.id,
            notes: "Restocked due to order cancellation",
            createdAt: new Date().toISOString(),
            createdBy: c.get("user")?.id || null,
          };
          await inventoryRepo.saveMovement(restoreMovement);
        }
      }
    }

    return c.json({ success: true, order: updatedOrder }, 200);
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 400);
  }
});

/**
 * 7. Stripe Webhook handler
 * POST /api/payments/webhook
 */
ordersRouter.post("/payments/webhook", async (c) => {
  const stripeSecret = process.env.STRIPE_SECRET_KEY;
  const webhookSecret = process.env.STRIPE_WEBHOOK_SECRET;
  const signature = c.req.header("stripe-signature");

  if (!stripeSecret || stripeSecret === "sk_test_mock_key" || !webhookSecret || !signature) {
    try {
      const body = await c.req.json().catch(() => ({}));
      if (body.type === "payment_intent.succeeded") {
        const paymentIntentId = body.data?.object?.id;
        if (paymentIntentId) {
          await confirmPaymentUseCase.execute({ stripePaymentIntentId: paymentIntentId });
          return c.json({ received: true, mocked: true });
        }
      }
      return c.json({ received: true, message: "Mock webhook ignored or processed" });
    } catch (error: any) {
      return c.json({ error: error.message }, 400);
    }
  }

  try {
    const rawBody = await c.req.text();
    const stripe = new Stripe(stripeSecret, { apiVersion: "2023-10-16" as any });
    const event = stripe.webhooks.constructEvent(rawBody, signature, webhookSecret);

    if (event.type === "payment_intent.succeeded") {
      const paymentIntent = event.data.object as Stripe.PaymentIntent;
      await confirmPaymentUseCase.execute({ stripePaymentIntentId: paymentIntent.id });
    } else if (event.type === "payment_intent.payment_failed") {
      const paymentIntent = event.data.object as Stripe.PaymentIntent;
      try {
        await confirmPaymentUseCase.execute({ stripePaymentIntentId: paymentIntent.id });
      } catch {
        // expected to fail
      }
    }

    return c.json({ received: true });
  } catch (error: any) {
    return c.json({ error: `Webhook Error: ${error.message}` }, 400);
  }
});

