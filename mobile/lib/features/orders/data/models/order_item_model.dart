import 'package:mobile/features/orders/domain/entities/order_item.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.id,
    required super.orderId,
    required super.productVariantId,
    required super.productNameSnapshot,
    required super.variantDetailsSnapshot,
    required super.quantity,
    required super.unitPrice,
    required super.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      productVariantId: json['productVariantId'] as String,
      productNameSnapshot: json['productNameSnapshot'] as String,
      variantDetailsSnapshot: json['variantDetailsSnapshot'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: (json['unitPrice'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'productVariantId': productVariantId,
      'productNameSnapshot': productNameSnapshot,
      'variantDetailsSnapshot': variantDetailsSnapshot,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'subtotal': subtotal,
    };
  }
}
