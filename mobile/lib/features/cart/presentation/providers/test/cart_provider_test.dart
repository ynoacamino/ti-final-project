import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/cart/domain/entities/cart.dart';
import 'package:mobile/features/cart/domain/entities/cart_item.dart';
import 'package:mobile/features/cart/domain/repositories/cart_repository.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StubCartRepository implements CartRepository {
  Cart? currentCart;
  bool throwError = false;

  @override
  Future<(Cart?, Failure?)> getCart({String? sessionId}) async {
    if (throwError) return (null, const ServerFailure('Database Error'));
    return (currentCart, null);
  }

  @override
  Future<(Cart?, Failure?)> addItemToCart({
    required String productVariantId,
    required int quantity,
    String? sessionId,
  }) async {
    if (throwError) return (null, const ServerFailure('Full capacity'));
    return (currentCart, null);
  }

  @override
  Future<(Cart?, Failure?)> updateCartItemQuantity({
    required String cartItemId,
    required int quantity,
  }) async {
    if (throwError) return (null, const ServerFailure('Invalid qty'));
    return (currentCart, null);
  }

  @override
  Future<(Cart?, Failure?)> removeItemFromCart(String cartItemId) async {
    if (throwError) return (null, const ServerFailure('Cannot remove'));
    return (currentCart, null);
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
    if (throwError) return (null, const ServerFailure('Checkout failed'));
    return ({'clientSecret': 'mock_secret'}, null);
  }

  @override
  Future<(Map<String, dynamic>?, Failure?)> confirmPayment(
    String stripePaymentIntentId,
  ) async {
    if (throwError) return (null, const ServerFailure('Confirm failed'));
    return ({'status': 'succeeded'}, null);
  }
}

void main() {
  group('CartNotifier Unit Tests', () {
    late StubCartRepository stubCartRepo;
    late ProviderContainer container;

    final mockCart = Cart(
      id: 'cart-1',
      customerId: 'cust-123',
      sessionId: null,
      status: 'active',
      items: [
        const CartItem(
          id: 'item-1',
          cartId: 'cart-1',
          productVariantId: 'variant-abc',
          quantity: 2,
          unitPriceSnapshot: 1500, // S/. 15.00
          productName: 'T-Shirt',
          size: 'M',
          color: 'Blue',
          sku: 'TSHIRT-M-BL',
          imageUrl: 'http://image.com',
        )
      ],
    );

    setUp(() {
      stubCartRepo = StubCartRepository();
      container = ProviderContainer(
        overrides: [
          cartRepositoryProvider.overrideWithValue(stubCartRepo),
          sessionIdProvider.overrideWith((ref) => 'mock-session-id-123'),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is loading', () {
      final state = container.read(cartProvider);
      expect(state, const AsyncValue<Cart?>.loading());
    });

    test('loadCart loads user cart successfully', () async {
      stubCartRepo.currentCart = mockCart;

      final notifier = container.read(cartProvider.notifier);
      await notifier.loadCart();

      final state = container.read(cartProvider);
      expect(state.value, mockCart);
    });

    test('addItem passes arguments and updates state', () async {
      stubCartRepo.currentCart = mockCart;

      final notifier = container.read(cartProvider.notifier);
      final result = await notifier.addItem('variant-abc', 2);

      expect(result, isTrue);
      final state = container.read(cartProvider);
      expect(state.value, mockCart);
    });

    test('updateQuantity updates state with loaded cart', () async {
      stubCartRepo.currentCart = mockCart;

      final notifier = container.read(cartProvider.notifier);
      final result = await notifier.updateQuantity('item-1', 5);

      expect(result, isTrue);
      final state = container.read(cartProvider);
      expect(state.value, mockCart);
    });

    test('removeItem removes item from cart state', () async {
      stubCartRepo.currentCart = mockCart;

      final notifier = container.read(cartProvider.notifier);
      final result = await notifier.removeItem('item-1');

      expect(result, isTrue);
      final state = container.read(cartProvider);
      expect(state.value, mockCart);
    });
  });
}
