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

class _DonationFormScreenState extends State<DonationFormScreen> {
  final _formKey = GlobalKey<FormState>();
  int bloodComponent = 0;
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

  final List<Map<String, String>> bloodComponentOptions = [
    {'en': 'Red Blood Cells', 'vi': 'Hồng cầu', 'value': '0'},
    {'en': 'Plasma', 'vi': 'Huyết tương', 'value': '1'},
    {'en': 'Platelets', 'vi': 'Tiểu cầu', 'value': '2'},
    {'en': 'White Blood Cells', 'vi': 'Bạch cầu', 'value': '3'},
    {'en': 'Whole Blood', 'vi': 'Máu toàn phần', 'value': '4'},
  ];

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final payload = {
        'eventId': widget.eventId,
        'bloodComponent': bloodComponent,
        'hasDonatedBefore': hasDonatedBefore,
        'hasDiseases': hasDiseases,
        'diseaseDetails': diseaseDetails,
        'isTakingMedicine': isTakingMedicine,
        'medicineDetails': medicineDetails,
        'symptoms': symptoms,
        'riskBehavior': riskBehavior,
        'travelHistory': travelHistory,
        'tattooOrSurgery': tattooOrSurgery,
        'weightOver45kg': weightOver45kg,
        'notes': notes,
      };

      try {
        await AppointmentService().createAppointment(payload);
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context).translate('form_submitted_successfully'))),
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          localizations.translate('donation_form'),
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: AppColors.primaryRed,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: bloodComponent,
                decoration: InputDecoration(
                  labelText: localizations.translate('blood_component'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                items: bloodComponentOptions.map((option) {
                  return DropdownMenuItem<int>(
                    value: int.parse(option['value']!),
                    child: Text(localizations.locale.languageCode == 'vi' ? option['vi']! : option['en']!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    bloodComponent = value!;
                  });
                },
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text(localizations.translate('has_donated_before')),
                value: hasDonatedBefore,
                onChanged: (value) {
                  setState(() {
                    hasDonatedBefore = value;
                  });
                },
                activeColor: AppColors.primaryRed,
              ),
              SwitchListTile(
                title: Text(localizations.translate('has_diseases')),
                value: hasDiseases,
                onChanged: (value) {
                  setState(() {
                    hasDiseases = value;
                  });
                },
                activeColor: AppColors.primaryRed,
              ),
              if (hasDiseases) ...[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: localizations.translate('disease_details'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onSaved: (value) => diseaseDetails = value ?? '',
                ),
                const SizedBox(height: 16),
              ],
              SwitchListTile(
                title: Text(localizations.translate('is_taking_medicine')),
                value: isTakingMedicine,
                onChanged: (value) {
                  setState(() {
                    isTakingMedicine = value;
                  });
                },
                activeColor: AppColors.primaryRed,
              ),
              if (isTakingMedicine) ...[
                TextFormField(
                  decoration: InputDecoration(
                    labelText: localizations.translate('medicine_details'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onSaved: (value) => medicineDetails = value ?? '',
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                decoration: InputDecoration(
                  labelText: localizations.translate('symptoms'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onSaved: (value) => symptoms = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: localizations.translate('risk_behavior'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onSaved: (value) => riskBehavior = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: localizations.translate('travel_history'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onSaved: (value) => travelHistory = value ?? '',
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: localizations.translate('tattoo_or_surgery'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onSaved: (value) => tattooOrSurgery = value ?? '',
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                title: Text(localizations.translate('weight_over_45kg')),
                value: weightOver45kg,
                onChanged: (value) {
                  setState(() {
                    weightOver45kg = value;
                  });
                },
                activeColor: AppColors.primaryRed,
              ),
              TextFormField(
                decoration: InputDecoration(
                  labelText: localizations.translate('notes'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                maxLines: 3,
                onSaved: (value) => notes = value ?? '',
              ),
              const SizedBox(height: 24),
              Center(
                child: CustomButton(
                  text: localizations.translate('submit'),
                  color: AppColors.primaryRed,
                  onPressed: _submitForm,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}