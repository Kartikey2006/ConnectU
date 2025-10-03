import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/core/utils/navigation_utils.dart';

class AlumniDirectoryPage extends StatefulWidget {
  const AlumniDirectoryPage({super.key});

  @override
  State<AlumniDirectoryPage> createState() => _AlumniDirectoryPageState();
}

class _AlumniDirectoryPageState extends State<AlumniDirectoryPage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedBatch = 'All';
  String _selectedIndustry = 'All';
  String _selectedLocation = 'All';
  String _selectedSkills = 'All';
  String _sortBy = 'Name';

  final List<String> _batchYears = [
    'All',
    '2020',
    '2019',
    '2018',
    '2017',
    '2016',
    '2015'
  ];
  final List<String> _industries = [
    'All',
    'Technology',
    'Finance',
    'Healthcare',
    'Education',
    'Consulting',
    'Startup'
  ];
  final List<String> _locations = [
    'All',
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Pune',
    'Hyderabad',
    'Chennai',
    'International'
  ];
  final List<String> _skills = [
    'All',
    'Software Development',
    'Data Science',
    'Product Management',
    'Marketing',
    'Sales',
    'Design'
  ];
  final List<String> _sortOptions = [
    'Name',
    'Batch Year',
    'Industry',
    'Location'
  ];

  @override
  void dispose() {
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
        leading: NavigationUtils.safeBackButton(
          context: context,
          iconColor: const Color(0xFF0E141B),
          iconSize: 24,
        ),
        title: const Text(
          'Alumni Directory',
          style: TextStyle(
            color: Color(0xFF0E141B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: _showFilters,
            icon: const Icon(
              Icons.filter_list,
              color: Color(0xFF0E141B),
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search alumni by name, company, or skills...',
                prefixIcon: const Icon(Icons.search, color: Color(0xFF4E7097)),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                        },
                        icon: const Icon(Icons.clear, color: Color(0xFF4E7097)),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE7EDF3)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFFE7EDF3)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1979E6)),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),

          // Filter Chips
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip(
                    'Batch: $_selectedBatch', () => _showBatchFilter()),
                const SizedBox(width: 8),
                _buildFilterChip('Industry: $_selectedIndustry',
                    () => _showIndustryFilter()),
                const SizedBox(width: 8),
                _buildFilterChip('Location: $_selectedLocation',
                    () => _showLocationFilter()),
                const SizedBox(width: 8),
                _buildFilterChip(
                    'Skills: $_selectedSkills', () => _showSkillsFilter()),
              ],
            ),
          ),

          // Sort and Results Count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${_getFilteredAlumni().length} alumni found',
                  style: const TextStyle(
                    color: Color(0xFF4E7097),
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                DropdownButton<String>(
                  value: _sortBy,
                  underline: const SizedBox(),
                  items: _sortOptions.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _sortBy = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),

          // Alumni List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _getFilteredAlumni().length,
              itemBuilder: (context, index) {
                final alumni = _getFilteredAlumni()[index];
                return _buildAlumniCard(alumni);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE7EDF3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF0E141B),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xFF4E7097),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlumniCard(Map<String, dynamic> alumni) {
    print('🔍 Building alumni card for: ${alumni['name']}');
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          // Profile Picture
          CircleAvatar(
            radius: 30,
            backgroundColor: const Color(0xFF1979E6).withOpacity(0.1),
            backgroundImage: alumni['profilePicture'] != null
                ? NetworkImage(alumni['profilePicture'])
                : null,
            child: alumni['profilePicture'] == null
                ? Text(
                    alumni['name'].split(' ').map((e) => e[0]).join(''),
                    style: const TextStyle(
                      color: Color(0xFF1979E6),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                : null,
          ),
          const SizedBox(width: 16),

          // Alumni Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alumni['name'] ?? 'No Name',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0E141B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alumni['designation'] ?? 'Software Engineer',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4E7097),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  alumni['company'] ?? 'Google',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4E7097),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoChip(
                        'Batch ${alumni['batchYear']}', Icons.school),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                        alumni['location'] ?? 'Mumbai', Icons.location_on),
                    const SizedBox(width: 8),
                    _buildInfoChip(
                        alumni['industry'] ?? 'Technology', Icons.business),
                  ],
                ),
              ],
            ),
          ),

          // Action Buttons
          Column(
            children: [
              IconButton(
                onPressed: () => _viewProfile(alumni),
                icon: const Icon(
                  Icons.visibility,
                  color: Color(0xFF1979E6),
                ),
              ),
              IconButton(
                onPressed: () => _startChat(alumni),
                icon: const Icon(
                  Icons.chat,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF4E7097)),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF4E7097),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> _getFilteredAlumni() {
    // Mock data - replace with actual API call
    List<Map<String, dynamic>> alumni = [
      {
        'name': 'Priya Sharma',
        'designation': 'Senior Software Engineer',
        'company': 'Google',
        'batchYear': '2018',
        'industry': 'Technology',
        'location': 'Bangalore',
        'skills': ['Software Development', 'Machine Learning'],
        'profilePicture': null,
      },
      {
        'name': 'Rajesh Kumar',
        'designation': 'Product Manager',
        'company': 'Microsoft',
        'batchYear': '2017',
        'industry': 'Technology',
        'location': 'Bangalore',
        'skills': ['Product Management', 'Data Science'],
        'profilePicture': null,
      },
      {
        'name': 'Anjali Singh',
        'designation': 'Investment Banker',
        'company': 'Goldman Sachs',
        'batchYear': '2016',
        'industry': 'Finance',
        'location': 'Mumbai',
        'skills': ['Finance', 'Analytics'],
        'profilePicture': null,
      },
      {
        'name': 'Vikram Patel',
        'designation': 'Data Scientist',
        'company': 'Amazon',
        'batchYear': '2019',
        'industry': 'Technology',
        'location': 'Pune',
        'skills': ['Data Science', 'Machine Learning'],
        'profilePicture': null,
      },
    ];

    print('🔍 Total alumni in mock data: ${alumni.length}');
    for (var a in alumni) {
      print('🔍 Alumni: ${a['name']}');
    }

    // Apply filters
    return alumni.where((alumni) {
      bool matchesSearch = _searchController.text.isEmpty ||
          alumni['name']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          alumni['company']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()) ||
          alumni['skills'].any((skill) => skill
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()));

      bool matchesBatch =
          _selectedBatch == 'All' || alumni['batchYear'] == _selectedBatch;
      bool matchesIndustry =
          _selectedIndustry == 'All' || alumni['industry'] == _selectedIndustry;
      bool matchesLocation =
          _selectedLocation == 'All' || alumni['location'] == _selectedLocation;
      bool matchesSkills = _selectedSkills == 'All' ||
          alumni['skills'].contains(_selectedSkills);

      return matchesSearch &&
          matchesBatch &&
          matchesIndustry &&
          matchesLocation &&
          matchesSkills;
    }).toList();
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildFilterBottomSheet(),
    );
  }

  Widget _buildFilterBottomSheet() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE7EDF3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Filter Alumni',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0E141B),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFilterSection('Batch Year', _batchYears, _selectedBatch,
                      (value) {
                    setState(() => _selectedBatch = value);
                  }),
                  const SizedBox(height: 24),
                  _buildFilterSection(
                      'Industry', _industries, _selectedIndustry, (value) {
                    setState(() => _selectedIndustry = value);
                  }),
                  const SizedBox(height: 24),
                  _buildFilterSection('Location', _locations, _selectedLocation,
                      (value) {
                    setState(() => _selectedLocation = value);
                  }),
                  const SizedBox(height: 24),
                  _buildFilterSection('Skills', _skills, _selectedSkills,
                      (value) {
                    setState(() => _selectedSkills = value);
                  }),
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _selectedBatch = 'All';
                        _selectedIndustry = 'All';
                        _selectedLocation = 'All';
                        _selectedSkills = 'All';
                      });
                      Navigator.pop(context);
                    },
                    child: const Text('Clear All'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1979E6),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Apply Filters'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options,
      String selected, Function(String) onChanged) {
    return Column(
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
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = option == selected;
            return GestureDetector(
              onTap: () => onChanged(option),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF1979E6) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF1979E6)
                        : const Color(0xFFE7EDF3),
                  ),
                ),
                child: Text(
                  option,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF0E141B),
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showBatchFilter() => _showFilters();
  void _showIndustryFilter() => _showFilters();
  void _showLocationFilter() => _showFilters();
  void _showSkillsFilter() => _showFilters();

  void _viewProfile(Map<String, dynamic> alumni) {
    context.go('/alumni-profile/${alumni['id'] ?? '1'}');
  }

  void _startChat(Map<String, dynamic> alumni) {
    // TODO: Navigate to chat with alumni
    context.go('/chat/${alumni['id'] ?? '1'}');
  }
}
