/**
 * Represents a ProductImage domain entity.
 */
export class ProductImage {
  constructor(
    public readonly id: string,
    public readonly productId: string,
    public readonly url: string,
    public readonly position: number,
    public readonly createdAt: string,
  ) {}

  public static create(params: {
    id: string;
    productId: string;
    url: string;
    position?: number;
    createdAt?: string;
  }): ProductImage {
    return new ProductImage(
      params.id,
      params.productId,
      params.url,
      params.position ?? 0,
      params.createdAt ?? new Date().toISOString(),
    );
  }
}
