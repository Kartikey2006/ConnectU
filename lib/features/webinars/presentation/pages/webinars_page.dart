import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';
import 'package:connectu_alumni_platform/core/widgets/modern_widgets.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WebinarsPage extends StatefulWidget {
  const WebinarsPage({super.key});

  @override
  State<WebinarsPage> createState() => _WebinarsPageState();
}

class _WebinarsPageState extends State<WebinarsPage> {
  String selectedCategory = 'All';
  final List<String> categories = [
    'All',
    'Technology',
    'Business',
    'Career',
    'Personal Development'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      body: Column(
        children: [
          // Modern Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              boxShadow: AppTheme.floatingShadow,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        String dashboardRoute = '/student-dashboard';
                        if (state is Authenticated) {
                          if (state.user.user.role.name == 'alumni') {
                            dashboardRoute = '/alumni-dashboard';
                          }
                        }
                        return ModernIconButton(
                          icon: Icons.arrow_back_rounded,
                          onPressed: () => context.go(dashboardRoute),
                          backgroundColor: Colors.white.withOpacity(0.2),
                          iconColor: Colors.white,
                          size: 40,
                        );
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Webinars',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    ModernIconButton(
                      icon: Icons.search_rounded,
                      onPressed: () => _showSearchDialog(context),
                      backgroundColor: Colors.white.withOpacity(0.2),
                      iconColor: Colors.white,
                      size: 40,
                    ),
                    const SizedBox(width: 8),
                    ModernIconButton(
                      icon: Icons.filter_list_rounded,
                      onPressed: () => _showFilterDialog(context),
                      backgroundColor: Colors.white.withOpacity(0.2),
                      iconColor: Colors.white,
                      size: 40,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Learn from industry experts and expand your knowledge',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),

          // Stats Section - Compact
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppTheme.cardShadow,
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildCompactStatCard(
                      '12', 'Live Sessions', Icons.video_call_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCompactStatCard(
                      '500+', 'Students', Icons.people_rounded),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildCompactStatCard(
                      '4.8', 'Rating', Icons.star_rounded),
                ),
              ],
            ),
          ),

