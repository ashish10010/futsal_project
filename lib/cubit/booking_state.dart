part of 'booking_cubit.dart';

abstract class BookingState extends Equatable {
  final DateTime selectedDay;

  const BookingState(this.selectedDay);

  @override
  List<Object> get props => [selectedDay];
}

class BookingInitial extends BookingState {
  BookingInitial() : super(DateTime.now());
}

class BookingLoading extends BookingState {
  BookingLoading(DateTime selectedDay) : super(selectedDay);
}

class BookingLoaded extends BookingState {
  final List<String> bookedSlots;

  const BookingLoaded(DateTime selectedDay, this.bookedSlots) : super(selectedDay);

  @override
  List<Object> get props => [selectedDay, bookedSlots];
}

class BookingSelectedDay extends BookingState {
  BookingSelectedDay(DateTime selectedDay) : super(selectedDay);
}

class BookingError extends BookingState {
  final String error;

  BookingError(DateTime selectedDay, this.error) : super(selectedDay);

  @override
  List<Object> get props => [selectedDay, error];
}
