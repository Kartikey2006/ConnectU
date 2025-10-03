import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:convert';

class NotificationService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Send a notification to a specific user
  Future<bool> sendNotification({
    required String userId,
    required String title,
    required String message,
    required NotificationType type,
    String? actionUrl,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _supabase.from('notifications').insert({
        'user_id': userId,
        'title': title,
        'message': message,
        'type': type.name,
        'action_url': actionUrl,
        'metadata': metadata != null ? jsonEncode(metadata) : null,
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('❌ Error sending notification: $e');
      return false;
    }
  }

  /// Send notification to multiple users
  Future<bool> sendBulkNotification({
    required List<String> userIds,
    required String title,
    required String message,
    required NotificationType type,
    String? actionUrl,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final notifications = userIds
          .map((userId) => {
                'user_id': userId,
                'title': title,
                'message': message,
                'type': type.name,
                'action_url': actionUrl,
                'metadata': metadata != null ? jsonEncode(metadata) : null,
                'is_read': false,
                'created_at': DateTime.now().toIso8601String(),
              })
          .toList();

      await _supabase.from('notifications').insert(notifications);
      return true;
    } catch (e) {
      print('❌ Error sending bulk notification: $e');
      return false;
    }
  }

  /// Get notifications for a user
  Future<List<Map<String, dynamic>>> getUserNotifications({
    required String userId,
    int limit = 50,
    int offset = 0,
    bool? isRead,
  }) async {
    try {
      var query = _supabase
          .from('notifications')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      if (isRead != null) {
        query = query.eq('is_read', isRead);
      }

      final response = await query.range(offset, offset + limit - 1);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('❌ Error fetching notifications: $e');
      return [];
    }
  }

  /// Mark notification as read
  Future<bool> markAsRead(String notificationId) async {
    try {
      await _supabase.from('notifications').update({
        'is_read': true,
        'read_at': DateTime.now().toIso8601String()
      }).eq('id', notificationId);
      return true;
    } catch (e) {
      print('❌ Error marking notification as read: $e');
      return false;
    }
  }

  /// Mark all notifications as read for a user
  Future<bool> markAllAsRead(String userId) async {
    try {
      await _supabase
          .from('notifications')
          .update(
              {'is_read': true, 'read_at': DateTime.now().toIso8601String()})
          .eq('user_id', userId)
          .eq('is_read', false);
      return true;
    } catch (e) {
      print('❌ Error marking all notifications as read: $e');
      return false;
    }
  }

  /// Delete a notification
  Future<bool> deleteNotification(String notificationId) async {
    try {
      await _supabase.from('notifications').delete().eq('id', notificationId);
      return true;
    } catch (e) {
      print('❌ Error deleting notification: $e');
      return false;
    }
  }

  /// Get unread notification count
  Future<int> getUnreadCount(String userId) async {
    try {
      final response = await _supabase
          .from('notifications')
          .select('id')
          .eq('user_id', userId)
          .eq('is_read', false);
      return response.length;
    } catch (e) {
      print('❌ Error getting unread count: $e');
      return 0;
    }
  }

  /// Send event notification
  Future<bool> sendEventNotification({
    required String eventId,
    required String title,
    required String message,
    required List<String> userIds,
    String? actionUrl,
  }) async {
    return await sendBulkNotification(
      userIds: userIds,
      title: title,
      message: message,
      type: NotificationType.event,
      actionUrl: actionUrl ?? '/events/$eventId',
      metadata: {'event_id': eventId},
    );
  }

  /// Send mentorship notification
  Future<bool> sendMentorshipNotification({
    required String menteeId,
    required String mentorId,
    required String title,
    required String message,
    required NotificationType type,
    String? sessionId,
  }) async {
    final userIds = [menteeId, mentorId];
    return await sendBulkNotification(
      userIds: userIds,
      title: title,
      message: message,
      type: type,
      actionUrl:
          sessionId != null ? '/mentorship/session/$sessionId' : '/mentorship',
      metadata: {
        'session_id': sessionId,
        'mentee_id': menteeId,
        'mentor_id': mentorId
      },
    );
  }

  /// Send job notification
  Future<bool> sendJobNotification({
    required String userId,
    required String title,
    required String message,
    required String jobId,
    NotificationType type = NotificationType.job,
  }) async {
    return await sendNotification(
      userId: userId,
      title: title,
      message: message,
      type: type,
      actionUrl: '/jobs/$jobId',
      metadata: {'job_id': jobId},
    );
  }

  /// Send system notification to all users
  Future<bool> sendSystemNotification({
    required String title,
    required String message,
    String? actionUrl,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Get all active users
      final users = await _supabase
          .from('users')
          .select('supabase_auth_id')
          .eq('is_active', true);

      final userIds =
          users.map((user) => user['supabase_auth_id'] as String).toList();

      return await sendBulkNotification(
        userIds: userIds,
        title: title,
        message: message,
        type: NotificationType.system,
        actionUrl: actionUrl,
        metadata: metadata,
      );
    } catch (e) {
      print('❌ Error sending system notification: $e');
      return false;
    }
  }

  /// Send welcome notification to new user
  Future<bool> sendWelcomeNotification(String userId, String userRole) async {
    const title = 'Welcome to ConnectU Alumni Platform!';
    final message = userRole == 'alumni'
        ? 'Welcome! Start connecting with fellow alumni and sharing your expertise.'
        : 'Welcome! Explore mentorship opportunities and connect with alumni.';

    return await sendNotification(
      userId: userId,
      title: title,
      message: message,
      type: NotificationType.system,
      actionUrl:
          userRole == 'alumni' ? '/alumni-dashboard' : '/student-dashboard',
      metadata: {'welcome': true, 'user_role': userRole},
    );
  }

  /// Send reminder notification
  Future<bool> sendReminderNotification({
    required String userId,
    required String title,
    required String message,
    required String reminderType,
    String? actionUrl,
  }) async {
    return await sendNotification(
      userId: userId,
      title: title,
      message: message,
      type: NotificationType.reminder,
      actionUrl: actionUrl,
      metadata: {'reminder_type': reminderType},
    );
  }

  /// Get notification statistics
  Future<Map<String, dynamic>> getNotificationStats(String userId) async {
    try {
      final total = await _supabase
          .from('notifications')
          .select('id')
          .eq('user_id', userId);

      final unread = await _supabase
          .from('notifications')
          .select('id')
          .eq('user_id', userId)
          .eq('is_read', false);

      final today = await _supabase
          .from('notifications')
          .select('id')
          .eq('user_id', userId)
          .gte(
              'created_at',
              DateTime.now()
                  .subtract(const Duration(days: 1))
                  .toIso8601String());

      return {
        'total': total.length,
        'unread': unread.length,
        'today': today.length,
      };
    } catch (e) {
      print('❌ Error getting notification stats: $e');
      return {'total': 0, 'unread': 0, 'today': 0};
    }
  }

  /// Subscribe to real-time notifications
  Stream<List<Map<String, dynamic>>> subscribeToNotifications(String userId) {
    return _supabase
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(50);
  }
}

enum NotificationType {
  mentorship,
  webinar,
  referral,
  chat,
  system,
  payment,
  event,
  job,
  reminder,
  achievement,
  message,
  connection,
}
