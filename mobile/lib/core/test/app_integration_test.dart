import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/presentation/providers/auth_state.dart';
import 'package:mobile/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:mobile/features/catalog/domain/entities/category.dart';
import 'package:mobile/features/catalog/domain/entities/product.dart';
import 'package:mobile/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:mobile/features/cart/domain/repositories/cart_repository.dart';
import 'package:mobile/features/cart/domain/entities/cart.dart';
import 'package:mobile/features/cart/presentation/providers/cart_provider.dart';
import 'package:mobile/main.dart';
import 'package:mobile/core/errors/failures.dart';

// Stubs for all repositories
class StubAuthRepository implements AuthRepository {
  User? currentUser;
  @override
  Future<(User?, Failure?)> getCurrentUser() async => (currentUser, null);
  @override
  Future<(User?, Failure?)> login(String email, String password) async {
    print('StubAuthRepository.login called with email: $email');
    currentUser = const User(
      id: 'u-1',
      name: 'Alvaro Test',
      email: 'alvaro@test.com',
      role: 'customer',
      isActive: true,
    );
    return (currentUser, null);
  }

  @override
  Future<(User?, Failure?)> register(
    String name,
    String email,
    String password,
  ) async => (null, null);
  @override
  Future<void> logout() async => currentUser = null;
}

class StubCatalogRepository implements CatalogRepository {
  @override
  Future<(List<Category>?, Failure?)> getCategories() async {
    final List<Category> cats = [];
    return (cats, null);
  }

  @override
  Future<(List<Product>?, Failure?)> getProducts({
    String? categoryId,
    String? query,
  }) async {
    final List<Product> prods = [
      const Product(
        id: 'p-1',
        name: 'Camisa Elegante Purpura',
        slug: 'camisa-elegante-purpura',
        description: 'Una camisa refinada de color purpura.',
        basePrice: 4500,
        categoryId: 'cat-1',
        images: [],
        variants: [],
      ),
    ];
    return (prods, null);
  }

  @override
  Future<(Product?, Failure?)> getProductBySlug(String slug) async =>
      (null, null);
  @override
  Future<(bool, Failure?)> updateVariantStock(
    String variantId,
    int newStock,
  ) async => (true, null);

  @override
  Future<(bool, Failure?)> createCategory(
    String name,
    String? description,
  ) async => (true, null);

  @override
  Future<(Product?, Failure?)> createProduct({
    required String name,
    required String description,
    required int basePrice,
    required String categoryId,
    required List<Map<String, dynamic>> variants,
  }) async => (null, null);

  @override
  Future<(bool, Failure?)> deleteProduct(String productId) async =>
      (true, null);
}

class StubCartRepository implements CartRepository {
  @override
  Future<(Cart?, Failure?)> getCart({String? sessionId}) async =>
      (const Cart(id: 'c-1', status: 'active', items: []), null);
  @override
  Future<(Cart?, Failure?)> addItemToCart({
    required String productVariantId,
    required int quantity,
    String? sessionId,
  }) async => (null, null);
  @override
  Future<(Cart?, Failure?)> updateCartItemQuantity({
    required String cartItemId,
    required int quantity,
  }) async => (null, null);
  @override
  Future<(Cart?, Failure?)> removeItemFromCart(String cartItemId) async =>
      (null, null);
  @override
  Future<(Map<String, dynamic>?, Failure?)> checkout({
    required String cartId,
    required Map<String, dynamic> shippingAddress,
    String? guestEmail,
    String? guestName,
    String? guestPhone,
    String? notes,
  }) async => (null, null);
  @override
  Future<(Map<String, dynamic>?, Failure?)> confirmPayment(
    String stripePaymentIntentId,
  ) async => (null, null);
}

void main() {
  group('App E2E Integration Flow Tests', () {
    testWidgets('Full User Onboarding, Navigation, and Login Flow', (
      WidgetTester tester,
    ) async {
      final authRepo = StubAuthRepository();
      final catalogRepo = StubCatalogRepository();
      final cartRepo = StubCartRepository();

      // Pump the App wrapped in ProviderScope with overridden repositories
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            authRepositoryProvider.overrideWithValue(authRepo),
            catalogRepositoryProvider.overrideWithValue(catalogRepo),
            cartRepositoryProvider.overrideWithValue(cartRepo),
            sessionIdProvider.overrideWith((ref) => 'test-session-id'),
          ],
          child: const MyApp(),
        ),
      );

      // 1. Verify we start on Onboarding Screen
      await tester.pumpAndSettle();
      expect(find.text('Descubre moda que se adapta a ti'), findsOneWidget);

      // 2. Click "Siguiente" to navigate to Login
      // Locate the start button
      final beginButton = find.text('Siguiente');
      expect(beginButton, findsOneWidget);
      await tester.ensureVisible(beginButton);
      await tester.tap(beginButton);
      await tester.pumpAndSettle();

      // 3. Verify we are on the Login Screen
      expect(find.text('MODA INTELIGENTE PARA TI'), findsOneWidget);

      // 4. Enter credentials
      await tester.enterText(find.byType(TextField).at(0), 'alvaro@test.com');
      await tester.enterText(find.byType(TextField).at(1), 'password123');
      await tester.pump();

      // 5. Tap the Login button
      final loginBtn = find.widgetWithText(ElevatedButton, 'Iniciar sesión');
      expect(loginBtn, findsOneWidget);
      await tester.tap(loginBtn);

      // Pump to trigger authenticating state
      await tester.pump();

      // Let it settle transition by pumping multiple times to process async navigation
      for (int i = 0; i < 10; i++) {
        await tester.pump(const Duration(milliseconds: 100));
      }

      // 6. Verify we successfully navigate to the Main app shell (Home screen)
      // Since Home screen is loaded, it should display the navbar items and title
      expect(find.text('Categorías'), findsOneWidget);
      expect(find.text('Novedades para Ti'), findsOneWidget);
      expect(find.text('Inicio'), findsOneWidget);
      expect(find.text('Catálogo'), findsOneWidget);
    });
  });
}
