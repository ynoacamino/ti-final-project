import 'package:mobile/features/orders/domain/entities/order_item.dart';
import 'package:mobile/features/orders/domain/entities/payment.dart';

/// Order domain entity on mobile.
class Order {
  final String id;
  final String? customerId;
  final String? guestEmail;
  final String? guestName;
  final String? guestPhone;
  final String? shippingAddress; // JSON string
  final int subtotal; // in cents
  final int total; // in cents
  final String currency;
  final String
  status; // 'pendiente', 'pagado', 'enviado', 'entregado', 'cancelado', 'fallido'
  final String? stripePaymentIntentId;
  final String? notes;
  final String createdAt;
  final String updatedAt;
  final List<OrderItem> items;
  final List<Payment> payments;

  const Order({
    required this.id,
    this.customerId,
    this.guestEmail,
    this.guestName,
    this.guestPhone,
    this.shippingAddress,
    required this.subtotal,
    required this.total,
    required this.currency,
    required this.status,
    this.stripePaymentIntentId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    required this.payments,
  });
}
