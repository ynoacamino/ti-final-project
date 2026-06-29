import type { IInventoryRepository } from "../ports/out/IInventoryRepository.ts";
import { StockMovement } from "../core/StockMovement.ts";
import { StockAlert } from "../core/StockAlert.ts";
import { db } from "../../shared/infrastructure/database/client.ts";
import { stockMovements, stockAlerts } from "../../shared/infrastructure/database/schema.ts";
import { eq, and } from "drizzle-orm";

export class SqliteInventoryRepo implements IInventoryRepository {
  private toDomainMovement(row: typeof stockMovements.$inferSelect): StockMovement {
    return new StockMovement(
      row.id,
      row.productVariantId,
      row.type as any,
      row.quantity,
      row.previousStock,
      row.newStock,
      row.referenceType as any,
      row.referenceId,
      row.notes,
      row.createdAt,
      row.createdBy,
    );
  }

  private toDomainAlert(row: typeof stockAlerts.$inferSelect): StockAlert {
    return new StockAlert(
      row.id,
      row.productVariantId,
      row.threshold,
      row.currentStock,
      row.status as "active" | "resolved",
      row.createdAt,
      row.resolvedAt,
    );
  }

  async saveMovement(movement: StockMovement): Promise<void> {
    await db.insert(stockMovements).values({
      id: movement.id,
      productVariantId: movement.productVariantId,
      type: movement.type,
      quantity: movement.quantity,
      previousStock: movement.previousStock,
      newStock: movement.newStock,
      referenceType: movement.referenceType,
      referenceId: movement.referenceId,
      notes: movement.notes,
      createdAt: movement.createdAt,
      createdBy: movement.createdBy,
    });
  }

  async saveAlert(alert: StockAlert): Promise<void> {
    await db
      .insert(stockAlerts)
      .values({
        id: alert.id,
        productVariantId: alert.productVariantId,
        threshold: alert.threshold,
        currentStock: alert.currentStock,
        status: alert.status,
        createdAt: alert.createdAt,
        resolvedAt: alert.resolvedAt,
      })
      .onConflictDoUpdate({
        target: stockAlerts.id,
        set: {
          currentStock: alert.currentStock,
          status: alert.status,
          resolvedAt: alert.resolvedAt,
        },
      });
  }

  async findActiveAlertByVariantId(variantId: string): Promise<StockAlert | null> {
    const [row] = await db
      .select()
      .from(stockAlerts)
      .where(and(eq(stockAlerts.productVariantId, variantId), eq(stockAlerts.status, "active")))
      .limit(1);

    if (!row) return null;
    return this.toDomainAlert(row);
  }

  async listAlerts(status?: "active" | "resolved"): Promise<StockAlert[]> {
    const conditions = [];
    if (status) {
      conditions.push(eq(stockAlerts.status, status));
    }

    const whereClause = conditions.length > 0 ? and(...conditions) : undefined;
    const rows = await db.select().from(stockAlerts).where(whereClause);

    return rows.map((r) => this.toDomainAlert(r));
  }
}
