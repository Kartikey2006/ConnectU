// import 'package:supabase_flutter/supabase_flutter.dart'; // Will be used in production

class StudentProfilesService {
  // final SupabaseClient _supabase = Supabase.instance.client; // Will be used in production

  // Get all student profiles
  Future<List<Map<String, dynamic>>> getAllStudentProfiles() async {
    try {
      print('🔍 Fetching student profiles...');

      // For demo purposes, return sample data
      // In production, this would fetch from Supabase
      return _getSampleStudentProfiles();
    } catch (e) {
      print('❌ Error fetching student profiles: $e');
      // Return sample data as fallback
      return _getSampleStudentProfiles();
    }
  }

  // Toggle shortlist status
  Future<void> toggleShortlist(String studentId) async {
    try {
      print('🔄 Toggling shortlist for student: $studentId');

      // For demo purposes, simulate the operation
      await Future.delayed(const Duration(milliseconds: 500));

      print('✅ Shortlist status updated');
    } catch (e) {
      print('❌ Error updating shortlist: $e');
      throw Exception('Failed to update shortlist status');
    }
  }

  // Get shortlisted students
  Future<List<Map<String, dynamic>>> getShortlistedStudents() async {
    try {
      print('🔍 Fetching shortlisted students...');

      final allStudents = await getAllStudentProfiles();
      return allStudents
          .where((student) => student['isShortlisted'] == true)
          .toList();
    } catch (e) {
      print('❌ Error fetching shortlisted students: $e');
      return [];
    }
  }

  // Get student profile by ID
  Future<Map<String, dynamic>?> getStudentProfile(String studentId) async {
    try {
      print('🔍 Fetching student profile: $studentId');

      final allStudents = await getAllStudentProfiles();
      return allStudents.firstWhere(
        (student) => student['id'] == studentId,
        orElse: () => <String, dynamic>{},
      );
    } catch (e) {
      print('❌ Error fetching student profile: $e');
      return null;
    }
  }

