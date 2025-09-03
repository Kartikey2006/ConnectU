import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:connectu_alumni_platform/features/auth/domain/entities/auth_user.dart'
    as app_auth;
import 'package:connectu_alumni_platform/core/models/user.dart' as app_user;

abstract class AuthRemoteDataSource {
  Future<app_auth.AuthUser> signInWithEmail(String email, String password);
  Future<app_auth.AuthUser> signInWithGoogle();
  Future<app_auth.AuthUser> signUpWithEmail(
      String email, String password, String name, String role);
  Future<void> signOut();
  Future<app_auth.AuthUser?> getCurrentUser();
  Future<app_auth.AuthUser> refreshToken(String refreshToken);
  Future<void> forgotPassword(String email);
  Future<void> resetPassword(String token, String newPassword);
  Future<app_auth.AuthUser> updateProfile(Map<String, dynamic> updates);
  Future<void> deleteAccount();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  Future<app_auth.AuthUser> signInWithEmail(
      String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user == null) {
        throw Exception('Sign in failed');
      }

      final user = await _getUserFromSupabase(response.user!.id);
      return app_auth.AuthUser(
        user: user,
        accessToken: response.session?.accessToken ?? '',
        refreshToken: response.session?.refreshToken ?? '',
        expiresAt: _parseExpiresAt(response.session?.expiresAt),
      );
    } catch (e) {
      throw Exception('Sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<app_auth.AuthUser> signInWithGoogle() async {
    try {
      final response = await _supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.connectu://login-callback/',
      );

      // Note: This is a simplified implementation
      // In a real app, you'd handle the OAuth callback properly
      throw UnimplementedError('Google sign in not fully implemented');
    } catch (e) {
      throw Exception('Google sign in failed: ${e.toString()}');
    }
  }

  @override
  Future<app_auth.AuthUser> signUpWithEmail(
      String email, String password, String name, String role) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'role': role,
        },
      );

      if (response.user == null) {
        throw Exception('Sign up failed');
      }

      // Create user profile in users table
      await _supabase.from('users').insert({
        'id': response.user!.id,
        'name': name,
        'email': email,
        'role': role,
      });

      final user = await _getUserFromSupabase(response.user!.id);
      return app_auth.AuthUser(
        user: user,
        accessToken: response.session?.accessToken ?? '',
        refreshToken: response.session?.refreshToken ?? '',
        expiresAt: _parseExpiresAt(response.session?.expiresAt),
      );
    } catch (e) {
      throw Exception('Sign up failed: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: ${e.toString()}');
    }
  }

  @override
  Future<app_auth.AuthUser?> getCurrentUser() async {
    try {
      final session = _supabase.auth.currentSession;
      if (session == null) return null;

      final user = await _getUserFromSupabase(session.user.id);
      return app_auth.AuthUser(
        user: user,
        accessToken: session.accessToken ?? '',
        refreshToken: session.refreshToken ?? '',
        expiresAt: _parseExpiresAt(session.expiresAt),
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<app_auth.AuthUser> refreshToken(String refreshToken) async {
    try {
      final response = await _supabase.auth.refreshSession(refreshToken);

      if (response.user == null) {
        throw Exception('Token refresh failed');
      }

      final user = await _getUserFromSupabase(response.user!.id);
      return app_auth.AuthUser(
        user: user,
        accessToken: response.session?.accessToken ?? '',
        refreshToken: response.session?.refreshToken ?? '',
        expiresAt: _parseExpiresAt(response.session?.expiresAt),
      );
    } catch (e) {
      throw Exception('Token refresh failed: ${e.toString()}');
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _supabase.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Password reset failed: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _supabase.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      throw Exception('Password update failed: ${e.toString()}');
    }
  }

  @override
  Future<app_auth.AuthUser> updateProfile(Map<String, dynamic> updates) async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      await _supabase.from('users').update(updates).eq('id', user.id);

      final updatedUser = await _getUserFromSupabase(user.id);
      final session = _supabase.auth.currentSession;

      return app_auth.AuthUser(
        user: updatedUser,
        accessToken: session?.accessToken ?? '',
        refreshToken: session?.refreshToken ?? '',
        expiresAt: _parseExpiresAt(session?.expiresAt),
      );
    } catch (e) {
      throw Exception('Profile update failed: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      final user = _supabase.auth.currentUser;
      if (user == null) {
        throw Exception('No authenticated user');
      }

      await _supabase.from('users').delete().eq('id', user.id);
      await _supabase.auth.admin.deleteUser(user.id);
    } catch (e) {
      throw Exception('Account deletion failed: ${e.toString()}');
    }
  }

  Future<app_user.User> _getUserFromSupabase(String userId) async {
    try {
      final response =
          await _supabase.from('users').select().eq('id', userId).single();

      return app_user.User.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch user: ${e.toString()}');
    }
  }

  DateTime _parseExpiresAt(dynamic expiresAt) {
    if (expiresAt == null) return DateTime.now();
    if (expiresAt is int) {
      return DateTime.fromMillisecondsSinceEpoch(expiresAt);
    }
    if (expiresAt is String) {
      return DateTime.parse(expiresAt);
    }
    return DateTime.now();
  }
}
