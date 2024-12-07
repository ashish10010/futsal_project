import 'dart:convert';
import 'package:http/http.dart' as http;
import '../src/features/auth/data/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final String baseUrl =
      'http://192.168.1.69:3000'; // Replace with your API base URL

  /// Sign in with email and password
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

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']); // Save JWT token
      return UserModel.fromMap(data);
    } else {
      throw Exception('Failed to log in: ${response.body}');
    }
  }

  /// Sign up a new user
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
    required String role,
  }) async {
    final url = Uri.parse('$baseUrl/auth/signup');
    final response = await http.post(
      url,
      body: json.encode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      final data = json.decode(response.body);
      return UserModel.fromMap(data);
    } else {
      throw Exception('Failed to sign up: ${response.body}');
    }
  }

  /// Sign out the current user
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Clear the stored token
  }

  Future<bool> isTokenValid() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return false;

    final url = Uri.parse('$baseUrl/auth/validate');
    final response = await http.post(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }
}
