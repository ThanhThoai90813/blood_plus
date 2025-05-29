import 'package:blood_plus/data/models/appointment_model.dart';

class AppointmentResponse {
  final List<Appointment> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  AppointmentResponse({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory AppointmentResponse.fromJson(Map<String, dynamic> json) {
    final message = json['message'] as Map<String, dynamic>? ?? {};
    final itemsData = message['items'] as Map<String, dynamic>? ?? {};
    final values = itemsData[r'$values'] as List<dynamic>? ?? [];

    return AppointmentResponse(
      items: values.map((item) => Appointment.fromJson(item as Map<String, dynamic>)).toList(),
      totalItems: message['totalItems'] ?? 0,
      totalPages: message['totalPages'] ?? 0,
      currentPage: message['currentPage'] ?? 1,
      pageSize: message['pageSize'] ?? 5,
      hasPreviousPage: message['hasPreviousPage'] ?? false,
      hasNextPage: message['hasNextPage'] ?? false,
    );
  }
}