import 'package:blood_plus/core/constants/app_theme.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class InformationScreen extends StatefulWidget {
  const InformationScreen({Key? key}) : super(key: key);

  @override
  State<InformationScreen> createState() => _InformationScreenState();
}

class _InformationScreenState extends State<InformationScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Filtered lists for search
  List<Map<String, String>> _filteredEmergencyNumbers = [];
  List<Map<String, String>> _filteredDonateHospitals = [];

  final List<Map<String, String>> _emergencyNumbers = [
    {
      'name': 'Trung tâm Truyền máu Chợ Rẫy',
      'number': '(+84) 28 3855 5730',
      'icon': 'hospital'
    },
    {
      'name': 'Viện Huyết học - Truyền máu Trung ương',
      'number': '(+84) 24 3868 6008',
      'icon': 'hospital'
    },
    {
      'name': 'Trung tâm Truyền máu Bệnh viện Bạch Mai',
      'number': '(+84) 24 3869 3721',
      'icon': 'hospital'
    },
    {
      'name': 'Hội Chữ thập đỏ TP.HCM',
      'number': '(+84) 28 3829 1151',
      'icon': 'emergency'
    },
    {
      'name': 'Trung tâm Cấp cứu 115 TP.HCM',
      'number': '115',
      'icon': 'emergency'
    },
    {
      'name': 'Trung tâm Cấp cứu 115 Hà Nội',
      'number': '115',
      'icon': 'emergency'
    },
  ];

  final List<Map<String, String>> _donateHospitals = [
    {
      'name': 'Bệnh viện Chợ Rẫy',
      'address': '201B Nguyễn Chí Thanh, Quận 5, TP.HCM',
      'phone': '(+84) 28 3855 4137',
      'hours': '8:00 - 17:00',
      'rating': '4.5'
    },
    {
      'name': 'Bệnh viện Bạch Mai',
      'address': '78 Giải Phóng, Đống Đa, Hà Nội',
      'phone': '(+84) 24 3869 3721',
      'hours': '8:00 - 17:00',
      'rating': '4.3'
    },
    {
      'name': 'Bệnh viện Việt Đức',
      'address': '40 Tràng Thi, Hoàn Kiếm, Hà Nội',
      'phone': '(+84) 24 3825 3531',
      'hours': '8:00 - 17:00',
      'rating': '4.4'
    },
    {
      'name': 'Bệnh viện FV',
      'address': '6 Nguyễn Lương Bằng, Quận 7, TP.HCM',
      'phone': '(+84) 28 5411 3333',
      'hours': '24/7',
      'rating': '4.7'
    },
    {
      'name': 'Bệnh viện Vinmec Central Park',
      'address': '208 Nguyễn Hữu Cảnh, Quận Bình Thạnh, TP.HCM',
      'phone': '(+84) 28 3622 1166',
      'hours': '24/7',
      'rating': '4.6'
    },
    {
      'name': 'Bệnh viện Từ Dũ',
      'address': '284 Cống Quỳnh, Quận 1, TP.HCM',
      'phone': '(+84) 28 5404 2829',
      'hours': '8:00 - 17:00',
      'rating': '4.2'
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    // Initialize filtered lists
    _filteredEmergencyNumbers = List.from(_emergencyNumbers);
    _filteredDonateHospitals = List.from(_donateHospitals);

    _fadeController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _filterLists(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredEmergencyNumbers = List.from(_emergencyNumbers);
        _filteredDonateHospitals = List.from(_donateHospitals);
      } else {
        final lowerQuery = query.toLowerCase();
        _filteredEmergencyNumbers = _emergencyNumbers
            .where((item) => item['name']!.toLowerCase().contains(lowerQuery))
            .toList();
        _filteredDonateHospitals = _donateHospitals
            .where((item) =>
        item['name']!.toLowerCase().contains(lowerQuery) ||
            item['address']!.toLowerCase().contains(lowerQuery))
            .toList();
      }
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    try {
      // Add haptic feedback
      HapticFeedback.lightImpact();

      final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        _showErrorSnackBar('Không thể thực hiện cuộc gọi');
      }
    } catch (e) {
      _showErrorSnackBar('Lỗi: $e');
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTheme.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppTheme.primaryRed,
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Đóng',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          _buildSliverAppBar(localizations, innerBoxIsScrolled),
        ],
        body: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              _buildTabBar(localizations),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildEmergencyTab(localizations),
                    _buildDonateTab(localizations),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(AppLocalizations localizations, bool innerBoxIsScrolled) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: AppTheme.primaryRed,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
        child: FlexibleSpaceBar(
          title: Text(
            localizations.translate('information'),
            style: AppTheme.headingMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
          titlePadding: const EdgeInsets.only(bottom: 16),
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.notifications_outlined, color: Colors.white, size: 20),
          ),
          onPressed: () {
            _showErrorSnackBar('Tính năng thông báo chưa được triển khai');
          },
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildTabBar(AppLocalizations localizations) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelStyle: AppTheme.headingSmall.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTheme.bodyMedium.copyWith(
          color: AppTheme.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        indicator: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryRed.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.textSecondary,
        labelPadding: const EdgeInsets.symmetric(horizontal: 16),
        padding: const EdgeInsets.all(6),
        tabs: [
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.emergency, size: 18),
                const SizedBox(width: 8),
                Text(localizations.translate('emergency_number_hotline')),
              ],
            ),
          ),
          Tab(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.local_hospital, size: 17),
                const SizedBox(width: 8),
                Text(localizations.translate('donate_blood')),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(AppLocalizations localizations) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: localizations.translate('search'),
          hintStyle: AppTheme.bodyMedium.copyWith(
            color: AppTheme.textSecondary.withOpacity(0.7),
          ),
          prefixIcon: Container(
            padding: const EdgeInsets.all(12),
            child: Icon(
              Icons.search_rounded,
              color: AppTheme.primaryRed,
              size: 22,
            ),
          ),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
            icon: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppTheme.textSecondary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.close,
                color: AppTheme.textSecondary,
                size: 16,
              ),
            ),
            onPressed: () {
              _searchController.clear();
              _filterLists('');
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: AppTheme.primaryRed, width: 2),
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        style: AppTheme.bodyLarge.copyWith(color: AppTheme.textPrimary),
        onChanged: _filterLists,
      ),
    );
  }

  Widget _buildEmergencyTab(AppLocalizations localizations) {
    return Column(
      children: [
        _buildSearchBar(localizations),
        Expanded(
          child: _filteredEmergencyNumbers.isEmpty
              ? _buildEmptyState(localizations, 'Không tìm thấy số cấp cứu')
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: _filteredEmergencyNumbers.length,
            itemBuilder: (context, index) {
              final emergency = _filteredEmergencyNumbers[index];
              return _AnimatedCard(
                index: index,
                child: _buildEmergencyCard(emergency, localizations),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDonateTab(AppLocalizations localizations) {
    return Column(
      children: [
        _buildSearchBar(localizations),
        Expanded(
          child: _filteredDonateHospitals.isEmpty
              ? _buildEmptyState(localizations, 'Không tìm thấy bệnh viện')
              : ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            physics: const BouncingScrollPhysics(),
            itemCount: _filteredDonateHospitals.length,
            itemBuilder: (context, index) {
              final hospital = _filteredDonateHospitals[index];
              return _AnimatedCard(
                index: index,
                child: _buildHospitalCard(hospital, localizations),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(AppLocalizations localizations, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off_rounded,
            size: 64,
            color: AppTheme.textSecondary.withOpacity(0.5),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: AppTheme.headingSmall.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thử tìm kiếm với từ khóa khác',
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyCard(Map<String, String> emergency, AppLocalizations localizations) {
    final isEmergency = emergency['icon'] == 'emergency';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _makePhoneCall(emergency['number']!),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: isEmergency
                        ? LinearGradient(
                      colors: [Colors.red.shade400, Colors.red.shade600],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    )
                        : LinearGradient(
                      colors: [AppTheme.primaryRed, AppTheme.secondaryRed],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: (isEmergency ? Colors.red : AppTheme.primaryRed)
                            .withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    isEmergency ? Icons.emergency : Icons.local_hospital,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        emergency['name']!,
                        style: AppTheme.headingSmall.copyWith(
                          color: AppTheme.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            size: 16,
                            color: AppTheme.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            emergency['number']!,
                            style: AppTheme.bodyMedium.copyWith(
                              color: AppTheme.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.phone, color: Colors.green, size: 20),
                    onPressed: () => _makePhoneCall(emergency['number']!),
                    tooltip: 'Gọi điện',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHospitalCard(Map<String, String> hospital, AppLocalizations localizations) {
    final rating = double.tryParse(hospital['rating'] ?? '0') ?? 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _makePhoneCall(hospital['phone']!),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppTheme.secondaryRed, AppTheme.primaryRed],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.secondaryRed.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.local_hospital,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            hospital['name']!,
                            style: AppTheme.headingSmall.copyWith(
                              color: AppTheme.textPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              ...List.generate(5, (index) => Icon(
                                index < rating.floor() ? Icons.star : Icons.star_border,
                                size: 16,
                                color: Colors.amber,
                              )),
                              const SizedBox(width: 6),
                              Text(
                                rating.toString(),
                                style: AppTheme.bodySmall.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildInfoRow(Icons.location_on, hospital['address']!),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.phone, hospital['phone']!),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.access_time, hospital['hours']!),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: TextButton.icon(
                          onPressed: () {
                            _showErrorSnackBar('Tính năng xem vị trí chưa được triển khai');
                          },
                          icon: const Icon(Icons.map, color: Colors.blue, size: 18),
                          label: const Text(
                            'Xem vị trí',
                            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => _makePhoneCall(hospital['phone']!),
                        icon: const Icon(Icons.phone, color: Colors.green, size: 20),
                        tooltip: 'Gọi điện',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: AppTheme.textSecondary,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: AppTheme.bodyMedium.copyWith(
              color: AppTheme.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _AnimatedCard extends StatefulWidget {
  final Widget child;
  final int index;

  const _AnimatedCard({
    required this.child,
    required this.index,
  });

  @override
  _AnimatedCardState createState() => _AnimatedCardState();
}

class _AnimatedCardState extends State<_AnimatedCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600 + (widget.index * 100)),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOutBack),
      ),
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
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: widget.child,
            ),
          ),
        );
      },
    );
  }
}