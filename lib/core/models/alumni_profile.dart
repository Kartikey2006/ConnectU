class AlumniProfile {
  final int userId;
  final String firstName;
  final String lastName;
  final String phone;
  final String dateOfBirth;
  final String address;
  final String city;
  final String state;
  final String country;
  final String linkedinProfile;
  final String bio;
  final String university;
  final String degree;
  final String fieldOfStudy;
  final String graduationYear;
  final String? gpa;
  final String achievements;
  final String? currentCompany;
  final String? currentPosition;
  final String? experienceYears;
  final String skills;
  final String interests;
  final String? profileImagePath;

  const AlumniProfile({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.dateOfBirth,
    required this.address,
    required this.city,
    required this.state,
    required this.country,
    required this.linkedinProfile,
    required this.bio,
    required this.university,
    required this.degree,
    required this.fieldOfStudy,
    required this.graduationYear,
    this.gpa,
    required this.achievements,
    this.currentCompany,
    this.currentPosition,
    this.experienceYears,
    required this.skills,
    required this.interests,
    this.profileImagePath,
  });

  // Getters for computed properties
  int get id => userId; // Use userId as id for compatibility
  String get fullName => '$firstName $lastName';
  String get currentRole => currentPosition ?? 'Software Engineer';
  String get location => '$city, $state, $country';

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'first_name': firstName,
      'last_name': lastName,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'linkedin_profile': linkedinProfile,
      'bio': bio,
      'university': university,
      'degree': degree,
      'field_of_study': fieldOfStudy,
      'graduation_year': graduationYear,
      'gpa': gpa,
      'achievements': achievements,
      'current_company': currentCompany,
      'current_position': currentPosition,
      'experience_years': experienceYears,
      'skills': skills,
      'interests': interests,
      'profile_image_path': profileImagePath,
    };
  }

  factory AlumniProfile.fromJson(Map<String, dynamic> json) {
    return AlumniProfile(
      userId: json['user_id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phone: json['phone'] as String,
      dateOfBirth: json['date_of_birth'] as String,
      address: json['address'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      country: json['country'] as String,
      linkedinProfile: json['linkedin_profile'] as String,
      bio: json['bio'] as String,
      university: json['university'] as String,
      degree: json['degree'] as String,
      fieldOfStudy: json['field_of_study'] as String,
      graduationYear: json['graduation_year'] as String,
      gpa: json['gpa'] as String?,
      achievements: json['achievements'] as String,
      currentCompany: json['current_company'] as String?,
      currentPosition: json['current_position'] as String?,
      experienceYears: json['experience_years'] as String?,
      skills: json['skills'] as String,
      interests: json['interests'] as String,
      profileImagePath: json['profile_image_path'] as String?,
    );
  }
}
