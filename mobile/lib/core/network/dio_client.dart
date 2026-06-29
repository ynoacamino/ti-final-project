import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Client wrapper around Dio for HTTP requests.
/// Implements auto-token injection interceptors and dynamic base URL detection.
class DioClient {
  final Dio dio;
  final FlutterSecureStorage _storage;

  DioClient({
    Dio? dio,
    FlutterSecureStorage? storage,
  })  : dio = dio ?? Dio(),
        _storage = storage ?? const FlutterSecureStorage() {
    _initClient();
  }

  void _initClient() {
    dio.options.baseUrl = _getBaseUrl();
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    // Add interceptor to inject JWT token automatically
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await _storage.read(key: 'jwt_token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (e, handler) {
          if (kDebugMode) {
            print('🔴 [Dio Error] ${e.requestOptions.method} ${e.requestOptions.path} : Status ${e.response?.statusCode}');
            print('Response body: ${e.response?.data}');
          }
          return handler.next(e);
        },
      ),
    );
  }

  String _getBaseUrl() {
    if (kIsWeb) {
      return 'http://localhost:3000/api';
    }
    try {
      if (Platform.isAndroid) {
        // Android Emulator loopback alias
        return 'http://10.0.2.2:3000/api';
      }
    } catch (_) {
      // Fallback if Platform is not available (e.g. mock tests)
    }
    return 'http://localhost:3000/api';
  }
}
