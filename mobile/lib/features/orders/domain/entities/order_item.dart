/// OrderItem domain entity on mobile.
class OrderItem {
  final String id;
  final String orderId;
  final String productVariantId;
  final String productNameSnapshot;
  final String
  variantDetailsSnapshot; // JSON string representing size, color, sku
  final int quantity;
  final int unitPrice; // in cents
  final int subtotal; // in cents

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.productVariantId,
    required this.productNameSnapshot,
    required this.variantDetailsSnapshot,
    required this.quantity,
    required this.unitPrice,
    required this.subtotal,
  });
}
