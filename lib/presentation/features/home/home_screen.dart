import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/core/widgets/dialog_helper.dart';
import 'package:blood_plus/core/widgets/custom_button_navBar.dart';
import 'package:blood_plus/data/manager/user_manager.dart';
import 'package:blood_plus/data/models/user_model.dart';
import 'package:blood_plus/presentation/features/blog/blog_screen.dart';
import 'package:blood_plus/presentation/features/home/expert_advice_screen.dart';
import 'package:blood_plus/presentation/features/home/other_information_screen.dart';
import 'package:blood_plus/presentation/features/schedule/schedule_donation_screen.dart';
import 'package:blood_plus/presentation/features/user/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> features = [
    {'icon': Icons.favorite, 'title': 'schedule_donation', 'color': Colors.red},
    {'icon': Icons.emergency, 'title': 'emergency_donation', 'color': Colors.red},
    {'icon': Icons.local_hospital, 'title': 'nearby_hospitals', 'color': Colors.green},
    {'icon': Icons.request_page, 'title': 'blog_list', 'color': Colors.blue},
    {'icon': Icons.local_hospital, 'title': 'expert_advice', 'color': Colors.orange},
    {'icon': Icons.inbox, 'title': 'information', 'color': Colors.purple},
  ];

  final List<Map<String, String>> newsItems = [
    {
      'image': 'assets/images/news1.jpg',
      'title': 'Hàng trăm “giọt viên hồng” được trao tặng tại “Ngày Chủ Nhật Đỏ”…',
      'date': '01/4/2025',
    },
    {
      'image': 'assets/images/news2.jpg',
      'title': 'Người dân phường Hòa chia sẻ giọt máu hồng cứu người',
      'date': '30/3/2025',
    },
    {
      'image': 'assets/images/news1.jpg',
      'title': 'Chiến dịch hiến máu toàn quốc thu hút hàng nghìn người',
      'date': '28/3/2025',
    },
  ];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
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
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _HeaderSection(),
              const SizedBox(height: 15),
              _NewsCarousel(newsItems: newsItems),
              _FeatureGrid(features: features),
            ],
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

class _HeaderSection extends StatefulWidget {
  @override
  _HeaderSectionState createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<_HeaderSection> {
  final UserManager _userManager = UserManager();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userId = await _userManager.getUserId();
    if (userId != null) {
      final user = await _userManager.getUserInfo(userId);
      if (user != null) {
        setState(() {
          _user = user;
        });
      }
    }
  }

