import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            onPressed: () => context.go('/chat/new'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildChatItem(
            name: 'Ethan Carter',
            lastMessage: 'Thanks for the mentorship session!',
            time: '2 min ago',
            unreadCount: 1,
            isOnline: true,
            onTap: () => context.go('/chat/1'),
          ),
          const SizedBox(height: 12),
          _buildChatItem(
            name: 'Olivia Bennett',
            lastMessage: 'When is our next meeting?',
            time: '1 hour ago',
            unreadCount: 0,
            isOnline: false,
            onTap: () => context.go('/chat/2'),
          ),
          const SizedBox(height: 12),
          _buildChatItem(
            name: 'Noah Thompson',
            lastMessage: 'I\'ll review your resume and get back to you',
            time: '3 hours ago',
            unreadCount: 2,
            isOnline: true,
            onTap: () => context.go('/chat/3'),
          ),
          const SizedBox(height: 12),
          _buildChatItem(
            name: 'Sarah Chen',
            lastMessage: 'The webinar was very informative',
            time: '1 day ago',
            unreadCount: 0,
            isOnline: false,
            onTap: () => context.go('/chat/4'),
          ),
          const SizedBox(height: 12),
          _buildChatItem(
            name: 'Mike Davis',
            lastMessage: 'Looking forward to our session',
            time: '2 days ago',
            unreadCount: 0,
            isOnline: false,
            onTap: () => context.go('/chat/5'),
          ),
        ],
      ),
    );
  }

  Widget _buildChatItem({
    required String name,
    required String lastMessage,
    required String time,
    required int unreadCount,
    required bool isOnline,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Text(
                    name.split(' ').map((e) => e[0]).join(''),
                    style: const TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (isOnline)
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: AppTheme.successColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),

            const SizedBox(width: 16),

            // Chat Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        time,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          lastMessage,
                          style: const TextStyle(
                            color: AppTheme.textSecondary,
                            fontSize: 14,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            unreadCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
