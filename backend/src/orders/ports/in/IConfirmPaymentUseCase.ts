import { Order } from "../../core/Order.ts";

export interface ConfirmPaymentDTO {
  stripePaymentIntentId: string;
}

export interface IConfirmPaymentUseCase {
  /**
   * Confirms payment for an order based on the Stripe PaymentIntent.
   * Updates order status, processes stock decrement, records stock movements,
   * generates stock alerts if needed, and marks the cart as converted.
   */
  execute(dto: ConfirmPaymentDTO): Promise<Order>;
}
