import 'package:mobile/core/errors/failures.dart';
import 'package:mobile/features/auth/domain/entities/user.dart';

/// Repository port defining authentication operations.
abstract class AuthRepository {
  /// Authenticates user and returns User profile on success, or Failure on error.
  Future<(User?, Failure?)> login(String email, String password);

  /// Registers a new customer user and returns User profile on success, or Failure on error.
  Future<(User?, Failure?)> register(
    String name,
    String email,
    String password,
  );

  /// Verifies current stored session/JWT and returns the active User profile if valid.
  Future<(User?, Failure?)> getCurrentUser();

  /// Destroys secure storage tokens and ends the session.
  Future<void> logout();
}
