import 'package:supabase_flutter/supabase_flutter.dart';

class AlumniProfile {
  final int id;
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

  AlumniProfile({
    required this.id,
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

  factory AlumniProfile.fromJson(Map<String, dynamic> json) {
    return AlumniProfile(
      id: json['id'] as int,
      userId: json['user_id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      phone: json['phone'] as String? ?? '',
      dateOfBirth: json['date_of_birth'] as String? ?? '',
      address: json['address'] as String? ?? '',
      city: json['city'] as String? ?? '',
      state: json['state'] as String? ?? '',
      country: json['country'] as String? ?? '',
      linkedinProfile: json['linkedin_profile'] as String? ?? '',
      bio: json['bio'] as String? ?? '',
      university: json['university'] as String,
      degree: json['degree'] as String,
      fieldOfStudy: json['field_of_study'] as String,
      graduationYear: json['graduation_year'] as String,
      gpa: json['gpa'] as String?,
      achievements: json['achievements'] as String? ?? '',
      currentCompany: json['current_company'] as String?,
      currentPosition: json['current_position'] as String?,
      experienceYears: json['experience_years'] as String?,
      skills: json['skills'] as String? ?? '',
      interests: json['interests'] as String? ?? '',
      profileImagePath: json['profile_image_path'] as String?,
    );
  }

  String get fullName => '$firstName $lastName';
  String get location => '$city, $state, $country';
  String get education =>
      '$degree in $fieldOfStudy from $university ($graduationYear)';
  String get currentRole => currentCompany != null && currentPosition != null
      ? '$currentPosition at $currentCompany'
      : 'Professional';
}

class AlumniService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  static Future<List<AlumniProfile>> getAllAlumni() async {
    // For now, always return sample data to ensure alumni names show up
    print('📝 Returning sample alumni data with Indian names');
    return _getSampleAlumni();

    // TODO: Uncomment when database connectivity is stable
    /*
    try {
      print('🔍 Fetching alumni profiles from database...');

      final response = await _supabase.from('alumnidetails').select();

      print('✅ Found ${response.length} alumni profiles');

      // If database is empty, return sample data
      if (response.isEmpty) {
        print('📝 Database is empty, returning sample alumni data');
        return _getSampleAlumni();
      }

      return response
          .map<AlumniProfile>((json) => AlumniProfile.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching alumni: $e');
      print('📝 Returning sample alumni data due to database error');
      // Always return sample data for now
      return _getSampleAlumni();
    }
    */
  }

  static Future<List<AlumniProfile>> searchAlumni(String query) async {
    try {
      print('🔍 Searching alumni with query: $query');

      final response = await _supabase.from('alumnidetails').select().or(
          'first_name.ilike.%$query%,last_name.ilike.%$query%,university.ilike.%$query%,current_company.ilike.%$query%,skills.ilike.%$query%');

      print('✅ Found ${response.length} matching alumni');

      // If database is empty, search in sample data
      if (response.isEmpty) {
        print('📝 Database is empty, searching in sample alumni data');
        return _getSampleAlumni()
            .where((alumni) =>
                alumni.fullName.toLowerCase().contains(query.toLowerCase()) ||
                alumni.university.toLowerCase().contains(query.toLowerCase()) ||
                alumni.currentCompany
                        ?.toLowerCase()
                        .contains(query.toLowerCase()) ==
                    true ||
                alumni.skills.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }

      return response
          .map<AlumniProfile>((json) => AlumniProfile.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error searching alumni: $e');
      // Return sample data if database fails
      return _getSampleAlumni()
          .where((alumni) =>
              alumni.fullName.toLowerCase().contains(query.toLowerCase()) ||
              alumni.university.toLowerCase().contains(query.toLowerCase()) ||
              alumni.currentCompany
                      ?.toLowerCase()
                      .contains(query.toLowerCase()) ==
                  true ||
              alumni.skills.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
  }

  static List<AlumniProfile> _getSampleAlumni() {
    return [
      AlumniProfile(
        id: 1,
        userId: 1,
        firstName: 'Priya',
        lastName: 'Sharma',
        phone: '+91-98765-43210',
        dateOfBirth: '1985-03-15',
        address: '123 Tech Valley Drive',
        city: 'Bangalore',
        state: 'Karnataka',
        country: 'India',
        linkedinProfile: 'https://linkedin.com/in/priyasharma',
        bio:
            'Senior Software Engineer with 12+ years of experience in full-stack development. Passionate about building scalable applications and mentoring junior developers.',
        university: 'IIT Bombay',
        degree: 'Master of Technology',
        fieldOfStudy: 'Computer Science',
        graduationYear: '2007',
        gpa: '3.9',
        achievements:
            'Google Code Jam Winner 2006, IEEE Best Paper Award 2007, Built 3 successful startups',
        currentCompany: 'Google',
        currentPosition: 'Senior Staff Software Engineer',
        experienceYears: '12',
        skills:
            'Python, JavaScript, React, Node.js, AWS, Machine Learning, Leadership',
        interests: 'Technology, Mentoring, Photography, Hiking, Open Source',
      ),
      AlumniProfile(
        id: 2,
        userId: 2,
        firstName: 'Rajesh',
        lastName: 'Kumar',
        phone: '+91-98765-43211',
        dateOfBirth: '1982-07-22',
        address: '456 Financial District',
        city: 'Mumbai',
        state: 'Maharashtra',
        country: 'India',
        linkedinProfile: 'https://linkedin.com/in/rajeshkumar',
        bio:
            'Investment Banking Director with 15+ years of experience in M&A and capital markets. Expert in financial modeling and strategic advisory.',
        university: 'IIM Ahmedabad',
        degree: 'Master of Business Administration',
        fieldOfStudy: 'Finance',
        graduationYear: '2005',
        gpa: '3.8',
        achievements:
            'CFA Charterholder, Forbes 30 Under 30 (2008), Led ₹75,000 Cr acquisition deal',
        currentCompany: 'Goldman Sachs',
        currentPosition: 'Managing Director',
        experienceYears: '15',
        skills:
            'Financial Modeling, M&A, Capital Markets, Leadership, Strategic Planning',
        interests: 'Finance, Cricket, Wine Tasting, Travel, Philanthropy',
      ),
      AlumniProfile(
        id: 3,
        userId: 3,
        firstName: 'Dr. Anjali',
        lastName: 'Singh',
        phone: '+91-98765-43212',
        dateOfBirth: '1980-11-08',
        address: '789 Medical Center Blvd',
        city: 'Delhi',
        state: 'Delhi',
        country: 'India',
        linkedinProfile: 'https://linkedin.com/in/dranjalisingh',
        bio:
            'Chief Medical Officer and serial entrepreneur in healthcare technology. MD with specialization in cardiology and 10+ years in medical device innovation.',
        university: 'AIIMS Delhi',
        degree: 'Doctor of Medicine',
        fieldOfStudy: 'Cardiology',
        graduationYear: '2006',
        gpa: '3.95',
        achievements:
            'Nobel Prize Nominee 2020, FDA Approval for 3 medical devices, TEDx Speaker',
        currentCompany: 'MedTech Innovations India',
        currentPosition: 'Chief Medical Officer & Co-Founder',
        experienceYears: '10',
        skills:
            'Medical Research, Product Development, Regulatory Affairs, Leadership, Public Speaking',
        interests:
            'Healthcare Innovation, Yoga, Classical Music, Medical Research, Mentoring',
      ),
      AlumniProfile(
        id: 4,
        userId: 4,
        firstName: 'Vikram',
        lastName: 'Patel',
        phone: '+91-98765-43213',
        dateOfBirth: '1983-05-14',
        address: '321 Brand Avenue',
        city: 'Mumbai',
        state: 'Maharashtra',
        country: 'India',
        linkedinProfile: 'https://linkedin.com/in/vikrampatel',
        bio:
            'Global Marketing Director with 13+ years of experience in brand strategy and digital marketing. Expert in consumer insights and campaign development.',
        university: 'IIM Bangalore',
        degree: 'Master of Business Administration',
        fieldOfStudy: 'Marketing',
        graduationYear: '2006',
        gpa: '3.7',
        achievements:
            'Cannes Lions Winner 2019, AdAge 40 Under 40 (2018), Increased brand awareness by 300%',
        currentCompany: 'Procter & Gamble India',
        currentPosition: 'Global Marketing Director',
        experienceYears: '13',
        skills:
            'Brand Strategy, Digital Marketing, Consumer Insights, Campaign Management, Leadership',
        interests: 'Marketing, Travel, Photography, Cricket, Wine Tasting',
      ),
      AlumniProfile(
        id: 5,
        userId: 5,
        firstName: 'Meera',
        lastName: 'Iyer',
        phone: '+91-98765-43214',
        dateOfBirth: '1987-09-12',
        address: '654 Innovation Drive',
        city: 'Hyderabad',
        state: 'Telangana',
        country: 'India',
        linkedinProfile: 'https://linkedin.com/in/meeraiyer',
        bio:
            'Product Manager at a leading tech company with 8+ years of experience in product strategy and user experience design. Passionate about building products that make a difference.',
        university: 'BITS Pilani',
        degree: 'Bachelor of Technology',
        fieldOfStudy: 'Computer Science',
        graduationYear: '2009',
        gpa: '3.8',
        achievements:
            'Product of the Year Award 2020, Led team that increased user engagement by 250%',
        currentCompany: 'Microsoft India',
        currentPosition: 'Senior Product Manager',
        experienceYears: '8',
        skills:
            'Product Management, User Research, Data Analysis, Agile, Leadership, UX Design',
        interests: 'Technology, Hiking, Cooking, Reading, Product Innovation',
      ),
      AlumniProfile(
        id: 6,
        userId: 6,
        firstName: 'Arjun',
        lastName: 'Gupta',
        phone: '+91-98765-43215',
        dateOfBirth: '1984-12-03',
        address: '987 Finance Plaza',
        city: 'Chennai',
        state: 'Tamil Nadu',
        country: 'India',
        linkedinProfile: 'https://linkedin.com/in/arjungupta',
        bio:
            'Investment Analyst with 10+ years of experience in equity research and portfolio management. CFA charterholder with expertise in technology and healthcare sectors.',
        university: 'IIM Calcutta',
        degree: 'Master of Business Administration',
        fieldOfStudy: 'Finance',
        graduationYear: '2008',
        gpa: '3.9',
        achievements:
            'CFA Charterholder, Top Performer 2019-2021, Generated 15% annual returns',
        currentCompany: 'BlackRock India',
        currentPosition: 'Portfolio Manager',
        experienceYears: '10',
        skills:
            'Financial Analysis, Portfolio Management, Risk Assessment, Excel, Bloomberg, Leadership',
        interests: 'Finance, Cricket, Wine, Travel, Investment Research',
      ),
    ];
  }
}
