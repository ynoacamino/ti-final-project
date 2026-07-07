/// ProductImage domain entity on mobile.
class ProductImage {
  final String id;
  final String productId;
  final String url;
  final int position;

  const ProductImage({
    required this.id,
    required this.productId,
    required this.url,
    required this.position,
  });
}
