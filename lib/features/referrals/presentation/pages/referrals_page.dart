import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';

class ReferralsPage extends StatelessWidget {
  const ReferralsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        title: const Text('Referrals'),
        actions: [
          IconButton(
            onPressed: () => context.go('/referrals/request'),
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
              'Referral Requests',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Connect with alumni for career opportunities',
              style: TextStyle(
                color: AppTheme.textSecondary,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 32),

            // Active Requests
            const Text(
              'Active Requests',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildReferralCard(
              company: 'Google',
              position: 'Software Engineer Intern',
              studentName: 'Alex Johnson',
              status: 'Pending',
              date: 'Dec 10, 2024',
              onTap: () => context.go('/referrals/1'),
            ),

            const SizedBox(height: 16),

            _buildReferralCard(
              company: 'Microsoft',
              position: 'Product Manager',
              studentName: 'Sarah Chen',
              status: 'Under Review',
              date: 'Dec 8, 2024',
              onTap: () => context.go('/referrals/2'),
            ),

            const SizedBox(height: 24),

            // Completed Referrals
            const Text(
              'Completed Referrals',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            _buildReferralCard(
              company: 'Amazon',
              position: 'Data Analyst',
              studentName: 'Mike Davis',
              status: 'Accepted',
              date: 'Nov 25, 2024',
              onTap: () => context.go('/referrals/3'),
              isCompleted: true,
            ),

            const SizedBox(height: 16),

            _buildReferralCard(
              company: 'Netflix',
              position: 'UX Designer',
              studentName: 'Emily Wilson',
              status: 'Rejected',
              date: 'Nov 20, 2024',
              onTap: () => context.go('/referrals/4'),
              isCompleted: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReferralCard({
    required String company,
    required String position,
    required String studentName,
    required String status,
    required String date,
    required VoidCallback onTap,
    bool isCompleted = false,
  }) {
    Color statusColor;
    switch (status.toLowerCase()) {
      case 'pending':
        statusColor = AppTheme.warningColor;
        break;
      case 'under review':
        statusColor = AppTheme.primaryColor;
        break;
      case 'accepted':
        statusColor = AppTheme.successColor;
        break;
      case 'rejected':
        statusColor = AppTheme.errorColor;
        break;
      default:
        statusColor = AppTheme.textSecondary;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
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
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.business,
                    color: AppTheme.primaryColor,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        company,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        position,
                        style: const TextStyle(
                          color: AppTheme.textSecondary,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoChip(
                  icon: Icons.person,
                  label: studentName,
                ),
                const SizedBox(width: 12),
                _buildInfoChip(
                  icon: Icons.calendar_today,
                  label: date,
                ),
              ],
            ),
            if (!isCompleted) ...[
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Implement accept logic
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.successColor,
                        side: const BorderSide(color: AppTheme.successColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Accept'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Implement reject logic
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.errorColor,
                        side: const BorderSide(color: AppTheme.errorColor),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                ],
              ),
            ],
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppTheme.textSecondary,
          ),
          const SizedBox(width: 6),
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
