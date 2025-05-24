import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/core/widgets/dialog_helper.dart';
import 'package:blood_plus/core/widgets/custom_button_navBar.dart';
import 'package:blood_plus/data/manager/user_manager.dart';
import 'package:blood_plus/data/models/user_model.dart';
import 'package:blood_plus/presentation/features/user/account_infor_screen.dart';
import 'package:blood_plus/presentation/features/user/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';
import '../auth/login_screen.dart';
import '../home/home_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isQrEnlarged = false;
  double _originalBrightness = 0.5;
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _storeCurrentBrightness();
    _loadUserInfo();
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

  Future<void> _loadUserInfo() async {
    final userManager = UserManager();
    final userId = await userManager.getUserId();
    if (userId != null) {
      final user = await userManager.getUserInfo(userId);
      if (user != null) {
        setState(() {
          _user = user;
        });
      }
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

  // Hàm tạo chuỗi dữ liệu QR từ thông tin người dùng
  String _generateQrData(UserModel? user) {
    if (user == null) {
      return 'No user data available';
    }

    // Tạo chuỗi dữ liệu với các thông tin từ UserModel
    final qrData = '''
ud: ${user.id ?? 'N/A'}
Name: ${user.name ?? 'N/A'}
Address: ${user.address ?? 'N/A'}
Date of Birth: ${user.dateOfBirth?.toString().split(' ')[0] ?? 'N/A'}
Passport/ID: ${user.passportNumber ?? 'N/A'}
Donation Count: ${user.donationCount?.toString() ?? '0'}
Image URL: ${user.userImage ?? 'N/A'}
Email: ${user.email ?? 'N/A'}
Job: ${user.job ?? 'N/A'}
BloodType: ${user.bloodType ?? 'N/A'}
Gender:  ${user.gender ?? 'N/A'}
PhoneNumber:  ${user.phoneNumber ?? 'N/A'}
'''.trim();

    return qrData;
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.slideRed,
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
                    color: AppColors.lowerRed,
                    borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.grey, width: 2),
                        ),
                        child: ClipOval(
                          child: FadeInImage(
                            placeholder: const AssetImage('assets/images/profile.jpg'),
                            image: _user?.userImage != null && _user!.userImage!.startsWith('http')
                                ? NetworkImage(_user!.userImage!)
                                : const AssetImage('assets/images/profile.jpg') as ImageProvider,
                            width: 100,
                            height: 100,
                            fit: BoxFit.cover,
                            imageErrorBuilder: (context, error, stackTrace) {
                              debugPrint('Image load error for ${_user?.userImage}: $error');
                              return Image.asset(
                                'assets/images/profile.jpg',
                                width: 100,
                                height: 100,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _user?.name ?? 'Loading...',
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        _user?.address ?? 'Loading...',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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
                      data: _generateQrData(_user),
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
    final userManager = UserManager();

    DialogHelper.showLogoutConfirmationDialog(
      context: context,
      title: localizations.translate('logout_confirm_title'),
      message: localizations.translate('logout_confirm_message'),
      cancelButtonText: localizations.translate('cancel'),
      confirmButtonText: localizations.translate('confirm'),
      onConfirm: () async {
        try {
          await userManager.clearUserData();

          Navigator.of(context).pop();

          if (context.mounted) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (route) => false,
            );

            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(localizations.translate('logout_success_message')),
                backgroundColor: AppColors.lowerRed,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                duration: const Duration(seconds: 2),
                elevation: 0,
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Đăng xuất thất bại: $e'),
                backgroundColor: AppColors.darkRed,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            );
          }
        }
      },
    );
  }
}