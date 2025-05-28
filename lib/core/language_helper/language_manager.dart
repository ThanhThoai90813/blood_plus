import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageManager with ChangeNotifier {
  Locale _locale = const Locale('vi', 'VN'); // Default language
  static const List<Locale> supportedLocales = [
    Locale('vi', 'VN'),
    Locale('en', 'US'),
  ];

  Locale get locale => _locale;

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'vi';
    _locale = languageCode == 'vi' ? const Locale('vi', 'VN') : const Locale('en', 'US');
    notifyListeners();
  }

  Future<void> changeLanguage(String languageCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', languageCode);
    _locale = languageCode == 'vi' ? const Locale('vi', 'VN') : const Locale('en', 'US');
    notifyListeners();
  }
}