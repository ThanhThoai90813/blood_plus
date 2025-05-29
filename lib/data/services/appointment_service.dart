import 'dart:convert';
import 'dart:io';
import 'package:blood_plus/data/manager/user_manager.dart';
import 'package:blood_plus/data/models/appointment_model.dart';
import 'package:blood_plus/data/repositories/appointment_response.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class AppointmentService {
  static final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  static final client = IOClient(_httpClient);
  static const String baseUrl = 'https://10.0.2.2:7026/api';
  final UserManager _userManager = UserManager();

  // Tạo cuộc hẹn (đã có sẵn trong mã của bạn)
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
        throw Exception('Failed to create appointment: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Connection error: $e');
    }
  }

  // Lấy danh sách cuộc hẹn của người dùng
  Future<List<Appointment>> getAppointments({
    int pageNumber = 1,
    int pageSize = 5,
  }) async {
    final token = await _userManager.getUserToken();
    final queryParameters = {
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
    };

    final url = Uri.parse('$baseUrl/appointment').replace(queryParameters: queryParameters);

    try {
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get Appointments response status: ${response.statusCode}');
      print('Get Appointments response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final appointmentResponse = AppointmentResponse.fromJson(data);
        return appointmentResponse.items;
      } else {
        throw Exception('Lấy danh sách cuộc hẹn thất bại: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  // Hủy cuộc hẹn
  Future<void> cancelAppointment(String appointmentId) async {
    final token = await _userManager.getUserToken();
    final url = Uri.parse('$baseUrl/appointment/markcancel-$appointmentId');

    try {
      final response = await client.patch(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'text/plain',
          'Authorization': 'Bearer $token',
        },
      );

      print('Cancel Appointment response status: ${response.statusCode}');
      print('Cancel Appointment response body: ${response.body}');

      if (response.statusCode == 200) {
        print('Appointment canceled successfully: ${response.body}');
      } else {
        throw Exception('Hủy cuộc hẹn thất bại: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }
}