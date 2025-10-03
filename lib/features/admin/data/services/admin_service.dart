import 'package:supabase_flutter/supabase_flutter.dart';

class AdminService {
  final SupabaseClient _supabase = Supabase.instance.client;

  // User Management
  Future<List<Map<String, dynamic>>> getAllUsers({
    int page = 0,
    int limit = 20,
    String? role,
    String? searchQuery,
  }) async {
    try {
      var query = _supabase.from('users').select('''
        *,
        alumnidetails(*),
        studentdetails(*)
      ''');

      if (role != null && role != 'all') {
        query = query.eq('role', role);
      }

      if (searchQuery != null && searchQuery.isNotEmpty) {
        query =
            query.or('name.ilike.%$searchQuery%,email.ilike.%$searchQuery%');
      }

      final from = page * limit;
      final to = from + limit - 1;
      final response =
          await query.order('created_at', ascending: false).range(from, to);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching users: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getUserById(String userId) async {
    try {
      final response = await _supabase.from('users').select('''
            *,
            alumnidetails(*),
            studentdetails(*)
          ''').eq('id', userId).single();

      return Map<String, dynamic>.from(response);
    } catch (e) {
      print('❌ Error fetching user by ID: $e');
      rethrow;
    }
  }

  Future<bool> updateUserRole(String userId, String newRole) async {
    try {
      await _supabase.from('users').update({'role': newRole}).eq('id', userId);

      return true;
    } catch (e) {
      print('❌ Error updating user role: $e');
      return false;
    }
  }

  Future<bool> suspendUser(String userId, bool isSuspended) async {
    try {
      await _supabase
          .from('users')
          .update({'is_suspended': isSuspended}).eq('id', userId);

      return true;
    } catch (e) {
      print('❌ Error suspending user: $e');
      return false;
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      await _supabase.from('users').delete().eq('id', userId);
      return true;
    } catch (e) {
      print('❌ Error deleting user: $e');
      return false;
    }
  }

  // Content Management
  Future<List<Map<String, dynamic>>> getReportedContent({
    int page = 0,
    int limit = 20,
  }) async {
    try {
      final from = page * limit;
      final to = from + limit - 1;
      final response = await _supabase.from('reports').select('''
            *,
            reporter:users!reports_reporter_id_fkey(name, email),
            reported_content:posts!reports_content_id_fkey(*)
          ''').order('created_at', ascending: false).range(from, to);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching reported content: $e');
      rethrow;
    }
  }

  Future<bool> moderateContent(
      String contentId, String action, String? reason) async {
    try {
      if (action == 'approve') {
        await _supabase
            .from('posts')
            .update({'is_approved': true, 'moderation_notes': reason}).eq(
                'id', contentId);
      } else if (action == 'reject') {
        await _supabase
            .from('posts')
            .update({'is_approved': false, 'moderation_notes': reason}).eq(
                'id', contentId);
      } else if (action == 'delete') {
        await _supabase.from('posts').delete().eq('id', contentId);
      }

      return true;
    } catch (e) {
      print('❌ Error moderating content: $e');
      return false;
    }
  }

  // Analytics
  Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      // Get user counts by role
      final userStats =
          await _supabase.from('users').select('role').then((data) {
        final stats = <String, int>{};
        for (final user in data) {
          final role = user['role'] as String;
          stats[role] = (stats[role] ?? 0) + 1;
        }
        return stats;
      });

      // Get recent activity counts
      final today = DateTime.now();
      final weekAgo = today.subtract(const Duration(days: 7));

      final recentUsers = await _supabase
          .from('users')
          .select('id')
          .gte('created_at', weekAgo.toIso8601String())
          .then((data) => data.length);

      // Try to get posts count, but handle if table doesn't exist
      int recentPosts = 0;
      try {
        recentPosts = await _supabase
            .from('posts')
            .select('id')
            .gte('created_at', weekAgo.toIso8601String())
            .then((data) => data.length);
      } catch (e) {
        print('⚠️ Posts table not found, using forum_posts instead');
        try {
          recentPosts = await _supabase
              .from('forum_posts')
              .select('id')
              .gte('created_at', weekAgo.toIso8601String())
              .then((data) => data.length);
        } catch (e2) {
          print('⚠️ Forum posts table not found, using 0');
          recentPosts = 0;
        }
      }

      // Try to get active users, but handle if last_active column doesn't exist
      int activeUsers = 0;
      try {
        activeUsers = await _supabase
            .from('users')
            .select('id')
            .gte('last_active', weekAgo.toIso8601String())
            .then((data) => data.length);
      } catch (e) {
        print('⚠️ last_active column not found, using recent users as active');
        activeUsers = recentUsers;
      }

      // Get pending reports count
      int pendingReports = 0;
      try {
        pendingReports = await _supabase
            .from('bug_reports')
            .select('id')
            .eq('status', 'pending')
            .then((data) => data.length);
      } catch (e) {
        print('⚠️ Bug reports table not found, using 0');
        pendingReports = 0;
      }

      return {
        'totalUsers': userStats.values.fold(0, (sum, count) => sum + count),
        'students': userStats['student'] ?? 0,
        'alumni': userStats['alumni'] ?? 0,
        'admins': userStats['admin'] ?? 0,
        'recentUsers': recentUsers,
        'recentPosts': recentPosts,
        'activeUsers': activeUsers,
        'pendingReports': pendingReports,
      };
    } catch (e) {
      print('❌ Error fetching dashboard stats: $e');
      // Return default stats if there's an error
      return {
        'totalUsers': 0,
        'students': 0,
        'alumni': 0,
        'admins': 0,
        'recentUsers': 0,
        'recentPosts': 0,
        'activeUsers': 0,
        'pendingReports': 0,
      };
    }
  }

