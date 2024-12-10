import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/src/core/constants/constants.dart';
import 'package:futsal_booking_app/src/features/booking/data/booking_model.dart';
import 'package:futsal_booking_app/src/features/futsal/data/models/field_model.dart';
import '../../../../cubit/booking_cubit.dart';
import '../../../../cubit/field_cubit.dart';

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fetch user bookings when the page loads
    context.read<BookingCubit>().fetchUserBookings();
    context.read<FieldCubit>().fetchAllFields(); // Fetch all fields

    return Scaffold(
      appBar: AppBar(
        title: const Text("Booking History"),
        backgroundColor: Palette.primaryGreen,
        centerTitle: true,
      ),
      body: BlocBuilder<BookingCubit, BookingState>(
        builder: (context, bookingState) {
          if (bookingState is BookingLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (bookingState is BookingSuccess) {
            final bookings = bookingState.bookings;

            if (bookings.isEmpty) {
              return const Center(
                child: Text(
                  "No bookings available.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              );
            }

            return BlocBuilder<FieldCubit, FieldState>(
              builder: (context, fieldState) {
                if (fieldState is FieldLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (fieldState is FieldSuccess) {
                  final fields = fieldState.fields;

                  return ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: bookings.length,
                    itemBuilder: (context, index) {
                      final booking = bookings[index];
                      final field = fields.firstWhere(
                        (field) => field.id == booking.futsalId,
                        orElse: () =>
                            FieldModel.empty(), // Handle missing field
                      );

                      final isSlotAvailable = _isSlotAvailable(booking);

                      return Card(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      field.cardImg,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(
                                        Icons.error,
                                        size: 100,
                                        color: Palette.error,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          field.name,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Field Type: ${field.courtSize}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Date: ${_formatDate(booking.date as String)}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Rs. ${booking.amount}",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Palette.primaryGreen,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: isSlotAvailable
                                        ? () => _rebook(context, booking, field)
                                        : null,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: isSlotAvailable
                                          ? Palette.primaryGreen
                                          : Palette.grey,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: Text(
                                      isSlotAvailable
                                          ? "Re-book"
                                          : "Slot Booked",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (fieldState is FieldFailure) {
                  return Center(
                    child: Text(
                      "Error fetching futsal details: ${fieldState.error}",
                      style: const TextStyle(color: Palette.error),
                    ),
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            );
          } else if (bookingState is BookingFailure) {
            return Center(
              child: Text(
                "Error: ${bookingState.error}",
                style: const TextStyle(color: Palette.error),
              ),
            );
          }

          return const Center(
            child: Text(
              "No bookings available.",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        },
      ),
    );
  }

  bool _isSlotAvailable(BookingModel booking) {
    final bookingDate = (booking.date);
    final now = DateTime.now();
    return bookingDate.isAfter(now);
  }

  void _rebook(BuildContext context, BookingModel booking, FieldModel field,) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.check_circle_outline,
                    color: Colors.green, size: 60),
                const SizedBox(height: 20),
                const Text(
                  'Booking Confirmed!',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'You have successfully rebooked ${field.name} on ${_formatDate(booking.date as String)}.',
                  style: const TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    // Navigate to the booking screen or take any other action here
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: Palette.primaryGreen,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatDate(String dateTime) {
    try {
      final parsedDate = DateTime.parse(dateTime);
      return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTime;
    }
  }
}
