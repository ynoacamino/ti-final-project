import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/orders/domain/entities/order.dart';

abstract class OrdersRepository {
  /// Fetches orders associated with the currently authenticated customer.
  Future<(List<Order>?, Failure?)> getCustomerOrders({int? limit, int? offset});

  /// Administrative operation to list all orders (supports status filtering).
  Future<(List<Order>?, Failure?)> getAdminOrders({
    String? status,
    int? limit,
    int? offset,
  });

  /// Fetches full details for a single order by ID.
  Future<(Order?, Failure?)> getOrderDetails(String id);

  /// Administrative operation to update order status (verifying sequential flow).
  Future<(Order?, Failure?)> updateOrderStatus(String id, String status);
}
