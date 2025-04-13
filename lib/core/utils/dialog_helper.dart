import 'package:blood_plus/core/widgets/success_dialog.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static void showAnimatedSuccessDialog({
    required BuildContext context,
    required String title,
    required String message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return const SizedBox.shrink(); // Không cần gì ở đây, tất cả nằm trong transitionBuilder
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
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
