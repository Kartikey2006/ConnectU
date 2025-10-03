import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/forum.dart';
import '../../domain/entities/forum_post.dart';

class RealtimeForumsService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Map<String, RealtimeChannel> _channels = {};

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

  // Get all forums with real-time updates
  Future<List<Forum>> getForums() async {
    try {
      print('🔍 Fetching forums...');

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

      print('✅ Found ${forums.length} forums');
      return forums;
    } catch (e) {
      print('❌ Error fetching forums: $e');
      rethrow;
    }
  }

  // Get all recent posts with real-time updates
  Future<List<ForumPost>> getAllRecentPosts() async {
    try {
      print('🔍 Fetching all recent posts...');

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

      print('✅ Found ${posts.length} recent posts');
      return posts;
    } catch (e) {
      print('❌ Error fetching recent posts: $e');
      rethrow;
    }
  }

  // Get forum by ID with posts
  Future<Forum?> getForumById(String forumId) async {
    try {
      final response = await _supabase.from('forums').select('''
            *,
            creator:users!forums_created_by_fkey(name, email),
            posts_count:forum_posts(count),
            members_count:forum_members(count)
          ''').eq('id', forumId).single();

      return Forum.fromJson(response);
    } catch (e) {
      print('❌ Error fetching forum by ID: $e');
      return null;
    }
  }

  // Get posts for a specific forum
  Future<List<ForumPost>> getForumPosts(String forumId) async {
    try {
      final response = await _supabase
          .from('forum_posts')
          .select('''
            *,
            author:users!forum_posts_author_id_fkey(name, email),
            forum:forums(*),
            replies_count:forum_replies(count)
          ''')
          .eq('forum_id', forumId)
          .order('is_pinned', ascending: false)
          .order('created_at', ascending: false);

      return response
          .map<ForumPost>((json) => ForumPost.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Error fetching forum posts: $e');
      rethrow;
    }
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
    try {
      print('📝 Creating forum post...');

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

      print('✅ Forum post created successfully');
      return true;
    } catch (e) {
      print('❌ Error creating forum post: $e');
      return false;
    }
  }

  // Join a forum
  Future<bool> joinForum({
    required String forumId,
    required String userId,
  }) async {
    try {
      await _supabase.from('forum_members').insert({
        'forum_id': forumId,
        'user_id': userId,
      });

      return true;
    } catch (e) {
      print('❌ Error joining forum: $e');
      return false;
    }
  }

  // Search forums and posts
  Future<Map<String, dynamic>> searchForumsAndPosts({
    required String query,
  }) async {
    try {
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
      print('❌ Error searching forums and posts: $e');
      rethrow;
    }
  }

  // Subscribe to real-time updates
  void subscribeToForums() {
    try {
      // Subscribe to forum changes
      final forumsChannel = _supabase.channel('forums_changes');
      forumsChannel
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'forums',
            callback: _handleForumUpdate,
          )
          .subscribe();

      _channels['forums'] = forumsChannel;

      // Subscribe to post changes
      final postsChannel = _supabase.channel('posts_changes');
      postsChannel
          .onPostgresChanges(
            event: PostgresChangeEvent.all,
            schema: 'public',
            table: 'forum_posts',
            callback: _handlePostUpdate,
          )
          .subscribe();

      _channels['posts'] = postsChannel;

      print('✅ Subscribed to real-time forum updates');
    } catch (e) {
      print('❌ Error subscribing to real-time updates: $e');
    }
  }

  // Handle forum updates
  void _handleForumUpdate(PostgresChangePayload payload) {
    print('🔄 Forum update received: ${payload.eventType}');

    // Refresh forums data
    getForums().then((forums) {
      print('📰 Updated forums: ${forums.length}');
    }).catchError((error) {
      print('❌ Error refreshing forums: $error');
    });
  }

  // Handle post updates
  void _handlePostUpdate(PostgresChangePayload payload) {
    print('🔄 Post update received: ${payload.eventType}');

    // Refresh posts data
    getAllRecentPosts().then((posts) {
      print('📰 Updated posts: ${posts.length}');
    }).catchError((error) {
      print('❌ Error refreshing posts: $error');
    });
  }

  // Unsubscribe from real-time updates
  void unsubscribeFromForums() {
    for (final channel in _channels.values) {
      _supabase.removeChannel(channel);
    }
    _channels.clear();
    print('✅ Unsubscribed from real-time forum updates');
  }

  // Dispose resources
  void dispose() {
    unsubscribeFromForums();
    _forumsController.close();
    _postsController.close();
  }

  // Force reload data (for testing)
  Future<void> forceReloadData() async {
    print('🔄 Force reloading forum data...');
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
}
