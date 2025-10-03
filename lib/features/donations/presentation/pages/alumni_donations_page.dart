import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/core/utils/navigation_utils.dart';

class AlumniDonationsPage extends StatefulWidget {
  const AlumniDonationsPage({super.key});

  @override
  State<AlumniDonationsPage> createState() => _AlumniDonationsPageState();
}

class _AlumniDonationsPageState extends State<AlumniDonationsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeFilter = 'This Year';

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
          'My Donations',
          style: TextStyle(
            color: Color(0xFF0E141B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.015,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showImpactReport(),
            icon: const Icon(
              Icons.assessment_outlined,
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
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'History'),
            Tab(text: 'Impact'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildHistoryTab(),
          _buildImpactTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _makeDonation(),
        backgroundColor: const Color(0xFF10B981),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.favorite),
        label: const Text('Donate Now'),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Total Impact Card
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF10B981), Color(0xFF059669)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF10B981).withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    const Text(
                      'Your Total Contribution',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'Lifetime',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                  '\$15,750',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '🎉 You\'re in the top 5% of donors!',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildImpactStat(
                          'Students Helped', '47', Icons.school),
                    ),
                    Expanded(
                      child: _buildImpactStat(
                          'Scholarships', '8', Icons.card_giftcard),
                    ),
                    Expanded(
                      child:
                          _buildImpactStat('Years Active', '3', Icons.timeline),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Quick Actions
          Row(
            children: [
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E141B),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _viewAllPrograms(),
                child: const Text(
                  'View All Programs',
                  style: TextStyle(
                    color: Color(0xFF1979E6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'Emergency Fund',
                  'Support students in crisis',
                  Icons.emergency,
                  const Color(0xFFEF4444),
                  () => _donateToEmergencyFund(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  'Scholarships',
                  'Fund academic excellence',
                  Icons.school,
                  const Color(0xFF1979E6),
                  () => _donateToScholarships(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _buildQuickActionCard(
                  'Research Grants',
                  'Advance scientific discovery',
                  Icons.science,
                  const Color(0xFF6366F1),
                  () => _donateToResearch(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickActionCard(
                  'Infrastructure',
                  'Build the future campus',
                  Icons.business,
                  const Color(0xFF10B981),
                  () => _donateToInfrastructure(),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Recent Activity
          Row(
            children: [
              const Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E141B),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _tabController.animateTo(1),
                child: const Text(
                  'View All History',
                  style: TextStyle(
                    color: Color(0xFF1979E6),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          _buildDonationHistoryCard(
            title: 'Computer Science Scholarship Fund',
            amount: '\$500',
            date: 'Dec 15, 2024',
            impact: 'Helped fund Sarah Chen\'s final semester',
            status: 'completed',
            isRecurring: false,
          ),

          const SizedBox(height: 12),

          _buildDonationHistoryCard(
            title: 'Emergency Student Support',
            amount: '\$200',
            date: 'Dec 1, 2024',
            impact: 'Provided emergency housing assistance',
            status: 'completed',
            isRecurring: true,
          ),

          const SizedBox(height: 12),

          _buildDonationHistoryCard(
            title: 'Library Modernization Project',
            amount: '\$1,000',
            date: 'Nov 28, 2024',
            impact: 'Contributing to new digital resources',
            status: 'processing',
            isRecurring: false,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Filter Row
          Row(
            children: [
              const Text(
                'Donation History',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E141B),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFFE7EDF3)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedTimeFilter,
                    items: ['This Year', 'Last Year', 'All Time']
                        .map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        _selectedTimeFilter = newValue!;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Summary Stats
          Container(
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
                  child: _buildSummaryItem(
                      'Total Donated', '\$3,200', Icons.attach_money),
                ),
                Container(width: 1, height: 40, color: const Color(0xFFE7EDF3)),
                Expanded(
                  child: _buildSummaryItem('Donations', '12', Icons.favorite),
                ),
                Container(width: 1, height: 40, color: const Color(0xFFE7EDF3)),
                Expanded(
                  child:
                      _buildSummaryItem('Average', '\$267', Icons.trending_up),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // History List
          _buildDonationHistoryCard(
            title: 'Computer Science Scholarship Fund',
            amount: '\$500',
            date: 'Dec 15, 2024',
            impact: 'Helped fund Sarah Chen\'s final semester',
            status: 'completed',
            isRecurring: false,
            showFullDetails: true,
          ),

          const SizedBox(height: 16),

          _buildDonationHistoryCard(
            title: 'Emergency Student Support',
            amount: '\$200',
            date: 'Dec 1, 2024',
            impact: 'Provided emergency housing assistance',
            status: 'completed',
            isRecurring: true,
            showFullDetails: true,
          ),

          const SizedBox(height: 16),

          _buildDonationHistoryCard(
            title: 'Library Modernization Project',
            amount: '\$1,000',
            date: 'Nov 28, 2024',
            impact: 'Contributing to new digital resources',
            status: 'processing',
            isRecurring: false,
            showFullDetails: true,
          ),

          const SizedBox(height: 16),

          _buildDonationHistoryCard(
            title: 'Athletic Program Support',
            amount: '\$750',
            date: 'Nov 15, 2024',
            impact: 'Funded new equipment for soccer team',
            status: 'completed',
            isRecurring: false,
            showFullDetails: true,
          ),

          const SizedBox(height: 16),

          _buildDonationHistoryCard(
            title: 'General Alumni Fund',
            amount: '\$300',
            date: 'Oct 20, 2024',
            impact: 'Supporting various university initiatives',
            status: 'completed',
            isRecurring: true,
            showFullDetails: true,
          ),
        ],
      ),
    );
  }

  Widget _buildImpactTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Impact Overview
          Container(
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
                const Text(
                  'Your Impact Story',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E141B),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildImpactMetric(
                        '47',
                        'Students Directly Helped',
                        Icons.people,
                        const Color(0xFF1979E6),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildImpactMetric(
                        '8',
                        'Scholarships Funded',
                        Icons.school,
                        const Color(0xFF10B981),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildImpactMetric(
                        '3',
                        'Research Projects',
                        Icons.science,
                        const Color(0xFF6366F1),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildImpactMetric(
                        '15k',
                        'Lives Touched',
                        Icons.favorite,
                        const Color(0xFFEF4444),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Success Stories
          const Text(
            'Success Stories',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0E141B),
            ),
          ),

          const SizedBox(height: 16),

          _buildSuccessStoryCard(
            name: 'Sarah Chen',
            story:
                'Thanks to your scholarship support, I was able to complete my Computer Science degree and landed a job at Google. Your generosity changed my life!',
            outcome:
                'Graduated Summa Cum Laude, now Software Engineer at Google',
            image: null,
            donationAmount: '\$2,500',
          ),

          const SizedBox(height: 16),

          _buildSuccessStoryCard(
            name: 'Marcus Johnson',
            story:
                'The emergency fund helped me when my family faced financial crisis. I stayed in school and graduated on time because of donors like you.',
            outcome:
                'Graduated in Engineering, working on renewable energy projects',
            donationAmount: '\$800',
          ),

          const SizedBox(height: 16),

          _buildSuccessStoryCard(
            name: 'Dr. Emily Rodriguez',
            story:
                'Your research grant funding enabled breakthrough discoveries in cancer treatment. We\'ve published 5 papers and started clinical trials.',
            outcome: '3 patents filed, clinical trials approved',
            donationAmount: '\$5,000',
            isResearchProject: true,
          ),

          const SizedBox(height: 24),

          // Impact Timeline
          Container(
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
                const Text(
                  'Your Giving Journey',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E141B),
                  ),
                ),
                const SizedBox(height: 16),
                _buildTimelineItem(
                  '2024',
                  '\$5,200 donated',
                  'Supported 15 students and 2 research projects',
                  const Color(0xFF10B981),
                  true,
                ),
                _buildTimelineItem(
                  '2023',
                  '\$4,800 donated',
                  'Funded 3 scholarships and emergency aid',
                  const Color(0xFF1979E6),
                  false,
                ),
                _buildTimelineItem(
                  '2022',
                  '\$5,750 donated',
                  'First year as major donor, supported infrastructure',
                  const Color(0xFF6366F1),
                  false,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImpactStat(String label, String value, IconData icon) {
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
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.white.withOpacity(0.8),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(String title, String subtitle, IconData icon,
      Color color, VoidCallback onTap) {
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
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
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
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDonationHistoryCard({
    required String title,
    required String amount,
    required String date,
    required String impact,
    required String status,
    required bool isRecurring,
    bool showFullDetails = false,
  }) {
    Color statusColor = _getStatusColor(status);

    return Container(
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
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E141B),
                  ),
                ),
              ),
              if (isRecurring)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Recurring',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            impact,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4E7097),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.calendar_today,
                size: 14,
                color: statusColor,
              ),
              const SizedBox(width: 4),
              Text(
                date,
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: statusColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          if (showFullDetails) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _viewReceipt(title),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4E7097),
                      side: const BorderSide(color: Color(0xFF4E7097)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('View Receipt'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _repeatDonation(title, amount),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Donate Again'),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFF1979E6),
          size: 20,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
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
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildImpactMetric(
      String value, String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: color,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF4E7097),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStoryCard({
    required String name,
    required String story,
    required String outcome,
    required String donationAmount,
    String? image,
    bool isResearchProject = false,
  }) {
    return Container(
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
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFF1979E6).withOpacity(0.1),
                child: isResearchProject
                    ? const Icon(
                        Icons.science,
                        color: Color(0xFF1979E6),
                        size: 20,
                      )
                    : Text(
                        name.split(' ').map((e) => e[0]).join(''),
                        style: const TextStyle(
                          color: Color(0xFF1979E6),
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
                      name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0E141B),
                      ),
                    ),
                    Text(
                      'Your donation: $donationAmount',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            story,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4E7097),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Color(0xFF10B981),
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Outcome: $outcome',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF10B981),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String year, String amount, String description,
      Color color, bool isActive) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: isActive ? color : color.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      year,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? const Color(0xFF0E141B)
                            : const Color(0xFF4E7097),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      amount,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isActive ? color : color.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4E7097),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return const Color(0xFF10B981);
      case 'processing':
        return const Color(0xFFF59E0B);
      case 'failed':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF4E7097);
    }
  }

  void _makeDonation() {
    // Navigate to donation campaigns page
    context.go('/donation-campaigns');
  }

  void _showImpactReport() {
    // TODO: Show detailed impact report
  }

  void _showSettings() {
    // TODO: Show donation settings
  }

  void _viewAllPrograms() {
    // TODO: Show all donation programs
  }

  void _donateToEmergencyFund() {
    // TODO: Navigate to emergency fund donation
  }

  void _donateToScholarships() {
    // TODO: Navigate to scholarship donation
  }

  void _donateToResearch() {
    // TODO: Navigate to research donation
  }

  void _donateToInfrastructure() {
    // TODO: Navigate to infrastructure donation
  }

  void _viewReceipt(String donation) {
    // TODO: Show donation receipt
  }

  void _repeatDonation(String title, String amount) {
    // TODO: Repeat donation
  }
}
