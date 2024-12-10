part of 'booking_cubit.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {
  final List<BookingModel> bookings;

  const BookingSuccess(this.bookings);

  @override
  List<Object?> get props => [bookings];
}

class BookingFailure extends BookingState {
  final String error;

  const BookingFailure(this.error);

  @override
  List<Object?> get props => [error];
}
