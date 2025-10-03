import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

/// A widget that handles back button behavior for specific pages
/// Use this widget to wrap pages where you want custom back button handling
class BackButtonHandler extends StatelessWidget {
  final Widget child;
  final bool isRootPage;
  final String? fallbackRoute;
  final VoidCallback? onBackPressed;

  const BackButtonHandler({
    super.key,
    required this.child,
    this.isRootPage = false,
    this.fallbackRoute,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Always handle back button ourselves
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) return; // Already popped, nothing to do

        // Custom back button callback
        if (onBackPressed != null) {
          onBackPressed!();
          return;
        }

        // Check if we can navigate back normally
        if (context.canPop() && !isRootPage) {
          context.pop();
          return;
        }

        // Handle root pages
        if (isRootPage) {
          // Show exit confirmation for root pages
          final shouldExit = await _showExitConfirmation(context);
          if (shouldExit) {
            SystemNavigator.pop();
          }
        } else if (fallbackRoute != null) {
          // Navigate to fallback route
          context.go(fallbackRoute!);
        } else {
          // Default behavior - try to pop or exit
          if (context.canPop()) {
            context.pop();
          } else {
            SystemNavigator.pop();
          }
        }
      },
      child: child,
    );
  }

  Future<bool> _showExitConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exit App'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Exit'),
          ),
        ],
      ),
    ) ?? false;
  }
}

/// Extension to easily add back button handling to any page
extension BackButtonHandling on Widget {
  /// Wraps the widget with back button handling
  Widget withBackButtonHandler({
    bool isRootPage = false,
    String? fallbackRoute,
    VoidCallback? onBackPressed,
  }) {
    return BackButtonHandler(
      isRootPage: isRootPage,
      fallbackRoute: fallbackRoute,
      onBackPressed: onBackPressed,
      child: this,
    );
  }
}
