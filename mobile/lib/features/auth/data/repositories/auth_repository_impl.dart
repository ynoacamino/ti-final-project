import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:mobile/features/auth/data/models/user_model.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';
import 'package:mobile/features/auth/domain/repositories/auth_repository.dart';

/// Concrete implementation of the AuthRepository.
/// Integrates storage operations and network services to manage sessions.
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDatasource remoteDatasource;
  final FlutterSecureStorage secureStorage;

  AuthRepositoryImpl({
    required this.remoteDatasource,
    required this.secureStorage,
  });

  @override
  Future<(User?, Failure?)> login(String email, String password) async {
    try {
      final data = await remoteDatasource.login(email, password);
      final token = data['token'] as String;
      await secureStorage.write(key: 'jwt_token', value: token);

      final userJson = data['user'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userJson);
      return (user, null);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        return (null, const AuthFailure('Correo o contraseña incorrectos'));
      }
      final errorMsg = e.response?.data is Map
          ? (e.response?.data['error'] ?? 'Error de inicio de sesión')
          : 'Error de servidor';
      return (null, ServerFailure(errorMsg));
    } catch (e) {
      return (null, ServerFailure(e.toString()));
    }
  }

  @override
  Future<(User?, Failure?)> register(
    String name,
    String email,
    String password,
  ) async {
    try {
      final data = await remoteDatasource.register(name, email, password);
      // Backend registration doesn't login automatically; it returns user info.
      // So we map it.
      final userJson = data['user'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userJson);
      return (user, null);
    } on DioException catch (e) {
      final errorMsg = e.response?.data is Map
          ? (e.response?.data['error'] ?? 'Error al registrarse')
          : 'Error de servidor';
      return (null, ServerFailure(errorMsg));
    } catch (e) {
      return (null, ServerFailure(e.toString()));
    }
  }

  @override
  Future<(User?, Failure?)> getCurrentUser() async {
    try {
      final token = await secureStorage.read(key: 'jwt_token');
      if (token == null) {
        return (null, const AuthFailure('No active session'));
      }

      final data = await remoteDatasource.getCurrentUser();
      final userJson = data['user'] as Map<String, dynamic>;
      final user = UserModel.fromJson(userJson);
      return (user, null);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await secureStorage.delete(key: 'jwt_token');
        return (null, const AuthFailure('La sesión ha expirado'));
      }
      return (null, ServerFailure('No se pudo verificar la sesión'));
    } catch (e) {
      return (null, ServerFailure(e.toString()));
    }
  }

  @override
  Future<void> logout() async {
    await secureStorage.delete(key: 'jwt_token');
  }
}
