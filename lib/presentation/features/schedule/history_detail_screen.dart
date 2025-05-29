import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/constants/app_theme.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/core/widgets/custom_button.dart';
import 'package:blood_plus/core/widgets/dialog_helper.dart';
import 'package:blood_plus/data/models/AppointmentStatus.dart';
import 'package:blood_plus/data/models/appointment_model.dart';
import 'package:blood_plus/data/services/appointment_service.dart';
import 'package:flutter/material.dart';

class HistoryDetailScreen extends StatefulWidget {
  final Appointment appointment;
  final VoidCallback onCancel;

  const HistoryDetailScreen({
    super.key,
    required this.appointment,
    required this.onCancel,
  });

  @override
  State<HistoryDetailScreen> createState() => _HistoryDetailScreenState();
}

class _HistoryDetailScreenState extends State<HistoryDetailScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late AnimationController _statusController;
  late Animation<double> _statusScaleAnimation;
  final AppointmentService _appointmentService = AppointmentService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic));

    _statusController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _statusScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _statusController, curve: Curves.elasticOut),
    );
    _fadeController.forward();
    _statusController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _cancelAppointment() async {
    if (widget.appointment.status != AppointmentStatus.pending) {
      if (context.mounted) {
        DialogHelper.showAnimatedErrorDialog( // Sửa thành showAnimatedErrorDialog
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
        DialogHelper.showAnimatedErrorDialog( // Sửa thành showAnimatedErrorDialog
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

  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return Colors.amber.shade600;
      case AppointmentStatus.completed:
        return AppColors.primaryRed;
      case AppointmentStatus.cancelled:
        return Colors.grey.shade600;
      default:
        return AppColors.textSecondary;
    }
  }

  Widget _buildInfoRow({required IconData icon, required String label, required String value}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 24, color: AppColors.primaryRed),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTheme.bodyMedium,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(AppointmentStatus status, String languageCode) {
    return AnimatedBuilder(
      animation: _statusController,
      builder: (context, child) {
        return Transform.scale(
          scale: _statusScaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _getStatusColor(status).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _getStatusColor(status).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Text(
              widget.appointment.getStatusText(languageCode),
              style: AppTheme.bodyMedium.copyWith(
                color: _getStatusColor(status),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final isPast = DateTime.parse(widget.appointment.appointmentDate).isBefore(DateTime.now());

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        title: Text(
          localizations.translate('appointment_details'),
          style: AppTheme.headingLarge.copyWith(color: Colors.white),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
          ),
        ),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: AppTheme.glassmorphismDecoration,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 64,
                                height: 64,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: AppTheme.cardGradient,
                                  border: Border.all(color: AppColors.primaryRed.withOpacity(0.3), width: 1.5),
                                ),
                                child: Icon(
                                  Icons.favorite_rounded,
                                  color: AppColors.primaryRed,
                                  size: 32,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Text(
                                  widget.appointment.eventName,
                                  style: AppTheme.headingMedium,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          _buildInfoRow(
                            icon: Icons.calendar_today_rounded,
                            label: localizations.translate('date'),
                            value: widget.appointment.getFormattedDate(),
                          ),
                          _buildInfoRow(
                            icon: Icons.access_time_rounded,
                            label: localizations.translate('time'),
                            value: widget.appointment.getFormattedTime(),
                          ),
                          _buildInfoRow(
                            icon: Icons.location_on_rounded,
                            label: localizations.translate('location'),
                            value: widget.appointment.location,
                          ),
                          _buildInfoRow(
                            icon: Icons.business_rounded,
                            label: localizations.translate('organization'),
                            value: widget.appointment.organizationName,
                          ),
                          _buildInfoRow(
                            icon: Icons.bloodtype_rounded,
                            label: localizations.translate('blood_component'),
                            value: widget.appointment.getBloodComponentText(languageCode),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            localizations.translate('status'),
                            style: AppTheme.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _buildStatusChip(widget.appointment.status, languageCode),
                        ],
                      ),
                    ),
                    if (!isPast && widget.appointment.status == AppointmentStatus.pending) ...[
                      const SizedBox(height: 24),
                      Center(
                        child: AnimatedOpacity(
                          opacity: !isPast && widget.appointment.status == AppointmentStatus.pending ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: CustomButton(
                            text: localizations.translate('cancel_appointment'),
                            color: AppColors.primaryRed,
                            textColor: Colors.white,
                            icon: Icons.cancel_rounded,
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
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            borderRadius: 16,
                            width: 220,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [
                        AppColors.primaryRed.withOpacity(0.2),
                        AppColors.primaryRed.withOpacity(0.05),
                      ],
                    ),
                  ),
                  child: const CircularProgressIndicator(
                    color: AppColors.primaryRed,
                    strokeWidth: 3,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}