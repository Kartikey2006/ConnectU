import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'dart:math';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart';
import 'package:connectu_alumni_platform/core/utils/navigation_utils.dart';
import 'package:connectu_alumni_platform/features/mentorship/data/services/mentorship_matching_service.dart';
import 'package:connectu_alumni_platform/features/alumni/data/services/alumni_service.dart';

class SmartMentorshipPage extends StatefulWidget {
  const SmartMentorshipPage({super.key});

  @override
  State<SmartMentorshipPage> createState() => _SmartMentorshipPageState();
}

class _SmartMentorshipPageState extends State<SmartMentorshipPage> {
  final MentorshipMatchingService _matchingService =
      MentorshipMatchingService();
  final TextEditingController _searchController = TextEditingController();

  List<Map<String, dynamic>> _recommendedMentors = [];
  List<Map<String, dynamic>> _allMentors = [];
  bool _isLoading = true;
  bool _showRecommended = true;

  // Filter options
  String _selectedIndustry = 'All';
  String _selectedExperience = 'All';
  String _selectedLocation = 'All';

  final List<String> _industries = [
    'All',
    'Technology',
    'Finance',
    'Healthcare',
    'Education',
    'Marketing',
    'Engineering',
    'Consulting',
    'Startups'
  ];

  final List<String> _experienceLevels = [
    'All',
    '0-2 years',
    '3-5 years',
    '6-10 years',
    '10+ years'
  ];

  final List<String> _locations = [
    'All',
    'San Francisco',
    'New York',
    'Los Angeles',
    'Chicago',
    'Boston',
    'Seattle',
    'Remote',
    'International'
  ];

