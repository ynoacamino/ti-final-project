/// Represents core failures in the application.
abstract class Failure {
  final String message;
  const Failure(this.message);
}

/// Failure occurring due to server-side errors or network unavailability.
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

/// Failure occurring due to invalid inputs or request structure (e.g. 400 Bad Request).
class ValidationFailure extends Failure {
  final Map<String, List<String>> errors;
  const ValidationFailure(super.message, {this.errors = const {}});
}

/// Failure occurring due to invalid credentials (e.g. 401 Unauthorized).
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

/// Failure occurring due to access restrictions (e.g. 403 Forbidden).
class PermissionFailure extends Failure {
  const PermissionFailure(super.message);
}

/// Failure occurring due to missing resource (e.g. 404 Not Found).
class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}

/// Failure occurring when local storage cache/secure operations fail.
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}
