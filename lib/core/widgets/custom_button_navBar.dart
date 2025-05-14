import 'package:blood_plus/core/localization.dart';
import 'package:flutter/material.dart';
import 'package:blood_plus/core/constants/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return SafeArea( // Sử dụng SafeArea để tránh bị che
      child: Container(
        height:61,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(
                  icon: Icons.home,
                  label: localizations.translate('home'),
                  index: 0,
                  isSelected: selectedIndex == 0,
                  onTap: onItemTapped,
                ),
                _buildNavItem(
                  icon: Icons.calendar_today,
                  label: localizations.translate('events'),
                  index: 1,
                  isSelected: selectedIndex == 1,
                  onTap: onItemTapped,
                ),
                const SizedBox(width: 60), // Space for the center button
                _buildNavItem(
                  icon: Icons.handshake,
                  label: localizations.translate('history'),
                  index: 3,
                  isSelected: selectedIndex == 3,
                  onTap: onItemTapped,
                ),
                _buildNavItem(
                  icon: Icons.person,
                  label: localizations.translate('profile'),
                  index: 4,
                  isSelected: selectedIndex == 4,
                  onTap: onItemTapped,
                ),
              ],
            ),
            Positioned(
              child: GestureDetector(
                onTap: () => onItemTapped(2),
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryRed,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.bloodtype,
                    color: Colors.white,
                    size: 48,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String label,
    required int index,
    required bool isSelected,
    required ValueChanged<int> onTap,
  }) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: isSelected ? 32 : 28,
            color: isSelected ? AppColors.primaryRed : Colors.grey,
          ),
          if (label.isNotEmpty)
            Text(
              label,
              style: TextStyle(
                color: isSelected ? AppColors.primaryRed : Colors.grey,
                fontSize: 12,
              ),
            ),
        ],
      ),
    );
  }
}