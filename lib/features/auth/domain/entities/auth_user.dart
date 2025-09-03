import 'package:connectu_alumni_platform/core/models/user.dart';

class AuthUser {
  final User user;
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  const AuthUser({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  bool get isStudent => user.role == UserRole.student;
  bool get isAlumni => user.role == UserRole.alumni;
  bool get isAdmin => user.role == UserRole.admin;

  AuthUser copyWith({
    User? user,
    String? accessToken,
    String? refreshToken,
    DateTime? expiresAt,
  }) {
    return AuthUser(
      user: user ?? this.user,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthUser && other.user.id == user.id;
  }

  @override
  int get hashCode => user.id.hashCode;

  @override
  String toString() {
    return 'AuthUser(user: ${user.name}, role: ${user.role})';
  }
}
