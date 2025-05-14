import 'package:blood_plus/core/utils/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/widgets/custom_button.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({Key? key}) : super(key: key);

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  final _formKey = GlobalKey<FormState>();

  String _fullName = 'Dương Thành Thoại';
  String _address = 'Mirpur 10, Dhaka';
  String _bloodType = 'A+';
  String _image = 'assets/images/profile.jpg';

  TextEditingController phoneController = TextEditingController(text: '0337252208');
  TextEditingController emailController = TextEditingController(text: 'thanhthoai13@gmail.com');
  TextEditingController roleController = TextEditingController(text: 'Donor');
  TextEditingController dobController = TextEditingController(text: '05/02/2003');
  TextEditingController organizationController = TextEditingController(text: 'Đại học FPT HCM');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        title: Text(
          'Cập nhật thông tin',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildUserProfileCard(),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _sectionTitle("Thông tin cá nhân"),
                  _buildInputField("Số điện thoại", phoneController, Icons.phone),
                  _buildInputField("Email", emailController, Icons.email),
                  _buildInputField("Ngày sinh", dobController, Icons.cake),
                  _buildInputField("Vai trò", roleController, Icons.verified_user),
                  const SizedBox(height: 20),
                  _sectionTitle("Thông tin cơ quan"),
                  _buildInputField("Cơ quan", organizationController, Icons.business),
                ],
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'LƯU THÔNG TIN',
              color: AppColors.primaryRed,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  DialogHelper.showAnimatedSuccessDialog(
                    context: context,
                    title: 'Thành công',
                    message: 'Thông tin đã được lưu thành công!',
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.grey.shade200, blurRadius: 200, spreadRadius: 5),
        ],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: AssetImage(_image),
          ),
          const SizedBox(height: 10),
          Text(
            _fullName,
            style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            _address,
            style: GoogleFonts.poppins(color: Colors.grey[600]),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.red.shade100),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.bloodtype, color: Colors.red, size: 22),
                const SizedBox(width: 6),
                Text(
                  _bloodType,
                  style: GoogleFonts.poppins(
                    color: Colors.red,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 16),
      child: Text(
        title,
        style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primaryRed),
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 16),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryRed),
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: const Icon(Icons.edit, size: 20),
          filled: true,
          fillColor: Colors.grey.shade50,
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Vui lòng nhập $label';
          }
          return null;
        },
      ),
    );
  }
}
