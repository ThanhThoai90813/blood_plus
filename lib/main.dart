import 'package:blood_plus/core/language_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'features/splash/splash_screen.dart';
import 'core/localization.dart';

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