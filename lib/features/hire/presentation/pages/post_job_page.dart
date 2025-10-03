import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';
import 'package:connectu_alumni_platform/core/widgets/modern_button.dart';
import 'package:connectu_alumni_platform/features/hire/data/services/job_posting_service.dart';

class PostJobPage extends StatefulWidget {
  const PostJobPage({super.key});

  @override
  State<PostJobPage> createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _companyController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _requirementsController = TextEditingController();
  final _benefitsController = TextEditingController();
  final _salaryController = TextEditingController();
  final _applicationDeadlineController = TextEditingController();

  final JobPostingService _jobPostingService = JobPostingService();

  String _selectedJobType = 'Full-time';
  String _selectedCategory = 'Technology';
  String _selectedLocation = 'Mumbai';
  String _selectedExperience = '0-1 years';
  bool _isRemote = false;
  bool _isLoading = false;

  final List<String> _jobTypes = [
    'Full-time',
    'Part-time',
    'Internship',
    'Contract',
    'Freelance',
  ];

  final List<String> _categories = [
    'Technology',
    'Finance',
    'Healthcare',
    'Education',
    'Consulting',
    'Marketing',
    'Sales',
    'Design',
    'Operations',
    'Other',
  ];

  final List<String> _locations = [
    'Mumbai',
    'Delhi',
    'Bangalore',
    'Pune',
    'Hyderabad',
    'Chennai',
    'Kolkata',
    'Ahmedabad',
    'Remote',
    'Other',
  ];

