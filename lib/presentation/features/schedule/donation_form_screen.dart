import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:blood_plus/core/language_helper/localization.dart';
import 'package:blood_plus/core/widgets/custom_button.dart';
import 'package:blood_plus/data/services/appointment_service.dart';
import 'package:flutter/material.dart';

class DonationFormScreen extends StatefulWidget {
  final String eventId;

  const DonationFormScreen({super.key, required this.eventId});

  @override
  State<DonationFormScreen> createState() => _DonationFormScreenState();
}

class _DonationFormScreenState extends State<DonationFormScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  String bloodComponent = '0';
  bool hasDonatedBefore = false;
  bool hasDiseases = false;
  String diseaseDetails = '';
  bool isTakingMedicine = false;
  String medicineDetails = '';
  String symptoms = '';
  String riskBehavior = '';
  String travelHistory = '';
  String tattooOrSurgery = '';
  bool weightOver45kg = false;
  String notes = '';

  // New state variables for the 9 questions
  bool hasPreviousInfections = false;
  String previousInfectionsDetails = '';
  bool hadRecentIllness12Months = false;
  String recentIllnessDetails = '';
  bool hadRecentIllness6Months = false;
  bool hadRecentIllness1Month = false;
  bool hadRecentIllness14Days = false;
  String recentIllness14DaysDetails = '';
  bool usedAntibiotics7Days = false;
  String antibioticsDetails = '';
  bool isPregnantOrRecentMother = false;
  String pregnancyDetails = '';

  final List<Map<String, String>> bloodComponentOptions = [
    {'en': 'Red Blood Cells', 'vi': 'Hồng cầu', 'value': '0'},
    {'en': 'Plasma', 'vi': 'Huyết tương', 'value': '1'},
    {'en': 'Platelets', 'vi': 'Tiểu cầu', 'value': '2'},
    {'en': 'White Blood Cells', 'vi': 'Bạch cầu', 'value': '3'},
    {'en': 'Whole Blood', 'vi': 'Máu toàn phần', 'value': '4'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryRed),
          ),
        ),
      );

      final payload = {
        'eventId': widget.eventId,
        'bloodComponent': int.parse(bloodComponent),
        'hasDonatedBefore': hasDonatedBefore,
        'hasDiseases': hasDiseases,
        'diseaseDetails': hasDiseases ? diseaseDetails : '',
        'isTakingMedicine': isTakingMedicine,
        'medicineDetails': isTakingMedicine ? medicineDetails : '',
        'symptoms': symptoms,
        'riskBehavior': riskBehavior,
        'travelHistory': travelHistory,
        'tattooOrSurgery': tattooOrSurgery,
        'weightOver45kg': weightOver45kg,
        'notes': notes,
        'hasPreviousInfections': hasPreviousInfections,
        'previousInfectionsDetails': hasPreviousInfections ? previousInfectionsDetails : '',
        'hadRecentIllness12Months': hadRecentIllness12Months,
        'recentIllness12MonthsDetails': hadRecentIllness12Months ? recentIllnessDetails : '',
        'hadRecentIllness6Months': hadRecentIllness6Months,
        'hadRecentIllness1Month': hadRecentIllness1Month,
        'hadRecentIllness14Days': hadRecentIllness14Days,
        'recentIllness14DaysDetails': hadRecentIllness14Days ? recentIllness14DaysDetails : '',
        'usedAntibiotics7Days': usedAntibiotics7Days,
        'antibioticsDetails': usedAntibiotics7Days ? antibioticsDetails : '',
        'isPregnantOrRecentMother': isPregnantOrRecentMother,
        'pregnancyDetails': isPregnantOrRecentMother ? pregnancyDetails : '',
      };

      try {
        await AppointmentService().createAppointment(payload);
        if (context.mounted) {
          Navigator.pop(context); // Close loading dialog
          Navigator.pop(context); // Go back to previous screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.check_circle, color: Colors.white),
                  const SizedBox(width: 8),
                  Text(
                    AppLocalizations.of(context).translate('form_submitted_successfully'),
                  ),
                ],
              ),
              backgroundColor: Colors.green,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Row(
                children: [
                  const Icon(Icons.error, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Error: $e'),
                ],
              ),
              backgroundColor: Colors.red,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          );
        }
      }
    }
  }

  Widget _buildSectionTitle(String title) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primaryRed.withOpacity(0.1), Colors.transparent],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryRed.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: AppColors.primaryRed,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryRed,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard({required Widget child}) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(20),
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
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: child,
      ),
    );
  }

  Widget _buildStyledDropdown() {
    final localizations = AppLocalizations.of(context);
    return _buildAnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.bloodtype, color: AppColors.primaryRed, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  localizations.translate('blood_component'),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  maxLines: null,
                  overflow: TextOverflow.visible,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: bloodComponent,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryRed, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            items: bloodComponentOptions.map((option) {
              return DropdownMenuItem<String>(
                value: option['value']!,
                child: Text(
                  localizations.locale.languageCode == 'vi'
                      ? option['vi']!
                      : option['en']!,
                  style: const TextStyle(fontSize: 16),
                  maxLines: null,
                  overflow: TextOverflow.visible,
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                bloodComponent = value!;
              });
            },
            validator: (value) {
              if (value == null || !['0', '1', '2', '3', '4'].contains(value)) {
                return localizations.translate('invalid_blood_component');
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStyledSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
    IconData? icon,
  }) {
    return _buildAnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Icon(icon, color: AppColors.primaryRed, size: 24),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                  maxLines: null,
                  overflow: TextOverflow.visible,
                ),
              ),
              const SizedBox(width: 12),
              Transform.scale(
                scale: 1.2,
                child: Switch(
                  value: value,
                  onChanged: onChanged,
                  activeColor: AppColors.primaryRed,
                  activeTrackColor: AppColors.primaryRed.withOpacity(0.3),
                  inactiveThumbColor: Colors.grey.shade400,
                  inactiveTrackColor: Colors.grey.shade300,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStyledTextField({
    required String labelText,
    required FormFieldValidator<String>? validator,
    required FormFieldSetter<String>? onSaved,
    int maxLines = 1,
    IconData? icon,
  }) {
    return _buildAnimatedCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: AppColors.primaryRed, size: 24),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    labelText,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.4,
                    ),
                    maxLines: null,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ],
            )
          else
            Text(
              labelText,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
                height: 1.4,
              ),
              maxLines: null,
              overflow: TextOverflow.visible,
            ),
          const SizedBox(height: 12),
          TextFormField(
            maxLines: maxLines,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: Colors.grey.shade300),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.primaryRed, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey.shade50,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              hintStyle: TextStyle(color: Colors.grey.shade500),
            ),
            validator: validator,
            onSaved: onSaved,
          ),
        ],
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
          localizations.translate('donation_form'),
          style: const TextStyle(
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primaryRed.withOpacity(0.05),
                Colors.grey.shade50,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header card
                  _buildAnimatedCard(
                    child: Column(
                      children: [
                        Icon(
                          Icons.favorite,
                          size: 48,
                          color: AppColors.primaryRed,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          localizations.translate('donation_form'),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryRed,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localizations.translate('donation_form_des'),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _buildSectionTitle(AppLocalizations.of(context).translate('blood_component_selection')),
                  _buildStyledDropdown(),
                  _buildSectionTitle(AppLocalizations.of(context).translate('basic_information')),
                  _buildStyledSwitchTile(
                    title: localizations.translate('has_donated_before'),
                    value: hasDonatedBefore,
                    onChanged: (value) => setState(() => hasDonatedBefore = value),
                    icon: Icons.history,
                  ),

                  _buildStyledSwitchTile(
                    title: localizations.translate('weight_over_45kg'),
                    value: weightOver45kg,
                    onChanged: (value) => setState(() => weightOver45kg = value),
                    icon: Icons.monitor_weight,
                  ),

                  _buildSectionTitle(AppLocalizations.of(context).translate('health_information')),
                  _buildStyledSwitchTile(
                    title: localizations.translate('has_diseases'),
                    value: hasDiseases,
                    onChanged: (value) => setState(() => hasDiseases = value),
                    icon: Icons.medical_services,
                  ),

                  if (hasDiseases)
                    _buildStyledTextField(
                      labelText: localizations.translate('disease_details'),
                      validator: (value) {
                        if (hasDiseases && (value == null || value.trim().isEmpty)) {
                          return localizations.translate('disease_details_required');
                        }
                        return null;
                      },
                      onSaved: (value) => diseaseDetails = value ?? '',
                      icon: Icons.description,
                    ),

                  _buildStyledSwitchTile(
                    title: localizations.translate('is_taking_medicine'),
                    value: isTakingMedicine,
                    onChanged: (value) => setState(() => isTakingMedicine = value),
                    icon: Icons.medication,
                  ),

                  if (isTakingMedicine)
                    _buildStyledTextField(
                      labelText: localizations.translate('medicine_details'),
                      validator: (value) {
                        if (isTakingMedicine && (value == null || value.trim().isEmpty)) {
                          return localizations.translate('medicine_details_required');
                        }
                        return null;
                      },
                      onSaved: (value) => medicineDetails = value ?? '',
                      icon: Icons.description,
                    ),

                  _buildStyledTextField(
                    labelText: localizations.translate('symptoms'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return localizations.translate('symptoms_required');
                      }
                      return null;
                    },
                    onSaved: (value) => symptoms = value ?? '',
                    icon: Icons.sick,
                  ),

                  _buildStyledTextField(
                    labelText: localizations.translate('risk_behavior'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return localizations.translate('risk_behavior_required');
                      }
                      return null;
                    },
                    onSaved: (value) => riskBehavior = value ?? '',
                    icon: Icons.warning,
                  ),

                  _buildStyledTextField(
                    labelText: localizations.translate('travel_history'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return localizations.translate('travel_history_required');
                      }
                      return null;
                    },
                    onSaved: (value) => travelHistory = value ?? '',
                    icon: Icons.flight,
                  ),

                  _buildStyledTextField(
                    labelText: localizations.translate('tattoo_or_surgery'),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return localizations.translate('tattoo_or_surgery_required');
                      }
                      return null;
                    },
                    onSaved: (value) => tattooOrSurgery = value ?? '',
                    icon: Icons.healing,
                  ),

                  _buildSectionTitle(AppLocalizations.of(context).translate('recent_health_history')),

                  _buildStyledSwitchTile(
                    title: localizations.translate('has_previous_infections'),
                    value: hasPreviousInfections,
                    onChanged: (value) => setState(() => hasPreviousInfections = value),
                    icon: Icons.coronavirus,
                  ),

                  if (hasPreviousInfections)
                    _buildStyledTextField(
                      labelText: localizations.translate('previous_infections_details'),
                      validator: (value) {
                        if (hasPreviousInfections && (value == null || value.trim().isEmpty)) {
                          return localizations.translate('previous_infections_details_required');
                        }
                        return null;
                      },
                      onSaved: (value) => previousInfectionsDetails = value ?? '',
                      icon: Icons.description,
                    ),

                  _buildStyledSwitchTile(
                    title: localizations.translate('had_recent_illness_12_months'),
                    value: hadRecentIllness12Months,
                    onChanged: (value) => setState(() => hadRecentIllness12Months = value),
                    icon: Icons.event_note,
                  ),

                  if (hadRecentIllness12Months)
                    _buildStyledTextField(
                      labelText: localizations.translate('recent_illness_12_months_details'),
                      validator: (value) {
                        if (hadRecentIllness12Months && (value == null || value.trim().isEmpty)) {
                          return localizations.translate('recent_illness_12_months_details_required');
                        }
                        return null;
                      },
                      onSaved: (value) => recentIllnessDetails = value ?? '',
                      icon: Icons.description,
                    ),

                  _buildStyledSwitchTile(
                    title: localizations.translate('had_recent_illness_6_months'),
                    value: hadRecentIllness6Months,
                    onChanged: (value) => setState(() => hadRecentIllness6Months = value),
                    icon: Icons.event_note,
                  ),

                  _buildStyledSwitchTile(
                    title: localizations.translate('had_recent_illness_1_month'),
                    value: hadRecentIllness1Month,
                    onChanged: (value) => setState(() => hadRecentIllness1Month = value),
                    icon: Icons.event_note,
                  ),

                  _buildStyledSwitchTile(
                    title: localizations.translate('had_recent_illness_14_days'),
                    value: hadRecentIllness14Days,
                    onChanged: (value) => setState(() => hadRecentIllness14Days = value),
                    icon: Icons.event_note,
                  ),

                  if (hadRecentIllness14Days)
                    _buildStyledTextField(
                      labelText: localizations.translate('recent_illness_14_days_details'),
                      validator: (value) {
                        if (hadRecentIllness14Days && (value == null || value.trim().isEmpty)) {
                          return localizations.translate('recent_illness_14_days_details_required');
                        }
                        return null;
                      },
                      onSaved: (value) => recentIllness14DaysDetails = value ?? '',
                      icon: Icons.description,
                    ),

                  _buildStyledSwitchTile(
                    title: localizations.translate('used_antibiotics_7_days'),
                    value: usedAntibiotics7Days,
                    onChanged: (value) => setState(() => usedAntibiotics7Days = value),
                    icon: Icons.medication,
                  ),

                  if (usedAntibiotics7Days)
                    _buildStyledTextField(
                      labelText: localizations.translate('antibiotics_details'),
                      validator: (value) {
                        if (usedAntibiotics7Days && (value == null || value.trim().isEmpty)) {
                          return localizations.translate('antibiotics_details_required');
                        }
                        return null;
                      },
                      onSaved: (value) => antibioticsDetails = value ?? '',
                      icon: Icons.description,
                    ),

                  _buildSectionTitle(AppLocalizations.of(context).translate('pregnancy')),
                  _buildStyledSwitchTile(
                    title: localizations.translate('is_pregnant_or_recent_mother'),
                    value: isPregnantOrRecentMother,
                    onChanged: (value) => setState(() => isPregnantOrRecentMother = value),
                    icon: Icons.pregnant_woman,
                  ),

                  if (isPregnantOrRecentMother)
                    _buildStyledTextField(
                      labelText: localizations.translate('pregnancy_details'),
                      validator: (value) {
                        if (isPregnantOrRecentMother && (value == null || value.trim().isEmpty)) {
                          return localizations.translate('pregnancy_details_required');
                        }
                        return null;
                      },
                      onSaved: (value) => pregnancyDetails = value ?? '',
                      icon: Icons.description,
                    ),

                  _buildSectionTitle(AppLocalizations.of(context).translate('additional_notes')),
                  _buildStyledTextField(
                    labelText: localizations.translate('notes'),
                    maxLines: 4,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return localizations.translate('notes_required');
                      }
                      return null;
                    },
                    onSaved: (value) => notes = value ?? '',
                    icon: Icons.note_add,
                  ),

                  const SizedBox(height: 32),
                  _buildAnimatedCard(
                    child: SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                          shadowColor: AppColors.primaryRed.withOpacity(0.3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.send, color: Colors.white, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              localizations.translate('submit'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}