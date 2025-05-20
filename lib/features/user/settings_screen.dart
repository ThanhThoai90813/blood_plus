import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/language_helper/language_manager.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/core/utils/dialog_helper.dart';
import 'package:blood_plus/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'Tiếng Việt';
  final List<String> _languages = ['Tiếng Việt', 'English'];

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLanguage = prefs.getString('language') ?? 'Tiếng Việt';
    final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
    setState(() {
      _selectedLanguage = savedLanguage;
      _notificationsEnabled = notificationsEnabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final languageManager = Provider.of<LanguageManager>(context, listen: false);

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        title: Text(
          localizations.translate('settings'),
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          children: [
            SwitchListTile(
              title: Text(
                localizations.translate('enable_notifications'),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
              value: _notificationsEnabled,
              activeColor: AppColors.primaryRed,
              onChanged: (bool value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            const Divider(),
            ListTile(
              title: Text(
                localizations.translate('language'),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
              trailing: DropdownButton<String>(
                value: _selectedLanguage,
                icon: const Icon(Icons.arrow_drop_down),
                underline: const SizedBox(),
                onChanged: (String? newValue) {
                  if (newValue != null) {
                    setState(() {
                      _selectedLanguage = newValue;
                    });
                  }
                },
                items: _languages
                    .map<DropdownMenuItem<String>>((String language) {
                  return DropdownMenuItem<String>(
                    value: language,
                    child: Text(language),
                  );
                }).toList(),
              ),
            ),
            const Divider(),
            SwitchListTile(
              title: Text(
                localizations.translate('dark_mode'),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
              value: false,
              activeColor: AppColors.primaryRed,
              onChanged: null,
            ),
            const Divider(),
            ListTile(
              title: Text(
                localizations.translate('privacy_policy'),
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w400,
                ),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                DialogHelper.showAnimatedSuccessDialog(
                  context: context,
                  title: localizations.translate('privacy_policy_title'),
                  message: localizations.translate('privacy_policy_message'),
                  buttonText: localizations.translate('close'),
                  onPressed: () => Navigator.of(context).pop(),
                );
              },
            ),
            const Divider(),
            const SizedBox(height: 20),
            CustomButton(
              text: localizations.translate('save_settings'),
              color: AppColors.primaryRed,
              onPressed: () async {
                await languageManager.changeLanguage(_selectedLanguage);
                final prefs = await SharedPreferences.getInstance();
                await prefs.setBool('notifications_enabled', _notificationsEnabled);
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localizations.translate('saved_settings')),
                    ),
                  );
                }
              },
              padding: const EdgeInsets.symmetric(vertical: 15),
              borderRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}