import 'dart:convert';

import 'package:blood_plus/data/models/donation_event_model.dart';

class DonationEventResponse {
  final List<DonationEvent> items;
  final int totalItems;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final bool hasPreviousPage;
  final bool hasNextPage;

  DonationEventResponse({
    required this.items,
    required this.totalItems,
    required this.totalPages,
    required this.currentPage,
    required this.pageSize,
    required this.hasPreviousPage,
    required this.hasNextPage,
  });

  factory DonationEventResponse.fromJson(Map<String, dynamic> json) {
    final message = json['message'] as Map<String, dynamic>? ?? {};
    final itemsData = message['items'] as Map<String, dynamic>? ?? {};
    final values = itemsData[r'$values'] as List<dynamic>? ?? [];

    return DonationEventResponse(
      items: values.map((item) => DonationEvent.fromJson(item as Map<String, dynamic>)).toList(),
      totalItems: message['totalItems'] ?? 0,
      totalPages: message['totalPages'] ?? 0,
      currentPage: message['currentPage'] ?? 1,
      pageSize: message['pageSize'] ?? 5,
      hasPreviousPage: message['hasPreviousPage'] ?? false,
      hasNextPage: message['hasNextPage'] ?? false,
    );
  }
}