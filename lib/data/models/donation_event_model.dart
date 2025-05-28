import 'package:intl/intl.dart';

class DonationEvent {
  final String id;
  final String title;
  final String location;
  final String organizationName;
  final String eventDate;
  final String endTime;
  final int requiredDonors;
  final int currentDonors;

  DonationEvent({
    required this.id,
    required this.title,
    required this.location,
    required this.organizationName,
    required this.eventDate,
    required this.endTime,
    required this.requiredDonors,
    required this.currentDonors,
  });

  factory DonationEvent.fromJson(Map<String, dynamic> json) {
    return DonationEvent(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      organizationName: json['organizationName'] ?? '',
      eventDate: json['eventDate'] ?? '',
      endTime: json['endTime'] ?? '',
      requiredDonors: json['requiredDonors'] ?? 0,
      currentDonors: json['currentDonors'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'location': location,
      'organizationName': organizationName,
      'eventDate': eventDate,
      'endTime': endTime,
      'requiredDonors': requiredDonors,
      'currentDonors': currentDonors,
    };
  }

  // Định dạng ngày (dd/MM/yyyy)
  String getFormattedDate() {
    try {
      final date = DateTime.parse(eventDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return eventDate.split('T')[0]; // Fallback nếu parse lỗi
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
