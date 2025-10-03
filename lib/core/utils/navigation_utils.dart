import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart';

class NavigationUtils {
  /// Safe back navigation that handles cases where there's no route to pop
  static void safeBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      // If we can't pop, navigate to the appropriate dashboard based on user role
      _navigateToDashboard(context);
    }
  }

  /// Navigate to the appropriate dashboard based on user role
  static void _navigateToDashboard(BuildContext context) {
    try {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        final userRole = authState.user.user.role.name;
        switch (userRole) {
          case 'alumni':
            context.go('/alumni-dashboard');
            break;
          case 'student':
            context.go('/student-dashboard');
            break;
          case 'admin':
            context.go('/admin-dashboard');
            break;
          default:
            context.go('/');
        }
      } else {
        context.go('/');
      }
    } catch (e) {
      // Fallback to home if there's any error
      context.go('/');
    }
  }

  /// Create a safe back button widget
  static Widget safeBackButton({
    required BuildContext context,
    Color? iconColor,
    double? iconSize,
  }) {
    return IconButton(
      onPressed: () => safeBack(context),
      icon: Icon(
        Icons.arrow_back,
        color: iconColor ?? const Color(0xFF0E141B),
        size: iconSize ?? 24,
      ),
    );
  }

  /// Create a role-aware back button that navigates to the correct dashboard
  static Widget roleAwareBackButton({
    required BuildContext context,
    Color? iconColor,
    double? iconSize,
  }) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        String userRole = 'student'; // default
        if (state is Authenticated) {
          userRole = state.user.user.role.name;
        }

        return IconButton(
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              // Navigate to appropriate dashboard based on user role
              switch (userRole) {
                case 'alumni':
                  context.go('/alumni-dashboard');
                  break;
                case 'student':
                  context.go('/student-dashboard');
                  break;
                case 'admin':
                  context.go('/admin-dashboard');
                  break;
                default:
                  context.go('/');
              }
            }
          },
          icon: Icon(
            Icons.arrow_back,
            color: iconColor ?? const Color(0xFF0E141B),
            size: iconSize ?? 24,
          ),
        );
      },
    );
  }
}
