import 'package:blood_plus/core/language_helper/language_manager.dart';
import 'package:blood_plus/features/onboarding/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'core/language_helper/localization.dart';

void main() {
  print('Starting app...');
  runApp(
    ChangeNotifierProvider(
      create: (context) => LanguageManager()..loadLanguage(),
      child: const BloodDonationApp(),
    ),
  );
}

class BloodDonationApp extends StatelessWidget {
  const BloodDonationApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<LanguageManager>(
      builder: (context, languageManager, child) {
        return MaterialApp(
          title: 'Mau Plus',
          theme: ThemeData(
            primarySwatch: Colors.red,
          ),
          home: const SplashScreen(),
          debugShowCheckedModeBanner: false,
          locale: languageManager.locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
        );
      },
    );
  }
}