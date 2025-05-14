import 'package:blood_plus/core/widgets/custom_button_navBar.dart';
import 'package:blood_plus/features/onboarding/account_infor_screen.dart';
import 'package:blood_plus/features/onboarding/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen_brightness/screen_brightness.dart';

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

  // Store the current brightness level
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

  // Set maximum brightness
  Future<void> _setMaxBrightness() async {
    try {
      await ScreenBrightness().setScreenBrightness(1.0);
    } catch (e) {
      debugPrint('Error setting max brightness: $e');
    }
  }

  // Restore original brightness
  Future<void> _restoreBrightness() async {
    try {
      await ScreenBrightness().setScreenBrightness(_originalBrightness);
    } catch (e) {
      debugPrint('Error restoring brightness: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFD12727),
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
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
                  width: 40, // Square dimensions
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
                // Profile header
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD12727),
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
                // Other ListTiles
                buildListTile(context, Icons.person_outline, 'Thông tin người dùng', const AccountInfoScreen()),
                buildListTile(context, Icons.settings, 'Cài Đặt', null),
                buildListTile(context, Icons.bookmark_border, 'Chính sách ứng dụng', null),
                buildListTile(context, Icons.history, 'Lịch sử hiến máu', null),
                buildListTile(context, Icons.logout, 'Đăng xuất', null),
                // "Hỗ trợ" button
                ListTile(
                  leading: const Icon(
                    Icons.help_outline,
                    size: 30,
                  ),
                  title: const Text(
                    'Hỗ trợ',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    size: 30,
                  ),
                  onTap: () {
                    _showSupportDialog(context);
                  },
                ),
              ],
            ),
          ),
          // Enlarged QR Code overlay with white background
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
                      color: Colors.white, // White background for enlarged QR
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
                      size: 300, // Enlarged size, square
                      backgroundColor: Colors.white, // Ensure white background
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
          } else if (index != 4) {
            // Handle other navigation if needed
          }
        },
      ),
    );
  }

  // Helper method to build the list tiles
  ListTile buildListTile(BuildContext context, IconData icon, String title, Widget? screen) {
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
      onTap: () {
        if (screen != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => screen),
          );
        }
      },
    );
  }

  // Function to show the support dialog
  void _showSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hỗ trợ từ nhà phát triển'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text('Số điện thoại: 0123456789'),
              Text('Email: support@bloodplus.com'),
              SizedBox(height: 10),
              Text('Phản hồi hoặc báo cáo ứng dụng, vui lòng gửi email hoặc gọi cho chúng tôi.')
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Đóng'),
            ),
          ],
        );
      },
    );
  }
}