import 'dart:convert';
import 'dart:io';
import 'package:blood_plus/data/models/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class UserService {
  static final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  static final client = IOClient(_httpClient);
  static const String baseUrl = 'https://10.0.2.2:7026/api';

  Future<UserModel> getUserInfo(String userId, String token) async {
    final url = Uri.parse('$baseUrl/user/$userId');

    try {
      final response = await client.get(
        url,
        headers: {
          'accept': 'text/plain',
          'Authorization': 'Bearer $token',
        },
      );

      print('UserInfo response status: ${response.statusCode}');
      print('UserInfo response body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        return UserModel.fromJson(jsonData);
      } else {
        throw Exception(
            'Lấy thông tin người dùng thất bại: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }
}