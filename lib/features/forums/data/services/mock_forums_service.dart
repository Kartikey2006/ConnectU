import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MockForumsService {
  static final MockForumsService _instance = MockForumsService._internal();
  factory MockForumsService() => _instance;
  MockForumsService._internal();

  // GLOBAL PERSISTENT STORAGE KEYS - These are shared across ALL user accounts
  static const String _globalForumsKey = 'connectu_global_forums';
  static const String _globalPostsKey = 'connectu_global_posts';
  static const String _globalNextPostIdKey = 'connectu_global_next_post_id';

  // In-memory storage for forums and posts (loaded from SharedPreferences)
  static List<Map<String, dynamic>> _forums = [];
  static List<Map<String, dynamic>> _posts = [];
  static int _nextPostId = 1;

  // Global shared data that persists across all users
  static bool _isInitialized = false;

  // Load data from SharedPreferences using GLOBAL keys
  Future<void> _loadData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Load forums from GLOBAL storage
      final forumsJson = prefs.getString(_globalForumsKey);
      if (forumsJson != null) {
        final List<dynamic> forumsList = json.decode(forumsJson);
        _forums = forumsList.cast<Map<String, dynamic>>();
      }

      // Load posts from GLOBAL storage
      final postsJson = prefs.getString(_globalPostsKey);
      if (postsJson != null) {
        final List<dynamic> postsList = json.decode(postsJson);
        _posts = postsList.cast<Map<String, dynamic>>();
      }

      // Load next post ID from GLOBAL storage
      _nextPostId = prefs.getInt(_globalNextPostIdKey) ?? 1;

      print('📂 Mock: Loaded ${_forums.length} forums from GLOBAL storage');
      print('📝 Mock: Loaded ${_posts.length} posts from GLOBAL storage');
      // Print post details for debugging
      for (var post in _posts) {
        print(
            '📝 Post: ${post['title']} by ${(post['author'] as Map)['name']} (ID: ${post['id']})');
      }
      print(
          '✅ Mock: Loaded ${_forums.length} forums and ${_posts.length} posts from GLOBAL storage');
    } catch (e) {
      print('❌ Mock: Error loading data: $e');
    }
  }

  // Save data to SharedPreferences using GLOBAL keys
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save forums to GLOBAL storage
      await prefs.setString(_globalForumsKey, json.encode(_forums));

      // Save posts to GLOBAL storage
      await prefs.setString(_globalPostsKey, json.encode(_posts));

      // Save next post ID to GLOBAL storage
      await prefs.setInt(_globalNextPostIdKey, _nextPostId);

      print(
          '💾 Mock: Saving ${_forums.length} forums and ${_posts.length} posts to GLOBAL storage');
      // Print post details for debugging
      for (var post in _posts) {
        print(
            '💾 Saving Post: ${post['title']} by ${(post['author'] as Map)['name']} (ID: ${post['id']})');
      }
      print(
          '✅ Mock: Saved ${_forums.length} forums and ${_posts.length} posts to GLOBAL storage');
    } catch (e) {
      print('❌ Mock: Error saving data: $e');
    }
  }

  // Initialize with sample data
  Future<void> _initializeSampleData() async {
    // Only initialize once globally
    if (_isInitialized) {
      return;
    }

    await _loadData();

    if (_forums.isEmpty) {
      _forums = [
        {
          'id': '1',
          'name': 'General Discussion',
          'description': 'General topics and discussions for all alumni',
          'category': 'General',
          'is_public': true,
          'created_at': DateTime.now()
              .subtract(const Duration(days: 5))
              .toIso8601String(),
          'creator': {
            'name': 'Admin',
            'email': 'admin@connectu.com',
          },
          'posts_count': 3,
          'members_count': 25,
        },
        {
          'id': '2',
          'name': 'Career Opportunities',
          'description': 'Share job opportunities and career advice',
          'category': 'Career',
          'is_public': true,
          'created_at': DateTime.now()
              .subtract(const Duration(days: 3))
              .toIso8601String(),
          'creator': {
            'name': 'Sarah Johnson',
            'email': 'sarah.johnson@connectu.com',
          },
          'posts_count': 2,
          'members_count': 18,
        },
        {
          'id': '3',
          'name': 'Alumni Events',
          'description': 'Discuss upcoming alumni events and meetups',
          'category': 'Events',
          'is_public': true,
          'created_at': DateTime.now()
              .subtract(const Duration(days: 2))
              .toIso8601String(),
          'creator': {
            'name': 'Mike Chen',
            'email': 'mike.chen@connectu.com',
          },
          'posts_count': 1,
          'members_count': 12,
        },
      ];
    }

    if (_posts.isEmpty) {
      _posts = [
        {
          'id': '1',
          'forum_id': '1',
          'title': 'Welcome to ConnectU Alumni Platform!',
          'content':
              'Welcome everyone to our new alumni platform! This is a great place to connect, share experiences, and help each other grow in our careers.',
          'author_id': '1',
          'author': {
            'name': 'Admin',
            'email': 'admin@connectu.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(days: 5))
              .toIso8601String(),
          'likes_count': 15,
          'replies_count': 3,
          'views_count': 45,
          'is_pinned': true,
        },
        {
          'id': '2',
          'forum_id': '1',
          'title': 'Best practices for networking',
          'content':
              'I wanted to share some networking tips that have worked well for me. Always follow up within 24 hours, be genuine in your conversations, and offer value before asking for anything.',
          'author_id': '2',
          'author': {
            'name': 'Sarah Johnson',
            'email': 'sarah.johnson@connectu.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(days: 4))
              .toIso8601String(),
          'likes_count': 8,
          'replies_count': 2,
          'views_count': 32,
          'is_pinned': false,
        },
        {
          'id': '3',
          'forum_id': '2',
          'title': 'Software Engineer position at Google',
          'content':
              'Hi everyone! I have a referral opportunity for a Software Engineer position at Google. If you\'re interested, please send me your resume and I\'ll be happy to refer you.',
          'author_id': '3',
          'author': {
            'name': 'Mike Chen',
            'email': 'mike.chen@connectu.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(days: 3))
              .toIso8601String(),
          'likes_count': 12,
          'replies_count': 5,
          'views_count': 28,
          'is_pinned': false,
        },
        {
          'id': '4',
          'forum_id': '1',
          'title': 'Mentorship program experiences',
          'content':
              'Has anyone participated in the mentorship program? I\'d love to hear about your experiences and any tips for making the most of the relationship.',
          'author_id': '4',
          'author': {
            'name': 'Emily Davis',
            'email': 'emily.davis@connectu.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(days: 2))
              .toIso8601String(),
          'likes_count': 6,
          'replies_count': 4,
          'views_count': 19,
          'is_pinned': false,
        },
        {
          'id': '5',
          'forum_id': '3',
          'title': 'Annual Alumni Reunion 2024',
          'content':
              'Mark your calendars! Our annual alumni reunion is scheduled for December 15th, 2024. We\'ll have networking sessions, keynote speakers, and lots of fun activities planned.',
          'author_id': '5',
          'author': {
            'name': 'David Wilson',
            'email': 'david.wilson@connectu.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(days: 1))
              .toIso8601String(),
          'likes_count': 20,
          'replies_count': 8,
          'views_count': 67,
          'is_pinned': true,
        },
      ];

      // Add sample cross-account posts to verify visibility
      final crossAccountPosts = [
        {
          'id': '98',
          'forum_id': '1',
          'title': '🔥 Welcome from Admin - Visible to All',
          'content':
              'Welcome to ConnectU! This post should be visible to ALL users regardless of which account they use to log in.',
          'image_path': null,
          'author_id': 'admin_global',
          'author': {
            'name': 'Admin',
            'email': 'admin@connectu.com',
          },
          'created_at': DateTime.now().toIso8601String(),
          'likes_count': 5,
          'replies_count': 2,
          'views_count': 15,
          'is_pinned': true,
        },
        {
          'id': '99',
          'forum_id': '1',
          'title': '🧪 Cross-Account Test Post',
          'content':
              'This is a test post to verify that posts are visible across different user accounts. If you can see this, the global storage is working correctly!',
          'image_path': null,
          'author_id': 'test_user_global',
          'author': {
            'name': 'Test User',
            'email': 'test@connectu.com',
          },
          'created_at': DateTime.now().subtract(const Duration(minutes: 10)).toIso8601String(),
          'likes_count': 1,
          'replies_count': 0,
          'views_count': 8,
          'is_pinned': false,
        },
      ];
      
      // Add cross-account posts to the beginning
      _posts.insertAll(0, crossAccountPosts);

      // Save the initialized data
      await _saveData();
    }

    // Mark as initialized
    _isInitialized = true;
  }

  // Get all forums
  Future<List<Map<String, dynamic>>> getForums() async {
    await _initializeSampleData();

    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));

    print('✅ Mock: Found ${_forums.length} forums');
    print('📝 Mock: Current posts in memory: ${_posts.length}');
    for (var post in _posts) {
      print(
          '📝 Post: ${post['title']} by ${(post['author'] as Map)['name']} (ID: ${post['id']})');
    }
    return List.from(_forums);
  }

  // Clear all data (for testing)
  Future<void> clearAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_globalForumsKey);
      await prefs.remove(_globalPostsKey);
      await prefs.remove(_globalNextPostIdKey);
      _forums.clear();
      _posts.clear();
      _nextPostId = 1;
      _isInitialized = false;
      print('🗑️ Mock: Cleared all GLOBAL data');
    } catch (e) {
      print('❌ Mock: Error clearing data: $e');
    }
  }

  // Create a test post (for debugging)
  Future<void> createTestPost() async {
    await _initializeSampleData();

    final testPost = {
      'id': '999',
      'forum_id': '1',
      'title': 'TEST POST - This should be visible!',
      'content':
          'This is a test post to verify cross-account visibility. If you can see this, the system is working!',
      'image_path': null,
      'author_id': '999',
      'author': {
        'name': 'Test User',
        'email': 'test@example.com',
      },
      'created_at': DateTime.now().toIso8601String(),
      'likes_count': 0,
      'replies_count': 0,
      'views_count': 0,
      'is_pinned': false,
    };

    _posts.insert(0, testPost);
    await _saveData();

    print('🧪 Mock: Created test post with ID 999');
    print(
        '📝 Test post: ${testPost['title']} by ${(testPost['author'] as Map)['name']}');
  }

  // Get forum by ID with posts
  Future<Map<String, dynamic>?> getForumById(String forumId) async {
    await _initializeSampleData();

    await Future.delayed(const Duration(milliseconds: 300));

    try {
      final forum = _forums.firstWhere((forum) => forum['id'] == forumId);
      final forumPosts =
          _posts.where((post) => post['forum_id'] == forumId).toList();
      forum['posts'] = forumPosts;
      return forum;
    } catch (e) {
      return null;
    }
  }

  // Get posts for a forum
  Future<List<Map<String, dynamic>>> getForumPosts({
    required String forumId,
    int page = 0,
    int limit = 20,
  }) async {
    await _initializeSampleData();

    await Future.delayed(const Duration(milliseconds: 300));

    final forumPosts =
        _posts.where((post) => post['forum_id'] == forumId).toList();

    // Sort by pinned first, then by creation date
    forumPosts.sort((a, b) {
      if (a['is_pinned'] == true && b['is_pinned'] != true) return -1;
      if (a['is_pinned'] != true && b['is_pinned'] == true) return 1;
      return DateTime.parse(b['created_at'])
          .compareTo(DateTime.parse(a['created_at']));
    });

    final from = page * limit;
    final to = (from + limit).clamp(0, forumPosts.length);

    return forumPosts.sublist(from, to);
  }

  // Create a new forum post
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

    await Future.delayed(const Duration(milliseconds: 500));

    try {
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
          '📝 Mock: Added post to GLOBAL storage - Total posts now: ${_posts.length}');
      print(
          '📝 New post: ${newPost['title']} by ${(newPost['author'] as Map)['name']} (ID: ${newPost['id']})');

      // Update forum post count
      final forumIndex = _forums.indexWhere((forum) => forum['id'] == forumId);
      if (forumIndex != -1) {
        _forums[forumIndex]['posts_count'] =
            (_forums[forumIndex]['posts_count'] as int) + 1;
      }

      // Save the updated data to GLOBAL storage
      await _saveData();

      print('✅ Mock: Created new post with ID ${newPost['id']} in GLOBAL storage');
      return true;
    } catch (e) {
      print('❌ Mock: Error creating post: $e');
      return false;
    }
  }

  // Search forums and posts
  Future<List<Map<String, dynamic>>> searchForumsAndPosts({
    required String query,
    int page = 0,
    int limit = 20,
  }) async {
    await _initializeSampleData();

    await Future.delayed(const Duration(milliseconds: 300));

    final results = <Map<String, dynamic>>[];

    // Search forums
    final matchingForums = _forums.where((forum) {
      final name = forum['name'].toString().toLowerCase();
      final description = forum['description'].toString().toLowerCase();
      final searchQuery = query.toLowerCase();
      return name.contains(searchQuery) || description.contains(searchQuery);
    }).toList();

    results.addAll(matchingForums.map((forum) => {
          ...forum,
          'type': 'forum',
        }));

    // Search posts
    final matchingPosts = _posts.where((post) {
      final title = post['title'].toString().toLowerCase();
      final content = post['content'].toString().toLowerCase();
      final searchQuery = query.toLowerCase();
      return title.contains(searchQuery) || content.contains(searchQuery);
    }).toList();

    results.addAll(matchingPosts.map((post) => {
          ...post,
          'type': 'post',
        }));

    // Sort by creation date
    results.sort((a, b) => DateTime.parse(b['created_at'])
        .compareTo(DateTime.parse(a['created_at'])));

    return results;
  }

  // Join a forum
  Future<bool> joinForum({
    required String forumId,
    required String userId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Update member count
    final forumIndex = _forums.indexWhere((forum) => forum['id'] == forumId);
    if (forumIndex != -1) {
      _forums[forumIndex]['members_count'] =
          (_forums[forumIndex]['members_count'] as int) + 1;
      return true;
    }

    return false;
  }

  // Get user's forum activity
  Future<List<Map<String, dynamic>>> getUserForumActivity(String userId) async {
    await _initializeSampleData();

    await Future.delayed(const Duration(milliseconds: 300));

    final userPosts =
        _posts.where((post) => post['author_id'] == userId).toList();

    // Add forum info to each post
    for (final post in userPosts) {
      final forum = _forums.firstWhere(
        (forum) => forum['id'] == post['forum_id'],
        orElse: () => {'name': 'Unknown Forum'},
      );
      post['forum'] = forum;
    }

    return userPosts;
  }

  // Get all posts across all forums (for recent posts tab)
  Future<List<Map<String, dynamic>>> getAllRecentPosts() async {
    await _initializeSampleData();

    await Future.delayed(const Duration(milliseconds: 300));

    // Get all posts from GLOBAL storage (no duplication needed)
    final allPosts = List<Map<String, dynamic>>.from(_posts);

    // Sort by pinned first, then by creation date (newest first)
    allPosts.sort((a, b) {
      // Pinned posts first
      if (a['is_pinned'] == true && b['is_pinned'] != true) return -1;
      if (a['is_pinned'] != true && b['is_pinned'] == true) return 1;
      
      // Then sort by creation date (newest first)
      return DateTime.parse(b['created_at'])
          .compareTo(DateTime.parse(a['created_at']));
    });

    // Add forum info to each post
    for (final post in allPosts) {
      final forum = _forums.firstWhere(
        (forum) => forum['id'] == post['forum_id'],
        orElse: () => {'name': 'Unknown Forum', 'category': 'General'},
      );
      post['forum'] = forum;
    }

    print('📝 Mock: getAllRecentPosts returning ${allPosts.length} posts from GLOBAL storage');
    for (var post in allPosts) {
      print(
          '📝 Post: ${post['title']} by ${(post['author'] as Map)['name']} (ID: ${post['id']})');
    }

    return allPosts;
  }

  // Force reload all data from storage (for debugging)
  Future<void> forceReloadData() async {
    print('🔄 Mock: Force reloading all data from storage...');
    await _loadData();
    print(
        '✅ Mock: Force reload completed - ${_forums.length} forums, ${_posts.length} posts');
    for (var post in _posts) {
      print(
          '📝 Post: ${post['title']} by ${(post['author'] as Map)['name']} (ID: ${post['id']})');
    }
  }

  // Get all posts (for debugging)
  Future<List<Map<String, dynamic>>> getAllPosts() async {
    await _initializeSampleData();
    print('📝 Mock: Returning all ${_posts.length} posts');
    for (var post in _posts) {
      print(
          '📝 Post: ${post['title']} by ${(post['author'] as Map)['name']} (ID: ${post['id']})');
    }
    return List.from(_posts);
  }
}
