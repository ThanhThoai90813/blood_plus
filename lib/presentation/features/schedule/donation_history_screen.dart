import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/constants/app_theme.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/core/widgets/custom_button.dart';
import 'package:blood_plus/core/widgets/dialog_helper.dart';
import 'package:blood_plus/data/models/AppointmentStatus.dart';
import 'package:blood_plus/data/models/appointment_model.dart';
import 'package:blood_plus/data/services/appointment_service.dart';
import 'package:blood_plus/presentation/features/schedule/donation_event_screen.dart';
import 'package:blood_plus/presentation/features/schedule/history_detail_screen.dart';
import 'package:flutter/material.dart';
import 'dart:ui';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _headerController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _headerScaleAnimation;
  late Animation<double> _pulseAnimation;

  final AppointmentService _appointmentService = AppointmentService();
  List<Appointment> _appointments = [];
  bool _isLoading = true;
  String _selectedFilter = 'all'; // all, upcoming, completed, cancelled
  final ScrollController _scrollController = ScrollController();
  bool _showFloatingButton = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _fetchAppointments();
    _scrollController.addListener(_onScroll);
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOutBack));

    _headerScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _headerController, curve: Curves.elasticOut),
    );

    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _fadeController.forward();
    _headerController.forward();
  }

  void _onScroll() {
    if (_scrollController.offset > 100 && !_showFloatingButton) {
      setState(() => _showFloatingButton = true);
    } else if (_scrollController.offset <= 100 && _showFloatingButton) {
      setState(() => _showFloatingButton = false);
    }
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _headerController.dispose();
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchAppointments() async {
    setState(() => _isLoading = true);

    try {
      final appointments = await _appointmentService.getAppointments();
      setState(() {
        _isLoading = false;
        _appointments = appointments;
      });
      _fadeController.reset();
      _fadeController.forward();
    } catch (e) {
      setState(() {
        _isLoading = false;
        _appointments = [];
      });
      if (context.mounted) {
        _showErrorDialog(e.toString());
      }
    }
  }

  void _showErrorDialog(String error) {
    DialogHelper.showAnimatedSuccessDialog(
      context: context,
      title: AppLocalizations.of(context).translate('error'),
      message: '${AppLocalizations.of(context).translate('error_loading_appointments')}: $error',
      buttonText: AppLocalizations.of(context).translate('ok'),
      icon: Icons.error_outline_rounded,
      iconColor: AppColors.primaryRed,
    );
  }

  List<Appointment> get _filteredAppointments {
    switch (_selectedFilter) {
      case 'upcoming':
        return _appointments.where((apt) =>
            DateTime.parse(apt.appointmentDate).isAfter(DateTime.now())).toList();
      case 'completed':
        return _appointments.where((apt) => apt.status == AppointmentStatus.completed).toList();
      case 'cancelled':
        return _appointments.where((apt) => apt.status == AppointmentStatus.cancelled).toList();
      default:
        return _appointments;
    }
  }

  Widget _buildModernAppBar() {
    return SliverAppBar(
      expandedHeight: 160,
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
              AppColors.primaryRed.withOpacity(0.8),
              Colors.pink.shade400,
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(32),
            bottomRight: Radius.circular(32),
          ),
        ),
        child: FlexibleSpaceBar(
          title: ScaleTransition(
            scale: _headerScaleAnimation,
            child: Text(
              AppLocalizations.of(context).translate('history'),
              style: AppTheme.headingLarge.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.3),
                  ),
                ],
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
                  AppColors.primaryRed,
                  Colors.pink.shade400,
                ],
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(32),
                bottomRight: Radius.circular(32),
              ),
            ),
            child: Stack(
              children: [
                // Animated blood drop particles
                ...List.generate(6, (index) => _buildFloatingParticle(index)),
                // Statistics overlay
                Positioned(
                  bottom: 60,
                  left: 20,
                  right: 20,
                  child: _buildQuickStats(),
                ),
              ],
            ),
          ),
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              color: Colors.white.withOpacity(0.2),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ),
      ),
      actions: [
        Container(
          margin: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Colors.white),
            onPressed: _fetchAppointments,
          ),
        ),
      ],
    );
  }

  Widget _buildFloatingParticle(int index) {
    final random = (index * 47) % 100;
    return Positioned(
      left: (random * 3.0) % 300,
      top: (random * 2.0) % 100 + 40,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Transform.scale(
            scale: 0.5 + (_pulseAnimation.value * 0.3),
            child: Container(
              width: 8 + (random % 4),
              height: 8 + (random % 4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.3 + (random % 30) / 100),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.2),
                    blurRadius: 4,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildQuickStats() {
    final now = DateTime.now(); // Thời gian hiện tại: 29/05/2025 05:09 PM +07
    final totalAppointments = _appointments.length;
    // Chỉ tính các cuộc hẹn trong tương lai và không bị hủy
    final upcomingCount = _appointments.where((apt) {
      final appointmentDate = DateTime.parse(apt.appointmentDate);
      final isFuture = appointmentDate.isAfter(now);
      final isNotCancelled = apt.status != AppointmentStatus.cancelled;
      return isFuture && isNotCancelled;
    }).length;

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildStatCard(
            icon: Icons.event_available_rounded,
            count: upcomingCount.toString(),
            label: AppLocalizations.of(context).translate('upcoming'),
          ),
          _buildStatCard(
            icon: Icons.favorite_rounded,
            count: totalAppointments.toString(),
            label: AppLocalizations.of(context).translate('total'),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String count,
    required String label,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.15),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(height: 4),
              Text(
                count,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.9),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = [
      {'key': 'all', 'label': 'all_appointments', 'icon': Icons.list_rounded},
      {'key': 'upcoming', 'label': 'upcoming', 'icon': Icons.schedule_rounded},
      {'key': 'completed', 'label': 'completed', 'icon': Icons.check_circle_rounded},
      {'key': 'cancelled', 'label': 'cancelled', 'icon': Icons.cancel_rounded},
    ];

    return SliverToBoxAdapter(
      child: Container(
        height: 60,
        margin: const EdgeInsets.symmetric(vertical: 16),
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: filters.length,
          itemBuilder: (context, index) {
            final filter = filters[index];
            final isSelected = _selectedFilter == filter['key'];

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              child: FilterChip(
                selected: isSelected,
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      filter['icon'] as IconData,
                      size: 18,
                      color: isSelected ? Colors.white : AppColors.primaryRed,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      AppLocalizations.of(context).translate(filter['label'] as String),
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.primaryRed,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
                onSelected: (selected) {
                  setState(() => _selectedFilter = filter['key'] as String);
                },
                backgroundColor: Colors.white,
                selectedColor: AppColors.primaryRed,
                checkmarkColor: Colors.white,
                elevation: isSelected ? 4 : 2,
                shadowColor: AppColors.primaryRed.withOpacity(0.3),
                side: BorderSide(
                  color: isSelected ? AppColors.primaryRed : AppColors.primaryRed.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEnhancedAppointmentCard(Appointment appointment, int index) {
    final isPast = DateTime.parse(appointment.appointmentDate).isBefore(DateTime.now());
    final localizations = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    final cardSlideAnimation = Tween<Offset>(
      begin: const Offset(0.3, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Interval(0.1 * index, 0.1 * index + 0.6, curve: Curves.easeOutBack),
      ),
    );

    return SlideTransition(
      position: cardSlideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 20),
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(20),
            shadowColor: AppColors.primaryRed.withOpacity(0.2),
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: () => _navigateToDetail(appointment),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white,
                      Colors.grey.shade50,
                    ],
                  ),
                  border: Border.all(
                    color: isPast ? Colors.grey.withOpacity(0.3) : AppColors.primaryRed.withOpacity(0.2),
                    width: 1.5,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCardHeader(appointment, isPast),
                    const SizedBox(height: 16),
                    _buildCardDetails(appointment, localizations, languageCode),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardHeader(Appointment appointment, bool isPast) {
    return Row(
      children: [
        Hero(
          tag: 'appointment_${appointment.id}',
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: isPast
                    ? [Colors.grey.shade400, Colors.grey.shade300]
                    : [AppColors.primaryRed, Colors.pink.shade400],
              ),
              boxShadow: [
                BoxShadow(
                  color: (isPast ? Colors.grey : AppColors.primaryRed).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.favorite_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                appointment.eventName,
                style: AppTheme.headingSmall.copyWith(
                  color: isPast ? Colors.grey.shade600 : Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              _buildStatusChip(appointment),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatusChip(Appointment appointment) {
    Color chipColor;
    IconData chipIcon;

    switch (appointment.status) {
      case AppointmentStatus.completed:
        chipColor = Colors.green;
        chipIcon = Icons.check_circle_rounded;
        break;
      case AppointmentStatus.cancelled:
        chipColor = Colors.red;
        chipIcon = Icons.cancel_rounded;
        break;
      case AppointmentStatus.pending:
        chipColor = Colors.orange;
        chipIcon = Icons.schedule_rounded;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: chipColor.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(chipIcon, size: 14, color: chipColor),
          const SizedBox(width: 4),
          Text(
            appointment.getStatusText(Localizations.localeOf(context).languageCode),
            style: TextStyle(
              color: chipColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardDetails(Appointment appointment, AppLocalizations localizations, String languageCode) {
    return Column(
      children: [
        _buildDetailRow(
          icon: Icons.calendar_today_rounded,
          label: localizations.translate('date'),
          value: appointment.getFormattedDate(),
          iconColor: Colors.blue,
        ),
        _buildDetailRow(
          icon: Icons.access_time_rounded,
          label: localizations.translate('time'),
          value: appointment.getFormattedTime(),
          iconColor: Colors.green,
        ),
        _buildDetailRow(
          icon: Icons.location_on_rounded,
          label: localizations.translate('location'),
          value: appointment.location,
          iconColor: Colors.orange,
        ),
        _buildDetailRow(
          icon: Icons.business_rounded,
          label: localizations.translate('organization'),
          value: appointment.organizationName,
          iconColor: Colors.purple,
        ),
        _buildDetailRow(
          icon: Icons.bloodtype_rounded,
          label: localizations.translate('blood_component_history'),
          value: appointment.getBloodComponentText(languageCode),
          iconColor: AppColors.primaryRed,
        ),
      ],
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
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

  void _navigateToDetail(Appointment appointment) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HistoryDetailScreen(
          appointment: appointment,
          onCancel: _fetchAppointments,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 300),
      ),
    );
  }

  Widget _buildEmptyState() {
    return SliverFillRemaining(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    padding: const EdgeInsets.all(32),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primaryRed.withOpacity(0.1),
                          AppColors.primaryRed.withOpacity(0.05),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryRed.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.event_busy_rounded,
                      color: AppColors.primaryRed,
                      size: 80,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 32),
            Text(
              AppLocalizations.of(context).translate('no_appointments'),
              style: AppTheme.headingMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                AppLocalizations.of(context).translate('no_appointments_message'),
                style: AppTheme.bodyMedium.copyWith(color: Colors.grey.shade600),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: AppLocalizations.of(context).translate('book_now'),
              color: AppColors.primaryRed,
              icon: Icons.add_rounded,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DonationEventScreen()),
                );
              },
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              borderRadius: 16,
              width: 200,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return SliverFillRemaining(
      child: Center(
        child: AnimatedBuilder(
          animation: _pulseAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _pulseAnimation.value,
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryRed.withOpacity(0.2),
                      AppColors.primaryRed.withOpacity(0.05),
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryRed.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const CircularProgressIndicator(
                  color: AppColors.primaryRed,
                  strokeWidth: 3,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filteredAppointments = _filteredAppointments;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          _buildModernAppBar(),
          _buildFilterChips(),
          if (_isLoading)
            _buildLoadingState()
          else if (filteredAppointments.isEmpty)
            _buildEmptyState()
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildEnhancedAppointmentCard(
                    filteredAppointments[index],
                    index,
                  ),
                  childCount: filteredAppointments.length,
                ),
              ),
            ),
          const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
        ],
      ),
      floatingActionButton: AnimatedSlide(
        offset: _showFloatingButton ? Offset.zero : const Offset(0, 2),
        duration: const Duration(milliseconds: 300),
        child: AnimatedOpacity(
          opacity: _showFloatingButton ? 1.0 : 0.0,
          duration: const Duration(milliseconds: 300),
          child: FloatingActionButton(
            onPressed: () {
              _scrollController.animateTo(
                0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeOutCubic,
              );
            },
            backgroundColor: AppColors.primaryRed,
            child: const Icon(Icons.keyboard_arrow_up_rounded, color: Colors.white),
          ),
        ),
      ),
    );
  }
}