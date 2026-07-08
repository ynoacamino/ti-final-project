import type { StockMovement } from "../../core/StockMovement.ts";
import type { StockAlert } from "../../core/StockAlert.ts";

export interface IInventoryRepository {
  saveMovement(movement: StockMovement): Promise<void>;
  saveAlert(alert: StockAlert): Promise<void>;
  findActiveAlertByVariantId(variantId: string): Promise<StockAlert | null>;
  listAlerts(status?: "active" | "resolved"): Promise<StockAlert[]>;
}
