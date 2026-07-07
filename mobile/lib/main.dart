import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mobile/core/router/app_router.dart';
import 'package:mobile/core/theme/app_theme.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set Stripe publishable key (standard sandbox key for local mockup checkout flow)
  Stripe.publishableKey =
      'pk_test_51P1t2X2K3L4M5N6O7P8Q9R0S1T2U3V4W5X6Y7Z8A9B0C1D2E3F4G5H6I7J8K9L';

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final isAdmin = authState.user?.role == 'admin';

    return MaterialApp.router(
      title: 'SmartPyME',
      debugShowCheckedModeBanner: false,
      theme: isAdmin ? AppTheme.darkTheme : AppTheme.lightTheme,
      routerConfig: appRouter,
    );
  }
}

