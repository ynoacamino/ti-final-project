import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

/// Fetches the administrative summary metrics.
final dashboardMetricsProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final client = ref.watch(dioClientProvider);
  final response = await client.dio.get('/dashboard/metrics');
  final data = response.data as Map<String, dynamic>;
  if (data['success'] != true) {
    throw Exception(data['error'] ?? 'Failed to load dashboard metrics');
  }
  return data['metrics'] as Map<String, dynamic>;
});

/// Fetches the top selling products.
final dashboardTopProductsProvider = FutureProvider<List<dynamic>>((ref) async {
  final client = ref.watch(dioClientProvider);
  final response = await client.dio.get('/dashboard/top-products');
  final data = response.data as Map<String, dynamic>;
  if (data['success'] != true) {
    throw Exception(data['error'] ?? 'Failed to load top products');
  }
  return data['topProducts'] as List<dynamic>;
});

/// Fetches the order count status distribution.
final dashboardOrderStatusProvider = FutureProvider<Map<String, dynamic>>((
  ref,
) async {
  final client = ref.watch(dioClientProvider);
  final response = await client.dio.get('/dashboard/orders-by-status');
  final data = response.data as Map<String, dynamic>;
  if (data['success'] != true) {
    throw Exception(data['error'] ?? 'Failed to load orders by status');
  }
  return data['statusDistribution'] as Map<String, dynamic>;
});

/// Fetches the sales revenue timeline (e.g. daily, weekly, monthly).
final dashboardSalesTimelineProvider =
    FutureProvider.family<List<dynamic>, String>((ref, interval) async {
      final client = ref.watch(dioClientProvider);
      final response = await client.dio.get(
        '/dashboard/sales-timeline',
        queryParameters: {'interval': interval},
      );
      final data = response.data as Map<String, dynamic>;
      if (data['success'] != true) {
        throw Exception(data['error'] ?? 'Failed to load sales timeline');
      }
      return data['timeline'] as List<dynamic>;
    });

/// Administrative operation to list active low stock alerts.
final inventoryAlertsProvider = FutureProvider<List<dynamic>>((ref) async {
  final client = ref.watch(dioClientProvider);
  final response = await client.dio.get('/inventory/alerts');
  final data = response.data as Map<String, dynamic>;
  if (data['success'] != true) {
    throw Exception(data['error'] ?? 'Failed to load low stock alerts');
  }
  return data['alerts'] as List<dynamic>;
});
