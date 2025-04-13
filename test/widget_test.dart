import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:blood_plus/main.dart';
import 'package:blood_plus/features/splash/splash_screen.dart';
import 'package:blood_plus/features/onboarding/started_screen.dart';

void main() {
  testWidgets('Splash screen scales logo and navigates to started screen', (WidgetTester tester) async {
    await tester.pumpWidget(const BloodDonationApp());

    expect(find.text('Blood Donation'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));

    expect(find.byType(StartedScreen), findsOneWidget);
    expect(find.text("Let's get started!"), findsOneWidget);
    expect(find.text('Login to enjoy the features we’ve\nprovided, and stay healthy!'), findsOneWidget);
    expect(find.text('Login'), findsOneWidget);
    expect(find.text('Sign Up'), findsOneWidget);
    expect(find.byType(Image), findsOneWidget);
  });
}