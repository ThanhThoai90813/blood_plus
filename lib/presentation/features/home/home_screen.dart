import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/widgets/custom_button_navBar.dart';
import 'package:blood_plus/core/widgets/feature_grid.dart';
import 'package:blood_plus/core/widgets/header_section.dart';
import 'package:blood_plus/core/widgets/news_carousel.dart';
import 'package:blood_plus/presentation/features/user/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  final List<Map<String, dynamic>> features = [
    {'icon': Icons.favorite, 'title': 'schedule_donation', 'color': Colors.red},
    {'icon': Icons.emergency, 'title': 'emergency_donation', 'color': Colors.red},
    {'icon': Icons.local_hospital, 'title': 'nearby_hospitals', 'color': Colors.green},
    {'icon': Icons.request_page, 'title': 'blog_list', 'color': Colors.blue},
    {'icon': Icons.local_hospital, 'title': 'expert_advice', 'color': Colors.orange},
    {'icon': Icons.inbox, 'title': 'information', 'color': Colors.purple},
  ];

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ProfileScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryRed,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        body: SafeArea(
          top: false,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: RefreshIndicator(
              onRefresh: () async {
                // Refresh logic here
                await Future.delayed(const Duration(seconds: 1));
              },
              color: AppColors.primaryRed,
              child: ListView(
                padding: EdgeInsets.zero,
                physics: const BouncingScrollPhysics(),
                children: [
                  HeaderSection(),
                  const SizedBox(height: 8),
                  NewsCarousel(),
                  const SizedBox(height: 16),
                  FeatureGrid(features: features),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: CustomBottomNavBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
    );
  }
}