import 'package:dio/dio.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/features/orders/data/models/order_model.dart';
import 'package:mobile/features/orders/domain/entities/order.dart';
import 'package:mobile/features/orders/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final DioClient client;

  OrdersRepositoryImpl(this.client);

  @override
  Future<(List<Order>?, Failure?)> getCustomerOrders({
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await client.dio.get(
        '/customers/me/orders',
        queryParameters: queryParams,
      );
      final data = response.data as Map<String, dynamic>;
      final listJson = data['orders'] as List? ?? [];
      final orders = listJson
          .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return (orders, null);
    } on DioException catch (e) {
      return (
        null,
        ServerFailure(e.response?.data?['error'] ?? 'Error de red'),
      );
    } catch (e) {
      return (null, ServerFailure(e.toString()));
    }
  }

  @override
  Future<(List<Order>?, Failure?)> getAdminOrders({
    String? status,
    int? limit,
    int? offset,
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (status != null) queryParams['status'] = status;
      if (limit != null) queryParams['limit'] = limit;
      if (offset != null) queryParams['offset'] = offset;

      final response = await client.dio.get(
        '/orders',
        queryParameters: queryParams,
      );
      final data = response.data as Map<String, dynamic>;
      final listJson = data['orders'] as List? ?? [];
      final orders = listJson
          .map((item) => OrderModel.fromJson(item as Map<String, dynamic>))
          .toList();
      return (orders, null);
    } on DioException catch (e) {
      return (
        null,
        ServerFailure(e.response?.data?['error'] ?? 'Error de red'),
      );
    } catch (e) {
      return (null, ServerFailure(e.toString()));
    }
  }

  @override
  Future<(Order?, Failure?)> getOrderDetails(String id) async {
    try {
      final response = await client.dio.get('/orders/$id');
      final data = response.data as Map<String, dynamic>;
      final order = OrderModel.fromJson(data['order'] as Map<String, dynamic>);
      return (order, null);
    } on DioException catch (e) {
      return (
        null,
        ServerFailure(e.response?.data?['error'] ?? 'Error de red'),
      );
    } catch (e) {
      return (null, ServerFailure(e.toString()));
    }
  }

  @override
  Future<(Order?, Failure?)> updateOrderStatus(String id, String status) async {
    try {
      final response = await client.dio.patch(
        '/orders/$id/status',
        data: {'status': status},
      );
      final data = response.data as Map<String, dynamic>;
      final order = OrderModel.fromJson(data['order'] as Map<String, dynamic>);
      return (order, null);
    } on DioException catch (e) {
      final errorMsg = e.response?.data is Map
          ? (e.response?.data['error'] ?? 'Error al actualizar estado')
          : 'Error de servidor';
      return (null, ServerFailure(errorMsg));
    } catch (e) {
      return (null, ServerFailure(e.toString()));
    }
  }
}
