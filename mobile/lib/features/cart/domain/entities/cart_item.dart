/// CartItem domain entity on mobile.
class CartItem {
  final String id;
  final String cartId;
  final String productVariantId;
  final int quantity;
  final int unitPriceSnapshot; // in cents
  final String productName;
  final String size;
  final String color;
  final String sku;
  final String imageUrl;

  const CartItem({
    required this.id,
    required this.cartId,
    required this.productVariantId,
    required this.quantity,
    required this.unitPriceSnapshot,
    required this.productName,
    required this.size,
    required this.color,
    required this.sku,
    required this.imageUrl,
  });

  /// Calculates the total cost for this item line.
  int get subtotal => quantity * unitPriceSnapshot;
}
