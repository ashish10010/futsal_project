import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:futsal_booking_app/src/features/auth/data/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl = 'http://192.168.1.68:3000';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> _saveToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> _deleteToken() async {
    await _storage.delete(key: 'token');
  }

  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    try {
      final res = await http.post(
        Uri.parse(
          '$baseUrl/auth/signup',
        ),
        headers: {
          'Content-type': 'application/json',
        },
        body: jsonEncode(
          {
            'name': name,
            'email': email,
            'password': password,
            'role': role,
          },
        ),
      );
      if (res.statusCode != 201) {
        throw jsonDecode(res.body)['message'];
      }
      return UserModel.fromJson(res.body);
    } catch (e) {
      throw e.toString();
    }
  }

  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');
    final response = await http.post(
      url,
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = json.decode(response.body);
      await _saveToken(data['token']); // Save token securely
      return UserModel.fromMap(data);
    } else {
      final errorMessage =
          jsonDecode(response.body)['message'] ?? 'Unknown error';
      throw Exception('Failed to log in: $errorMessage');
    }
  }

  Future<void> signOut() async {
    await _storage.delete(key: 'token');
  }
}
