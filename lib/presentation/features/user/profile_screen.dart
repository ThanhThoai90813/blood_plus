import 'package:blood_plus/core/constants/app_theme.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/core/widgets/custom_button.dart';
import 'package:blood_plus/core/widgets/custom_button_navBar.dart';
import 'package:blood_plus/core/widgets/dialog_helper.dart';
import 'package:blood_plus/data/manager/user_manager.dart';
import 'package:blood_plus/data/models/user_model.dart';
import 'package:blood_plus/presentation/features/user/account_infor_screen.dart';
import 'package:blood_plus/presentation/features/user/settings_screen.dart';
import 'package:blood_plus/presentation/features/auth/login_screen.dart';
import 'package:blood_plus/presentation/features/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with TickerProviderStateMixin {
  bool _isQrEnlarged = false;
  double _originalBrightness = 0.5;
  UserModel? _user;
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
    _storeCurrentBrightness();
    _loadUserInfo();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
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
        _fadeController.forward();
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

  String _generateQrData(UserModel? user) {
    if (user == null) {
      return 'No user data available';
    }
    final qrData = '''
ID: ${user.id ?? 'N/A'}
Name: ${user.name ?? 'N/A'}
Address: ${user.address ?? 'N/A'}
DOB: ${user.dateOfBirth?.toString().split(' ')[0] ?? 'N/A'}
Passport: ${user.passportNumber ?? 'N/A'}
Donations: ${user.donationCount?.toString() ?? '0'}
Email: ${user.email ?? 'N/A'}
Blood Type: ${user.bloodType ?? 'N/A'}
Phone: ${user.phoneNumber ?? 'N/A'}
'''.trim();
    return qrData;
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryRed,
        elevation: 0,
        title: Text(
          localizations.translate('profile'),
          style: AppTheme.headingMedium.copyWith(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code, color: Colors.white, size: 33),
            onPressed: () {
              setState(() {
                _isQrEnlarged = true;
              });
              _setMaxBrightness();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: _user == null
                ? _buildLoadingWidget(localizations)
                : SingleChildScrollView(
              child: Column(
                children: [
                  _buildProfileHeader(context),
                  const SizedBox(height: 24),
                  _buildMenuSection(context),
                ],
              ),
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
                color: Colors.black.withOpacity(0.7),
                child: Center(
                  child: _buildQrDialog(context),
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

  Widget _buildProfileHeader(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppTheme.primaryGradient,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Hero(
            tag: 'profile_image',
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
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
          ),
          const SizedBox(height: 16),
          Text(
            _user?.name ?? localizations.translate('loading'),
            style: AppTheme.headingLarge.copyWith(color: Colors.white),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 16),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  _user?.address ?? localizations.translate('loading'),
                  style: AppTheme.bodyMedium.copyWith(color: Colors.white70),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildInfoCard(
                title: localizations.translate('blood_type'),
                value: _user?.bloodType ?? 'N/A',
                icon: Icons.bloodtype,
                color: Colors.red,
              ),
              _buildInfoCard(
                title: localizations.translate('donation_count'),
                value: _user?.donationCount.toString() ?? '0',
                icon: Icons.favorite,
                color: Colors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 140,
      padding: const EdgeInsets.all(12),
      decoration: AppTheme.cardDecoration,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: AppTheme.bodySmall.copyWith(color: AppTheme.textSecondary),
            textAlign: TextAlign.center,
          ),
          Text(
            value,
            style: AppTheme.headingSmall.copyWith(color: AppTheme.textPrimary),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildMenuSection(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.translate('options'),
            style: AppTheme.headingMedium.copyWith(color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 16),
          _buildMenuItem(
            context: context,
            icon: Icons.person_outline,
            title: localizations.translate('user_info'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccountInfoScreen()),
            ),
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.settings,
            title: localizations.translate('settings'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SettingsScreen()),
            ),
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.bookmark_border,
            title: localizations.translate('app_info'),
            onTap: () {
              DialogHelper.showAnimatedSuccessDialog(
                context: context,
                title: localizations.translate('app_info_title'),
                message: localizations.translate('app_info_message'),
                buttonText: localizations.translate('close'),
                icon: Icons.info_outline,
                iconColor: AppTheme.primaryRed,
              );
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.history,
            title: localizations.translate('donation_history'),
            onTap: () {
              // Placeholder for donation history screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localizations.translate('feature_coming_soon')),
                  backgroundColor: AppTheme.primaryRed,
                ),
              );
            },
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.logout,
            title: localizations.translate('logout'),
            onTap: () => _showLogoutConfirmationDialog(context),
            iconColor: Colors.red,
          ),
          _buildMenuItem(
            context: context,
            icon: Icons.help_outline,
            title: localizations.translate('support'),
            onTap: () {
              DialogHelper.showAnimatedSuccessDialog(
                context: context,
                title: localizations.translate('support_title'),
                message: localizations.translate('support_message'),
                buttonText: localizations.translate('close'),
                icon: Icons.help_outline,
                iconColor: AppTheme.primaryRed,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color? iconColor,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        leading: Icon(icon, size: 28, color: iconColor ?? AppTheme.primaryRed),
        title: Text(
          title,
          style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary),
        ),
        trailing: const Icon(Icons.chevron_right, size: 28, color: AppTheme.textSecondary),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        tileColor: AppTheme.cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  Widget _buildQrDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Container(
      padding: const EdgeInsets.all(24),
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: AppTheme.glassmorphismDecoration,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            localizations.translate('user_qr_code'),
            style: AppTheme.headingMedium.copyWith(color: AppTheme.textPrimary),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: QrImageView(
              data: _generateQrData(_user),
              size: 250,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          CustomButton(
            text: localizations.translate('close'),
            color: AppTheme.primaryRed,
            textColor: Colors.white,
            onPressed: () {
              setState(() {
                _isQrEnlarged = false;
              });
              _restoreBrightness();
            },
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
            borderRadius: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingWidget(AppLocalizations localizations) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryRed),
          ),
          const SizedBox(height: 16),
          Text(
            localizations.translate('loading'),
            style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final userManager = UserManager();

    DialogHelper.showConfirmationDialog(
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
                backgroundColor: AppTheme.primaryRed,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                duration: const Duration(seconds: 2),
              ),
            );
          }
        } catch (e) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${localizations.translate('logout_failed')}: $e'),
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        }
      },
    );
  }
}