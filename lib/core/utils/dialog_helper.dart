import 'package:blood_plus/core/widgets/success_dialog.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static void showAnimatedSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
    Color barrierColor = Colors.black54, // Darker barrier for better contrast
    Duration transitionDuration = const Duration(milliseconds: 400),
  }) {
    if (!context.mounted) return; // Prevent errors if context is invalid
    showGeneralDialog(
      context: context,
      barrierDismissible: true, // Allow tap outside to dismiss
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: barrierColor,
      transitionDuration: transitionDuration,
      pageBuilder: (_, __, ___) => const SizedBox.shrink(),
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.bounceOut, // Bouncy effect for a modern feel
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
            ),
          ),
        );
      },
    );
  }
}
