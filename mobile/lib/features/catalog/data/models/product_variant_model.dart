import 'package:mobile/features/catalog/domain/entities/product_variant.dart';

class ProductVariantModel extends ProductVariant {
  const ProductVariantModel({
    required super.id,
    required super.productId,
    required super.size,
    required super.color,
    required super.sku,
    required super.stock,
    required super.additionalPrice,
  });

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    return ProductVariantModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      size: json['size'] as String,
      color: json['color'] as String,
      sku: json['sku'] as String,
      stock: (json['stock'] as num).toInt(),
      additionalPrice: (json['additionalPrice'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'productId': productId,
      'size': size,
      'color': color,
      'sku': sku,
      'stock': stock,
      'additionalPrice': additionalPrice,
    };
  }
}
