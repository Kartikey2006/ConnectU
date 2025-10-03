import 'package:connectu_alumni_platform/features/auth/domain/entities/auth_user.dart';
import 'package:connectu_alumni_platform/features/auth/domain/repositories/auth_repository.dart';
import 'package:connectu_alumni_platform/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:connectu_alumni_platform/features/auth/data/datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<AuthUser> signInWithEmail(String email, String password) async {
    try {
      print('🔑 Signing in user: $email');
      final user = await remoteDataSource.signInWithEmail(email, password);
      print('✅ Remote sign in successful');

      await localDataSource.saveAuthUser(user);
      print('✅ User saved to local storage');

      return user;
    } catch (e) {
      print('❌ Sign in error: $e');
      rethrow;
    }
  }

  @override
  Future<AuthUser> signInWithGoogle() async {
    return await remoteDataSource.signInWithGoogle();
  }

  @override
  Future<AuthUser> signUpWithEmail(
      String email, String password, String name, String role) async {
    print('🔐 Repository: Starting signup for $email as $role');
    final user =
        await remoteDataSource.signUpWithEmail(email, password, name, role);
    print('✅ Repository: Remote signup successful, saving to local storage');
    await localDataSource.saveAuthUser(user);
    print('✅ Repository: User saved to local storage successfully');
    return user;
  }

  @override
  Future<void> signOut() async {
    await remoteDataSource.signOut();
    await localDataSource.clearAuthUser();
  }

  @override
  Future<AuthUser?> getCurrentUser() async {
    try {
      print('🔍 Getting current user...');

      // First check local storage (faster)
      final localUser = await localDataSource.getAuthUser();
      if (localUser != null) {
        print('✅ Found local user: ${localUser.user.email}');

        // If token is expired, try to refresh it
        if (localUser.isExpired) {
          print('⏰ Token expired, attempting refresh...');
          try {
            final refreshedUser =
                await remoteDataSource.refreshToken(localUser.refreshToken);
            print('✅ Token refreshed successfully');
            await localDataSource.saveAuthUser(refreshedUser);
            return refreshedUser;
          } catch (refreshError) {
            print('❌ Token refresh failed: $refreshError');
            // Don't clear immediately, try remote session first
          }
        } else {
          print('✅ Local user token is valid');
          // Verify with remote in background (don't wait)
          _verifyWithRemoteInBackground(localUser);
          return localUser;
        }
      }

      print('📱 No valid local user, checking Supabase session...');
      // If no valid local user, check Supabase session
      final remoteUser = await remoteDataSource.getCurrentUser();
      if (remoteUser != null) {
        print('✅ Found valid Supabase session');
        await localDataSource.saveAuthUser(remoteUser);
        return remoteUser;
      }

      print('❌ No valid user found anywhere');
      // Only clear local storage if we're sure there's no valid session
      await localDataSource.clearAuthUser();
      return null;
    } catch (e) {
      print('❌ Error in getCurrentUser: $e');
      // Don't clear local storage on error, just return null
      return null;
    }
  }

  // Helper method to verify with remote in background
  void _verifyWithRemoteInBackground(AuthUser localUser) async {
    try {
      final remoteUser = await remoteDataSource.getCurrentUser();
      if (remoteUser != null && remoteUser.user.id != localUser.user.id) {
        // User changed, update local storage
        await localDataSource.saveAuthUser(remoteUser);
        print('🔄 Updated local user from remote');
      }
    } catch (e) {
      // Ignore background verification errors
      print('⚠️ Background verification failed: $e');
    }
  }

  @override
  Future<AuthUser> refreshToken(String refreshToken) async {
    return await remoteDataSource.refreshToken(refreshToken);
  }

  @override
  Future<bool> isAuthenticated() async {
    return await localDataSource.isUserAuthenticated();
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

  @override
  Future<AuthUser?> restoreAuthState() async {
    try {
      print('🔍 Starting auth state restoration...');

      // First check local storage
      print('📱 Checking local storage...');
      final localUser = await localDataSource.getAuthUser();
      if (localUser != null && !localUser.isExpired) {
        print('✅ Found valid local user: ${localUser.user.email}');
        return localUser;
      }

      print('❌ No valid local user found');
      // Clear local storage if user is expired or doesn't exist
      await localDataSource.clearAuthUser();
      return null;
    } catch (e) {
      print('❌ Error in restoreAuthState: $e');
      await localDataSource.clearAuthUser();
      return null;
    }
  }
}
