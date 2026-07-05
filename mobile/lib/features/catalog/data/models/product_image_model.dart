import 'package:mobile/features/catalog/domain/entities/product_image.dart';

class ProductImageModel extends ProductImage {
  const ProductImageModel({
    required super.id,
    required super.productId,
    required super.url,
    required super.position,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    return ProductImageModel(
      id: json['id'] as String,
      productId: json['productId'] as String,
      url: json['url'] as String,
      position: (json['position'] as num).toInt(),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'productId': productId, 'url': url, 'position': position};
  }
}
