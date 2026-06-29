/**
 * Represents a Payment domain entity.
 */
export class Payment {
  constructor(
    public readonly id: string,
    public readonly orderId: string,
    public readonly amount: number, // in cents
    public readonly currency: string,
    public readonly status: "pending" | "succeeded" | "failed" | "refunded",
    public readonly method: "card" | "yape" | "plin" | "cash",
    public readonly stripeChargeId: string | null,
    public readonly stripePaymentIntentId: string | null,
    public readonly errorMessage: string | null,
    public readonly createdAt: string,
    public readonly updatedAt: string,
  ) {}

  public static create(params: {
    id: string;
    orderId: string;
    amount: number;
    currency?: string;
    status: "pending" | "succeeded" | "failed" | "refunded";
    method?: "card" | "yape" | "plin" | "cash";
    stripeChargeId?: string | null;
    stripePaymentIntentId?: string | null;
    errorMessage?: string | null;
    createdAt?: string;
    updatedAt?: string;
  }): Payment {
    const now = new Date().toISOString();
    return new Payment(
      params.id,
      params.orderId,
      params.amount,
      params.currency ?? "PEN",
      params.status,
      params.method ?? "card",
      params.stripeChargeId ?? null,
      params.stripePaymentIntentId ?? null,
      params.errorMessage ?? null,
      params.createdAt ?? now,
      params.updatedAt ?? now,
    );
  }
}
