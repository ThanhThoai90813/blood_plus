import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class SuccessDialog extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String message;
  final String buttonText;
  final VoidCallback onButtonPressed;

  const SuccessDialog({
    super.key,
    this.icon = Icons.check_circle_outline,
    this.iconColor = AppColors.primaryRed, // Use AppColors for consistency
    required this.title,
    required this.message,
    this.buttonText = 'OK',
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 8, // Subtle elevation for card-like effect
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    iconColor.withOpacity(0.2),
                    iconColor.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: iconColor.withOpacity(0.3), width: 1),
              ),
              child: Icon(
                icon,
                size: 48, // Slightly larger for emphasis
                color: iconColor,
                semanticLabel: 'Success icon', // Accessibility
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
                fontFamily: 'Roboto',
                height: 1.5, // Improved readability
              ),
            ),
            const SizedBox(height: 24),
            CustomButton(
              text: buttonText,
              color: iconColor,
              onPressed: onButtonPressed,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
              borderRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}