import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/catalog/domain/entities/category.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';

abstract class CatalogRepository {
  /// Fetches all active product categories.
  Future<(List<Category>?, Failure?)> getCategories();

  /// Fetches products, optionally filtering by category and query string.
  Future<(List<Product>?, Failure?)> getProducts({
    String? categoryId,
    String? query,
  });

  /// Fetches detailed specifications of a single product using its unique slug.
  Future<(Product?, Failure?)> getProductBySlug(String slug);

  /// Administrative operation to update a variant's inventory level.
  Future<(bool, Failure?)> updateVariantStock(String variantId, int newStock);

  /// Administrative operation to restock variants.
  Future<(bool, Failure?)> createCategory(String name, String? description);

  /// Administrative operation to create a product.
  Future<(Product?, Failure?)> createProduct({
    required String name,
    required String description,
    required int basePrice,
    required String categoryId,
    required List<Map<String, dynamic>> variants,
  });
}
