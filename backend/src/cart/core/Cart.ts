import type { CartItem } from "./CartItem.ts";

/**
 * Represents a Cart domain entity.
 */
export class Cart {
  constructor(
    public readonly id: string,
    public readonly customerId: string | null,
    public readonly sessionId: string | null,
    public readonly status: "active" | "abandoned" | "converted",
    public readonly createdAt: string,
    public readonly updatedAt: string,
    public readonly items: CartItem[] = [],
  ) {}

  public static create(params: {
    id: string;
    customerId?: string | null;
    sessionId?: string | null;
    status?: "active" | "abandoned" | "converted";
    createdAt?: string;
    updatedAt?: string;
    items?: CartItem[];
  }): Cart {
    const now = new Date().toISOString();
    return new Cart(
      params.id,
      params.customerId ?? null,
      params.sessionId ?? null,
      params.status ?? "active",
      params.createdAt ?? now,
      params.updatedAt ?? now,
      params.items ?? [],
    );
  }

  /**
   * Calculates subtotal of the cart.
   *
   * @returns Total amount in cents
   */
  public getSubtotal(): number {
    return this.items.reduce((sum, item) => sum + item.quantity * item.unitPriceSnapshot, 0);
  }
}
