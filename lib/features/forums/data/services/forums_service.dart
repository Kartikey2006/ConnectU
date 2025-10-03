import 'package:supabase_flutter/supabase_flutter.dart';

class ForumsService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // Get all forums
  Future<List<Map<String, dynamic>>> getForums() async {
    try {
      print('🔍 Fetching forums...');

      final response = await _supabase.from('forums').select('''
            *,
            creator:users!forums_created_by_fkey(name, email),
            posts_count:forum_posts(count),
            members_count:forum_members(count)
          ''').eq('is_public', true).order('created_at', ascending: false);

      print('✅ Found ${response.length} forums');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching forums: $e');
      rethrow;
    }
  }

  // Get all recent posts across all forums
  Future<List<Map<String, dynamic>>> getAllRecentPosts() async {
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

      print('✅ Found ${response.length} recent posts');
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching recent posts: $e');
      rethrow;
    }
  }

  // Get forum by ID with posts
  Future<Map<String, dynamic>?> getForumById(String forumId) async {
    try {
      final response = await _supabase.from('forums').select('''
            *,
            creator:users!forums_created_by_fkey(name, email),
            posts:forum_posts(
              *,
              author:users!forum_posts_author_id_fkey(name, email),
              replies_count:forum_replies(count)
            )
          ''').eq('id', forumId).single();

      return response;
    } catch (e) {
      print('❌ Error fetching forum by ID: $e');
      return null;
    }
  }

  // Get posts for a forum
  Future<List<Map<String, dynamic>>> getForumPosts({
    required String forumId,
    int page = 0,
    int limit = 20,
  }) async {
    try {
      final from = page * limit;
      final to = from + limit - 1;

      final response = await _supabase
          .from('forum_posts')
          .select('''
            *,
            author:users!forum_posts_author_id_fkey(name, email),
            replies_count:forum_replies(count)
          ''')
          .eq('forum_id', forumId)
          .order('is_pinned', ascending: false)
          .order('created_at', ascending: false)
          .range(from, to);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching forum posts: $e');
      rethrow;
    }
  }

  // Get post by ID with replies
  Future<Map<String, dynamic>?> getPostById(String postId) async {
    try {
      final response = await _supabase.from('forum_posts').select('''
            *,
            author:users!forum_posts_author_id_fkey(name, email),
            forum:forums(*),
            replies:forum_replies(
              *,
              author:users!forum_replies_author_id_fkey(name, email)
            )
          ''').eq('id', postId).single();

      return response;
    } catch (e) {
      print('❌ Error fetching post by ID: $e');
      return null;
    }
  }

  // Create a new forum post
  Future<bool> createPost({
    required String forumId,
    required String authorId,
    required String title,
    required String content,
  }) async {
    try {
      print('📝 Creating forum post...');

      await _supabase.from('forum_posts').insert({
        'forum_id': forumId,
        'author_id': authorId,
        'title': title,
        'content': content,
      });

      print('✅ Forum post created successfully');
      return true;
    } catch (e) {
      print('❌ Error creating forum post: $e');
      return false;
    }
  }

  // Create a reply to a post
  Future<bool> createReply({
    required String postId,
    required String authorId,
    required String content,
    String? parentReplyId,
  }) async {
    try {
      print('💬 Creating forum reply...');

      await _supabase.from('forum_replies').insert({
        'post_id': postId,
        'author_id': authorId,
        'content': content,
        'parent_reply_id': parentReplyId,
      });

      // Update reply count
      await _supabase.rpc('increment_reply_count', params: {
        'post_id': postId,
      });

      print('✅ Forum reply created successfully');
      return true;
    } catch (e) {
      print('❌ Error creating forum reply: $e');
      return false;
    }
  }

  // Like/unlike a post
  Future<bool> togglePostLike({
    required String postId,
    required String userId,
  }) async {
    try {
      // Check if user already liked the post
      final existingLike = await _supabase
          .from('forum_likes')
          .select('id')
          .eq('post_id', postId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existingLike != null) {
        // Unlike the post
        await _supabase
            .from('forum_likes')
            .delete()
            .eq('post_id', postId)
            .eq('user_id', userId);

        // Decrement like count
        await _supabase.rpc('decrement_like_count', params: {
          'post_id': postId,
        });
      } else {
        // Like the post
        await _supabase.from('forum_likes').insert({
          'post_id': postId,
          'user_id': userId,
        });

        // Increment like count
        await _supabase.rpc('increment_like_count', params: {
          'post_id': postId,
        });
      }

      return true;
    } catch (e) {
      print('❌ Error toggling post like: $e');
      return false;
    }
  }

  // Like/unlike a reply
  Future<bool> toggleReplyLike({
    required String replyId,
    required String userId,
  }) async {
    try {
      // Check if user already liked the reply
      final existingLike = await _supabase
          .from('forum_likes')
          .select('id')
          .eq('reply_id', replyId)
          .eq('user_id', userId)
          .maybeSingle();

      if (existingLike != null) {
        // Unlike the reply
        await _supabase
            .from('forum_likes')
            .delete()
            .eq('reply_id', replyId)
            .eq('user_id', userId);
      } else {
        // Like the reply
        await _supabase.from('forum_likes').insert({
          'reply_id': replyId,
          'user_id': userId,
        });
      }

      return true;
    } catch (e) {
      print('❌ Error toggling reply like: $e');
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

  // Leave a forum
  Future<bool> leaveForum({
    required String forumId,
    required String userId,
  }) async {
    try {
      await _supabase
          .from('forum_members')
          .delete()
          .eq('forum_id', forumId)
          .eq('user_id', userId);

      return true;
    } catch (e) {
      print('❌ Error leaving forum: $e');
      return false;
    }
  }

  // Check if user is member of forum
  Future<bool> isForumMember({
    required String forumId,
    required String userId,
  }) async {
    try {
      final response = await _supabase
          .from('forum_members')
          .select('id')
          .eq('forum_id', forumId)
          .eq('user_id', userId)
          .maybeSingle();

      return response != null;
    } catch (e) {
      print('❌ Error checking forum membership: $e');
      return false;
    }
  }

  // Search forums and posts
  Future<List<Map<String, dynamic>>> searchForumsAndPosts({
    required String query,
    int page = 0,
    int limit = 20,
  }) async {
    try {
      final from = page * limit;
      final to = from + limit - 1;

      // Search forums
      final forumsResponse = await _supabase
          .from('forums')
          .select('''
            *,
            creator:users!forums_created_by_fkey(name, email)
          ''')
          .or('name.ilike.%$query%,description.ilike.%$query%')
          .eq('is_public', true)
          .range(from, to);

      // Search posts
      final postsResponse = await _supabase
          .from('forum_posts')
          .select('''
            *,
            author:users!forum_posts_author_id_fkey(name, email),
            forum:forums(*)
          ''')
          .or('title.ilike.%$query%,content.ilike.%$query%')
          .range(from, to);

      // Combine results
      final results = <Map<String, dynamic>>[];
      results.addAll(forumsResponse.map((forum) => {
            ...forum,
            'type': 'forum',
          }));
      results.addAll(postsResponse.map((post) => {
            ...post,
            'type': 'post',
          }));

      // Sort by relevance (you could implement more sophisticated ranking)
      results.sort((a, b) => b['created_at'].compareTo(a['created_at']));

      return results;
    } catch (e) {
      print('❌ Error searching forums and posts: $e');
      rethrow;
    }
  }

  // Get user's forum activity
  Future<List<Map<String, dynamic>>> getUserForumActivity(String userId) async {
    try {
      final response = await _supabase.from('forum_posts').select('''
            *,
            forum:forums(*)
          ''').eq('author_id', userId).order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching user forum activity: $e');
      rethrow;
    }
  }

  // Update post view count
  Future<void> incrementPostViewCount(String postId) async {
    try {
      await _supabase.rpc('increment_view_count', params: {
        'post_id': postId,
      });
    } catch (e) {
      print('❌ Error incrementing post view count: $e');
    }
  }
}
