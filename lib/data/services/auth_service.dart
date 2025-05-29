import 'dart:convert';
import 'dart:io';

import 'package:blood_plus/data/manager/user_manager.dart';
import 'package:blood_plus/data/services/user_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

class AuthService {
  static final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  static final client = IOClient(_httpClient);
  static const String baseUrl = 'https://10.0.2.2:7026/api';
  final UserService _userService = UserService();
  final UserManager _userManager = UserManager();

  Future<Map<String, dynamic>> login(
      String username, String password, Map<String, String> localizedStrings) async {

    final url = Uri.parse('$baseUrl/auth/auth-account');
    final body = jsonEncode({'username': username, 'password': password});

    try {
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
        body: body,
      );

      print('Login response status: ${response.statusCode}');
      print('Login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['accessToken']?.toString();

        if (token == null) {
          throw Exception('Dữ liệu trả về từ API không hợp lệ: Thiếu token');
        }

        final userId = _extractUserIdFromToken(token) ?? data['id']?.toString();
        if (userId == null) {
          throw Exception('Không thể lấy userId từ token hoặc dữ liệu API');
        }

        await _userManager.saveUserToken(token);
        await _userManager.saveUserId(userId);
        final user = await _userService.getUserInfo(userId, token);
        await _userManager.saveUserInfo(userId, user);
        print('Login successful: $userId, User: ${user.toJson()}');
        return {
          'accessToken': token,
          'userId': userId,
        };
      } else {
        throw Exception(
          localizedStrings['login_failed']
              ?.replaceAll('{statusCode}', response.statusCode.toString())
              ?.replaceAll('{message}', response.body) ??
              'Đăng nhập thất bại',
        );
      }
    } catch (e) {
      throw Exception(
        localizedStrings['connection_error']?.replaceAll('{error}', e.toString()) ??
            'Lỗi kết nối: $e',
      );
    }
  }

  Future<Map<String, dynamic>> loginWithGoogle(Map<String, String> localizedStrings) async {
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'profile'],
      serverClientId:
      '229734390839-3n21tokpf4sg0l6v7kur91dk78djvr9p.apps.googleusercontent.com',
    );

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        return {'error': 'Đăng nhập Google bị hủy'};
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        throw Exception('Không thể lấy idToken');
      }

      final url = Uri.parse('$baseUrl/auth/login-google?idToken=$idToken');
      final response = await client.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'accept': '*/*',
        },
      );

      print('Google login response status: ${response.statusCode}');
      print('Google login response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['accessToken']?.toString();

        if (token == null) {
          throw Exception('Dữ liệu trả về từ API không hợp lệ: Thiếu token');
        }

        final userId = _extractUserIdFromToken(token) ?? data['id']?.toString();
        if (userId == null) {
          throw Exception('Không thể lấy userId từ token hoặc dữ liệu API');
        }

        await _userManager.saveUserToken(token);
        await _userManager.saveUserId(userId);
        final user = await _userService.getUserInfo(userId, token);
        await _userManager.saveUserInfo(userId, user);
        print('Google login successful: $userId, User: ${user.toJson()}');
        return {
          'accessToken': token,
          'userId': userId,
        };
      } else {
        throw Exception(
          localizedStrings['login_failed']
              ?.replaceAll('{statusCode}', response.statusCode.toString())
              ?.replaceAll('{message}', response.body) ??
              'Đăng nhập Google thất bại',
        );
      }
    } catch (e) {
      throw Exception(
        localizedStrings['connection_error']?.replaceAll('{error}', e.toString()) ??
            'Lỗi kết nối: $e',
      );
    }
  }

  String? _extractUserIdFromToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) {
        print('Invalid token format');
        return null;
      }

      final payload = parts[1];
      final normalizedPayload =
      payload.padRight(payload.length + (4 - payload.length % 4) % 4, '=');
      final decodedPayload = utf8.decode(base64Url.decode(normalizedPayload));
      final payloadMap = jsonDecode(decodedPayload) as Map<String, dynamic>;

      final userId = payloadMap['userId']?.toString();
      print('Extracted userId from token: $userId');
      return userId;
    } catch (e) {
      print('Error decoding token: $e');
      return null;
    }
  }
}