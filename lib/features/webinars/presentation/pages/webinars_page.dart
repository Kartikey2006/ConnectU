import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';

class WebinarsPage extends StatelessWidget {
  const WebinarsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        title: const Text('Webinars'),
        actions: [
          IconButton(
            onPressed: () => context.go('/webinars/create'),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Upcoming Webinars',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Learn from industry experts and expand your knowledge',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 32),
            _buildWebinarCard(
              title: 'Digital Marketing Trends 2024',
              host: 'Ethan Carter',
              date: 'Dec 20, 2024',
              time: '2:00 PM',
              duration: '90 min',
              price: '\$25',
              imageUrl: 'https://example.com/webinar1.jpg',
              onTap: () => context.go('/webinars/1'),
            ),
            const SizedBox(height: 16),
            _buildWebinarCard(
              title: 'Product Management Fundamentals',
              host: 'Olivia Bennett',
              date: 'Dec 22, 2024',
              time: '3:00 PM',
              duration: '60 min',
              price: '\$20',
              imageUrl: 'https://example.com/webinar2.jpg',
              onTap: () => context.go('/webinars/2'),
            ),
            const SizedBox(height: 16),
            _buildWebinarCard(
              title: 'Financial Planning for Students',
              host: 'Noah Thompson',
              date: 'Dec 25, 2024',
              time: '1:00 PM',
              duration: '75 min',
              price: '\$15',
              imageUrl: 'https://example.com/webinar3.jpg',
              onTap: () => context.go('/webinars/3'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWebinarCard({
    required String title,
    required String host,
    required String date,
    required String time,
    required String duration,
    required String price,
    required String imageUrl,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Webinar Image
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  color: AppTheme.cardColor,
                  child: const Icon(
                    Icons.video_call,
                    size: 48,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ),

            // Webinar Info
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        child: Text(
                          host.split(' ').map((e) => e[0]).join(''),
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        host,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildInfoChip(
                        icon: Icons.calendar_today,
                        label: date,
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        icon: Icons.access_time,
                        label: time,
                      ),
                      const SizedBox(width: 8),
                      _buildInfoChip(
                        icon: Icons.timer,
                        label: duration,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: onTap,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text('Register'),
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

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
