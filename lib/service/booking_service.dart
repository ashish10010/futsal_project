import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../src/core/constants/string.dart';
import '../src/features/booking/data/booking_model.dart';

class BookingService {
 
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  // Retrieve the token
  Future<String?> _getToken() async {
    return await _storage.read(key: 'token');
  }

  // Retrieve the userId
  Future<String?> _getUserId() async {
    return await _storage.read(key: 'userId');
  }

  // Create a new booking
  Future<BookingModel> createBooking({
    required String futsalId,
    required String packageType,
    required double amount,
    required String date,
  }) async {
    final token = await _getToken();
    final userId = await _getUserId();
    if (token == null || userId == null) {
      throw Exception('User is not authenticated or userId missing.');
    }

    final response = await http.post(
      Uri.parse('${AppString.baseUrl}/booking/add-booking'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'futsalId': futsalId,
        'packageType': packageType,
        'amount': amount,
        'date': date,
        'userId': userId, // Pass userId
      }),
    );

    if (response.statusCode == 201) {
      return BookingModel.fromJson(response.body);
    } else {
      throw Exception('Failed to create booking: ${response.body}');
    }
  }

  // Get all bookings for the authenticated user
  Future<List<BookingModel>> getAllBookings() async {
    final token = await _getToken();
    final userId = await _getUserId();
    if (token == null || userId == null) {
      throw Exception('User is not authenticated or userId missing.');
    }

    final response = await http.get(
      Uri.parse('${AppString.baseUrl}/booking/user/$userId'), 
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> bookings = jsonDecode(response.body);
      return bookings.map((booking) => BookingModel.fromMap(booking)).toList();
    } else {
      throw Exception('Failed to fetch bookings: ${response.body}');
    }
  }

  // Get booking by ID
  Future<List<BookingModel>> getBookingById(String bookingId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('User is not authenticated.');
    }

    final response = await http.get(
      Uri.parse('${AppString.baseUrl}/booking/search/$bookingId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => BookingModel.fromMap(json)).toList();
    } else {
      throw Exception('Failed to fetch booking: ${response.body}');
    }
  }

  // Update booking by ID
  Future<void> updateBooking({
    required String bookingId,
    String? futsalId,
    String? packageType,
    double? amount,
    String? date,
  }) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('User is not authenticated.');
    }

    final response = await http.put(
      Uri.parse('${AppString.baseUrl}/booking/update-booking/$bookingId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        if (futsalId != null) 'futsalId': futsalId,
        if (packageType != null) 'packageType': packageType,
        if (amount != null) 'amount': amount.toString(),
        if (date != null) 'date': date,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update booking: ${response.body}');
    }
  }

  // Delete booking by ID
  Future<void> deleteBooking(String bookingId) async {
    final token = await _getToken();
    if (token == null) {
      throw Exception('User is not authenticated.');
    }

    final response = await http.delete(
      Uri.parse('${AppString.baseUrl}/booking/delete-booking/$bookingId'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete booking: ${response.body}');
    }
  }
}
