import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/core/services/user_manager.dart';
import 'package:blood_plus/core/utils/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/widgets/custom_button.dart';
import 'package:blood_plus/core/models/user_model.dart';
import 'package:blood_plus/core/services/user_service.dart';

class AccountInfoScreen extends StatefulWidget {
  const AccountInfoScreen({Key? key}) : super(key: key);

  @override
  State<AccountInfoScreen> createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isBloodCardHovered = false;
  final UserManager _userManager = UserManager();
  final UserService _userService = UserService();

  TextEditingController emailController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  Future<UserModel?> _loadUserInfo() async {
    final userId = await _userManager.getUserId();
    if (userId == null) {
      print('Error: userId is null');
      return null;
    }
    final token = await _userManager.getUserToken();
    if (token == null) {
      print('Error: token is null');
      return null;
    }
    try {
      final cachedUser = await _userManager.getUserInfo(userId);
      if (cachedUser != null) {
        emailController.text = cachedUser.email;
        dobController.text = cachedUser.dateOfBirth?.toString().split(' ')[0] ?? '';
        print('Loaded user from SharedPreferences: ${cachedUser.toJson()}');
        return cachedUser;
      }
      print('No cached user, fetching from API');
      final user = await _userService.getUserInfo(userId, token);
      await _userManager.saveUserInfo(userId, user);
      emailController.text = user.email;
      dobController.text = user.dateOfBirth?.toString().split(' ')[0] ?? '';
      print('Loaded user from API: ${user.toJson()}');
      return user;
    } catch (e) {
      print('Error loading user info: $e');
      return null;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    dobController.dispose();
    super.dispose();
  }

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
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<UserModel?>(
        future: _loadUserInfo(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data != null) {
            final user = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserProfileCard(
                    name: user.name,
                    address: user.address ?? 'Không có địa chỉ',
                    bloodType: user.bloodType ?? 'Không xác định',
                    userImage: user.userImage ?? 'assets/images/profile.jpg',
                  ),
                  const SizedBox(height: 30),
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
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
                            _buildInputField(localizations.translate('email'),
                                emailController, Icons.email),
                            _buildInputField(localizations.translate('date_of_birth'),
                                dobController, Icons.cake),
                            _buildReadOnlyField(localizations.translate('job'),
                                user.job ?? 'Không có nghề nghiệp', Icons.work),
                            _buildReadOnlyField(
                                localizations.translate('donation_count'),
                                user.donationCount.toString(),
                                Icons.favorite),
                            _buildReadOnlyField(
                                localizations.translate('passport_number'),
                                user.passportNumber ?? 'Không có số hộ chiếu',
                                Icons.book),
                            _buildReadOnlyField(
                                localizations.translate('latitude'),
                                user.latitude?.toString() ?? 'N/A',
                                Icons.location_on),
                            _buildReadOnlyField(
                                localizations.translate('longitude'),
                                user.longitude?.toString() ?? 'N/A',
                                Icons.location_on),
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
            );
          } else {
            return const Center(child: Text('Không tìm thấy thông tin người dùng'));
          }
        },
      ),
    );
  }

  Widget _buildUserProfileCard({
    required String name,
    required String address,
    required String bloodType,
    required String userImage,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.red[300]!, Colors.yellow[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.blue[800]!.withOpacity(0.3),
            spreadRadius: 3,
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.red[200]!, Colors.red[400]!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(80),
            ),
            child: ClipOval(
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/profile.jpg'),
                image: userImage.startsWith('http') || userImage.startsWith('https')
                    ? NetworkImage(userImage)
                    : const AssetImage('assets/images/profile.jpg') as ImageProvider,
                width: 130, // Đảm bảo kích thước phù hợp với CircleAvatar
                height: 130,
                fit: BoxFit.cover,
                imageErrorBuilder: (context, error, stackTrace) {
                  print('Image load error for $userImage: $error');
                  return Image.asset('assets/images/profile.jpg', width: 130, height: 130, fit: BoxFit.cover);
                },
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            name,
            style: GoogleFonts.poppins(
                fontSize: 27, fontWeight: FontWeight.bold, color: Colors.black38),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            address,
            style: GoogleFonts.poppins(fontSize: 19, color: Colors.redAccent[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => _showBloodGroupDialog(context, bloodType),
            onTapDown: (_) => setState(() => _isBloodCardHovered = true),
            onTapUp: (_) => setState(() => _isBloodCardHovered = false),
            onTapCancel: () => setState(() => _isBloodCardHovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: _isBloodCardHovered
                      ? [Colors.red[700]!, Colors.red[400]!]
                      : [Colors.red[300]!, Colors.red[100]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(30),
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
                  Icon(Icons.bloodtype,
                      color: _isBloodCardHovered ? Colors.white : Colors.red[700],
                      size: 35),
                  const SizedBox(width: 8),
                  Text(
                    bloodType,
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
      style: GoogleFonts.poppins(
          fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.primaryRed),
    );
  }

  Widget _buildInputField(
      String label, TextEditingController controller, IconData icon) {
    final localizations = AppLocalizations.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
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
            return localizations
                .translate('please_enter')
                .replaceAll('{field}', label.toLowerCase());
          }
          return null;
        },
      ),
    );
  }

  Widget _buildReadOnlyField(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: TextFormField(
        initialValue: value,
        readOnly: true,
        style: GoogleFonts.poppins(
            fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: AppColors.primaryRed, size: 20),
          labelText: label,
          labelStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[600]),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[300]!, width: 1.5),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 14),
        ),
      ),
    );
  }

  void _showBloodGroupDialog(BuildContext context, String currentBloodType) {
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
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryRed),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  alignment: WrapAlignment.center,
                  children: [
                    _buildBloodOption('A+', currentBloodType),
                    _buildBloodOption('A-', currentBloodType),
                    _buildBloodOption('B+', currentBloodType),
                    _buildBloodOption('B-', currentBloodType),
                    _buildBloodOption('AB+', currentBloodType),
                    _buildBloodOption('AB-', currentBloodType),
                    _buildBloodOption('O+', currentBloodType),
                    _buildBloodOption('O-', currentBloodType),
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

  Widget _buildBloodOption(String bloodType, String currentBloodType) {
    bool isSelected = currentBloodType == bloodType;
    return GestureDetector(
      onTap: () {
        setState(() {
          // Cập nhật bloodType nếu cần lưu lại (có thể gửi lên API sau)
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