import 'dart:convert';
import 'dart:io';
import 'package:blood_plus/data/manager/user_manager.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class AppointmentService {
  static final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  static final client = IOClient(_httpClient);
  static const String baseUrl = 'https://10.0.2.2:7026/api';
  final UserManager _userManager = UserManager();

  Future<void> createAppointment(Map<String, dynamic> payload) async {
    final token = await _userManager.getUserToken();
    final url = Uri.parse('$baseUrl/appointment');

    try {
      print('Payload: $payload');
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'text/plain',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print('Appointment created successfully: ${response.body}');
      } else {
        throw Exception('Failed to appointment: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }
}