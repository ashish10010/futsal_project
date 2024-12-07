import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BookingModel extends Equatable {
  final String id;                  // Document ID for the booking
  final String fieldId;             // String ID representing the futsal field
  final String userId;              // String ID representing the user
  final DateTime date;              // Date of booking (update to use Timestamp in Firestore)
  final DateTime startTime;         // Start time of booking
  final DateTime endTime;           // End time of booking
  final String status;              // Booking status (pending, confirmed, cancelled)
  final double price;               // Total price for the booking
  final DateTime createdAt;         // Booking creation timestamp
  final DateTime updatedAt;         // Last update timestamp
  final bool? isConflict;           // Indicates conflict during booking (optional)

  const BookingModel({
    required this.id,
    required this.fieldId,
    required this.userId,
    required this.date,
    required this.startTime,
    required this.endTime,
    this.status = 'pending',
    required this.price,
    required this.createdAt,
    required this.updatedAt,
    this.isConflict,
  });

  /// Factory method to create BookingModel from Firestore document data
  factory BookingModel.fromJson(String id, Map<String, dynamic> json) {
    return BookingModel(
      id: id,
      fieldId: json['fieldId'] ?? '',
      userId: json['userId'] ?? '',
      date: (json['date'] is Timestamp) ? (json['date'] as Timestamp).toDate() : DateTime.now(),
      startTime: (json['startTime'] as Timestamp).toDate(),
      endTime: (json['endTime'] as Timestamp).toDate(),
      status: json['status'] ?? 'pending',
      price: (json['price'] ?? 0).toDouble(),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
      isConflict: json['isConflict'] ?? false,
    );
  }

  /// Convert BookingModel to a Map for Firestore
  Map<String, dynamic> toJson() {
    return {
      'fieldId': fieldId,
      'userId': userId,
      'date': Timestamp.fromDate(date),
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'status': status,
      'price': price,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isConflict': isConflict,
    };
  }

  @override
  List<Object?> get props => [
        id,
        fieldId,
        userId,
        date,
        startTime,
        endTime,
        status,
        price,
        createdAt,
        updatedAt,
        isConflict,
      ];
}
