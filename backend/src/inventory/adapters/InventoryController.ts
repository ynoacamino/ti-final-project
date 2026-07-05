import { Hono } from "hono";
import { z } from "zod";
import { SqliteInventoryRepo } from "./SqliteInventoryRepo.ts";
import { SqliteProductRepo } from "../../catalog/adapters/SqliteProductRepo.ts";
import { authMiddleware } from "../../shared/infrastructure/middleware/auth.ts";
import { StockAlert } from "../core/StockAlert.ts";
import { StockMovement } from "../core/StockMovement.ts";

export const inventoryRouter = new Hono();

const inventoryRepo = new SqliteInventoryRepo();
const productRepo = new SqliteProductRepo();

// Secure all inventory endpoints for admins
inventoryRouter.use("*", authMiddleware(["admin"]));

const restockSchema = z.object({
  productVariantId: z.string().uuid("El id de la variante debe ser un UUID válido"),
  quantity: z.number().int().positive("La cantidad a reabastecer debe ser mayor a 0"),
  notes: z.string().optional(),
});

/**
 * 1. Get Active Low Stock Alerts
 * GET /api/inventory/alerts
 */
inventoryRouter.get("/alerts", async (c) => {
  try {
    const alerts = await inventoryRepo.listAlerts("active");
    return c.json({ success: true, alerts });
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 500);
  }
});

/**
 * 2. Restock Product Variant (resolves alert if stock is 5 or more)
 * POST /api/inventory/restock
 */
inventoryRouter.post("/restock", async (c) => {
  try {
    const body = await c.req.json().catch(() => ({}));
    const validation = restockSchema.safeParse(body);

    if (!validation.success) {
      return c.json({ success: false, errors: validation.error.flatten().fieldErrors }, 400);
    }

    const { productVariantId, quantity, notes } = validation.data;

    // Fetch variant
    const variant = await productRepo.findVariantById(productVariantId);
    if (!variant) {
      return c.json({ success: false, error: "Product variant not found" }, 404);
    }

    const previousStock = variant.stock;
    const newStock = previousStock + quantity;

    // Update variant stock in db
    await productRepo.updateVariantStock(productVariantId, newStock);

    // Save StockMovement
    const movement = StockMovement.create({
      id: crypto.randomUUID(),
      productVariantId,
      type: "restock",
      quantity,
      previousStock,
      newStock,
      referenceType: "restock",
      notes: notes || "Manual restock",
      createdBy: c.get("user")?.id || null,
    });
    await inventoryRepo.saveMovement(movement);

    // If new stock is >= 5, resolve active alert
    if (newStock >= 5) {
      const activeAlert = await inventoryRepo.findActiveAlertByVariantId(productVariantId);
      if (activeAlert) {
        const resolvedAlert = StockAlert.create({
          ...activeAlert,
          status: "resolved",
          resolvedAt: new Date().toISOString(),
        });
        await inventoryRepo.saveAlert(resolvedAlert);
      }
    }

    return c.json({
      success: true,
      message: `Restocked ${quantity} units successfully. New stock: ${newStock}`,
    });
  } catch (error: any) {
    return c.json({ success: false, error: error.message }, 400);
  }
});
