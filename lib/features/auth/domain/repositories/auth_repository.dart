import 'package:connectu_alumni_platform/features/auth/domain/entities/auth_user.dart';

abstract class AuthRepository {
  /// Sign in with email and password
  Future<AuthUser> signInWithEmail(String email, String password);
  
  /// Sign in with Google
  Future<AuthUser> signInWithGoogle();
  
  /// Sign up with email and password
  Future<AuthUser> signUpWithEmail(String email, String password, String name, String role);
  
  /// Sign out
  Future<void> signOut();
  
  /// Get current authenticated user
  Future<AuthUser?> getCurrentUser();
  
  /// Refresh access token
  Future<AuthUser> refreshToken(String refreshToken);
  
  /// Check if user is authenticated
  Future<bool> isAuthenticated();
  
  /// Forgot password
  Future<void> forgotPassword(String email);
  
  /// Reset password
  Future<void> resetPassword(String token, String newPassword);
  
  /// Update user profile
  Future<AuthUser> updateProfile(Map<String, dynamic> updates);
  
  /// Delete account
  Future<void> deleteAccount();
  
  /// Restore authentication state from local storage
  Future<AuthUser?> restoreAuthState();
}
