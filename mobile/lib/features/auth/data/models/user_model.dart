import 'package:mobile/features/auth/domain/entities/user.dart';

/// Data Transfer Object (DTO) for User entity.
/// Implements standard serialization mapping from backend JSON schemas.
class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.role,
    required super.isActive,
  });

  /// Factory helper mapping JSON keys to User instance.
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      isActive: json['isActive'] == 1 || json['isActive'] == true,
    );
  }

  /// Maps UserModel to standard serializable JSON Map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      'isActive': isActive ? 1 : 0,
    };
  }
}
