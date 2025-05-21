import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/widgets/custom_confirmation_dialog.dart';
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
    Duration transitionDuration = const Duration(milliseconds: 300),
    IconData icon = Icons.check_circle_outline,
    Color iconColor = AppColors.primaryRed,
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
          curve: Curves.easeInOut, // Smooth animation, matching logout dialog
          reverseCurve: Curves.easeInOut,
        );
        return ScaleTransition(
          scale: curvedAnimation,
          child: FadeTransition(
            opacity: animation,
            child: SuccessDialog(
              title: title,
              message: message,
              buttonText: buttonText,
              onButtonPressed: () {
                Navigator.of(context).pop();
                if (onPressed != null) {
                  onPressed();
                }
              },
              icon: icon,
              iconColor: iconColor,
            ),
          ),
        );
      },
    );
  }

  static void showLogoutConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String cancelButtonText,
    required String confirmButtonText,
    required VoidCallback onConfirm,
    Color barrierColor = Colors.black54,
    Duration transitionDuration = const Duration(milliseconds: 300),
    IconData icon = Icons.logout,
    Color iconColor = AppColors.primaryRed,
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
          curve: Curves.easeInOut, // Smooth animation
          reverseCurve: Curves.easeInOut,
        );
        return ScaleTransition(
          scale: curvedAnimation,
          child: FadeTransition(
            opacity: animation,
            child: CustomConfirmationDialog( // Updated to use the renamed dialog
              title: title,
              message: message,
              cancelButtonText: cancelButtonText,
              confirmButtonText: confirmButtonText,
              onCancel: () {
                Navigator.of(context).pop();
              },
              onConfirm: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              icon: icon,
              iconColor: iconColor,
            ),
          ),
        );
      },
    );
  }
}