          // Category Filter - Compact
          Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: _buildCategoryFilter(),
            ),
          ),

          // Webinars List
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Webinar Cards
                  _buildWebinarCard(
                    title: 'Digital Marketing Trends 2024',
                    host: 'Rajesh Kumar',
                    hostTitle: 'Senior Marketing Director at Google',
                    date: 'Dec 20, 2024',
                    time: '2:00 PM',
                    duration: '90 min',
                    price: '₹199',
                    category: 'Technology',
                    description:
                        'Learn the latest digital marketing strategies, tools, and trends that are shaping the industry in 2024.',
                    attendees: 245,
                    rating: 4.9,
                    imageUrl: 'https://example.com/webinar1.jpg',
                    onTap: () => _showWebinarDetails(
                        context, 'Digital Marketing Trends 2024'),
                  ),
                  const SizedBox(height: 16),
                  _buildWebinarCard(
                    title: 'Product Management Fundamentals',
                    host: 'Priya Sharma',
                    hostTitle: 'Product Manager at Microsoft',
                    date: 'Dec 22, 2024',
                    time: '3:00 PM',
                    duration: '60 min',
                    price: '₹149',
                    category: 'Business',
                    description:
                        'Master the core principles of product management from ideation to launch.',
                    attendees: 189,
                    rating: 4.8,
                    imageUrl: 'https://example.com/webinar2.jpg',
                    onTap: () => _showWebinarDetails(
                        context, 'Product Management Fundamentals'),
                  ),
                  const SizedBox(height: 16),
                  _buildWebinarCard(
                    title: 'Financial Planning for Students',
                    host: 'Amit Patel',
                    hostTitle: 'Financial Advisor & Author',
                    date: 'Dec 25, 2024',
                    time: '1:00 PM',
                    duration: '75 min',
                    price: '₹299',
                    category: 'Personal Development',
                    description:
                        'Essential financial planning tips and strategies specifically designed for students.',
                    attendees: 156,
                    rating: 4.7,
                    imageUrl: 'https://example.com/webinar3.jpg',
                    onTap: () => _showWebinarDetails(
                        context, 'Financial Planning for Students'),
                  ),
                  const SizedBox(height: 16),
                  _buildWebinarCard(
                    title: 'AI & Machine Learning Basics',
                    host: 'Dr. Sarah Johnson',
                    hostTitle: 'AI Research Scientist at MIT',
                    date: 'Dec 28, 2024',
                    time: '4:00 PM',
                    duration: '120 min',
                    price: '\$30',
                    category: 'Technology',
                    description:
                        'Introduction to artificial intelligence and machine learning concepts for beginners.',
                    attendees: 312,
                    rating: 4.9,
                    imageUrl: 'https://example.com/webinar4.jpg',
                    onTap: () => _showWebinarDetails(
                        context, 'AI & Machine Learning Basics'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebinarCard({
    required String title,
    required String host,
    required String hostTitle,
    required String date,
    required String time,
    required String duration,
    required String price,
    required String category,
    required String description,
    required int attendees,
    required double rating,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return ModernCard(
      margin: const EdgeInsets.only(bottom: 16),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Webinar Image with Category Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.primaryColor.withOpacity(0.8),
                          AppTheme.primaryColor.withOpacity(0.6),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Icon(
                      Icons.video_call,
                      size: 64,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    category,
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.people, color: Colors.white, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        '$attendees attending',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Webinar Info
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Rating
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            rating.toString(),
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Description
                Text(
                  description,
                  style: const TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 14,
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Host Info
                Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child: Text(
                        host.split(' ').map((e) => e[0]).join(''),
                        style: const TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            host,
                            style: const TextStyle(
                              color: Color(0xFF1F2937),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            hostTitle,
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Info Chips
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(
                      icon: Icons.calendar_today,
                      label: date,
                    ),
                    _buildInfoChip(
                      icon: Icons.access_time,
                      label: time,
                    ),
                    _buildInfoChip(
                      icon: Icons.timer,
                      label: duration,
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Price and Register Button
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 300) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Price',
                                style: TextStyle(
                                  color: AppTheme.textSecondary,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                price,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                              ),
                            ],
                          ),
                          ModernButton(
                            text: 'Register Now',
                            onPressed: onTap,
                            type: ModernButtonType.primary,
                            icon: Icons.add_rounded,
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Price',
                                    style: TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  Text(
                                    price,
                                    style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          ModernButton(
                            text: 'Register Now',
                            onPressed: onTap,
                            type: ModernButtonType.primary,
                            icon: Icons.add_rounded,
                            isFullWidth: true,
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.primaryColor,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactStatCard(String value, String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 18),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Row(
      children: categories.map((category) {
        final isSelected = selectedCategory == category;

        return Container(
          margin: const EdgeInsets.only(right: 8),
          child: GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = category;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryColor : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : AppTheme.textSecondary.withOpacity(0.3),
                  width: 1,
                ),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppTheme.textPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  fontSize: 11,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: 'Search Webinars',
        content: const ModernSearchField(),
        actions: [
          ModernButton(
            text: 'Cancel',
            onPressed: () => context.go('/alumni-dashboard'),
            type: ModernButtonType.ghost,
          ),
          const SizedBox(width: 8),
          ModernButton(
            text: 'Search',
            onPressed: () => context.go('/alumni-dashboard'),
            type: ModernButtonType.primary,
            icon: Icons.search_rounded,
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: 'Filter Webinars',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Free Only'),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
                activeThumbColor: AppTheme.primaryColor,
              ),
            ),
            ListTile(
              title: const Text('This Week'),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
                activeThumbColor: AppTheme.primaryColor,
              ),
            ),
            ListTile(
              title: const Text('High Rating (4.5+)'),
              trailing: Switch(
                value: false,
                onChanged: (value) {},
                activeThumbColor: AppTheme.primaryColor,
              ),
            ),
          ],
        ),
        actions: [
          ModernButton(
            text: 'Cancel',
            onPressed: () => context.go('/alumni-dashboard'),
            type: ModernButtonType.ghost,
          ),
          const SizedBox(width: 8),
          ModernButton(
            text: 'Apply',
            onPressed: () => context.go('/alumni-dashboard'),
            type: ModernButtonType.primary,
          ),
        ],
      ),
    );
  }

  void _showWebinarDetails(BuildContext context, String title) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
          boxShadow: AppTheme.elevatedShadow,
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'What you\'ll learn:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Latest industry trends and insights\n• Practical tools and techniques\n• Real-world case studies\n• Q&A session with the expert\n• Networking opportunities',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Requirements:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      '• Basic computer skills\n• Internet connection\n• Note-taking materials',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: AppTheme.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ModernButton(
                        text: 'Register Now',
                        onPressed: () {
                          context.go('/alumni-dashboard');
                          _showRegistrationDialog(context, title);
                        },
                        type: ModernButtonType.primary,
                        icon: Icons.add_rounded,
                        isFullWidth: true,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRegistrationDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (context) => ModernDialog(
        title: 'Register for Webinar',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'You are about to register for: $title',
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Registration includes:\n• Live webinar access\n• Recording (available for 30 days)\n• Certificate of completion\n• Course materials',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
        actions: [
          ModernButton(
            text: 'Cancel',
            onPressed: () => context.go('/alumni-dashboard'),
            type: ModernButtonType.ghost,
          ),
          const SizedBox(width: 8),
          ModernButton(
            text: 'Confirm Registration',
            onPressed: () {
              context.go('/alumni-dashboard');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Successfully registered for $title!'),
                  backgroundColor: AppTheme.successColor,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            type: ModernButtonType.primary,
            icon: Icons.check_rounded,
          ),
        ],
      ),
    );
  }
}
