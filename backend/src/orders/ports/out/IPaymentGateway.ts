export interface PaymentIntentResult {
  id: string;
  clientSecret: string;
}

export interface PaymentStatusResult {
  status: string;
  chargeId: string | null;
  errorMessage?: string;
}

export interface IPaymentGateway {
  createPaymentIntent(
    amount: number,
    currency: string,
    metadata?: Record<string, string>,
  ): Promise<PaymentIntentResult>;
  retrievePaymentIntentStatus(paymentIntentId: string): Promise<PaymentStatusResult>;
}
