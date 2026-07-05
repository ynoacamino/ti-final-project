import 'package:mobile/features/catalog/domain/entities/product_image.dart';
import 'package:mobile/features/catalog/domain/entities/product_variant.dart';

/// Product domain entity on mobile.
class Product {
  final String id;
  final String name;
  final String slug;
  final String description;
  final int basePrice; // in cents (e.g. S/. 29.90 = 2990)
  final String categoryId;
  final List<ProductImage> images;
  final List<ProductVariant> variants;

  const Product({
    required this.id,
    required this.name,
    required this.slug,
    required this.description,
    required this.basePrice,
    required this.categoryId,
    required this.images,
    required this.variants,
  });

  /// Computes the total stock of all product variants combined.
  int get totalStock => variants.fold(0, (sum, v) => sum + v.stock);

  /// Helper to get the first image URL or a placeholder if none is present.
  String get firstImageUrl {
    if (images.isEmpty) {
      return 'https://via.placeholder.com/300';
    }
    // Try to find the one with the lowest position
    final sorted = List<ProductImage>.from(images)
      ..sort((a, b) => a.position.compareTo(b.position));
    return sorted.first.url;
  }
}
