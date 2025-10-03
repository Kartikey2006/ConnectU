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
      await _supabase.auth.signInWithOAuth(
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
      print('🔐 Starting signup process for: $email');

      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          'name': name,
          'role': role,
        },
      );

      print('📝 Supabase auth response: ${response.user?.id}');

      if (response.user == null) {
        throw Exception('Sign up failed - no user returned');
      }

      print('👤 Creating user profile in database...');

      // Create user profile in users table
      // Note: We don't insert the 'id' field as it's auto-generated
      // RLS policy now allows user inserts
      try {
        // First, check if user already exists
        final existingUser = await _supabase
            .from('users')
            .select('id, email')
            .eq('email', email)
            .maybeSingle();

        if (existingUser != null) {
          print('⚠️ User already exists, updating profile...');
          // Update existing user with new role if needed
          final updateResult = await _supabase
              .from('users')
              .update({
                'name': name,
                'role': role,
                'password_hash': 'supabase_auth_managed',
              })
              .eq('email', email)
              .select();

          print('✅ User profile updated: $updateResult');
        } else {
          // Create new user
          final insertResult = await _supabase.from('users').insert({
            'name': name,
            'email': email,
            'role': role,
            'password_hash': 'supabase_auth_managed',
          }).select();

          print('✅ User profile created: $insertResult');
        }
      } catch (e) {
        print('❌ Failed to create/update user profile: $e');
        // Don't throw error here, continue with authentication
        print('⚠️ Continuing with authentication despite database error...');
      }

      print('🔍 Fetching created user...');
      final user = await _getUserFromSupabase(response.user!.id);
      print('✅ User fetched successfully: ${user.name}');

      // Check if we have a valid session
      if (response.session != null) {
        print('✅ Valid session found, user is authenticated');
        return app_auth.AuthUser(
          user: user,
          accessToken: response.session!.accessToken,
          refreshToken: response.session!.refreshToken ?? '',
          expiresAt: _parseExpiresAt(response.session!.expiresAt),
        );
      } else {
        print('⚠️ No session found, user needs email confirmation');
        // For development, we'll create a mock session
        // In production, you'd handle email confirmation flow
        return app_auth.AuthUser(
          user: user,
          accessToken: 'mock_token_${DateTime.now().millisecondsSinceEpoch}',
          refreshToken: 'mock_refresh_${DateTime.now().millisecondsSinceEpoch}',
          expiresAt: DateTime.now().add(const Duration(hours: 24)),
        );
      }
    } catch (e) {
      print('❌ Signup error: $e');
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
        accessToken: session.accessToken,
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

      await _supabase.from('users').update(updates).eq('email', user.email!);

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

      await _supabase.from('users').delete().eq('email', user.email!);
      await _supabase.auth.admin.deleteUser(user.id);
    } catch (e) {
      throw Exception('Account deletion failed: ${e.toString()}');
    }
  }

  Future<app_user.User> _getUserFromSupabase(String authUserId) async {
    try {
      // Skip supabase_auth_id lookup since column doesn't exist
      // Go directly to email-based lookup
      try {
        final authUser = _supabase.auth.currentUser;
        if (authUser == null) {
          throw Exception('No authenticated user');
        }

        print('🔍 Looking for user by email: ${authUser.email}');

        // Try multiple email variations to handle case sensitivity
        final emailVariations = [
          authUser.email!, // Original case
          authUser.email!.toLowerCase(), // Lowercase
          authUser.email!.toUpperCase(), // Uppercase
        ];

        for (final email in emailVariations) {
          try {
            print('🔍 Trying email: $email');
            final response = await _supabase
                .from('users')
                .select()
                .eq('email', email)
                .single();
            print('✅ Found user by email: ${response['name']}');
            return app_user.User.fromJson(response);
          } catch (emailError) {
            print('⚠️ Email $email not found, trying next variation...');
            continue;
          }
        }

        // Try case-insensitive search
        print('🔍 Trying case-insensitive email match...');
        try {
          final response = await _supabase
              .from('users')
              .select()
              .ilike('email', authUser.email!)
              .single();
          print('✅ Found user by case-insensitive email: ${response['name']}');
          return app_user.User.fromJson(response);
        } catch (ilikeError) {
          print('⚠️ Case-insensitive search failed: $ilikeError');
        }

        // Last resort: try to find any user with similar email
        print('🔍 Last resort: searching for any user with similar email...');
        try {
          final response = await _supabase
              .from('users')
              .select()
              .ilike('email', '%${authUser.email!.split('@')[0]}%')
              .single();
          print('✅ Found user by partial email match: ${response['name']}');
          return app_user.User.fromJson(response);
        } catch (partialError) {
          print('❌ All email search methods failed');
          throw Exception('Failed to find user with any email variation');
        }
      } catch (fallbackError) {
        print('❌ Failed to find user by email: $fallbackError');
        throw Exception('Failed to fetch user: ${fallbackError.toString()}');
      }
    } catch (e) {
      print('❌ Failed to find user: $e');
      throw Exception('User not found in database');
    }
  }

  DateTime _parseExpiresAt(dynamic expiresAt) {
    if (expiresAt is int) {
      return DateTime.fromMillisecondsSinceEpoch(expiresAt);
    }
    if (expiresAt is String) {
      return DateTime.parse(expiresAt);
    }
    // If no expiration time provided, set a default 7-day expiration
    return DateTime.now().add(const Duration(days: 7));
  }
}
