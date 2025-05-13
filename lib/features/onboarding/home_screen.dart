import 'package:blood_plus/core/utils/dialog_helper.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/custom_button_navBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> features = [
    {'icon': Icons.favorite, 'title': 'Đặt Lịch\nHiến Máu', 'color': Colors.red},
    {'icon': Icons.emergency, 'title': 'Hiến Máu\nKhẩn Cấp!', 'color': Colors.red},
    {'icon': Icons.local_hospital, 'title': 'Bệnh viện\nGần Đây', 'color': Colors.green},
    {'icon': Icons.request_page, 'title': 'Sự Kiện\nNổi Bật', 'color': Colors.blue},
    {'icon': Icons.local_hospital, 'title': 'Lời khuyên\nChuyên Gia', 'color': Colors.orange},
    {'icon': Icons.inbox, 'title': 'Các thông\ntin', 'color': Colors.purple},
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
    // TODO: Navigate to other screens
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: AppColors.primaryRed, // Khớp với màu của header
        statusBarIconBrightness: Brightness.light, // Biểu tượng sáng để tương phản
        statusBarBrightness: Brightness.dark, // Dành cho iOS
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          top: false, // Tắt SafeArea cho phần trên để header mở rộng
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _HeaderSection(),
              const SizedBox(height: 15),
              _NewsCarousel(newsItems: newsItems),
              const SizedBox(height: 15),
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

// ======================= HEADER SECTION ========================
class _HeaderSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;

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
              const CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage('assets/images/profile.jpg'),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Duong Thanh Thoai',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    'P13, Binh Thanh, HCM',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              const Icon(Icons.notifications, color: Colors.white, size: 30),
            ],
          ),
          const SizedBox(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Expanded(
                child: _CampaignCard(
                  title: 'Lần hiến máu',
                  subtitle: '15',
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
                      title: 'Thông Báo',
                      message: 'Thời gian có thể tiếp tục hiến máu là 54 ngày nữa',
                      buttonText: 'OK',
                    );
                  },
                  child: const _CampaignCard(
                    title: '', // Hide title
                    subtitle: 'Còn: 54 ngày', // Add context to subtitle
                    image: 'assets/images/blood.png',
                    color: Colors.red,
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

// ======================= CAMPAIGN CARD ========================
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
      padding: const EdgeInsets.all(12),
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
          const SizedBox(width: 8),
          SizedBox(
            width: 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center, // Center vertically
              children: [
                if (title.isNotEmpty) // Only show title if not empty
                  AutoSizeText(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    minFontSize: 12,
                  ),
                AutoSizeText(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================= NEWS CAROUSEL ========================
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 27),
          child: Text(
            'Tin Tức',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 16),
        CarouselSlider(
          options: CarouselOptions(
            height: 240,
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
                        height: 140,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: AutoSizeText(
                        item['title']!,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
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

// ======================= FEATURE GRID ========================
class _FeatureGrid extends StatelessWidget {
  final List<Map<String, dynamic>> features;

  const _FeatureGrid({required this.features});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: features.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemBuilder: (_, index) {
          final feature = features[index];
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: feature['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(feature['icon'], size: 32, color: feature['color']),
              ),
              const SizedBox(height: 8),
              Text(
                feature['title'],
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}