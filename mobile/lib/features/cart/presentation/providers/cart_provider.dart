import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/cart/data/repositories/cart_repository_impl.dart';
import 'package:mobile/features/cart/domain/entities/cart.dart';
import 'package:mobile/features/cart/domain/repositories/cart_repository.dart';
import 'package:uuid/uuid.dart';

final cartRepositoryProvider = Provider<CartRepository>((ref) {
  return CartRepositoryImpl(ref.watch(dioClientProvider));
});

/// Generates or loads a persistent anonymous Session ID for guest carts.
final sessionIdProvider = FutureProvider<String>((ref) async {
  final storage = ref.watch(secureStorageProvider);
  String? id = await storage.read(key: 'session_id');
  if (id == null) {
    id = const Uuid().v4();
    await storage.write(key: 'session_id', value: id);
  }
  return id;
});

class CartNotifier extends StateNotifier<AsyncValue<Cart?>> {
  final CartRepository _repository;
  final Ref _ref;

  CartNotifier(this._repository, this._ref)
    : super(const AsyncValue.loading()) {
    loadCart();
  }

  Future<void> loadCart() async {
    state = const AsyncValue.loading();
    // Check if user is authenticated
    final authState = _ref.read(authProvider);
    String? sId;
    if (authState.user == null) {
      sId = await _ref.read(sessionIdProvider.future);
    }

    final (cart, failure) = await _repository.getCart(sessionId: sId);
    if (failure != null) {
      state = AsyncValue.error(failure.message, StackTrace.current);
    } else {
      state = AsyncValue.data(cart);
    }
  }

  Future<bool> addItem(String productVariantId, int quantity) async {
    final authState = _ref.read(authProvider);
    String? sId;
    if (authState.user == null) {
      sId = await _ref.read(sessionIdProvider.future);
    }

    final (updatedCart, failure) = await _repository.addItemToCart(
      productVariantId: productVariantId,
      quantity: quantity,
      sessionId: sId,
    );

    if (failure != null) {
      return false;
    } else {
      state = AsyncValue.data(updatedCart);
      return true;
    }
  }

  Future<bool> updateQuantity(String cartItemId, int quantity) async {
    final (updatedCart, failure) = await _repository.updateCartItemQuantity(
      cartItemId: cartItemId,
      quantity: quantity,
    );

    if (failure != null) {
      return false;
    } else {
      state = AsyncValue.data(updatedCart);
      return true;
    }
  }

  Future<bool> removeItem(String cartItemId) async {
    final (updatedCart, failure) = await _repository.removeItemFromCart(
      cartItemId,
    );

    if (failure != null) {
      return false;
    } else {
      state = AsyncValue.data(updatedCart);
      return true;
    }
  }

  Future<void> clearCart() async {
    // Reloads to verify or clears local state
    state = const AsyncValue.data(null);
    await loadCart();
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, AsyncValue<Cart?>>((
  ref,
) {
  return CartNotifier(ref.watch(cartRepositoryProvider), ref);
});
