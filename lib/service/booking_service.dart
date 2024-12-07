import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch bookings for a given field and date from Firestore
  Future<List<Map<String, dynamic>>> getBookingsForDay(DateTime selectedDay, String fieldId) async {
    try {
      final snapshot = await _firestore
          .collection('bookings')
          .where('fieldId', isEqualTo: fieldId)
          .where('date', isEqualTo: Timestamp.fromDate(DateTime(selectedDay.year, selectedDay.month, selectedDay.day)))
          .get();

      List<Map<String, dynamic>> bookings = snapshot.docs.map((doc) => doc.data()).toList();
      return bookings;
    } catch (e) {
      throw Exception('Error fetching bookings: $e');
    }
  }

  /// Add a new booking to Firestore
  Future<void> addBooking({
    required String fieldId,
    required String userId,
    required DateTime date,
    required DateTime startTime,
    required DateTime endTime,
    required double price,
  }) async {
    try {
      final newBooking = {
        'fieldId': fieldId,
        'userId': userId,
        'date': Timestamp.fromDate(date),
        'startTime': Timestamp.fromDate(startTime),
        'endTime': Timestamp.fromDate(endTime),
        'status': 'confirmed',
        'price': price,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
        'isConflict': false,
      };

      await _firestore.collection('bookings').add(newBooking);
    } catch (e) {
      throw Exception('Error adding booking: $e');
    }
  }
}
