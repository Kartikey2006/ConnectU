import 'package:connectu_alumni_platform/features/auth/domain/entities/auth_user.dart';
import 'package:connectu_alumni_platform/features/auth/domain/repositories/auth_repository.dart';
import 'package:connectu_alumni_platform/features/auth/data/datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<AuthUser> signInWithEmail(String email, String password) async {
    return await remoteDataSource.signInWithEmail(email, password);
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    return await remoteDataSource.signInWithGoogle();
  }

  @override
  Future<AuthUser> signUpWithEmail(String email, String password, String name, String role) async {
    return await remoteDataSource.signUpWithEmail(email, password, name, role);
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    return await remoteDataSource.getCurrentUser();
  }

  @override
  Future<AuthUser> refreshToken(String refreshToken) async {
    return await remoteDataSource.refreshToken(refreshToken);
  }

  @override
  Future<bool> isAuthenticated() async {
    final user = await getCurrentUser();
    return user != null && !user.isExpired;
  }

  @override
  Future<void> forgotPassword(String email) async {
    await remoteDataSource.forgotPassword(email);
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    await remoteDataSource.resetPassword(token, newPassword);
  }

  @override
  Future<AuthUser> updateProfile(Map<String, dynamic> updates) async {
    return await remoteDataSource.updateProfile(updates);
  }

  @override
  Future<void> deleteAccount() async {
    await remoteDataSource.deleteAccount();
  }
}
