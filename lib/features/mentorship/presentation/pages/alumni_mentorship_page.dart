import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart';
import 'package:connectu_alumni_platform/core/utils/navigation_utils.dart';

class AlumniMentorshipPage extends StatelessWidget {
  const AlumniMentorshipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        title: const Text('Mentorship'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        leading: NavigationUtils.roleAwareBackButton(
          context: context,
        ),
        actions: [
          IconButton(
            onPressed: () => context.go('/mentorship/create'),
            icon: const Icon(Icons.add),
            tooltip: 'Create Session',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Mentorship Sessions',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage your mentorship sessions and help students grow',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 24),

            // Upcoming Sessions
            _buildSectionTitle('Upcoming Sessions'),
            const SizedBox(height: 16),
            _buildSessionCard(
              studentName: 'Ethan Carter',
              subject: 'Career Guidance in Tech',
              date: 'Dec 15, 2024',
              time: '2:00 PM - 3:00 PM',
              status: 'Confirmed',
              statusColor: Colors.green,
            ),
            const SizedBox(height: 12),
            _buildSessionCard(
              studentName: 'Olivia Bennett',
              subject: 'Data Science Career Path',
              date: 'Dec 18, 2024',
              time: '10:00 AM - 11:00 AM',
              status: 'Pending',
              statusColor: Colors.orange,
            ),
            const SizedBox(height: 12),
            _buildSessionCard(
              studentName: 'Michael Rodriguez',
              subject: 'Leadership Skills',
              date: 'Dec 20, 2024',
              time: '3:00 PM - 4:00 PM',
              status: 'Confirmed',
              statusColor: Colors.green,
            ),

            const SizedBox(height: 32),

            // Recent Sessions
            _buildSectionTitle('Recent Sessions'),
            const SizedBox(height: 16),
            _buildSessionCard(
              studentName: 'Sarah Chen',
              subject: 'Software Engineering Interview Prep',
              date: 'Dec 10, 2024',
              time: '2:00 PM - 3:00 PM',
              status: 'Completed',
              statusColor: Colors.blue,
              isCompleted: true,
            ),
            const SizedBox(height: 12),
            _buildSessionCard(
              studentName: 'David Kim',
              subject: 'Product Management Career',
              date: 'Dec 8, 2024',
              time: '11:00 AM - 12:00 PM',
              status: 'Completed',
              statusColor: Colors.blue,
              isCompleted: true,
            ),

            const SizedBox(height: 32),

            // Quick Actions
            _buildSectionTitle('Quick Actions'),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    icon: Icons.add,
                    title: 'Create Session',
                    subtitle: 'Schedule new mentorship',
                    onTap: () => context.go('/mentorship/create'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionCard(
                    icon: Icons.people,
                    title: 'View Requests',
                    subtitle: 'Student requests',
                    onTap: () => context.go('/alumni-requests'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    icon: Icons.analytics,
                    title: 'Analytics',
                    subtitle: 'Session insights',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Analytics coming soon!')),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionCard(
                    icon: Icons.settings,
                    title: 'Settings',
                    subtitle: 'Mentorship preferences',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Settings coming soon!')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String userRole = 'student'; // default
          if (state is Authenticated) {
            userRole = state.user.user.role.name;
          }

          return Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFE7EDF3), width: 1),
              ),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: 2, // Mentorship tab
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
                    // Already on mentorship
                    break;
                  case 3:
                    context.go('/notifications');
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
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildSessionCard({
    required String studentName,
    required String subject,
    required String date,
    required String time,
    required String status,
    required Color statusColor,
    bool isCompleted = false,
  }) {
    return Builder(
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE7EDF3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Text(
                    studentName.split(' ').map((e) => e[0]).join(''),
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        studentName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        subject,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.access_time,
                  size: 16,
                  color: AppTheme.textSecondary,
                ),
                const SizedBox(width: 8),
                Text(
                  time,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
            if (!isCompleted) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Builder(
                      builder: (context) => OutlinedButton(
                        onPressed: () {
                          // TODO: Implement reschedule
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Reschedule coming soon!')),
                          );
                        },
                        child: const Text('Reschedule'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Builder(
                      builder: (context) => ElevatedButton(
                        onPressed: () {
                          // TODO: Implement start session
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Start session coming soon!')),
                          );
                        },
                        child: const Text('Start Session'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Builder(
      builder: (context) => GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE7EDF3)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppTheme.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
