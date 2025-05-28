import 'dart:math';

import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

// 4. Enhanced Success Dialog
class SuccessDialog extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const SuccessDialog({
    super.key,
    this.icon = Icons.check_circle_outline_rounded,
    this.iconColor = AppColors.primaryRed,
    required this.title,
    required this.message,
    this.buttonText = 'OK',
    required this.onButtonPressed,
  });

  @override
  State<SuccessDialog> createState() => _SuccessDialogState();
}

class _SuccessDialogState extends State<SuccessDialog>
    with TickerProviderStateMixin {
  late AnimationController _iconController;
  late AnimationController _particleController;
  late Animation<double> _iconScale;
  late Animation<double> _iconRotation;
  late List<Animation<Offset>> _particleAnimations;

  @override
  void initState() {
    super.initState();

    _iconController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _iconScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _iconRotation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _iconController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    // Create particle animations
    _particleAnimations = List.generate(6, (index) {
      final angle = (index * 60) * (3.14159 / 180); // Convert to radians
      return Tween<Offset>(
        begin: Offset.zero,
        end: Offset(cos(angle) * 80, sin(angle) * 80),
      ).animate(
        CurvedAnimation(
          parent: _particleController,
          curve: Interval(0.0, 0.7, curve: Curves.easeOut),
        ),
      );
    });

    _iconController.forward();
    _particleController.forward();
  }

  @override
  void dispose() {
    _iconController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 30,
              offset: const Offset(0, 15),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Animated icon with particles
            SizedBox(
              height: 120,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Particles
                  ...List.generate(6, (index) {
                    return AnimatedBuilder(
                      animation: _particleController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: _particleAnimations[index].value,
                          child: Opacity(
                            opacity: 1 - _particleController.value,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: widget.iconColor.withOpacity(0.6),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                  // Main icon
                  AnimatedBuilder(
                    animation: _iconController,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _iconScale.value,
                        child: Transform.rotate(
                          angle: _iconRotation.value,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  widget.iconColor.withOpacity(0.15),
                                  widget.iconColor.withOpacity(0.05),
                                  Colors.transparent,
                                ],
                                stops: const [0.3, 0.7, 1.0],
                              ),
                              border: Border.all(
                                color: widget.iconColor.withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              widget.icon,
                              size: 52,
                              color: widget.iconColor,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
                letterSpacing: -0.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              widget.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                height: 1.5,
                letterSpacing: 0.2,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: widget.buttonText,
                color: widget.iconColor,
                onPressed: widget.onButtonPressed,
                borderRadius: 14,
                height: 52,
              ),
            ),
          ],
        ),
      ),
    );
  }
}