import 'package:dio/dio.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/features/cart/data/models/cart_model.dart';
import 'package:mobile/features/cart/domain/entities/cart.dart';
import 'package:mobile/features/cart/domain/repositories/cart_repository.dart';

class CartRepositoryImpl implements CartRepository {
  final DioClient client;

  CartRepositoryImpl(this.client);

  @override
  Future<(Cart?, Failure?)> getCart({String? sessionId}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (sessionId != null) queryParams['session_id'] = sessionId;

      final response = await client.dio.get(
        '/cart',
        queryParameters: queryParams,
      );
      final data = response.data as Map<String, dynamic>;
      final cart = CartModel.fromJson(data['cart'] as Map<String, dynamic>);
      return (cart, null);
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
  Future<(Cart?, Failure?)> addItemToCart({
    required String productVariantId,
    required int quantity,
    String? sessionId,
  }) async {
    try {
      final response = await client.dio.post(
        '/cart/items',
        data: {
          'productVariantId': productVariantId,
          'quantity': quantity,
          if (sessionId != null) 'sessionId': sessionId,
        },
      );
      final data = response.data as Map<String, dynamic>;
      final cart = CartModel.fromJson(data['cart'] as Map<String, dynamic>);
      return (cart, null);
    } on DioException catch (e) {
      final errorMsg = e.response?.data is Map
          ? (e.response?.data['error'] ?? 'Error al añadir al carrito')
          : 'Error de servidor';
      return (null, ServerFailure(errorMsg));
    } catch (e) {
      return (null, ServerFailure(e.toString()));
    }
  }

  @override
  Future<(Cart?, Failure?)> updateCartItemQuantity({
    required String cartItemId,
    required int quantity,
  }) async {
    try {
      final response = await client.dio.patch(
        '/cart/items/$cartItemId',
        data: {'quantity': quantity},
      );
      final data = response.data as Map<String, dynamic>;
      final cart = CartModel.fromJson(data['cart'] as Map<String, dynamic>);
      return (cart, null);
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
  Future<(Cart?, Failure?)> removeItemFromCart(String cartItemId) async {
    try {
      final response = await client.dio.delete('/cart/items/$cartItemId');
      final data = response.data as Map<String, dynamic>;
      final cart = CartModel.fromJson(data['cart'] as Map<String, dynamic>);
      return (cart, null);
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
  Future<(Map<String, dynamic>?, Failure?)> checkout({
    required String cartId,
    required Map<String, dynamic> shippingAddress,
    String? guestEmail,
    String? guestName,
    String? guestPhone,
    String? notes,
  }) async {
    try {
      final response = await client.dio.post(
        '/checkout',
        data: {
          'cartId': cartId,
          'shippingAddress': shippingAddress,
          if (guestEmail != null) 'guestEmail': guestEmail,
          if (guestName != null) 'guestName': guestName,
          if (guestPhone != null) 'guestPhone': guestPhone,
          if (notes != null) 'notes': notes,
        },
      );
      return (response.data as Map<String, dynamic>, null);
    } on DioException catch (e) {
      final errorMsg = e.response?.data is Map
          ? (e.response?.data['error'] ?? 'Error en checkout')
          : 'Error de servidor';
      return (null, ServerFailure(errorMsg));
    } catch (e) {
      return (null, ServerFailure(e.toString()));
    }
  }

  @override
  Future<(Map<String, dynamic>?, Failure?)> confirmPayment(
    String stripePaymentIntentId,
  ) async {
    try {
      final response = await client.dio.post(
        '/payments/confirm',
        data: {'stripePaymentIntentId': stripePaymentIntentId},
      );
      return (response.data as Map<String, dynamic>, null);
    } on DioException catch (e) {
      return (
        null,
        ServerFailure(e.response?.data?['error'] ?? 'Error al confirmar pago'),
      );
    } catch (e) {
      return (null, ServerFailure(e.toString()));
    }
  }
}