  // Sample student profiles data
  List<Map<String, dynamic>> _getSampleStudentProfiles() {
    return [
      {
        'id': '1',
        'name': 'Rajesh Kumar',
        'email': 'rajesh.kumar@student.edu',
        'phone': '+91 98765 43210',
        'university': 'IIT Delhi',
        'branch': 'Computer Science',
        'year': '2024',
        'cgpa': '8.5',
        'experience': '1',
        'projects': 5,
        'skills': [
          'Flutter',
          'Dart',
          'Firebase',
          'React',
          'JavaScript',
          'Python'
        ],
        'about':
            'Passionate about mobile app development with experience in Flutter and React Native. Strong problem-solving skills and eager to learn new technologies.',
        'isShortlisted': false,
        'createdAt': DateTime.now().subtract(const Duration(days: 30)),
      },
      {
        'id': '2',
        'name': 'Priya Sharma',
        'email': 'priya.sharma@student.edu',
        'phone': '+91 98765 43211',
        'university': 'IIM Bangalore',
        'branch': 'Business Administration',
        'year': '2024',
        'cgpa': '9.2',
        'experience': '2',
        'projects': 8,
        'skills': [
          'Marketing',
          'Data Analysis',
          'Python',
          'Excel',
          'Power BI',
          'Leadership'
        ],
        'about':
            'Marketing enthusiast with strong analytical skills. Led multiple marketing campaigns and has experience in data-driven decision making.',
        'isShortlisted': true,
        'createdAt': DateTime.now().subtract(const Duration(days: 25)),
      },
      {
        'id': '3',
        'name': 'Arjun Singh',
        'email': 'arjun.singh@student.edu',
        'phone': '+91 98765 43212',
        'university': 'NIT Trichy',
        'branch': 'Electronics',
        'year': '2025',
        'cgpa': '8.8',
        'experience': '0',
        'projects': 3,
        'skills': [
          'Embedded Systems',
          'C++',
          'Arduino',
          'IoT',
          'Python',
          'MATLAB'
        ],
        'about':
            'Electronics engineering student passionate about embedded systems and IoT. Strong foundation in programming and hardware design.',
        'isShortlisted': false,
        'createdAt': DateTime.now().subtract(const Duration(days: 20)),
      },
      {
        'id': '4',
        'name': 'Sneha Patel',
        'email': 'sneha.patel@student.edu',
        'phone': '+91 98765 43213',
        'university': 'BITS Pilani',
        'branch': 'Computer Science',
        'year': '2024',
        'cgpa': '9.0',
        'experience': '1',
        'projects': 6,
        'skills': [
          'Machine Learning',
          'Python',
          'TensorFlow',
          'Data Science',
          'SQL',
          'Java'
        ],
        'about':
            'Machine learning enthusiast with hands-on experience in building predictive models. Strong background in mathematics and statistics.',
        'isShortlisted': true,
        'createdAt': DateTime.now().subtract(const Duration(days: 18)),
      },
      {
        'id': '5',
        'name': 'Vikram Reddy',
        'email': 'vikram.reddy@student.edu',
        'phone': '+91 98765 43214',
        'university': 'VIT Vellore',
        'branch': 'Mechanical',
        'year': '2025',
        'cgpa': '8.2',
        'experience': '0',
        'projects': 4,
        'skills': [
          'CAD',
          'SolidWorks',
          'AutoCAD',
          'MATLAB',
          'Project Management',
          'Team Leadership'
        ],
        'about':
            'Mechanical engineering student with expertise in CAD design and project management. Strong leadership skills and attention to detail.',
        'isShortlisted': false,
        'createdAt': DateTime.now().subtract(const Duration(days: 15)),
      },
      {
        'id': '6',
        'name': 'Ananya Gupta',
        'email': 'ananya.gupta@student.edu',
        'phone': '+91 98765 43215',
        'university': 'DU Delhi',
        'branch': 'Design',
        'year': '2024',
        'cgpa': '8.7',
        'experience': '2',
        'projects': 7,
        'skills': [
          'UI/UX Design',
          'Figma',
          'Adobe Creative Suite',
          'Prototyping',
          'User Research',
          'Web Design'
        ],
        'about':
            'Creative designer with expertise in UI/UX design. Strong portfolio showcasing modern and user-friendly designs across various platforms.',
        'isShortlisted': true,
        'createdAt': DateTime.now().subtract(const Duration(days: 12)),
      },
      {
        'id': '7',
        'name': 'Rohit Agarwal',
        'email': 'rohit.agarwal@student.edu',
        'phone': '+91 98765 43216',
        'university': 'IIIT Hyderabad',
        'branch': 'Computer Science',
        'year': '2025',
        'cgpa': '9.1',
        'experience': '1',
        'projects': 5,
        'skills': [
          'Web Development',
          'React',
          'Node.js',
          'MongoDB',
          'JavaScript',
          'TypeScript'
        ],
        'about':
            'Full-stack developer with experience in modern web technologies. Passionate about building scalable and efficient web applications.',
        'isShortlisted': false,
        'createdAt': DateTime.now().subtract(const Duration(days: 10)),
      },
      {
        'id': '8',
        'name': 'Kavya Nair',
        'email': 'kavya.nair@student.edu',
        'phone': '+91 98765 43217',
        'university': 'NIT Surathkal',
        'branch': 'Civil',
        'year': '2024',
        'cgpa': '8.6',
        'experience': '1',
        'projects': 4,
        'skills': [
          'AutoCAD',
          'STAAD Pro',
          'Project Planning',
          'Quality Control',
          'Team Management',
          'Communication'
        ],
        'about':
            'Civil engineering student with strong technical skills and project management experience. Excellent communication and leadership abilities.',
        'isShortlisted': false,
        'createdAt': DateTime.now().subtract(const Duration(days: 8)),
      },
      {
        'id': '9',
        'name': 'Manish Kumar',
        'email': 'manish.kumar@student.edu',
        'phone': '+91 98765 43218',
        'university': 'IIT Kanpur',
        'branch': 'Computer Science',
        'year': '2025',
        'cgpa': '8.9',
        'experience': '0',
        'projects': 6,
        'skills': [
          'Competitive Programming',
          'C++',
          'Java',
          'Algorithms',
          'Data Structures',
          'Problem Solving'
        ],
        'about':
            'Competitive programmer with strong algorithmic thinking. Participated in various coding contests and has a passion for solving complex problems.',
        'isShortlisted': true,
        'createdAt': DateTime.now().subtract(const Duration(days: 5)),
      },
      {
        'id': '10',
        'name': 'Deepika Joshi',
        'email': 'deepika.joshi@student.edu',
        'phone': '+91 98765 43219',
        'university': 'Symbiosis Pune',
        'branch': 'Business',
        'year': '2024',
        'cgpa': '8.8',
        'experience': '2',
        'projects': 5,
        'skills': [
          'Sales',
          'Customer Relations',
          'Business Analysis',
          'Communication',
          'Negotiation',
          'Market Research'
        ],
        'about':
            'Business student with strong sales and customer relationship skills. Experienced in market research and business analysis.',
        'isShortlisted': false,
        'createdAt': DateTime.now().subtract(const Duration(days: 3)),
      },
    ];
  }
}
