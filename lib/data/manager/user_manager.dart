import 'dart:convert';
import 'package:blood_plus/data/models/user_model.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserManager {
  static const String _tokenKey = 'auth_token';
  static const String _userIdKey = 'user_id';
  static const String _userInfoKey = 'user_info';

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
    serverClientId:
    '229734390839-3n21tokpf4sg0l6v7kur91dk78djvr9p.apps.googleusercontent.com',
  );

  Future<void> saveUserToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.setString(_tokenKey, token);
    print('Saved token: $result');
  }

  Future<String?> getUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    print('Retrieved token: $token');
    return token;
  }

  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final result = await prefs.setString(_userIdKey, userId);
    print('Saved userId: $userId, result: $result');
  }

  Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString(_userIdKey);
    print('Retrieved userId: $userId');
    return userId;
  }

  Future<void> saveUserInfo(String userId, UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    final result = await prefs.setString('$_userInfoKey$userId', userJson);
    print('Saved user info for $userId: $result, JSON: $userJson');
  }

  Future<UserModel?> getUserInfo(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('$_userInfoKey$userId');
    print('Retrieved user JSON for $userId: $userJson');
    if (userJson != null) {
      try {
        return UserModel.fromJson(jsonDecode(userJson));
      } catch (e) {
        print('Error parsing user JSON: $e');
      }
    }
    return null;
  }

  Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = await getUserId();
    if (userId != null) {
      await prefs.remove('$_userInfoKey$userId');
      print('Cleared user info for $userId');
    }
    await prefs.remove(_tokenKey);
    await prefs.remove(_userIdKey);
    await _googleSignIn.signOut();
    print('Cleared all user data');
  }
}