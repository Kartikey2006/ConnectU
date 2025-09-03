enum UserRole { student, alumni, admin }

class User {
  final int id;
  final String name;
  final String email;
  final UserRole role;
  final DateTime createdAt;
  final String? profileImageUrl;
  final String? bio;
  final String? phoneNumber;

  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.createdAt,
    this.profileImageUrl,
    this.bio,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: UserRole.values.firstWhere(
        (role) => role.name == json['role'],
        orElse: () => UserRole.student,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      profileImageUrl: json['profile_image_url'] as String?,
      bio: json['bio'] as String?,
      phoneNumber: json['phone_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role.name,
      'created_at': createdAt.toIso8601String(),
      'profile_image_url': profileImageUrl,
      'bio': bio,
      'phone_number': phoneNumber,
    };
  }

  User copyWith({
    int? id,
    String? name,
    String? email,
    UserRole? role,
    DateTime? createdAt,
    String? profileImageUrl,
    String? bio,
    String? phoneNumber,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      phoneNumber: phoneNumber ?? this.phoneNumber,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is User && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, role: $role)';
  }
}
