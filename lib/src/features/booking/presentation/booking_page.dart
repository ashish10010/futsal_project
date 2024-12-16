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
  DateTime _selectedDay = DateTime.now();
  final List<DateTime> _timeSlots = [];

  List<DateTime> pickSlots(DateTime baseDate) {
    _timeSlots.clear();
    const int startHour = 6; // Start at 6 AM
    const int endHour = 19; // End at 7 PM

    for (int hour = startHour; hour <= endHour; hour++) {
      final slot = DateTime(baseDate.year, baseDate.month, baseDate.day, hour);
      _timeSlots.add(slot);
      print('Generated Slot: $slot'); // Debugging
    }

    return _timeSlots;
  }

  @override
  void initState() {
    super.initState();
    pickSlots(DateTime.now());
    context.read<BookingCubit>().fetchBookingsByFutsal(widget.field.id);
  }

   bool isSlotOccupied(
      {required DateTime slot, required List<BookingModel> occupiedSlots}) {
    for (var occupied in occupiedSlots) {
      if (occupied.packageType.toLowerCase() == 'hourly' &&
          slot.day == DateTime.parse(occupied.date).day &&
          slot.hour == DateTime.parse(occupied.date).hour) {
        return true;
      } else if (occupied.packageType.toLowerCase() == 'monthly' &&
          slot.month == DateTime.parse(occupied.date).month &&
          slot.day == DateTime.parse(occupied.date).day &&
          slot.hour == DateTime.parse(occupied.date).hour) {
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
    final result = await Navigator.pushNamed(
      context,
      '/bookingdetails',
      arguments: {
        'futsalId': widget.field.id,
        'futsalName': widget.field.name,
        'futsalImageUrl': widget.field.cardImg,
        'fieldType': widget.field.courtSize,
        'price': packageType == 'Hourly'
            ? widget.field.hourlyPrice
            : widget.field.monthlyPrice,
        'date': _selectedDay.toIso8601String(),
        'time': slotTime.toIso8601String(),
        'packageType': packageType,
      },
    );

    if (result == true) {
      context.read<BookingCubit>().fetchBookingsByFutsal(widget.field.id);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Schedule Slots",
          style: whiteTextStyle.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
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
            print("Occupied slots Received from backedn: ");
            for (var occupied in bookings) {
              print('Date: ${occupied.date}, Package: ${occupied.packageType}');
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.now().subtract(const Duration(days: 30)),
                    lastDay: DateTime.now().add(const Duration(days: 30)),
                    focusedDay: _selectedDay,
                    calendarFormat: _calendarFormat,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        pickSlots(selectedDay);
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
                      final int time = (slotTime.hour > 12)
                          ? slotTime.hour - 12
                          : slotTime.hour;
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '$time - ${(time + 1) > 12 ? ((time + 1) - 12) : (time + 1)} ${slotTime.hour >= 12 ? 'PM' : 'AM'}',
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
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
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
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
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
}
