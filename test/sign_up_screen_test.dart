
import 'package:blood_plus/presentation/features/auth/login_screen.dart';
import 'package:blood_plus/presentation/features/auth/sign_up_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Nhóm các test case cho SignUpScreen
  group('SignUpScreen Tests', () {
    // Test case 1: Kiểm tra giao diện hiển thị đúng
    testWidgets('SignUpScreen displays all UI elements', (WidgetTester tester) async {
      // Tạo widget SignUpScreen
      await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

      // Kiểm tra tiêu đề "Sign Up"
      expect(find.text('Sign Up'), findsOneWidget);

      // Kiểm tra các trường nhập liệu
      expect(find.byType(TextField), findsNWidgets(3)); // Có 3 TextField: name, email, password
      expect(find.text('Enter your name'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);
      expect(find.text('Enter your password'), findsOneWidget);

      // Kiểm tra checkbox điều khoản
      expect(find.byType(Checkbox), findsOneWidget);
      expect(find.text('I agree to the medidoc Terms of Service \nand Privacy Policy'), findsOneWidget);

      // Kiểm tra nút "Sign Up"
      expect(find.text('Sign Up'), findsOneWidget);

      // Kiểm tra liên kết "Log In"
      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Log In'), findsOneWidget);
    });

    // Test case 2: Kiểm tra validation - không nhập đủ trường
    testWidgets('SignUpScreen shows error when fields are empty', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

      // Nhấn nút "Sign Up" mà không nhập gì
      await tester.tap(find.text('Sign Up'));
      await tester.pump(); // Cập nhật giao diện

      // Kiểm tra thông báo lỗi
      expect(find.text('Please fill in all fields.'), findsOneWidget);
    });

    // Test case 3: Kiểm tra validation - email không hợp lệ
    testWidgets('SignUpScreen shows error for invalid email', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

      // Nhập dữ liệu
      await tester.enterText(find.widgetWithText(TextField, 'Enter your name'), 'Nguyen Van A');
      await tester.enterText(find.widgetWithText(TextField, 'Enter your email'), 'invalid-email'); // Email không hợp lệ
      await tester.enterText(find.widgetWithText(TextField, 'Enter your password'), 'password123');

      // Đánh dấu checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Nhấn nút "Sign Up"
      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      // Kiểm tra thông báo lỗi
      expect(find.text('Please enter a valid email.'), findsOneWidget);
    });

    // Test case 4: Kiểm tra validation - không đồng ý điều khoản
    testWidgets('SignUpScreen shows error when terms are not agreed', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: SignUpScreen()));

      // Nhập dữ liệu hợp lệ
      await tester.enterText(find.widgetWithText(TextField, 'Enter your name'), 'Nguyen Van A');
      await tester.enterText(find.widgetWithText(TextField, 'Enter your email'), 'test@example.com');
      await tester.enterText(find.widgetWithText(TextField, 'Enter your password'), 'password123');

      // Không đánh dấu checkbox
      // Nhấn nút "Sign Up"
      await tester.tap(find.text('Sign Up'));
      await tester.pump();

      // Kiểm tra thông báo lỗi
      expect(find.text('You must agree to the terms.'), findsOneWidget);
    });

    // Test case 5: Kiểm tra đăng ký thành công
    testWidgets('SignUpScreen shows success dialog and navigates to LoginScreen on successful signup', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          // Định nghĩa routes để điều hướng
          routes: {
            '/': (context) => const SignUpScreen(),
            '/login': (context) => const LoginScreen(),
          },
          initialRoute: '/',
        ),
      );

      // Nhập dữ liệu hợp lệ
      await tester.enterText(find.widgetWithText(TextField, 'Enter your name'), 'Nguyen Van A');
      await tester.enterText(find.widgetWithText(TextField, 'Enter your email'), 'test@example.com');
      await tester.enterText(find.widgetWithText(TextField, 'Enter your password'), 'password123');

      // Đánh dấu checkbox
      await tester.tap(find.byType(Checkbox));
      await tester.pump();

      // Nhấn nút "Sign Up"
      await tester.tap(find.text('Sign Up'));
      await tester.pumpAndSettle(); // Đợi dialog hiển thị

      // Kiểm tra dialog thành công
      expect(find.text('Sign Up Successful'), findsOneWidget);
      expect(find.text('Your account has been created successfully!'), findsOneWidget);
      expect(find.text('Go to Login'), findsOneWidget);

      // Nhấn nút "Go to Login" trên dialog
      await tester.tap(find.text('Go to Login'));
      await tester.pumpAndSettle(); // Đợi điều hướng

      // Kiểm tra xem đã điều hướng đến LoginScreen chưa
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });
  });
}