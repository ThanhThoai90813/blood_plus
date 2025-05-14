import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/widgets/success_dialog.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static void showAnimatedSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
    Color barrierColor = Colors.black54,
    Duration transitionDuration = const Duration(milliseconds: 400),
    IconData icon = Icons.check_circle_outline, // Default icon
    Color iconColor = AppColors.primaryRed, // Default icon color
  }) {
    if (!context.mounted) return;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.bounceOut,
          reverseCurve: Curves.easeInBack,
        );
        return ScaleTransition(
          scale: curvedAnimation,
          child: FadeTransition(
            opacity: animation,
            child: SuccessDialog(
              title: title,
              message: message,
              buttonText: buttonText,
              onButtonPressed: onPressed ?? () => Navigator.of(context).pop(),
              icon: icon,
              iconColor: iconColor,
            ),
          ),
        );
      },
    );
  }
}