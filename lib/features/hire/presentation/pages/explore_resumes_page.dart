import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';
import 'package:connectu_alumni_platform/core/widgets/modern_button.dart';
import 'package:connectu_alumni_platform/features/hire/data/services/student_profiles_service.dart';

class ExploreResumesPage extends StatefulWidget {
  const ExploreResumesPage({super.key});

  @override
  State<ExploreResumesPage> createState() => _ExploreResumesPageState();
}

class _ExploreResumesPageState extends State<ExploreResumesPage> {
  final TextEditingController _searchController = TextEditingController();
  final StudentProfilesService _studentProfilesService =
      StudentProfilesService();

  String _selectedFilter = 'All';
  String _selectedSkill = 'All';
  List<Map<String, dynamic>> _students = [];
  List<Map<String, dynamic>> _filteredStudents = [];
  bool _isLoading = true;

  final List<String> _filters = [
    'All',
    'Computer Science',
    'Electronics',
    'Mechanical',
    'Civil',
    'Business',
    'Design',
  ];

  final List<String> _skills = [
    'All',
    'Flutter',
    'React',
    'Python',
    'Java',
    'JavaScript',
    'UI/UX Design',
    'Data Science',
    'Machine Learning',
    'Marketing',
    'Sales',
  ];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final students = await _studentProfilesService.getAllStudentProfiles();
      setState(() {
        _students = students;
        _filteredStudents = students;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading students: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterStudents() {
    setState(() {
      _filteredStudents = _students.where((student) {
        // Search filter
        final searchQuery = _searchController.text.toLowerCase();
        final matchesSearch = searchQuery.isEmpty ||
            student['name']?.toLowerCase().contains(searchQuery) == true ||
            student['branch']?.toLowerCase().contains(searchQuery) == true ||
            student['skills']?.any(
                    (skill) => skill.toLowerCase().contains(searchQuery)) ==
                true;

        // Branch filter
        final matchesBranch =
            _selectedFilter == 'All' || student['branch'] == _selectedFilter;

        // Skill filter
        final matchesSkill = _selectedSkill == 'All' ||
            student['skills']?.contains(_selectedSkill) == true;

        return matchesSearch && matchesBranch && matchesSkill;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        title: const Text(
          'Explore Resumes',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textPrimary),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: AppTheme.textPrimary),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Column(
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  onChanged: (_) => _filterStudents(),
                  decoration: InputDecoration(
                    hintText: 'Search students by name, branch, or skills...',
                    prefixIcon:
                        const Icon(Icons.search, color: AppTheme.textSecondary),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear,
                                color: AppTheme.textSecondary),
                            onPressed: () {
                              _searchController.clear();
                              _filterStudents();
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppTheme.textSecondary),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                          color: AppTheme.primaryColor, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 12),

                // Filter Chips
                LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 400) {
                      return Row(
                        children: [
                          Expanded(
                            child: _buildFilterChip('Branch', _selectedFilter,
                                (value) {
                              setState(() {
                                _selectedFilter = value;
                                _filterStudents();
                              });
                            }),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildFilterChip('Skills', _selectedSkill,
                                (value) {
                              setState(() {
                                _selectedSkill = value;
                                _filterStudents();
                              });
                            }),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: _buildFilterChip('Branch', _selectedFilter,
                                (value) {
                              setState(() {
                                _selectedFilter = value;
                                _filterStudents();
                              });
                            }),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: _buildFilterChip('Skills', _selectedSkill,
                                (value) {
                              setState(() {
                                _selectedSkill = value;
                                _filterStudents();
                              });
                            }),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ],
            ),
          ),

          // Results Count
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: AppTheme.surfaceColor,
            child: Row(
              children: [
                Text(
                  '${_filteredStudents.length} students found',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
                const Spacer(),
                if (_filteredStudents.isNotEmpty)
                  TextButton.icon(
                    onPressed: _viewShortlistedStudents,
                    icon: const Icon(Icons.people, size: 16),
                    label: const Text('View Shortlisted'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppTheme.primaryColor,
                    ),
                  ),
              ],
            ),
          ),

          // Students List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredStudents.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _filteredStudents.length,
                        itemBuilder: (context, index) {
                          return _buildStudentCard(_filteredStudents[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      String label, String value, Function(String) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.textSecondary),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isDense: true,
          isExpanded: true,
          style: const TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppTheme.textSecondary,
            size: 16,
          ),
          items: (label == 'Branch' ? _filters : _skills).map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            );
          }).toList(),
          onChanged: (String? newValue) {
            if (newValue != null) {
              onChanged(newValue);
            }
          },
        ),
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    final isShortlisted = student['isShortlisted'] == true;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isShortlisted
            ? Border.all(color: AppTheme.successColor, width: 2)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with avatar and basic info
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                child: Text(
                  student['name']?.substring(0, 1).toUpperCase() ?? 'S',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
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
                            student['name'] ?? 'Unknown Student',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.textPrimary,
                            ),
                          ),
                        ),
                        if (isShortlisted)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppTheme.successColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                  color:
                                      AppTheme.successColor.withOpacity(0.3)),
                            ),
                            child: const Text(
                              'Shortlisted',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.successColor,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${student['branch'] ?? 'Unknown'} • ${student['year'] ?? 'Unknown Year'}',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppTheme.textSecondary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      student['university'] ?? 'Unknown University',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Skills
          if (student['skills'] != null && student['skills'].isNotEmpty) ...[
            const Text(
              'Skills',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: (student['skills'] as List).take(6).map((skill) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    skill.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Experience and Projects
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 400) {
                return Row(
                  children: [
                    Expanded(
                      child: _buildInfoItem(
                        Icons.work_outline,
                        'Experience',
                        student['experience'] ?? '0 years',
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        Icons.code,
                        'Projects',
                        '${student['projects'] ?? 0} projects',
                      ),
                    ),
                    Expanded(
                      child: _buildInfoItem(
                        Icons.school,
                        'CGPA',
                        student['cgpa'] ?? 'N/A',
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            Icons.work_outline,
                            'Experience',
                            student['experience'] ?? '0 years',
                          ),
                        ),
                        Expanded(
                          child: _buildInfoItem(
                            Icons.code,
                            'Projects',
                            '${student['projects'] ?? 0} projects',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoItem(
                            Icons.school,
                            'CGPA',
                            student['cgpa'] ?? 'N/A',
                          ),
                        ),
                        const Expanded(child: SizedBox()), // Spacer
                      ],
                    ),
                  ],
                );
              }
            },
          ),

          const SizedBox(height: 16),

          // Action Buttons
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 400) {
                return Row(
                  children: [
                    Expanded(
                      child: ModernButton(
                        text: 'View Resume',
                        onPressed: () => _viewResume(student),
                        type: ModernButtonType.secondary,
                        icon: Icons.visibility,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ModernButton(
                        text: isShortlisted ? 'Remove from List' : 'Shortlist',
                        onPressed: () => _toggleShortlist(student),
                        type: isShortlisted
                            ? ModernButtonType.outline
                            : ModernButtonType.primary,
                        icon: isShortlisted ? Icons.remove : Icons.add,
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ModernButton(
                        text: 'View Resume',
                        onPressed: () => _viewResume(student),
                        type: ModernButtonType.secondary,
                        icon: Icons.visibility,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ModernButton(
                        text: isShortlisted ? 'Remove from List' : 'Shortlist',
                        onPressed: () => _toggleShortlist(student),
                        type: isShortlisted
                            ? ModernButtonType.outline
                            : ModernButtonType.primary,
                        icon: isShortlisted ? Icons.remove : Icons.add,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppTheme.textSecondary,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppTheme.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 80,
            color: AppTheme.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No students found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search criteria',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 24),
          ModernButton(
            text: 'Clear Filters',
            onPressed: () {
              setState(() {
                _selectedFilter = 'All';
                _selectedSkill = 'All';
                _searchController.clear();
              });
              _filterStudents();
            },
            type: ModernButtonType.outline,
            icon: Icons.clear,
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Advanced Filters'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Branch'),
              trailing: DropdownButton<String>(
                value: _selectedFilter,
                items: _filters.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedFilter = newValue;
                    });
                  }
                },
              ),
            ),
            ListTile(
              title: const Text('Skill'),
              trailing: DropdownButton<String>(
                value: _selectedSkill,
                items: _skills.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedSkill = newValue;
                    });
                  }
                },
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
              Navigator.of(context).pop();
              _filterStudents();
            },
            child: const Text('Apply'),
          ),
        ],
      ),
    );
  }

  void _viewResume(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      child: Text(
                        student['name']?.substring(0, 1).toUpperCase() ?? 'S',
                        style: const TextStyle(
                          color: Colors.white,
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
                            student['name'] ?? 'Unknown Student',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${student['branch'] ?? 'Unknown'} • ${student['year'] ?? 'Unknown Year'}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildResumeSection('About',
                          student['about'] ?? 'No description available'),
                      _buildResumeSection('Education',
                          '${student['university'] ?? 'Unknown University'}\n${student['branch'] ?? 'Unknown Branch'}\nCGPA: ${student['cgpa'] ?? 'N/A'}'),
                      _buildResumeSection(
                          'Skills',
                          (student['skills'] as List?)?.join(', ') ??
                              'No skills listed'),
                      _buildResumeSection('Experience',
                          '${student['experience'] ?? '0'} years of experience'),
                      _buildResumeSection('Projects',
                          '${student['projects'] ?? 0} projects completed'),
                      _buildResumeSection('Contact',
                          'Email: ${student['email'] ?? 'Not provided'}\nPhone: ${student['phone'] ?? 'Not provided'}'),
                    ],
                  ),
                ),
              ),

              // Actions
              Padding(
                padding: const EdgeInsets.all(20),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    if (constraints.maxWidth > 400) {
                      return Row(
                        children: [
                          Expanded(
                            child: ModernButton(
                              text: student['isShortlisted'] == true
                                  ? 'Remove from List'
                                  : 'Shortlist',
                              onPressed: () {
                                Navigator.of(context).pop();
                                _toggleShortlist(student);
                              },
                              type: student['isShortlisted'] == true
                                  ? ModernButtonType.outline
                                  : ModernButtonType.primary,
                              icon: student['isShortlisted'] == true
                                  ? Icons.remove
                                  : Icons.add,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ModernButton(
                              text: 'Contact',
                              onPressed: () {
                                Navigator.of(context).pop();
                                _contactStudent(student);
                              },
                              type: ModernButtonType.secondary,
                              icon: Icons.message,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: ModernButton(
                              text: student['isShortlisted'] == true
                                  ? 'Remove from List'
                                  : 'Shortlist',
                              onPressed: () {
                                Navigator.of(context).pop();
                                _toggleShortlist(student);
                              },
                              type: student['isShortlisted'] == true
                                  ? ModernButtonType.outline
                                  : ModernButtonType.primary,
                              icon: student['isShortlisted'] == true
                                  ? Icons.remove
                                  : Icons.add,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ModernButton(
                              text: 'Contact',
                              onPressed: () {
                                Navigator.of(context).pop();
                                _contactStudent(student);
                              },
                              type: ModernButtonType.secondary,
                              icon: Icons.message,
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResumeSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: AppTheme.textSecondary,
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  void _toggleShortlist(Map<String, dynamic> student) async {
    try {
      await _studentProfilesService.toggleShortlist(student['id']);
      setState(() {
        student['isShortlisted'] = !(student['isShortlisted'] ?? false);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(student['isShortlisted']
              ? 'Added to shortlist'
              : 'Removed from shortlist'),
          backgroundColor: student['isShortlisted']
              ? AppTheme.successColor
              : AppTheme.warningColor,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating shortlist: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  void _contactStudent(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Contact ${student['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email'),
              subtitle: Text(student['email'] ?? 'Not provided'),
              onTap: () {
                // Open email app
              },
            ),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Phone'),
              subtitle: Text(student['phone'] ?? 'Not provided'),
              onTap: () {
                // Open phone app
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _viewShortlistedStudents() {
    context.push('/hire/hire-interns');
  }
}
