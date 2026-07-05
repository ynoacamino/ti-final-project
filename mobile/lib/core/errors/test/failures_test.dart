import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/errors/failures.dart';

void main() {
  group('Failures', () {
    test('ServerFailure holds correct message', () {
      const failure = ServerFailure('Internal Server Error');
      expect(failure.message, 'Internal Server Error');
    });

    test('ValidationFailure holds errors map', () {
      final errors = {
        'email': ['Invalid email format']
      };
      final failure = ValidationFailure('Validation error', errors: errors);
      expect(failure.message, 'Validation error');
      expect(failure.errors, errors);
    });

    test('AuthFailure holds message', () {
      const failure = AuthFailure('Invalid credentials');
      expect(failure.message, 'Invalid credentials');
    });
  });
}
