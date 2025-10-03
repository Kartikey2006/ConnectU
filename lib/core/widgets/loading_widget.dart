import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final double? size;

  const LoadingWidget({
    super.key,
    this.message,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF1979E6)),
              strokeWidth: 2.0,
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: const TextStyle(
                color: Color(0xFF4E7097),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }
}

class ImagePlaceholder extends StatelessWidget {
  final String? initials;
  final IconData? icon;
  final double? size;
  final Color? backgroundColor;
  final Color? foregroundColor;

  const ImagePlaceholder({
    super.key,
    this.initials,
    this.icon,
    this.size = 80.0,
    this.backgroundColor = const Color(0xFFE7EDF3),
    this.foregroundColor = const Color(0xFF4E7097),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        gradient: initials != null
            ? const LinearGradient(
                colors: [Color(0xFF1979E6), Color(0xFF4A90E2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
      ),
      child: Center(
        child: initials != null
            ? Text(
                initials!,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: (size ?? 80) * 0.3,
                  fontWeight: FontWeight.bold,
                ),
              )
            : Icon(
                icon ?? Icons.person,
                size: (size ?? 80) * 0.5,
                color: initials != null ? Colors.white : foregroundColor,
              ),
      ),
    );
  }
}
