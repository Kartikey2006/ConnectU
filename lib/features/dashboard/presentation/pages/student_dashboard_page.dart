import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';
import 'package:connectu_alumni_platform/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:connectu_alumni_platform/features/dashboard/presentation/widgets/mentor_card.dart';
import 'package:connectu_alumni_platform/features/dashboard/presentation/widgets/event_card.dart';
import 'package:connectu_alumni_platform/features/dashboard/presentation/widgets/side_navigation.dart';

class StudentDashboardPage extends StatefulWidget {
  const StudentDashboardPage({super.key});

  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends State<StudentDashboardPage> {
  int _selectedIndex = 0;
  bool _isSideMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      body: Stack(
        children: [
          // Main Content
          Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _isSideMenuOpen = !_isSideMenuOpen;
                        });
                      },
                      icon: const Icon(
                        Icons.menu,
                        color: AppTheme.textPrimary,
                        size: 24,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Dashboard',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => context.go('/notifications'),
                      icon: const Icon(
                        Icons.notifications_outlined,
                        color: AppTheme.textPrimary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Welcome Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        String userName = 'Student';
                        if (state is Authenticated) {
                          userName = state.authUser.user.name;
                        }
                        return Text(
                          'Welcome, $userName',
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Connect with alumni and explore opportunities.',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Recommended Mentors Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recommended Mentors',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 200,
                      child: ListView(
                        scrollDirection: Axis.horizontal,
                        children: const [
                          MentorCard(
                            name: 'Ethan Carter',
                            role: 'Marketing',
                            imageUrl: 'https://example.com/ethan.jpg',
                          ),
                          SizedBox(width: 16),
                          MentorCard(
                            name: 'Olivia Bennett',
                            role: 'Product Management',
                            imageUrl: 'https://example.com/olivia.jpg',
                          ),
                          SizedBox(width: 16),
                          MentorCard(
                            name: 'Noah Thompson',
                            role: 'Finance',
                            imageUrl: 'https://example.com/noah.jpg',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Upcoming Events Section
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upcoming Events',
                      style: TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    EventCard(
                      title: 'Alumni Mixer',
                      subtitle: 'Networking Event',
                      description:
                          'Connect with fellow alumni and industry leaders.',
                      imageUrl: 'https://example.com/event.jpg',
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Side Navigation Menu
          if (_isSideMenuOpen)
            SideNavigation(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) {
                setState(() {
                  _selectedIndex = index;
                  _isSideMenuOpen = false;
                });
                _navigateToPage(index);
              },
              onClose: () {
                setState(() {
                  _isSideMenuOpen = false;
                });
              },
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
          _navigateToPage(index);
        },
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: AppTheme.textSecondary,
        backgroundColor: Colors.white,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Alumni',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.work),
            label: 'Mentorship',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }

  void _navigateToPage(int index) {
    switch (index) {
      case 0:
        // Already on dashboard
        break;
      case 1:
        context.go('/alumni');
        break;
      case 2:
        context.go('/mentorship');
        break;
      case 3:
        context.go('/notifications');
        break;
    }
  }
}
