import 'package:mobile/features/catalog/data/models/product_image_model.dart';
import 'package:mobile/features/catalog/data/models/product_variant_model.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';

class ProductModel extends Product {
  const ProductModel({
    required super.id,
    required super.name,
    required super.slug,
    required super.description,
    required super.basePrice,
    required super.categoryId,
    required super.images,
    required super.variants,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final imagesList = (json['images'] as List? ?? [])
        .map((img) => ProductImageModel.fromJson(img as Map<String, dynamic>))
        .toList();

    final variantsList = (json['variants'] as List? ?? [])
        .map((v) => ProductVariantModel.fromJson(v as Map<String, dynamic>))
        .toList();

    return ProductModel(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      description: json['description'] as String? ?? '',
      basePrice: (json['basePrice'] as num).toInt(),
      categoryId: json['categoryId'] as String,
      images: imagesList,
      variants: variantsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'description': description,
      'basePrice': basePrice,
      'categoryId': categoryId,
      'images': images
          .map((img) => (img as ProductImageModel).toJson())
          .toList(),
      'variants': variants
          .map((v) => (v as ProductVariantModel).toJson())
          .toList(),
    };
  }
}
