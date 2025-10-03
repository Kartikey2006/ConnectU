import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/core/utils/navigation_utils.dart';
import 'package:connectu_alumni_platform/features/jobs/data/services/jobs_service.dart';

class JobPostingsPage extends StatefulWidget {
  const JobPostingsPage({super.key});

  @override
  State<JobPostingsPage> createState() => _JobPostingsPageState();
}

class _JobPostingsPageState extends State<JobPostingsPage> {
  final TextEditingController _searchController = TextEditingController();
  final JobsService _jobsService = JobsService();
  String _selectedCategory = 'All';
  String _selectedLocation = 'All';
  String _selectedType = 'All';
  List<Map<String, dynamic>> _jobs = [];
  bool _isLoading = true;
  String? _applyingJobId; // Track which job is being applied to

  final List<String> _categories = [
    'All',
    'Technology',
    'Finance',
    'Healthcare',
    'Education',
    'Consulting',
    'Marketing'
  ];
  final List<String> _locations = [
    'All',
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Pune',
    'Hyderabad',
    'Chennai',
    'Remote'
  ];
  final List<String> _types = [
    'All',
    'Full-time',
    'Part-time',
    'Internship',
    'Contract'
  ];

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadJobs() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final jobs = await _jobsService.getJobs(
        category: _selectedCategory == 'All' ? null : _selectedCategory,
        location: _selectedLocation == 'All' ? null : _selectedLocation,
        type: _selectedType == 'All' ? null : _selectedType,
        searchQuery:
            _searchController.text.isEmpty ? null : _searchController.text,
      );

