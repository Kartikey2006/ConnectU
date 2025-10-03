import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/forum.dart';
import '../../domain/entities/forum_post.dart';

class GlobalForumsService {
  // Singleton instance
  static final GlobalForumsService _instance = GlobalForumsService._internal();
  factory GlobalForumsService() => _instance;
  GlobalForumsService._internal();

  // GLOBAL PERSISTENT STORAGE KEYS - These are shared across ALL user accounts
  static const String _globalForumsKey = 'connectu_global_forums_v4_fresh';
  static const String _globalPostsKey = 'connectu_global_posts_v4_fresh';
  static const String _globalNextPostIdKey =
      'connectu_global_next_post_id_v4_fresh';

  // In-memory storage for forums and posts (loaded from SharedPreferences)
  static List<Map<String, dynamic>> _forums = [];
  static List<Map<String, dynamic>> _posts = [];
  static int _nextPostId = 1;

  // Global shared data that persists across all users
  static bool _isInitialized = false;

  // Stream controllers for real-time updates
  final StreamController<List<Forum>> _forumsController =
      StreamController<List<Forum>>.broadcast();
  final StreamController<List<ForumPost>> _postsController =
      StreamController<List<ForumPost>>.broadcast();

  // Getters for streams
  Stream<List<Forum>> get forumsStream => _forumsController.stream;
  Stream<List<ForumPost>> get postsStream => _postsController.stream;

  // Load data from SharedPreferences using GLOBAL keys
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      print('🔍 Global: Loading data from SharedPreferences...');

      // Load forums from GLOBAL storage
      final forumsJson = prefs.getString(_globalForumsKey);
      if (forumsJson != null) {
        final List<dynamic> forumsList = json.decode(forumsJson);
        _forums = forumsList.cast<Map<String, dynamic>>();
        print('🔍 Global: Loaded ${_forums.length} forums from storage');
      } else {
        print('🔍 Global: No forums found in storage');
      }

      // Load posts from GLOBAL storage
      final postsJson = prefs.getString(_globalPostsKey);
      if (postsJson != null) {
        final List<dynamic> postsList = json.decode(postsJson);
        _posts = postsList.cast<Map<String, dynamic>>();
        print('🔍 Global: Loaded ${_posts.length} posts from storage');

        // Print all posts for debugging
        for (var post in _posts) {
          print(
              '🔍 Global: Post: ${post['title']} by ${(post['author'] as Map)['name']} (ID: ${post['id']})');
        }
      } else {
        print('🔍 Global: No posts found in storage');
      }

