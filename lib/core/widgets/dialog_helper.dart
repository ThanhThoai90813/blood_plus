import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/widgets/custom_confirmation_dialog.dart';
import 'package:blood_plus/core/widgets/success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 5. Enhanced Dialog Helper with improved animations
class DialogHelper {
  static void showAnimatedSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
    Color barrierColor = Colors.black54,
    Duration transitionDuration = const Duration(milliseconds: 400),
    IconData icon = Icons.check_circle_outline_rounded,
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
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
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
          ),
        );
      },
    );
  }

  static Future<bool> showConfirmationDialog({
    required BuildContext context,
    required String title,
    required String message,
    required String cancelButtonText,
    required String confirmButtonText,
    required VoidCallback onConfirm,
    Color barrierColor = Colors.black54,
    Duration transitionDuration = const Duration(milliseconds: 350),
    IconData icon = Icons.logout_rounded,
    Color iconColor = AppColors.primaryRed,
  }) async {
    if (!context.mounted) return false;
    HapticFeedback.heavyImpact();
    final result = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, -0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
              child: CustomConfirmationDialog(
                title: title,
                message: message,
                cancelButtonText: cancelButtonText,
                confirmButtonText: confirmButtonText,
                onCancel: () {
                  Navigator.of(context).pop(false);
                },
                onConfirm: () {
                  Navigator.of(context).pop(true);
                  onConfirm();
                },
                icon: icon,
                iconColor: iconColor,
              ),
            ),
          ),
        );
      },
    );
    return result ?? false;
  }

  static void showAnimatedErrorDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
    Color barrierColor = Colors.black54,
    Duration transitionDuration = const Duration(milliseconds: 400),
    IconData icon = Icons.error_outline_rounded,
    Color iconColor = AppColors.primaryRed,
  }) {
    if (!context.mounted) return;
    HapticFeedback.heavyImpact();
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.3),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          )),
          child: FadeTransition(
            opacity: CurvedAnimation(
              parent: animation,
              curve: Curves.easeOut,
            ),
            child: ScaleTransition(
              scale: Tween<double>(begin: 0.8, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                ),
              ),
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
          ),
        );
      },
    );
  }
}