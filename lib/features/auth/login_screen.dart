import 'package:blood_plus/core/utils/dialog_helper.dart';
import 'package:blood_plus/features/auth/sign_up_screen.dart';
import 'package:blood_plus/features/onboarding/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:blood_plus/core/constants/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true; // Trạng thái ẩn/hiện mật khẩu

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Tiêu đề "Login"
              const Text(
                'Login',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 60),

              // Trường nhập email
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primaryRed), // Viền đỏ khi focus
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 27),

              // Trường nhập mật khẩu
              TextField(
                obscureText: _obscureText,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primaryRed), // Viền đỏ khi focus
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Liên kết "Forgot Password?"
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ForgotPasswordScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    'Forgot Password?',
                    style: TextStyle(
                      color: AppColors.primaryRed, // Đổi màu thành đỏ
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Nút "Login"
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7, // 70% chiều rộng màn hình
                  child: CustomButton(
                    text: 'Login',
                    color: AppColors.primaryRed,
                    onPressed: () {
                      DialogHelper.showAnimatedSuccessDialog(
                          context: context,
                          title: "Login Successful",
                          message: "Welcome!",
                          buttonText: 'Go to Home',
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const HomeScreen(),
                              ),
                            );
                          },
                        );
                      },
                    padding: const EdgeInsets.symmetric(vertical: 19),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Liên kết "Sign Up"
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account? ",
                    style: TextStyle(fontSize: 15, color: AppColors.black),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignUpScreen(),
                        ),
                      );
                    },

                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(
                        fontSize: 17,
                        color: AppColors.primaryRed, // Đổi màu thành đỏ
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60),


              // Phân cách "OR"

              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'OR',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 20),

              // Nút "Sign in with Google"
              OutlinedButton.icon(
                onPressed: () {
                  print('Sign in with Google pressed');
                },
                icon: Image.asset(
                  'assets/icons/google_logo.png', // Sử dụng logo cục bộ
                  width: 24,
                  height: 24,
                ),
                label: const Text(
                  'Sign in with Google',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Nút "Sign in with Apple"
              OutlinedButton.icon(
                onPressed: () {
                  print('Sign in with Apple pressed');
                },
                icon: const Icon(
                  Icons.apple, // Sử dụng biểu tượng có sẵn của Flutter
                  color: AppColors.black,
                  size: 24,
                ),
                label: const Text(
                  'Sign in with Apple',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Nút "Sign in with Facebook"
              OutlinedButton.icon(
                onPressed: () {
                  print('Sign in with Facebook pressed');
                },
                icon: Image.asset(
                  'assets/icons/facebook_logo.png', // Sử dụng logo cục bộ
                  width: 24,
                  height: 24,
                ),
                label: const Text(
                  'Sign in with Facebook',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.black,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  minimumSize: const Size(double.infinity, 50),
                  side: const BorderSide(color: Colors.grey),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}