import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:mobile/features/catalog/domain/entities/product_variant.dart';
import 'package:mobile/features/catalog/presentation/providers/catalog_providers.dart';

class ProductDetailPage extends ConsumerStatefulWidget {
  final String slug;
  const ProductDetailPage({super.key, required this.slug});

  @override
  ConsumerState<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends ConsumerState<ProductDetailPage> {
  String? _selectedColor;
  String? _selectedSize;
  bool _isAdding = false;

  String _formatCurrency(int cents) {
    return 'S/. ${(cents / 100).toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.slug));

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Producto')),
      body: productAsync.when(
        data: (prod) {
          // Extractor for colors and sizes
          final colors = prod.variants.map((v) => v.color).toSet().toList();

          // Set default color if not selected
          if (_selectedColor == null && colors.isNotEmpty) {
            _selectedColor = colors.first;
          }

          // Sizes available for the selected color
          final sizesForColor = prod.variants
              .where((v) => v.color == _selectedColor)
              .map((v) => v.size)
              .toSet()
              .toList();

          // Reset or select default size if needed
          if (_selectedSize == null || !sizesForColor.contains(_selectedSize)) {
            _selectedSize = sizesForColor.isNotEmpty
                ? sizesForColor.first
                : null;
          }

          // Active variant selection
          ProductVariant? selectedVariant;
          try {
            selectedVariant = prod.variants.firstWhere(
              (v) => v.color == _selectedColor && v.size == _selectedSize,
            );
          } catch (_) {
            selectedVariant = null;
          }

          final price =
              prod.basePrice + (selectedVariant?.additionalPrice ?? 0);
          final stock = selectedVariant?.stock ?? 0;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Large image display
                      SizedBox(
                        height: 320,
                        child: CachedNetworkImage(
                          imageUrl: prod.firstImageUrl,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: const Color(0xFF1E293B),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: const Color(0xFF1E293B),
                            child: const Icon(
                              Icons.image_not_supported_outlined,
                              size: 64,
                            ),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name & Price
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    prod.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  _formatCurrency(price),
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: AppTheme.secondaryColor,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Description
                            Text(
                              prod.description,
                              style: const TextStyle(
                                fontSize: 15,
                                height: 1.5,
                                color: AppTheme.textSecondaryColor,
                              ),
                            ),
                            const SizedBox(height: 28),

                            // Color selection
                            const Text(
                              'Color',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 12,
                              children: colors.map((color) {
                                final isSelected = color == _selectedColor;
                                return ChoiceChip(
                                  selected: isSelected,
                                  label: Text(color),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedColor = color;
                                        _selectedSize = null; // trigger re-eval
                                      });
                                    }
                                  },
                                  selectedColor: AppTheme.primaryColor
                                      .withOpacity(0.2),
                                  checkmarkColor: AppTheme.primaryColor,
                                  side: BorderSide(
                                    color: isSelected
                                        ? AppTheme.primaryColor
                                        : const Color(0xFF334155),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),

                            // Size selection
                            const Text(
                              'Talla',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 12,
                              children: sizesForColor.map((size) {
                                final isSelected = size == _selectedSize;
                                return ChoiceChip(
                                  selected: isSelected,
                                  label: Text(size),
                                  onSelected: (selected) {
                                    if (selected) {
                                      setState(() {
                                        _selectedSize = size;
                                      });
                                    }
                                  },
                                  selectedColor: AppTheme.primaryColor
                                      .withOpacity(0.2),
                                  checkmarkColor: AppTheme.primaryColor,
                                  side: BorderSide(
                                    color: isSelected
                                        ? AppTheme.primaryColor
                                        : const Color(0xFF334155),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),

                            // Stock Indicator badge
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: stock > 0
                                        ? AppTheme.secondaryColor.withOpacity(
                                            0.1,
                                          )
                                        : AppTheme.errorColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: stock > 0
                                          ? AppTheme.secondaryColor
                                          : AppTheme.errorColor,
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        stock > 0
                                            ? Icons.check
                                            : Icons.error_outline,
                                        size: 16,
                                        color: stock > 0
                                            ? AppTheme.secondaryColor
                                            : AppTheme.errorColor,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        stock > 0
                                            ? 'Disponibles: $stock unidades'
                                            : 'Agotado',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: stock > 0
                                              ? AppTheme.secondaryColor
                                              : AppTheme.errorColor,
                                        ),
                                      ),
                                    ],
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
              ),

              // Bottom Action Bar for Add to Cart
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 20,
                ),
                decoration: const BoxDecoration(
                  color: AppTheme.surfaceColor,
                  border: Border(
                    top: BorderSide(color: Color(0xFF334155), width: 1),
                  ),
                ),
                child: SafeArea(
                  child: ElevatedButton(
                    onPressed: stock <= 0 || _isAdding
                        ? null
                        : () async {
                            if (selectedVariant == null) return;
                            setState(() => _isAdding = true);
                            final done = await ref
                                .read(cartProvider.notifier)
                                .addItem(selectedVariant.id, 1);
                            setState(() => _isAdding = false);

                            if (mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    done
                                        ? '¡Añadido al carrito con éxito!'
                                        : 'Error al añadir. Verifica stock disponible.',
                                  ),
                                  backgroundColor: done
                                      ? AppTheme.secondaryColor
                                      : AppTheme.errorColor,
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      disabledBackgroundColor: const Color(0xFF1E293B),
                    ),
                    child: _isAdding
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(stock > 0 ? 'Añadir al Carrito' : 'Sin Stock'),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.primaryColor),
        ),
        error: (err, _) => Center(child: Text('Error al cargar detalle: $err')),
      ),
    );
  }
}