  Future<List<Map<String, dynamic>>> getUserGrowthData({int days = 30}) async {
    try {
      final endDate = DateTime.now();
      final startDate = endDate.subtract(Duration(days: days));

      final response = await _supabase
          .from('users')
          .select('created_at')
          .gte('created_at', startDate.toIso8601String())
          .lte('created_at', endDate.toIso8601String())
          .order('created_at');

      // Group by date
      final Map<String, int> dailyCounts = {};
      for (final user in response) {
        final date =
            DateTime.parse(user['created_at']).toIso8601String().split('T')[0];
        dailyCounts[date] = (dailyCounts[date] ?? 0) + 1;
      }

      // Convert to list format
      final List<Map<String, dynamic>> result = [];
      for (int i = 0; i < days; i++) {
        final date =
            startDate.add(Duration(days: i)).toIso8601String().split('T')[0];
        result.add({
          'date': date,
          'count': dailyCounts[date] ?? 0,
        });
      }

      return result;
    } catch (e) {
      print('❌ Error fetching user growth data: $e');
      rethrow;
    }
  }

  // System Management
  Future<bool> createAnnouncement({
    required String title,
    required String content,
    required String type,
    List<String>? targetRoles,
  }) async {
    try {
      await _supabase.from('announcements').insert({
        'title': title,
        'content': content,
        'type': type,
        'target_roles': targetRoles,
        'created_by': _supabase.auth.currentUser?.id,
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('❌ Error creating announcement: $e');
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> getAnnouncements() async {
    try {
      final response = await _supabase.from('announcements').select('''
            *,
            creator:users!announcements_created_by_fkey(name, email)
          ''').order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching announcements: $e');
      rethrow;
    }
  }

  Future<bool> updateSystemSettings(Map<String, dynamic> settings) async {
    try {
      for (final entry in settings.entries) {
        await _supabase.from('platform_settings').upsert({
          'key': entry.key,
          'value': entry.value,
          'updated_at': DateTime.now().toIso8601String(),
        });
      }

      return true;
    } catch (e) {
      print('❌ Error updating system settings: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>> getSystemSettings() async {
    try {
      final response =
          await _supabase.from('platform_settings').select('key, value');

      final settings = <String, dynamic>{};
      for (final setting in response) {
        settings[setting['key']] = setting['value'];
      }

      return settings;
    } catch (e) {
      print('❌ Error fetching system settings: $e');
      rethrow;
    }
  }

  // Logs and Monitoring
  Future<List<Map<String, dynamic>>> getAdminLogs({
    int page = 0,
    int limit = 50,
    String? action,
  }) async {
    try {
      var query = _supabase.from('admin_actions').select('''
        *,
        admin:users!admin_actions_admin_id_fkey(name, email)
      ''');

      if (action != null && action != 'all') {
        query = query.eq('action', action);
      }

      final from = page * limit;
      final to = from + limit - 1;
      final response =
          await query.order('created_at', ascending: false).range(from, to);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching admin logs: $e');
      rethrow;
    }
  }

  Future<bool> logAdminAction({
    required String action,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _supabase.from('admin_actions').insert({
        'admin_id': _supabase.auth.currentUser?.id,
        'action': action,
        'description': description,
        'metadata': metadata,
        'created_at': DateTime.now().toIso8601String(),
      });

      return true;
    } catch (e) {
      print('❌ Error logging admin action: $e');
      return false;
    }
  }

  // Backup and Maintenance
  Future<bool> triggerBackup() async {
    try {
      // This would typically trigger a database backup
      // For now, we'll just log the action
      await logAdminAction(
        action: 'backup_triggered',
        description: 'Manual backup triggered by admin',
      );

      return true;
    } catch (e) {
      print('❌ Error triggering backup: $e');
      return false;
    }
  }

  Future<bool> performMaintenance({
    required String type,
    required String description,
  }) async {
    try {
      await logAdminAction(
        action: 'maintenance',
        description: description,
        metadata: {'type': type},
      );

      return true;
    } catch (e) {
      print('❌ Error performing maintenance: $e');
      return false;
    }
  }
}