      setState(() {
        _jobs = jobs;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error loading jobs: $e');
      setState(() {
        _isLoading = false;
      });
    }
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
          'Job Opportunities',
          style: TextStyle(
            color: Color(0xFF0E141B),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => _showFilters(),
            icon: const Icon(
              Icons.filter_list,
              color: Color(0xFF0E141B),
              size: 24,
            ),
          ),
          IconButton(
            onPressed: () => _postJob(),
            icon: const Icon(
              Icons.add,
              color: Color(0xFF1979E6),
              size: 24,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with gradient
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1979E6),
                  Color(0xFF10B981),
                ],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Find Your Dream Job',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Discover opportunities from top companies',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search jobs by title, company, or skills...',
                    prefixIcon:
                        const Icon(Icons.search, color: Color(0xFF4E7097)),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.clear,
                                color: Color(0xFF4E7097)),
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() {});
                    _loadJobs(); // Reload jobs when search text changes
                  },
                ),
              ],
            ),
          ),

          // Filter Chips
          Container(
            height: 50,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _buildFilterChip('Category: $_selectedCategory',
                    () => _showCategoryFilter()),
                const SizedBox(width: 8),
                _buildFilterChip('Location: $_selectedLocation',
                    () => _showLocationFilter()),
                const SizedBox(width: 8),
                _buildFilterChip(
                    'Type: $_selectedType', () => _showTypeFilter()),
              ],
            ),
          ),

          // Results Count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  '${_jobs.length} jobs found',
                  style: const TextStyle(
                    color: Color(0xFF4E7097),
                    fontSize: 14,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => _postJob(),
                  icon: const Icon(Icons.add, size: 16),
                  label: const Text('Post a Job'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFF1979E6),
                  ),
                ),
              ],
            ),
          ),

          // Jobs List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: Color(0xFF1979E6),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Loading jobs...',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  )
                : _jobs.isEmpty
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.work_off,
                              size: 64,
                              color: Color(0xFF9CA3AF),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No jobs found',
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
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _jobs.length,
                        itemBuilder: (context, index) {
                          final job = _jobs[index];
                          return _buildJobCard(job);
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

  Widget _buildJobCard(Map<String, dynamic> job) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
          // Header
          Row(
            children: [
              // Company Logo
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: const Color(0xFF1979E6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.business,
                  color: Color(0xFF1979E6),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),

              // Job Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      job['title'] ?? 'Job Title',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0E141B),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      job['company'] ?? 'Company',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Color(0xFF4E7097),
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Location and Type in separate rows to avoid overflow
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 14,
                          color: Color(0xFF4E7097),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            job['location'] ?? 'Location',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4E7097),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          size: 14,
                          color: Color(0xFF4E7097),
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            job['type'] ?? 'Type',
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF4E7097),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Posted by
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Posted by',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF4E7097),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    job['postedBy'] ?? 'HR',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0E141B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Job Description
          Text(
            job['description'] ?? 'Job description not available.',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4E7097),
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),

          const SizedBox(height: 16),

          // Skills
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: (job['skills'] as List<String>? ?? []).map((skill) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  skill,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF4E7097),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),

          // Footer
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              // Salary
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.attach_money,
                      size: 14,
                      color: Color(0xFF10B981),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      job['salary'] ?? 'Not specified',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF10B981),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // Experience
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF1979E6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.work,
                      size: 14,
                      color: Color(0xFF1979E6),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      job['experience'] ?? 'Not specified',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1979E6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Posted Date and Action Buttons
          Row(
            children: [
              // Posted Date
              Text(
                job['postedDate'] ?? 'Recently',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF4E7097),
                ),
              ),
              const Spacer(),
            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _viewJobDetails(job),
                  icon: const Icon(Icons.visibility, size: 16),
                  label: const Text('View Details'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF1979E6),
                    side: const BorderSide(color: Color(0xFF1979E6)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed:
                      _applyingJobId == job['id'] ? null : () => _applyJob(job),
                  icon: _applyingJobId == job['id']
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.send, size: 16),
                  label: Text(_applyingJobId == job['id']
                      ? 'Applying...'
                      : 'Apply Now'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Filter methods that reload jobs from database
  void _showCategoryFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Category',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ..._categories.map((category) => ListTile(
                  title: Text(category),
                  trailing: _selectedCategory == category
                      ? const Icon(Icons.check, color: Color(0xFF1979E6))
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                    Navigator.pop(context);
                    _loadJobs(); // Reload jobs when filter changes
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showLocationFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Location',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ..._locations.map((location) => ListTile(
                  title: Text(location),
                  trailing: _selectedLocation == location
                      ? const Icon(Icons.check, color: Color(0xFF1979E6))
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedLocation = location;
                    });
                    Navigator.pop(context);
                    _loadJobs(); // Reload jobs when filter changes
                  },
                )),
          ],
        ),
      ),
    );
  }

  void _showTypeFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Job Type',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ..._types.map((type) => ListTile(
                  title: Text(type),
                  trailing: _selectedType == type
                      ? const Icon(Icons.check, color: Color(0xFF1979E6))
                      : null,
                  onTap: () {
                    setState(() {
                      _selectedType = type;
                    });
                    Navigator.pop(context);
                    _loadJobs(); // Reload jobs when filter changes
                  },
                )),
          ],
        ),
      ),
    );
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
      height: MediaQuery.of(context).size.height * 0.6,
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
              'Filter Jobs',
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
                  _buildFilterSection(
                      'Category', _categories, _selectedCategory, (value) {
                    setState(() => _selectedCategory = value);
                  }),
                  const SizedBox(height: 24),
                  _buildFilterSection('Location', _locations, _selectedLocation,
                      (value) {
                    setState(() => _selectedLocation = value);
                  }),
                  const SizedBox(height: 24),
                  _buildFilterSection('Job Type', _types, _selectedType,
                      (value) {
                    setState(() => _selectedType = value);
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
                        _selectedCategory = 'All';
                        _selectedLocation = 'All';
                        _selectedType = 'All';
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

  void _postJob() {
    // TODO: Navigate to job posting form
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Job posting feature coming soon!'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewJobDetails(Map<String, dynamic> job) {
    context.go('/job-details/${job['id']}');
  }

  void _applyJob(Map<String, dynamic> job) async {
    // Show confirmation dialog first
    final shouldApply = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apply for Job'),
        content: Text(
            'Are you sure you want to apply for ${job['title']} at ${job['company']}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
              foregroundColor: Colors.white,
            ),
            child: const Text('Apply'),
          ),
        ],
      ),
    );

    if (shouldApply != true) return;

    // Set loading state
    setState(() {
      _applyingJobId = job['id'];
    });

    try {
      // Apply for job using database service
      final success = await _jobsService.applyForJob(
        jobId: job['id'],
        applicantId: '1', // TODO: Get actual user ID from auth
        coverLetter:
            'I am interested in this position and would like to apply.',
      );

      // Clear loading state
      setState(() {
        _applyingJobId = null;
      });

      if (success) {
        _showResumeSentPopup(job);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to submit application. Please try again.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Clear loading state in case of error
      setState(() {
        _applyingJobId = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showResumeSentPopup(Map<String, dynamic> job) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.all(24),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 50,
                color: Colors.green,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Resume Sent!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0E141B),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Your application for ${job['title']} at ${job['company']} has been submitted successfully.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF6B7280),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
