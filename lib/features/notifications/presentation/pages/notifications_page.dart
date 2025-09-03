import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement mark all as read
            },
            icon: const Icon(Icons.done_all),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationItem(
            title: 'Mentorship Session Confirmed',
            message: 'Your session with Ethan Carter has been confirmed for Dec 15, 2024 at 2:00 PM',
            time: '2 minutes ago',
            type: NotificationType.mentorship,
            isUnread: true,
            onTap: () {
              // TODO: Navigate to session details
            },
          ),
          
          const SizedBox(height: 12),
          
          _buildNotificationItem(
            title: 'Webinar Registration Successful',
            message: 'You have successfully registered for "Digital Marketing Trends 2024"',
            time: '1 hour ago',
            type: NotificationType.webinar,
            isUnread: true,
            onTap: () {
              // TODO: Navigate to webinar details
            },
          ),
          
          const SizedBox(height: 12),
          
          _buildNotificationItem(
            title: 'Referral Request Update',
            message: 'Your referral request for Google has been reviewed and is under consideration',
            time: '3 hours ago',
            type: NotificationType.referral,
            isUnread: false,
            onTap: () {
              // TODO: Navigate to referral details
            },
          ),
          
          const SizedBox(height: 12),
          
          _buildNotificationItem(
            title: 'New Message from Olivia Bennett',
            message: 'Olivia sent you a message about your upcoming mentorship session',
            time: '1 day ago',
            type: NotificationType.chat,
            isUnread: false,
            onTap: () {
              context.go('/chat/2');
            },
          ),
          
          const SizedBox(height: 12),
          
          _buildNotificationItem(
            title: 'Profile Verification Complete',
            message: 'Your alumni profile has been verified successfully',
            time: '2 days ago',
            type: NotificationType.system,
            isUnread: false,
            onTap: () {
              // TODO: Navigate to profile
            },
          ),
          
          const SizedBox(height: 12),
          
          _buildNotificationItem(
            title: 'Payment Successful',
            message: 'Payment of \$50 for mentorship session has been processed',
            time: '3 days ago',
            type: NotificationType.payment,
            isUnread: false,
            onTap: () {
              // TODO: Navigate to payment history
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String message,
    required String time,
    required NotificationType type,
    required bool isUnread,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Notification Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: _getNotificationColor(type).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getNotificationIcon(type),
                color: _getNotificationColor(type),
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Notification Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: isUnread ? FontWeight.bold : FontWeight.w600,
                            color: isUnread ? AppTheme.textPrimary : AppTheme.textPrimary,
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppTheme.primaryColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  
                  const SizedBox(height: 4),
                  
                  Text(
                    message,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 14,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    time,
                    style: const TextStyle(
                      color: AppTheme.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getNotificationColor(NotificationType type) {
    switch (type) {
      case NotificationType.mentorship:
        return AppTheme.primaryColor;
      case NotificationType.webinar:
        return AppTheme.warningColor;
      case NotificationType.referral:
        return AppTheme.accentColor;
      case NotificationType.chat:
        return AppTheme.successColor;
      case NotificationType.system:
        return AppTheme.textSecondary;
      case NotificationType.payment:
        return AppTheme.successColor;
    }
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.mentorship:
        return Icons.school;
      case NotificationType.webinar:
        return Icons.video_call;
      case NotificationType.referral:
        return Icons.handshake;
      case NotificationType.chat:
        return Icons.chat;
      case NotificationType.system:
        return Icons.info;
      case NotificationType.payment:
        return Icons.payment;
    }
  }
}

enum NotificationType {
  mentorship,
  webinar,
  referral,
  chat,
  system,
  payment,
}
