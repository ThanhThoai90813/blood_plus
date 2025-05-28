import 'dart:convert';
import 'dart:io';
import 'package:blood_plus/data/manager/user_manager.dart';
import 'package:blood_plus/data/models/blog_model.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import '../repositories/blog_response.dart';

class BlogService {
  static final HttpClient _httpClient = HttpClient()
    ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  static final client = IOClient(_httpClient);
  static const String baseUrl = 'https://10.0.2.2:7026/api';
  final UserManager _userManager = UserManager();

  Future<BlogResponse> getBlogs({
    String? title,
    String? content,
    int pageNumber = 1,
    int pageSize = 5,
  }) async {
    final queryParameters = {
      if (title != null) 'title': title,
      if (content != null) 'content': content,
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
    };

    final url = Uri.parse('$baseUrl/blog').replace(queryParameters: queryParameters);
    final token = await _userManager.getUserToken() ?? '';

    try {
      final response = await client.get(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // print('Response body: ${response.body}');
        return BlogResponse.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Lấy danh sách blog thất bại: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối: $e');
    }
  }

  Future<BlogModel> getBlogById(String id) async {
    final url = Uri.parse('$baseUrl/blog/$id');
    final token = await _userManager.getUserToken() ?? '';

    try {
      final response = await client.get(
        url,
        headers: {
          'accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        // print('Response body for blog by ID: ${response.body}');
        final jsonResponse = jsonDecode(response.body);
        final message = jsonResponse['message'] as Map<String, dynamic>? ?? {};
        return BlogModel.fromJson(message); // Parse từ 'message'
      } else {
        throw Exception('Lấy thông tin blog thất bại: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Lỗi kết nối khi lấy blog theo ID: $e');
    }
  }

}