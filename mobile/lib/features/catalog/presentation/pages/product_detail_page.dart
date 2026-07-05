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

  int _quantity = 1;

  Color _getColorHex(String colorName) {
    switch (colorName.toLowerCase().trim()) {
      case 'blanco':
      case 'blanco hueso':
      case 'white':
        return const Color(0xFFF5F0E8);
      case 'arena':
      case 'beige':
        return const Color(0xFFC8B99A);
      case 'azul marino':
      case 'marino':
      case 'navy':
      case 'azul':
      case 'blue':
        return const Color(0xFF1E3A5F);
      case 'sage':
      case 'verde':
      case 'green':
        return const Color(0xFF7C9C7E);
      case 'terracota':
      case 'rojo':
      case 'red':
        return const Color(0xFFC1634A);
      case 'negro':
      case 'black':
        return const Color(0xFF1C1B1F);
      case 'gris':
      case 'grey':
      case 'gray':
        return const Color(0xFF78909C);
      default:
        return const Color(0xFF6750A4); // fallback primary
    }
  }

  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productDetailProvider(widget.slug));

    return Scaffold(
      backgroundColor: AppTheme.lightBackground,
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
            _selectedSize = sizesForColor.isNotEmpty ? sizesForColor.first : null;
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

          final price = prod.basePrice + (selectedVariant?.additionalPrice ?? 0);
          final stock = selectedVariant?.stock ?? 0;
          final originalPrice = (price * 1.35).round(); // mock original price for discount display
          final discountPercent = 26; // mock discount percent

          return Stack(
            children: [
              // Scrollable Detail Body
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Large Image Showcase (420px height)
                      Stack(
                        children: [
                          SizedBox(
                            height: 420,
                            width: double.infinity,
                            child: CachedNetworkImage(
                              imageUrl: prod.firstImageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                color: const Color(0xFFF4EFF4),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: AppTheme.lightPrimary,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                color: const Color(0xFFF4EFF4),
                                child: const Icon(
                                  Icons.image_not_supported_outlined,
                                  size: 64,
                                  color: AppTheme.lightTextSecondary,
                                ),
                              ),
                            ),
                          ),
                          // Bottom fade gradient overlay into light background
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 80,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    AppTheme.lightBackground.withOpacity(0.4),
                                    AppTheme.lightBackground,
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Information and Controls
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 120.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Brand name & Rating Stars row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'SMARTPYME STUDIO',
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: 1.2,
                                    color: AppTheme.lightPrimary,
                                  ),
                                ),
                                Row(
                                  children: [
                                    ...List.generate(5, (index) {
                                      return Icon(
                                        Icons.star,
                                        size: 14,
                                        color: index < 4
                                            ? const Color(0xFFF59E0B)
                                            : const Color(0xFFCAC4D0),
                                      );
                                    }),
                                    const SizedBox(width: 4),
                                    const Text(
                                      '4.0 (128)',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppTheme.lightTextSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            // Product Title
                            Text(
                              prod.name,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.lightTextPrimary,
                                letterSpacing: -0.5,
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Price and Discount row
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  _formatCurrency(price),
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.lightPrimary,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _formatCurrency(originalPrice),
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: AppTheme.lightTextSecondary,
                                    decoration: TextDecoration.lineThrough,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD9F5E4),
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: Text(
                                    '-$discountPercent%',
                                    style: const TextStyle(
                                      color: Color(0xFF146C3E),
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            // Sizing section
                            const Text(
                              'Talla',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppTheme.lightTextPrimary,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: ['XS', 'S', 'M', 'L', 'XL'].map((size) {
                                final isAvailable = sizesForColor.contains(size);
                                final isSelected = size == _selectedSize;

                                return GestureDetector(
                                  onTap: () {
                                    if (isAvailable) {
                                      setState(() {
                                        _selectedSize = size;
                                      });
                                    }
                                  },
                                  child: Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? AppTheme.lightPrimary
                                          : isAvailable
                                              ? const Color(0xFFF4EFF4)
                                              : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppTheme.lightPrimary
                                            : isAvailable
                                                ? Colors.transparent
                                                : const Color(0xFFE8E4EC),
                                        width: 2,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: AppTheme.lightPrimary.withOpacity(0.35),
                                                blurRadius: 10,
                                                offset: const Offset(0, 2),
                                              )
                                            ]
                                          : null,
                                    ),
                                    child: Center(
                                      child: Stack(
                                        alignment: Alignment.center,
                                        children: [
                                          Text(
                                            size,
                                            style: TextStyle(
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected
                                                  ? Colors.white
                                                  : isAvailable
                                                      ? AppTheme.lightTextPrimary
                                                      : const Color(0xFFCAC4D0),
                                            ),
                                          ),
                                          if (!isAvailable)
                                            CustomPaint(
                                              size: const Size(48, 48),
                                              painter: LineStrikePainter(),
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),

                            // Color section
                            Row(
                              children: [
                                const Text(
                                  'Color: ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.lightTextPrimary,
                                  ),
                                ),
                                Text(
                                  _selectedColor ?? '',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: AppTheme.lightTextSecondary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: colors.map((colorName) {
                                final isSelected = colorName == _selectedColor;
                                final hexColor = _getColorHex(colorName);

                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedColor = colorName;
                                      _selectedSize = null; // force re-evaluation of size
                                    });
                                  },
                                  child: Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: hexColor,
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.white
                                            : hexColor.computeLuminance() > 0.9
                                                ? const Color(0xFFD4CFC6)
                                                : Colors.transparent,
                                        width: 2.5,
                                      ),
                                      boxShadow: [
                                        if (isSelected)
                                          BoxShadow(
                                            color: AppTheme.lightPrimary.withOpacity(0.3),
                                            blurRadius: 12,
                                            spreadRadius: 2,
                                          )
                                        else
                                          const BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 1),
                                          ),
                                      ],
                                    ),
                                    child: isSelected
                                        ? Center(
                                            child: Icon(
                                              Icons.check,
                                              size: 16,
                                              color: hexColor.computeLuminance() > 0.7
                                                  ? AppTheme.lightPrimary
                                                  : Colors.white,
                                            ),
                                          )
                                        : null,
                                  ),
                                );
                              }).toList(),
                            ),
                            const SizedBox(height: 24),

                            // Description paragraph
                            Text(
                              prod.description,
                              style: const TextStyle(
                                fontSize: 13,
                                height: 1.6,
                                color: AppTheme.lightTextSecondary,
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Perks row
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4EFF4),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  _buildPerkItem(Icons.local_shipping_outlined, 'Envío gratis\n+S/. 150'),
                                  _buildPerkItem(Icons.history_outlined, 'Devolución\n30 días'),
                                  _buildPerkItem(Icons.security_outlined, 'Pago\nseguro'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Floating app chrome header on top of image
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Back Button
                        GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(0.82),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  offset: Offset(0, 1),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.arrow_back,
                              size: 18,
                              color: AppTheme.lightTextPrimary,
                            ),
                          ),
                        ),
                        // Actions Group (Favorites, Share, Cart)
                        Row(
                          children: [
                            _buildFloatingIcon(Icons.favorite_border, () {}),
                            const SizedBox(width: 8),
                            _buildFloatingIcon(Icons.share_outlined, () {}),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Fixed Bottom Action Bar: Quantity Stepper & Add to Cart button
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    color: AppTheme.lightBackground.withOpacity(0.95),
                    border: const Border(
                      top: BorderSide(color: Color(0x141C1B1F), width: 1),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (_selectedSize == null)
                          const Padding(
                            padding: EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              'Selecciona una talla para continuar',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFFB3261E),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        Row(
                          children: [
                            // Stepper
                            Container(
                              height: 54,
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF4EFF4),
                                borderRadius: BorderRadius.circular(100),
                                border: Border.all(
                                  color: AppTheme.lightPrimary.withOpacity(0.28),
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (_quantity > 1) {
                                        setState(() => _quantity--);
                                      }
                                    },
                                    child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: _quantity > 1
                                          ? AppTheme.lightPrimary
                                          : Colors.transparent,
                                      child: Icon(
                                        Icons.remove,
                                        size: 15,
                                        color: _quantity > 1
                                            ? Colors.white
                                            : const Color(0xFFCAC4D0),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 28,
                                    child: Text(
                                      '$_quantity',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.lightTextPrimary,
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () => setState(() => _quantity++),
                                    child: const CircleAvatar(
                                      radius: 18,
                                      backgroundColor: AppTheme.lightPrimary,
                                      child: Icon(
                                        Icons.add,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Add to Cart Button
                            Expanded(
                              child: ElevatedButton(
                                onPressed: stock <= 0 || _isAdding || _selectedSize == null
                                    ? null
                                    : () async {
                                        if (selectedVariant == null) return;
                                        setState(() => _isAdding = true);
                                        final done = await ref
                                            .read(cartProvider.notifier)
                                            .addItem(selectedVariant.id, _quantity);
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
                                                  ? const Color(0xFF146C3E)
                                                  : AppTheme.errorColor,
                                            ),
                                          );
                                        }
                                      },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size(0, 54),
                                  backgroundColor: _selectedSize != null
                                      ? AppTheme.lightPrimary
                                      : const Color(0xFFCAC4D0),
                                  foregroundColor: Colors.white,
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
                                    : Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.shopping_bag_outlined, size: 18),
                                          const SizedBox(width: 8),
                                          Text(stock > 0 ? 'Añadir al Carrito' : 'Sin Stock'),
                                          if (_quantity > 1) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.white24,
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                '$_quantity',
                                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                              ),
                                            )
                                          ]
                                        ],
                                      ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: AppTheme.lightPrimary),
        ),
        error: (err, _) => Center(child: Text('Error al cargar detalle: $err')),
      ),
    );
  }

  Widget _buildFloatingIcon(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withOpacity(0.82),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 18,
          color: AppTheme.lightTextPrimary,
        ),
      ),
    );
  }

  Widget _buildPerkItem(IconData icon, String text) {
    return Expanded(
      child: Column(
        children: [
          CircleAvatar(
            radius: 17,
            backgroundColor: const Color(0xFFEAD1FF),
            child: Icon(icon, size: 16, color: AppTheme.lightPrimary),
          ),
          const SizedBox(height: 6),
          Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppTheme.lightTextSecondary,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}

class LineStrikePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD5CFE0)
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.8),
      Offset(size.width * 0.8, size.height * 0.2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
