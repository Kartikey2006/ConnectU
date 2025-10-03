import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectu_alumni_platform/features/auth/domain/entities/auth_user.dart';
import 'package:connectu_alumni_platform/core/models/user.dart';

abstract class AuthLocalDataSource {
  Future<void> saveAuthUser(AuthUser user);
  Future<AuthUser?> getAuthUser();
  Future<void> clearAuthUser();
  Future<bool> hasAuthUser();
  Future<bool> isUserAuthenticated();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _authUserKey = 'auth_user';
  static const String _isLoggedInKey = 'is_logged_in';

  @override
  Future<void> saveAuthUser(AuthUser user) async {
    print('🔐 Saving auth user to local storage: ${user.user.email}');
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode({
      'user': user.user.toJson(),
      'accessToken': user.accessToken,
      'refreshToken': user.refreshToken,
      'expiresAt': user.expiresAt.toIso8601String(),
    });
    await prefs.setString(_authUserKey, userJson);
    await prefs.setBool(_isLoggedInKey, true);
    print('✅ Auth user saved successfully');
  }

  @override
  Future<AuthUser?> getAuthUser() async {
    print('🔍 Getting auth user from local storage...');
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_authUserKey);
    if (userJson == null) {
      print('❌ No auth user found in local storage');
      return null;
    }

    try {
      final userMap = jsonDecode(userJson) as Map<String, dynamic>;
      final authUser = AuthUser(
        user: User.fromJson(userMap['user']),
        accessToken: userMap['accessToken'],
        refreshToken: userMap['refreshToken'],
        expiresAt: DateTime.parse(userMap['expiresAt']),
      );

      print('✅ Auth user found in local storage: ${authUser.user.email}');
      print('⏰ Token expires at: ${authUser.expiresAt}');
      print('🕒 Current time: ${DateTime.now()}');
      print('📊 Is expired: ${authUser.isExpired}');

      // Don't clear expired tokens here - let the repository handle refresh
      return authUser;
    } catch (e) {
      print('❌ Error parsing auth user: $e');
      // If parsing fails, clear the stored data
      await clearAuthUser();
      return null;
    }
  }

  @override
  Future<void> clearAuthUser() async {
    print('🗑️ Clearing auth user from local storage');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authUserKey);
    await prefs.setBool(_isLoggedInKey, false);
    print('✅ Auth user cleared successfully');
  }

  @override
  Future<bool> hasAuthUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  @override
  Future<bool> isUserAuthenticated() async {
    final user = await getAuthUser();
    return user != null && !user.isExpired;
  }
}
