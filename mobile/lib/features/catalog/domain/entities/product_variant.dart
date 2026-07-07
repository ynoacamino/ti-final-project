/// ProductVariant domain entity on mobile.
class ProductVariant {
  final String id;
  final String productId;
  final String size;
  final String color;
  final String sku;
  final int stock;
  final int additionalPrice; // in cents

  const ProductVariant({
    required this.id,
    required this.productId,
    required this.size,
    required this.color,
    required this.sku,
    required this.stock,
    required this.additionalPrice,
  });
}
