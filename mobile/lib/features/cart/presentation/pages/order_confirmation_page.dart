import 'package:flutter/material.dart';
class OrderConfirmationPage extends StatelessWidget {
  final String orderId;
  const OrderConfirmationPage({super.key, required this.orderId});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text('Order Confirmation: $orderId')));
}
