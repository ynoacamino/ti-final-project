/// Represents a User domain entity on mobile.
class User {
  final String id;
  final String email;
  final String name;
  final String role; // 'admin' or 'customer'
  final bool isActive;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    required this.isActive,
  });
}
