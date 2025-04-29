import 'package:flutter/material.dart';
import 'package:blood_plus/core/constants/app_colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Danh sách các chức năng với biểu tượng từ Icons
  final List<Map<String, dynamic>> features = [
    {'icon': Icons.calendar_today, 'title': 'Đặt lịch', 'color': Colors.blue},
    {'icon': Icons.location_on, 'title': 'Địa điểm', 'color': Colors.yellow},
    {'icon': Icons.local_hospital, 'title': 'Bệnh viện', 'color': Colors.orange},
    {'icon': Icons.group, 'title': 'Nhóm', 'color': Colors.cyan},
    {'icon': Icons.person, 'title': 'Bạn bè', 'color': Colors.green},
    {'icon': Icons.contact_mail, 'title': 'Liên hệ', 'color': Colors.red},
    {'icon': Icons.local_offer, 'title': 'Ưu đãi', 'color': Colors.purple},
    {'icon': Icons.question_answer, 'title': 'Hỏi đáp', 'color': Colors.green},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 0:
        break;
      case 1:
        print('Chuyển đến Lịch sử');
        break;
      case 2:
        print('Chuyển đến Mã QR');
        break;
      case 3:
        print('Chuyển đến Thông báo');
        break;
      case 4:
        print('Chuyển đến Cài đặt');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 20),
            _buildFeatureGrid(),
            const SizedBox(height: 20),
            _buildBanner(),
            const SizedBox(height: 20),
            _buildNewsSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.primaryRed,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Xin chào, Dương Thành Thoại',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Bạn đã đủ điều kiện hiến máu!',
            style: TextStyle(
              fontSize: 16,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Nhóm máu',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Lần hiến máu',
                  style: TextStyle(color: AppColors.white),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1,
        ),
        itemCount: features.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: features[index]['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  features[index]['icon'],
                  size: 40,
                  color: features[index]['color'],
                ),
              ),
              const SizedBox(height: 5),
              Text(
                features[index]['title'],
                style: const TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Image.asset(
          'assets/images/banner.jpg',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildNewsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tin tức',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: const Text(
                  'Tất cả',
                  style: TextStyle(
                    fontSize: 16,
                    color: AppColors.primaryRed,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildNewsItem(
            image: 'assets/images/news1.jpg',
            title: 'Hàng trăm “giọt viên hồng” được trao tặng tại “Ngày Chủ Nhật Đỏ”...',
            date: '01/4/2025',
          ),
          const SizedBox(height: 10),
          _buildNewsItem(
            image: 'assets/images/news2.jpg',
            title: 'Người dân phường Hòa chia sẻ giọt máu hồng cứu người',
            date: '30/3/2025',
          ),
        ],
      ),
    );
  }

  Widget _buildNewsItem({required String image, required String title, required String date}) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            image,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                date,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.history),
          label: 'Lịch sử',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.qr_code),
          label: 'Mã QR',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.notifications),
          label: 'Thông báo',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Cài đặt',
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppColors.primaryRed,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }
}