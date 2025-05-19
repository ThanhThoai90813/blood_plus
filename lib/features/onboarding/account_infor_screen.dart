import 'package:blood_plus/core/localization.dart';
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
  bool _isBloodCardHovered = false;

  String _fullName = 'Dương Thành Thoại';
  String _address = 'Mirpur 10, Dhaka';
  String _bloodType = 'A+';
  String _image = 'assets/images/profile.jpg'; // Thay bằng asset hoa hướng dương nếu có

  TextEditingController phoneController = TextEditingController(text: '0337252208');
  TextEditingController emailController = TextEditingController(text: 'thanhthoai13@gmail.com');
  TextEditingController roleController = TextEditingController(text: 'Donor');
  TextEditingController dobController = TextEditingController(text: '05/02/2003');
  TextEditingController organizationController = TextEditingController(text: 'Đại học FPT HCM');

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        title: Text(
          localizations.translate('update_info'),
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserProfileCard(),
            const SizedBox(height: 30),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(localizations.translate('personal_info')),
                      const SizedBox(height: 16),
                      _buildInputField(localizations.translate('phone_number'), phoneController, Icons.phone),
                      _buildInputField(localizations.translate('email'), emailController, Icons.email),
                      _buildInputField(localizations.translate('date_of_birth'), dobController, Icons.cake),
                      _buildInputField(localizations.translate('role'), roleController, Icons.verified_user),
                      const SizedBox(height: 24),
                      _sectionTitle(localizations.translate('organization_info')),
                      const SizedBox(height: 16),
                      _buildInputField(localizations.translate('organization'), organizationController, Icons.business),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Center(
              child: CustomButton(
                text: localizations.translate('save_info'),
                color: AppColors.primaryRed,
                textColor: Colors.white,
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    DialogHelper.showAnimatedSuccessDialog(
                      context: context,
                      title: localizations.translate('sign_up_successful'),
                      message: localizations.translate('info_saved_successfully'),
                      buttonText: localizations.translate('close'),
                    );
                  }
                },
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                borderRadius: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserProfileCard() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity, // Làm card bao trọn chiều ngang màn hình
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15), // Tăng padding cho thoáng
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red[300]!, Colors.yellow[50]!], // Gradient xanh lam
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[800]!.withOpacity(0.3), // Shadow xanh đậm
            spreadRadius: 3,
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(30), // Bo góc lớn hơn
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Căn giữa các phần tử bên trong
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red[200]!, Colors.red[400]!], // Gradient tím
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(80),
            ),
            child: CircleAvatar(
              radius: 65, // Tăng kích thước avatar
              backgroundImage: AssetImage(_image),
              backgroundColor: Colors.red[100],
            ),
          ),
          const SizedBox(height: 20), // Tăng khoảng cách cho thoáng
          Text(
            _fullName,
            style: GoogleFonts.poppins(fontSize: 27, fontWeight: FontWeight.bold, color: Colors.black38), // Màu xanh lá
            textAlign: TextAlign.center, // Căn giữa
          ),
          const SizedBox(height: 8),
          Text(
            _address,
            style: GoogleFonts.poppins(fontSize: 19, color: Colors.redAccent[600]), // Xám đậm hơn
            textAlign: TextAlign.center, // Căn giữa
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => _showBloodGroupDialog(context),
            onTapDown: (_) => setState(() => _isBloodCardHovered = true),
            onTapUp: (_) => setState(() => _isBloodCardHovered = false),
            onTapCancel: () => setState(() => _isBloodCardHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isBloodCardHovered
                      ? [Colors.red[700]!, Colors.red[400]!] // Gradient tím khi hover
                      : [Colors.red[300]!, Colors.red[100]!], // Gradient tím nhạt
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: Colors.white, width: 2), // Viền trắng
                borderRadius: BorderRadius.circular(30), // Bo góc lớn hơn
                boxShadow: _isBloodCardHovered
                    ? [
                  BoxShadow(
                    color: Colors.purple[700]!.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.bloodtype, color: _isBloodCardHovered ? Colors.white : Colors.red[700], size: 35),
                  const SizedBox(width: 8),
                  Text(
                    _bloodType,
                    style: GoogleFonts.poppins(
                      color: _isBloodCardHovered ? Colors.white : Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 25,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primaryRed),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, IconData icon) {
    final localizations = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primaryRed, size: 20),
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.primaryRed, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return localizations.translate('please_enter').replaceAll('{field}', label.toLowerCase());
          }
          return null;
        },
      ),
    );
  }

  void _showBloodGroupDialog(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  localizations.translate('choose_the_blood_group'),
                  style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primaryRed),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildBloodOption('A+'),
                    _buildBloodOption('A-'),
                    _buildBloodOption('B+'),
                    _buildBloodOption('B-'),
                    _buildBloodOption('AB+'),
                    _buildBloodOption('AB-'),
                    _buildBloodOption('O+'),
                    _buildBloodOption('O-'),
                  ],
                ),
                const SizedBox(height: 20),
                CustomButton(
                  text: localizations.translate('close'),
                  color: AppColors.primaryRed,
                  textColor: Colors.white,
                  onPressed: () => Navigator.pop(context),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  borderRadius: 12,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBloodOption(String bloodType) {
    bool isSelected = _bloodType == bloodType;
    return GestureDetector(
      onTap: () {
        setState(() {
          _bloodType = bloodType;
        });
        Navigator.pop(context);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(colors: [AppColors.primaryRed, AppColors.darkRed])
              : LinearGradient(colors: [Colors.grey[200]!, Colors.grey[300]!]),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
            BoxShadow(
              color: AppColors.primaryRed.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ]
              : [],
        ),
        child: Center(
          child: Text(
            bloodType,
            style: GoogleFonts.poppins(
              color: isSelected ? Colors.white : Colors.black87,
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }
}