  final List<String> _experienceLevels = [
    '0-1 years',
    '1-2 years',
    '2-3 years',
    '3-5 years',
    '5+ years',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _companyController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    _benefitsController.dispose();
    _salaryController.dispose();
    _applicationDeadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        title: const Text(
          'Post Job',
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
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Job Posting',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Reach talented students and alumni with your opportunities',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Job Details Section
              _buildSectionTitle('Job Details'),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _titleController,
                label: 'Job Title *',
                hint: 'e.g., Software Engineer Intern',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter job title';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _companyController,
                label: 'Company Name *',
                hint: 'Your company name',
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter company name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: 'Job Type *',
                value: _selectedJobType,
                items: _jobTypes,
                onChanged: (value) {
                  setState(() {
                    _selectedJobType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: 'Category *',
                value: _selectedCategory,
                items: _categories,
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _descriptionController,
                label: 'Job Description *',
                hint:
                    'Describe the role, responsibilities, and what the candidate will do...',
                maxLines: 4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter job description';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _requirementsController,
                label: 'Requirements',
                hint: 'Skills, qualifications, and experience required...',
                maxLines: 3,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _benefitsController,
                label: 'Benefits & Perks',
                hint: 'What you offer to candidates...',
                maxLines: 2,
              ),

              const SizedBox(height: 24),

              // Compensation & Details Section
              _buildSectionTitle('Compensation & Details'),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _salaryController,
                label: 'Salary/Stipend',
                hint:
                    'e.g., ₹25,000 - ₹35,000/month or ₹3,00,000 - ₹5,00,000/year',
                keyboardType: TextInputType.text,
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: 'Experience Level',
                value: _selectedExperience,
                items: _experienceLevels,
                onChanged: (value) {
                  setState(() {
                    _selectedExperience = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              _buildDropdown(
                label: 'Location *',
                value: _selectedLocation,
                items: _locations,
                onChanged: (value) {
                  setState(() {
                    _selectedLocation = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              SwitchListTile(
                title: const Text('Remote Work Available'),
                subtitle: const Text('Allow candidates to work remotely'),
                value: _isRemote,
                onChanged: (value) {
                  setState(() {
                    _isRemote = value;
                  });
                },
                activeColor: AppTheme.primaryColor,
              ),
              const SizedBox(height: 16),

              _buildTextField(
                controller: _applicationDeadlineController,
                label: 'Application Deadline',
                hint: 'YYYY-MM-DD (optional)',
                keyboardType: TextInputType.datetime,
                onTap: () => _selectDate(),
                readOnly: true,
              ),

              const SizedBox(height: 32),

              // Submit and Preview Buttons
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 400) {
                    return Row(
                      children: [
                        Expanded(
                          child: ModernButton(
                            text: _isLoading ? 'Posting Job...' : 'Post Job',
                            onPressed: _isLoading ? null : _postJob,
                            type: ModernButtonType.primary,
                            icon: Icons.send,
                            size: ModernButtonSize.large,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ModernButton(
                            text: 'Preview Job Post',
                            onPressed: _previewJob,
                            type: ModernButtonType.outline,
                            icon: Icons.visibility,
                            size: ModernButtonSize.large,
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
                            text: _isLoading ? 'Posting Job...' : 'Post Job',
                            onPressed: _isLoading ? null : _postJob,
                            type: ModernButtonType.primary,
                            icon: Icons.send,
                            size: ModernButtonSize.large,
                          ),
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ModernButton(
                            text: 'Preview Job Post',
                            onPressed: _previewJob,
                            type: ModernButtonType.outline,
                            icon: Icons.visibility,
                            size: ModernButtonSize.large,
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: AppTheme.textPrimary,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    VoidCallback? onTap,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      validator: validator,
      onTap: onTap,
      readOnly: readOnly,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.textSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppTheme.textSecondary),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 30)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      _applicationDeadlineController.text =
          "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
    }
  }

  void _postJob() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final jobData = {
        'title': _titleController.text,
        'company': _companyController.text,
        'description': _descriptionController.text,
        'requirements': _requirementsController.text,
        'benefits': _benefitsController.text,
        'salary': _salaryController.text,
        'jobType': _selectedJobType,
        'category': _selectedCategory,
        'location': _selectedLocation,
        'experience': _selectedExperience,
        'isRemote': _isRemote,
        'applicationDeadline': _applicationDeadlineController.text.isNotEmpty
            ? _applicationDeadlineController.text
            : null,
        'postedBy': 'Current User', // This should come from auth
        'postedAt': DateTime.now().toIso8601String(),
      };

      await _jobPostingService.postJob(jobData);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Job posted successfully!'),
          backgroundColor: AppTheme.successColor,
        ),
      );

      // Clear form
      _formKey.currentState!.reset();
      _titleController.clear();
      _companyController.clear();
      _descriptionController.clear();
      _requirementsController.clear();
      _benefitsController.clear();
      _salaryController.clear();
      _applicationDeadlineController.clear();

      setState(() {
        _selectedJobType = 'Full-time';
        _selectedCategory = 'Technology';
        _selectedLocation = 'Mumbai';
        _selectedExperience = '0-1 years';
        _isRemote = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error posting job: $e'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _previewJob() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

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
                    const Icon(Icons.work, color: Colors.white, size: 24),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Text(
                        'Job Post Preview',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
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
                      // Job Title and Company
                      Text(
                        _titleController.text,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _companyController.text,
                        style: TextStyle(
                          fontSize: 18,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Job Details
                      _buildPreviewItem('Job Type', _selectedJobType),
                      _buildPreviewItem('Category', _selectedCategory),
                      _buildPreviewItem('Location', _selectedLocation),
                      _buildPreviewItem('Experience', _selectedExperience),
                      _buildPreviewItem(
                          'Remote Work', _isRemote ? 'Yes' : 'No'),
                      if (_salaryController.text.isNotEmpty)
                        _buildPreviewItem('Salary', _salaryController.text),
                      if (_applicationDeadlineController.text.isNotEmpty)
                        _buildPreviewItem(
                            'Deadline', _applicationDeadlineController.text),

                      const SizedBox(height: 20),

                      // Description
                      const Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _descriptionController.text,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                      ),

                      if (_requirementsController.text.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Text(
                          'Requirements',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _requirementsController.text,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],

                      if (_benefitsController.text.isNotEmpty) ...[
                        const SizedBox(height: 20),
                        const Text(
                          'Benefits & Perks',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _benefitsController.text,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppTheme.textSecondary,
                            height: 1.4,
                          ),
                        ),
                      ],
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
                              text: 'Edit',
                              onPressed: () => Navigator.of(context).pop(),
                              type: ModernButtonType.outline,
                              icon: Icons.edit,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ModernButton(
                              text: 'Post Job',
                              onPressed: () {
                                Navigator.of(context).pop();
                                _postJob();
                              },
                              type: ModernButtonType.primary,
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
                              text: 'Edit',
                              onPressed: () => Navigator.of(context).pop(),
                              type: ModernButtonType.outline,
                              icon: Icons.edit,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: double.infinity,
                            child: ModernButton(
                              text: 'Post Job',
                              onPressed: () {
                                Navigator.of(context).pop();
                                _postJob();
                              },
                              type: ModernButtonType.primary,
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

  Widget _buildPreviewItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
