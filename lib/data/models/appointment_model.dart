import 'package:blood_plus/data/models/AppointmentStatus.dart';
import 'package:intl/intl.dart';

class Appointment {
  final String id;
  final String eventName;
  final int bloodComponent;
  final String organizationName;
  final String location;
  final String appointmentDate;
  final AppointmentStatus status;

  Appointment({
    required this.id,
    required this.eventName,
    required this.bloodComponent,
    required this.organizationName,
    required this.location,
    required this.appointmentDate,
    required this.status,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      id: json['id'] ?? '',
      eventName: json['eventName'] ?? '',
      bloodComponent: json['bloodComponent'] ?? 0,
      organizationName: json['organizationName'] ?? '',
      location: json['location'] ?? '',
      appointmentDate: json['appointmentDate'] ?? '',
      status: AppointmentStatus.fromValue(json['status'] ?? 0),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'eventName': eventName,
      'bloodComponent': bloodComponent,
      'organizationName': organizationName,
      'location': location,
      'appointmentDate': appointmentDate,
      'status': status.value,
    };
  }

  String getFormattedDate() {
    try {
      final date = DateTime.parse(appointmentDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return appointmentDate.split('T')[0]; // Fallback
    }
  }

  String getFormattedTime() {
    try {
      final date = DateTime.parse(appointmentDate);
      return DateFormat('HH:mm').format(date);
    } catch (e) {
      return appointmentDate.split('T')[1].split('.')[0]; // Fallback
    }
  }

  String getStatusText(String languageCode) {
    switch (status) {
      case AppointmentStatus.pending:
        return languageCode == 'vi' ? 'Chờ xử lý' : 'Pending';
      case AppointmentStatus.completed:
        return languageCode == 'vi' ? 'Đã hoàn thành' : 'Completed';
      case AppointmentStatus.cancelled:
        return languageCode == 'vi' ? 'Đã hủy' : 'Cancelled';
    }
  }

  String getBloodComponentText(String languageCode) {
    switch (bloodComponent) {
      case 0:
        return languageCode == 'vi' ? 'Hồng cầu' : 'Red Blood Cells';
      case 1:
        return languageCode == 'vi' ? 'Huyết tương' : 'Plasma';
      case 2:
        return languageCode == 'vi' ? 'Tiểu cầu' : 'Platelets';
      case 3:
        return languageCode == 'vi' ? 'Bạch cầu' : 'White Blood Cells';
      case 4:
        return languageCode == 'vi' ? 'Máu toàn phần' : 'Whole Blood';
      default:
        return languageCode == 'vi' ? 'Không xác định' : 'Unknown';
    }
  }
}