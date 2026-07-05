/// Payment domain entity on mobile.
class Payment {
  final String id;
  final String orderId;
  final int amount; // in cents
  final String currency;
  final String status; // 'pending', 'succeeded', 'failed', 'refunded'
  final String method; // 'card', 'yape', 'plin', 'cash'
  final String? stripeChargeId;
  final String? stripePaymentIntentId;
  final String? errorMessage;
  final String createdAt;

  const Payment({
    required this.id,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.method,
    this.stripeChargeId,
    this.stripePaymentIntentId,
    this.errorMessage,
    required this.createdAt,
  });
}
