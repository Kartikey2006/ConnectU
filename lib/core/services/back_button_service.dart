import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart'
    as auth_bloc;

class BackButtonService {
  static const platform =
      MethodChannel('com.example.connectu_alumni_platform/back_button');
  static GoRouter? _router;

  static void initialize(GoRouter router) {
    _router = router;

    // Set up method channel for back button handling
    platform.setMethodCallHandler((call) async {
      if (call.method == 'onBackPressed') {
        return await _handleBackButton();
      }
      return false;
    });
  }

  static Future<bool> _handleBackButton() async {
    final context = _router?.routerDelegate.navigatorKey.currentContext;
    if (context != null) {
      if (context.canPop()) {
        context.pop();
        return true; // Handled by Flutter
      } else {
        // Navigate to appropriate dashboard based on user role
        final authState = context.read<auth_bloc.AuthBloc>().state;
        if (authState is auth_bloc.Authenticated) {
          final userRole = authState.user.user.role.name;
          if (userRole == 'alumni') {
            context.go('/alumni-dashboard');
          } else if (userRole == 'student') {
            context.go('/student-dashboard');
          } else if (userRole == 'admin') {
            context.go('/admin-dashboard');
          } else {
            context.go('/');
          }
        } else {
          context.go('/');
        }
        return true; // Handled by Flutter
      }
    }
    return false; // Let Android handle it (close app)
  }

  static Future<void> exitApp() async {
    try {
      await platform.invokeMethod('exitApp');
    } catch (e) {
      print('Error exiting app: $e');
    }
  }
}
