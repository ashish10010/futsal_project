part of 'booking_cubit.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

// Initial State
class BookingInitial extends BookingState {}

// Loading State
class BookingLoading extends BookingState {}

// Success State for fetching bookings
class BookingSuccess extends BookingState {
  final List<BookingModel> bookings;

  const BookingSuccess(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

// Success State for adding a booking
class BookingAddSuccess extends BookingState {
  final String message;
  // e.g., "Booking added successfully!"

  const BookingAddSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Success State for updating a booking
class BookingUpdateSuccess extends BookingState {
  final String message;
  // e.g., "Booking updated successfully!"

  const BookingUpdateSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Success State for deleting a booking
class BookingDeleteSuccess extends BookingState {
  final String message;
  // e.g., "Booking deleted successfully!"

  const BookingDeleteSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

// Failure State
class BookingFailure extends BookingState {
  final String error;

  const BookingFailure(this.error);

  @override
  List<Object?> get props => [error];
}
