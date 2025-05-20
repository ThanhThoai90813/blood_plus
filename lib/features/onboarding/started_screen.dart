import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/features/auth/login_screen.dart';
import 'package:blood_plus/features/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';

class StartedScreen extends StatelessWidget {
  const StartedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: Image.asset(
                'assets/images/logo.png',
                width: 150,
                height: 150,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Helthi',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryRed,
              ),
            ),
            const SizedBox(height: 40),
            Text(
              localizations.translate('lets_get_started'),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              localizations.translate('login_welcome_message'),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 40),
            CustomButton(
              text: localizations.translate('login'),
              color: AppColors.primaryRed,
              textColor: AppColors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginScreen(),
                  ),
                );
              },
              padding: const EdgeInsets.symmetric(horizontal: 120, vertical: 15),
              borderRadius: 10,
            ),
            const SizedBox(height: 20),
            OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignUpScreen(),
                  ),
                );
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.grey),
                padding: const EdgeInsets.symmetric(
                  horizontal: 110,
                  vertical: 15,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                localizations.translate('sign_up'),
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.primaryRed,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}