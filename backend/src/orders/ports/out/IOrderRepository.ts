import type { Order } from "../../core/Order.ts";
import type { Payment } from "../../core/Payment.ts";

export interface ListOrdersParams {
  customerId?: string;
  status?: string;
  limit?: number;
  offset?: number;
}

export interface IOrderRepository {
  findById(id: string): Promise<Order | null>;
  findByPaymentIntentId(paymentIntentId: string): Promise<Order | null>;
  save(order: Order): Promise<void>;
  savePayment(payment: Payment): Promise<void>;
  list(params: ListOrdersParams): Promise<{ orders: Order[]; total: number }>;
}
