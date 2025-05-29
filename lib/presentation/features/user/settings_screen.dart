import 'package:blood_plus/core/constants/app_theme.dart';
import 'package:blood_plus/core/language_helper/language_manager.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/core/widgets/custom_button.dart';
import 'package:blood_plus/core/widgets/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> with TickerProviderStateMixin {
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  String _selectedLanguageCode = 'vi';
  final List<String> _languageCodes = ['vi', 'en'];
  bool _isLoading = true;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _loadSavedSettings();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _loadSavedSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguageCode = prefs.getString('languageCode') ?? 'vi';
      final notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      final darkModeEnabled = prefs.getBool('dark_mode_enabled') ?? false;
      setState(() {
        _selectedLanguageCode = savedLanguageCode;
        _notificationsEnabled = notificationsEnabled;
        _darkModeEnabled = darkModeEnabled;
        _isLoading = false;
      });
      _fadeController.forward();
    } catch (e) {
      debugPrint('Error loading settings: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveSettings(LanguageManager languageManager) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('languageCode', _selectedLanguageCode);
      await prefs.setBool('notifications_enabled', _notificationsEnabled);
      await prefs.setBool('dark_mode_enabled', _darkModeEnabled);

      // Cập nhật ngôn ngữ
      await languageManager.changeLanguage(_selectedLanguageCode);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              AppLocalizations.of(context).translate('saved_settings'),
              style: AppTheme.bodyMedium.copyWith(color: Colors.white),
            ),
            backgroundColor: AppTheme.primaryRed,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error saving settings: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${AppLocalizations.of(context).translate('error')}: $e',
              style: AppTheme.bodyMedium.copyWith(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final languageManager = Provider.of<LanguageManager>(context, listen: false);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryRed,
        elevation: 0,
        title: Text(
          localizations.translate('settings'),
          style: AppTheme.headingMedium.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? _buildLoadingIndicator(context)
          : FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.translate('general'),
                style: AppTheme.headingMedium.copyWith(color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 16),
              _buildSwitchTile(
                title: localizations.translate('enable_notifications'),
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
              ),
              _buildSwitchTile(
                title: localizations.translate('dark_mode'),
                value: _darkModeEnabled,
                onChanged: (value) {
                  setState(() {
                    _darkModeEnabled = value;
                  });
                  // Cập nhật ThemeMode (yêu cầu tích hợp với ThemeProvider)
                  // Ví dụ: Provider.of<ThemeProvider>(context, listen: false).toggleTheme(value);
                },
              ),
              _buildDivider(context),
              Text(
                localizations.translate('language'),
                style: AppTheme.headingMedium.copyWith(color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 16),
              _buildLanguageDropdown(context),
              _buildDivider(context),
              Text(
                localizations.translate('about'),
                style: AppTheme.headingMedium.copyWith(color: AppTheme.textPrimary),
              ),
              const SizedBox(height: 16),
              _buildMenuItem(
                context: context,
                title: localizations.translate('privacy_policy'),
                onTap: () {
                  DialogHelper.showAnimatedSuccessDialog(
                    context: context,
                    title: localizations.translate('privacy_policy_title'),
                    message: localizations.translate('privacy_policy_message'),
                    buttonText: localizations.translate('close'),
                    icon: Icons.shield,
                    iconColor: AppTheme.primaryRed,
                    onPressed: () => Navigator.pop(context),
                  );
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: CustomButton(
                  text: localizations.translate('save_settings'),
                  color: AppTheme.primaryRed,
                  textColor: Colors.white,
                  onPressed: () => _saveSettings(languageManager),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  borderRadius: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
        CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryRed)),
    const SizedBox(height: 16),
    Text(
    AppLocalizations.of(context).translate('loading'),
    style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary),
    ),
    ],
        ));
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppTheme.cardColor,
      child: SwitchListTile(
        title: Text(
          title,
          style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary),
        ),
        value: value,
        activeColor: AppTheme.primaryRed,
        inactiveTrackColor: AppTheme.borderColor,
        onChanged: onChanged,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildLanguageDropdown(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    // Map language codes to translated display names
    final languageDisplayNames = {
      'vi': localizations.translate('language_vietnamese'),
      'en': localizations.translate('language_english'),
    };

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppTheme.cardColor,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: DropdownButtonFormField<String>(
          value: _selectedLanguageCode,
          decoration: InputDecoration(
            labelText: AppLocalizations.of(context).translate('language'),
            labelStyle: AppTheme.bodyMedium.copyWith(color: AppTheme.textSecondary),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.borderColor, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.borderColor, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppTheme.primaryRed, width: 2),
            ),
            filled: true,
            fillColor: AppTheme.cardColor,
            contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
          ),
          style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary),
          icon: Icon(Icons.arrow_drop_down, color: AppTheme.primaryRed),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedLanguageCode = newValue;
              });
            }
          },
          items: _languageCodes.map<DropdownMenuItem<String>>((String language) {
            return DropdownMenuItem<String>(
              value: language,
              child: Text(languageDisplayNames[language] ?? language),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required String title,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppTheme.cardColor,
      child: ListTile(
        title: Text(
          title,
          style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary),
        ),
        trailing: Icon(Icons.chevron_right, color: AppTheme.textSecondary, size: 28),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildDivider(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Divider(
        color: AppTheme.borderColor,
        thickness: 1,
        indent: 8,
        endIndent: 8,
      ),
    );
  }
}