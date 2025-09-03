import 'package:connectu_alumni_platform/features/auth/domain/entities/auth_user.dart';
import 'package:connectu_alumni_platform/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  final AuthRepository repository;

  SignUpUseCase(this.repository);

  Future<AuthUser> call({
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String role,
  }) async {
    // Validation
    if (email.isEmpty || password.isEmpty || name.isEmpty || role.isEmpty) {
      throw ArgumentError('All fields are required');
    }
    
    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }
    
    if (password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }
    
    if (password != confirmPassword) {
      throw ArgumentError('Passwords do not match');
    }
    
    if (name.length < 2) {
      throw ArgumentError('Name must be at least 2 characters');
    }
    
    if (!['student', 'alumni'].contains(role.toLowerCase())) {
      throw ArgumentError('Invalid role. Must be student or alumni');
    }
    
    return await repository.signUpWithEmail(email, password, name, role);
  }
  
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
