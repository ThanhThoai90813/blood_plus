import 'package:blood_plus/core/localization.dart';
import 'package:blood_plus/core/utils/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button_navBar.dart';
import '../auth/login_screen.dart';
import '../onboarding/account_infor_screen.dart';
import '../onboarding/home_screen.dart';
import '../onboarding/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isQrEnlarged = false;
  double _originalBrightness = 0.5;

  @override
  void initState() {
    super.initState();
    _storeCurrentBrightness();
  }

  Future<void> _storeCurrentBrightness() async {
    try {
      final currentBrightness = await ScreenBrightness().current;
      setState(() {
        _originalBrightness = currentBrightness;
      });
    } catch (e) {
      debugPrint('Error getting current brightness: $e');
    }
  }

  Future<void> _setMaxBrightness() async {
    try {
      await ScreenBrightness().setScreenBrightness(1.0);
    } catch (e) {
      debugPrint('Error setting max brightness: $e');
    }
  }

  Future<void> _restoreBrightness() async {
    try {
      await ScreenBrightness().setScreenBrightness(_originalBrightness);
    } catch (e) {
      debugPrint('Error restoring brightness: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        title: Text(
          localizations.translate('profile'),
          style: const TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 10, top: 5),
            child: Transform(
              transform: Matrix4.translationValues(0.0, -10.0, 0.0),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _isQrEnlarged = true;
                  });
                  _setMaxBrightness();
                },
                child: Container(
                  width: 40,
                  height: 40,
                  child: const Icon(
                    Icons.qr_code,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryRed,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage('assets/images/profile.jpg'),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Duong Thanh Thoai',
                        style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'P13, Binh Thanh, Ho Chi Minh',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                buildListTile(context, Icons.person_outline, localizations.translate('user_info'), const AccountInfoScreen()),
                buildListTile(context, Icons.settings, localizations.translate('settings'), const SettingsScreen()),
                buildListTile(context, Icons.bookmark_border, localizations.translate('app_info'), null, onTap: () {
                  DialogHelper.showAnimatedSuccessDialog(
                    context: context,
                    title: localizations.translate('app_info_title'),
                    message: localizations.translate('app_info_message'),
                    buttonText: localizations.translate('close'),
                    icon: Icons.info_outline,
                    iconColor: AppColors.primaryRed,
                  );
                }),
                buildListTile(context, Icons.history, localizations.translate('donation_history'), null),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    size: 30,
                  ),
                  title: Text(
                    localizations.translate('logout'),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    size: 30,
                  ),
                  onTap: () {
                    _showLogoutConfirmationDialog(context);
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.help_outline,
                    size: 30,
                  ),
                  title: Text(
                    localizations.translate('support'),
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    size: 30,
                  ),
                  onTap: () {
                    DialogHelper.showAnimatedSuccessDialog(
                      context: context,
                      title: localizations.translate('support_title'),
                      message: localizations.translate('support_message'),
                      buttonText: localizations.translate('close'),
                      icon: Icons.help_outline,
                      iconColor: AppColors.primaryRed,
                    );
                  },
                ),
              ],
            ),
          ),
          if (_isQrEnlarged)
            GestureDetector(
              onTap: () {
                setState(() {
                  _isQrEnlarged = false;
                });
                _restoreBrightness();
              },
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.shade600,
                          spreadRadius: 2,
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: 'Duong Thanh Thoai\n05/02/2003\n083203007395',
                      size: 300,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: 4,
        onItemTapped: (index) {
          if (index == 0) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
                  (route) => false,
            );
          }
        },
      ),
    );
  }

  ListTile buildListTile(
      BuildContext context,
      IconData icon,
      String title,
      Widget? screen, {
        VoidCallback? onTap,
      }) {
    return ListTile(
      leading: Icon(
        icon,
        size: 30,
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
        ),
      ),
      trailing: const Icon(
        Icons.chevron_right,
        size: 30,
      ),
      onTap: onTap ??
              () {
            if (screen != null) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => screen),
              );
            }
          },
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(localizations.translate('logout_confirm_title')),
          content: Text(localizations.translate('logout_confirm_message')),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(localizations.translate('cancel')),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                      (route) => false,
                );
                DialogHelper.showAnimatedSuccessDialog(
                  context: context,
                  title: localizations.translate('logout_success_title'),
                  message: localizations.translate('logout_success_message'),
                  buttonText: localizations.translate('ok'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                );
              },
              child: Text(
                localizations.translate('confirm'),
                style: const TextStyle(color: AppColors.primaryRed),
              ),
            ),
          ],
        );
      },
    );
  }
}