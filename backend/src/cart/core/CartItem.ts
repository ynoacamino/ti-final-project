/**
 * Represents a CartItem domain entity.
 */
export class CartItem {
  constructor(
    public readonly id: string,
    public readonly cartId: string,
    public readonly productVariantId: string,
    public readonly quantity: number,
    public readonly unitPriceSnapshot: number, // in cents
    public readonly createdAt: string,
    public readonly updatedAt: string,
  ) {}

  public static create(params: {
    id: string;
    cartId: string;
    productVariantId: string;
    quantity: number;
    unitPriceSnapshot: number;
    createdAt?: string;
    updatedAt?: string;
  }): CartItem {
    const now = new Date().toISOString();
    return new CartItem(
      params.id,
      params.cartId,
      params.productVariantId,
      params.quantity,
      params.unitPriceSnapshot,
      params.createdAt ?? now,
      params.updatedAt ?? now,
    );
  }
}
