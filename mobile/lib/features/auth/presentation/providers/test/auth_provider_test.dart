import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/providers/auth_provider.dart';
import 'package:mobile/features/auth/presentation/providers/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StubAuthRepository implements AuthRepository {
  User? currentUser;
  String? loginEmail;
  String? loginPassword;
  bool throwError = false;

  @override
  Future<(User?, Failure?)> getCurrentUser() async {
    if (throwError) return (null, const AuthFailure('Failed to fetch user'));
    return (currentUser, null);
  }

  @override
  Future<(User?, Failure?)> login(String email, String password) async {
    loginEmail = email;
    loginPassword = password;
    if (throwError) return (null, const AuthFailure('Invalid credentials'));
    return (currentUser, null);
  }

  @override
  Future<(User?, Failure?)> register(String name, String email, String password) async {
    if (throwError) return (null, const AuthFailure('Registration failed'));
    return (currentUser, null);
  }

  @override
  Future<void> logout() async {
    currentUser = null;
  }
}

void main() {
  group('AuthNotifier Unit Tests', () {
    late StubAuthRepository stubRepo;
    late ProviderContainer container;

    setUp(() {
      stubRepo = StubAuthRepository();
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(stubRepo),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('initial state is authenticating/checking', () {
      final state = container.read(authProvider);
      expect(state.status, AuthStatus.authenticating);
    });

    test('checkAuth handles unauthenticated user correctly', () async {
      stubRepo.currentUser = null;
      
      final notifier = container.read(authProvider.notifier);
      await notifier.checkAuth();
      
      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
    });

    test('checkAuth handles authenticated user correctly', () async {
      const mockUser = User(id: 'u-1', name: 'Alvaro', email: 'alvaro@test.com', role: 'customer', isActive: true);
      stubRepo.currentUser = mockUser;

      final notifier = container.read(authProvider.notifier);
      await notifier.checkAuth();

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user, mockUser);
    });

    test('login success sets authenticated user', () async {
      const mockUser = User(id: 'u-2', name: 'Admin User', email: 'admin@test.com', role: 'admin', isActive: true);
      stubRepo.currentUser = mockUser;

      final notifier = container.read(authProvider.notifier);
      final result = await notifier.login('admin@test.com', 'secret');

      expect(result, isTrue);
      expect(stubRepo.loginEmail, 'admin@test.com');
      expect(stubRepo.loginPassword, 'secret');
      
      final state = container.read(authProvider);
      expect(state.status, AuthStatus.authenticated);
      expect(state.user, mockUser);
    });

    test('login failure sets error state', () async {
      stubRepo.throwError = true;

      final notifier = container.read(authProvider.notifier);
      final result = await notifier.login('bad@test.com', 'wrong');

      expect(result, isFalse);
      
      final state = container.read(authProvider);
      expect(state.status, AuthStatus.error);
      expect(state.errorMessage, 'Invalid credentials');
    });

    test('logout clears credentials and sets unauthenticated', () async {
      const mockUser = User(id: 'u-1', name: 'Alvaro', email: 'alvaro@test.com', role: 'customer', isActive: true);
      stubRepo.currentUser = mockUser;

      final notifier = container.read(authProvider.notifier);
      await notifier.checkAuth(); // authenticate first

      await notifier.logout();

      final state = container.read(authProvider);
      expect(state.status, AuthStatus.unauthenticated);
      expect(state.user, isNull);
    });
  });
}
