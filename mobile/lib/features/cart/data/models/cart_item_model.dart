import 'package:mobile/features/cart/domain/entities/cart_item.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.id,
    required super.cartId,
    required super.productVariantId,
    required super.quantity,
    required super.unitPriceSnapshot,
    required super.productName,
    required super.size,
    required super.color,
    required super.sku,
    required super.imageUrl,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      cartId: json['cartId'] as String,
      productVariantId: json['productVariantId'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPriceSnapshot: (json['unitPriceSnapshot'] as num).toInt(),
      productName: json['productName'] as String? ?? 'Prenda',
      size: json['size'] as String? ?? '',
      color: json['color'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'cartId': cartId,
      'productVariantId': productVariantId,
      'quantity': quantity,
      'unitPriceSnapshot': unitPriceSnapshot,
      'productName': productName,
      'size': size,
      'color': color,
      'sku': sku,
      'imageUrl': imageUrl,
    };
  }
}
