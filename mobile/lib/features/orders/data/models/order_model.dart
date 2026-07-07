import 'package:mobile/features/orders/data/models/order_item_model.dart';
import 'package:mobile/features/orders/data/models/payment_model.dart';
import 'package:mobile/features/orders/domain/entities/order.dart';

class OrderModel extends Order {
  const OrderModel({
    required super.id,
    super.customerId,
    super.guestEmail,
    super.guestName,
    super.guestPhone,
    super.shippingAddress,
    required super.subtotal,
    required super.total,
    required super.currency,
    required super.status,
    super.stripePaymentIntentId,
    super.notes,
    required super.createdAt,
    required super.updatedAt,
    required super.items,
    required super.payments,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List? ?? [])
        .map((item) => OrderItemModel.fromJson(item as Map<String, dynamic>))
        .toList();

    final paymentsList = (json['payments'] as List? ?? [])
        .map((p) => PaymentModel.fromJson(p as Map<String, dynamic>))
        .toList();

    return OrderModel(
      id: json['id'] as String,
      customerId: json['customerId'] as String?,
      guestEmail: json['guestEmail'] as String?,
      guestName: json['guestName'] as String?,
      guestPhone: json['guestPhone'] as String?,
      shippingAddress: json['shippingAddress'] as String?,
      subtotal: (json['subtotal'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      currency: json['currency'] as String? ?? 'PEN',
      status: json['status'] as String,
      stripePaymentIntentId: json['stripePaymentIntentId'] as String?,
      notes: json['notes'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
      items: itemsList,
      payments: paymentsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'guestEmail': guestEmail,
      'guestName': guestName,
      'guestPhone': guestPhone,
      'shippingAddress': shippingAddress,
      'subtotal': subtotal,
      'total': total,
      'currency': currency,
      'status': status,
      'stripePaymentIntentId': stripePaymentIntentId,
      'notes': notes,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'items': items.map((item) => (item as OrderItemModel).toJson()).toList(),
      'payments': payments.map((p) => (p as PaymentModel).toJson()).toList(),
    };
  }
}
