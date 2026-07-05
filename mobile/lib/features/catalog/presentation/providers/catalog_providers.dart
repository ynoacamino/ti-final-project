import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/catalog/data/repositories/catalog_repository_impl.dart';
import 'package:mobile/features/catalog/domain/entities/category.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/catalog/domain/repositories/catalog_repository.dart';

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  return CatalogRepositoryImpl(ref.watch(dioClientProvider));
});

/// Fetches categories from the catalog repository.
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  final (categories, failure) = await repo.getCategories();
  if (failure != null) {
    throw Exception(failure.message);
  }
  return categories ?? [];
});

/// Holds the currently selected category for catalog filtering.
final selectedCategoryProvider = StateProvider<String?>((ref) => null);

/// Holds the current query string for searching.
final catalogSearchQueryProvider = StateProvider<String>((ref) => '');

/// Fetches the product list using the active filters.
final productsProvider = FutureProvider<List<Product>>((ref) async {
  final repo = ref.watch(catalogRepositoryProvider);
  final selectedCat = ref.watch(selectedCategoryProvider);
  final search = ref.watch(catalogSearchQueryProvider);

  final (products, failure) = await repo.getProducts(
    categoryId: selectedCat,
    query: search,
  );
  if (failure != null) {
    throw Exception(failure.message);
  }
  return products ?? [];
});

/// Fetches a single product details by its slug.
final productDetailProvider = FutureProvider.family<Product, String>((
  ref,
  slug,
) async {
  final repo = ref.watch(catalogRepositoryProvider);
  final (product, failure) = await repo.getProductBySlug(slug);
  if (failure != null) {
    throw Exception(failure.message);
  }
  if (product == null) {
    throw Exception('Producto no encontrado');
  }
  return product;
});
