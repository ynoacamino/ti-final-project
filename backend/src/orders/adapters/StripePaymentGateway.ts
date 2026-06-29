import Stripe from "stripe";
import type {
  IPaymentGateway,
  PaymentIntentResult,
  PaymentStatusResult,
} from "../ports/out/IPaymentGateway.ts";

export class StripePaymentGateway implements IPaymentGateway {
  private stripe: Stripe;
  private isMock = true;

  constructor() {
    const key = process.env.STRIPE_SECRET_KEY;
    if (key && key !== "sk_test_mock_key") {
      this.isMock = false;
      this.stripe = new Stripe(key, {
        apiVersion: "2023-10-16" as any,
      });
    } else {
      // Stub initialization for typescript type-safety
      this.stripe = new Stripe("sk_test_mock", {
        apiVersion: "2023-10-16" as any,
      });
    }
  }

  async createPaymentIntent(
    amount: number,
    currency: string,
    metadata?: Record<string, string>,
  ): Promise<PaymentIntentResult> {
    if (this.isMock) {
      // Mock Sandbox response
      const randomId = crypto.randomUUID().substring(0, 8);
      return {
        id: `pi_mock_${randomId}`,
        clientSecret: `pi_mock_secret_${randomId}_${crypto.randomUUID()}`,
      };
    }

    const intent = await this.stripe.paymentIntents.create({
      amount,
      currency: currency.toLowerCase(),
      metadata,
    });

    return {
      id: intent.id,
      clientSecret: intent.client_secret || "",
    };
  }

  async retrievePaymentIntentStatus(paymentIntentId: string): Promise<PaymentStatusResult> {
    if (this.isMock || paymentIntentId.startsWith("pi_mock_")) {
      // Mock Sandbox payment success
      const randomChargeId = crypto.randomUUID().substring(0, 8);
      return {
        status: "succeeded",
        chargeId: `ch_mock_${randomChargeId}`,
      };
    }

    const intent = await this.stripe.paymentIntents.retrieve(paymentIntentId);

    let status: PaymentStatusResult["status"] = "unknown";
    if (intent.status === "succeeded") status = "succeeded";
    else if (intent.status === "requires_payment_method") status = "requires_payment_method";
    else if (intent.status === "processing") status = "processing";
    else if (intent.status === "canceled") status = "canceled";

    const chargeId = typeof intent.latest_charge === "string" ? intent.latest_charge : null;

    return {
      status,
      chargeId,
      errorMessage: intent.last_payment_error?.message,
    };
  }
}
