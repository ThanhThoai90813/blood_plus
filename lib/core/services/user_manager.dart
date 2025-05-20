import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static const String _tokenKey = 'auth_token';

  // Lưu token khi đăng nhập
  Future<void> saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Lấy token
  Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Xóa thông tin người dùng khi đăng xuất
  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }
}