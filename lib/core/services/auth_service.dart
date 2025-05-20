import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/io_client.dart';

class AuthService {
  // Tạo client với bỏ qua chứng chỉ SSL
  static final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  static final client = IOClient(_httpClient);

  // API endpoint
  static const String baseUrl = 'https://10.0.2.2:7026/api';

  // Đăng nhập và lấy token
  Future<Map<String, dynamic>> login(String username, String password, Map<String, String> localizedStrings) async {    // Kiểm tra tài khoản tĩnh
    if (username == 'thanhthoai' && password == '123') {
      return {
        'accessToken': 'static_token_thanhthoai', // Token giả lập
        'message': 'Chào mừng mày trở lại! dmm.'
      };
    }

    // Nếu không phải tài khoản tĩnh, tiếp tục gọi API
    final url = Uri.parse('$baseUrl/auth/auth-account');
    final body = jsonEncode({
      'username': username,
      'password': password,
    });

    try {
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
          localizedStrings['login_failed']?.replaceAll('{statusCode}', response.statusCode.toString())?.replaceAll('{message}', response.body) ??
              'Đăng nhập thất bại: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      throw Exception(
        localizedStrings['connection_error']?.replaceAll('{error}', e.toString()) ?? 'Lỗi kết nối: $e',
      );
    }
  }
}