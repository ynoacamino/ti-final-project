import { Hono } from "hono";
import { z } from "zod";
import { jwtVerify } from "jose";
import { AddToCartUseCase } from "../core/AddToCartUseCase.ts";
import { UpdateCartItemUseCase } from "../core/UpdateCartItemUseCase.ts";
import { RemoveFromCartUseCase } from "../core/RemoveFromCartUseCase.ts";
import { SqliteCartRepo } from "./SqliteCartRepo.ts";
import { SqliteProductRepo } from "../../catalog/adapters/SqliteProductRepo.ts";

export const cartRouter = new Hono();

// Repositories
const cartRepo = new SqliteCartRepo();
const productRepo = new SqliteProductRepo();

// Use Cases
const addToCartUseCase = new AddToCartUseCase(cartRepo, productRepo);
const updateCartItemUseCase = new UpdateCartItemUseCase(cartRepo, productRepo);
const removeFromCartUseCase = new RemoveFromCartUseCase(cartRepo);

// Helper to extract customer ID from JWT if present
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

// Validation schemas
const addToCartSchema = z.object({
  productVariantId: z.string().uuid("El id de la variante debe ser un UUID válido"),
  quantity: z.number().int().positive("La cantidad debe ser mayor a 0"),
  sessionId: z.string().optional(),
});

const updateCartItemSchema = z.object({
  quantity: z.number().int().positive("La cantidad debe ser mayor a 0"),
});

async function populateCartItems(items: any[]) {
  const populated = [];
  for (const item of items) {
    const variant = await productRepo.findVariantById(item.productVariantId);
    if (variant) {
      const product = await productRepo.findById(variant.productId);
      populated.push({
        id: item.id,
        cartId: item.cartId,
        productVariantId: item.productVariantId,
        quantity: item.quantity,
        unitPriceSnapshot: item.unitPriceSnapshot,
        createdAt: item.createdAt,
        updatedAt: item.updatedAt,
        productName: product?.name || "Prenda",
        size: variant.size,
        color: variant.color,
        sku: variant.sku,
        imageUrl: product?.images?.[0]?.url || "",
      });
    } else {
      populated.push(item);
    }
  }
  return populated;
}

/**
 * 1. Get Cart
 * GET /api/cart?session_id=xxx
 */
cartRouter.get("/", async (c) => {
  try {
    const customerId = await getCustomerId(c.req.header("Authorization"));
    const sessionId = c.req.query("session_id");

    let cart;
    if (customerId) {
      cart = await cartRepo.findActiveByCustomerId(customerId);
    } else if (sessionId) {
      cart = await cartRepo.findActiveBySessionId(sessionId);
    } else {
      return c.json({ success: false, error: "Debe proveer autenticación o session_id" }, 400);
    }

    if (!cart) {
      // Return empty cart DTO instead of 404, simplifies frontend
      return c.json({
        success: true,
        cart: {
          id: "",
          customerId: customerId || null,
          sessionId: sessionId || null,
          status: "active",
          items: [],
          subtotal: 0,
        },
      });
    }

    return c.json({
      success: true,
      cart: {
        id: cart.id,
        customerId: cart.customerId,
        sessionId: cart.sessionId,
        status: cart.status,
        items: await populateCartItems(cart.items),
        subtotal: cart.getSubtotal(),
      },
    });
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 500);
  }
});

/**
 * 2. Add Item to Cart
 * POST /api/cart/items
 */
cartRouter.post("/items", async (c) => {
  try {
    const customerId = await getCustomerId(c.req.header("Authorization"));
    const body = await c.req.json().catch(() => ({}));
    const validation = addToCartSchema.safeParse(body);

    if (!validation.success) {
      return c.json({ success: false, errors: validation.error.flatten().fieldErrors }, 400);
    }

    const { productVariantId, quantity, sessionId } = validation.data;

    if (!customerId && !sessionId) {
      return c.json(
        { success: false, error: "Debe iniciar sesión o proveer un session_id de invitado" },
        400,
      );
    }

    const cart = await addToCartUseCase.execute({
      customerId,
      sessionId,
      productVariantId,
      quantity,
    });

    return c.json(
      {
        success: true,
        cart: {
          id: cart.id,
          customerId: cart.customerId,
          sessionId: cart.sessionId,
          status: cart.status,
          items: await populateCartItems(cart.items),
          subtotal: cart.getSubtotal(),
        },
      },
      201,
    );
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 400);
  }
});

/**
 * 3. Update Cart Item Quantity
 * PATCH /api/cart/items/:id
 */
cartRouter.patch("/items/:id", async (c) => {
  try {
    const cartItemId = c.req.param("id");
    const body = await c.req.json().catch(() => ({}));
    const validation = updateCartItemSchema.safeParse(body);

    if (!validation.success) {
      return c.json({ success: false, errors: validation.error.flatten().fieldErrors }, 400);
    }

    const cart = await updateCartItemUseCase.execute({
      cartItemId,
      quantity: validation.data.quantity,
    });

    return c.json({
      success: true,
      cart: {
        id: cart.id,
        customerId: cart.customerId,
        sessionId: cart.sessionId,
        status: cart.status,
        items: await populateCartItems(cart.items),
        subtotal: cart.getSubtotal(),
      },
    });
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 400);
  }
});

/**
 * 4. Remove Item from Cart
 * DELETE /api/cart/items/:id
 */
cartRouter.delete("/items/:id", async (c) => {
  try {
    const cartItemId = c.req.param("id");
    const cart = await removeFromCartUseCase.execute({ cartItemId });

    return c.json({
      success: true,
      cart: {
        id: cart.id,
        customerId: cart.customerId,
        sessionId: cart.sessionId,
        status: cart.status,
        items: await populateCartItems(cart.items),
        subtotal: cart.getSubtotal(),
      },
    });
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 400);
  }
});
