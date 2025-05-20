import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageManager with ChangeNotifier {
  Locale _locale = const Locale('vi', 'VN'); // Ngôn ngữ mặc định
  static const List<Locale> supportedLocales = [
    Locale('vi', 'VN'),
    Locale('en', 'US'),
  ];

  Locale get locale => _locale;

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final language = prefs.getString('language') ?? 'Tiếng Việt';
    _locale = language == 'Tiếng Việt' ? const Locale('vi', 'VN') : const Locale('en', 'US');
    notifyListeners();
  }

  Future<void> changeLanguage(String language) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', language);
    _locale = language == 'Tiếng Việt' ? const Locale('vi', 'VN') : const Locale('en', 'US');
    notifyListeners();
  }
}