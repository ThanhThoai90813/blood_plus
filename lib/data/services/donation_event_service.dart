import 'dart:convert';
import 'dart:io';
import 'package:blood_plus/data/manager/user_manager.dart';
import 'package:blood_plus/data/repositories/donation_event_response.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class DonationEventService {
  static final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  static final client = IOClient(_httpClient);
  static const String baseUrl = 'https://10.0.2.2:7026/api';
  final UserManager _userManager = UserManager();

  Future<DonationEventResponse> getDonationEvents({
    String? location,
    String? startDate,
    String? endDate,
    String? organization,
    int pageNumber = 1,
    int pageSize = 5,
  }) async {
    final token = await _userManager.getUserToken();
    final queryParameters = {
      'location': location,
      'startDate': startDate,
      'endDate': endDate,
      'organization': organization,
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
    };

    queryParameters.removeWhere((key, value) => value == null);

    final url = Uri.parse('$baseUrl/donationevent').replace(queryParameters: queryParameters);

    try {
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
          'Authorization': 'Bearer $token', // Thêm token vào header
        },
      );

      print('DonationEvent response status: ${response.statusCode}');
      print('DonationEvent response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return DonationEventResponse.fromJson(data);
      } else {
        throw Exception('Lấy danh sách sự kiện thất bại: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }
}