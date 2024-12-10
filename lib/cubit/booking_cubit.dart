import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/service/booking_service.dart';
import 'package:futsal_booking_app/src/features/booking/data/booking_model.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingService bookingService;

  BookingCubit(this.bookingService) : super(BookingInitial());

  // Fetch all bookings for the logged-in user
  Future<void> fetchUserBookings() async {
    try {
      emit(BookingLoading());
      final bookings = await bookingService.getAllBookings();
      emit(BookingSuccess(bookings));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  // Fetch bookings for a specific futsal
  Future<void> fetchBookingsByFutsal(String futsalId) async {
    try {
      emit(BookingLoading());
      final bookings = await bookingService.getBookingById(futsalId);
      emit(BookingSuccess(bookings));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  // Add a new booking
  Future<void> addBooking({
    required String futsalId,
    required String packageType,
    required double amount,
    required String date,
  }) async {
    try {
      emit(BookingLoading());
      await bookingService.createBooking(
        futsalId: futsalId,
        packageType: packageType,
        amount: amount,
        date: date,
      );
      await fetchUserBookings(); // Refresh bookings after adding
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  // Update an existing booking
  Future<void> updateBooking({
    required String bookingId,
    String? futsalId,
    String? packageType,
    double? amount,
    String? date,
  }) async {
    try {
      emit(BookingLoading());
      await bookingService.updateBooking(
        bookingId: bookingId,
        futsalId: futsalId,
        packageType: packageType,
        amount: amount,
        date: date,
      );
      await fetchUserBookings(); // Refresh bookings after updating
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  // Delete a booking
  Future<void> deleteBooking(String bookingId) async {
    try {
      emit(BookingLoading());
      await bookingService.deleteBooking(bookingId);
      await fetchUserBookings(); // Refresh bookings after deleting
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }
}
