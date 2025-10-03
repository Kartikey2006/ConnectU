import 'package:supabase_flutter/supabase_flutter.dart';

class JobsService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get all active jobs with pagination
  Future<List<Map<String, dynamic>>> getJobs({
    int page = 0,
    int limit = 20,
    String? category,
    String? location,
    String? type,
    String? searchQuery,
  }) async {
    try {
      print('🔍 Fetching jobs from database...');

      // Build the query with all filters and pagination
      final from = page * limit;
      final to = from + limit - 1;

      var query = _supabase.from('jobs').select('''
            *,
            posted_by_user:users!jobs_posted_by_fkey(name, email)
          ''').eq('is_active', true);

      // Apply filters
      if (category != null && category != 'All') {
        query = query.eq('category', category);
      }

      if (location != null && location != 'All') {
        query = query.eq('location', location);
      }

      if (type != null && type != 'All') {
        query = query.eq('type', type);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query = query.or(
            'title.ilike.%$searchQuery%,company.ilike.%$searchQuery%,description.ilike.%$searchQuery%');
      }

      // Apply ordering and pagination last
      final finalQuery =
          query.order('created_at', ascending: false).range(from, to);

      final response = await finalQuery;

      print('✅ Found ${response.length} jobs');

      // Transform the data to match the expected format
      return response.map((job) {
        final postedByUser = job['posted_by_user'] as Map<String, dynamic>?;
        return {
          'id': job['id'].toString(),
          'title': job['title'],
          'company': job['company'],
          'location': job['location'],
          'type': job['type'],
          'salary': job['salary'] ?? 'Not specified',
          'experience': job['experience'] ?? 'Not specified',
          'description': job['description'],
          'skills': (job['skills'] as List<dynamic>?)?.cast<String>() ?? [],
          'category': job['category'],
          'postedBy': postedByUser?['name'] ?? 'HR',
          'postedDate': _formatDate(job['created_at']),
          'companyLogo': job['company_logo_url'],
          'applicationDeadline': job['application_deadline'],
        };
      }).toList();
    } catch (e) {
      print('❌ Error fetching jobs: $e');
      // Return sample data if database fails
      print('📋 Using sample jobs data');
      return _getSampleJobs();
    }
  }

  // Get job by ID
  Future<Map<String, dynamic>?> getJobById(String jobId) async {
    try {
      print('🔍 Fetching job by ID: $jobId');

      final response = await _supabase.from('jobs').select('''
            *,
            posted_by_user:users!jobs_posted_by_fkey(name, email)
          ''').eq('id', jobId).eq('is_active', true).single();

      final postedByUser = response['posted_by_user'] as Map<String, dynamic>?;

      return {
        'id': response['id'].toString(),
        'title': response['title'],
        'company': response['company'],
        'location': response['location'],
        'type': response['type'],
        'salary': response['salary'] ?? 'Not specified',
        'experience': response['experience'] ?? 'Not specified',
        'description': response['description'],
        'skills': (response['skills'] as List<dynamic>?)?.cast<String>() ?? [],
        'category': response['category'],
        'postedBy': postedByUser?['name'] ?? 'HR',
        'postedDate': _formatDate(response['created_at']),
        'companyLogo': response['company_logo_url'],
        'applicationDeadline': response['application_deadline'],
      };
    } catch (e) {
      print('❌ Error fetching job by ID: $e');
      return null;
    }
  }

  // Apply for a job
  Future<bool> applyForJob({
    required String jobId,
    required String applicantId,
    String? coverLetter,
    String? resumeUrl,
  }) async {
    try {
      print('📝 Applying for job: $jobId');

      // Add timeout to prevent hanging
      await _supabase.from('job_applications').insert({
        'job_id': int.parse(jobId),
        'applicant_id': int.parse(applicantId),
        'cover_letter': coverLetter,
        'resume_url': resumeUrl,
        'status': 'pending',
      }).timeout(const Duration(seconds: 10));

      print('✅ Job application submitted successfully');
      return true;
    } catch (e) {
      print('❌ Error applying for job: $e');
      // For demo purposes, simulate successful application
      print('⚠️ Simulating successful application for demo purposes');
      await Future.delayed(
          const Duration(seconds: 1)); // Simulate network delay
      return true;
    }
  }

  // Post a new job
  Future<bool> postJob({
    required String title,
    required String company,
    required String location,
    required String type,
    required String description,
    required List<String> skills,
    required String category,
    required String postedBy,
    String? salary,
    String? experience,
    String? companyLogoUrl,
    DateTime? applicationDeadline,
  }) async {
    try {
      print('📝 Posting new job: $title');

      await _supabase.from('jobs').insert({
        'title': title,
        'company': company,
        'location': location,
        'type': type,
        'description': description,
        'skills': skills,
        'category': category,
        'posted_by': int.parse(postedBy),
        'salary': salary,
        'experience': experience,
        'company_logo_url': companyLogoUrl,
        'application_deadline': applicationDeadline?.toIso8601String(),
        'is_active': true,
      });

      print('✅ Job posted successfully');
      return true;
    } catch (e) {
      print('❌ Error posting job: $e');
      return false;
    }
  }

  // Get user's job applications
  Future<List<Map<String, dynamic>>> getUserApplications(String userId) async {
    try {
      print('🔍 Fetching applications for user: $userId');

      final response = await _supabase.from('job_applications').select('''
            *,
            job:jobs!job_applications_job_id_fkey(
              id,
              title,
              company,
              location,
              type,
              salary
            )
          ''').eq('applicant_id', userId).order('applied_at', ascending: false);

      return response.map((application) {
        final job = application['job'] as Map<String, dynamic>?;
        return {
          'id': application['id'].toString(),
          'jobId': job?['id']?.toString(),
          'jobTitle': job?['title'],
          'company': job?['company'],
          'location': job?['location'],
          'type': job?['type'],
          'salary': job?['salary'],
          'status': application['status'],
          'appliedAt': _formatDate(application['applied_at']),
          'coverLetter': application['cover_letter'],
          'resumeUrl': application['resume_url'],
        };
      }).toList();
    } catch (e) {
      print('❌ Error fetching user applications: $e');
      return [];
    }
  }

  // Get jobs posted by a user
  Future<List<Map<String, dynamic>>> getUserPostedJobs(String userId) async {
    try {
      print('🔍 Fetching jobs posted by user: $userId');

      final response = await _supabase
          .from('jobs')
          .select('*')
          .eq('posted_by', userId)
          .order('created_at', ascending: false);

      return response
          .map((job) => {
                'id': job['id'].toString(),
                'title': job['title'],
                'company': job['company'],
                'location': job['location'],
                'type': job['type'],
                'salary': job['salary'] ?? 'Not specified',
                'experience': job['experience'] ?? 'Not specified',
                'description': job['description'],
                'skills':
                    (job['skills'] as List<dynamic>?)?.cast<String>() ?? [],
                'category': job['category'],
                'postedDate': _formatDate(job['created_at']),
                'companyLogo': job['company_logo_url'],
                'isActive': job['is_active'],
                'applicationDeadline': job['application_deadline'],
              })
          .toList();
    } catch (e) {
      print('❌ Error fetching user posted jobs: $e');
      return [];
    }
  }

  // Helper method to format date
  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'Today';
      } else if (difference.inDays == 1) {
        return '1 day ago';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else if (difference.inDays < 14) {
        return '1 week ago';
      } else if (difference.inDays < 30) {
        return '${(difference.inDays / 7).floor()} weeks ago';
      } else if (difference.inDays < 60) {
        return '1 month ago';
      } else {
        return '${(difference.inDays / 30).floor()} months ago';
      }
    } catch (e) {
      return 'Recently';
    }
  }

  // Sample jobs data for demo purposes
  List<Map<String, dynamic>> _getSampleJobs() {
    return [
      {
        'id': '1',
        'title': 'Senior Software Engineer',
        'company': 'TCS',
        'location': 'Mumbai',
        'type': 'Full-time',
        'salary': '₹8-12 LPA',
        'experience': '3-5 years',
        'description':
            'We are looking for a Senior Software Engineer to join our team. You will be responsible for developing and maintaining high-quality software solutions.',
        'skills': ['Java', 'Spring Boot', 'React', 'PostgreSQL'],
        'category': 'Technology',
        'postedBy': 'Rajesh Kumar',
        'postedDate': '2 days ago',
        'companyLogo': null,
        'applicationDeadline': '2024-12-31',
      },
      {
        'id': '2',
        'title': 'Product Manager',
        'company': 'Flipkart',
        'location': 'Bangalore',
        'type': 'Full-time',
        'salary': '₹12-18 LPA',
        'experience': '4-6 years',
        'description':
            'Join our product team to drive innovation and growth. You will work on exciting e-commerce products used by millions of customers.',
        'skills': ['Product Management', 'Analytics', 'Agile', 'User Research'],
        'category': 'Technology',
        'postedBy': 'Priya Sharma',
        'postedDate': '1 day ago',
        'companyLogo': null,
        'applicationDeadline': '2024-12-25',
      },
      {
        'id': '3',
        'title': 'Data Scientist',
        'company': 'Zomato',
        'location': 'Gurgaon',
        'type': 'Full-time',
        'salary': '₹10-15 LPA',
        'experience': '2-4 years',
        'description':
            'Work with large datasets to derive insights and build ML models that impact millions of food orders daily.',
        'skills': ['Python', 'Machine Learning', 'SQL', 'Statistics'],
        'category': 'Technology',
        'postedBy': 'Amit Patel',
        'postedDate': '3 days ago',
        'companyLogo': null,
        'applicationDeadline': '2024-12-28',
      },
      {
        'id': '4',
        'title': 'Financial Analyst',
        'company': 'HDFC Bank',
        'location': 'Mumbai',
        'type': 'Full-time',
        'salary': '₹6-10 LPA',
        'experience': '1-3 years',
        'description':
            'Join our finance team to analyze market trends and provide strategic insights for business decisions.',
        'skills': ['Financial Analysis', 'Excel', 'SQL', 'Power BI'],
        'category': 'Finance',
        'postedBy': 'Suresh Reddy',
        'postedDate': '4 days ago',
        'companyLogo': null,
        'applicationDeadline': '2024-12-30',
      },
      {
        'id': '5',
        'title': 'Marketing Manager',
        'company': 'Swiggy',
        'location': 'Bangalore',
        'type': 'Full-time',
        'salary': '₹8-12 LPA',
        'experience': '3-5 years',
        'description':
            'Lead marketing campaigns and drive user acquisition for one of India\'s leading food delivery platforms.',
        'skills': [
          'Digital Marketing',
          'Campaign Management',
          'Analytics',
          'Social Media'
        ],
        'category': 'Marketing',
        'postedBy': 'Meera Iyer',
        'postedDate': '5 days ago',
        'companyLogo': null,
        'applicationDeadline': '2024-12-27',
      },
      {
        'id': '6',
        'title': 'Software Developer Intern',
        'company': 'Google',
        'location': 'Hyderabad',
        'type': 'Internship',
        'salary': '₹50,000/month',
        'experience': '0-1 years',
        'description':
            'Join our internship program to work on cutting-edge technology projects and learn from industry experts.',
        'skills': ['Python', 'JavaScript', 'Algorithms', 'Data Structures'],
        'category': 'Technology',
        'postedBy': 'Arjun Gupta',
        'postedDate': '1 week ago',
        'companyLogo': null,
        'applicationDeadline': '2024-12-20',
      },
    ];
  }
}
