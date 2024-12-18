import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';

import '../src/core/constants/string.dart';
import '../src/features/futsal/data/models/field_model.dart';

final client = http.Client();

class FieldService {
  final Logger _logger = Logger();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'userId');
  }

  // Fetch all futsal fields
  Future<List<FieldModel>> fetchAllFields() async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found. User not authenticated.');
    }

    final url = Uri.parse('${AppString.baseUrl}/futsal/all-futsal');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      return data.map((field) => FieldModel.fromMap(field)).toList();
    } else {
      throw Exception('Failed to fetch futsal fields: ${response.body}');
    }
  }

  // Fetch a single futsal field by ID
  Future<FieldModel> getFutsalById(String futsalId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found. User not authenticated.');
    }

    final url = Uri.parse('${AppString.baseUrl}/futsal/$futsalId');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return FieldModel.fromMap(data);
    } else {
      throw Exception('Failed to fetch futsal field: ${response.body}');
    }
  }

  // Add a new futsal field (For Owner)
  Future<void> addFutsal({
    required String name,
    required String email,
    required String location,
    required String hourlyPrice,
    required String monthlyPrice,
    required String contact,
    required String courtSize,
    required String userId,
    required String cardImg,
    required String img1,
    required String img2,
  }) async {
    final token = await _getToken();
    _logger.d("Starting addFutsal request...");

    final url = Uri.parse('${AppString.baseUrl}/futsal/add-futsal');

    final body = jsonEncode({
      "name": name,
      "email": email,
      "location": location,
      "hourlyPrice": hourlyPrice,
      "monthlyPrice": monthlyPrice,
      "contact": contact,
      "courtSize": courtSize,
      "userId": userId,
      "cardImg": cardImg,
      "img1": img1,
      "img2": img2,
    });

    _logger.i("Request Body: $body");

    final response = await client.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    _logger.d("Response Status: ${response.statusCode}");
    _logger.d("Response Body: ${response.body}");

    if (response.statusCode != 201) {
      throw Exception('Failed to add futsal: ${response.body}');
    }

    _logger.i("Futsal successfully added!");
  }

  // Update a futsal field by ID
  Future<void> updateFutsalById(
      String futsalId, FieldModel updatedField) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found. User not authenticated.');
    }

    final url = Uri.parse('${AppString.baseUrl}/futsal/$futsalId');
    final response = await http.put(
      url,
      body: json.encode(updatedField.toMap()),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update futsal field: ${response.body}');
    }
  }

  // Delete a futsal field by ID
  Future<void> deleteFutsal(String futsalId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('No token found. User not authenticated.');
    }

    final url = Uri.parse('${AppString.baseUrl}/futsal/$futsalId');
    final response = await http.delete(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete futsal: ${response.body}');
    }
  }
}
