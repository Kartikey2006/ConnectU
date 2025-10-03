import 'package:flutter/material.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';
import 'package:connectu_alumni_platform/core/widgets/modern_button.dart';

class ModernDialog extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? content;
  final List<Widget>? actions;
  final bool showCloseButton;
  final VoidCallback? onClose;

  const ModernDialog({
    super.key,
    required this.title,
    this.subtitle,
    this.content,
    this.actions,
    this.showCloseButton = true,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppTheme.floatingShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (showCloseButton)
                    IconButton(
                      onPressed: onClose ?? () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
            // Content
            if (content != null)
              Padding(
                padding: const EdgeInsets.all(24),
                child: content!,
              ),
            // Actions
            if (actions != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions!,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class ModernAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmText;
  final String? cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final bool isDestructive;

  const ModernAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return ModernDialog(
      title: title,
      content: Text(
        message,
        style: const TextStyle(
          color: AppTheme.textSecondary,
          fontSize: 16,
          height: 1.5,
        ),
      ),
      actions: [
        if (cancelText != null)
          ModernButton(
            text: cancelText!,
            type: ModernButtonType.outline,
            onPressed: onCancel ?? () => Navigator.of(context).pop(),
          ),
        if (cancelText != null) const SizedBox(width: 12),
        ModernButton(
          text: confirmText ?? 'OK',
          type: isDestructive
              ? ModernButtonType.secondary
              : ModernButtonType.primary,
          onPressed: onConfirm ?? () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

class ModernBottomSheet extends StatelessWidget {
  final String? title;
  final Widget? content;
  final List<Widget>? actions;
  final bool showHandle;

  const ModernBottomSheet({
    super.key,
    this.title,
    this.content,
    this.actions,
    this.showHandle = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle)
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          if (title != null)
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                title!,
                style: const TextStyle(
                  color: AppTheme.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          if (content != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: content!,
            ),
          if (actions != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!,
              ),
            ),
        ],
      ),
    );
  }
}

class ModernSnackBar extends StatelessWidget {
  final String message;
  final ModernSnackBarType type;
  final VoidCallback? onAction;
  final String? actionText;

  const ModernSnackBar({
    super.key,
    required this.message,
    this.type = ModernSnackBarType.info,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _getBackgroundColor(),
        borderRadius: BorderRadius.circular(12),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Icon(
            _getIcon(),
            color: _getIconColor(),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: _getTextColor(),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          if (onAction != null && actionText != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                actionText!,
                style: TextStyle(
                  color: _getIconColor(),
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Color _getBackgroundColor() {
    switch (type) {
      case ModernSnackBarType.success:
        return AppTheme.successColor.withOpacity(0.1);
      case ModernSnackBarType.error:
        return AppTheme.errorColor.withOpacity(0.1);
      case ModernSnackBarType.warning:
        return AppTheme.warningColor.withOpacity(0.1);
      case ModernSnackBarType.info:
        return AppTheme.infoColor.withOpacity(0.1);
    }
  }

  Color _getIconColor() {
    switch (type) {
      case ModernSnackBarType.success:
        return AppTheme.successColor;
      case ModernSnackBarType.error:
        return AppTheme.errorColor;
      case ModernSnackBarType.warning:
        return AppTheme.warningColor;
      case ModernSnackBarType.info:
        return AppTheme.infoColor;
    }
  }

  Color _getTextColor() {
    switch (type) {
      case ModernSnackBarType.success:
        return AppTheme.successColor;
      case ModernSnackBarType.error:
        return AppTheme.errorColor;
      case ModernSnackBarType.warning:
        return AppTheme.warningColor;
      case ModernSnackBarType.info:
        return AppTheme.textPrimary;
    }
  }

  IconData _getIcon() {
    switch (type) {
      case ModernSnackBarType.success:
        return Icons.check_circle_rounded;
      case ModernSnackBarType.error:
        return Icons.error_rounded;
      case ModernSnackBarType.warning:
        return Icons.warning_rounded;
      case ModernSnackBarType.info:
        return Icons.info_rounded;
    }
  }
}

enum ModernSnackBarType {
  success,
  error,
  warning,
  info,
}

class ModernToast {
  static void show(
    BuildContext context, {
    required String message,
    ModernSnackBarType type = ModernSnackBarType.info,
    VoidCallback? onAction,
    String? actionText,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: ModernSnackBar(
          message: message,
          type: type,
          onAction: onAction,
          actionText: actionText,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}
