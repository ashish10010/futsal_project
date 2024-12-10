import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../service/booking_service.dart';
import '../src/features/booking/data/booking_model.dart';

part 'booking_state.dart';

class BookingCubit extends Cubit<BookingState> {
  final BookingService bookingService;

  BookingCubit(this.bookingService) : super(BookingInitial());

  /// Fetch all bookings
  Future<void> fetchBookings() async {
    try {
      emit(BookingLoading());
      final bookings = await bookingService.getAllBookings();
      emit(BookingSuccess(bookings));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  /// Fetch bookings by futsal ID
  Future<void> fetchBookingsByFutsal(String futsalId) async {
    try {
      emit(BookingLoading());
      final bookings = await bookingService.getBookingById(futsalId);
      emit(BookingSuccess(bookings));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }

  /// Add a new booking
  Future<void> addBooking({
    required String futsalId,
    required String packageType,
    required double amount,
    required String date,
  }) async {
    try {
      emit(BookingLoading());
      final newBooking = await bookingService.createBooking(
        futsalId: futsalId,
        packageType: packageType,
        amount: amount,
        date: date,
      );
      emit(AddBookingSuccess(newBooking));
    } catch (e) {
      emit(BookingFailure(e.toString()));
    }
  }
}
