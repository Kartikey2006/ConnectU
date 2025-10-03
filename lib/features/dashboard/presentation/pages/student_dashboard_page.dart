import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart'
    as auth_bloc;
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';

class StudentDashboardPage extends StatefulWidget {
  const StudentDashboardPage({super.key});

  @override
  State<StudentDashboardPage> createState() => _StudentDashboardPageState();
}

class _StudentDashboardPageState extends State<StudentDashboardPage> {
  int _selectedIndex = 0;
  int _selectedSideIndex = 0;
  bool _isSideMenuOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.surfaceColor,
              Color(0xFFF1F5F9),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Main Content
            Column(
              children: [
                // Modern Header
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: AppTheme.cardShadow,
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _isSideMenuOpen = !_isSideMenuOpen;
                                  });
                                },
                                icon: const Icon(
                                  Icons.menu_rounded,
                                  color: AppTheme.primaryColor,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    'Student',
                                    style: TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                  Text(
                                    'Connect with alumni and explore opportunities',
                                    style: TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 14,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: () => context.go('/notifications'),
                                icon: const Icon(
                                  Icons.notifications_outlined,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              decoration: BoxDecoration(
                                color: AppTheme.accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                onPressed: () => context.go('/test-navigation'),
                                icon: const Icon(
                                  Icons.bug_report_rounded,
                                  color: AppTheme.accentColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Main Content Area
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Section
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: AppTheme.floatingShadow,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: const Icon(
                                      Icons.school_rounded,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        BlocBuilder<auth_bloc.AuthBloc,
                                            auth_bloc.AuthState>(
                                          builder: (context, state) {
                                            String userName = 'Student';
                                            if (state
                                                is auth_bloc.Authenticated) {
                                              userName = state.user.user.name;
                                            }
                                            return Text(
                                              'Welcome back, $userName!',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.5,
                                              ),
                                            );
                                          },
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Ready to connect with amazing alumni?',
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildQuickStat(
                                      'Active Sessions',
                                      '3',
                                      Icons.people_rounded,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildQuickStat(
                                      'New Opportunities',
                                      '12',
                                      Icons.work_rounded,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Mentorship Notifications Section
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.people_alt_rounded,
                                color: AppTheme.primaryColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Mentorship Updates',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Mentorship Notifications List
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: AppTheme.cardShadow,
                          ),
                          child: Column(
                            children: [
                              _buildMentorshipNotification(
                                title:
                                    'New mentorship session scheduled with Dr. Evelyn Reed',
                                subtitle: 'Mentorship Updates',
                                time: '2 minutes ago',
                                isUnread: true,
                                onTap: () => context.go('/mentorship'),
                              ),
                              const SizedBox(height: 12),
                              _buildMentorshipNotification(
                                title:
                                    'Your session with Ethan Carter has been confirmed',
                                subtitle: 'Session Confirmation',
                                time: '1 hour ago',
                                isUnread: true,
                                onTap: () => context.go('/mentorship'),
                              ),
                              const SizedBox(height: 12),
                              _buildMentorshipNotification(
                                title:
                                    'Mentorship feedback received from Olivia Bennett',
                                subtitle: 'Feedback',
                                time: '3 hours ago',
                                isUnread: false,
                                onTap: () => context.go('/mentorship'),
                              ),
                              const SizedBox(height: 12),
                              _buildMentorshipNotification(
                                title:
                                    'New mentor available: Amit Patel (Finance)',
                                subtitle: 'New Mentor',
                                time: '1 day ago',
                                isUnread: false,
                                onTap: () => context.go('/mentorship'),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Recommended Mentors Section
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppTheme.accentColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.star_rounded,
                                color: AppTheme.accentColor,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Recommended Mentors',
                              style: TextStyle(
                                color: AppTheme.textPrimary,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Mentors List
                        SizedBox(
                          height: 220,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: const [
                              SizedBox(width: 4),
                              MentorCard(
                                name: 'Rajesh Kumar',
                                role: 'Product Manager at TechCorp',
                              ),
                              SizedBox(width: 16),
                              MentorCard(
                                name: 'Priya Sharma',
                                role: 'Marketing Director at InnovateCorp',
                              ),
                              SizedBox(width: 16),
                              MentorCard(
                                name: 'Amit Patel',
                                role:
                                    'Senior Financial Analyst at DataSolutions',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Smart Mentorship Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF1979E6), Color(0xFF0D47A1)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF1979E6).withOpacity(0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: const Icon(
                                      Icons.psychology,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  const Expanded(
                                    child: Text(
                                      'AI-Powered Mentor Matching',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text(
                                      'NEW',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Find your perfect mentor using our advanced AI matching system. Get personalized recommendations based on your goals, skills, and preferences.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  height: 1.4,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () =>
                                          context.go('/smart-mentorship'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor:
                                            const Color(0xFF1979E6),
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'Find My Mentor',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  OutlinedButton(
                                    onPressed: () => context.go('/mentorship'),
                                    style: OutlinedButton.styleFrom(
                                      foregroundColor: Colors.white,
                                      side:
                                          const BorderSide(color: Colors.white),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Browse All',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Job Opportunities Section
                        Row(
                          children: [
                            const Text(
                              'Job Opportunities',
                              style: TextStyle(
                                color: Color(0xFF0E141B),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.015,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () => context.go('/jobs'),
                              child: const Text(
                                'View All',
                                style: TextStyle(
                                  color: Color(0xFF1979E6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildJobCard(
                          title: 'Senior Software Engineer',
                          company: 'Google',
                          location: 'Bangalore',
                          salary: '₹15-25 LPA',
                          postedBy: 'Sarah Chen',
                          onTap: () => context.go('/jobs'),
                        ),
                        const SizedBox(height: 12),
                        _buildJobCard(
                          title: 'Product Manager Intern',
                          company: 'Microsoft',
                          location: 'Mumbai',
                          salary: '₹30k/month',
                          postedBy: 'Rajesh Kumar',
                          onTap: () => context.go('/jobs'),
                        ),

                        const SizedBox(height: 24),

                        // Resume Upload Section
                        const Text(
                          'Resume & Documents',
                          style: TextStyle(
                            color: Color(0xFF0E141B),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.015,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => _showResumeOptions(context),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.upload_file,
                                    color: Color(0xFF10B981),
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Upload Resume',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0E141B),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Upload your resume to get noticed by alumni and recruiters',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF4E7097),
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF10B981)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Text(
                                              'PDF, DOC, DOCX',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF10B981),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1979E6)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Text(
                                              'Max 5MB',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF1979E6),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF4E7097),
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Community Forums Section
                        const Text(
                          'Community Forums',
                          style: TextStyle(
                            color: Color(0xFF0E141B),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.015,
                          ),
                        ),
                        const SizedBox(height: 16),
                        GestureDetector(
                          onTap: () => context.go('/forums'),
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1979E6)
                                        .withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.forum,
                                    color: Color(0xFF1979E6),
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Join Discussions',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF0E141B),
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Connect with alumni, share insights, and participate in community discussions',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Color(0xFF4E7097),
                                          height: 1.4,
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF10B981)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Text(
                                              '24 active discussions',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF10B981),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF1979E6)
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            ),
                                            child: const Text(
                                              '156 members online',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF1979E6),
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                  color: Color(0xFF4E7097),
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Upcoming Events Section
                        const Text(
                          'Upcoming Events',
                          style: TextStyle(
                            color: Color(0xFF0E141B),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.015,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const EventCard(
                          title: 'Alumni Mixer',
                          subtitle: 'Networking Event',
                          description:
                              'Connect with fellow alumni and industry leaders.',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            // Side Navigation Menu
            if (_isSideMenuOpen)
              SideNavigation(
                selectedIndex: _selectedSideIndex,
                onItemSelected: (index) {
                  setState(() {
                    _selectedSideIndex = index;
                    _isSideMenuOpen = false;
                  });
                  _navigateFromSideMenu(index);
                },
                onClose: () {
                  setState(() {
                    _isSideMenuOpen = false;
                  });
                },
              ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: AppTheme.cardShadow,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
              _navigateFromBottomNav(index);
            },
            selectedItemColor: AppTheme.primaryColor,
            unselectedItemColor: AppTheme.textSecondary,
            backgroundColor: Colors.white,
            elevation: 0,
            selectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded, size: 24),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.people_rounded, size: 24),
                label: 'Alumni',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.work_rounded, size: 24),
                label: 'Mentorship',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_rounded, size: 24),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateFromBottomNav(int index) {
    print('🔍 Bottom Navigation: Navigating to index $index');
    switch (index) {
      case 0:
        // Home - Already on dashboard
        print('🏠 Staying on dashboard');
        break;
      case 1:
        // Alumni - go to alumni page
        print('👥 Navigating to alumni page');
        context.go('/alumni');
        break;
      case 2:
        // Mentorship
        print('🤝 Navigating to mentorship page');
        context.go('/mentorship');
        break;
      case 3:
        // Profile
        print('👤 Navigating to profile page');
        context.go('/student-profile');
        break;
    }
  }

  void _navigateFromSideMenu(int index) {
    print('🔍 Side Menu: Navigating to index $index');
    switch (index) {
      case 0:
        // Dashboard - Already on dashboard
        print('🏠 Staying on dashboard');
        break;
      case 1:
        // Find Alumni
        print('👥 Navigating to alumni page');
        context.go('/alumni');
        break;
      case 2:
        // Mentorship
        print('🤝 Navigating to mentorship page');
        context.go('/mentorship');
        break;
      case 3:
        // Events
        print('📅 Navigating to events page');
        context.push('/events');
        break;
      case 4:
        // Webinars
        print('🎥 Navigating to webinars page');
        context.push('/webinars');
        break;
      case 5:
        // Forums
        print('💬 Navigating to forums page');
        context.go('/forums');
        break;
    }
  }

  Widget _buildQuickStat(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMentorshipNotification({
    required String title,
    required String subtitle,
    required String time,
    required bool isUnread,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: isUnread
            ? AppTheme.primaryColor.withOpacity(0.05)
            : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isUnread
              ? AppTheme.primaryColor.withOpacity(0.2)
              : Colors.grey.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.people_rounded,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isUnread
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                color: AppTheme.textPrimary,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                          if (isUnread) ...[
                            const SizedBox(width: 8),
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppTheme.primaryColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
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
        ),
      ),
    );
  }

  Widget _buildJobCard({
    required String title,
    required String company,
    required String location,
    required String salary,
    required String postedBy,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1979E6).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.business,
                    color: Color(0xFF1979E6),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0E141B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        company,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4E7097),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    salary,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Color(0xFF4E7097),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      location,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF4E7097),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.person,
                      size: 14,
                      color: Color(0xFF4E7097),
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        'Posted by $postedBy',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4E7097),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showResumeOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Upload Resume',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0E141B),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose how you want to upload your resume',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF4E7097),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildResumeOption(
                    icon: Icons.upload_file,
                    title: 'Upload File',
                    subtitle: 'PDF, DOC, DOCX',
                    onTap: () {
                      Navigator.pop(context);
                      _uploadResumeFile();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildResumeOption(
                    icon: Icons.create,
                    title: 'Create Online',
                    subtitle: 'Build with template',
                    onTap: () {
                      Navigator.pop(context);
                      _createResumeOnline();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildResumeOption(
                    icon: Icons.link,
                    title: 'Add Link',
                    subtitle: 'LinkedIn, Portfolio',
                    onTap: () {
                      Navigator.pop(context);
                      _addResumeLink();
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildResumeOption(
                    icon: Icons.visibility,
                    title: 'View Current',
                    subtitle: 'See uploaded resume',
                    onTap: () {
                      Navigator.pop(context);
                      _viewCurrentResume();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildResumeOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: const Color(0xFF1979E6),
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0E141B),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF4E7097),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _uploadResumeFile() {
    // TODO: Implement file upload functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File upload feature coming soon!'),
        backgroundColor: Color(0xFF1979E6),
      ),
    );
  }

  void _createResumeOnline() {
    // TODO: Implement online resume builder
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Online resume builder coming soon!'),
        backgroundColor: Color(0xFF10B981),
      ),
    );
  }

  void _addResumeLink() {
    // TODO: Implement resume link functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Resume link feature coming soon!'),
        backgroundColor: Color(0xFFF59E0B),
      ),
    );
  }

  void _viewCurrentResume() {
    // TODO: Implement view current resume functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('No resume uploaded yet. Upload one to get started!'),
        backgroundColor: Color(0xFF6B7280),
      ),
    );
  }
}

class MentorCard extends StatelessWidget {
  final String name;
  final String role;
  final String? imageUrl;

  const MentorCard({
    super.key,
    required this.name,
    required this.role,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
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
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFE7EDF3),
            ),
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return _buildAvatarPlaceholder();
                      },
                    ),
                  )
                : _buildAvatarPlaceholder(),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(
              color: Color(0xFF0E141B),
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            role,
            style: const TextStyle(
              color: Color(0xFF4E7097),
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarPlaceholder() {
    final initials = name
        .split(' ')
        .map((e) => e.isNotEmpty ? e[0] : '')
        .take(2)
        .join()
        .toUpperCase();
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: const LinearGradient(
          colors: [Color(0xFF1979E6), Color(0xFF4A90E2)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String? imageUrl;

  const EventCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Color(0xFF4E7097),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF0E141B),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF4E7097),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => context.push('/events'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFE7EDF3),
                    foregroundColor: const Color(0xFF0E141B),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('View Details'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            width: 120,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: const Color(0xFFE7EDF3),
            ),
            child: imageUrl != null && imageUrl!.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.event,
                          size: 40,
                          color: Color(0xFF4E7097),
                        );
                      },
                    ),
                  )
                : const Icon(
                    Icons.event,
                    size: 40,
                    color: Color(0xFF4E7097),
                  ),
          ),
        ],
      ),
    );
  }
}

class SideNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onClose;

  const SideNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.4),
      child: Row(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.83,
            height: double.infinity,
            color: const Color(0xFFF8FAFC),
            child: Column(
              children: [
                // User name
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: BlocBuilder<auth_bloc.AuthBloc, auth_bloc.AuthState>(
                    builder: (context, state) {
                      String userName = 'Student';
                      if (state is auth_bloc.Authenticated) {
                        userName = state.user.user.name;
                      }
                      return Text(
                        userName,
                        style: const TextStyle(
                          color: Color(0xFF0E141B),
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.015,
                        ),
                      );
                    },
                  ),
                ),

                // Navigation items
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        _buildNavItem(
                          icon: Icons.home,
                          label: 'Dashboard',
                          isSelected: selectedIndex == 0,
                          onTap: () => onItemSelected(0),
                        ),
                        const SizedBox(height: 16),
                        _buildNavItem(
                          icon: Icons.people,
                          label: 'Find Alumni',
                          isSelected: selectedIndex == 1,
                          onTap: () => onItemSelected(1),
                        ),
                        const SizedBox(height: 16),
                        _buildNavItem(
                          icon: Icons.groups,
                          label: 'Mentorship',
                          isSelected: selectedIndex == 2,
                          onTap: () => onItemSelected(2),
                        ),
                        const SizedBox(height: 16),
                        _buildNavItem(
                          icon: Icons.event,
                          label: 'Events',
                          isSelected: selectedIndex == 3,
                          onTap: () => onItemSelected(3),
                        ),
                        const SizedBox(height: 16),
                        _buildNavItem(
                          icon: Icons.video_call,
                          label: 'Webinars',
                          isSelected: selectedIndex == 4,
                          onTap: () => onItemSelected(4),
                        ),
                        const SizedBox(height: 16),
                        _buildNavItem(
                          icon: Icons.forum,
                          label: 'Forums',
                          isSelected: selectedIndex == 5,
                          onTap: () => onItemSelected(5),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE7EDF3) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: const Color(0xFF0E141B),
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF0E141B),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
