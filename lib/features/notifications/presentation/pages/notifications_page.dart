import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart';
import 'package:connectu_alumni_platform/core/utils/navigation_utils.dart';

enum NotificationType {
  mentorship,
  webinar,
  referral,
  chat,
  system,
  payment,
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('🚨 NOTIFICATIONS PAGE BUILT');
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC), // slate-50
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: NavigationUtils.roleAwareBackButton(
          context: context,
          iconColor: const Color(0xFF0E141B),
          iconSize: 24,
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF0E141B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.015,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // TODO: Implement mark all as read
            },
            icon: const Icon(
              Icons.done_all,
              color: Color(0xFF0E141B),
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Today Section
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Today',
                style: TextStyle(
                  color: Color(0xFF0E141B),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.015,
                ),
              ),
            ),
          ),

          // Today's Notifications
          Expanded(
            child: ListView(
              children: [
                _buildNotificationItem(
                  title: 'Welcome to the Alumni Network!',
                  subtitle: 'System',
                  time: '2 minutes ago',
                  type: NotificationType.system,
                  isUnread: true,
                  onTap: () {},
                ),
                _buildNotificationItem(
                  title:
                      'Your referral for Software Engineer at TechCorp has been submitted.',
                  subtitle: 'Referral',
                  time: '1 hour ago',
                  type: NotificationType.referral,
                  isUnread: true,
                  onTap: () => context.go('/referrals'),
                ),
                _buildNotificationItem(
                  title: 'Upcoming Webinar: \'Career Paths in AI\'',
                  subtitle: 'Webinar',
                  time: '2 hours ago',
                  type: NotificationType.webinar,
                  isUnread: true,
                  onTap: () => context.push('/webinars'),
                ),
                _buildNotificationItem(
                  title:
                      'New mentorship session scheduled with Dr. Evelyn Reed.',
                  subtitle: 'Mentorship Updates',
                  time: '3 hours ago',
                  type: NotificationType.mentorship,
                  isUnread: true,
                  onTap: () => context.go('/mentorship'),
                ),

                // Yesterday Section
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Yesterday',
                      style: TextStyle(
                        color: Color(0xFF0E141B),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.015,
                      ),
                    ),
                  ),
                ),

                _buildNotificationItem(
                  title: 'Profile updated successfully.',
                  subtitle: 'System',
                  time: '1 day ago',
                  type: NotificationType.system,
                  isUnread: false,
                  onTap: () => context.go('/profile'),
                ),
                _buildNotificationItem(
                  title:
                      'Referral for Data Analyst at DataSolutions is under review.',
                  subtitle: 'Referral',
                  time: '1 day ago',
                  type: NotificationType.referral,
                  isUnread: false,
                  onTap: () => context.go('/referrals'),
                ),
                _buildNotificationItem(
                  title:
                      'Webinar recording: \'Entrepreneurship in the Digital Age\' is now available.',
                  subtitle: 'Webinar',
                  time: '1 day ago',
                  type: NotificationType.webinar,
                  isUnread: false,
                  onTap: () => context.push('/webinars'),
                ),
                _buildNotificationItem(
                  title:
                      'Your session with Ethan Carter has been confirmed for Dec 15, 2024 at 2:00 PM',
                  subtitle: 'Mentorship Updates',
                  time: '1 day ago',
                  type: NotificationType.mentorship,
                  isUnread: false,
                  onTap: () => context.go('/mentorship'),
                ),
                _buildNotificationItem(
                  title: 'New Message from Olivia Bennett',
                  subtitle: 'Chat',
                  time: '1 day ago',
                  type: NotificationType.chat,
                  isUnread: false,
                  onTap: () => context.go('/chat'),
                ),
                _buildNotificationItem(
                  title: 'Payment Successful',
                  subtitle: 'Payment',
                  time: '1 day ago',
                  type: NotificationType.payment,
                  isUnread: false,
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String userRole = 'student'; // default
          if (state is Authenticated) {
            userRole = state.user.user.role.name;
            print('🔍 NotificationsPage - User role detected: $userRole');
          } else {
            print(
                '🔍 NotificationsPage - User not authenticated, using default role: $userRole');
          }

          return Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFE7EDF3), width: 1),
              ),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: 3, // Notifications tab
              onTap: (index) {
                switch (index) {
                  case 0:
                    // Navigate to appropriate dashboard based on user role
                    if (userRole == 'alumni') {
                      context.go('/alumni-dashboard');
                    } else {
                      context.go('/student-dashboard');
                    }
                    break;
                  case 1:
                    if (userRole == 'alumni') {
                      context.go('/alumni-network');
                    } else {
                      context.go('/alumni');
                    }
                    break;
                  case 2:
                    print('🚨 MENTORSHIP TAB CLICKED - UserRole: $userRole');
                    if (userRole == 'alumni') {
                      print('🚨 GOING TO ALUMNI MENTORSHIP');
                      context.go('/alumni-mentorship');
                    } else {
                      print('🚨 GOING TO STUDENT MENTORSHIP');
                      context.go('/mentorship');
                    }
                    break;
                  case 3:
                    // Already on notifications
                    break;
                  case 4:
                    // Referrals - only show for alumni
                    if (userRole == 'alumni') {
                      context.go('/referrals');
                    }
                    break;
                }
              },
              selectedItemColor: const Color(0xFF0E141B),
              unselectedItemColor: const Color(0xFF4E7097),
              backgroundColor: const Color(0xFFF8FAFC),
              elevation: 0,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home, size: 24),
                  label: 'Dashboard',
                ),
                BottomNavigationBarItem(
                  icon: const Icon(Icons.people, size: 24),
                  label:
                      userRole == 'alumni' ? 'Alumni Network' : 'Find Alumni',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.work, size: 24),
                  label: 'Mentorship',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.notifications, size: 24),
                  label: 'Notifications',
                ),
                if (userRole == 'alumni')
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.handshake, size: 24),
                    label: 'Referrals',
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildNotificationItem({
    required String title,
    required String subtitle,
    required String time,
    required NotificationType type,
    required bool isUnread,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(0),
        ),
        child: Row(
          children: [
            // Notification Icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFFE7EDF3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                _getNotificationIcon(type),
                color: const Color(0xFF0E141B),
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
                            fontWeight:
                                isUnread ? FontWeight.bold : FontWeight.w600,
                            color: const Color(0xFF0E141B),
                          ),
                        ),
                      ),
                      if (isUnread)
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Color(0xFF1979E6),
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: Color(0xFF4E7097),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            // Close button
            IconButton(
              onPressed: () {
                // TODO: Implement dismiss notification
              },
              icon: const Icon(
                Icons.close,
                color: Color(0xFF0E141B),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getNotificationIcon(NotificationType type) {
    switch (type) {
      case NotificationType.mentorship:
        return Icons.people;
      case NotificationType.webinar:
        return Icons.video_library;
      case NotificationType.referral:
        return Icons.handshake;
      case NotificationType.chat:
        return Icons.chat;
      case NotificationType.system:
        return Icons.notifications;
      case NotificationType.payment:
        return Icons.payment;
    }
  }
}
