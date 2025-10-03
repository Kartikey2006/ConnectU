import 'package:flutter/material.dart';
import 'package:connectu_alumni_platform/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:connectu_alumni_platform/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:connectu_alumni_platform/features/auth/data/datasources/auth_local_datasource.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print('🧪 Testing signup functionality...');
  
  try {
    // Create repository
    final repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(),
      localDataSource: AuthLocalDataSourceImpl(),
    );
    
    // Test signup
    print('📝 Attempting to sign up test user...');
    final user = await repository.signUpWithEmail(
      'test@example.com',
      'password123',
      'Test User',
      'student',
    );
    
    print('✅ Signup successful!');
    print('User: ${user.user.name} (${user.user.email})');
    print('Role: ${user.user.role}');
    
  } catch (e) {
    print('❌ Signup failed: $e');
  }
}
