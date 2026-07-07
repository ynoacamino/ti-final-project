import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/orders/data/repositories/orders_repository_impl.dart';
import 'package:mobile/features/orders/domain/entities/order.dart';
import 'package:mobile/features/orders/domain/repositories/orders_repository.dart';

final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  return OrdersRepositoryImpl(ref.watch(dioClientProvider));
});

/// FutureProvider that fetches the currently logged in customer's order history.
final customerOrdersProvider = FutureProvider<List<Order>>((ref) async {
  final repo = ref.watch(ordersRepositoryProvider);
  final (orders, failure) = await repo.getCustomerOrders();
  if (failure != null) {
    throw Exception(failure.message);
  }
  return orders ?? [];
});

/// FutureProvider family that fetches all orders for administrators.
final adminOrdersProvider = FutureProvider.family<List<Order>, String?>((
  ref,
  status,
) async {
  final repo = ref.watch(ordersRepositoryProvider);
  final (orders, failure) = await repo.getAdminOrders(status: status);
  if (failure != null) {
    throw Exception(failure.message);
  }
  return orders ?? [];
});

/// FutureProvider family that fetches single order details by ID.
final orderDetailsProvider = FutureProvider.family<Order, String>((
  ref,
  id,
) async {
  final repo = ref.watch(ordersRepositoryProvider);
  final (order, failure) = await repo.getOrderDetails(id);
  if (failure != null) {
    throw Exception(failure.message);
  }
  if (order == null) {
    throw Exception('Pedido no encontrado');
  }
  return order;
});
