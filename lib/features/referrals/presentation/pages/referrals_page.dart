import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';
import 'package:connectu_alumni_platform/features/referrals/domain/entities/referral_request.dart';
import 'package:connectu_alumni_platform/features/referrals/domain/entities/student_profile.dart';
import 'package:connectu_alumni_platform/features/referrals/presentation/pages/referral_request_detail_page.dart';
import 'package:connectu_alumni_platform/core/widgets/modern_widgets.dart';

class ReferralsPage extends StatefulWidget {
  const ReferralsPage({super.key});

  @override
  State<ReferralsPage> createState() => _ReferralsPageState();
}

class _ReferralsPageState extends State<ReferralsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isLoading = false;

  final List<String> _filterOptions = [
    'All',
    'Pending',
    'Guidance Offered',
    'Closed',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

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
            decoration: const BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ModernIconButton(
                      icon: Icons.arrow_back_rounded,
                      onPressed: () => context.go('/alumni-dashboard'),
                      backgroundColor: Colors.white.withOpacity(0.2),
                      iconColor: Colors.white,
                      size: 40,
                    ),
                    const Expanded(
                      child: Text(
                        'Referral Requests',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ModernIconButton(
                      icon: Icons.add_rounded,
                      onPressed: _showCreateReferralDialog,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      iconColor: Colors.white,
                      size: 40,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Connect with students and provide career guidance',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                // Search and Filter
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth < 400) {
                      // Stack vertically on small screens
                      return Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              controller: _searchController,
                              style: const TextStyle(color: Colors.white),
                              decoration: const InputDecoration(
                                hintText: 'Search requests...',
                                hintStyle: TextStyle(color: Colors.white70),
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.search_rounded,
                                    color: Colors.white70),
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _searchQuery = value.toLowerCase();
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedFilter,
                              dropdownColor: AppTheme.surfaceColor,
                              style: const TextStyle(color: Colors.white),
                              underline: const SizedBox(),
                              icon: const Icon(Icons.filter_list_rounded,
                                  color: Colors.white),
                              isExpanded: true,
                              items: _filterOptions.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedFilter = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      // Row layout for larger screens
                      return Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                controller: _searchController,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration(
                                  hintText:
                                      'Search by name, company, or position...',
                                  hintStyle: TextStyle(color: Colors.white70),
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.search_rounded,
                                      color: Colors.white70),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    _searchQuery = value.toLowerCase();
                                  });
                                },
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<String>(
                              value: _selectedFilter,
                              dropdownColor: AppTheme.surfaceColor,
                              style: const TextStyle(color: Colors.white),
                              underline: const SizedBox(),
                              icon: const Icon(Icons.filter_list_rounded,
                                  color: Colors.white),
                              items: _filterOptions.map((String option) {
                                return DropdownMenuItem<String>(
                                  value: option,
                                  child: Text(option),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedFilter = newValue!;
                                });
                              },
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),
          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: AppTheme.textSecondary,
              indicatorColor: AppTheme.primaryColor,
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Active Requests'),
                Tab(text: 'Completed'),
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActiveRequestsTab(),
                _buildCompletedRequestsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveRequestsTab() {
    final activeRequests = _getMockReferralRequests()
        .where((request) => _matchesSearchAndFilter(request))
        .toList();

    if (_isLoading) {
      return const Center(child: ModernLoadingIndicator());
    }

    if (activeRequests.isEmpty) {
      return _buildEmptyState(
        icon: Icons.pending_actions_rounded,
        title: 'No Active Requests',
        subtitle: _searchQuery.isNotEmpty || _selectedFilter != 'All'
            ? 'No requests match your current search or filter criteria.'
            : 'You don\'t have any active referral requests at the moment.',
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: activeRequests.length,
        itemBuilder: (context, index) {
          final request = activeRequests[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildModernReferralCard(
              request: request,
              onTap: () => _navigateToDetail(request),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCompletedRequestsTab() {
    final completedRequests = _getMockCompletedReferralRequests()
        .where((request) => _matchesSearchAndFilter(request))
        .toList();

    if (_isLoading) {
      return const Center(child: ModernLoadingIndicator());
    }

    if (completedRequests.isEmpty) {
      return _buildEmptyState(
        icon: Icons.check_circle_outline_rounded,
        title: 'No Completed Requests',
        subtitle: _searchQuery.isNotEmpty || _selectedFilter != 'All'
            ? 'No completed requests match your current search or filter criteria.'
            : 'You haven\'t completed any referral requests yet.',
      );
    }

    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: completedRequests.length,
        itemBuilder: (context, index) {
          final request = completedRequests[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildModernReferralCard(
              request: request,
              onTap: () => _navigateToDetail(request),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: AppTheme.primaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 16,
                color: AppTheme.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (_searchQuery.isNotEmpty || _selectedFilter != 'All') ...[
              const SizedBox(height: 24),
              ModernButton(
                text: 'Clear Filters',
                onPressed: () {
                  setState(() {
                    _searchQuery = '';
                    _selectedFilter = 'All';
                    _searchController.clear();
                  });
                },
                type: ModernButtonType.outline,
                icon: Icons.clear_rounded,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildModernReferralCard({
    required ReferralRequest request,
    required VoidCallback onTap,
  }) {
    Color statusColor;
    IconData statusIcon;
    switch (request.status) {
      case ReferralRequestStatus.pending:
        statusColor = AppTheme.warningColor;
        statusIcon = Icons.pending_rounded;
        break;
      case ReferralRequestStatus.guidanceOffered:
        statusColor = AppTheme.successColor;
        statusIcon = Icons.check_circle_rounded;
        break;
      case ReferralRequestStatus.closed:
        statusColor = AppTheme.textSecondary;
        statusIcon = Icons.cancel_rounded;
        break;
    }

    return ModernCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: AppTheme.accentGradient,
                ),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.transparent,
                  backgroundImage: request.student.profileImageUrl != null
                      ? NetworkImage(request.student.profileImageUrl!)
                      : null,
                  child: request.student.profileImageUrl == null
                      ? const Icon(
                          Icons.person_rounded,
                          size: 28,
                          color: Colors.white,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.student.name,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    if (request.company != null && request.position != null)
                      Text(
                        '${request.position} at ${request.company}',
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )
                    else if (request.position != null)
                      Text(
                        request.position!,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      )
                    else
                      const Text(
                        'Career Guidance Request',
                        style: TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statusColor.withOpacity(0.3)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        statusIcon,
                        size: 16,
                        color: statusColor,
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          request.statusDisplayName,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.surfaceColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              request.message ?? 'No message provided',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildModernInfoChip(
                icon: Icons.email_rounded,
                label: request.student.email,
              ),
              _buildModernInfoChip(
                icon: Icons.calendar_today_rounded,
                label: _formatDate(request.createdAt),
              ),
              if (request.company != null)
                _buildModernInfoChip(
                  icon: Icons.business_rounded,
                  label: request.company!,
                ),
            ],
          ),
          if (request.isActive) ...[
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth < 300) {
                  // Stack vertically on very small screens
                  return Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ModernButton(
                          text: 'Provide Guidance',
                          onPressed: () => _handleGuideAction(request),
                          type: ModernButtonType.primary,
                          icon: Icons.lightbulb_outline_rounded,
                          size: ModernButtonSize.small,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ModernButton(
                          text: 'Decline',
                          onPressed: () => _handleDeclineAction(request),
                          type: ModernButtonType.outline,
                          icon: Icons.close_rounded,
                          size: ModernButtonSize.small,
                        ),
                      ),
                    ],
                  );
                } else {
                  // Row layout for larger screens
                  return Row(
                    children: [
                      Expanded(
                        child: ModernButton(
                          text: 'Provide Guidance',
                          onPressed: () => _handleGuideAction(request),
                          type: ModernButtonType.primary,
                          icon: Icons.lightbulb_outline_rounded,
                          size: ModernButtonSize.small,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ModernButton(
                          text: 'Decline',
                          onPressed: () => _handleDeclineAction(request),
                          type: ModernButtonType.outline,
                          icon: Icons.close_rounded,
                          size: ModernButtonSize.small,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModernInfoChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryColor.withOpacity(0.2)),
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
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                color: AppTheme.primaryColor,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  bool _matchesSearchAndFilter(ReferralRequest request) {
    // Search filter
    bool matchesSearch = _searchQuery.isEmpty ||
        request.student.name.toLowerCase().contains(_searchQuery) ||
        request.student.email.toLowerCase().contains(_searchQuery) ||
        (request.company?.toLowerCase().contains(_searchQuery) ?? false) ||
        (request.position?.toLowerCase().contains(_searchQuery) ?? false) ||
        (request.message?.toLowerCase().contains(_searchQuery) ?? false);

    // Status filter
    bool matchesFilter = _selectedFilter == 'All' ||
        request.statusDisplayName == _selectedFilter;

    return matchesSearch && matchesFilter;
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToDetail(ReferralRequest request) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReferralRequestDetailPage(request: request),
      ),
    );
  }

  void _handleGuideAction(ReferralRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Provide Guidance'),
        content: Text(
            'Are you sure you want to provide guidance to ${request.student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showGuidanceDialog(request);
            },
            child: const Text('Yes, Provide Guidance'),
          ),
        ],
      ),
    );
  }

  void _handleDeclineAction(ReferralRequest request) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Decline Request'),
        content: Text(
            'Are you sure you want to decline ${request.student.name}\'s request?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _declineRequest(request);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
              foregroundColor: Colors.white,
            ),
            child: const Text('Yes, Decline'),
          ),
        ],
      ),
    );
  }

  void _showGuidanceDialog(ReferralRequest request) {
    final TextEditingController messageController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Provide Guidance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Send a message to ${request.student.name}',
              style: const TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Type your guidance message here...',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (messageController.text.trim().isNotEmpty) {
                Navigator.of(context).pop();
                _sendGuidance(request, messageController.text.trim());
              }
            },
            child: const Text('Send Guidance'),
          ),
        ],
      ),
    );
  }

  void _sendGuidance(ReferralRequest request, String message) {
    // Simulate API call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Guidance sent to ${request.student.name}!'),
        backgroundColor: AppTheme.successColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // Update the request status (in a real app, this would be an API call)
    setState(() {
      // This would update the request status in the actual data
    });
  }

  void _declineRequest(ReferralRequest request) {
    // Simulate API call
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request from ${request.student.name} declined'),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // Update the request status (in a real app, this would be an API call)
    setState(() {
      // This would update the request status in the actual data
    });
  }

  void _showCreateReferralDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Referral Request'),
        content: const Text(
          'This feature allows you to create a new referral request. In a real application, this would open a form to create a new request.',
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  List<ReferralRequest> _getMockReferralRequests() {
    return [
      ReferralRequest(
        id: 1,
        student: StudentProfile(
          id: 101,
          name: 'Alex Johnson',
          email: 'alex.johnson@university.edu',
          profileImageUrl:
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150&h=150&fit=crop&crop=face',
          bio:
              'Computer Science student passionate about software development and AI.',
          phoneNumber: '+1 (555) 123-4567',
          resumeUrl: 'https://example.com/resumes/alex_johnson.pdf',
          education: const EducationDetails(
            university: 'Stanford University',
            degree: 'Bachelor of Science',
            fieldOfStudy: 'Computer Science',
            graduationYear: '2025',
            gpa: 3.8,
            relevantCoursework: [
              'Data Structures',
              'Algorithms',
              'Machine Learning',
              'Software Engineering'
            ],
          ),
          skills: [
            'Python',
            'Java',
            'JavaScript',
            'React',
            'Node.js',
            'Machine Learning',
            'Git'
          ],
          projects: [
            const Project(
              name: 'AI Chatbot Assistant',
              description:
                  'Developed an intelligent chatbot using NLP and machine learning to help students with course selection and academic planning.',
              technologies: 'Python, TensorFlow, Flask, PostgreSQL',
              githubUrl: 'https://github.com/alexjohnson/ai-chatbot',
              duration: '3 months',
            ),
            const Project(
              name: 'E-commerce Platform',
              description:
                  'Built a full-stack e-commerce platform with user authentication, payment integration, and admin dashboard.',
              technologies: 'React, Node.js, MongoDB, Stripe API',
              githubUrl: 'https://github.com/alexjohnson/ecommerce-platform',
              liveUrl: 'https://alexjohnson-ecommerce.vercel.app',
              duration: '2 months',
            ),
          ],
          workExperience: [
            const WorkExperience(
              company: 'Tech Startup Inc.',
              position: 'Software Development Intern',
              duration: 'Summer 2024',
              description: 'Worked on frontend development and API integration',
              responsibilities: [
                'Developed React components',
                'Integrated REST APIs',
                'Participated in code reviews'
              ],
            ),
          ],
          personalNote:
              'I\'m really excited about the opportunity to learn from experienced professionals in the tech industry. I\'m particularly interested in understanding how to transition from academic projects to real-world software development.',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
        ),
        alumniId: 1,
        company: 'Google',
        position: 'Software Engineer Intern',
        message:
            'Hi! I\'m a CS student at Stanford and I\'m very interested in interning at Google. I\'d love to get some guidance on how to prepare for the application process and what skills I should focus on developing.',
        status: ReferralRequestStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      ReferralRequest(
        id: 2,
        student: StudentProfile(
          id: 102,
          name: 'Sarah Chen',
          email: 'sarah.chen@university.edu',
          profileImageUrl:
              'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150&h=150&fit=crop&crop=face',
          bio:
              'Business student with a passion for product management and user experience.',
          phoneNumber: '+1 (555) 987-6543',
          resumeUrl: 'https://example.com/resumes/sarah_chen.pdf',
          education: const EducationDetails(
            university: 'UC Berkeley',
            degree: 'Bachelor of Science',
            fieldOfStudy: 'Business Administration',
            graduationYear: '2024',
            gpa: 3.9,
            relevantCoursework: [
              'Product Management',
              'Marketing Analytics',
              'User Research',
              'Business Strategy'
            ],
          ),
          skills: [
            'Product Management',
            'Figma',
            'SQL',
            'Analytics',
            'User Research',
            'Agile',
            'Project Management'
          ],
          projects: [
            const Project(
              name: 'Mobile App Redesign',
              description:
                  'Led a team to redesign a mobile app\'s user interface, resulting in 40% improvement in user engagement.',
              technologies: 'Figma, Adobe Creative Suite, User Testing',
              duration: '4 months',
            ),
          ],
          workExperience: [
            const WorkExperience(
              company: 'Local Marketing Agency',
              position: 'Marketing Intern',
              duration: 'Summer 2023',
              description:
                  'Assisted with digital marketing campaigns and analytics',
              responsibilities: [
                'Created social media content',
                'Analyzed campaign performance',
                'Conducted market research'
              ],
            ),
          ],
          personalNote:
              'I\'m particularly interested in learning about the product development process at Microsoft and how to build products that truly serve users\' needs.',
          createdAt: DateTime.now().subtract(const Duration(days: 4)),
        ),
        alumniId: 1,
        company: 'Microsoft',
        position: 'Product Manager',
        message:
            'Hello! I\'m a business student interested in product management roles. Could you share insights about the PM role at Microsoft and any advice on building a career in this field?',
        status: ReferralRequestStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
      ),
    ];
  }

  List<ReferralRequest> _getMockCompletedReferralRequests() {
    return [
      ReferralRequest(
        id: 3,
        student: StudentProfile(
          id: 103,
          name: 'Mike Davis',
          email: 'mike.davis@university.edu',
          profileImageUrl:
              'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150&h=150&fit=crop&crop=face',
          bio:
              'Data Science student passionate about analytics and business intelligence.',
          education: const EducationDetails(
            university: 'MIT',
            degree: 'Master of Science',
            fieldOfStudy: 'Data Science',
            graduationYear: '2024',
            gpa: 3.7,
          ),
          skills: [
            'Python',
            'R',
            'SQL',
            'Tableau',
            'Machine Learning',
            'Statistics'
          ],
          projects: [
            const Project(
              name: 'Predictive Analytics Dashboard',
              description:
                  'Built a dashboard for predicting customer churn using machine learning models.',
              technologies: 'Python, Scikit-learn, Tableau, PostgreSQL',
              duration: '2 months',
            ),
          ],
          personalNote:
              'I\'m excited to learn about data-driven decision making in a corporate environment.',
          createdAt: DateTime.now().subtract(const Duration(days: 15)),
        ),
        alumniId: 1,
        company: 'Amazon',
        position: 'Data Analyst',
        message:
            'Hi! I\'m interested in data analyst roles at Amazon. Could you provide guidance on the application process?',
        status: ReferralRequestStatus.guidanceOffered,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        updatedAt: DateTime.now().subtract(const Duration(days: 10)),
        responseMessage:
            'I\'d be happy to help you prepare for data analyst roles. Let\'s schedule a call to discuss your background and career goals.',
      ),
      ReferralRequest(
        id: 4,
        student: StudentProfile(
          id: 104,
          name: 'Emily Wilson',
          email: 'emily.wilson@university.edu',
          profileImageUrl:
              'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=150&h=150&fit=crop&crop=face',
          bio:
              'Design student with focus on user experience and visual design.',
          education: const EducationDetails(
            university: 'Art Center College of Design',
            degree: 'Bachelor of Fine Arts',
            fieldOfStudy: 'Graphic Design',
            graduationYear: '2025',
            gpa: 3.6,
          ),
          skills: [
            'UI/UX Design',
            'Adobe Creative Suite',
            'Figma',
            'Sketch',
            'Prototyping',
            'User Research'
          ],
          projects: [
            const Project(
              name: 'Healthcare App Design',
              description:
                  'Designed a mobile app interface for healthcare appointment booking with focus on accessibility.',
              technologies: 'Figma, Principle, Adobe XD',
              duration: '3 months',
            ),
          ],
          personalNote:
              'I\'m passionate about creating inclusive design solutions that improve user experiences.',
          createdAt: DateTime.now().subtract(const Duration(days: 20)),
        ),
        alumniId: 1,
        company: 'Netflix',
        position: 'UX Designer',
        message:
            'Hello! I\'m a design student interested in UX roles at Netflix. Could you share insights about the design process there?',
        status: ReferralRequestStatus.closed,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
        updatedAt: DateTime.now().subtract(const Duration(days: 18)),
        responseMessage:
            'Thank you for reaching out. While I can\'t provide specific guidance at this time, I encourage you to continue building your design portfolio and applying to various opportunities.',
      ),
    ];
  }
}
