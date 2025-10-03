import 'package:flutter/material.dart';
import 'package:connectu_alumni_platform/core/utils/navigation_utils.dart';

class AlumniWebinarsPage extends StatefulWidget {
  const AlumniWebinarsPage({super.key});

  @override
  State<AlumniWebinarsPage> createState() => _AlumniWebinarsPageState();
}

class _AlumniWebinarsPageState extends State<AlumniWebinarsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final String _selectedTimeFilter = 'All';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
          'My Webinars',
          style: TextStyle(
            color: Color(0xFF0E141B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.015,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showAnalytics(),
            icon: const Icon(
              Icons.analytics_outlined,
              color: Color(0xFF0E141B),
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () => _showSettings(),
            icon: const Icon(
              Icons.settings_outlined,
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
          isScrollable: true,
          tabs: const [
            Tab(text: 'Upcoming'),
            Tab(text: 'Live'),
            Tab(text: 'Past'),
            Tab(text: 'Drafts'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Analytics Overview
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF1979E6), Color(0xFF2563EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF1979E6).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.trending_up,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Webinar Analytics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _showDetailedAnalytics(),
                      child: const Text(
                        'View All',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildAnalyticsItem(
                        'Total Sessions',
                        '24',
                        Icons.video_library,
                      ),
                    ),
                    Expanded(
                      child: _buildAnalyticsItem(
                        'Total Attendees',
                        '1,847',
                        Icons.people,
                      ),
                    ),
                    Expanded(
                      child: _buildAnalyticsItem(
                        'Avg Rating',
                        '4.8',
                        Icons.star,
                      ),
                    ),
                    Expanded(
                      child: _buildAnalyticsItem(
                        'Revenue',
                        '\$12,450',
                        Icons.attach_money,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildUpcomingWebinarsTab(),
                _buildLiveWebinarsTab(),
                _buildPastWebinarsTab(),
                _buildDraftsTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createNewWebinar(),
        backgroundColor: const Color(0xFF1979E6),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text('Create Webinar'),
      ),
    );
  }

  Widget _buildAnalyticsItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 20,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildUpcomingWebinarsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 8),
        _buildWebinarCard(
          title: 'Advanced Product Management Strategies',
          description: 'Learn cutting-edge PM techniques from FAANG experience',
          date: 'Dec 25, 2024',
          time: '3:00 PM - 4:30 PM EST',
          duration: 90,
          price: 75.0,
          registrations: 156,
          maxCapacity: 200,
          status: 'upcoming',
          thumbnail: null,
          tags: ['Product Management', 'Strategy', 'Leadership'],
          isPromoted: true,
        ),
        const SizedBox(height: 16),
        _buildWebinarCard(
          title: 'Building Scalable Tech Teams',
          description:
              'From startup to scale: hiring and managing engineering teams',
          date: 'Jan 5, 2025',
          time: '2:00 PM - 3:00 PM EST',
          duration: 60,
          price: 50.0,
          registrations: 89,
          maxCapacity: 150,
          status: 'upcoming',
          tags: ['Engineering', 'Management', 'Scaling'],
        ),
        const SizedBox(height: 16),
        _buildWebinarCard(
          title: 'Data-Driven Decision Making',
          description: 'Using analytics to guide business strategy',
          date: 'Jan 12, 2025',
          time: '1:00 PM - 2:30 PM EST',
          duration: 90,
          price: 60.0,
          registrations: 67,
          maxCapacity: 100,
          status: 'upcoming',
          tags: ['Data Science', 'Analytics', 'Strategy'],
        ),
      ],
    );
  }

  Widget _buildLiveWebinarsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 8),
        _buildWebinarCard(
          title: 'Live: Startup Fundraising Essentials',
          description: 'Currently hosting: How to secure Series A funding',
          date: 'Today',
          time: 'Started 15 mins ago',
          duration: 60,
          price: 45.0,
          registrations: 142,
          maxCapacity: 180,
          status: 'live',
          liveViewers: 128,
          tags: ['Fundraising', 'Startups', 'Investment'],
        ),
      ],
    );
  }

  Widget _buildPastWebinarsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 8),
        _buildWebinarCard(
          title: 'Career Transition to Tech',
          description: 'Successfully completed webinar on tech career paths',
          date: 'Dec 15, 2024',
          time: 'Completed',
          duration: 75,
          price: 40.0,
          registrations: 234,
          maxCapacity: 250,
          status: 'completed',
          attendanceRate: 89,
          rating: 4.9,
          tags: ['Career', 'Tech', 'Transition'],
          recordingViews: 567,
        ),
        const SizedBox(height: 16),
        _buildWebinarCard(
          title: 'UX Design Principles',
          description: 'Fundamental principles of user experience design',
          date: 'Dec 10, 2024',
          time: 'Completed',
          duration: 90,
          price: 55.0,
          registrations: 189,
          maxCapacity: 200,
          status: 'completed',
          attendanceRate: 92,
          rating: 4.7,
          tags: ['UX Design', 'Design', 'User Experience'],
          recordingViews: 423,
        ),
      ],
    );
  }

  Widget _buildDraftsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 8),
        _buildWebinarCard(
          title: 'AI in Product Development',
          description: 'Draft: How AI is transforming product creation',
          date: 'Not scheduled',
          time: 'Draft',
          duration: 60,
          price: 0.0,
          registrations: 0,
          maxCapacity: 0,
          status: 'draft',
          tags: ['AI', 'Product', 'Technology'],
          isDraft: true,
        ),
        const SizedBox(height: 16),
        _buildWebinarCard(
          title: 'Remote Team Leadership',
          description: 'Draft: Managing distributed teams effectively',
          date: 'Not scheduled',
          time: 'Draft',
          duration: 45,
          price: 0.0,
          registrations: 0,
          maxCapacity: 0,
          status: 'draft',
          tags: ['Leadership', 'Remote Work', 'Management'],
          isDraft: true,
        ),
      ],
    );
  }

  Widget _buildWebinarCard({
    required String title,
    required String description,
    required String date,
    required String time,
    required int duration,
    required double price,
    required int registrations,
    required int maxCapacity,
    required String status,
    required List<String> tags,
    String? thumbnail,
    bool isPromoted = false,
    bool isDraft = false,
    int? liveViewers,
    int? attendanceRate,
    double? rating,
    int? recordingViews,
  }) {
    Color statusColor = _getStatusColor(status);
    String statusText = _getStatusText(status);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        border: isPromoted
            ? Border.all(color: const Color(0xFFFFD700), width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Image and Status
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Container(
                  height: 140,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF1979E6).withOpacity(0.8),
                        const Color(0xFF2563EB).withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: const Icon(
                    Icons.video_call,
                    size: 48,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (isPromoted)
                const Positioned(
                  top: 12,
                  left: 12,
                  child: Icon(
                    Icons.star,
                    color: Color(0xFFFFD700),
                    size: 24,
                  ),
                ),
              if (status == 'live')
                const Positioned(
                  top: 40,
                  right: 12,
                  child: Row(
                    children: [
                      Icon(
                        Icons.circle,
                        color: Colors.red,
                        size: 8,
                      ),
                      SizedBox(width: 4),
                      Text(
                        'LIVE',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title and Description
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E141B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4E7097),
                    height: 1.4,
                  ),
                ),

                const SizedBox(height: 12),

                // Tags
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tags
                      .map((tag) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE7EDF3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color(0xFF4E7097),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ))
                      .toList(),
                ),

                const SizedBox(height: 16),

                // Webinar Details
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          _buildDetailItem(
                            Icons.schedule,
                            '$date\n$time',
                          ),
                          if (!isDraft) ...[
                            const SizedBox(width: 16),
                            _buildDetailItem(
                              Icons.timer,
                              '$duration min',
                            ),
                          ],
                          if (!isDraft && price > 0) ...[
                            const Spacer(),
                            Text(
                              '\$${price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF10B981),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (!isDraft && maxCapacity > 0) ...[
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.people,
                              size: 16,
                              color: Color(0xFF4E7097),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              status == 'live'
                                  ? '$liveViewers viewers'
                                  : '$registrations/$maxCapacity registered',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Color(0xFF4E7097),
                              ),
                            ),
                            const Spacer(),
                            if (status == 'live' || maxCapacity > 0)
                              LinearProgressIndicator(
                                value: status == 'live'
                                    ? (liveViewers! / maxCapacity)
                                    : (registrations / maxCapacity),
                                backgroundColor: const Color(0xFFE7EDF3),
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  statusColor,
                                ),
                                minHeight: 4,
                              ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),

                // Additional Stats for Past Webinars
                if (status == 'completed') ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '$attendanceRate%',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF10B981),
                                ),
                              ),
                              const Text(
                                'Attendance',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF4E7097),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF59E0B).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    rating!.toStringAsFixed(1),
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF59E0B),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  const Icon(
                                    Icons.star,
                                    size: 16,
                                    color: Color(0xFFF59E0B),
                                  ),
                                ],
                              ),
                              const Text(
                                'Rating',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF4E7097),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6366F1).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                '$recordingViews',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6366F1),
                                ),
                              ),
                              const Text(
                                'Recording Views',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF4E7097),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],

                const SizedBox(height: 16),

                // Action Buttons
                _buildActionButtons(status, isDraft),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF4E7097),
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            color: Color(0xFF4E7097),
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(String status, bool isDraft) {
    if (isDraft) {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _deleteWebinar(),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFFEF4444),
                side: const BorderSide(color: Color(0xFFEF4444)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Delete'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _editWebinar(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1979E6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Continue Editing'),
            ),
          ),
        ],
      );
    }

    if (status == 'upcoming') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _editWebinar(),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1979E6),
                side: const BorderSide(color: Color(0xFF1979E6)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Edit'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () => _viewRegistrations(),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF10B981),
                side: const BorderSide(color: Color(0xFF10B981)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Registrations'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _startWebinar(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Start'),
            ),
          ),
        ],
      );
    }

    if (status == 'live') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _viewLiveStats(),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1979E6),
                side: const BorderSide(color: Color(0xFF1979E6)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Live Stats'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _joinWebinar(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Join Live'),
            ),
          ),
        ],
      );
    }

    if (status == 'completed') {
      return Row(
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => _viewAnalytics(),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF1979E6),
                side: const BorderSide(color: Color(0xFF1979E6)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Analytics'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: OutlinedButton(
              onPressed: () => _viewRecording(),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF6366F1),
                side: const BorderSide(color: Color(0xFF6366F1)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Recording'),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: ElevatedButton(
              onPressed: () => _downloadResources(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Resources'),
            ),
          ),
        ],
      );
    }

    return const SizedBox();
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'upcoming':
        return const Color(0xFF1979E6);
      case 'live':
        return Colors.red;
      case 'completed':
        return const Color(0xFF10B981);
      case 'draft':
        return const Color(0xFF4E7097);
      default:
        return const Color(0xFF4E7097);
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'upcoming':
        return 'UPCOMING';
      case 'live':
        return 'LIVE';
      case 'completed':
        return 'COMPLETED';
      case 'draft':
        return 'DRAFT';
      default:
        return 'UNKNOWN';
    }
  }

  void _createNewWebinar() {
    // TODO: Navigate to create webinar page
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Create new webinar feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showAnalytics() {
    // TODO: Show analytics page
  }

  void _showSettings() {
    // TODO: Show settings page
  }

  void _showDetailedAnalytics() {
    // TODO: Show detailed analytics
  }

  void _editWebinar() {
    // TODO: Navigate to edit webinar
  }

  void _deleteWebinar() {
    // TODO: Show delete confirmation
  }

  void _viewRegistrations() {
    // TODO: Show registrations list
  }

  void _startWebinar() {
    // TODO: Start webinar
  }

  void _viewLiveStats() {
    // TODO: Show live statistics
  }

  void _joinWebinar() {
    // TODO: Join live webinar
  }

  void _viewAnalytics() {
    // TODO: Show webinar analytics
  }

  void _viewRecording() {
    // TODO: Show recording
  }

  void _downloadResources() {
    // TODO: Download resources
  }
}
