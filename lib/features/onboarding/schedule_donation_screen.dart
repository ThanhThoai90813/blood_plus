import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:blood_plus/core/localization.dart';
import 'package:blood_plus/core/constants/app_colors.dart';
import 'package:intl/intl.dart';

class ScheduleDonationScreen extends StatefulWidget {
  const ScheduleDonationScreen({Key? key}) : super(key: key);

  @override
  _ScheduleDonationScreenState createState() => _ScheduleDonationScreenState();
}

class _ScheduleDonationScreenState extends State<ScheduleDonationScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedLocation;
  bool _isHealthy = false;

  final List<String> _locations = [
    'Bệnh viện Chợ Rẫy, TP.HCM',
    'Bệnh viện Hùng Vương, TP.HCM',
    'Trung tâm Hiến máu Nhân đạo, Hà Nội',
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2026),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null || _selectedLocation == null || !_isHealthy) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Vui lòng điền đầy đủ thông tin và xác nhận sức khỏe!')),
        );
        return;
      }
      // Simulate successful scheduling
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lịch hiến máu đã được đặt thành công!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.translate('schedule_donation'),
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: AppColors.primaryRed,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                localizations.translate('schedule_donation'),
                style: GoogleFonts.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: localizations.translate('date_of_birth'),
                  suffixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: TextEditingController(
                  text: _selectedDate == null
                      ? ''
                      : DateFormat('dd/MM/yyyy').format(_selectedDate!),
                ),
                onTap: () => _selectDate(context),
                validator: (value) => _selectedDate == null ? 'Vui lòng chọn ngày' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  labelText: localizations.translate('phone'),
                  suffixIcon: Icon(Icons.access_time),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                controller: TextEditingController(
                  text: _selectedTime == null
                      ? ''
                      : _selectedTime!.format(context),
                ),
                onTap: () => _selectTime(context),
                validator: (value) => _selectedTime == null ? 'Vui lòng chọn giờ' : null,
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: localizations.translate('nearby_hospitals'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                value: _selectedLocation,
                items: _locations.map((String location) {
                  return DropdownMenuItem<String>(
                    value: location,
                    child: Text(location),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedLocation = newValue;
                  });
                },
                validator: (value) => value == null ? 'Vui lòng chọn địa điểm' : null,
              ),
              const SizedBox(height: 20),
              SwitchListTile(
                title: Text(localizations.translate('who_can_donate')),
                value: _isHealthy,
                onChanged: (bool value) {
                  setState(() {
                    _isHealthy = value;
                  });
                },
                subtitle: Text(localizations.translate('who_can_donate_desc')),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  localizations.translate('save_info'),
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}