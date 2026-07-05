/**
 * Represents a StockMovement domain entity.
 * Keeps an audit log of all changes to a variant's inventory level.
 */
export class StockMovement {
  /**
   *
   */
  constructor(
    public readonly id: string,
    public readonly productVariantId: string,
    public readonly type: "sale" | "restock" | "adjustment" | "cancellation",
    public readonly quantity: number, // positive for additions, negative for reductions
    public readonly previousStock: number,
    public readonly newStock: number,
    public readonly referenceType: "order" | "manual" | "restock" | null,
    public readonly referenceId: string | null,
    public readonly notes: string | null,
    public readonly createdAt: string,
    public readonly createdBy: string | null,
  ) {}

  /**
   *
   */
  public static create(params: {
    id: string;
    productVariantId: string;
    type: "sale" | "restock" | "adjustment" | "cancellation";
    quantity: number;
    previousStock: number;
    newStock: number;
    referenceType?: "order" | "manual" | "restock" | null;
    referenceId?: string | null;
    notes?: string | null;
    createdAt?: string;
    createdBy?: string | null;
  }): StockMovement {
    return new StockMovement(
      params.id,
      params.productVariantId,
      params.type,
      params.quantity,
      params.previousStock,
      params.newStock,
      params.referenceType ?? null,
      params.referenceId ?? null,
      params.notes ?? null,
      params.createdAt ?? new Date().toISOString(),
      params.createdBy ?? null,
    );
  }
}
