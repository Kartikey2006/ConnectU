import 'package:flutter/material.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';

class WebinarDetailsPage extends StatelessWidget {
  final String webinarId;

  const WebinarDetailsPage({
    super.key,
    required this.webinarId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        title: const Text('Webinar Details'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Webinar Image
            AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                width: double.infinity,
                color: AppTheme.cardColor,
                child: const Icon(
                  Icons.video_call,
                  size: 64,
                  color: AppTheme.textSecondary,
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  const Text(
                    'Digital Marketing Trends 2024',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Host Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                        child: const Text(
                          'EC',
                          style: TextStyle(
                            color: AppTheme.primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ethan Carter',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Marketing Expert',
                            style: TextStyle(
                              color: AppTheme.textSecondary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Description
                  const Text(
                    'Description',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Join us for an insightful session on the latest digital marketing trends that will shape the industry in 2024. Learn about emerging technologies, consumer behavior changes, and strategies to stay ahead of the competition.',
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Details
                  const Text(
                    'Event Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildDetailRow(
                    icon: Icons.calendar_today,
                    label: 'Date',
                    value: 'December 20, 2024',
                  ),

                  const SizedBox(height: 12),

                  _buildDetailRow(
                    icon: Icons.access_time,
                    label: 'Time',
                    value: '2:00 PM - 3:30 PM',
                  ),

                  const SizedBox(height: 12),

                  _buildDetailRow(
                    icon: Icons.timer,
                    label: 'Duration',
                    value: '90 minutes',
                  ),

                  const SizedBox(height: 12),

                  _buildDetailRow(
                    icon: Icons.attach_money,
                    label: 'Price',
                    value: '\$25',
                  ),

                  const SizedBox(height: 12),

                  _buildDetailRow(
                    icon: Icons.people,
                    label: 'Capacity',
                    value: '100 participants',
                  ),

                  const SizedBox(height: 32),

                  // What You'll Learn
                  const Text(
                    'What You\'ll Learn',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  _buildLearningPoint(
                    'Emerging digital marketing technologies',
                  ),

                  _buildLearningPoint(
                    'Consumer behavior analysis and insights',
                  ),

                  _buildLearningPoint(
                    'Effective social media strategies',
                  ),

                  _buildLearningPoint(
                    'Data-driven marketing approaches',
                  ),

                  const SizedBox(height: 32),

                  // Register Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement registration logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Registration successful!'),
                            backgroundColor: AppTheme.successColor,
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Register for Webinar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppTheme.textSecondary,
          size: 20,
        ),
        const SizedBox(width: 12),
        Text(
          '$label: ',
          style: const TextStyle(
            color: AppTheme.textSecondary,
            fontSize: 16,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLearningPoint(String point) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppTheme.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              point,
              style: const TextStyle(
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
