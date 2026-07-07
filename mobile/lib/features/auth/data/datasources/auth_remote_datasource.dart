import 'package:mobile/core/network/dio_client.dart';

/// Calls the Hono backend Auth endpoints.
class AuthRemoteDatasource {
  final DioClient _client;

  AuthRemoteDatasource(this._client);

  /// POST /api/auth/login
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await _client.dio.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );
    return response.data as Map<String, dynamic>;
  }

  /// POST /api/auth/register
  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await _client.dio.post(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'role': 'customer',
      },
    );
    return response.data as Map<String, dynamic>;
  }

  /// GET /api/auth/me
  Future<Map<String, dynamic>> getCurrentUser() async {
    final response = await _client.dio.get('/auth/me');
    return response.data as Map<String, dynamic>;
  }
}
