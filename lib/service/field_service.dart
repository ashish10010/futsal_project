import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../src/core/constants/string.dart';
import '../src/features/futsal/data/models/field_model.dart';

class FieldService {

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Retrieve the token
  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  // Retrieve the userId from storage
  Future<String?> _getUserId() async {
    return await _storage.read(key: 'userId'); // Ensure `userId` is saved during login
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

  // Add a new futsal field (For Admin/Owner)
  Future<void> addFutsal(FieldModel field) async {
    final token = await _getToken();
    final userId = await _getUserId(); // Fetch the userId for the owner
    if (token == null || userId == null) {
      throw Exception('User not authenticated or userId missing.');
    }

    final url = Uri.parse('${AppString.baseUrl}/futsal/add-futsal');
    final response = await http.post(
      url,
      body: json.encode({...field.toMap(), 'userId': userId}),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add futsal: ${response.body}');
    }
  }

  // Update a futsal field by ID
  Future<void> updateFutsalById(String futsalId, FieldModel updatedField) async {
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
