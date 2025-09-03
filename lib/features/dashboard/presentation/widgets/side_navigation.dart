import 'package:flutter/material.dart';
import 'package:connectu_alumni_platform/core/theme/app_theme.dart';

class SideNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;
  final VoidCallback onClose;

  const SideNavigation({
    super.key,
    required this.selectedIndex,
    required this.onItemSelected,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.black.withOpacity(0.4),
      child: Row(
        children: [
          // Side Menu
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: AppTheme.surfaceColor,
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: const EdgeInsets.all(16),
                  child: const Row(
                    children: [
                      Icon(
                        Icons.close,
                        color: AppTheme.textPrimary,
                        size: 24,
                      ),
                      Expanded(
                        child: Text(
                          'Menu',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: 24), // Balance the close icon
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Navigation Items
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: [
                      _buildNavItem(
                        icon: Icons.home,
                        label: 'Dashboard',
                        index: 0,
                        isSelected: selectedIndex == 0,
                      ),
                      const SizedBox(height: 16),
                      _buildNavItem(
                        icon: Icons.people,
                        label: 'Find Alumni',
                        index: 1,
                        isSelected: selectedIndex == 1,
                      ),
                      const SizedBox(height: 16),
                      _buildNavItem(
                        icon: Icons.people_outline,
                        label: 'Mentorship',
                        index: 2,
                        isSelected: selectedIndex == 2,
                      ),
                      const SizedBox(height: 16),
                      _buildNavItem(
                        icon: Icons.handshake,
                        label: 'Referrals',
                        index: 3,
                        isSelected: selectedIndex == 3,
                      ),
                      const SizedBox(height: 16),
                      _buildNavItem(
                        icon: Icons.calendar_today,
                        label: 'Events',
                        index: 4,
                        isSelected: selectedIndex == 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Close area
          Expanded(
            child: GestureDetector(
              onTap: onClose,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () => onItemSelected(index),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.cardColor : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: AppTheme.textPrimary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: AppTheme.textPrimary,
                fontSize: 16,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
