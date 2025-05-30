import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/constants/app_theme.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/core/widgets/custom_button.dart';
import 'package:blood_plus/core/widgets/dialog_helper.dart';
import 'package:blood_plus/data/models/AppointmentStatus.dart';
import 'package:blood_plus/data/models/appointment_model.dart';
import 'package:blood_plus/data/services/appointment_service.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryDetailScreen extends StatefulWidget {
  final Appointment appointment;
  final VoidCallback onCancel;
  final VoidCallback? onComplete;

  const HistoryDetailScreen({
    super.key,
    required this.appointment,
    required this.onCancel,
    this.onComplete,
  });

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _floatingController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _scaleAnimation;

  final AppointmentService _appointmentService = AppointmentService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initAnimations();
  }

  void _initAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _floatingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutQuart),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack));

    _floatingAnimation = Tween<double>(begin: -5.0, end: 5.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.elasticOut),
    );

    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _floatingController.dispose();
    super.dispose();
  }

  // Keep existing methods for functionality...
  Future<void> _cancelAppointment() async {
    if (widget.appointment.status != AppointmentStatus.pending) {
      if (context.mounted) {
        DialogHelper.showAnimatedErrorDialog(
          context: context,
          title: AppLocalizations.of(context).translate('error'),
          message: AppLocalizations.of(context).translate('cannot_cancel_non_pending'),
          buttonText: AppLocalizations.of(context).translate('ok'),
          icon: Icons.error_outline_rounded,
          iconColor: AppColors.primaryRed,
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _appointmentService.cancelAppointment(widget.appointment.id);
      setState(() => _isLoading = false);

      if (context.mounted) {
        DialogHelper.showAnimatedSuccessDialog(
          context: context,
          title: AppLocalizations.of(context).translate('success'),
          message: AppLocalizations.of(context).translate('appointment_canceled'),
          buttonText: AppLocalizations.of(context).translate('ok'),
          icon: Icons.check_circle_outline_rounded,
          iconColor: Colors.green,
          onPressed: () {
            widget.onCancel();
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (context.mounted) {
        DialogHelper.showAnimatedErrorDialog(
          context: context,
          title: AppLocalizations.of(context).translate('error'),
          message: '${AppLocalizations.of(context).translate('error_canceling_appointment')}: $e',
          buttonText: AppLocalizations.of(context).translate('ok'),
          icon: Icons.error_outline_rounded,
          iconColor: AppColors.primaryRed,
        );
      }
    }
  }

  Future<void> _completeAppointment() async {
    if (widget.appointment.status != AppointmentStatus.pending) {
      if (context.mounted) {
        DialogHelper.showAnimatedErrorDialog(
          context: context,
          title: AppLocalizations.of(context).translate('error'),
          message: AppLocalizations.of(context).translate('cannot_complete_non_pending'),
          buttonText: AppLocalizations.of(context).translate('ok'),
          icon: Icons.error_outline_rounded,
          iconColor: AppColors.primaryRed,
        );
      }
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _appointmentService.completeAppointment(widget.appointment.id);
      setState(() => _isLoading = false);

      if (context.mounted) {
        DialogHelper.showAnimatedSuccessDialog(
          context: context,
          title: AppLocalizations.of(context).translate('success'),
          message: AppLocalizations.of(context).translate('appointment_completed'),
          buttonText: AppLocalizations.of(context).translate('ok'),
          icon: Icons.check_circle_outline_rounded,
          iconColor: Colors.green,
          onPressed: () {
            widget.onComplete?.call();
            Navigator.pop(context);
          },
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (context.mounted) {
        DialogHelper.showAnimatedErrorDialog(
          context: context,
          title: AppLocalizations.of(context).translate('error'),
          message: '${AppLocalizations.of(context).translate('error_completing_appointment')}: $e',
          buttonText: AppLocalizations.of(context).translate('ok'),
          icon: Icons.error_outline_rounded,
          iconColor: AppColors.primaryRed,
        );
      }
    }
  }

  Future<void> _openGoogleMaps(String location) async {
    final encodedLocation = Uri.encodeComponent(location);
    // Updated Google Maps app URL to include search query
    final googleMapsAppUrl = Uri.parse('geo:0,0?q=$encodedLocation');
    // Updated web URL to ensure proper search
    final googleMapsWebUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$encodedLocation');

    try {
      // First try to open in Google Maps app with geo URI
      if (await canLaunchUrl(googleMapsAppUrl)) {
        await launchUrl(googleMapsAppUrl, mode: LaunchMode.externalApplication);
      }
      // Fallback to web version
      else if (await canLaunchUrl(googleMapsWebUrl)) {
        await launchUrl(googleMapsWebUrl, mode: LaunchMode.externalApplication);
      }
      // Show error if neither can be opened
      else {
        if (context.mounted) {
          DialogHelper.showAnimatedErrorDialog(
            context: context,
            title: AppLocalizations.of(context).translate('error'),
            message: AppLocalizations.of(context).translate('cannot_open_maps'),
            buttonText: AppLocalizations.of(context).translate('ok'),
            icon: Icons.error_outline_rounded,
            iconColor: AppColors.primaryRed,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        DialogHelper.showAnimatedErrorDialog(
          context: context,
          title: AppLocalizations.of(context).translate('error'),
          message: '${AppLocalizations.of(context).translate('cannot_open_maps')}: $e',
          buttonText: AppLocalizations.of(context).translate('ok'),
          icon: Icons.error_outline_rounded,
          iconColor: AppColors.primaryRed,
        );
      }
    }
  }

  Future<void> _openCalendar(String date) async {
    final parsedDate = DateTime.parse(date);
    final startDateTime = '${parsedDate.toIso8601String().substring(0, 10).replaceAll('-', '')}T${parsedDate.toIso8601String().substring(11, 19).replaceAll(':', '')}Z';
    final endDateTime = '${parsedDate.add(const Duration(days: 1)).toIso8601String().substring(0, 10).replaceAll('-', '')}T000000Z';

    final calendarUrl = Uri.parse(
      'https://www.google.com/calendar/render?action=TEMPLATE&dates=$startDateTime/$endDateTime&text=${Uri.encodeComponent(widget.appointment.eventName)}&location=${Uri.encodeComponent(widget.appointment.location)}',
    );

    try {
      if (await canLaunchUrl(calendarUrl)) {
        await launchUrl(calendarUrl, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          DialogHelper.showAnimatedErrorDialog(
            context: context,
            title: AppLocalizations.of(context).translate('error'),
            message: AppLocalizations.of(context).translate('cannot_open_calendar'),
            buttonText: AppLocalizations.of(context).translate('ok'),
            icon: Icons.error_outline_rounded,
            iconColor: AppColors.primaryRed,
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        DialogHelper.showAnimatedErrorDialog(
          context: context,
          title: AppLocalizations.of(context).translate('error'),
          message: '${AppLocalizations.of(context).translate('cannot_open_calendar')}: $e',
          buttonText: AppLocalizations.of(context).translate('ok'),
          icon: Icons.error_outline_rounded,
          iconColor: AppColors.primaryRed,
        );
      }
    }
  }

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return const Color(0xFFFF9800);
      case AppointmentStatus.completed:
        return const Color(0xFF4CAF50);
      case AppointmentStatus.cancelled:
        return const Color(0xFF757575);
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildHeroSection() {
    final localizations = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    return AnimatedBuilder(
      animation: _floatingAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _floatingAnimation.value),
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white,
                  Colors.grey.shade50,
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryRed.withOpacity(0.1),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                // Hero Icon with pulsing animation
                Container(
                  width: 80,
                  height: 80,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryRed,
                        AppColors.primaryRed.withOpacity(0.8),
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryRed.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    color: Colors.white,
                    size: 40,
                  ),
                ),

                // Event name
                Text(
                  widget.appointment.eventName,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A1A),
                    height: 1.2,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                const SizedBox(height: 16),

                // Status chip
                _buildModernStatusChip(widget.appointment.status, languageCode),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildModernStatusChip(AppointmentStatus status, String languageCode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: _getStatusColor(status).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _getStatusColor(status).withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _getStatusColor(status),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            widget.appointment.getStatusText(languageCode),
            style: TextStyle(
              color: _getStatusColor(status),
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSection() {
    final localizations = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chi tiết cuộc hẹn',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 16),

          _buildModernInfoCard([
            _buildInfoItem(
              Icons.calendar_today_rounded,
              localizations.translate('date'),
              widget.appointment.getFormattedDate(),
              const Color(0xFF2196F3),
              onTap: () => _openCalendar(widget.appointment.appointmentDate),
            ),
            _buildInfoItem(
              Icons.access_time_rounded,
              localizations.translate('time'),
              widget.appointment.getFormattedTime(),
              const Color(0xFF9C27B0),
            ),
          ]),

          const SizedBox(height: 12),

          _buildModernInfoCard([
            _buildInfoItem(
              Icons.location_on_rounded,
              localizations.translate('location'),
              widget.appointment.location,
              const Color(0xFF4CAF50),
              onTap: () => _openGoogleMaps(widget.appointment.location),
            ),
          ]),

          const SizedBox(height: 12),

          _buildModernInfoCard([
            _buildInfoItem(
              Icons.business_rounded,
              localizations.translate('organization'),
              widget.appointment.organizationName,
              const Color(0xFFFF9800),
            ),
            _buildInfoItem(
              Icons.bloodtype_rounded,
              localizations.translate('blood_component_history'),
              widget.appointment.getBloodComponentText(languageCode),
              AppColors.primaryRed,
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildModernInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: children.map((child) {
          final index = children.indexOf(child);
          return Column(
            children: [
              child,
              if (index < children.length - 1) ...[
                const SizedBox(height: 16),
                Divider(
                  color: Colors.grey.shade200,
                  height: 1,
                ),
                const SizedBox(height: 16),
              ],
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildInfoItem(
      IconData icon,
      String label,
      String value,
      Color color, {
        VoidCallback? onTap,
      }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
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
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: onTap != null ? color : const Color(0xFF1A1A1A),
                      fontWeight: FontWeight.w600,
                      decoration: onTap != null ? TextDecoration.underline : null,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            if (onTap != null)
              Icon(
                Icons.arrow_forward_ios_rounded,
                size: 16,
                color: color,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    final localizations = AppLocalizations.of(context);
    final isPast = DateTime.parse(widget.appointment.appointmentDate).isBefore(DateTime.now());

    if (isPast || widget.appointment.status != AppointmentStatus.pending) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Complete button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                DialogHelper.showConfirmationDialog(
                  context: context,
                  title: localizations.translate('complete_appointment'),
                  message: localizations.translate('confirm_complete_appointment'),
                  cancelButtonText: localizations.translate('no'),
                  confirmButtonText: localizations.translate('yes'),
                  onConfirm: _completeAppointment,
                  icon: Icons.check_circle_rounded,
                  iconColor: Colors.green,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadowColor: const Color(0xFF4CAF50).withOpacity(0.3),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.check_circle_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    localizations.translate('mark_completed'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          // Cancel button
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: () {
                DialogHelper.showConfirmationDialog(
                  context: context,
                  title: localizations.translate('cancel_appointment'),
                  message: localizations.translate('confirm_cancel_appointment'),
                  cancelButtonText: localizations.translate('no'),
                  confirmButtonText: localizations.translate('yes'),
                  onConfirm: _cancelAppointment,
                  icon: Icons.warning_rounded,
                  iconColor: AppColors.primaryRed,
                );
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primaryRed,
                side: BorderSide(color: AppColors.primaryRed.withOpacity(0.3), width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.cancel_rounded, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    localizations.translate('cancel_appointment'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: Stack(
        children: [
          // Background gradient
          Container(
            height: 200,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primaryRed,
                  AppColors.primaryRed.withOpacity(0.8),
                ],
              ),
            ),
          ),

          // Content
          SafeArea(
            child: Column(
              children: [
                // Custom App Bar
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 18),
                          onPressed: () => Navigator.pop(context),
                          padding: EdgeInsets.zero,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          localizations.translate('appointment_details'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable content
                Expanded(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHeroSection(),
                              const SizedBox(height: 8),
                              _buildInfoSection(),
                              const SizedBox(height: 24),
                              _buildActionButtons(),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: AppColors.primaryRed,
                        strokeWidth: 3,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Đang xử lý...',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}