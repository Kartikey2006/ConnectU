import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart';
import 'package:connectu_alumni_platform/core/models/alumni_profile.dart';
import 'package:connectu_alumni_platform/features/auth/data/services/profile_service.dart';
import 'dart:io';

class AlumniProfileCompletionPage extends StatefulWidget {
  const AlumniProfileCompletionPage({super.key});

  @override
  State<AlumniProfileCompletionPage> createState() =>
      _AlumniProfileCompletionPageState();
}

class _AlumniProfileCompletionPageState
    extends State<AlumniProfileCompletionPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  XFile? _profileImage;

  // Controllers for personal information
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _linkedinController = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  // Controllers for education information
  final TextEditingController _universityController = TextEditingController();
  final TextEditingController _degreeController = TextEditingController();
  final TextEditingController _fieldOfStudyController = TextEditingController();
  final TextEditingController _graduationYearController =
      TextEditingController();
  final TextEditingController _gpaController = TextEditingController();
  final TextEditingController _achievementsController = TextEditingController();

  // Controllers for professional information
  final TextEditingController _currentCompanyController =
      TextEditingController();
  final TextEditingController _currentPositionController =
      TextEditingController();
  final TextEditingController _experienceYearsController =
      TextEditingController();
  final TextEditingController _skillsController = TextEditingController();
  final TextEditingController _interestsController = TextEditingController();

  @override
  void dispose() {
    _pageController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _dateOfBirthController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    _linkedinController.dispose();
    _bioController.dispose();
    _universityController.dispose();
    _degreeController.dispose();
    _fieldOfStudyController.dispose();
    _graduationYearController.dispose();
    _gpaController.dispose();
    _achievementsController.dispose();
    _currentCompanyController.dispose();
    _currentPositionController.dispose();
    _experienceYearsController.dispose();
    _skillsController.dispose();
    _interestsController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < 2) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = image;
      });
    }
  }

  Future<void> _completeProfile() async {
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Get current user ID
      final authState = context.read<AuthBloc>().state;
      if (authState is! Authenticated) {
        throw Exception('User not authenticated');
      }

      final userId = authState.user.user.id;
      print('🔍 User ID for profile completion: $userId');

      if (userId == 0) {
        throw Exception('Invalid user ID');
      }

      // Create alumni profile
      final profile = AlumniProfile(
        userId: userId,
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        phone: _phoneController.text,
        dateOfBirth: _dateOfBirthController.text,
        address: _addressController.text,
        city: _cityController.text,
        state: _stateController.text,
        country: _countryController.text,
        linkedinProfile: _linkedinController.text,
        bio: _bioController.text,
        university: _universityController.text,
        degree: _degreeController.text,
        fieldOfStudy: _fieldOfStudyController.text,
        graduationYear: _graduationYearController.text,
        gpa: _gpaController.text,
        achievements: _achievementsController.text,
        currentCompany: _currentCompanyController.text,
        currentPosition: _currentPositionController.text,
        experienceYears: _experienceYearsController.text,
        skills: _skillsController.text,
        interests: _interestsController.text,
        profileImagePath: _profileImage?.path,
      );

      // Save profile
      await ProfileService.saveAlumniProfile(profile);

      // Dismiss loading dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile completed successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Mark profile as completed in local storage (temporary fix)
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('profile_completed_$userId', true);

      // Dispatch profile completed event
      context.read<AuthBloc>().add(ProfileCompleted());

      // Navigate to alumni dashboard
      context.go('/alumni-dashboard');
    } catch (e) {
      // Dismiss loading dialog
      Navigator.of(context).pop();

      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error completing profile: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      print('❌ Error completing profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complete Your Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: (_currentPage + 1) / 3,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).colorScheme.primary,
            ),
          ),
          const SizedBox(height: 20),

          // Page content
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: [
                _buildPersonalInfoPage(),
                _buildEducationInfoPage(),
                _buildProfessionalInfoPage(),
              ],
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (_currentPage > 0)
                  OutlinedButton(
                    onPressed: _previousPage,
                    child: const Text('Previous'),
                  ),
                if (_currentPage > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _currentPage == 2 ? _completeProfile : _nextPage,
                    child:
                        Text(_currentPage == 2 ? 'Complete Profile' : 'Next'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile picture section
          Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    child: _profileImage != null
                        ? ClipOval(
                            child: Image.file(
                              File(_profileImage!.path),
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.person,
                            size: 60,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Tap to add profile picture',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Personal Information
          Text(
            'Personal Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),

          // Name fields
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstNameController,
                  decoration: const InputDecoration(
                    labelText: 'First Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _lastNameController,
                  decoration: const InputDecoration(
                    labelText: 'Last Name',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Phone
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 16),

          // Date of Birth
          TextFormField(
            controller: _dateOfBirthController,
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              border: OutlineInputBorder(),
              suffixIcon: Icon(Icons.calendar_today),
            ),
            readOnly: true,
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now()
                    .subtract(const Duration(days: 6570)), // 18 years ago
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
              );
              if (picked != null) {
                _dateOfBirthController.text =
                    '${picked.day}/${picked.month}/${picked.year}';
              }
            },
          ),
          const SizedBox(height: 16),

          // Address
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Address',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),

          // City, State, Country
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _stateController,
                  decoration: const InputDecoration(
                    labelText: 'State',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Country
          TextFormField(
            controller: _countryController,
            decoration: const InputDecoration(
              labelText: 'Country',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // LinkedIn
          TextFormField(
            controller: _linkedinController,
            decoration: const InputDecoration(
              labelText: 'LinkedIn Profile',
              border: OutlineInputBorder(),
              prefixText: 'https://linkedin.com/in/',
            ),
          ),
          const SizedBox(height: 16),

          // Bio
          TextFormField(
            controller: _bioController,
            decoration: const InputDecoration(
              labelText: 'Bio',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildEducationInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Education Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),

          // University
          TextFormField(
            controller: _universityController,
            decoration: const InputDecoration(
              labelText: 'University/College',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Degree and Field of Study
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _degreeController,
                  decoration: const InputDecoration(
                    labelText: 'Degree',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _fieldOfStudyController,
                  decoration: const InputDecoration(
                    labelText: 'Field of Study',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Graduation Year and GPA
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _graduationYearController,
                  decoration: const InputDecoration(
                    labelText: 'Graduation Year',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _gpaController,
                  decoration: const InputDecoration(
                    labelText: 'GPA',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Achievements
          TextFormField(
            controller: _achievementsController,
            decoration: const InputDecoration(
              labelText: 'Achievements & Awards',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildProfessionalInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Professional Information',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 16),

          // Current Company
          TextFormField(
            controller: _currentCompanyController,
            decoration: const InputDecoration(
              labelText: 'Current Company',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Current Position
          TextFormField(
            controller: _currentPositionController,
            decoration: const InputDecoration(
              labelText: 'Current Position',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),

          // Experience Years
          TextFormField(
            controller: _experienceYearsController,
            decoration: const InputDecoration(
              labelText: 'Years of Experience',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),

          // Skills
          TextFormField(
            controller: _skillsController,
            decoration: const InputDecoration(
              labelText: 'Skills',
              border: OutlineInputBorder(),
              hintText: 'e.g., Flutter, React, Python, Leadership',
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),

          // Interests
          TextFormField(
            controller: _interestsController,
            decoration: const InputDecoration(
              labelText: 'Interests',
              border: OutlineInputBorder(),
              hintText: 'e.g., Technology, Sports, Music, Travel',
            ),
            maxLines: 2,
          ),
        ],
      ),
    );
  }
}
