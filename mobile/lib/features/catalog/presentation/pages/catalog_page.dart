import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/catalog/presentation/providers/catalog_providers.dart';

class CatalogPage extends ConsumerWidget {
  const CatalogPage({super.key});

  String _formatCurrency(int cents) {
    return 'S/. ${(cents / 100).toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final productsAsync = ref.watch(productsProvider);
    final selectedCat = ref.watch(selectedCategoryProvider);
    final search = ref.watch(catalogSearchQueryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Explorar Catálogo')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 1. Search Bar
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: TextField(
              onChanged: (val) {
                ref.read(catalogSearchQueryProvider.notifier).state = val;
              },
              decoration: InputDecoration(
                hintText: 'Buscar prendas, jeans, camisas...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: search.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          ref.read(catalogSearchQueryProvider.notifier).state =
                              '';
                        },
                      )
                    : null,
              ),
            ),
          ),

          // 2. Horizontal Category Filter Chips
          SizedBox(
            height: 48,
            child: categoriesAsync.when(
              data: (list) {
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: list.length + 1,
                  itemBuilder: (context, index) {
                    final isAll = index == 0;
                    final category = isAll ? null : list[index - 1];
                    final isSelected = isAll
                        ? selectedCat == null
                        : selectedCat == category?.id;

                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: FilterChip(
                        selected: isSelected,
                        label: Text(isAll ? 'Todos' : category!.name),
                        onSelected: (selected) {
                          ref.read(selectedCategoryProvider.notifier).state =
                              isAll ? null : category!.id;
                        },
                        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                        checkmarkColor: AppTheme.primaryColor,
                        side: BorderSide(
                          color: isSelected
                              ? AppTheme.primaryColor
                              : const Color(0xFF334155),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
              error: (_, __) => const SizedBox(),
            ),
          ),

          const SizedBox(height: 16),

          // 3. Products Grid View
          Expanded(
            child: productsAsync.when(
              data: (products) {
                if (products.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.search_off_outlined,
                            size: 64,
                            color: AppTheme.textSecondaryColor,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'No se encontraron productos.',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Prueba quitando filtros o cambiando la búsqueda.',
                            style: TextStyle(
                              color: AppTheme.textSecondaryColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          TextButton(
                            onPressed: () {
                              ref
                                      .read(selectedCategoryProvider.notifier)
                                      .state =
                                  null;
                              ref
                                      .read(catalogSearchQueryProvider.notifier)
                                      .state =
                                  '';
                            },
                            child: const Text('Limpiar filtros'),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.65,
                  ),
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final prod = products[index];
                    return GestureDetector(
                      onTap: () => context.go('/catalog/product/${prod.slug}'),
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppTheme.surfaceColor,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: const Color(0xFF334155),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(17),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: prod.firstImageUrl,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    color: const Color(0xFF1E293B),
                                    child: const Center(
                                      child: SizedBox(
                                        height: 24,
                                        width: 24,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Container(
                                        color: const Color(0xFF1E293B),
                                        child: const Icon(
                                          Icons.image_not_supported_outlined,
                                          color: AppTheme.textSecondaryColor,
                                        ),
                                      ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    prod.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatCurrency(prod.basePrice),
                                    style: const TextStyle(
                                      color: AppTheme.secondaryColor,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Row(
                                    children: [
                                      Icon(
                                        prod.totalStock > 0
                                            ? Icons.check_circle_outline
                                            : Icons.remove_circle_outline,
                                        size: 14,
                                        color: prod.totalStock > 0
                                            ? AppTheme.secondaryColor
                                            : AppTheme.errorColor,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        prod.totalStock > 0
                                            ? 'En Stock (${prod.totalStock})'
                                            : 'Agotado',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: prod.totalStock > 0
                                              ? AppTheme.secondaryColor
                                              : AppTheme.errorColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              ),
              error: (err, _) =>
                  Center(child: Text('Error al cargar catálogo: $err')),
            ),
          ),
        ],
      ),
    );
  }
}
