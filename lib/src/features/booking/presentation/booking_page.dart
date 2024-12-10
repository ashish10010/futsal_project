import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/src/core/constants/constants.dart';
import 'package:futsal_booking_app/src/features/futsal/data/models/field_model.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../../../cubit/booking_cubit.dart';
import '../data/booking_model.dart';

class ScheduleSlotsPage extends StatefulWidget {
  final FieldModel field; // Pass the selected futsal field

  const ScheduleSlotsPage({
    super.key,
    required this.field,
  });

  @override
  State<ScheduleSlotsPage> createState() => _ScheduleSlotsPageState();
}

class _ScheduleSlotsPageState extends State<ScheduleSlotsPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _selectedDay = DateTime.now();

  final List<String> _timeSlots = List.generate(
    14,
    (index) {
      final startHour = 6 + index;
      final endHour = startHour + 1;
      return '${_formatTime(startHour)} - ${_formatTime(endHour)}';
    },
  ); // Generates slots from 6 AM to 8 PM

  @override
  void initState() {
    super.initState();
    // Fetch bookings for the given futsalId
    context.read<BookingCubit>().fetchBookingsByFutsal(widget.field.id);
  }

  List<BookingModel> _getBookingsForDay(
      List<BookingModel> bookings, DateTime day) {
    final dayKey = DateTime(day.year, day.month, day.day);
    return bookings.where((booking) {
      final bookingDate = booking.date;
      return bookingDate.year == dayKey.year &&
          bookingDate.month == dayKey.month &&
          bookingDate.day == dayKey.day;
    }).toList();
  }

  void _navigateToBookingDetails(
    BuildContext context,
    String slotTime,
    String packageType,
  ) {
    Navigator.pushNamed(
      context,
      '/bookingdetails',
      arguments: {
        'futsalName': widget.field.name,
        'futsalImageUrl': widget.field.cardImg, 
        'fieldType': widget.field.courtSize,
        'price': packageType == 'Hourly'
            ? widget.field.hourlyPrice
            : widget.field.monthlyPrice,
        'date': _selectedDay.toIso8601String(),
        'time': slotTime,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Schedule Slots",
          style: whiteTextStyle.copyWith(
              fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Palette.primaryGreen,
        centerTitle: true,
        elevation: 0,
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
                  // Calendar
                  TableCalendar(
                    firstDay: DateTime.now().subtract(const Duration(days: 30)),
                    lastDay: DateTime.now().add(const Duration(days: 30)),
                    focusedDay: _selectedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
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
                        color: Palette.lightGreen.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      outsideDaysVisible: false,
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      titleTextStyle: headlineTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Slots List
                  ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _timeSlots.length, // 14 slots (6 AM to 8 PM)
                    itemBuilder: (context, index) {
                      final slotTime = _timeSlots[index];
                      final isBooked = _getBookingsForDay(
                              bookings, _selectedDay)
                          .any((booking) => booking.packageType == slotTime);

                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: ListTile(
                          title: Text(
                            slotTime,
                            style: subtitleTextStyle.copyWith(
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text(
                            isBooked ? 'Booked' : 'Available',
                            style: bodyTextStyle.copyWith(
                              color: isBooked
                                  ? Palette.error
                                  : Palette.primaryGreen,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
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
                                      ? Palette.error
                                      : Palette.primaryGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                ),
                                child: const Text(
                                  'Book',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 8),
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
                                      ? Palette.error
                                      : Palette.primaryGreen,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8,
                                    horizontal: 12,
                                  ),
                                ),
                                child: const Text(
                                  'Book Monthly',
                                  style: TextStyle(color: Colors.white),
                                ),
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
