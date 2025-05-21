import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> emergencyNumbers = [
    {
      'name': 'Trung tâm Truyền máu Chợ Rẫy',
      'number': '(+84) 28 3855 5730',
    },
    {
      'name': 'Viện Huyết học - Truyền máu Trung ương',
      'number': '(+84) 24 3868 6008',
    },
    {
      'name': 'Trung tâm Truyền máu Bệnh viện Bạch Mai',
      'number': '(+84) 24 3869 3721',
    },
    {
      'name': 'Hội Chữ thập đỏ TP.HCM',
      'number': '(+84) 28 3829 1151',
    },
    {
      'name': 'Trung tâm Cấp cứu 115 TP.HCM',
      'number': '115',
    },
    {
      'name': 'Trung tâm Cấp cứu 115 Hà Nội',
      'number': '115',
    },
  ];

  final List<Map<String, String>> donateHospitals = [
    {
      'name': 'Bệnh viện Chợ Rẫy',
      'address': '201B Nguyễn Chí Thanh, Quận 5, TP.HCM',
      'phone': '(+84) 28 3855 4137',
    },
    {
      'name': 'Bệnh viện Bạch Mai',
      'address': '78 Giải Phóng, Đống Đa, Hà Nội',
      'phone': '(+84) 24 3869 3721',
    },
    {
      'name': 'Bệnh viện Việt Đức',
      'address': '40 Tràng Thi, Hoàn Kiếm, Hà Nội',
      'phone': '(+84) 24 3825 3531',
    },
    {
      'name': 'Bệnh viện FV',
      'address': '6 Nguyễn Lương Bằng, Quận 7, TP.HCM',
      'phone': '(+84) 28 5411 3333',
    },
    {
      'name': 'Bệnh viện Vinmec Central Park',
      'address': '208 Nguyễn Hữu Cảnh, Quận Bình Thạnh, TP.HCM',
      'phone': '(+84) 28 3622 1166',
    },
    {
      'name': 'Bệnh viện Từ Dũ',
      'address': '284 Cống Quỳnh, Quận 1, TP.HCM',
      'phone': '(+84) 28 5404 2829',
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context).translate('cannot_make_call'),
            style: GoogleFonts.poppins(fontSize: 14),
          ),
          backgroundColor: AppColors.darkRed,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: AppColors.black, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          localizations.translate('information'),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            color: AppColors.black,
            fontSize: 22,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.black, size: 24),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    localizations.translate('notifications_not_implemented'),
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  backgroundColor: AppColors.darkRed,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              );
            },
          ),
        ],
        backgroundColor: AppColors.white,
        elevation: 3,
        shadowColor: Colors.grey.withOpacity(0.3),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TabBar(
              controller: _tabController,
              labelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              unselectedLabelStyle: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 16,
              ),
              indicator: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(30),
              ),
              labelColor: AppColors.white,
              unselectedLabelColor: AppColors.black.withOpacity(0.7),
              labelPadding: const EdgeInsets.symmetric(horizontal: 12),
              padding: const EdgeInsets.all(4),
              tabs: [
                Tab(text: localizations.translate('emergency_number_hotline')),
                Tab(text: localizations.translate('donate_blood')),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildEmergencyTab(localizations, screenWidth),
                _buildDonateTab(localizations, screenWidth),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyTab(AppLocalizations localizations, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: localizations.translate('search'),
                hintStyle: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 16),
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryRed, size: 24),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              style: GoogleFonts.poppins(fontSize: 16),
              onChanged: (value) => setState(() {}),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            localizations.translate('emergency_contacts'),
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: emergencyNumbers.length,
              itemBuilder: (context, index) {
                final emergency = emergencyNumbers[index];
                if (_searchController.text.isNotEmpty &&
                    !emergency['name']!.toLowerCase().contains(_searchController.text.toLowerCase())) {
                  return const SizedBox.shrink();
                }
                return _AnimatedCard(
                  child: _buildEmergencyCard(emergency, localizations, screenWidth),
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDonateTab(AppLocalizations localizations, double screenWidth) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: localizations.translate('search'),
                hintStyle: GoogleFonts.poppins(color: Colors.grey[500], fontSize: 16),
                prefixIcon: const Icon(Icons.search, color: AppColors.primaryRed, size: 24),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
              ),
              style: GoogleFonts.poppins(fontSize: 16),
              onChanged: (value) => setState(() {}),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            localizations.translate('donation_centers'),
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.black,
            ),
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: donateHospitals.length,
              itemBuilder: (context, index) {
                final hospital = donateHospitals[index];
                if (_searchController.text.isNotEmpty &&
                    !hospital['name']!.toLowerCase().contains(_searchController.text.toLowerCase())) {
                  return const SizedBox.shrink();
                }
                return _AnimatedCard(
                  child: _buildHospitalCard(hospital, localizations, screenWidth),
                  index: index,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard(Map<String, String> emergency, AppLocalizations localizations, double screenWidth) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [AppColors.white, Colors.grey[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.primaryRed.withOpacity(0.15),
            child: const Icon(
              Icons.local_hospital,
              color: AppColors.primaryRed,
              size: 28,
            ),
          ),
          title: Text(
            emergency['name']!,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.black,
            ),
          ),
          subtitle: Text(
            emergency['number']!,
            style: GoogleFonts.poppins(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.call, color: Colors.green, size: 24),
            onPressed: () => _makePhoneCall(emergency['number']!),
            tooltip: localizations.translate('call'),
          ),
          onTap: () => _makePhoneCall(emergency['number']!),
        ),
      ),
    );
  }

  Widget _buildHospitalCard(Map<String, String> hospital, AppLocalizations localizations, double screenWidth) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      margin: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            colors: [AppColors.white, Colors.grey[50]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          leading: CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.blue.withOpacity(0.15),
            child: const Icon(
              Icons.local_hospital,
              color: AppColors.blue,
              size: 28,
            ),
          ),
          title: Text(
            hospital['name']!,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: AppColors.black,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                hospital['address']!,
                style: GoogleFonts.poppins(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.phone, color: Colors.grey, size: 16),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      hospital['phone']!,
                      style: GoogleFonts.poppins(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.location_on, color: AppColors.blue, size: 24),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        localizations.translate('location_not_implemented'),
                        style: GoogleFonts.poppins(fontSize: 14),
                      ),
                      backgroundColor: AppColors.darkRed,
                      behavior: SnackBarBehavior.floating,
                      margin: const EdgeInsets.all(16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  );
                },
                tooltip: localizations.translate('view_location'),
              ),
              IconButton(
                icon: const Icon(Icons.call, color: Colors.green, size: 24),
                onPressed: () => _makePhoneCall(hospital['phone']!),
                tooltip: localizations.translate('call'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedCard extends StatefulWidget {
  final Widget child;
  final int index;

  const _AnimatedCard({required this.child, required this.index});

  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600 + (widget.index * 100)),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.2, 0.0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: widget.child,
      ),
    );
  }
}