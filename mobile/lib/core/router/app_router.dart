import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/core/widgets/main_navigation_shell.dart';
import 'package:mobile/features/auth/presentation/pages/onboarding_page.dart';
import 'package:mobile/features/auth/presentation/pages/login_page.dart';
import 'package:mobile/features/auth/presentation/pages/register_page.dart';
import 'package:mobile/features/catalog/presentation/pages/home_page.dart';
import 'package:mobile/features/catalog/presentation/pages/catalog_page.dart';
import 'package:mobile/features/catalog/presentation/pages/product_detail_page.dart';
import 'package:mobile/features/cart/presentation/pages/cart_page.dart';
import 'package:mobile/features/cart/presentation/pages/checkout_page.dart';
import 'package:mobile/features/cart/presentation/pages/order_confirmation_page.dart';
import 'package:mobile/features/orders/presentation/pages/my_orders_page.dart';
import 'package:mobile/features/orders/presentation/pages/admin_orders_page.dart';
import 'package:mobile/features/dashboard/presentation/pages/admin_dashboard_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/onboarding',
  routes: [
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterPage(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainNavigationShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/catalog',
              builder: (context, state) => const CatalogPage(),
              routes: [
                GoRoute(
                  path: 'product/:slug',
                  builder: (context, state) {
                    final slug = state.pathParameters['slug'] ?? '';
                    return ProductDetailPage(slug: slug);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/cart',
              builder: (context, state) => const CartPage(),
              routes: [
                GoRoute(
                  path: 'checkout',
                  builder: (context, state) => const CheckoutPage(),
                ),
                GoRoute(
                  path: 'order-confirmation/:id',
                  builder: (context, state) {
                    final orderId = state.pathParameters['id'] ?? '';
                    return OrderConfirmationPage(orderId: orderId);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const MyOrdersPage(),
            ),
          ],
        ),
      ],
    ),
    // Admin routes
    GoRoute(
      path: '/admin/dashboard',
      builder: (context, state) => const AdminDashboardPage(),
    ),
    GoRoute(
      path: '/admin/orders',
      builder: (context, state) => const AdminOrdersPage(),
    ),
  ],
);
