import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';

class AnalyticsDashboardPage extends StatefulWidget {
  const AnalyticsDashboardPage({super.key});

  @override
  State<AnalyticsDashboardPage> createState() => _AnalyticsDashboardPageState();
}

class _AnalyticsDashboardPageState extends State<AnalyticsDashboardPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

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
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
        ),
        title: const Text(
          'Analytics Dashboard',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showDateRangePicker(),
            icon: const Icon(Icons.date_range, color: Color(0xFF1F2937)),
          ),
          IconButton(
            onPressed: () => _exportData(),
            icon: const Icon(Icons.download, color: Color(0xFF1F2937)),
          ),
        ],
      ),
      body: Column(
        children: [
          // Summary Cards
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Users',
                    '2,847',
                    Icons.people,
                    Colors.blue,
                    '+12%',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Active Events',
                    '12',
                    Icons.event,
                    Colors.green,
                    '+8%',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Mentorships',
                    '156',
                    Icons.people_alt,
                    Colors.orange,
                    '+15%',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildSummaryCard(
                    'Engagement',
                    '89%',
                    Icons.trending_up,
                    Colors.purple,
                    '+5%',
                  ),
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
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.primaryColor,
              isScrollable: true,
              tabs: const [
                Tab(text: 'Overview'),
                Tab(text: 'Engagement'),
                Tab(text: 'Events'),
                Tab(text: 'Mentorship'),
              ],
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(),
                _buildEngagementTab(),
                _buildEventsTab(),
                _buildMentorshipTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: change.startsWith('+')
                      ? Colors.green.withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: 10,
                    color: change.startsWith('+') ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Growth Chart
          _buildChartCard(
            'User Growth (Last 6 Months)',
            _buildUserGrowthChart(),
          ),
          const SizedBox(height: 16),

          // Platform Activity
          _buildChartCard(
            'Platform Activity Distribution',
            _buildActivityChart(),
          ),
          const SizedBox(height: 16),

          // Recent Activity
          _buildRecentActivityCard(),
        ],
      ),
    );
  }

  Widget _buildEngagementTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Engagement Metrics
          Row(
            children: [
              Expanded(
                child: _buildEngagementMetric(
                  'Daily Active Users',
                  '1,234',
                  '+12%',
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEngagementMetric(
                  'Session Duration',
                  '24m',
                  '+8%',
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildEngagementMetric(
                  'Page Views',
                  '45,678',
                  '+15%',
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEngagementMetric(
                  'Bounce Rate',
                  '32%',
                  '-5%',
                  Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Engagement Chart
          _buildChartCard(
            'Engagement Trends (Last 7 Days)',
            _buildEngagementChart(),
          ),
          const SizedBox(height: 16),

          // Top Pages
          _buildTopPagesCard(),
        ],
      ),
    );
  }

  Widget _buildEventsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Event Statistics
          _buildEventStatsCard(),
          const SizedBox(height: 16),

          // Event Performance Chart
          _buildChartCard(
            'Event Performance',
            _buildEventPerformanceChart(),
          ),
          const SizedBox(height: 16),

          // Top Events
          _buildTopEventsCard(),
        ],
      ),
    );
  }

  Widget _buildMentorshipTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Mentorship Statistics
          _buildMentorshipStatsCard(),
          const SizedBox(height: 16),

          // Mentorship Success Chart
          _buildChartCard(
            'Mentorship Success Rate',
            _buildMentorshipSuccessChart(),
          ),
          const SizedBox(height: 16),

          // Top Mentors
          _buildTopMentorsCard(),
        ],
      ),
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(height: 200, child: chart),
        ],
      ),
    );
  }

  Widget _buildUserGrowthChart() {
    return CustomPaint(
      painter: LineChartPainter([
        {'x': 0, 'y': 3},
        {'x': 1, 'y': 1},
        {'x': 2, 'y': 4},
        {'x': 3, 'y': 2},
        {'x': 4, 'y': 5},
        {'x': 5, 'y': 3},
      ], AppTheme.primaryColor),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: const Column(
          children: [
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Jan',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text('Feb',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text('Mar',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text('Apr',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text('May',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text('Jun',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActivityChart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildPieSection('Events', 40, Colors.blue),
        _buildPieSection('Mentorship', 30, Colors.green),
        _buildPieSection('Jobs', 20, Colors.orange),
        _buildPieSection('Other', 10, Colors.purple),
      ],
    );
  }

  Widget _buildPieSection(String label, int percentage, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$percentage%',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
      ],
    );
  }

  Widget _buildEngagementChart() {
    return CustomPaint(
      painter: BarChartPainter([
        {'x': 0, 'y': 8},
        {'x': 1, 'y': 12},
        {'x': 2, 'y': 6},
        {'x': 3, 'y': 15},
        {'x': 4, 'y': 18},
        {'x': 5, 'y': 10},
        {'x': 6, 'y': 14},
      ], AppTheme.primaryColor),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: const Column(
          children: [
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Mon',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text('Tue',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text('Wed',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text('Thu',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text('Fri',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text('Sat',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text('Sun',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEventPerformanceChart() {
    return CustomPaint(
      painter: LineChartPainter([
        {'x': 0, 'y': 3},
        {'x': 1, 'y': 1},
        {'x': 2, 'y': 4},
        {'x': 3, 'y': 2},
        {'x': 4, 'y': 5},
      ], Colors.green),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: const Column(
          children: [
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Event 1',
                    style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                Text('Event 2',
                    style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                Text('Event 3',
                    style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                Text('Event 4',
                    style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
                Text('Event 5',
                    style: TextStyle(fontSize: 10, color: Color(0xFF6B7280))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMentorshipSuccessChart() {
    return CustomPaint(
      painter: LineChartPainter([
        {'x': 0, 'y': 2},
        {'x': 1, 'y': 3},
        {'x': 2, 'y': 4},
        {'x': 3, 'y': 3.5},
        {'x': 4, 'y': 4.5},
        {'x': 5, 'y': 4.8},
      ], Colors.orange),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: const Column(
          children: [
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Jan',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text('Feb',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text('Mar',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text('Apr',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text('May',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
                Text('Jun',
                    style: TextStyle(fontSize: 12, color: Color(0xFF6B7280))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementMetric(
      String title, String value, String change, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.trending_up,
                  color: color,
                  size: 16,
                ),
              ),
              const Spacer(),
              Text(
                change,
                style: TextStyle(
                  fontSize: 12,
                  color: change.startsWith('+') ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentActivityCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(5, (index) => _buildActivityItem(index)),
        ],
      ),
    );
  }

  Widget _buildActivityItem(int index) {
    final activities = [
      {
        'icon': Icons.person_add,
        'text': 'New user registered',
        'time': '2 min ago',
        'color': Colors.blue
      },
      {
        'icon': Icons.event,
        'text': 'Event created',
        'time': '15 min ago',
        'color': Colors.green
      },
      {
        'icon': Icons.people,
        'text': 'Mentorship started',
        'time': '1 hour ago',
        'color': Colors.orange
      },
      {
        'icon': Icons.message,
        'text': 'New message sent',
        'time': '2 hours ago',
        'color': Colors.purple
      },
      {
        'icon': Icons.work,
        'text': 'Job application submitted',
        'time': '3 hours ago',
        'color': Colors.red
      },
    ];

    final activity = activities[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (activity['color'] as Color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              activity['icon'] as IconData,
              color: activity['color'] as Color,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activity['text'] as String,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Text(
                  activity['time'] as String,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Event Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildEventStat('Total Events', '24', Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEventStat('Active Events', '12', Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child:
                    _buildEventStat('Total Attendees', '1,234', Colors.orange),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEventStat(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTopEventsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Performing Events',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(3, (index) => _buildTopEventItem(index)),
        ],
      ),
    );
  }

  Widget _buildTopEventItem(int index) {
    final events = [
      {'name': 'Annual Alumni Reunion', 'attendees': '450', 'rating': '4.8'},
      {'name': 'Tech Innovation Webinar', 'attendees': '320', 'rating': '4.6'},
      {'name': 'Networking Mixer', 'attendees': '180', 'rating': '4.7'},
    ];

    final event = events[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event['name']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Text(
                  '${event['attendees']} attendees • ${event['rating']}★',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorshipStatsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mentorship Statistics',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildEventStat('Active Sessions', '45', Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEventStat('Completed', '156', Colors.green),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildEventStat('Success Rate', '89%', Colors.orange),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopMentorsCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Mentors',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(3, (index) => _buildTopMentorItem(index)),
        ],
      ),
    );
  }

  Widget _buildTopMentorItem(int index) {
    final mentors = [
      {'name': 'Sarah Johnson', 'sessions': '45', 'rating': '4.9'},
      {'name': 'Michael Chen', 'sessions': '38', 'rating': '4.8'},
      {'name': 'Emily Rodriguez', 'sessions': '32', 'rating': '4.7'},
    ];

    final mentor = mentors[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
            child: Text(
              mentor['name']!.split(' ').map((e) => e[0]).join(''),
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mentor['name']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1F2937),
                  ),
                ),
                Text(
                  '${mentor['sessions']} sessions • ${mentor['rating']}★',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopPagesCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Pages',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 16),
          ...List.generate(5, (index) => _buildTopPageItem(index)),
        ],
      ),
    );
  }

  Widget _buildTopPageItem(int index) {
    final pages = [
      {'name': 'Dashboard', 'views': '12,456', 'icon': Icons.dashboard},
      {'name': 'Events', 'views': '8,234', 'icon': Icons.event},
      {'name': 'Mentorship', 'views': '6,789', 'icon': Icons.people_alt},
      {'name': 'Jobs', 'views': '5,123', 'icon': Icons.work},
      {'name': 'Profile', 'views': '4,567', 'icon': Icons.person},
    ];

    final page = pages[index];
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              page['icon'] as IconData,
              color: AppTheme.primaryColor,
              size: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              page['name'] as String,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
          ),
          Text(
            page['views'] as String,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  void _showDateRangePicker() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Date Range'),
        content: const Text('Date range picker functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Data'),
        content: const Text('Data export functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Custom Painters for Charts
class LineChartPainter extends CustomPainter {
  final List<Map<String, double>> data;
  final Color color;

  LineChartPainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..color = color.withOpacity(0.1)
      ..style = PaintingStyle.fill;

    if (data.isEmpty) return;

    final path = Path();
    final fillPath = Path();

    final maxX = data.map((e) => e['x']!).reduce((a, b) => a > b ? a : b);
    final maxY = data.map((e) => e['y']!).reduce((a, b) => a > b ? a : b);

    for (int i = 0; i < data.length; i++) {
      final x = (data[i]['x']! / maxX) * size.width;
      final y = size.height - (data[i]['y']! / maxY) * size.height;

      if (i == 0) {
        path.moveTo(x, y);
        fillPath.moveTo(x, size.height);
        fillPath.lineTo(x, y);
      } else {
        path.lineTo(x, y);
        fillPath.lineTo(x, y);
      }
    }

    fillPath.lineTo(size.width, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, fillPaint);
    canvas.drawPath(path, paint);

    // Draw dots
    final dotPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    for (final point in data) {
      final x = (point['x']! / maxX) * size.width;
      final y = size.height - (point['y']! / maxY) * size.height;
      canvas.drawCircle(Offset(x, y), 4, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class BarChartPainter extends CustomPainter {
  final List<Map<String, double>> data;
  final Color color;

  BarChartPainter(this.data, this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    if (data.isEmpty) return;

    final maxY = data.map((e) => e['y']!).reduce((a, b) => a > b ? a : b);
    final barWidth = size.width / data.length * 0.6;

    for (int i = 0; i < data.length; i++) {
      final x = (i / data.length) * size.width +
          (size.width / data.length - barWidth) / 2;
      final barHeight = (data[i]['y']! / maxY) * size.height;
      final y = size.height - barHeight;

      final rect = Rect.fromLTWH(x, y, barWidth, barHeight);
      canvas.drawRRect(
          RRect.fromRectAndRadius(rect, const Radius.circular(4)), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
