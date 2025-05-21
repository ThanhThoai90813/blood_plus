import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:flutter/material.dart';
import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/widgets/custom_button.dart';
import 'package:blood_plus/features/auth/enter_verification_code_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _isEmailSelected = true;
  final TextEditingController _inputController = TextEditingController();

  void _handleSendOTP() {
    final localizations = AppLocalizations.of(context);
    String input = _inputController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.translate('please_enter_email_or_phone'))),
      );
      return;
    }
    if (_isEmailSelected && (!input.contains('@') || !input.contains('.'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.translate('please_enter_valid_email'))),
      );
      return;
    }
    if (!_isEmailSelected && input.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.translate('please_enter_valid_phone'))),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EnterVerificationCodeScreen(
          contact: _isEmailSelected ? input : '0852818***',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  localizations.translate('forgot_password'),
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  localizations.translate('select_reset_method'),
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _isEmailSelected
                              ? AppColors.primaryRed
                              : Colors.grey.shade200,
                          foregroundColor:
                          _isEmailSelected ? Colors.white : Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          setState(() {
                            _isEmailSelected = true;
                            _inputController.clear();
                          });
                        },
                        child: Text(
                          localizations.translate('email'),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: !_isEmailSelected
                              ? AppColors.primaryRed
                              : Colors.grey.shade200,
                          foregroundColor:
                          !_isEmailSelected ? Colors.white : Colors.black87,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          setState(() {
                            _isEmailSelected = false;
                            _inputController.clear();
                          });
                        },
                        child: Text(
                          localizations.translate('phone'),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _inputController,
                  keyboardType: _isEmailSelected
                      ? TextInputType.emailAddress
                      : TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: _isEmailSelected
                        ? localizations.translate('enter_your_email')
                        : localizations.translate('phone_number'),
                    prefixIcon: Icon(
                      _isEmailSelected ? Icons.email_outlined : Icons.phone,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    text: localizations.translate('send_otp'),
                    color: AppColors.primaryRed,
                    onPressed: _handleSendOTP,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    borderRadius: 10,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}