import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:blood_plus/core/constants/app_colors.dart';

import '../../core/widgets/custom_button_navBar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> features = [
    {'icon': Icons.favorite, 'title': 'Donate\nBlood', 'color': Colors.red},
    {'icon': Icons.request_page, 'title': 'Request\nBlood', 'color': Colors.blue},
    {'icon': Icons.local_hospital, 'title': 'Blood\nBank', 'color': Colors.orange},
    {'icon': Icons.local_hospital, 'title': 'Hospital', 'color': Colors.green},
    {'icon': Icons.inbox, 'title': 'Inbox', 'color': Colors.purple},
    {'icon': Icons.emergency, 'title': 'Emergency\nNumbers', 'color': Colors.red},
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
    switch (index) {
      case 0:
        break;
      case 1:
        print('Chuyển đến Sự kiện');
        break;
      case 2:
        print('Chuyển đến Hiến máu');
        break;
      case 3:
        print('Chuyển đến Hồ sơ');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _HeaderSection(),
            const SizedBox(height: 16),
            _NewsCarousel(newsItems: newsItems),
            const SizedBox(height: 20),
            _FeatureGrid(features: features),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

// ======================= HEADER ========================

class _HeaderSection extends StatelessWidget {
  const _HeaderSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
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
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _CampaignCard(
                title: 'Lifesaver',
                subtitle: '15 People',
                icon: Icons.favorite,
                color: Colors.orange,
              ),
              _CampaignCard(
                title: 'Next Donation',
                subtitle: '54 Days Left',
                icon: Icons.calendar_today,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CampaignCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _CampaignCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(subtitle, style: const TextStyle(color: Colors.white)),
          ],
        )
      ],
    );
  }
}

// ======================= NEWS ========================

class _NewsCarousel extends StatelessWidget {
  final List<Map<String, String>> newsItems;

  const _NewsCarousel({required this.newsItems});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Tin tức',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        CarouselSlider(
          options: CarouselOptions(
            height: 240,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.8,
          ),
          items: newsItems.map((item) {
            return Builder(
              builder: (_) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey[100],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
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
                style: const TextStyle(fontSize: 13),
              ),
            ],
          );
        },
      ),
    );
  }
}