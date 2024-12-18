import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/cubit/booking_cubit.dart';
import 'package:futsal_booking_app/src/core/constants/constants.dart';
import 'package:futsal_booking_app/src/features/booking/data/booking_model.dart';
import 'package:futsal_booking_app/src/features/futsal/data/models/field_model.dart';
import 'package:table_calendar/table_calendar.dart';

class ScheduleSlotsPage extends StatefulWidget {
  final FieldModel field;

  const ScheduleSlotsPage({
    super.key,
    required this.field,
  });

  @override
  State<ScheduleSlotsPage> createState() => _ScheduleSlotsPageState();
}

class _ScheduleSlotsPageState extends State<ScheduleSlotsPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  final List<DateTime> _timeSlots = [];

  /// Generates hourly slots (6 AM - 7 PM) for the selected day
  List<DateTime> pickSlots(DateTime baseDate) {
    _timeSlots.clear();
    const int startHour = 6; // Start at 6 AM
    const int endHour = 19; // End at 7 PM

    for (int hour = startHour; hour <= endHour; hour++) {
      final slot = DateTime(baseDate.year, baseDate.month, baseDate.day, hour);
      _timeSlots.add(slot);
    }
    return _timeSlots;
  }

  @override
  void initState() {
    super.initState();
    pickSlots(DateTime.now());
    context.read<BookingCubit>().fetchBookingsByFutsal(widget.field.id);
  }

  /// Checks if a specific time slot is booked
  bool isSlotOccupied({
    required DateTime slot,
    required List<BookingModel> occupiedSlots,
  }) {
    for (var occupied in occupiedSlots) {
      final occupiedDateTime = DateTime.parse(occupied.date);
      if (occupied.packageType.toLowerCase() == 'hourly' &&
          slot.day == occupiedDateTime.day &&
          slot.hour == occupiedDateTime.hour) {
        return true;
      } else if (occupied.packageType.toLowerCase() == 'monthly' &&
          slot.month == occupiedDateTime.month &&
          slot.hour == occupiedDateTime.hour) {
        return true;
      }
    }
    return false;
  }

  void _navigateToBookingDetails(
    BuildContext context,
    DateTime slotTime,
    String packageType,
  ) async {
    List<DateTime> monthlySlots = [];

    if (packageType.toLowerCase() == 'monthly') {
      final int selectedHour = slotTime.hour;
      final startDay = _selectedDay;
      final lastDayOfMonth = DateTime(startDay.year, startDay.month + 1, 0);

      for (int day = startDay.day; day <= lastDayOfMonth.day; day++) {
        monthlySlots
            .add(DateTime(startDay.year, startDay.month, day, selectedHour));
      }
    }
    final combinedDateTime = DateTime(
      _selectedDay.year,
      _selectedDay.month,
      _selectedDay.day,
      slotTime.hour,
    );

    final result = await Navigator.pushNamed(
      context,
      '/bookingdetails',
      arguments: {
        'futsalId': widget.field.id,
        'futsalName': widget.field.name,
        'futsalImageUrl': widget.field.cardImg,
        'fieldType': widget.field.courtSize,
        'price': packageType.toLowerCase() == 'hourly'
            ? widget.field.hourlyPrice
            : widget.field.monthlyPrice,
        'date': combinedDateTime.toString(),
        'time': slotTime.hour,
        'packageType': packageType,
      },
    );

    if (result == true) {
      context.read<BookingCubit>().fetchBookingsByFutsal(widget.field.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
        backgroundColor: Palette.primaryGreen,
        centerTitle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
        title: const Text(
          "Schedule Slots",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 1,
          ),
        ),
      ),
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is BookingSuccess) {
            final bookings = state.bookings;

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Calendar Widget
                  TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime.now().add(const Duration(days: 365)),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                        pickSlots(selectedDay);
                      });
                    },
                    onFormatChanged: (format) {
                      setState(() {
                        _calendarFormat = format;
                      });
                    },
                    calendarStyle: CalendarStyle(
                      selectedDecoration: const BoxDecoration(
                        color: Palette.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Palette.lightGreen.withOpacity(0.7),
                        shape: BoxShape.circle,
                      ),
                      defaultTextStyle: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                      disabledTextStyle: const TextStyle(
                        color: Colors.grey,
                      ),
                      outsideDaysVisible: false,
                    ),
                    headerStyle: const HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                      leftChevronIcon:
                          Icon(Icons.chevron_left, color: Colors.black),
                      rightChevronIcon:
                          Icon(Icons.chevron_right, color: Colors.black),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Slots List
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _timeSlots.length,
                    itemBuilder: (context, index) {
                      final slotTime = _timeSlots[index];
                      final isBooked = isSlotOccupied(
                        occupiedSlots: bookings,
                        slot: slotTime,
                      );

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '${_formatTime(slotTime.hour)} - ${_formatTime(slotTime.hour + 1)}',
                                style: subtitleTextStyle.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                isBooked ? 'Already Booked' : 'Available',
                                style: bodyTextStyle.copyWith(
                                  color: isBooked
                                      ? Palette.error
                                      : Palette.primaryGreen,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: isBooked
                                        ? null
                                        : () => _navigateToBookingDetails(
                                              context,
                                              slotTime,
                                              'Hourly',
                                            ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isBooked
                                          ? Colors.grey
                                          : Palette.primaryGreen,
                                    ),
                                    child: const Text(
                                      'Book Hourly',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: isBooked
                                        ? null
                                        : () => _navigateToBookingDetails(
                                              context,
                                              slotTime,
                                              'Monthly',
                                            ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isBooked
                                          ? Colors.grey
                                          : Palette.primaryGreen,
                                    ),
                                    child: const Text(
                                      'Book Monthly',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else if (state is BookingFailure) {
            return Center(child: Text('Error: ${state.error}'));
          } else {
            return const Center(child: Text('No bookings available.'));
          }
        },
      ),
    );
  }

  static String _formatTime(int hour) {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    final period = hour < 12 ? 'AM' : 'PM';
    return '$h $period';
  }
}
