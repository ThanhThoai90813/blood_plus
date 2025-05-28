// 1. Enhanced Custom Bottom Navigation Bar
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/presentation/features/schedule/donation_event_screen.dart';
import 'package:flutter/material.dart';
import 'package:blood_plus/core/constants/app_colors.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const CustomBottomNavBar({
    required this.selectedIndex,
    required this.onItemTapped,
    Key? key,
  }) : super(key: key);

  @override
  State<CustomBottomNavBar> createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar>
    with TickerProviderStateMixin {
  late AnimationController _fabController;
  late Animation<double> _fabScale;
  late Animation<double> _fabRotation;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _fabScale = Tween<double>(begin: 1.0, end: 0.9).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
    );
    _fabRotation = Tween<double>(begin: 0.0, end: 0.1).animate(
      CurvedAnimation(parent: _fabController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            spreadRadius: 0,
            blurRadius: 40,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: SafeArea(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildNavItem(
                    icon: Icons.home_rounded,
                    label: localizations.translate('home'),
                    index: 0,
                    isSelected: widget.selectedIndex == 0,
                    onTap: widget.onItemTapped,
                  ),
                  _buildNavItem(
                    icon: Icons.calendar_today_rounded,
                    label: localizations.translate('events'),
                    index: 1,
                    isSelected: widget.selectedIndex == 1,
                    onTap: widget.onItemTapped,
                  ),
                  const SizedBox(width: 72), // Space for center FAB
                  _buildNavItem(
                    icon: Icons.handshake_rounded,
                    label: localizations.translate('history'),
                    index: 3,
                    isSelected: widget.selectedIndex == 3,
                    onTap: widget.onItemTapped,
                  ),
                  _buildNavItem(
                    icon: Icons.person_rounded,
                    label: localizations.translate('profile'),
                    index: 4,
                    isSelected: widget.selectedIndex == 4,
                    onTap: widget.onItemTapped,
                  ),
                ],
              ),
            ),
            // Enhanced FAB with animation and better design
            Positioned(
              top: -20,
              child: AnimatedBuilder(
                animation: _fabController,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _fabScale.value,
                    child: Transform.rotate(
                      angle: _fabRotation.value,
                      child: GestureDetector(
                        onTapDown: (_) => _fabController.forward(),
                        onTapUp: (_) => _fabController.reverse(),
                        onTapCancel: () => _fabController.reverse(),
                        onTap: () {
                          widget.onItemTapped(2);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const DonationEventScreen(),
                            ),
                          );
                        },
                        child: Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryRed,
                                AppColors.primaryRed.withOpacity(0.8),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.primaryRed.withOpacity(0.4),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                                spreadRadius: 0,
                              ),
                              BoxShadow(
                                color: AppColors.primaryRed.withOpacity(0.2),
                                blurRadius: 40,
                                offset: const Offset(0, 16),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: const Icon(
                              Icons.bloodtype_rounded,
                              color: Colors.white,
                              size: 32,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 200),
      tween: Tween<double>(begin: 0, end: isSelected ? 1 : 0),
      builder: (context, animation, child) {
        return GestureDetector(
          onTap: () => onTap(index),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Color.lerp(
                Colors.transparent,
                AppColors.primaryRed.withOpacity(0.1),
                animation,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.scale(
                  scale: 1 + (animation * 0.1),
                  child: Icon(
                    icon,
                    size: 24,
                    color: Color.lerp(
                      Colors.grey.shade500,
                      AppColors.primaryRed,
                      animation,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                if (label.isNotEmpty)
                  Text(
                    label,
                    style: TextStyle(
                      color: Color.lerp(
                        Colors.grey.shade500,
                        AppColors.primaryRed,
                        animation,
                      ),
                      fontSize: 11,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}