      // Load next post ID from GLOBAL storage
      _nextPostId = prefs.getInt(_globalNextPostIdKey) ?? 1;
      print('🔍 Global: Next post ID: $_nextPostId');
    } catch (e) {
      print('❌ Global: Error loading data: $e');
    }
  }

  // Save data to SharedPreferences using GLOBAL keys
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      print('💾 Global: Saving data to SharedPreferences...');

      // Save forums to GLOBAL storage
      final forumsJson = json.encode(_forums);
      await prefs.setString(_globalForumsKey, forumsJson);

      // Save posts to GLOBAL storage
      final postsJson = json.encode(_posts);
      await prefs.setString(_globalPostsKey, postsJson);

      // Save next post ID to GLOBAL storage
      await prefs.setInt(_globalNextPostIdKey, _nextPostId);

      print(
          '💾 Global: Saved ${_forums.length} forums and ${_posts.length} posts to storage');
      for (var post in _posts) {
        print(
            '💾 Global: Saved Post: ${post['title']} by ${(post['author'] as Map)['name']} (ID: ${post['id']})');
      }
    } catch (e) {
      print('❌ Global: Error saving data: $e');
    }
  }

  // Initialize sample data if none exists
  Future<void> _initializeSampleData() async {
    if (_isInitialized) {
      print('🔄 Global: Already initialized, skipping...');
      return;
    }

    print('🔄 Global: Initializing data...');
    await _loadData();

    // Only create sample data if storage is empty
    if (_forums.isEmpty) {
      print('🔄 Global: Creating sample forums...');
      _forums = [
        {
          'id': '1',
          'name': 'General Discussion',
          'description': 'General topics and discussions for all alumni',
          'category': 'General',
          'is_public': true,
          'created_by': 'priya_sharma',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'posts_count': 0,
          'members_count': 0,
          'creator': {
            'name': 'Priya Sharma',
            'email': 'priya.sharma@connectu.com',
          },
        },
        {
          'id': '2',
          'name': 'Career Opportunities',
          'description': 'Share job opportunities and career advice',
          'category': 'Career',
          'is_public': true,
          'created_by': 'priya_sharma',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'posts_count': 0,
          'members_count': 0,
          'creator': {
            'name': 'Priya Sharma',
            'email': 'priya.sharma@connectu.com',
          },
        },
        {
          'id': '3',
          'name': 'Alumni Events',
          'description':
              'Information about upcoming alumni events and reunions',
          'category': 'Events',
          'is_public': true,
          'created_by': 'priya_sharma',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'posts_count': 0,
          'members_count': 0,
          'creator': {
            'name': 'Priya Sharma',
            'email': 'priya.sharma@connectu.com',
          },
        },
      ];
    }

    if (_posts.isEmpty) {
      print('🔄 Global: Creating sample posts...');
      _posts = [
        // General Discussion Posts
        {
          'id': '1',
          'forum_id': '1',
          'title': 'Welcome to ConnectU Alumni Platform!',
          'content':
              'Namaste everyone! Welcome to our ConnectU Alumni Platform. Let\'s connect, share experiences, and help each other grow in our careers. Looking forward to meaningful discussions!',
          'image_path': null,
          'author_id': 'priya_sharma',
          'author': {
            'name': 'Priya Sharma',
            'email': 'priya.sharma@connectu.com',
          },
          'created_at': DateTime.now().toIso8601String(),
          'likes_count': 12,
          'replies_count': 5,
          'views_count': 45,
          'is_pinned': true,
        },
        {
          'id': '2',
          'forum_id': '1',
          'title': 'How to maintain work-life balance in IT industry?',
          'content':
              'Hi everyone! I\'m working as a Software Engineer in Bangalore and struggling with work-life balance. Any tips from experienced professionals? How do you manage long working hours and still find time for family?',
          'image_path': null,
          'author_id': 'user1',
          'author': {
            'name': 'Rajesh Kumar',
            'email': 'rajesh.kumar@gmail.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 3))
              .toIso8601String(),
          'likes_count': 8,
          'replies_count': 12,
          'views_count': 67,
          'is_pinned': false,
        },
        {
          'id': '3',
          'forum_id': '1',
          'title': 'My journey from small town to Silicon Valley',
          'content':
              'Hello everyone! I wanted to share my story of how I moved from a small town in Bihar to working in Silicon Valley. It wasn\'t easy, but with determination and the right guidance, anything is possible. Happy to help anyone with similar aspirations!',
          'image_path': null,
          'author_id': 'user2',
          'author': {
            'name': 'Anjali Singh',
            'email': 'anjali.singh@yahoo.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 6))
              .toIso8601String(),
          'likes_count': 25,
          'replies_count': 8,
          'views_count': 134,
          'is_pinned': false,
        },
        {
          'id': '4',
          'forum_id': '1',
          'title': 'Best places to visit in India for tech professionals',
          'content':
              'Planning a vacation with family. Looking for suggestions on places in India that are tech-friendly (good internet, co-working spaces) but also family-oriented. Any recommendations?',
          'image_path': null,
          'author_id': 'user3',
          'author': {
            'name': 'Vikram Patel',
            'email': 'vikram.patel@outlook.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 8))
              .toIso8601String(),
          'likes_count': 6,
          'replies_count': 15,
          'views_count': 89,
          'is_pinned': false,
        },
        // Career Opportunities Posts
        {
          'id': '5',
          'forum_id': '2',
          'title': 'Senior Software Engineer - Full Stack Developer at TCS',
          'content':
              'We have an opening for Senior Software Engineer position at TCS Mumbai. Requirements: 5+ years experience in React, Node.js, and cloud technologies. Salary: 12-18 LPA. Contact me for referral.',
          'image_path': null,
          'author_id': 'user4',
          'author': {
            'name': 'Suresh Reddy',
            'email': 'suresh.reddy@tcs.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 2))
              .toIso8601String(),
          'likes_count': 15,
          'replies_count': 7,
          'views_count': 156,
          'is_pinned': false,
        },
        {
          'id': '6',
          'forum_id': '2',
          'title': 'Product Manager Role at Flipkart - Immediate Opening',
          'content':
              'Hi everyone! We\'re looking for a Product Manager with 3-5 years experience in e-commerce domain. Location: Bangalore. Great opportunity to work on scale and impact millions of users. DM me for details.',
          'image_path': null,
          'author_id': 'user5',
          'author': {
            'name': 'Meera Iyer',
            'email': 'meera.iyer@flipkart.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 4))
              .toIso8601String(),
          'likes_count': 22,
          'replies_count': 11,
          'views_count': 203,
          'is_pinned': false,
        },
        {
          'id': '7',
          'forum_id': '2',
          'title': 'Data Scientist Position at Zomato - Gurgaon',
          'content':
              'Exciting opportunity for Data Scientists! We\'re building the future of food delivery with AI/ML. Looking for candidates with Python, SQL, and machine learning experience. Competitive package + ESOPs.',
          'image_path': null,
          'author_id': 'user6',
          'author': {
            'name': 'Arjun Gupta',
            'email': 'arjun.gupta@zomato.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 5))
              .toIso8601String(),
          'likes_count': 18,
          'replies_count': 9,
          'views_count': 178,
          'is_pinned': false,
        },
        {
          'id': '8',
          'forum_id': '2',
          'title': 'Startup Opportunity - Co-founder/CTO Role',
          'content':
              'Looking for a technical co-founder for my fintech startup. We\'re building a digital lending platform for SMEs. Need someone with strong backend development skills and entrepreneurial mindset. Equity-based partnership.',
          'image_path': null,
          'author_id': 'user7',
          'author': {
            'name': 'Deepak Jain',
            'email': 'deepak.jain@startup.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 7))
              .toIso8601String(),
          'likes_count': 14,
          'replies_count': 6,
          'views_count': 92,
          'is_pinned': false,
        },
        // Alumni Events Posts
        {
          'id': '9',
          'forum_id': '3',
          'title': 'Annual Alumni Meet 2024 - Save the Date!',
          'content':
              'Mark your calendars! Our Annual Alumni Meet is scheduled for December 15th, 2024 at Hotel Taj Palace, Mumbai. This year we have exciting sessions on AI, entrepreneurship, and networking. Early bird registration is open!',
          'image_path': null,
          'author_id': 'user8',
          'author': {
            'name': 'Kavita Desai',
            'email': 'kavita.desai@alumni.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 1))
              .toIso8601String(),
          'likes_count': 35,
          'replies_count': 18,
          'views_count': 267,
          'is_pinned': true,
        },
        {
          'id': '10',
          'forum_id': '3',
          'title': 'Tech Talk Series - "Future of AI in India"',
          'content':
              'Join us for an exclusive tech talk by Dr. Ravi Shankar, CTO of Infosys, on "Future of AI in India" this Saturday at 3 PM. Venue: IIT Bombay Auditorium. Free for all alumni members. Register now!',
          'image_path': null,
          'author_id': 'user9',
          'author': {
            'name': 'Rohit Agarwal',
            'email': 'rohit.agarwal@iitb.ac.in',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 9))
              .toIso8601String(),
          'likes_count': 28,
          'replies_count': 12,
          'views_count': 189,
          'is_pinned': false,
        },
        {
          'id': '11',
          'forum_id': '3',
          'title': 'Mentorship Program Launch - Be a Mentor!',
          'content':
              'We\'re launching our Alumni Mentorship Program! Experienced professionals, please consider mentoring current students and recent graduates. It\'s a great way to give back to the community. Sign up as a mentor today!',
          'image_path': null,
          'author_id': 'user10',
          'author': {
            'name': 'Sunita Verma',
            'email': 'sunita.verma@mentor.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 12))
              .toIso8601String(),
          'likes_count': 41,
          'replies_count': 23,
          'views_count': 312,
          'is_pinned': false,
        },
        {
          'id': '12',
          'forum_id': '3',
          'title': 'Alumni Cricket Tournament - Team Registration Open',
          'content':
              'Get ready for some fun! Alumni Cricket Tournament is back this year. Teams of 11 players each. Registration fee: ₹2000 per team. Prizes worth ₹50,000. Last date for registration: November 30th. Let\'s play!',
          'image_path': null,
          'author_id': 'user11',
          'author': {
            'name': 'Amit Khanna',
            'email': 'amit.khanna@sports.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 15))
              .toIso8601String(),
          'likes_count': 19,
          'replies_count': 8,
          'views_count': 145,
          'is_pinned': false,
        },
        // Diary/Personal Experience Posts
        {
          'id': '13',
          'forum_id': '1',
          'title': 'My first day at Google - A dream come true!',
          'content':
              'Today marks one of the most special days of my life! After 3 years of hard work and multiple interview rounds, I finally joined Google as a Software Engineer. The campus is amazing, and the people are so welcoming. Grateful for this opportunity!',
          'image_path': null,
          'author_id': 'user12',
          'author': {
            'name': 'Neha Sharma',
            'email': 'neha.sharma@gmail.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 10))
              .toIso8601String(),
          'likes_count': 67,
          'replies_count': 31,
          'views_count': 445,
          'is_pinned': false,
        },
        {
          'id': '14',
          'forum_id': '1',
          'title': 'Lessons learned from my startup failure',
          'content':
              'Sharing my experience of starting a tech startup that didn\'t work out. What went wrong, what I learned, and how it made me a better professional. Sometimes failures teach us more than successes. Hope this helps someone!',
          'image_path': null,
          'author_id': 'user13',
          'author': {
            'name': 'Rahul Mehta',
            'email': 'rahul.mehta@startup.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 18))
              .toIso8601String(),
          'likes_count': 52,
          'replies_count': 28,
          'views_count': 389,
          'is_pinned': false,
        },
        {
          'id': '15',
          'forum_id': '1',
          'title': 'How I managed to get 3 job offers simultaneously',
          'content':
              'After months of preparation and networking, I finally received 3 job offers from different companies. Sharing my strategy: how I prepared, what resources I used, and how I negotiated the best package. Happy to help others in their job search!',
          'image_path': null,
          'author_id': 'user14',
          'author': {
            'name': 'Priyanka Joshi',
            'email': 'priyanka.joshi@career.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 20))
              .toIso8601String(),
          'likes_count': 89,
          'replies_count': 45,
          'views_count': 567,
          'is_pinned': false,
        },
      ];
    }

    await _saveData();
    _isInitialized = true;
    print('✅ Global: Initialization complete');
  }

  // Get all forums
  Future<List<Forum>> getForums() async {
    await _initializeSampleData();

    final forums = _forums.map<Forum>((json) => Forum.fromJson(json)).toList();
    _forumsController.add(forums);

    print('✅ Global: Found ${forums.length} forums');
    return forums;
  }

  // Get all recent posts
  Future<List<ForumPost>> getAllRecentPosts() async {
    await _initializeSampleData();

    // Always reload from storage to get latest data
    await _loadData();

    final allPosts = List<Map<String, dynamic>>.from(_posts);

    // Sort by creation date (newest first)
    allPosts.sort((a, b) => DateTime.parse(b['created_at'])
        .compareTo(DateTime.parse(a['created_at'])));

    // Add forum info to each post
    for (final post in allPosts) {
      final forum = _forums.firstWhere(
        (forum) => forum['id'] == post['forum_id'],
        orElse: () => {'name': 'Unknown Forum'},
      );
      post['forum'] = forum;
    }

    final posts =
        allPosts.map<ForumPost>((json) => ForumPost.fromJson(json)).toList();
    _postsController.add(posts);

    print(
        '📝 Global: getAllRecentPosts returning ${allPosts.length} posts from storage');
    for (var post in allPosts) {
      print(
          '📝 Global: Post: ${post['title']} by ${(post['author'] as Map)['name']} (ID: ${post['id']})');
    }

    return posts;
  }

  // Create a new forum post with proper authentication integration
  Future<bool> createPost({
    required String forumId,
    required String authorId,
    required String title,
    required String content,
    String? imagePath,
    String? authorName,
    String? authorEmail,
  }) async {
    await _initializeSampleData();

    try {
      print('📝 Global: Creating forum post...');
      print(
          '📝 Global: Author ID: $authorId, Name: $authorName, Email: $authorEmail');

      final newPost = {
        'id': _nextPostId.toString(),
        'forum_id': forumId,
        'title': title,
        'content': content,
        'image_path': imagePath,
        'author_id': authorId,
        'author': {
          'name': authorName ?? 'Current User',
          'email': authorEmail ?? 'user@connectu.com',
        },
        'created_at': DateTime.now().toIso8601String(),
        'likes_count': 0,
        'replies_count': 0,
        'views_count': 0,
        'is_pinned': false,
      };

      _posts.insert(0, newPost); // Add to beginning of list
      _nextPostId++;

      print(
          '📝 Global: Added post to storage - Total posts now: ${_posts.length}');
      print(
          '📝 Global: New post: ${newPost['title']} by ${(newPost['author'] as Map)['name']} (ID: ${newPost['id']})');

      // Save to persistent storage
      await _saveData();

      // Update cached posts and notify listeners
      await getAllRecentPosts();

      print('✅ Global: Created new post with ID ${newPost['id']} in storage');
      return true;
    } catch (e) {
      print('❌ Global: Error creating forum post: $e');
      return false;
    }
  }

  // Join a forum
  Future<bool> joinForum({
    required String forumId,
    required String userId,
  }) async {
    await _initializeSampleData();

    try {
      print('👥 Global: User $userId joining forum $forumId');
      return true;
    } catch (e) {
      print('❌ Global: Error joining forum: $e');
      return false;
    }
  }

  // Search forums and posts
  Future<Map<String, dynamic>> searchForumsAndPosts({
    required String query,
  }) async {
    await _initializeSampleData();

    try {
      final results = <Map<String, dynamic>>[];

      // Search forums
      for (final forum in _forums) {
        if (forum['name']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            forum['description']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())) {
          results.add({
            ...forum,
            'type': 'forum',
          });
        }
      }

      // Search posts
      for (final post in _posts) {
        if (post['title']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            post['content']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase())) {
          results.add({
            ...post,
            'type': 'post',
          });
        }
      }

      // Sort by relevance
      results.sort((a, b) => b['created_at'].compareTo(a['created_at']));

      return {
        'forums': results.where((item) => item['type'] == 'forum').toList(),
        'posts': results.where((item) => item['type'] == 'post').toList(),
      };
    } catch (e) {
      print('❌ Global: Error searching forums and posts: $e');
      return {
        'forums': [],
        'posts': [],
      };
    }
  }

  // Subscribe to real-time updates (simulated with periodic refresh)
  void subscribeToForums() {
    print('✅ Global: Subscribed to real-time forum updates (simulated)');
  }

  // Unsubscribe from real-time updates
  void unsubscribeFromForums() {
    print('✅ Global: Unsubscribed from real-time forum updates');
  }

  // Force reload data (for testing)
  Future<void> forceReloadData() async {
    print('🔄 Global: Force reloading forum data...');
    _isInitialized = false; // Reset initialization flag
    await _loadData();
    await getForums();
    await getAllRecentPosts();
  }

  // Debug method to check cross-account visibility
  Future<void> debugCrossAccountVisibility() async {
    print('🔍 DEBUG: Checking cross-account visibility...');
    await _loadData();
    print('🔍 DEBUG: Total posts in storage: ${_posts.length}');
    for (var post in _posts) {
      print(
          '🔍 DEBUG: Post: ${post['title']} by ${(post['author'] as Map)['name']} (ID: ${post['id']})');
    }
  }

  // Reset data to load new sample posts
  Future<void> resetToNewSampleData() async {
    print('🔄 Global: Resetting to new sample data...');
    try {
      final prefs = await SharedPreferences.getInstance();

      // Clear existing data
      await prefs.remove(_globalForumsKey);
      await prefs.remove(_globalPostsKey);
      await prefs.remove(_globalNextPostIdKey);

      // Also clear old keys to ensure clean start
      await prefs.remove('connectu_global_forums_v2');
      await prefs.remove('connectu_global_posts_v2');
      await prefs.remove('connectu_global_next_post_id_v2');
      await prefs.remove('connectu_global_forums_v3_indian');
      await prefs.remove('connectu_global_posts_v3_indian');
      await prefs.remove('connectu_global_next_post_id_v3_indian');

      // Reset in-memory data
      _forums = [];
      _posts = [];
      _nextPostId = 1;
      _isInitialized = false;

      print(
          '✅ Global: Data reset complete. New sample data will be loaded on next access.');
    } catch (e) {
      print('❌ Global: Error resetting data: $e');
    }
  }

  // Dispose resources
  void dispose() {
    unsubscribeFromForums();
    // Don't close StreamControllers for singleton service
    // _forumsController.close();
    // _postsController.close();
  }
}
