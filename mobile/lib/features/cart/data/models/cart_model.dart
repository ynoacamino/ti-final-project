import 'package:mobile/features/cart/data/models/cart_item_model.dart';
import 'package:mobile/features/cart/domain/entities/cart.dart';

class CartModel extends Cart {
  const CartModel({
    required super.id,
    super.customerId,
    super.sessionId,
    required super.status,
    required super.items,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List? ?? [])
        .map((item) => CartItemModel.fromJson(item as Map<String, dynamic>))
        .toList();

    return CartModel(
      id: json['id'] as String? ?? '',
      customerId: json['customerId'] as String?,
      sessionId: json['sessionId'] as String?,
      status: json['status'] as String? ?? 'active',
      items: itemsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'sessionId': sessionId,
      'status': status,
      'items': items.map((item) => (item as CartItemModel).toJson()).toList(),
    };
  }
}
