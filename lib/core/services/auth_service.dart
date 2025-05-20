import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http/io_client.dart';

class AuthService {
  static final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host,
        int port) => true;
  static final client = IOClient(_httpClient);
  static const String baseUrl = 'https://10.0.2.2:7026/api';

  // Đăng nhập bằng tài khoản thông thường
  Future<Map<String, dynamic>> login(String username, String password,
      Map<String, String> localizedStrings) async {
    if (username == 'thanhthoai' && password == '123') {
      return {
        'accessToken': 'static_token_thanhthoai',
        'message': 'Chào mừng mày trở lại! dmm.'
      };
    }

    final url = Uri.parse('$baseUrl/auth/auth-account');
    final body = jsonEncode({'username': username, 'password': password});

    try {
      final response = await client.post(url, headers: {
        'Content-Type': 'application/json',
        'accept': '*/*',
      }, body: body);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception(
            localizedStrings['login_failed']?.replaceAll(
                '{statusCode}', response.statusCode.toString())?.replaceAll(
                '{message}', response.body) ?? 'Đăng nhập thất bại');
      }
    } catch (e) {
      throw Exception(
          localizedStrings['connection_error']?.replaceAll(
              '{error}', e.toString()) ?? 'Lỗi kết nối: $e');
    }
  }

  // Đăng nhập bằng Google
  Future<Map<String, dynamic>> loginWithGoogle(
      Map<String, String> localizedStrings) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      serverClientId: '33333980186-6tgdq00nt9ejnsq02gp6h77ejkugg0be.apps.googleusercontent.com',
    );

    try {
      print('1. Bắt đầu quá trình đăng nhập Google...');

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        print('2. Người dùng đã hủy đăng nhập');
        return {'error': 'Đăng nhập Google bị hủy'};
      }

      print('3. Đã chọn tài khoản Google: ${googleUser.email}');
      print('4. Lấy thông tin xác thực...');

      final GoogleSignInAuthentication googleAuth = await googleUser
          .authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      print('5. Nhận được idToken: ${idToken != null ? "CÓ" : "KHÔNG"}');
      print(
          '6. Nhận được accessToken: ${accessToken != null ? "CÓ" : "KHÔNG"}');

      if (idToken == null) {
        print('7. LỖI: Không thể lấy idToken');
        throw Exception('Không thể lấy idToken');
      }

      print('8. Gửi idToken đến server backend...');
      final url = Uri.parse('$baseUrl/auth/login-google');
      final response = await client.post(
        Uri.parse('https://10.0.2.2:7026/api/auth/login-google?idToken=$idToken'),
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
      );


      print('9. Phản hồi từ server: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        print('10. Đăng nhập thành công');
        return jsonDecode(response.body);
      } else {
        print('11. LỖI từ server: ${response.statusCode}');
        throw Exception(
            localizedStrings['login_failed']?.replaceAll(
                '{statusCode}', response.statusCode.toString())?.replaceAll(
                '{message}', response.body) ?? 'Đăng nhập Google thất bại');
      }
    } catch (e, stackTrace) {
      print('12. LỖI TRONG QUÁ TRÌNH ĐĂNG NHẬP: $e');
      print('13. STACK TRACE: $stackTrace');
      throw Exception(
          localizedStrings['connection_error']?.replaceAll(
              '{error}', e.toString()) ?? 'Lỗi kết nối: $e');
    }
  }
}