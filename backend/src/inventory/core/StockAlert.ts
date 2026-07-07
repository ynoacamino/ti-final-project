/**
 * Represents a StockAlert domain entity.
 */
export class StockAlert {
  /**
   *
   */
  constructor(
    public readonly id: string,
    public readonly productVariantId: string,
    public readonly threshold: number,
    public readonly currentStock: number,
    public readonly status: "active" | "resolved",
    public readonly createdAt: string,
    public readonly resolvedAt: string | null,
  ) {}

  /**
   *
   */
  public static create(params: {
    id: string;
    productVariantId: string;
    threshold: number;
    currentStock: number;
    status?: "active" | "resolved";
    createdAt?: string;
    resolvedAt?: string | null;
  }): StockAlert {
    return new StockAlert(
      params.id,
      params.productVariantId,
      params.threshold,
      params.currentStock,
      params.status ?? "active",
      params.createdAt ?? new Date().toISOString(),
      params.resolvedAt ?? null,
    );
  }
}
