import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/service/booking_service.dart';
import 'package:futsal_booking_app/src/features/booking/data/booking_model.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingService bookingService;

  BookingCubit(this.bookingService) : super(BookingInitial());

  /// Fetch all bookings for the current user
  Future<void> fetchUserBookings() async {
    print('FETCH BOOKING IS WORKING:::::::::::::::::::::');
    print('FETCH BOOKING IS WORKING:::::::::::::::::::::');
    print('FETCH BOOKING IS WORKING:::::::::::::::::::::');

    try {
      emit(BookingLoading());
      final bookings = await bookingService.getAllBookings();
      emit(BookingSuccess(bookings));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  /// Fetch all bookings for a specific futsal field (e.g., for owners)
  Future<void> fetchBookingsByFutsal(String futsalId) async {

         print('Fetch  BOOKING  By FutsalID IS WORKING:::::::::::::::::::::');

    try {
      emit(BookingLoading());
      final bookings = await bookingService.getAllBookings(futsalId: futsalId);
      emit(BookingSuccess(bookings));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  /// Add a new booking
  Future<void> addBooking({
    required String futsalId,
    required String packageType,
    required String amount,
    required String date,
  }) async {

         print('Add BOOKING IS WORKING:::::::::::::::::::::');

    try {
      emit(BookingLoading());
      await bookingService.addBooking(
        futsalId: futsalId,
        packageType: packageType,
        amount: amount,
        date: date,
      );
      // Refresh bookings after adding
      await fetchBookingsByFutsal(futsalId);
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  /// Update an existing booking
  Future<void> updateBooking({
    required String bookingId,
    String? futsalId,
    String? packageType,
    String? amount,
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
      emit(const BookingUpdateSuccess("Booking Added Successfully!"));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  /// Delete a booking
  Future<void> deleteBooking(String bookingId) async {

     print('Delete BOOKING IS WORKING:::::::::::::::::::::');

    try {
      emit(BookingLoading());
      await bookingService.deleteBooking(bookingId);
      await fetchUserBookings(); // Refresh bookings after deleting
      emit(const BookingDeleteSuccess('Booking Deleted Succcessfully!'));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }
}
