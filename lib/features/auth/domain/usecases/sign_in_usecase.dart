import 'package:connectu_alumni_platform/features/auth/domain/entities/auth_user.dart';
import 'package:connectu_alumni_platform/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository repository;

  SignInUseCase(this.repository);

  Future<AuthUser> call(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw ArgumentError('Email and password cannot be empty');
    }
    
    if (!_isValidEmail(email)) {
      throw ArgumentError('Invalid email format');
    }
    
    if (password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters');
    }
    
    return await repository.signInWithEmail(email, password);
  }
  
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
}
