import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/features/auth/bloc/auth_bloc.dart';
import 'package:connectu_alumni_platform/core/utils/navigation_utils.dart';
import 'package:connectu_alumni_platform/features/notifications/data/services/notification_service.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';

class EnhancedNotificationsPage extends StatefulWidget {
  const EnhancedNotificationsPage({super.key});

  @override
  State<EnhancedNotificationsPage> createState() =>
      _EnhancedNotificationsPageState();
}

class _EnhancedNotificationsPageState extends State<EnhancedNotificationsPage>
    with TickerProviderStateMixin {
  final NotificationService _notificationService = NotificationService();
  late TabController _tabController;

  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  int _unreadCount = 0;
  int _totalCount = 0;
  int _todayCount = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadNotifications();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final authState = context.read<AuthBloc>().state;
      if (authState is Authenticated) {
        final userId = authState.user.user.id.toString();

        // Load notifications
        final notifications =
            await _notificationService.getUserNotifications(userId: userId);

        // Get stats
        final stats = await _notificationService.getNotificationStats(userId);

        setState(() {
          _notifications = notifications;
          _unreadCount = (stats['unread'] ?? 0) as int;
          _totalCount = (stats['total'] ?? 0) as int;
          _todayCount = (stats['today'] ?? 0) as int;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('❌ Error loading notifications: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _markAsRead(String notificationId) async {
    final success = await _notificationService.markAsRead(notificationId);
    if (success) {
      setState(() {
        final index =
            _notifications.indexWhere((n) => n['id'] == notificationId);
        if (index != -1) {
          _notifications[index]['is_read'] = true;
          _notifications[index]['read_at'] = DateTime.now().toIso8601String();
          _unreadCount = (_unreadCount - 1).clamp(0, _unreadCount);
        }
      });
    }
  }

  Future<void> _markAllAsRead() async {
    final authState = context.read<AuthBloc>().state;
    if (authState is Authenticated) {
      final userId = authState.user.user.id.toString();
      final success = await _notificationService.markAllAsRead(userId);
      if (success) {
        setState(() {
          for (var notification in _notifications) {
            notification['is_read'] = true;
            notification['read_at'] = DateTime.now().toIso8601String();
          }
          _unreadCount = 0;
        });
      }
    }
  }

  Future<void> _deleteNotification(String notificationId) async {
    final success =
        await _notificationService.deleteNotification(notificationId);
    if (success) {
      setState(() {
        _notifications.removeWhere((n) => n['id'] == notificationId);
        _totalCount--;
        if (!_notifications
            .any((n) => n['id'] == notificationId && !n['is_read'])) {
          _unreadCount = (_unreadCount - 1).clamp(0, _unreadCount);
        }
      });
    }
  }

  List<Map<String, dynamic>> get _filteredNotifications {
    switch (_tabController.index) {
      case 0: // All
        return _notifications;
      case 1: // Unread
        return _notifications.where((n) => !n['is_read']).toList();
      case 2: // Today
        final today = DateTime.now();
        return _notifications.where((n) {
          final createdAt = DateTime.parse(n['created_at']);
          return createdAt.year == today.year &&
              createdAt.month == today.month &&
              createdAt.day == today.day;
        }).toList();
      case 3: // Important
        return _notifications
            .where((n) =>
                n['type'] == 'system' ||
                n['type'] == 'mentorship' ||
                n['type'] == 'payment')
            .toList();
      default:
        return _notifications;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        leading: NavigationUtils.roleAwareBackButton(
          context: context,
          iconColor: const Color(0xFF0E141B),
          iconSize: 24,
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF0E141B),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: -0.015,
          ),
        ),
        centerTitle: true,
        actions: [
          if (_unreadCount > 0)
            IconButton(
              onPressed: _markAllAsRead,
              icon: const Icon(
                Icons.done_all,
                color: Color(0xFF0E141B),
                size: 24,
              ),
              tooltip: 'Mark all as read',
            ),
          IconButton(
            onPressed: () => _showNotificationSettings(),
            icon: const Icon(
              Icons.settings,
              color: Color(0xFF0E141B),
              size: 24,
            ),
            tooltip: 'Notification settings',
          ),
        ],
      ),
      body: Column(
        children: [
          // Stats Cards
          _buildStatsCards(),

          // Tab Bar
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppTheme.primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: AppTheme.primaryColor,
              isScrollable: true,
              onTap: (index) => setState(() {}),
              tabs: [
                Tab(text: 'All ($_totalCount)'),
                Tab(text: 'Unread ($_unreadCount)'),
                Tab(text: 'Today ($_todayCount)'),
                const Tab(text: 'Important'),
              ],
            ),
          ),

          // Notifications List
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredNotifications.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadNotifications,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredNotifications.length,
                          itemBuilder: (context, index) {
                            final notification = _filteredNotifications[index];
                            return _buildNotificationItem(notification);
                          },
                        ),
                      ),
          ),
        ],
      ),
      bottomNavigationBar: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String userRole = 'student';
          if (state is Authenticated) {
            userRole = state.user.user.role.name;
          }

          return Container(
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: Color(0xFFE7EDF3), width: 1),
              ),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: 3, // Notifications tab
              onTap: (index) {
                switch (index) {
                  case 0:
                    if (userRole == 'alumni') {
                      context.go('/alumni-dashboard');
                    } else {
                      context.go('/student-dashboard');
                    }
                    break;
                  case 1:
                    if (userRole == 'alumni') {
                      context.go('/alumni-network');
                    } else {
                      context.go('/alumni');
                    }
                    break;
                  case 2:
                    if (userRole == 'alumni') {
                      context.go('/alumni-mentorship');
                    } else {
                      context.go('/mentorship');
                    }
                    break;
                  case 3:
                    // Already on notifications
                    break;
                  case 4:
                    if (userRole == 'alumni') {
                      context.go('/referrals');
                    }
                    break;
                }
              },
              selectedItemColor: const Color(0xFF0E141B),
              unselectedItemColor: const Color(0xFF4E7097),
              backgroundColor: const Color(0xFFF8FAFC),
              elevation: 0,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.dashboard),
                  label: 'Dashboard',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.people),
                  label: 'Network',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.people_alt),
                  label: 'Mentorship',
                ),
                BottomNavigationBarItem(
                  icon: Stack(
                    children: [
                      const Icon(Icons.notifications),
                      if (_unreadCount > 0)
                        Positioned(
                          right: 0,
                          top: 0,
                          child: Container(
                            padding: const EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            constraints: const BoxConstraints(
                              minWidth: 12,
                              minHeight: 12,
                            ),
                            child: Text(
                              _unreadCount > 99
                                  ? '99+'
                                  : _unreadCount.toString(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  label: 'Notifications',
                ),
                if (userRole == 'alumni')
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.handshake),
                    label: 'Referrals',
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatsCards() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total',
              _totalCount.toString(),
              Icons.notifications,
              Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Unread',
              _unreadCount.toString(),
              Icons.notifications_active,
              Colors.red,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Today',
              _todayCount.toString(),
              Icons.today,
              Colors.green,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_none,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _tabController.index == 1
                ? 'No unread notifications'
                : _tabController.index == 2
                    ? 'No notifications today'
                    : _tabController.index == 3
                        ? 'No important notifications'
                        : 'No notifications yet',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You\'ll see notifications here when you receive them',
            style: TextStyle(
              fontSize: 14,
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    final isUnread = !notification['is_read'];
    final type = notification['type'] as String;
    final createdAt = DateTime.parse(notification['created_at']);
    final timeAgo = _getTimeAgo(createdAt);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: isUnread
            ? Border.all(color: AppTheme.primaryColor.withOpacity(0.3))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          if (isUnread) {
            _markAsRead(notification['id']);
          }
          _handleNotificationTap(notification);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Notification Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getNotificationColor(type).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getNotificationIcon(type),
                  color: _getNotificationColor(type),
                  size: 24,
                ),
              ),

              const SizedBox(width: 16),

              // Notification Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            notification['title'] ?? 'Notification',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight:
                                  isUnread ? FontWeight.bold : FontWeight.w600,
                              color: const Color(0xFF0E141B),
                            ),
                          ),
                        ),
                        if (isUnread)
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppTheme.primaryColor,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      notification['message'] ?? '',
                      style: const TextStyle(
                        color: Color(0xFF4E7097),
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getNotificationColor(type).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            _getNotificationTypeLabel(type),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getNotificationColor(type),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          timeAgo,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF9CA3AF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              PopupMenuButton<String>(
                onSelected: (value) {
                  switch (value) {
                    case 'mark_read':
                      if (isUnread) _markAsRead(notification['id']);
                      break;
                    case 'delete':
                      _deleteNotification(notification['id']);
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (isUnread)
                    const PopupMenuItem(
                      value: 'mark_read',
                      child: Row(
                        children: [
                          Icon(Icons.mark_email_read, size: 16),
                          SizedBox(width: 8),
                          Text('Mark as read'),
                        ],
                      ),
                    ),
                  const PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, size: 16, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete', style: TextStyle(color: Colors.red)),
                      ],
                    ),
                  ),
                ],
                child: const Icon(
                  Icons.more_vert,
                  color: Color(0xFF9CA3AF),
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleNotificationTap(Map<String, dynamic> notification) {
    final actionUrl = notification['action_url'] as String?;
    if (actionUrl != null && actionUrl.isNotEmpty) {
      context.go(actionUrl);
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'mentorship':
        return Icons.people_alt;
      case 'webinar':
        return Icons.video_library;
      case 'referral':
        return Icons.handshake;
      case 'chat':
        return Icons.chat;
      case 'system':
        return Icons.notifications;
      case 'payment':
        return Icons.payment;
      case 'event':
        return Icons.event;
      case 'job':
        return Icons.work;
      case 'reminder':
        return Icons.schedule;
      case 'achievement':
        return Icons.emoji_events;
      case 'message':
        return Icons.message;
      case 'connection':
        return Icons.person_add;
      default:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'mentorship':
        return Colors.orange;
      case 'webinar':
        return Colors.purple;
      case 'referral':
        return Colors.green;
      case 'chat':
        return Colors.blue;
      case 'system':
        return Colors.grey;
      case 'payment':
        return Colors.green;
      case 'event':
        return Colors.red;
      case 'job':
        return Colors.indigo;
      case 'reminder':
        return Colors.amber;
      case 'achievement':
        return Colors.yellow[700]!;
      case 'message':
        return Colors.cyan;
      case 'connection':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  String _getNotificationTypeLabel(String type) {
    switch (type) {
      case 'mentorship':
        return 'Mentorship';
      case 'webinar':
        return 'Webinar';
      case 'referral':
        return 'Referral';
      case 'chat':
        return 'Chat';
      case 'system':
        return 'System';
      case 'payment':
        return 'Payment';
      case 'event':
        return 'Event';
      case 'job':
        return 'Job';
      case 'reminder':
        return 'Reminder';
      case 'achievement':
        return 'Achievement';
      case 'message':
        return 'Message';
      case 'connection':
        return 'Connection';
      default:
        return 'Notification';
    }
  }

  String _getTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _buildNotificationSettingsSheet(),
    );
  }

  Widget _buildNotificationSettingsSheet() {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Notification Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Color(0xFF6B7280)),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notification Preferences',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSettingTile(
                        'Push Notifications',
                        'Receive push notifications on your device',
                        true,
                        (value) {},
                      ),
                      _buildSettingTile(
                        'Email Notifications',
                        'Receive notifications via email',
                        true,
                        (value) {},
                      ),
                      _buildSettingTile(
                        'Mentorship Notifications',
                        'Get notified about mentorship activities',
                        true,
                        (value) {},
                      ),
                      _buildSettingTile(
                        'Event Notifications',
                        'Get notified about upcoming events',
                        true,
                        (value) {},
                      ),
                      _buildSettingTile(
                        'Job Notifications',
                        'Get notified about new job opportunities',
                        true,
                        (value) {},
                      ),
                      _buildSettingTile(
                        'System Notifications',
                        'Receive important system updates',
                        true,
                        (value) {},
                      ),
                      _buildSettingTile(
                        'Marketing Notifications',
                        'Receive promotional content and updates',
                        false,
                        (value) {},
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSettingTile(
      String title, String subtitle, bool value, ValueChanged<bool> onChanged) {
    return SwitchListTile(
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Color(0xFF1F2937),
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14,
          color: Color(0xFF6B7280),
        ),
      ),
      value: value,
      onChanged: onChanged,
      activeThumbColor: AppTheme.primaryColor,
    );
  }
}
