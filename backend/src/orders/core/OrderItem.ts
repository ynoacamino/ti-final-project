/**
 * Represents an OrderItem domain entity.
 * Keeps an immutable snapshot of the product and variant details at the time of purchase.
 */
export class OrderItem {
  /**
   *
   */
  constructor(
    public readonly id: string,
    public readonly orderId: string,
    public readonly productVariantId: string,
    public readonly productNameSnapshot: string,
    public readonly variantDetailsSnapshot: string, // JSON text containing {size, color, sku}
    public readonly quantity: number,
    public readonly unitPrice: number, // in cents
    public readonly subtotal: number, // in cents
    public readonly createdAt: string,
  ) {}

  /**
   *
   */
  public static create(params: {
    id: string;
    orderId: string;
    productVariantId: string;
    productNameSnapshot: string;
    variantDetailsSnapshot: string;
    quantity: number;
    unitPrice: number;
    subtotal?: number;
    createdAt?: string;
  }): OrderItem {
    return new OrderItem(
      params.id,
      params.orderId,
      params.productVariantId,
      params.productNameSnapshot,
      params.variantDetailsSnapshot,
      params.quantity,
      params.unitPrice,
      params.subtotal ?? params.quantity * params.unitPrice,
      params.createdAt ?? new Date().toISOString(),
    );
  }
}
