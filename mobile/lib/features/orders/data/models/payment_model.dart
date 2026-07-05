import 'package:mobile/features/orders/domain/entities/payment.dart';

class PaymentModel extends Payment {
  const PaymentModel({
    required super.id,
    required super.orderId,
    required super.amount,
    required super.currency,
    required super.status,
    required super.method,
    super.stripeChargeId,
    super.stripePaymentIntentId,
    super.errorMessage,
    required super.createdAt,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      amount: (json['amount'] as num).toInt(),
      currency: json['currency'] as String? ?? 'PEN',
      status: json['status'] as String,
      method: json['method'] as String? ?? 'card',
      stripeChargeId: json['stripeChargeId'] as String?,
      stripePaymentIntentId: json['stripePaymentIntentId'] as String?,
      errorMessage: json['errorMessage'] as String?,
      createdAt: json['createdAt'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'amount': amount,
      'currency': currency,
      'status': status,
      'method': method,
      'stripeChargeId': stripeChargeId,
      'stripePaymentIntentId': stripePaymentIntentId,
      'errorMessage': errorMessage,
      'createdAt': createdAt,
    };
  }
}
