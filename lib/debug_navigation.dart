// Debug navigation helper for testing back button and route handling
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationDebugger {
  static void logCurrentRoute(BuildContext context) {
    final location = GoRouterState.of(context).fullPath;
    debugPrint('Current route: $location');
  }

  static void logCanPop(BuildContext context) {
    final canPop = GoRouter.of(context).canPop();
    debugPrint('Can pop: $canPop');
  }

  static void logRouterState(BuildContext context) {
    logCurrentRoute(context);
    logCanPop(context);
  }

  static void safeNavigateBack(BuildContext context) {
    if (GoRouter.of(context).canPop()) {
      debugPrint('Popping current route');
      context.pop();
    } else {
      debugPrint('Cannot pop, navigating to home');
      context.go('/');
    }
  }
}

// Extension to add debug methods to BuildContext
extension NavigationDebugExtension on BuildContext {
  void debugNavigation() {
    NavigationDebugger.logRouterState(this);
  }

  void safeGoBack() {
    NavigationDebugger.safeNavigateBack(this);
  }
}