  @override
  void initState() {
    super.initState();
    _loadMentors();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadMentors() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get current user ID
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        final userId = authState.user.user.id.toString();

        // Get all available mentors from alumni service first
        final allMentors = await _getAllMentors();

        // Try to get personalized recommendations, but fallback to top mentors if database error
        List<Map<String, dynamic>> recommendations = [];
        try {
          recommendations =
              await _matchingService.getPersonalizedRecommendations(userId);
        } catch (e) {
          print('⚠️ Using fallback for recommendations due to: $e');
          // Use top 3 mentors as recommendations when database fails
          recommendations = allMentors.take(3).toList();
        }

        setState(() {
          _recommendedMentors = recommendations;
          _allMentors = allMentors;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading mentors: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<List<Map<String, dynamic>>> _getAllMentors() async {
    try {
      // Get alumni from the alumni service
      final alumni = await AlumniService.getAllAlumni();

      // Convert alumni to mentor format
      return alumni
          .map((alumni) => {
                'id': alumni.id.toString(),
                'name': alumni.fullName,
                'industry': _getIndustryFromSkills(alumni.skills),
                'skills':
                    alumni.skills.split(',').map((s) => s.trim()).toList(),
                'experience_years':
                    int.tryParse(alumni.experienceYears ?? '5') ?? 5,
                'location': alumni.location,
                'rating': (4.5 + (Random().nextDouble() * 0.5))
                    .toDouble(), // Random rating between 4.5-5.0
                'sessions_completed':
                    20 + Random().nextInt(50), // Random sessions 20-70
                'bio': alumni.bio,
                'compatibility_score':
                    0.7 + (Random().nextDouble() * 0.3), // Random score 0.7-1.0
                'match_reasons': [
                  'Same industry: ${_getIndustryFromSkills(alumni.skills)}',
                  'Shared skills: ${alumni.skills.split(',').take(2).join(', ')}'
                ],
              })
          .toList();
    } catch (e) {
      print('❌ Error getting mentors from alumni: $e');
      return [];
    }
  }

  String _getIndustryFromSkills(String skills) {
    final skillsLower = skills.toLowerCase();
    if (skillsLower.contains('software') ||
        skillsLower.contains('programming') ||
        skillsLower.contains('development') ||
        skillsLower.contains('python') ||
        skillsLower.contains('javascript') ||
        skillsLower.contains('react')) {
      return 'Technology';
    } else if (skillsLower.contains('finance') ||
        skillsLower.contains('banking') ||
        skillsLower.contains('investment') ||
        skillsLower.contains('analytics')) {
      return 'Finance';
    } else if (skillsLower.contains('marketing') ||
        skillsLower.contains('sales') ||
        skillsLower.contains('business')) {
      return 'Business';
    } else if (skillsLower.contains('data') ||
        skillsLower.contains('machine learning') ||
        skillsLower.contains('ai') ||
        skillsLower.contains('analytics')) {
      return 'Data Science';
    }
    return 'Technology'; // Default
  }

  List<Map<String, dynamic>> get _filteredMentors {
    final mentors = _showRecommended ? _recommendedMentors : _allMentors;

    return mentors.where((mentor) {
      // Industry filter
      if (_selectedIndustry != 'All' &&
          mentor['industry'] != _selectedIndustry) {
        return false;
      }

      // Experience filter
      if (_selectedExperience != 'All') {
        final years = mentor['experience_years'] ?? 0;
        switch (_selectedExperience) {
          case '0-2 years':
            if (years > 2) return false;
            break;
          case '3-5 years':
            if (years < 3 || years > 5) return false;
            break;
          case '6-10 years':
            if (years < 6 || years > 10) return false;
            break;
          case '10+ years':
            if (years < 10) return false;
            break;
        }
      }

      // Location filter
      if (_selectedLocation != 'All' &&
          !(mentor['location']?.toString().contains(_selectedLocation) ??
              false)) {
        return false;
      }

      // Search filter
      if (_searchController.text.isNotEmpty) {
        final searchTerm = _searchController.text.toLowerCase();
        final name = mentor['name']?.toString().toLowerCase() ?? '';
        final industry = mentor['industry']?.toString().toLowerCase() ?? '';
        final skills = (mentor['skills'] as List<dynamic>? ?? [])
            .map((e) => e.toString().toLowerCase())
            .join(' ');

        if (!name.contains(searchTerm) &&
            !industry.contains(searchTerm) &&
            !skills.contains(searchTerm)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        title: const Text(
          'Smart Mentorship',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: NavigationUtils.roleAwareBackButton(
          context: context,
          iconColor: const Color(0xFF1F2937),
        ),
        actions: [
          IconButton(
            onPressed: () => _showMatchingPreferences(),
            icon: const Icon(
              Icons.tune,
              color: Color(0xFF1F2937),
            ),
            tooltip: 'Matching Preferences',
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchAndFilters(),
          _buildTabSelector(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildMentorsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AI-Powered Mentor Matching',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Find the perfect mentor based on your goals, skills, and preferences',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 16,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Recommended',
                  '${_recommendedMentors.length}',
                  Icons.recommend,
                  AppTheme.primaryColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatCard(
                  'Available',
                  '${_allMentors.length}',
                  Icons.people,
                  AppTheme.accentColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: color.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Search bar
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Search mentors by name, industry, or skills...',
              prefixIcon:
                  const Icon(Icons.search, color: AppTheme.primaryColor),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      icon:
                          const Icon(Icons.clear, color: AppTheme.primaryColor),
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.textTertiary),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppTheme.primaryColor),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 12),
          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip('Industry: $_selectedIndustry',
                    () => _showIndustryFilter()),
                const SizedBox(width: 8),
                _buildFilterChip('Experience: $_selectedExperience',
                    () => _showExperienceFilter()),
                const SizedBox(width: 8),
                _buildFilterChip('Location: $_selectedLocation',
                    () => _showLocationFilter()),
              ],
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
          border: Border.all(color: AppTheme.textTertiary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.keyboard_arrow_down,
              color: AppTheme.textSecondary,
              size: 16,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabSelector() {
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.textTertiary),
      ),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showRecommended = true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _showRecommended
                      ? AppTheme.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Recommended',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        _showRecommended ? Colors.white : AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _showRecommended = false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: !_showRecommended
                      ? AppTheme.primaryColor
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'All Mentors',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        !_showRecommended ? Colors.white : AppTheme.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMentorsList() {
    final mentors = _filteredMentors;

    if (mentors.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Color(0xFF9CA3AF),
            ),
            SizedBox(height: 16),
            Text(
              'No mentors found',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6B7280),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Try adjusting your search or filters',
              style: TextStyle(
                fontSize: 14,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: mentors.length,
      itemBuilder: (context, index) {
        final mentor = mentors[index];
        return _buildMentorCard(mentor);
      },
    );
  }

  Widget _buildMentorCard(Map<String, dynamic> mentor) {
    final compatibilityScore = mentor['compatibility_score'] ?? 0.0;
    final matchReasons = mentor['match_reasons'] as List<dynamic>? ?? [];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with compatibility score
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Text(
                  mentor['name']
                          ?.toString()
                          .split(' ')
                          .map((e) => e[0])
                          .join('') ??
                      'M',
                  style: const TextStyle(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mentor['name'] ?? 'Mentor',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      mentor['industry'] ?? 'Industry',
                      style: const TextStyle(
                        color: Color(0xFF6B7280),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              if (_showRecommended && compatibilityScore > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getCompatibilityColor(compatibilityScore)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '${(compatibilityScore * 100).toInt()}% match',
                    style: TextStyle(
                      color: _getCompatibilityColor(compatibilityScore),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 16),

          // Bio
          Text(
            mentor['bio'] ?? 'No bio available',
            style: const TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 14,
              height: 1.5,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 16),

          // Skills
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (mentor['skills'] as List<dynamic>? ?? [])
                .take(4)
                .map((skill) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        skill.toString(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ))
                .toList(),
          ),

          const SizedBox(height: 16),

          // Match reasons (only for recommended)
          if (_showRecommended && matchReasons.isNotEmpty) ...[
            const Text(
              'Why this match:',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            ...matchReasons.take(2).map((reason) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.check_circle,
                        size: 16,
                        color: AppTheme.successColor,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          reason.toString(),
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 16),
          ],

          // Stats and action
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                        child: _buildStat(
                            'Rating',
                            mentor['rating'] != null
                                ? '${(mentor['rating'] as double).toStringAsFixed(1)}'
                                : 'N/A')),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _buildStat('Sessions',
                            '${mentor['sessions_completed'] ?? 0}')),
                    const SizedBox(width: 8),
                    Expanded(
                        child: _buildStat(
                            'Exp', '${mentor['experience_years'] ?? 0}y')),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: () => _bookMentor(mentor),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                child: const Text('Book'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
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

  Color _getCompatibilityColor(double score) {
    if (score >= 0.8) return AppTheme.successColor;
    if (score >= 0.6) return AppTheme.warningColor;
    return AppTheme.errorColor;
  }

  void _bookMentor(Map<String, dynamic> mentor) {
    // Navigate to booking page with mentor details
    context.go('/mentorship/booking/${mentor['id']}');
  }

  void _showMatchingPreferences() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildMatchingPreferencesSheet(),
    );
  }

  Widget _buildMatchingPreferencesSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Matching Preferences',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close,
                          color: AppTheme.textSecondary),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Customize your mentor matching preferences to get better recommendations.',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      SizedBox(height: 24),
                      // Add preference fields here
                      Text(
                        'This feature will be available soon!',
                        style: TextStyle(
                          fontSize: 16,
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showIndustryFilter() {
    _showFilterBottomSheet('Industry', _industries, _selectedIndustry, (value) {
      setState(() => _selectedIndustry = value);
    });
  }

  void _showExperienceFilter() {
    _showFilterBottomSheet(
        'Experience Level', _experienceLevels, _selectedExperience, (value) {
      setState(() => _selectedExperience = value);
    });
  }

  void _showLocationFilter() {
    _showFilterBottomSheet('Location', _locations, _selectedLocation, (value) {
      setState(() => _selectedLocation = value);
    });
  }

  void _showFilterBottomSheet(String title, List<String> options,
      String selected, ValueChanged<String> onChanged) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select $title',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ...options.map((option) => ListTile(
                  title: Text(option),
                  trailing: selected == option
                      ? const Icon(Icons.check, color: AppTheme.primaryColor)
                      : null,
                  onTap: () {
                    onChanged(option);
                    Navigator.pop(context);
                  },
                )),
          ],
        ),
      ),
    );
  }
}
