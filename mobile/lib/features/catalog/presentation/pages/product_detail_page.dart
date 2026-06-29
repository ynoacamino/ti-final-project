import 'package:flutter/material.dart';
class ProductDetailPage extends StatelessWidget {
  final String slug;
  const ProductDetailPage({super.key, required this.slug});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Product Detail: $slug')));
}
