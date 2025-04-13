import 'package:flutter/material.dart';
import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/widgets/custom_button.dart';
import 'package:blood_plus/features/auth/enter_verification_code_screen.dart';

// ------------------ ForgotPasswordScreen -----------------
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  bool _isEmailSelected = true;
  final TextEditingController _inputController = TextEditingController();

  void _handleSendOTP() {
    String input = _inputController.text.trim();
    if (input.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter your email or phone number.')),
      );
      return;
    }
    if (_isEmailSelected && (!input.contains('@') || !input.contains('.'))) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email.')),
      );
      return;
    }
    if (!_isEmailSelected && input.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid phone number.')),
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryRed,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Select a method to reset your password.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 50),
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
                    child: const Text('Email'),
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
                    child: const Text('Phone'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 25),
            TextField(
              controller: _inputController,
              keyboardType: _isEmailSelected
                  ? TextInputType.emailAddress
                  : TextInputType.phone,
              decoration: InputDecoration(
                hintText: _isEmailSelected
                    ? 'Enter your email'
                    : 'Enter your phone number',
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const Spacer(),
            CustomButton(
              text: 'Send OTP',
              color: AppColors.primaryRed,
              onPressed: _handleSendOTP,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}

