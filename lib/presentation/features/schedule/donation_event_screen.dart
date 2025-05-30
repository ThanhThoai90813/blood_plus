import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/constants/app_theme.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/core/widgets/dialog_helper.dart';
import 'package:blood_plus/data/models/donation_event_model.dart';
import 'package:blood_plus/data/services/donation_event_service.dart';
import 'package:blood_plus/presentation/features/schedule/donation_event_detail_screen.dart';
import 'package:blood_plus/presentation/features/schedule/donation_form_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart' as dp;
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class DonationEventScreen extends StatefulWidget {
  const DonationEventScreen({super.key});

  @override
  State<DonationEventScreen> createState() => _DonationEventScreenState();
}

class _DonationEventScreenState extends State<DonationEventScreen>
    with TickerProviderStateMixin {
  final DonationEventService _donationEventService = DonationEventService();
  List<DonationEvent> _events = [];
  int _currentPage = 1;
  int _pageSize = 5;
  bool _hasNextPage = false;
  bool _isLoading = false;
  bool _isFilterExpanded = false;

  final TextEditingController _searchLocationController = TextEditingController();
  final TextEditingController _searchOrganizationController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;
  final DateTime _currentDate = DateTime.now();

  late AnimationController _fadeController;
  late AnimationController _filterController;
  late AnimationController _listController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _filterAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _fetchDonationEvents();
    _fadeController.forward();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _filterController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _listController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutQuart),
    );
    _filterAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _filterController, curve: Curves.easeInOutCubic),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _listController, curve: Curves.easeOutBack));
  }

  @override
  void dispose() {
    _searchLocationController.dispose();
    _searchOrganizationController.dispose();
    _fadeController.dispose();
    _filterController.dispose();
    _listController.dispose();
    super.dispose();
  }

  Future<void> _fetchDonationEvents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _donationEventService.getDonationEvents(
        pageNumber: _currentPage,
        pageSize: _pageSize,
        location: _searchLocationController.text.isNotEmpty ? _searchLocationController.text : null,
        startDate: _startDate?.toIso8601String().split('T')[0],
        endDate: _endDate?.toIso8601String().split('T')[0],
        organization: _searchOrganizationController.text.isNotEmpty ? _searchOrganizationController.text : null,
      );

      setState(() {
        if (_currentPage == 1) {
          _events = response.items;
        } else {
          _events.addAll(response.items);
        }
        _hasNextPage = response.hasNextPage;
        _isLoading = false;
      });
      _listController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        _showErrorSnackBar(AppLocalizations.of(context).translate('error_loading_events'));
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: AppTheme.bodyMedium.copyWith(color: Colors.white),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.primaryRed,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _loadMore() {
    if (_hasNextPage && !_isLoading) {
      setState(() {
        _currentPage++;
      });
      _fetchDonationEvents();
    }
  }

  void _onSearchChanged() {
    setState(() {
      _currentPage = 1;
      _events.clear();
    });
    _listController.reset();
    _fetchDonationEvents();
  }

  void _clearFilters() {
    setState(() {
      _searchLocationController.clear();
      _searchOrganizationController.clear();
      _startDate = null;
      _endDate = null;
      _currentPage = 1;
      _events.clear();
    });
    _listController.reset();
    _fetchDonationEvents();
  }

  void _toggleFilter() {
    setState(() {
      _isFilterExpanded = !_isFilterExpanded;
    });
    if (_isFilterExpanded) {
      _filterController.forward();
    } else {
      _filterController.reverse();
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    dp.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2020),
      maxTime: DateTime(2030),
      onConfirm: (date) {
        if (date != _startDate) {
          setState(() {
            _startDate = date;
            _currentPage = 1;
            _events.clear();
          });
          _listController.reset();
          _fetchDonationEvents();
        }
      },
      currentTime: _startDate ?? _currentDate,
      locale: dp.LocaleType.vi,
      theme: dp.DatePickerTheme(
        headerColor: AppColors.primaryRed,
        backgroundColor: AppColors.white,
        itemStyle: AppTheme.bodyLarge.copyWith(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
        doneStyle: AppTheme.buttonText,
        cancelStyle: AppTheme.bodyMedium.copyWith(color: AppColors.black),
      ),
    );
  }

  Future<void> _selectEndDate(BuildContext context) async {
    dp.DatePicker.showDatePicker(
      context,
      showTitleActions: true,
      minTime: DateTime(2020),
      maxTime: DateTime(2030),
      onConfirm: (date) {
        if (date != _endDate) {
          setState(() {
            _endDate = date;
            _currentPage = 1;
            _events.clear();
          });
          _listController.reset();
          _fetchDonationEvents();
        }
      },
      currentTime: _endDate ?? _currentDate,
      locale: dp.LocaleType.vi,
      theme: dp.DatePickerTheme(
        headerColor: AppColors.primaryRed,
        backgroundColor: AppColors.white,
        itemStyle: AppTheme.bodyLarge.copyWith(
          color: AppColors.black,
          fontWeight: FontWeight.w600,
        ),
        doneStyle: AppTheme.buttonText,
        cancelStyle: AppTheme.bodyMedium.copyWith(color: AppColors.black),
      ),
    );
  }

  Future<void> _launchGoogleMaps(String location) async {
    final String encodedLocation = Uri.encodeComponent(location);
    final String googleMapsUrl = 'geo:0,0?q=$encodedLocation';
    final String fallbackUrl = 'https://www.google.com/maps/search/?api=1&query=$encodedLocation';

    final Uri geoUrl = Uri.parse(googleMapsUrl);
    final Uri webUrl = Uri.parse(fallbackUrl);

    final localizations = AppLocalizations.of(context);

    try {
      if (await canLaunchUrl(geoUrl)) {
        await launchUrl(geoUrl, mode: LaunchMode.externalApplication);
      } else if (await canLaunchUrl(webUrl)) {
        await launchUrl(webUrl, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          await DialogHelper.showConfirmationDialog(
            context: context,
            title: localizations.translate('no_google_maps'),
            message: localizations.translate('open_in_browser'),
            cancelButtonText: localizations.translate('cancel'),
            confirmButtonText: localizations.translate('open'),
            onConfirm: () async {
              if (await canLaunchUrl(webUrl)) {
                await launchUrl(webUrl, mode: LaunchMode.externalApplication);
              } else {
                throw Exception(localizations.translate('could_not_launch_google_maps'));
              }
            },
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorSnackBar('${localizations.translate('could_not_launch_google_maps')}: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Enhanced App Bar
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.transparent,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primaryRed,
                    AppColors.darkRed,
                    AppColors.lowerRed,
                  ],
                  stops: const [0.0, 0.6, 1.0],
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryRed.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: FlexibleSpaceBar(
                title: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    localizations.translate('donation_events'),
                    style: GoogleFonts.poppins(
                      fontSize: 19,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                centerTitle: true,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primaryRed.withOpacity(0.9),
                        AppColors.darkRed.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Center(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Icon(
                        Icons.favorite,
                        size: 40,
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Filter Section
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                margin: const EdgeInsets.all(16),
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
                child: Column(
                  children: [
                    // Filter Header
                    InkWell(
                      onTap: _toggleFilter,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.primaryRed.withOpacity(0.1),
                              AppColors.primaryRed.withOpacity(0.05),
                            ],
                          ),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primaryRed.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.tune,
                                color: AppColors.primaryRed,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                localizations.translate('filter_events'),
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            AnimatedRotation(
                              turns: _isFilterExpanded ? 0.5 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.primaryRed,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Filter Content
                    AnimatedSize(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOutCubic,
                      child: _isFilterExpanded
                          ? FadeTransition(
                        opacity: _filterAnimation,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            children: [
                              _buildSearchField(
                                controller: _searchLocationController,
                                hint: localizations.translate('search_by_location'),
                                icon: Icons.location_on,
                                onChanged: _onSearchChanged,
                              ),
                              const SizedBox(height: 16),
                              _buildSearchField(
                                controller: _searchOrganizationController,
                                hint: localizations.translate('search_by_organization'),
                                icon: Icons.business,
                                onChanged: _onSearchChanged,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildDateField(
                                      value: _startDate,
                                      hint: localizations.translate('select_start_date'),
                                      onTap: () => _selectStartDate(context),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: _buildDateField(
                                      value: _endDate,
                                      hint: localizations.translate('select_end_date'),
                                      onTap: () => _selectEndDate(context),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              _buildClearButton(localizations),
                            ],
                          ),
                        ),
                      )
                          : const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Event List
          SliverToBoxAdapter(
            child: SlideTransition(
              position: _slideAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: _events.isEmpty && _isLoading
                    ? const _LoadingWidget()
                    : _events.isEmpty
                    ? _buildEmptyState(localizations)
                    : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _events.length + (_hasNextPage ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (index == _events.length) {
                      _loadMore();
                      return const _LoadingWidget();
                    }

                    final event = _events[index];
                    return TweenAnimationBuilder<double>(
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      tween: Tween(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.translate(
                          offset: Offset(0, 30 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: _EventCard(
                              event: event,
                              onTap: () => _showScheduleDialog(event, localizations),
                              onLocationTap: () => _launchGoogleMaps(event.location),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required VoidCallback onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderColor),
      ),
      child: TextField(
        controller: controller,
        onChanged: (value) => onChanged(),
        style: AppTheme.bodyMedium.copyWith(color: AppColors.textPrimary),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTheme.bodyMedium.copyWith(color: AppColors.textSecondary),
          prefixIcon: Icon(icon, color: AppColors.primaryRed, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required DateTime? value,
    required String hint,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.borderColor),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: AppColors.primaryRed, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                value == null ? hint : DateFormat('dd/MM/yyyy').format(value),
                style: AppTheme.bodyMedium.copyWith(
                  color: value == null ? AppColors.textSecondary : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildClearButton(AppLocalizations localizations) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryRed.withOpacity(0.1),
            AppColors.primaryRed.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryRed.withOpacity(0.3)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _clearFilters,
          borderRadius: BorderRadius.circular(16),
          child: Center(
            child: Text(
              localizations.translate('clear_filters'),
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryRed,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(AppLocalizations localizations) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              Icons.event_busy,
              size: 48,
              color: AppColors.primaryRed,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            localizations.translate('no_events_found'),
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Không tìm thấy sự kiện phù hợp',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  void _showScheduleDialog(DonationEvent event, AppLocalizations localizations) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EventDetailScreen(eventId: event.id),
      ),
    );
  }
}

class _LoadingWidget extends StatelessWidget {
  const _LoadingWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppColors.primaryRed.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: const CircularProgressIndicator(
                color: AppColors.primaryRed,
                strokeWidth: 3,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Đang tải...',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EventCard extends StatefulWidget {
  final DonationEvent event;
  final VoidCallback onTap;
  final VoidCallback onLocationTap;

  const _EventCard({
    required this.event,
    required this.onTap,
    required this.onLocationTap,
  });

  @override
  State<_EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<_EventCard> with SingleTickerProviderStateMixin {
  late AnimationController _hoverController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _hoverController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.02).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
    _elevationAnimation = Tween<double>(begin: 4.0, end: 12.0).animate(
      CurvedAnimation(parent: _hoverController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final progress = widget.event.currentDonors / widget.event.requiredDonors;

    return AnimatedBuilder(
      animation: _hoverController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: (_) {
              setState(() => _isHovered = true);
              _hoverController.forward();
            },
            onTapUp: (_) {
              setState(() => _isHovered = false);
              _hoverController.reverse();
              widget.onTap();
            },
            onTapCancel: () {
              setState(() => _isHovered = false);
              _hoverController.reverse();
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryRed.withOpacity(0.1),
                    blurRadius: _elevationAnimation.value,
                    offset: Offset(0, _elevationAnimation.value / 3),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  children: [
                    // Progress indicator at top
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primaryRed.withOpacity(0.3),
                            AppColors.primaryRed,
                            AppColors.darkRed,
                          ],
                          stops: [0.0, progress, 1.0],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header Row
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Event Image/Icon
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      AppColors.primaryRed.withOpacity(0.1),
                                      AppColors.primaryRed.withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: AppColors.primaryRed.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    fit: BoxFit.contain,
                                    errorBuilder: (context, error, stackTrace) => Icon(
                                      Icons.favorite,
                                      color: AppColors.primaryRed,
                                      size: 36,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),

                              // Event Info
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.event.title,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary,
                                        height: 1.3,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),

                                    // Organization
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryRed.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: AppColors.primaryRed.withOpacity(0.3),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.business,
                                              size: 12,
                                              color: AppColors.primaryRed,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              widget.event.organizationName,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w500,
                                                color: AppColors.primaryRed,
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Date and Time Section
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: AppColors.primaryRed.withOpacity(0.1),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    // Date Section
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryRed.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.calendar_today,
                                              size: 16,
                                              color: AppColors.primaryRed,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  localizations.translate('date'),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    color: AppColors.textSecondary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  widget.event.getFormattedDate(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    // Vertical Divider
                                    Container(
                                      height: 40,
                                      width: 1,
                                      color: AppColors.borderColor,
                                      margin: const EdgeInsets.symmetric(horizontal: 12),
                                    ),

                                    // Time Section
                                    Expanded(
                                      child: Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: AppColors.primaryRed.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Icon(
                                              Icons.access_time,
                                              size: 16,
                                              color: AppColors.primaryRed,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  localizations.translate('time'),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 11,
                                                    color: AppColors.textSecondary,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Text(
                                                  widget.event.getFormattedTime(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.w600,
                                                    color: AppColors.textPrimary,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Location Section
                          GestureDetector(
                            onTap: widget.onLocationTap,
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.primaryRed.withOpacity(0.05),
                                    AppColors.primaryRed.withOpacity(0.02),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: AppColors.primaryRed.withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryRed.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      Icons.location_on,
                                      size: 18,
                                      color: AppColors.primaryRed,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          localizations.translate('location'),
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: AppColors.textSecondary,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          widget.event.location,
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.primaryRed,
                                            decoration: TextDecoration.underline,
                                            decorationColor: AppColors.primaryRed.withOpacity(0.5),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.open_in_new,
                                    size: 16,
                                    color: AppColors.primaryRed.withOpacity(0.7),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          // Progress Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    localizations.translate('participants'),
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: progress >= 1.0
                                          ? Colors.green.withOpacity(0.1)
                                          : progress >= 0.8
                                          ? Colors.orange.withOpacity(0.1)
                                          : AppColors.primaryRed.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: progress >= 1.0
                                            ? Colors.green.withOpacity(0.3)
                                            : progress >= 0.8
                                            ? Colors.orange.withOpacity(0.3)
                                            : AppColors.primaryRed.withOpacity(0.3),
                                      ),
                                    ),
                                    child: Text(
                                      '${widget.event.currentDonors}/${widget.event.requiredDonors}',
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: progress >= 1.0
                                            ? Colors.green
                                            : progress >= 0.8
                                            ? Colors.orange
                                            : AppColors.primaryRed,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),

                              // Enhanced Progress Bar
                              Container(
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppColors.borderColor.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.borderColor.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: progress.clamp(0.0, 1.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: progress >= 1.0
                                                ? [Colors.green, Colors.green.shade700]
                                                : progress >= 0.8
                                                ? [Colors.orange, Colors.orange.shade700]
                                                : [AppColors.primaryRed, AppColors.darkRed],
                                          ),
                                          borderRadius: BorderRadius.circular(4),
                                          boxShadow: [
                                            BoxShadow(
                                              color: (progress >= 1.0
                                                  ? Colors.green
                                                  : progress >= 0.8
                                                  ? Colors.orange
                                                  : AppColors.primaryRed)
                                                  .withOpacity(0.3),
                                              blurRadius: 4,
                                              offset: const Offset(0, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),

                              // Progress Text with Status
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${(progress * 100).toInt()}% ${localizations.translate('completed')}',
                                    style: GoogleFonts.poppins(
                                      fontSize: 11,
                                      color: AppColors.textSecondary,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: progress >= 1.0
                                          ? Colors.green.withOpacity(0.1)
                                          : progress >= 0.8
                                          ? Colors.orange.withOpacity(0.1)
                                          : AppColors.primaryRed.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      progress >= 1.0
                                          ? 'Đầy'
                                          : progress >= 0.8
                                          ? 'Sắp đầy'
                                          : 'Còn chỗ',
                                      style: GoogleFonts.poppins(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                        color: progress >= 1.0
                                            ? Colors.green
                                            : progress >= 0.8
                                            ? Colors.orange
                                            : AppColors.primaryRed,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // Action Button
                          Container(
                            width: double.infinity,
                            height: 48,
                            decoration: BoxDecoration(
                              gradient: progress >= 1.0
                                  ? LinearGradient(
                                colors: [
                                  Colors.grey.withOpacity(0.3),
                                  Colors.grey.withOpacity(0.2),
                                ],
                              )
                                  : LinearGradient(
                                colors: [
                                  AppColors.primaryRed,
                                  AppColors.darkRed,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: progress >= 1.0
                                  ? null
                                  : [
                                BoxShadow(
                                  color: AppColors.primaryRed.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: progress >= 1.0 ? null : widget.onTap,
                                borderRadius: BorderRadius.circular(16),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        progress >= 1.0 ? Icons.event_busy : Icons.volunteer_activism,
                                        color: progress >= 1.0 ? Colors.grey : Colors.white,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        progress >= 1.0
                                            ? localizations.translate('Full')
                                            : localizations.translate('view_detail'),
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: progress >= 1.0 ? Colors.grey : Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Extension method for formatting date and time
extension DonationEventExtension on DonationEvent {
  String getFormattedDate() {
    try {
      final date = DateTime.parse(eventDate);
      final now = DateTime.now();
      final difference = date.difference(now).inDays;

      if (difference == 0) {
        return 'Hôm nay';
      } else if (difference == 1) {
        return 'Ngày mai';
      } else if (difference == -1) {
        return 'Hôm qua';
      } else {
        return DateFormat('dd/MM/yyyy').format(date);
      }
    } catch (e) {
      return eventDate.split('T')[0]; // Fallback if parse fails
    }
  }

  String getFormattedTime() {
    try {
      final start = DateTime.parse(eventDate);
      final end = DateTime.parse(endTime);
      final timeFormat = DateFormat('HH:mm');
      return '${timeFormat.format(start)} - ${timeFormat.format(end)}';
    } catch (e) {
      return '${eventDate.split('T')[1].split('.')[0]} - ${endTime.split('T')[1].split('.')[0]}'; // Fallback
    }
  }
}

// Animation utilities
class AnimationUtils {
  static Widget buildStaggeredList({
    required List<Widget> children,
    Duration delay = const Duration(milliseconds: 100),
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;

        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 300 + (index * delay.inMilliseconds)),
          tween: Tween(begin: 0.0, end: 1.0),
          builder: (context, value, _) {
            return Transform.translate(
              offset: Offset(0, 30 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
        );
      }).toList(),
    );
  }
}

// Shimmer loading effect widget
class ShimmerCard extends StatefulWidget {
  const ShimmerCard({super.key});

  @override
  State<ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<ShimmerCard> with SingleTickerProviderStateMixin {
  late AnimationController _shimmerController;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _shimmerAnimation = Tween<double>(
      begin: -1.0,
      end: 2.0,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOutSine,
    ));
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return Container(
          margin: const EdgeInsets.only(bottom: 20),
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(-1.0 + _shimmerAnimation.value, 0.0),
                        end: Alignment(1.0 + _shimmerAnimation.value, 0.0),
                        colors: [
                          Colors.grey.withOpacity(0.1),
                          Colors.grey.withOpacity(0.3),
                          Colors.grey.withOpacity(0.1),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}