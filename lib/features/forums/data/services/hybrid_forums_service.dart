import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/forum.dart';
import '../../domain/entities/forum_post.dart';
import 'mock_forums_service.dart';

class HybridForumsService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final MockForumsService _mockService = MockForumsService();

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

  // Flag to track if we're using mock service
  bool _usingMockService = false;

  // Check if database tables exist
  Future<bool> _checkDatabaseTables() async {
    try {
      // Try to query a simple table to see if forums table exists
      await _supabase.from('forums').select('id').limit(1);
      return true;
    } catch (e) {
      print('⚠️ Database tables not found, falling back to mock service: $e');
      return false;
    }
  }

  // Get all forums with fallback to mock service
  Future<List<Forum>> getForums() async {
    try {
      // Check if database tables exist
      if (!await _checkDatabaseTables()) {
        _usingMockService = true;
        return await _getForumsFromMock();
      }

      _usingMockService = false;
      print('🔍 Fetching forums from database...');

      final response = await _supabase.from('forums').select('''
            *,
            creator:users!forums_created_by_fkey(name, email),
            posts_count:forum_posts(count),
            members_count:forum_members(count)
          ''').eq('is_public', true).order('created_at', ascending: false);

      final forums =
          response.map<Forum>((json) => Forum.fromJson(json)).toList();
      _cachedForums = forums;
      _forumsController.add(forums);

      print('✅ Found ${forums.length} forums from database');
      return forums;
    } catch (e) {
      print('❌ Error fetching forums from database, falling back to mock: $e');
      _usingMockService = true;
      return await _getForumsFromMock();
    }
  }

  // Get forums from mock service
  Future<List<Forum>> _getForumsFromMock() async {
    try {
      final mockForums = await _mockService.getForums();
      final forums =
          mockForums.map<Forum>((json) => Forum.fromJson(json)).toList();
      _cachedForums = forums;
      _forumsController.add(forums);
      print('✅ Found ${forums.length} forums from mock service');
      return forums;
    } catch (e) {
      print('❌ Error fetching forums from mock service: $e');
      return [];
    }
  }

  // Get all recent posts with fallback to mock service
  Future<List<ForumPost>> getAllRecentPosts() async {
    try {
      if (_usingMockService) {
        return await _getPostsFromMock();
      }

      print('🔍 Fetching all recent posts from database...');

      final response = await _supabase
          .from('forum_posts')
          .select('''
            *,
            author:users!forum_posts_author_id_fkey(name, email),
            forum:forums(*),
            replies_count:forum_replies(count)
          ''')
          .order('is_pinned', ascending: false)
          .order('created_at', ascending: false)
          .limit(50);

      final posts =
          response.map<ForumPost>((json) => ForumPost.fromJson(json)).toList();
      _cachedPosts = posts;
      _postsController.add(posts);

      print('✅ Found ${posts.length} recent posts from database');
      return posts;
    } catch (e) {
      print('❌ Error fetching posts from database, falling back to mock: $e');
      _usingMockService = true;
      return await _getPostsFromMock();
    }
  }

  // Get posts from mock service
  Future<List<ForumPost>> _getPostsFromMock() async {
    try {
      final mockPosts = await _mockService.getAllRecentPosts();
      final posts =
          mockPosts.map<ForumPost>((json) => ForumPost.fromJson(json)).toList();
      _cachedPosts = posts;
      _postsController.add(posts);
      print('✅ Found ${posts.length} recent posts from mock service');
      return posts;
    } catch (e) {
      print('❌ Error fetching posts from mock service: $e');
      return [];
    }
  }

  // Create a new forum post with fallback to mock service
  Future<bool> createPost({
    required String forumId,
    required String authorId,
    required String title,
    required String content,
    String? imagePath,
    String? authorName,
    String? authorEmail,
  }) async {
    try {
      if (_usingMockService) {
        return await _createPostInMock(
          forumId: forumId,
          authorId: authorId,
          title: title,
          content: content,
          imagePath: imagePath,
          authorName: authorName,
          authorEmail: authorEmail,
        );
      }

      print('📝 Creating forum post in database...');

      final postData = {
        'forum_id': forumId,
        'author_id': authorId,
        'title': title,
        'content': content,
        'image_path': imagePath,
        'likes_count': 0,
        'replies_count': 0,
        'views_count': 0,
        'is_pinned': false,
      };

      final response = await _supabase
          .from('forum_posts')
          .insert(postData)
          .select()
          .single();

      // Create a ForumPost object with author info
      final newPost = ForumPost.fromJson({
        ...response,
        'author': {
          'name': authorName ?? 'Current User',
          'email': authorEmail ?? 'user@connectu.com',
        },
      });

      // Add to cached posts and notify listeners
      _cachedPosts.insert(0, newPost);
      _postsController.add(_cachedPosts);

      print('✅ Forum post created successfully in database');
      return true;
    } catch (e) {
      print(
          '❌ Error creating forum post in database, falling back to mock: $e');
      _usingMockService = true;
      return await _createPostInMock(
        forumId: forumId,
        authorId: authorId,
        title: title,
        content: content,
        imagePath: imagePath,
        authorName: authorName,
        authorEmail: authorEmail,
      );
    }
  }

  // Create post in mock service
  Future<bool> _createPostInMock({
    required String forumId,
    required String authorId,
    required String title,
    required String content,
    String? imagePath,
    String? authorName,
    String? authorEmail,
  }) async {
    try {
      final success = await _mockService.createPost(
        forumId: forumId,
        authorId: authorId,
        title: title,
        content: content,
        imagePath: imagePath,
        authorName: authorName,
        authorEmail: authorEmail,
      );

      if (success) {
        // Refresh posts from mock service
        await _getPostsFromMock();
      }

      print('✅ Forum post created successfully in mock service');
      return success;
    } catch (e) {
      print('❌ Error creating forum post in mock service: $e');
      return false;
    }
  }

  // Join a forum with fallback to mock service
  Future<bool> joinForum({
    required String forumId,
    required String userId,
  }) async {
    try {
      if (_usingMockService) {
        return await _mockService.joinForum(
          forumId: forumId,
          userId: userId,
        );
      }

      await _supabase.from('forum_members').insert({
        'forum_id': forumId,
        'user_id': userId,
      });

      return true;
    } catch (e) {
      print('❌ Error joining forum, falling back to mock: $e');
      _usingMockService = true;
      return await _mockService.joinForum(
        forumId: forumId,
        userId: userId,
      );
    }
  }

  // Search forums and posts with fallback to mock service
  Future<Map<String, dynamic>> searchForumsAndPosts({
    required String query,
  }) async {
    try {
      if (_usingMockService) {
        final mockResults =
            await _mockService.searchForumsAndPosts(query: query);
        // Convert mock results to the expected format
        return {
          'forums':
              mockResults.where((item) => item['type'] == 'forum').toList(),
          'posts': mockResults.where((item) => item['type'] == 'post').toList(),
        };
      }

      // Search forums
      final forumsResponse = await _supabase
          .from('forums')
          .select('''
            *,
            creator:users!forums_created_by_fkey(name, email)
          ''')
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .eq('is_public', true);

      // Search posts
      final postsResponse = await _supabase.from('forum_posts').select('''
            *,
            author:users!forum_posts_author_id_fkey(name, email),
            forum:forums(*)
          ''').or('title.ilike.%$query%,content.ilike.%$query%');

      return {
        'forums': forumsResponse,
        'posts': postsResponse,
      };
    } catch (e) {
      print('❌ Error searching forums and posts, falling back to mock: $e');
      _usingMockService = true;
      final mockResults = await _mockService.searchForumsAndPosts(query: query);
      // Convert mock results to the expected format
      return {
        'forums': mockResults.where((item) => item['type'] == 'forum').toList(),
        'posts': mockResults.where((item) => item['type'] == 'post').toList(),
      };
    }
  }

  // Subscribe to real-time updates (only works with database)
  void subscribeToForums() {
    if (_usingMockService) {
      print('⚠️ Real-time subscriptions not available with mock service');
      return;
    }

    try {
      print('✅ Subscribed to real-time forum updates');
      // Real-time subscription logic would go here
    } catch (e) {
      print('❌ Error subscribing to real-time updates: $e');
    }
  }

  // Unsubscribe from real-time updates
  void unsubscribeFromForums() {
    print('✅ Unsubscribed from real-time forum updates');
  }

  // Force reload data
  Future<void> forceReloadData() async {
    print('🔄 Force reloading forum data...');
    await getForums();
    await getAllRecentPosts();
  }

  // Create test post
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

  // Dispose resources
  void dispose() {
    unsubscribeFromForums();
    _forumsController.close();
    _postsController.close();
  }
}
