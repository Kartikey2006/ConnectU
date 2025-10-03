import 'package:flutter/material.dart';
import 'package:connectu_alumni_platform/core/utils/navigation_utils.dart';

class AlumniNetworkPage extends StatefulWidget {
  const AlumniNetworkPage({super.key});

  @override
  State<AlumniNetworkPage> createState() => _AlumniNetworkPageState();
}

class _AlumniNetworkPageState extends State<AlumniNetworkPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  final String _selectedFilter = 'All';
  final String _selectedLocation = 'All Locations';
  final String _selectedIndustry = 'All Industries';
  final String _selectedGradYear = 'All Years';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
          'Alumni Network',
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
              Icons.tune,
              color: Color(0xFF0E141B),
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () => _showNetworkingEvents(),
            icon: const Icon(
              Icons.event,
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
            Tab(text: 'Discover'),
            Tab(text: 'Connections'),
            Tab(text: 'Requests'),
            Tab(text: 'Saved'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search by name, company, or skills...',
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Color(0xFF4E7097)),
                hintStyle: TextStyle(color: Color(0xFF4E7097)),
              ),
              onChanged: (value) => _performSearch(value),
            ),
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildDiscoverTab(),
                _buildConnectionsTab(),
                _buildRequestsTab(),
                _buildSavedTab(),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _startNetworking(),
        backgroundColor: const Color(0xFF1979E6),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.group_add),
        label: const Text('Start Networking'),
      ),
    );
  }

  Widget _buildDiscoverTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Featured Alumni
          Row(
            children: [
              const Text(
                'Featured Alumni',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0E141B),
                ),
              ),
              const Spacer(),
              TextButton(
                onPressed: () => _viewAllFeatured(),
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

          // Featured Alumni Cards
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                final featuredAlumni = [
                  {
                    'name': 'Dr. Sarah Johnson',
                    'title': 'Chief Technology Officer',
                    'company': 'Google',
                    'gradYear': '2015',
                    'major': 'Computer Science',
                    'location': 'San Francisco, CA',
                    'isFeatured': true,
                    'achievements': [
                      'Forbes 30 Under 30',
                      'Tech Innovator Award'
                    ],
                    'expertise': ['AI/ML', 'Cloud Computing', 'Leadership'],
                  },
                  {
                    'name': 'Michael Chen',
                    'title': 'Venture Partner',
                    'company': 'Andreessen Horowitz',
                    'gradYear': '2012',
                    'major': 'Business Administration',
                    'location': 'Palo Alto, CA',
                    'isFeatured': true,
                    'achievements': ['40 Under 40', 'Angel Investor'],
                    'expertise': ['Venture Capital', 'Startups', 'Strategy'],
                  },
                  {
                    'name': 'Dr. Emily Rodriguez',
                    'title': 'Research Director',
                    'company': 'Massachusetts General Hospital',
                    'gradYear': '2010',
                    'major': 'Biomedical Engineering',
                    'location': 'Boston, MA',
                    'isFeatured': true,
                    'achievements': [
                      'Medical Innovation Award',
                      'Published Researcher'
                    ],
                    'expertise': ['Medical Research', 'Biotech', 'Innovation'],
                  },
                ];

                final alumni = featuredAlumni[index];
                return Container(
                  width: 280,
                  margin: const EdgeInsets.only(right: 16),
                  child: _buildAlumniCard(alumni, isFeatured: true),
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // Industry Leaders
          const Text(
            'Industry Leaders',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF0E141B),
            ),
          ),

          const SizedBox(height: 16),

          _buildAlumniCard({
            'name': 'David Park',
            'title': 'Senior Software Engineer',
            'company': 'Meta',
            'gradYear': '2018',
            'major': 'Computer Science',
            'location': 'Seattle, WA',
            'expertise': ['React', 'Node.js', 'System Design'],
            'isOnline': true,
          }),

          const SizedBox(height: 16),

          _buildAlumniCard({
            'name': 'Lisa Wang',
            'title': 'Product Manager',
            'company': 'Apple',
            'gradYear': '2016',
            'major': 'Industrial Design',
            'location': 'Cupertino, CA',
            'expertise': ['Product Strategy', 'Design Thinking', 'Mobile'],
            'isOnline': false,
          }),

          const SizedBox(height: 16),

          _buildAlumniCard({
            'name': 'James Miller',
            'title': 'Investment Banking Analyst',
            'company': 'Goldman Sachs',
            'gradYear': '2020',
            'major': 'Finance',
            'location': 'New York, NY',
            'expertise': ['Investment Banking', 'Financial Modeling', 'M&A'],
            'isOnline': true,
          }),
        ],
      ),
    );
  }

  Widget _buildConnectionsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 8),

        // Quick Stats
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
                child: _buildConnectionStat('Connections', '247', Icons.people),
              ),
              Container(width: 1, height: 40, color: const Color(0xFFE7EDF3)),
              Expanded(
                child:
                    _buildConnectionStat('Following', '89', Icons.person_add),
              ),
              Container(width: 1, height: 40, color: const Color(0xFFE7EDF3)),
              Expanded(
                child: _buildConnectionStat('Followers', '156', Icons.group),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Recent Connections
        Row(
          children: [
            const Text(
              'Recent Connections',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0E141B),
              ),
            ),
            const Spacer(),
            TextButton(
              onPressed: () => _viewAllConnections(),
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

        _buildConnectionCard({
          'name': 'Alex Thompson',
          'title': 'Data Scientist',
          'company': 'Netflix',
          'mutualConnections': 12,
          'connectedDate': '2 days ago',
          'status': 'connected',
        }),

        const SizedBox(height: 12),

        _buildConnectionCard({
          'name': 'Rachel Green',
          'title': 'Marketing Director',
          'company': 'Spotify',
          'mutualConnections': 8,
          'connectedDate': '1 week ago',
          'status': 'connected',
        }),

        const SizedBox(height: 12),

        _buildConnectionCard({
          'name': 'Kevin Liu',
          'title': 'UX Designer',
          'company': 'Airbnb',
          'mutualConnections': 15,
          'connectedDate': '2 weeks ago',
          'status': 'connected',
        }),
      ],
    );
  }

  Widget _buildRequestsTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 8),

        // Sent Requests
        const Text(
          'Sent Requests',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E141B),
          ),
        ),

        const SizedBox(height: 16),

        _buildConnectionCard({
          'name': 'Jennifer Adams',
          'title': 'Software Architect',
          'company': 'Microsoft',
          'mutualConnections': 5,
          'connectedDate': '3 days ago',
          'status': 'pending_sent',
        }),

        const SizedBox(height: 12),

        _buildConnectionCard({
          'name': 'Robert Kim',
          'title': 'Product Manager',
          'company': 'Tesla',
          'mutualConnections': 3,
          'connectedDate': '1 week ago',
          'status': 'pending_sent',
        }),

        const SizedBox(height: 24),

        // Received Requests
        const Text(
          'Received Requests',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E141B),
          ),
        ),

        const SizedBox(height: 16),

        _buildConnectionCard({
          'name': 'Maria Gonzalez',
          'title': 'Financial Analyst',
          'company': 'JPMorgan Chase',
          'mutualConnections': 7,
          'connectedDate': '1 day ago',
          'status': 'pending_received',
          'message':
              'Hi! I\'d love to connect and learn about your experience in fintech.',
        }),

        const SizedBox(height: 12),

        _buildConnectionCard({
          'name': 'Tom Wilson',
          'title': 'Marketing Manager',
          'company': 'Salesforce',
          'mutualConnections': 9,
          'connectedDate': '2 days ago',
          'status': 'pending_received',
          'message':
              'Hello! I saw we both graduated from the same program. Would love to connect!',
        }),
      ],
    );
  }

  Widget _buildSavedTab() {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 8),
        const Text(
          'Saved Profiles',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0E141B),
          ),
        ),
        const SizedBox(height: 16),
        _buildAlumniCard({
          'name': 'Amanda Foster',
          'title': 'Startup Founder',
          'company': 'TechCorp Inc.',
          'gradYear': '2014',
          'major': 'Entrepreneurship',
          'location': 'Austin, TX',
          'expertise': ['Entrepreneurship', 'Fundraising', 'Leadership'],
          'isSaved': true,
        }),
        const SizedBox(height: 16),
        _buildAlumniCard({
          'name': 'Carlos Rodriguez',
          'title': 'AI Research Scientist',
          'company': 'OpenAI',
          'gradYear': '2017',
          'major': 'Computer Science',
          'location': 'San Francisco, CA',
          'expertise': ['Machine Learning', 'NLP', 'Research'],
          'isSaved': true,
        }),
      ],
    );
  }

  Widget _buildAlumniCard(Map<String, dynamic> alumni,
      {bool isFeatured = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        border: isFeatured
            ? Border.all(
                color: const Color(0xFF1979E6).withOpacity(0.3), width: 2)
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: const Color(0xFF1979E6).withOpacity(0.1),
                    child: Text(
                      alumni['name'].split(' ').map((e) => e[0]).join(''),
                      style: const TextStyle(
                        color: Color(0xFF1979E6),
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  if (alumni['isOnline'] == true)
                    Positioned(
                      bottom: 2,
                      right: 2,
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          color: Color(0xFF10B981),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 3,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            alumni['name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0E141B),
                            ),
                          ),
                        ),
                        if (isFeatured)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1979E6).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              'FEATURED',
                              style: TextStyle(
                                fontSize: 10,
                                color: Color(0xFF1979E6),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      alumni['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0E141B),
                      ),
                    ),
                    Text(
                      alumni['company'],
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1979E6),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _toggleSaved(alumni['name']),
                icon: Icon(
                  alumni['isSaved'] == true
                      ? Icons.bookmark
                      : Icons.bookmark_border,
                  color: alumni['isSaved'] == true
                      ? const Color(0xFF1979E6)
                      : const Color(0xFF4E7097),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Details
          if (alumni['gradYear'] != null) ...[
            Row(
              children: [
                _buildInfoChip(Icons.school, 'Class of ${alumni['gradYear']}'),
                const SizedBox(width: 8),
                _buildInfoChip(Icons.subject, alumni['major']),
              ],
            ),
            const SizedBox(height: 8),
          ],

          if (alumni['location'] != null)
            _buildInfoRow(Icons.location_on, alumni['location']),

          if (alumni['achievements'] != null) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (alumni['achievements'] as List<String>)
                  .map(
                    (achievement) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD700).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star,
                              size: 12, color: Color(0xFFFFD700)),
                          const SizedBox(width: 4),
                          Text(
                            achievement,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF0E141B),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],

          // Expertise Tags
          if (alumni['expertise'] != null) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: (alumni['expertise'] as List<String>)
                  .map(
                    (skill) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE7EDF3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        skill,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF4E7097),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ],

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _viewProfile(alumni['name']),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1979E6),
                    side: const BorderSide(color: Color(0xFF1979E6)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('View Profile'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _sendConnectionRequest(alumni['name']),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1979E6),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Connect'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildConnectionCard(Map<String, dynamic> connection) {
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
                child: Text(
                  connection['name'].split(' ').map((e) => e[0]).join(''),
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
                      connection['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0E141B),
                      ),
                    ),
                    Text(
                      '${connection['title']} at ${connection['company']}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF4E7097),
                      ),
                    ),
                  ],
                ),
              ),
              _getConnectionStatusWidget(connection['status']),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.people,
                size: 16,
                color: Color(0xFF4E7097),
              ),
              const SizedBox(width: 4),
              Text(
                '${connection['mutualConnections']} mutual connections',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4E7097),
                ),
              ),
              const Spacer(),
              Text(
                connection['connectedDate'],
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4E7097),
                ),
              ),
            ],
          ),
          if (connection['message'] != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                connection['message'],
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF4E7097),
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
          if (connection['status'] == 'pending_received') ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _rejectConnection(connection['name']),
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
                    onPressed: () => _acceptConnection(connection['name']),
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
          ],
        ],
      ),
    );
  }

  Widget _buildConnectionStat(String title, String value, IconData icon) {
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
            fontSize: 20,
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

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: const Color(0xFF4E7097),
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF4E7097),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: const Color(0xFF4E7097),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4E7097),
            ),
          ),
        ),
      ],
    );
  }

  Widget _getConnectionStatusWidget(String status) {
    switch (status) {
      case 'connected':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF10B981).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Connected',
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF10B981),
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case 'pending_sent':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF59E0B).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'Pending',
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFFF59E0B),
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      case 'pending_received':
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1979E6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Text(
            'New Request',
            style: TextStyle(
              fontSize: 10,
              color: Color(0xFF1979E6),
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      default:
        return const SizedBox();
    }
  }

  void _performSearch(String query) {
    // TODO: Implement search functionality
  }

  void _showFilterDialog() {
    // TODO: Show filter dialog
  }

  void _showNetworkingEvents() {
    // TODO: Show networking events
  }

  void _viewAllFeatured() {
    // TODO: View all featured alumni
  }

  void _viewAllConnections() {
    // TODO: View all connections
  }

  void _startNetworking() {
    // TODO: Start networking flow
  }

  void _toggleSaved(String name) {
    // TODO: Toggle saved status
  }

  void _viewProfile(String name) {
    // TODO: View alumni profile
  }

  void _sendConnectionRequest(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connection request sent to $name'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    // TODO: Send connection request
  }

  void _acceptConnection(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connection accepted: $name'),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
    // TODO: Accept connection
  }

  void _rejectConnection(String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Connection declined: $name'),
        backgroundColor: const Color(0xFFEF4444),
        behavior: SnackBarBehavior.floating,
      ),
    );
    // TODO: Reject connection
  }
}
