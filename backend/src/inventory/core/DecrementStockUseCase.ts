import type {
  IDecrementStockUseCase,
  DecrementStockDTO,
} from "../ports/in/IDecrementStockUseCase.ts";
import type { IInventoryRepository } from "../ports/out/IInventoryRepository.ts";
import type { IProductRepository } from "../../catalog/ports/out/IProductRepository.ts";
import { StockMovement } from "./StockMovement.ts";
import { StockAlert } from "./StockAlert.ts";

/**
 *
 */
export class DecrementStockUseCase implements IDecrementStockUseCase {
  /**
   *
   */
  constructor(
    private readonly productRepository: IProductRepository,
    private readonly inventoryRepository: IInventoryRepository,
  ) {}

  /**
   *
   */
  async execute(dto: DecrementStockDTO): Promise<void> {
    if (dto.quantity <= 0) {
      throw new Error("Quantity to decrement must be greater than 0");
    }

    const variant = await this.productRepository.findVariantById(dto.productVariantId);
    if (!variant) {
      throw new Error("Product variant not found");
    }

    const previousStock = variant.stock;
    const newStock = previousStock - dto.quantity;

    if (newStock < 0) {
      throw new Error(
        `Insuficient stock for variant: ${previousStock} available, requested ${dto.quantity}`,
      );
    }

    // 1. Update stock in database
    await this.productRepository.updateVariantStock(dto.productVariantId, newStock);

    // 2. Log movement (negative quantity since it is a reduction)
    const movement = StockMovement.create({
      id: crypto.randomUUID(),
      productVariantId: dto.productVariantId,
      type: "sale",
      quantity: -dto.quantity,
      previousStock,
      newStock,
      referenceType: dto.referenceType,
      referenceId: dto.referenceId,
      createdBy: dto.createdBy,
    });

    await this.inventoryRepository.saveMovement(movement);

    // 3. Low stock alert logic (default threshold is 5 units)
    const threshold = 5;
    if (newStock < threshold) {
      const activeAlert = await this.inventoryRepository.findActiveAlertByVariantId(
        dto.productVariantId,
      );

      if (!activeAlert) {
        const newAlert = StockAlert.create({
          id: crypto.randomUUID(),
          productVariantId: dto.productVariantId,
          threshold,
          currentStock: newStock,
          status: "active",
        });
        await this.inventoryRepository.saveAlert(newAlert);
      } else {
        // Update current stock in existing alert
        const updatedAlert = StockAlert.create({
          ...activeAlert,
          currentStock: newStock,
        });
        await this.inventoryRepository.saveAlert(updatedAlert);
      }
    }
  }
}
