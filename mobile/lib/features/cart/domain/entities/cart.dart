import 'package:mobile/features/cart/domain/entities/cart_item.dart';

/// Cart domain entity on mobile.
class Cart {
  final String id;
  final String? customerId;
  final String? sessionId;
  final String status; // 'active' or 'converted'
  final List<CartItem> items;

  const Cart({
    required this.id,
    this.customerId,
    this.sessionId,
    required this.status,
    required this.items,
  });

  /// Calculates the total cost of all items in the cart.
  int get subtotal => items.fold(0, (sum, item) => sum + item.subtotal);
}
