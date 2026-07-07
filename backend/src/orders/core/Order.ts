import type { OrderItem } from "./OrderItem.ts";
import type { Payment } from "./Payment.ts";

/**
 * Represents an Order domain entity.
 */
export class Order {
  /**
   *
   */
  constructor(
    public readonly id: string,
    public readonly customerId: string | null,
    public readonly guestEmail: string | null,
    public readonly guestName: string | null,
    public readonly guestPhone: string | null,
    public readonly shippingAddress: string | null, // JSON string
    public readonly subtotal: number, // in cents
    public readonly total: number, // in cents
    public readonly currency: string,
    public readonly status:
      "pendiente" | "pagado" | "enviado" | "entregado" | "cancelado" | "fallido",
    public readonly stripePaymentIntentId: string | null,
    public readonly notes: string | null,
    public readonly createdAt: string,
    public readonly updatedAt: string,
    public readonly items: OrderItem[] = [],
    public readonly payments: Payment[] = [],
  ) {}

  /**
   *
   */
  public static create(params: {
    id: string;
    customerId?: string | null;
    guestEmail?: string | null;
    guestName?: string | null;
    guestPhone?: string | null;
    shippingAddress?: string | null;
    subtotal: number;
    total: number;
    currency?: string;
    status?: "pendiente" | "pagado" | "enviado" | "entregado" | "cancelado" | "fallido";
    stripePaymentIntentId?: string | null;
    notes?: string | null;
    createdAt?: string;
    updatedAt?: string;
    items?: OrderItem[];
    payments?: Payment[];
  }): Order {
    const now = new Date().toISOString();
    return new Order(
      params.id,
      params.customerId ?? null,
      params.guestEmail ?? null,
      params.guestName ?? null,
      params.guestPhone ?? null,
      params.shippingAddress ?? null,
      params.subtotal,
      params.total,
      params.currency ?? "PEN",
      params.status ?? "pendiente",
      params.stripePaymentIntentId ?? null,
      params.notes ?? null,
      params.createdAt ?? now,
      params.updatedAt ?? now,
      params.items ?? [],
      params.payments ?? [],
    );
  }
}
