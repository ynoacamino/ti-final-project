import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final gradientDecoration = isDark
        ? const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF080D1A),
                Color(0xFF0F172A),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          )
        : const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFF3EEFF), // Soft lavender
                Color(0xFFFFFBFE), // Crema
                Color(0xFFFFF0F5), // Soft rose
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          );

    final cartState = ref.watch(cartProvider);

    return Scaffold(
      body: Container(
        decoration: gradientDecoration,
        child: SafeArea(
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
            // Custom Mockup-aligned Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Colección',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF79747E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'SmartPyME',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: isDark ? Colors.white : const Color(0xFF1C1B1F),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => context.go('/cart'),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isDark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFF6750A4).withOpacity(0.12),
                              width: 1.5,
                            ),
                            boxShadow: isDark
                                ? null
                                : [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.04),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ],
                          ),
                          child: Icon(
                            Icons.shopping_bag_outlined,
                            color: isDark ? Colors.white : const Color(0xFF1C1B1F),
                            size: 24,
                          ),
                        ),
                        if (cartState.value != null) ...[
                          (() {
                            final count = cartState.value!.items.fold<int>(0, (int prev, element) => prev + element.quantity);
                            if (count == 0) return const SizedBox();
                            return Positioned(
                              right: -2,
                              top: -2,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Color(0xFF6750A4),
                                  shape: BoxShape.circle,
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 18,
                                  minHeight: 18,
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  '$count',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            );
                          })(),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Search Bar Row with Tune settings button
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        ref.read(catalogSearchQueryProvider.notifier).state = val;
                      },
                      decoration: InputDecoration(
                        hintText: 'Buscar prendas, marcas...',
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
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isDark
                            ? const Color(0xFF334155)
                            : const Color(0xFF6750A4).withOpacity(0.12),
                        width: 1.5,
                      ),
                      boxShadow: isDark
                          ? null
                          : [
                              BoxShadow(
                                color: const Color(0xFF6750A4).withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.tune, color: Color(0xFF6750A4)),
                      onPressed: () {}, // Optional filters
                    ),
                  ),
                ],
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
                              : (Theme.of(context).brightness == Brightness.dark
                                  ? const Color(0xFF334155)
                                  : const Color(0xFFEADDFF)),
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
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF1E293B)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? const Color(0xFF334155)
                                : const Color(0xFF6750A4).withOpacity(0.08),
                            width: 1.5,
                          ),
                          boxShadow: Theme.of(context).brightness == Brightness.dark
                              ? null
                              : [
                                  BoxShadow(
                                    color: const Color(0xFF6750A4).withOpacity(0.03),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // Product Image Stack
                            Expanded(
                              child: Stack(
                                children: [
                                  Positioned.fill(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(17),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: prod.firstImageUrl,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) => Container(
                                          color: Theme.of(context).brightness == Brightness.dark
                                              ? const Color(0xFF0F172A)
                                              : const Color(0xFFF1F5F9),
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
                                              color: Theme.of(context).brightness == Brightness.dark
                                                  ? const Color(0xFF0F172A)
                                                  : const Color(0xFFF1F5F9),
                                              child: const Icon(
                                                Icons.image_not_supported_outlined,
                                                color: AppTheme.textSecondaryColor,
                                              ),
                                            ),
                                      ),
                                    ),
                                  ),

                                  // Sold out overlay
                                  if (prod.totalStock == 0)
                                    Positioned.fill(
                                      child: Container(
                                        color: Colors.black.withOpacity(0.4),
                                        child: Center(
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: Colors.black.withOpacity(0.7),
                                              borderRadius: BorderRadius.circular(100),
                                            ),
                                            child: const Text(
                                              'AGOTADO',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w900,
                                                letterSpacing: 1.2,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),

                                  // Oferta badge
                                  if (prod.basePrice < 15000 && prod.totalStock > 0)
                                    Positioned(
                                      top: 8,
                                      left: 8,
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF6750A4),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text(
                                          'OFERTA',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 8,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                  // Floating wishlist heart
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.favorite_border,
                                        color: Color(0xFF79747E),
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Product Info
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    prod.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Color(0xFF1C1B1F),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 6),
                                  
                                  // Stock availability chip
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: prod.totalStock > 5
                                          ? const Color(0xFFD9F5E4)
                                          : (prod.totalStock > 0 ? const Color(0xFFFEF3C7) : const Color(0xFFFCE8E6)),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      prod.totalStock > 5
                                          ? '• Disponible'
                                          : (prod.totalStock > 0 ? '• Últimas ud.' : '• Agotado'),
                                      style: TextStyle(
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold,
                                        color: prod.totalStock > 5
                                            ? const Color(0xFF146C3E)
                                            : (prod.totalStock > 0 ? const Color(0xFFD97706) : const Color(0xFFC1634A)),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 8),

                                  // Price
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      _formatCurrency(prod.basePrice),
                                      style: const TextStyle(
                                        color: Color(0xFF1C1B1F),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
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
     ),
    ),
  );
}
}
