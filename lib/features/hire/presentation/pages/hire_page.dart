import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';
import 'package:connectu_alumni_platform/core/widgets/modern_button.dart';

class HirePage extends StatelessWidget {
  const HirePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surfaceColor,
      appBar: AppBar(
        title: const Text(
          'HIRE',
          style: TextStyle(
            color: AppTheme.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppTheme.surfaceColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppTheme.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        color: AppTheme.surfaceColor,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Find & Hire Talent',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Connect with students and alumni to build your team',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        if (constraints.maxWidth > 400) {
                          return Row(
                            children: [
                              _buildStatCard('Active Jobs', '12', Icons.work),
                              const SizedBox(width: 12),
                              _buildStatCard('Shortlisted', '8', Icons.people),
                              const SizedBox(width: 12),
                              _buildStatCard('Hired', '5', Icons.check_circle),
                            ],
                          );
                        } else {
                          return Column(
                            children: [
                              Row(
                                children: [
                                  _buildStatCard(
                                      'Active Jobs', '12', Icons.work),
                                  const SizedBox(width: 12),
                                  _buildStatCard(
                                      'Shortlisted', '8', Icons.people),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _buildStatCard(
                                      'Hired', '5', Icons.check_circle),
                                  const SizedBox(width: 12),
                                  Expanded(child: Container()), // Spacer
                                ],
                              ),
                            ],
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Main Options Grid
              Text(
                'What would you like to do?',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 800) {
                    // Desktop layout - 3 columns
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.1,
                      children: [
                        _buildOptionCard(
                          context,
                          'Explore Resumes',
                          'Browse student profiles and resumes',
                          'Find talented students and recent graduates with skills that match your requirements',
                          Icons.assignment_ind_rounded,
                          AppTheme.primaryColor,
                          () => context.push('/hire/explore-resumes'),
                        ),
                        _buildOptionCard(
                          context,
                          'Hire Interns',
                          'View shortlisted candidates',
                          'Review and hire from your shortlisted student candidates',
                          Icons.work_history_rounded,
                          AppTheme.successColor,
                          () => context.push('/hire/hire-interns'),
                        ),
                        _buildOptionCard(
                          context,
                          'Post Job',
                          'Create new job opportunities',
                          'Post full-time, part-time, or internship opportunities for students',
                          Icons.add_business_rounded,
                          AppTheme.accentColor,
                          () => context.push('/hire/post-job'),
                        ),
                      ],
                    );
                  } else if (constraints.maxWidth > 500) {
                    // Tablet layout - 2 columns
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.2,
                      children: [
                        _buildOptionCard(
                          context,
                          'Explore Resumes',
                          'Browse student profiles and resumes',
                          'Find talented students and recent graduates with skills that match your requirements',
                          Icons.assignment_ind_rounded,
                          AppTheme.primaryColor,
                          () => context.push('/hire/explore-resumes'),
                        ),
                        _buildOptionCard(
                          context,
                          'Hire Interns',
                          'View shortlisted candidates',
                          'Review and hire from your shortlisted student candidates',
                          Icons.work_history_rounded,
                          AppTheme.successColor,
                          () => context.push('/hire/hire-interns'),
                        ),
                        _buildOptionCard(
                          context,
                          'Post Job',
                          'Create new job opportunities',
                          'Post full-time, part-time, or internship opportunities for students',
                          Icons.add_business_rounded,
                          AppTheme.accentColor,
                          () => context.push('/hire/post-job'),
                        ),
                      ],
                    );
                  } else {
                    // Mobile layout - single column
                    return Column(
                      children: [
                        _buildOptionCard(
                          context,
                          'Explore Resumes',
                          'Browse student profiles and resumes',
                          'Find talented students and recent graduates with skills that match your requirements',
                          Icons.assignment_ind_rounded,
                          AppTheme.primaryColor,
                          () => context.push('/hire/explore-resumes'),
                        ),
                        const SizedBox(height: 16),
                        _buildOptionCard(
                          context,
                          'Hire Interns',
                          'View shortlisted candidates',
                          'Review and hire from your shortlisted student candidates',
                          Icons.work_history_rounded,
                          AppTheme.successColor,
                          () => context.push('/hire/hire-interns'),
                        ),
                        const SizedBox(height: 16),
                        _buildOptionCard(
                          context,
                          'Post Job',
                          'Create new job opportunities',
                          'Post full-time, part-time, or internship opportunities for students',
                          Icons.add_business_rounded,
                          AppTheme.accentColor,
                          () => context.push('/hire/post-job'),
                        ),
                      ],
                    );
                  }
                },
              ),

              const SizedBox(height: 32),

              // Recent Activity
              Text(
                'Recent Activity',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              const SizedBox(height: 16),

              _buildRecentActivityCard(
                'New application received',
                'Rajesh Kumar applied for Software Engineer Intern',
                '2 hours ago',
                Icons.person_add,
                AppTheme.infoColor,
              ),
              const SizedBox(height: 12),
              _buildRecentActivityCard(
                'Job posted successfully',
                'Product Manager - Full Time posted and is now live',
                '1 day ago',
                Icons.check_circle,
                AppTheme.successColor,
              ),
              const SizedBox(height: 12),
              _buildRecentActivityCard(
                'Candidate shortlisted',
                'Priya Sharma shortlisted for Marketing Intern',
                '3 days ago',
                Icons.star,
                AppTheme.warningColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 24),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionCard(
    BuildContext context,
    String title,
    String subtitle,
    String description,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppTheme.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  color: AppTheme.textTertiary,
                  size: 14,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              description,
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                height: 1.3,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ModernButton(
                text: 'Get Started',
                onPressed: onTap,
                type: ModernButtonType.outline,
                size: ModernButtonSize.small,
                icon: Icons.arrow_forward,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivityCard(
    String title,
    String description,
    String time,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }
}
