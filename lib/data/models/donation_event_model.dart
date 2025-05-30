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
  final String description;
  final String? image;
  final String status;
  final bool isEmergency;

  DonationEvent({
    required this.id,
    required this.title,
    required this.location,
    required this.organizationName,
    required this.eventDate,
    required this.endTime,
    required this.requiredDonors,
    required this.currentDonors,
    required this.description,
    this.image,
    required this.status,
    required this.isEmergency,
  });

  factory DonationEvent.fromJson(Map<String, dynamic> json) {
    return DonationEvent(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      location: json['location'] ?? '',
      organizationName: json['organizationName'] ?? '',
      eventDate: json['eventDate'] ?? '',
      endTime: json['endTime'] ?? '',
      requiredDonors: (json['requiredDonors'] is int && json['requiredDonors'] >= 0)
          ? json['requiredDonors']
          : 0,
      currentDonors: (json['currentDonors'] is int && json['currentDonors'] >= 0)
          ? json['currentDonors']
          : 0,
      description: json['description'] ?? '',
      image: json['image'],
      status: json['status'] ?? 'Unknown',
      isEmergency: json['isEmergency'] ?? false,
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
      'description': description,
      'image': image,
      'status': status,
      'isEmergency': isEmergency,
    };
  }

  String getFormattedDate() {
    try {
      final date = DateTime.parse(eventDate);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return eventDate.split('T')[0];
    }
  }

  String getFormattedTime() {
    try {
      final start = DateTime.parse(eventDate);
      final end = DateTime.parse(endTime);
      final timeFormat = DateFormat('HH:mm');
      return '${timeFormat.format(start)} - ${timeFormat.format(end)}';
    } catch (e) {
      String formatTime(String dateStr) {
        if (dateStr.contains('T')) {
          final parts = dateStr.split('T');
          final timePart = parts[1].split('.')[0];
          return timePart;
        } else {
          return dateStr;
        }
      }

      final startTime = formatTime(eventDate);
      final endTimeStr = formatTime(endTime);
      return '$startTime - $endTimeStr';
    }
  }
}