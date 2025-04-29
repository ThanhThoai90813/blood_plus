import 'package:flutter/material.dart';
import 'package:blood_plus/core/constants/app_colors.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        const SizedBox(height: 20),
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Dương Thành Thoại',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'duong.thanh.thoai@example.com',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        ListTile(
          leading: const Icon(Icons.edit, color: AppColors.primaryRed),
          title: const Text('Cập nhật thông tin cá nhân'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.history, color: AppColors.primaryRed),
          title: const Text('Lịch sử hiến máu'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.delete, color: Colors.red),
          title: const Text('Xóa tài khoản'),
          onTap: () {},
        ),
        ListTile(
          leading: const Icon(Icons.logout, color: AppColors.primaryRed),
          title: const Text('Đăng xuất'),
          onTap: () {},
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.info, color: AppColors.primaryRed),
          title: const Text('Phiên bản phần mềm'),
          subtitle: const Text('1.0.0'),
        ),
        ListTile(
          leading: const Icon(Icons.contact_mail, color: AppColors.primaryRed),
          title: const Text('Liên hệ DEV'),
          onTap: () {},
        ),
      ],
    );
  }
}