import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/catalog/presentation/providers/catalog_providers.dart';

class AdminProductsPage extends ConsumerStatefulWidget {
  const AdminProductsPage({super.key});

  @override
  ConsumerState<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends ConsumerState<AdminProductsPage> {
  String _searchQuery = '';
  bool _isDeleting = false;

  String _formatCurrency(int cents) {
    return 'S/. ${(cents / 100).toStringAsFixed(2)}';
  }

  Future<void> _confirmDelete(BuildContext context, String id, String name) async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppTheme.darkSurface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0x22818CF8)),
          ),
          title: Text(
            'Eliminar Producto',
            style: TextStyle(
              color: AppTheme.errorColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            '¿Está seguro de que desea eliminar definitivamente "$name"? Esta acción no se puede deshacer y borrará todas sus variantes e imágenes.',
            style: const TextStyle(color: AppTheme.darkTextPrimary),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Cancelar',
                style: TextStyle(color: AppTheme.darkTextSecondary),
              ),
            ),
            ElevatedButton(
              onPressed: _isDeleting
                  ? null
                  : () async {
                      setState(() => _isDeleting = true);
                      Navigator.of(context).pop();

                      final repo = ref.read(catalogRepositoryProvider);
                      final (success, failure) = await repo.deleteProduct(id);

                      if (mounted) {
                        setState(() => _isDeleting = false);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? '¡Producto eliminado con éxito!'
                                  : 'Error: ${failure?.message ?? "No se pudo eliminar"}',
                            ),
                            backgroundColor: success
                                ? AppTheme.secondaryColor
                                : AppTheme.errorColor,
                          ),
                        );
                        if (success) {
                          ref.invalidate(productsProvider);
                        }
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorColor,
                foregroundColor: Colors.white,
              ),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productsAsync = ref.watch(productsProvider);

    return Scaffold(
      backgroundColor: AppTheme.darkBackground,
      appBar: AppBar(
        title: const Text('Administrar Catálogo'),
        backgroundColor: AppTheme.darkSurface,
        foregroundColor: AppTheme.darkTextPrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              ref.invalidate(productsProvider);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  _searchQuery = val.trim();
                });
              },
              style: const TextStyle(color: AppTheme.darkTextPrimary),
              decoration: InputDecoration(
                hintText: 'Buscar productos...',
                hintStyle: const TextStyle(color: AppTheme.darkTextSecondary),
                prefixIcon: const Icon(Icons.search, color: AppTheme.darkTextSecondary),
                filled: true,
                fillColor: AppTheme.darkSurface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0x17818CF8)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0x17818CF8)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppTheme.darkPrimary, width: 1.5),
                ),
              ),
            ),
          ),

          Expanded(
            child: productsAsync.when(
              data: (products) {
                final filtered = products.where((p) {
                  if (_searchQuery.isEmpty) return true;
                  return p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      p.description.toLowerCase().contains(_searchQuery.toLowerCase());
                }).toList();

                if (filtered.isEmpty) {
                  return const Center(
                    child: Text(
                      'No se encontraron productos.',
                      style: TextStyle(color: AppTheme.darkTextSecondary),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final product = filtered[index];
                    return Card(
                      color: AppTheme.darkSurface,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: const BorderSide(color: Color(0x17818CF8)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          children: [
                            // Product Image Thumbnail
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl: product.firstImageUrl,
                                width: 64,
                                height: 64,
                                fit: BoxFit.cover,
                                placeholder: (context, url) => Container(
                                  width: 64,
                                  height: 64,
                                  color: Colors.white10,
                                  child: const Center(
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                ),
                                errorWidget: (context, url, error) => Container(
                                  width: 64,
                                  height: 64,
                                  color: Colors.white10,
                                  child: const Icon(
                                    Icons.image_not_supported_outlined,
                                    color: AppTheme.darkTextSecondary,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),

                            // Product details
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: const TextStyle(
                                      color: AppTheme.darkTextPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _formatCurrency(product.basePrice),
                                    style: const TextStyle(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Stock total: ${product.totalStock} uds. | ${product.variants.length} variantes',
                                    style: const TextStyle(
                                      color: AppTheme.darkTextSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Actions
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: AppTheme.errorColor),
                              onPressed: () => _confirmDelete(context, product.id, product.name),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(color: AppTheme.darkPrimary),
              ),
              error: (err, _) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Text(
                    'Error al cargar productos: $err',
                    style: const TextStyle(color: AppTheme.errorColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/admin/products/create'),
        backgroundColor: const Color(0xFFEAB308), // Elegant Amber gold to match the design system
        foregroundColor: Colors.black,
        icon: const Icon(Icons.add),
        label: const Text(
          'Crear Producto',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
