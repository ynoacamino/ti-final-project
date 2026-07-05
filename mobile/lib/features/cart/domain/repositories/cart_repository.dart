import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/cart/domain/entities/cart.dart';

abstract class CartRepository {
  /// Retrieves the active shopping cart (supports optional session_id for guest checkout).
  Future<(Cart?, Failure?)> getCart({String? sessionId});

  /// Adds a product variant to the cart.
  Future<(Cart?, Failure?)> addItemToCart({
    required String productVariantId,
    required int quantity,
    String? sessionId,
  });

  /// Updates quantity of an existing item in the cart.
  Future<(Cart?, Failure?)> updateCartItemQuantity({
    required String cartItemId,
    required int quantity,
  });

  /// Deletes an item from the cart.
  Future<(Cart?, Failure?)> removeItemFromCart(String cartItemId);

  /// Performs checkout and creates a pending order, returning the clientSecret for Stripe payment.
  Future<(Map<String, dynamic>?, Failure?)> checkout({
    required String cartId,
    required Map<String, dynamic> shippingAddress,
    String? guestEmail,
    String? guestName,
    String? guestPhone,
    String? notes,
  });

  /// Confirms Stripe payment success with backend.
  Future<(Map<String, dynamic>?, Failure?)> confirmPayment(
    String stripePaymentIntentId,
  );
}
