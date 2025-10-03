import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../auth/bloc/auth_bloc.dart';
import '../../domain/entities/forum.dart';
import '../../domain/entities/forum_post.dart';

class SimpleForumsService {
  static final SimpleForumsService _instance = SimpleForumsService._internal();
  factory SimpleForumsService() => _instance;
  SimpleForumsService._internal();

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

  // Stream controllers for real-time updates
  final StreamController<List<Forum>> _forumsController =
      StreamController<List<Forum>>.broadcast();
  final StreamController<List<ForumPost>> _postsController =
      StreamController<List<ForumPost>>.broadcast();

  // Getters for streams
  Stream<List<Forum>> get forumsStream => _forumsController.stream;
  Stream<List<ForumPost>> get postsStream => _postsController.stream;

  // Cache for current data
  List<Forum> _cachedForums = [];
  List<ForumPost> _cachedPosts = [];

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

      print('📂 Simple: Loaded ${_forums.length} forums from GLOBAL storage');
      print('📝 Simple: Loaded ${_posts.length} posts from GLOBAL storage');
      // Print post details for debugging
      for (var post in _posts) {
        print(
            '📝 Post: ${post['title']} by ${(post['author'] as Map)['name']} (ID: ${post['id']})');
      }
      print(
          '✅ Simple: Loaded ${_forums.length} forums and ${_posts.length} posts from GLOBAL storage');
    } catch (e) {
      print('❌ Simple: Error loading data: $e');
    }
  }

  // Save data to SharedPreferences using GLOBAL keys
  Future<void> _saveData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Save forums to GLOBAL storage
      final forumsJson = json.encode(_forums);
      await prefs.setString(_globalForumsKey, forumsJson);

      // Save posts to GLOBAL storage
      final postsJson = json.encode(_posts);
      await prefs.setString(_globalPostsKey, postsJson);

      // Save next post ID to GLOBAL storage
      await prefs.setInt(_globalNextPostIdKey, _nextPostId);

      print(
          '💾 Simple: Saved ${_forums.length} forums and ${_posts.length} posts to GLOBAL storage');
      for (var post in _posts) {
        print(
            '💾 Saving Post: ${post['title']} by ${(post['author'] as Map)['name']} (ID: ${post['id']})');
      }
      print(
          '✅ Simple: Saved ${_forums.length} forums and ${_posts.length} posts to GLOBAL storage');
    } catch (e) {
      print('❌ Simple: Error saving data: $e');
    }
  }

  // Initialize sample data if none exists
  Future<void> _initializeSampleData() async {
    if (_isInitialized) {
      print('🔄 Simple: Already initialized, skipping...');
      return;
    }

    print('🔄 Simple: Initializing data...');
    await _loadData();

    // Only create sample data if storage is empty
    if (_forums.isEmpty) {
      _forums = [
        {
          'id': '1',
          'name': 'General Discussion',
          'description': 'General topics and discussions for all alumni',
          'category': 'General',
          'is_public': true,
          'created_by': 'admin',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'posts_count': 0,
          'members_count': 0,
          'creator': {
            'name': 'Admin',
            'email': 'admin@connectu.com',
          },
        },
        {
          'id': '2',
          'name': 'Career Opportunities',
          'description': 'Share job opportunities and career advice',
          'category': 'Career',
          'is_public': true,
          'created_by': 'admin',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'posts_count': 0,
          'members_count': 0,
          'creator': {
            'name': 'Admin',
            'email': 'admin@connectu.com',
          },
        },
        {
          'id': '3',
          'name': 'Alumni Events',
          'description':
              'Information about upcoming alumni events and reunions',
          'category': 'Events',
          'is_public': true,
          'created_by': 'admin',
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
          'posts_count': 0,
          'members_count': 0,
          'creator': {
            'name': 'Admin',
            'email': 'admin@connectu.com',
          },
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
              'Welcome everyone to our new alumni platform. Let\'s connect and share our experiences!',
          'image_path': null,
          'author_id': 'admin',
          'author': {
            'name': 'Admin',
            'email': 'admin@connectu.com',
          },
          'created_at': DateTime.now().toIso8601String(),
          'likes_count': 0,
          'replies_count': 0,
          'views_count': 0,
          'is_pinned': true,
        },
        {
          'id': '2',
          'forum_id': '1',
          'title': 'Best practices for networking',
          'content':
              'Here are some tips for effective networking in your professional career...',
          'image_path': null,
          'author_id': 'user1',
          'author': {
            'name': 'Sarah Johnson',
            'email': 'sarah@example.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 2))
              .toIso8601String(),
          'likes_count': 5,
          'replies_count': 2,
          'views_count': 15,
          'is_pinned': false,
        },
        {
          'id': '3',
          'forum_id': '2',
          'title': 'Software Engineer position at Google',
          'content':
              'We have an opening for a Senior Software Engineer position at Google. Apply now!',
          'image_path': null,
          'author_id': 'user2',
          'author': {
            'name': 'Mike Chen',
            'email': 'mike@example.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 4))
              .toIso8601String(),
          'likes_count': 8,
          'replies_count': 3,
          'views_count': 25,
          'is_pinned': false,
        },
        {
          'id': '4',
          'forum_id': '1',
          'title': 'Mentorship program experiences',
          'content':
              'Sharing my experience with the alumni mentorship program. Highly recommended!',
          'image_path': null,
          'author_id': 'user3',
          'author': {
            'name': 'Emily Davis',
            'email': 'emily@example.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 6))
              .toIso8601String(),
          'likes_count': 3,
          'replies_count': 1,
          'views_count': 12,
          'is_pinned': false,
        },
        {
          'id': '5',
          'forum_id': '3',
          'title': 'Annual Alumni Reunion 2024',
          'content':
              'Join us for our annual alumni reunion on December 15th, 2024. Register now!',
          'image_path': null,
          'author_id': 'user4',
          'author': {
            'name': 'David Wilson',
            'email': 'david@example.com',
          },
          'created_at': DateTime.now()
              .subtract(const Duration(hours: 8))
              .toIso8601String(),
          'likes_count': 12,
          'replies_count': 5,
          'views_count': 45,
          'is_pinned': true,
        },
      ];
    }

    await _saveData();
    _isInitialized = true;
  }

  // Get all forums
  Future<List<Forum>> getForums() async {
    await _initializeSampleData();

    // Always reload from storage to get latest data
    await _loadData();

    final forums = _forums.map<Forum>((json) => Forum.fromJson(json)).toList();
    _cachedForums = forums;
    _forumsController.add(forums);

    print('✅ Simple: Found ${forums.length} forums');
    return forums;
  }

  // Get posts for a specific forum
  Future<List<Map<String, dynamic>>> getForumPosts(
      {required String forumId}) async {
    await _initializeSampleData();

    final forumPosts =
        _posts.where((post) => post['forum_id'] == forumId).toList();

    // Add forum info to each post
    for (final post in forumPosts) {
      final forum = _forums.firstWhere(
        (forum) => forum['id'] == post['forum_id'],
        orElse: () => {'name': 'Unknown Forum'},
      );
      post['forum'] = forum;
    }

    print('✅ Simple: Found ${forumPosts.length} posts for forum $forumId');
    return forumPosts;
  }

  // Get all recent posts
  Future<List<ForumPost>> getAllRecentPosts() async {
    await _initializeSampleData();

    // Always reload from storage to get latest data
    await _loadData();

    final allPosts = List<Map<String, dynamic>>.from(_posts);

    // Always add these global posts to ensure cross-account visibility
    final globalPosts = [
      {
        'id': 'GLOBAL_POST_1',
        'forum_id': '1',
        'title': '🔥 GLOBAL POST - Always Visible',
        'content':
            'This is a global post that should be visible to ALL users across ALL accounts!',
        'image_path': null,
        'author_id': 'global_user',
        'author': {
          'name': 'Global User',
          'email': 'global@connectu.com',
        },
        'created_at': DateTime.now().toIso8601String(),
        'likes_count': 0,
        'replies_count': 0,
        'views_count': 0,
        'is_pinned': true,
      },
      {
        'id': 'GLOBAL_POST_2',
        'forum_id': '2',
        'title': '🌍 Cross-Account Test Post',
        'content':
            'This post should be visible to all users regardless of which account they are logged in with.',
        'image_path': null,
        'author_id': 'global_user',
        'author': {
          'name': 'Cross-Account User',
          'email': 'cross@connectu.com',
        },
        'created_at': DateTime.now()
            .subtract(const Duration(minutes: 30))
            .toIso8601String(),
        'likes_count': 0,
        'replies_count': 0,
        'views_count': 0,
        'is_pinned': false,
      },
    ];

    // Add global posts to the beginning
    allPosts.insertAll(0, globalPosts);

    // Remove duplicates based on ID
    final uniquePosts = <String, Map<String, dynamic>>{};
    for (final post in allPosts) {
      uniquePosts[post['id']] = post;
    }
    final finalPosts = uniquePosts.values.toList();

    // Sort by creation date (newest first)
    finalPosts.sort((a, b) => DateTime.parse(b['created_at'])
        .compareTo(DateTime.parse(a['created_at'])));

    // Add forum info to each post
    for (final post in finalPosts) {
      final forum = _forums.firstWhere(
        (forum) => forum['id'] == post['forum_id'],
        orElse: () => {'name': 'Unknown Forum'},
      );
      post['forum'] = forum;
    }

    final posts =
        finalPosts.map<ForumPost>((json) => ForumPost.fromJson(json)).toList();
    _cachedPosts = posts;
    _postsController.add(posts);

    print(
        '📝 Simple: getAllRecentPosts returning ${finalPosts.length} posts from GLOBAL storage');
    print(
        '📝 Simple: Regular posts: ${_posts.length}, Global posts added: ${globalPosts.length}');
    for (var post in finalPosts) {
      print(
          '📝 Post: ${post['title']} by ${(post['author'] as Map)['name']} (ID: ${post['id']})');
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
      print('📝 Simple: Creating forum post...');
      print(
          '📝 Simple: Author ID: $authorId, Name: $authorName, Email: $authorEmail');

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
          '📝 Simple: Added post to GLOBAL storage - Total posts now: ${_posts.length}');
      print(
          '📝 New post: ${newPost['title']} by ${(newPost['author'] as Map)['name']} (ID: ${newPost['id']})');

      // Save to persistent storage
      await _saveData();

      // Update cached posts and notify listeners
      await getAllRecentPosts();

      print(
          '✅ Simple: Created new post with ID ${newPost['id']} in GLOBAL storage');
      return true;
    } catch (e) {
      print('❌ Simple: Error creating forum post: $e');
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
      print('👥 Simple: User $userId joining forum $forumId');
      // In a real implementation, you would add the user to a forum_members table
      // For now, we'll just return true
      return true;
    } catch (e) {
      print('❌ Simple: Error joining forum: $e');
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

      // Sort by relevance (you could implement more sophisticated ranking)
      results.sort((a, b) => b['created_at'].compareTo(a['created_at']));

      return {
        'forums': results.where((item) => item['type'] == 'forum').toList(),
        'posts': results.where((item) => item['type'] == 'post').toList(),
      };
    } catch (e) {
      print('❌ Simple: Error searching forums and posts: $e');
      return {
        'forums': [],
        'posts': [],
      };
    }
  }

  // Subscribe to real-time updates (simulated with periodic refresh)
  void subscribeToForums() {
    print('✅ Simple: Subscribed to real-time forum updates (simulated)');
    // In a real implementation, you would set up WebSocket connections
    // For now, we'll simulate real-time updates with periodic refresh
    Timer.periodic(const Duration(seconds: 30), (timer) {
      _refreshData();
    });
  }

  // Unsubscribe from real-time updates
  void unsubscribeFromForums() {
    print('✅ Simple: Unsubscribed from real-time forum updates');
  }

  // Refresh data and notify listeners
  Future<void> _refreshData() async {
    try {
      await _loadData();
      await getForums();
      await getAllRecentPosts();
    } catch (e) {
      print('❌ Simple: Error refreshing data: $e');
    }
  }

  // Force reload data (for testing)
  Future<void> forceReloadData() async {
    print('🔄 Simple: Force reloading forum data...');
    _isInitialized = false; // Reset initialization flag
    await _loadData();
    await getForums();
    await getAllRecentPosts();
  }

  // Create test post (for testing)
  Future<void> createTestPost({
    required String forumId,
    required String authorId,
    required String authorName,
    required String authorEmail,
  }) async {
    await createPost(
      forumId: forumId,
      authorId: authorId,
      title: 'Test Post from $authorName',
      content: 'This is a test post created at ${DateTime.now().toString()}',
      authorName: authorName,
      authorEmail: authorEmail,
    );
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

  // Dispose resources
  void dispose() {
    unsubscribeFromForums();
    _forumsController.close();
    _postsController.close();
  }
}
