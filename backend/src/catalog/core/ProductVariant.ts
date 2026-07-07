/**
 * Represents a ProductVariant domain entity.
 * Defines specific inventory item configurations based on size and color.
 */
export class ProductVariant {
  /**
   *
   */
  constructor(
    public readonly id: string,
    public readonly productId: string,
    public readonly size: string,
    public readonly color: string,
    public readonly sku: string,
    public readonly stock: number,
    public readonly additionalPrice: number, // in cents
    public readonly createdAt: string,
    public readonly updatedAt: string,
  ) {}

  /**
   *
   */
  public static create(params: {
    id: string;
    productId: string;
    size: string;
    color: string;
    sku: string;
    stock?: number;
    additionalPrice?: number;
    createdAt?: string;
    updatedAt?: string;
  }): ProductVariant {
    const now = new Date().toISOString();
    return new ProductVariant(
      params.id,
      params.productId,
      params.size,
      params.color,
      params.sku,
      params.stock ?? 0,
      params.additionalPrice ?? 0,
      params.createdAt ?? now,
      params.updatedAt ?? now,
    );
  }
}
