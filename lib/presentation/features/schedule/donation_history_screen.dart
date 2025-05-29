import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/core/widgets/custom_button.dart';
import 'package:blood_plus/core/widgets/custom_confirmation_dialog.dart';
import 'package:blood_plus/data/models/donation_event_model.dart';
import 'package:blood_plus/data/services/appointment_service.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final AppointmentService _appointmentService = AppointmentService();
  List<DonationEvent> _appointments = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeOut));
    _fadeController.forward();
    _fetchAppointments();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  Future<void> _fetchAppointments() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final appointments = await _appointmentService.getAppointments();
      print('Appointments fetched: $appointments');
      setState(() {
        _isLoading = false;
        _appointments = appointments;
      });
    } catch (e) {
      print('Error fetching appointments: $e');
      setState(() {
        _isLoading = false;
        _appointments = [];
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).translate('error_loading_appointments') + ': $e'),
            backgroundColor: AppColors.primaryRed,
          ),
        );
      }
    }
  }

  Future<void> _cancelAppointment(String appointmentId) async {
    setState(() {
      _isLoading = true;
    });
    try {
      await _appointmentService.cancelAppointment(appointmentId);
      setState(() {
        _isLoading = false;
        _appointments.removeWhere((appointment) => appointment.id == appointmentId);
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).translate('appointment_canceled')),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error canceling appointment: $e'),
            backgroundColor: AppColors.primaryRed,
          ),
        );
      }
    }
  }

  Widget _buildAppointmentCard(DonationEvent appointment) {
    final isPast = DateTime.parse(appointment.eventDate).isBefore(DateTime.now());
    final localizations = AppLocalizations.of(context);

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryRed.withOpacity(0.1), Colors.transparent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.favorite,
                  color: AppColors.primaryRed,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      appointment.title,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${localizations.translate('date')}: ${appointment.getFormattedDate()}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${localizations.translate('time')}: ${appointment.getFormattedTime()}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    Text(
                      '${localizations.translate('location')}: ${appointment.location}',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (!isPast)
                CustomButton(
                  text: localizations.translate('cancel'),
                  color: Colors.grey.shade400,
                  textColor: AppColors.textPrimary,
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => CustomConfirmationDialog(
                        title: localizations.translate('cancel_appointment'),
                        message: localizations.translate('confirm_cancel_appointment'),
                        cancelButtonText: localizations.translate('no'),
                        confirmButtonText: localizations.translate('yes'),
                        onCancel: () => Navigator.pop(context),
                        onConfirm: () {
                          Navigator.pop(context);
                          _cancelAppointment(appointment.id);
                        },
                        icon: Icons.cancel,
                        iconColor: Colors.grey,
                      ),
                    );
                  },
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  borderRadius: 8,
                  height: 40,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          localizations.translate('history'),
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primaryRed))
          : _appointments.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.event_busy, color: AppColors.primaryRed, size: 60),
            const SizedBox(height: 16),
            Text(
              localizations.translate('no_appointments'),
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              localizations.translate('your_appointments'),
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                return _buildAppointmentCard(_appointments[index]);
              },
            ),
          ],
        ),
      ),
    );
  }
}