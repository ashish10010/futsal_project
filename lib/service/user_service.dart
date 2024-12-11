import 'dart:convert';
import 'package:futsal_booking_app/service/auth_service.dart';
import 'package:futsal_booking_app/src/features/auth/data/model/user_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../src/core/constants/string.dart';

class UserService {
  
  /// Retrieve the current user's details
  Future<UserModel> fetchCurrentUser() async {
    final token = await _getToken();
    final url = Uri.parse('${AppString.baseUrl}/auth/me');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromMap(data);
    } else {
      throw Exception('Failed to fetch current user: ${response.body}');
    }
  }

  /// Retrieve a user by ID
  Future<UserModel> fetchUserById(String userId) async {
    final token = await _getToken();
    final userId = await AuthService().getUserId();
    if (userId == null) {
      throw Exception('User ID not found');
    }
    final url = Uri.parse('${AppString.baseUrl}/users/$userId');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromMap(data);
    } else {
      throw Exception('Failed to fetch user by ID: ${response.body}');
    }
  }

  /// Update the current user's details
  Future<UserModel> updateCurrentUser(Map<String, dynamic> updatedData) async {
    final token = await _getToken();
    final url =
        Uri.parse('${AppString.baseUrl}/auth/update'); 

    final response = await http.put(
      url,
      body: json.encode(updatedData),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return UserModel.fromMap(data);
    } else {
      throw Exception('Failed to update user: ${response.body}');
    }
  }

  /// Save a new user (Admin feature)
  Future<void> saveUser(UserModel user) async {
    final token = await _getToken();
    final url =
        Uri.parse('${AppString.baseUrl}/users/create'); // Adjusted to an admin endpoint

    final response = await http.post(
      url,
      body: json.encode(user.toMap()),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to save user: ${response.body}');
    }
  }

  /// Helper: Get token from SharedPreferences
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) {
      throw Exception('No token found. User not authenticated.');
    }
    return token;
  }
}
