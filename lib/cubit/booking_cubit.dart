
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/booking_service.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingService _bookingService;

  BookingCubit(this._bookingService) : super(BookingInitial());

  /// Fetch booked slots for the selected day using BookingService
  Future<void> fetchBookedSlots(DateTime selectedDay, String fieldId) async {
    try {
      emit(BookingLoading(selectedDay));

      // Fetch booked slots using BookingService
      final bookings = await _bookingService.getBookingsForDay(selectedDay, fieldId);

      List<String> slots = [];
      for (var booking in bookings) {
        final DateTime startTime = (booking['startTime'] as Timestamp).toDate();
        slots.add('${startTime.hour}:00 ${startTime.hour < 12 ? "AM" : "PM"} - ${startTime.hour + 1}:00 ${startTime.hour + 1 < 12 ? "AM" : "PM"}');
      }

      emit(BookingLoaded(selectedDay, slots));
    } catch (e) {
      emit(BookingError(selectedDay, e.toString()));
    }
  }

  /// Save a new booking using BookingService
  Future<void> bookSlot(String slotTime, DateTime selectedDay, int startHour, String fieldId, double price) async {
    try {
      DateTime startTime = DateTime(selectedDay.year, selectedDay.month, selectedDay.day, startHour);
      DateTime endTime = startTime.add(const Duration(hours: 1));

      // Call BookingService to add booking
      await _bookingService.addBooking(
        fieldId: fieldId,
        userId: 'user123', // Replace with actual user ID from authentication
        date: selectedDay,
        startTime: startTime,
        endTime: endTime,
        price: price,
      );

      // Update the slots list
      List<String> updatedSlots = List<String>.from((state as BookingLoaded).bookedSlots);
      updatedSlots.add(slotTime);

      emit(BookingLoaded(selectedDay, updatedSlots));
    } catch (e) {
      emit(BookingError(selectedDay, 'Failed to book slot: $e'));
    }
  }

  void updateSelectedDay(DateTime selectedDay) {
    emit(BookingSelectedDay(selectedDay));
  }
}
