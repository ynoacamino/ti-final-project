import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/core/network/dio_client.dart';
import 'package:mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mobile/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';
import 'package:mobile/features/auth/presentation/providers/auth_state.dart';

final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

final dioClientProvider = Provider<DioClient>((ref) {
  return DioClient(storage: ref.watch(secureStorageProvider));
});

final authRemoteDatasourceProvider = Provider<AuthRemoteDatasource>((ref) {
  return AuthRemoteDatasource(ref.watch(dioClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(
    remoteDatasource: ref.watch(authRemoteDatasourceProvider),
    secureStorage: ref.watch(secureStorageProvider),
  );
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(AuthState.initial()) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    state = AuthState.authenticating();
    final (user, _) = await _repository.getCurrentUser();
    if (user != null) {
      state = AuthState.authenticated(user);
    } else {
      state = AuthState.unauthenticated();
    }
  }

  Future<bool> login(String email, String password) async {
    state = AuthState.authenticating();
    final (user, failure) = await _repository.login(email, password);
    if (user != null) {
      state = AuthState.authenticated(user);
      return true;
    } else {
      state = AuthState.error(failure?.message ?? 'Error de inicio de sesión');
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = AuthState.authenticating();
    final (user, failure) = await _repository.register(name, email, password);
    if (user != null) {
      // In Hono register doesn't log in automatically, so we call login right after.
      return await login(email, password);
    } else {
      state = AuthState.error(failure?.message ?? 'Error de registro');
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    state = AuthState.unauthenticated();
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});
