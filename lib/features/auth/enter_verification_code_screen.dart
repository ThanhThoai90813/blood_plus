import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:flutter/material.dart';
import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/widgets/custom_button.dart';
import 'package:blood_plus/features/auth/create_new_password_screen.dart';

class EnterVerificationCodeScreen extends StatefulWidget {
  final String contact;

  const EnterVerificationCodeScreen({Key? key, required this.contact}) : super(key: key);

  @override
  _EnterVerificationCodeScreenState createState() => _EnterVerificationCodeScreenState();
}

class _EnterVerificationCodeScreenState extends State<EnterVerificationCodeScreen> {
  final List<TextEditingController> _otpControllers = List.generate(4, (_) => TextEditingController());

  void _handleVerify() {
    final localizations = AppLocalizations.of(context);
    String otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(localizations.translate('please_enter_4_digit_code'))),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateNewPasswordScreen(),
      ),
    );
  }

  void _handleResend() {
    final localizations = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(localizations.translate('otp_resent'))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: AppColors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.translate('enter_verification_code'),
              style: const TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryRed,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              localizations.translate('enter_code_sent_to').replaceAll('{contact}', widget.contact),
              style: const TextStyle(fontSize: 17, color: Colors.black87),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) {
                return SizedBox(
                  width: 65,
                  child: TextField(
                    controller: _otpControllers[index],
                    keyboardType: TextInputType.number,
                    maxLength: 1,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      counterText: '',
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primaryRed, width: 2),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 1 && index < 3) {
                        FocusScope.of(context).nextFocus();
                      }
                    },
                  ),
                );
              }),
            ),
            const SizedBox(height: 40),
            Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: CustomButton(
                  text: localizations.translate('verify'),
                  color: AppColors.primaryRed,
                  onPressed: _handleVerify,
                  padding: const EdgeInsets.symmetric(vertical: 23),
                ),
              ),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  localizations.translate('didnt_receive_code'),
                  style: const TextStyle(fontSize: 15, color: Colors.black54),
                ),
                TextButton(
                  onPressed: _handleResend,
                  child: Text(
                    localizations.translate('resend'),
                    style: const TextStyle(fontSize: 20, color: AppColors.primaryRed),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}