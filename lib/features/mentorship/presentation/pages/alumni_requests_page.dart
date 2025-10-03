import 'package:flutter/material.dart';
import 'package:connectu_alumni_platform/core/utils/navigation_utils.dart';

class AlumniRequestsPage extends StatefulWidget {
  const AlumniRequestsPage({super.key});

  @override
  State<AlumniRequestsPage> createState() => _AlumniRequestsPageState();
}

class _AlumniRequestsPageState extends State<AlumniRequestsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final int _selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: IconButton(
          onPressed: () => NavigationUtils.safeBack(context),
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF0E141B),
            size: 24,
          ),
        ),
        title: const Text(
          'Student Requests',
          style: TextStyle(
            color: Color(0xFF0E141B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.015,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showFilterDialog(),
            icon: const Icon(
              Icons.filter_list,
              color: Color(0xFF0E141B),
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () => _showNotificationSettings(),
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFF0E141B),
              size: 24,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFF0E141B),
          unselectedLabelColor: const Color(0xFF4E7097),
          indicatorColor: const Color(0xFF1979E6),
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'Active'),
            Tab(text: 'Completed'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Stats Overview
          Container(
            margin: const EdgeInsets.all(16),
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
                Expanded(
                  child: _buildStatItem(
                    'Pending',
                    '12',
                    Icons.hourglass_empty,
                    const Color(0xFFF59E0B),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: const Color(0xFFE7EDF3),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Active',
                    '8',
                    Icons.people,
                    const Color(0xFF10B981),
                  ),
                ),
                Container(
                  width: 1,
                  height: 40,
                  color: const Color(0xFFE7EDF3),
                ),
                Expanded(
                  child: _buildStatItem(
                    'Completed',
                    '45',
                    Icons.check_circle,
                    const Color(0xFF6366F1),
                  ),
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildPendingRequestsTab(),
                _buildActiveRequestsTab(),
                _buildCompletedRequestsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showBulkActionsDialog(),
        backgroundColor: const Color(0xFF1979E6),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.checklist),
        label: const Text('Bulk Actions'),
      ),
    );
  }

  Widget _buildStatItem(
      String title, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E141B),
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF4E7097),
          ),
        ),
      ],
    );
  }

  Widget _buildPendingRequestsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildRequestCard(
          studentName: 'Emily Johnson',
          studentEmail: 'emily.johnson@university.edu',
          requestType: 'Career Mentorship',
          subject: 'Seeking guidance in Product Management career path',
          timeAgo: '2 hours ago',
          priority: 'High',
          studentYear: '3rd Year',
          major: 'Computer Science',
          interests: ['Product Management', 'Tech Startups', 'UI/UX'],
          isPending: true,
        ),
        const SizedBox(height: 16),
        _buildRequestCard(
          studentName: 'Michael Chen',
          studentEmail: 'michael.chen@university.edu',
          requestType: 'Interview Preparation',
          subject: 'Mock interviews for Software Engineering positions',
          timeAgo: '5 hours ago',
          priority: 'Medium',
          studentYear: '4th Year',
          major: 'Software Engineering',
          interests: ['Full Stack Development', 'System Design', 'Algorithms'],
          isPending: true,
        ),
        const SizedBox(height: 16),
        _buildRequestCard(
          studentName: 'Sarah Williams',
          studentEmail: 'sarah.williams@university.edu',
          requestType: 'Industry Insights',
          subject: 'Learning about Marketing in Tech Industry',
          timeAgo: '1 day ago',
          priority: 'Low',
          studentYear: '2nd Year',
          major: 'Marketing',
          interests: ['Digital Marketing', 'Brand Strategy', 'Analytics'],
          isPending: true,
        ),
      ],
    );
  }

  Widget _buildActiveRequestsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildRequestCard(
          studentName: 'David Kumar',
          studentEmail: 'david.kumar@university.edu',
          requestType: 'Career Mentorship',
          subject: 'Data Science career transition guidance',
          timeAgo: 'Started 1 week ago',
          priority: 'High',
          studentYear: '4th Year',
          major: 'Mathematics',
          interests: ['Data Science', 'Machine Learning', 'Statistics'],
          isPending: false,
          isActive: true,
          nextSession: 'Tomorrow 3:00 PM',
        ),
        const SizedBox(height: 16),
        _buildRequestCard(
          studentName: 'Lisa Zhang',
          studentEmail: 'lisa.zhang@university.edu',
          requestType: 'Project Review',
          subject: 'Portfolio review and feedback',
          timeAgo: 'Started 3 days ago',
          priority: 'Medium',
          studentYear: '3rd Year',
          major: 'Design',
          interests: ['UI/UX Design', 'Web Development', 'Design Systems'],
          isPending: false,
          isActive: true,
          nextSession: 'Friday 2:00 PM',
        ),
      ],
    );
  }

  Widget _buildCompletedRequestsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        _buildRequestCard(
          studentName: 'Alex Rodriguez',
          studentEmail: 'alex.rodriguez@university.edu',
          requestType: 'Job Referral',
          subject: 'Software Engineer position at Google',
          timeAgo: 'Completed 1 week ago',
          priority: 'High',
          studentYear: '4th Year',
          major: 'Computer Science',
          interests: [
            'Backend Development',
            'Cloud Computing',
            'Distributed Systems'
          ],
          isPending: false,
          isCompleted: true,
          outcome: 'Successfully referred and interviewed',
        ),
      ],
    );
  }

  Widget _buildRequestCard({
    required String studentName,
    required String studentEmail,
    required String requestType,
    required String subject,
    required String timeAgo,
    required String priority,
    required String studentYear,
    required String major,
    required List<String> interests,
    bool isPending = false,
    bool isActive = false,
    bool isCompleted = false,
    String? nextSession,
    String? outcome,
  }) {
    Color priorityColor = _getPriorityColor(priority);
    Color statusColor = _getStatusColor(isPending, isActive, isCompleted);

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: const Color(0xFF1979E6).withOpacity(0.1),
                child: Text(
                  studentName.split(' ').map((e) => e[0]).join(''),
                  style: const TextStyle(
                    color: Color(0xFF1979E6),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
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
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0E141B),
                      ),
                    ),
                    Text(
                      '$studentYear • $major',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4E7097),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: priorityColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  priority,
                  style: TextStyle(
                    color: priorityColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Request Details
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      _getRequestTypeIcon(requestType),
                      size: 16,
                      color: const Color(0xFF4E7097),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      requestType,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF4E7097),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  subject,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF0E141B),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Interests Tags
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: interests
                .map((interest) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7EDF3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        interest,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF4E7097),
                        ),
                      ),
                    ))
                .toList(),
          ),

          const SizedBox(height: 16),

          // Status and Additional Info
          Row(
            children: [
              Icon(
                Icons.access_time,
                size: 16,
                color: statusColor,
              ),
              const SizedBox(width: 4),
              Text(
                timeAgo,
                style: TextStyle(
                  fontSize: 14,
                  color: statusColor,
                ),
              ),
              if (nextSession != null) ...[
                const Spacer(),
                const Icon(
                  Icons.schedule,
                  size: 16,
                  color: Color(0xFF10B981),
                ),
                const SizedBox(width: 4),
                Text(
                  nextSession,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF10B981),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),

          if (outcome != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.check_circle,
                    size: 16,
                    color: Color(0xFF10B981),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      outcome,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),

          // Action Buttons
          if (isPending)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _rejectRequest(studentName),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFFEF4444),
                      side: const BorderSide(color: Color(0xFFEF4444)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Decline'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _acceptRequest(studentName),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Accept'),
                  ),
                ),
              ],
            ),
          if (isActive)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _messageStudent(studentName),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF1979E6),
                      side: const BorderSide(color: Color(0xFF1979E6)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Message'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _scheduleSession(studentName),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1979E6),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Schedule'),
                  ),
                ),
              ],
            ),
          if (isCompleted)
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _viewDetails(studentName),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF4E7097),
                  side: const BorderSide(color: Color(0xFF4E7097)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('View Details'),
              ),
            ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return const Color(0xFFEF4444);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'low':
        return const Color(0xFF10B981);
      default:
        return const Color(0xFF4E7097);
    }
  }

  Color _getStatusColor(bool isPending, bool isActive, bool isCompleted) {
    if (isPending) return const Color(0xFFF59E0B);
    if (isActive) return const Color(0xFF10B981);
    if (isCompleted) return const Color(0xFF6366F1);
    return const Color(0xFF4E7097);
  }

  IconData _getRequestTypeIcon(String requestType) {
    switch (requestType.toLowerCase()) {
      case 'career mentorship':
        return Icons.school;
      case 'interview preparation':
        return Icons.quiz;
      case 'project review':
        return Icons.rate_review;
      case 'job referral':
        return Icons.work;
      case 'industry insights':
        return Icons.insights;
      default:
        return Icons.help_outline;
    }
  }

  void _acceptRequest(String studentName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Accepted request from $studentName'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
    // TODO: Implement accept logic
  }

  void _rejectRequest(String studentName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Declined request from $studentName'),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
      ),
    );
    // TODO: Implement reject logic
  }

  void _messageStudent(String studentName) {
    // TODO: Navigate to chat page
  }

  void _scheduleSession(String studentName) {
    // TODO: Open scheduling dialog
  }

  void _viewDetails(String studentName) {
    // TODO: Navigate to detailed view
  }

  void _showFilterDialog() {
    // TODO: Implement filter dialog
  }

  void _showNotificationSettings() {
    // TODO: Implement notification settings
  }

  void _showBulkActionsDialog() {
    // TODO: Implement bulk actions dialog
  }
}
