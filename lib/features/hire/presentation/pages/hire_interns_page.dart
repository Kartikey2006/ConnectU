import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';
import 'package:connectu_alumni_platform/core/widgets/modern_button.dart';
import 'package:connectu_alumni_platform/features/hire/data/services/student_profiles_service.dart';

class HireInternsPage extends StatefulWidget {
  const HireInternsPage({super.key});

  @override
  State<HireInternsPage> createState() => _HireInternsPageState();
}

class _HireInternsPageState extends State<HireInternsPage> {
  final StudentProfilesService _studentProfilesService =
      StudentProfilesService();
  List<Map<String, dynamic>> _shortlistedStudents = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadShortlistedStudents();
  }

  Future<void> _loadShortlistedStudents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final students = await _studentProfilesService.getShortlistedStudents();
      setState(() {
        _shortlistedStudents = students;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading shortlisted students: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        title: const Text(
          'Hire Interns',
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
          if (_shortlistedStudents.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.people, color: AppTheme.textPrimary),
              onPressed: () => _showBulkActions(),
            ),
        ],
      ),
      body: Column(
        children: [
          // Header Stats
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              children: [
                _buildStatCard(
                  'Shortlisted',
                  _shortlistedStudents.length.toString(),
                  Icons.people,
                  AppTheme.primaryColor,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  'Interviewed',
                  '3',
                  Icons.calendar_today,
                  AppTheme.successColor,
                ),
                const SizedBox(width: 16),
                _buildStatCard(
                  'Hired',
                  '2',
                  Icons.check_circle,
                  AppTheme.accentColor,
                ),
              ],
            ),
          ),

          // Quick Actions
          Container(
            padding: const EdgeInsets.all(16),
            color: AppTheme.surfaceColor,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 400) {
                  return Row(
                    children: [
                      Expanded(
                        child: ModernButton(
                          text: 'Schedule Interviews',
                          onPressed: _shortlistedStudents.isNotEmpty
                              ? _scheduleInterviews
                              : null,
                          type: ModernButtonType.primary,
                          icon: Icons.calendar_today,
                          size: ModernButtonSize.small,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ModernButton(
                          text: 'Send Offers',
                          onPressed: _shortlistedStudents.isNotEmpty
                              ? _sendOffers
                              : null,
                          type: ModernButtonType.secondary,
                          icon: Icons.send,
                          size: ModernButtonSize.small,
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
                          text: 'Schedule Interviews',
                          onPressed: _shortlistedStudents.isNotEmpty
                              ? _scheduleInterviews
                              : null,
                          type: ModernButtonType.primary,
                          icon: Icons.calendar_today,
                          size: ModernButtonSize.small,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ModernButton(
                          text: 'Send Offers',
                          onPressed: _shortlistedStudents.isNotEmpty
                              ? _sendOffers
                              : null,
                          type: ModernButtonType.secondary,
                          icon: Icons.send,
                          size: ModernButtonSize.small,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ),

          // Students List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _shortlistedStudents.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _shortlistedStudents.length,
                        itemBuilder: (context, index) {
                          return _buildStudentCard(_shortlistedStudents[index]);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStudentCard(Map<String, dynamic> student) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.successColor.withOpacity(0.3)),
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
                radius: 25,
                backgroundColor: AppTheme.successColor.withOpacity(0.1),
                child: Text(
                  student['name']?.substring(0, 1).toUpperCase() ?? 'S',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.successColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student['name'] ?? 'Unknown Student',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textPrimary,
                      ),
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.successColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border:
                      Border.all(color: AppTheme.successColor.withOpacity(0.3)),
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

          const SizedBox(height: 16),

          // Key Skills
          if (student['skills'] != null && student['skills'].isNotEmpty) ...[
            const Text(
              'Key Skills',
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
              children: (student['skills'] as List).take(4).map((skill) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppTheme.successColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    skill.toString(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppTheme.successColor,
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],

          // Student Stats
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  Icons.school,
                  'CGPA',
                  student['cgpa'] ?? 'N/A',
                  AppTheme.primaryColor,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  Icons.work_outline,
                  'Experience',
                  '${student['experience'] ?? '0'} years',
                  AppTheme.accentColor,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  Icons.code,
                  'Projects',
                  '${student['projects'] ?? 0}',
                  AppTheme.infoColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > 400) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ModernButton(
                            text: 'View Profile',
                            onPressed: () => _viewStudentProfile(student),
                            type: ModernButtonType.secondary,
                            icon: Icons.visibility,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ModernButton(
                            text: 'Schedule Interview',
                            onPressed: () => _scheduleInterview(student),
                            type: ModernButtonType.primary,
                            icon: Icons.calendar_today,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ModernButton(
                            text: 'Send Offer',
                            onPressed: () => _sendOffer(student),
                            type: ModernButtonType.outline,
                            icon: Icons.send,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ModernButton(
                            text: 'Remove',
                            onPressed: () => _removeFromShortlist(student),
                            type: ModernButtonType.outline,
                            icon: Icons.remove_circle_outline,
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ModernButton(
                        text: 'View Profile',
                        onPressed: () => _viewStudentProfile(student),
                        type: ModernButtonType.secondary,
                        icon: Icons.visibility,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ModernButton(
                        text: 'Schedule Interview',
                        onPressed: () => _scheduleInterview(student),
                        type: ModernButtonType.primary,
                        icon: Icons.calendar_today,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ModernButton(
                        text: 'Send Offer',
                        onPressed: () => _sendOffer(student),
                        type: ModernButtonType.outline,
                        icon: Icons.send,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ModernButton(
                        text: 'Remove',
                        onPressed: () => _removeFromShortlist(student),
                        type: ModernButtonType.outline,
                        icon: Icons.remove_circle_outline,
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

  Widget _buildInfoItem(
      IconData icon, String label, String value, Color color) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: color,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
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
            Icons.people_outline,
            size: 80,
            color: AppTheme.textTertiary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            'No Shortlisted Students',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Browse and shortlist students to see them here',
            style: TextStyle(
              fontSize: 14,
              color: AppTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 24),
          ModernButton(
            text: 'Explore Resumes',
            onPressed: () => context.push('/hire/explore-resumes'),
            type: ModernButtonType.primary,
            icon: Icons.assignment_ind,
          ),
        ],
      ),
    );
  }

  void _viewStudentProfile(Map<String, dynamic> student) {
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
                decoration: BoxDecoration(
                  color: AppTheme.successColor,
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(16)),
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
                            'Shortlisted Candidate',
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
                      _buildProfileSection('About',
                          student['about'] ?? 'No description available'),
                      _buildProfileSection('Education',
                          '${student['university'] ?? 'Unknown University'}\n${student['branch'] ?? 'Unknown Branch'}\nCGPA: ${student['cgpa'] ?? 'N/A'}'),
                      _buildProfileSection(
                          'Skills',
                          (student['skills'] as List?)?.join(', ') ??
                              'No skills listed'),
                      _buildProfileSection('Experience',
                          '${student['experience'] ?? '0'} years of experience'),
                      _buildProfileSection('Projects',
                          '${student['projects'] ?? 0} projects completed'),
                      _buildProfileSection('Contact',
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
                              text: 'Schedule Interview',
                              onPressed: () {
                                Navigator.of(context).pop();
                                _scheduleInterview(student);
                              },
                              type: ModernButtonType.primary,
                              icon: Icons.calendar_today,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ModernButton(
                              text: 'Send Offer',
                              onPressed: () {
                                Navigator.of(context).pop();
                                _sendOffer(student);
                              },
                              type: ModernButtonType.secondary,
                              icon: Icons.send,
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
                              text: 'Schedule Interview',
                              onPressed: () {
                                Navigator.of(context).pop();
                                _scheduleInterview(student);
                              },
                              type: ModernButtonType.primary,
                              icon: Icons.calendar_today,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ModernButton(
                              text: 'Send Offer',
                              onPressed: () {
                                Navigator.of(context).pop();
                                _sendOffer(student);
                              },
                              type: ModernButtonType.secondary,
                              icon: Icons.send,
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

  Widget _buildProfileSection(String title, String content) {
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

  void _scheduleInterview(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Schedule Interview - ${student['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Date'),
              trailing: Text(DateTime.now()
                  .add(const Duration(days: 3))
                  .toString()
                  .split(' ')[0]),
            ),
            ListTile(
              title: const Text('Time'),
              trailing: DropdownButton<String>(
                value: '10:00 AM',
                items: ['10:00 AM', '2:00 PM', '4:00 PM'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {},
              ),
            ),
            ListTile(
              title: const Text('Type'),
              trailing: DropdownButton<String>(
                value: 'Video Call',
                items: ['Video Call', 'In-Person', 'Phone'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {},
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Interview scheduled successfully!'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Schedule'),
          ),
        ],
      ),
    );
  }

  void _sendOffer(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Send Offer - ${student['name']}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Position',
                hintText: 'e.g., Software Engineer Intern',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Duration',
                hintText: 'e.g., 3 months',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Stipend',
                hintText: 'e.g., ₹25,000/month',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Additional Details',
                hintText: 'Any additional information...',
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
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Offer sent successfully!'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Send Offer'),
          ),
        ],
      ),
    );
  }

  void _removeFromShortlist(Map<String, dynamic> student) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove from Shortlist'),
        content: Text(
            'Are you sure you want to remove ${student['name']} from the shortlist?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                student['isShortlisted'] = false;
                _shortlistedStudents.remove(student);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Removed from shortlist'),
                  backgroundColor: AppTheme.warningColor,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warningColor,
            ),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  void _scheduleInterviews() {
    if (_shortlistedStudents.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Schedule Bulk Interviews'),
        content: Text(
            'Schedule interviews for ${_shortlistedStudents.length} shortlisted students?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Interviews scheduled for ${_shortlistedStudents.length} students'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Schedule All'),
          ),
        ],
      ),
    );
  }

  void _sendOffers() {
    if (_shortlistedStudents.isEmpty) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Send Bulk Offers'),
        content: Text(
            'Send offers to ${_shortlistedStudents.length} shortlisted students?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                      'Offers sent to ${_shortlistedStudents.length} students'),
                  backgroundColor: AppTheme.successColor,
                ),
              );
            },
            child: const Text('Send All'),
          ),
        ],
      ),
    );
  }

  void _showBulkActions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Bulk Actions',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Schedule All Interviews'),
              onTap: () {
                Navigator.of(context).pop();
                _scheduleInterviews();
              },
            ),
            ListTile(
              leading: const Icon(Icons.send),
              title: const Text('Send All Offers'),
              onTap: () {
                Navigator.of(context).pop();
                _sendOffers();
              },
            ),
            ListTile(
              leading: const Icon(Icons.download),
              title: const Text('Export List'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('List exported successfully'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
