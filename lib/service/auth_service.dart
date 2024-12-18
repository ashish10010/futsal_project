import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:futsal_booking_app/src/core/constants/string.dart';
import 'package:futsal_booking_app/src/features/auth/data/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> _saveTokenAndUserId(String token, String userId) async {
    await _storage.write(key: 'token', value: token);
    await _storage.write(key: 'userId', value: userId);
  }

  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<String?> _getUserId() async {
    return await _storage.read(key: 'userId');
  }

  Future<void> _deleteTokenAndUserId() async {
    await _storage.delete(key: 'token');
    // await _storage.delete(key: 'userId');
  }

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final res = await http.post(
        Uri.parse('${AppString.baseUrl}/auth/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'role': role,
        }),
      );

      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['message'];
      }

      final data = jsonDecode(res.body);
      await _saveTokenAndUserId(data['token'], data['id']); 

      return UserModel.fromMap(data);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('${AppString.baseUrl}/auth/login');
    final response = await http.post(
      url,
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      await _saveTokenAndUserId(data['token'], data['id']); 
      return UserModel.fromMap(data);
    } else {
      final errorMessage =
          jsonDecode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Failed to log in: $errorMessage');
    }
  }

  Future<void> signOut() async {
    await _deleteTokenAndUserId();
  }

  Future<String?> getToken() => _getToken();
   Future<String?> getUserId() => _getUserId();
}
