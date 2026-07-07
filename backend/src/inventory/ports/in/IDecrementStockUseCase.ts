export interface DecrementStockDTO {
  productVariantId: string;
  quantity: number; // positive number representing quantity to reduce
  referenceType: "order" | "manual";
  referenceId: string;
  createdBy?: string;
}

export interface IDecrementStockUseCase {
  /**
   * Decrements stock for a specific variant, logs the movement,
   * and generates a stock alert if stock falls below the threshold (5 units).
   */
  execute(dto: DecrementStockDTO): Promise<void>;
}