  String _truncateAddress(String? address, int maxLength) {
    if (address == null) return 'Loading...';
    if (address.length <= maxLength) return address;
    return '${address.substring(0, maxLength - 3)}...';
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Container(
      padding: EdgeInsets.fromLTRB(24, statusBarHeight + 24, 24, 24),
      decoration: const BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipOval(
                  child: FadeInImage(
                    placeholder: const AssetImage('assets/images/profile.jpg'),
                    image: _user?.userImage != null && (_user!.userImage!.startsWith('http') || _user!.userImage!.startsWith('https'))
                        ? NetworkImage(_user!.userImage!)
                        : const AssetImage('assets/images/profile.jpg') as ImageProvider,
                    width: 74,
                    height: 74,
                    fit: BoxFit.cover,
                    imageErrorBuilder: (context, error, stackTrace) {
                      debugPrint('Image load error for ${_user?.userImage}: $error');
                      return Image.asset(
                        'assets/images/profile.jpg',
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _user?.name ?? 'Loading...',
                    style: GoogleFonts.poppins(
                      fontSize: 22 * 1.2, // Increase font size by 30%
                      fontWeight: FontWeight.w600,
                      color: AppColors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    _truncateAddress(_user?.address, 30),
                    style: GoogleFonts.poppins(
                      fontSize: 13 * 1.1, // Increase font size by 30%
                      color: Colors.white70,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.notifications, color: Colors.white, size: 30),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: _CampaignCard(
                  title: localizations.translate('donation_times'),
                  subtitle: (_user?.donationCount ?? 0).toString(),
                  image: 'assets/images/blood.png',
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    DialogHelper.showAnimatedSuccessDialog(
                      context: context,
                      title: localizations.translate('donation_day_count_title'),
                      message: localizations.translate('donation_day_count_message').replaceAll('{days}', '0'),
                      buttonText: localizations.translate('ok'),
                    );
                  },
                  child: _ProgressCircle(
                    daysLeft: 40,
                    totalDays: 90,
                    label: localizations.translate('days_left'),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProgressCircle extends StatefulWidget {
  final int daysLeft;
  final int totalDays;
  final String label;

  const _ProgressCircle({
    required this.daysLeft,
    required this.totalDays,
    required this.label,
  });

  @override
  _ProgressCircleState createState() => _ProgressCircleState();
}

class _ProgressCircleState extends State<_ProgressCircle> with SingleTickerProviderStateMixin {
  late AnimationController _glowController;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();
    _glowController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);
    _glowAnimation = Tween<double>(begin: 0.4, end: 0.8).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOutCubic),
    );
  }

  @override
  void dispose() {
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final double progress = (widget.totalDays - widget.daysLeft) / widget.totalDays;
    final bool canDonate = widget.daysLeft == 0;

    return GestureDetector(
      onTap: () {
        DialogHelper.showAnimatedSuccessDialog(
          context: context,
          title: canDonate
              ? localizations.translate('donation_today_title')
              : localizations.translate('donation_day_count_title'),
          message: canDonate
              ? localizations.translate('donation_today_message')
              : localizations.translate('donation_day_count_message').replaceAll('{days}', widget.daysLeft.toString()),
          buttonText: localizations.translate('ok'),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        canDonate ? Colors.green.withOpacity(0.3) : Colors.pink.withOpacity(0.3),
                        Colors.white.withOpacity(0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: canDonate
                        ? [
                      BoxShadow(
                        color: Colors.green.withOpacity(_glowAnimation.value * 0.4),
                        blurRadius: 12,
                        spreadRadius: 3,
                      ),
                    ]
                        : [
                      BoxShadow(
                        color: Colors.red.withOpacity(_glowAnimation.value * 0.2),
                        blurRadius: 8,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 66,
                  height: 66,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 14,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      canDonate ? Colors.green : Colors.red,
                    ),
                    semanticsLabel: canDonate
                        ? localizations.translate('donation_today_title')
                        : localizations.translate('days_left').replaceAll('{days}', widget.daysLeft.toString()),
                  ),
                ),
                canDonate
                    ? Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 32,
                      semanticLabel: localizations.translate('donation_today_title'),
                    ),
                  ],
                )
                    : Text(
                  '${widget.daysLeft}',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                  semanticsLabel: localizations.translate('days_left').replaceAll('{days}', widget.daysLeft.toString()),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AutoSizeText(
              canDonate
                  ? localizations.translate('donation_today_title')
                  : localizations.translate('days_left').replaceAll('{days}', widget.daysLeft.toString()),
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
              maxLines: 2,
              minFontSize: 10,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String image;
  final Color color;

  const _CampaignCard({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.2),
            child: Image.asset(
              image,
              width: 40,
              height: 40,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (title.isNotEmpty)
                  AutoSizeText(
                    title,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 12,
                  ),
                AutoSizeText(
                  subtitle,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  minFontSize: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NewsCarousel extends StatefulWidget {
  final List<Map<String, String>> newsItems;

  const _NewsCarousel({required this.newsItems});

  @override
  _NewsCarouselState createState() => _NewsCarouselState();
}

class _NewsCarouselState extends State<_NewsCarousel> {
  int _currentIndex = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27),
          child: Text(
            localizations.translate('news'),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 16),
        CarouselSlider(
          options: CarouselOptions(
            height: 260,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.8,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          items: widget.newsItems.map((item) {
            return Builder(
              builder: (_) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.transparent,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      child: Image.asset(
                        item['image']!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 48,
                              child: AutoSizeText(
                                item['title']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w600,
                                  height: 1.4,
                                  color: Colors.black87,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                minFontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['date']!,
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.newsItems.asMap().entries.map((entry) {
            int index = entry.key;
            return GestureDetector(
              child: Container(
                width: _currentIndex == index ? 24.0 : 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.0),
                  color: _currentIndex == index
                      ? Colors.red
                      : Colors.grey.withOpacity(0.5),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  final List<Map<String, dynamic>> features;

  const _FeatureGrid({required this.features});

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: features.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (_, index) {
          final feature = features[index];
          return GestureDetector(
            onTap: () {
              if (feature['title'] == 'expert_advice') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ExpertAdviceScreen(),
                  ),
                );
              } else if (feature['title'] == 'information') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const InformationScreen(),
                  ),
                );
              } else if (feature['title'] == 'schedule_donation') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ScheduleDonationScreen(),
                  ),
                );
              } else if (feature['title'] == 'blog_list') {
                Navigator.push(
                    context,
                  MaterialPageRoute(
                    builder: (context) => const BlogScreen(),
                  ),
                );
              }
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: feature['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Icon(feature['icon'], size: 32, color: feature['color']),
                ),
                const SizedBox(height: 10),
                Text(
                  localizations.translate(feature['title']),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}