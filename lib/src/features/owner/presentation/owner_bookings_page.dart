import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/cubit/booking_cubit.dart';

class OwnerBookingsPage extends StatelessWidget {
  final String futsalId;

  const OwnerBookingsPage({
    super.key,
    required this.futsalId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<BookingCubit>()..fetchBookingsByFutsal(futsalId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "View Bookings",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
          centerTitle: true,
        ),
        body: BlocBuilder<BookingCubit, BookingState>(
          builder: (context, state) {
            if (state is BookingLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is BookingSuccess) {
              final bookings = state.bookings;

              if (bookings.isEmpty) {
                return const Center(
                  child: Text(
                    "No bookings available for this futsal.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final user = booking.userId;

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Booking Info Section
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Booked By: ${user ?? "Unknown User"}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Package: ${booking.packageType}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                "Date: ${booking.date}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                "Price: Rs. ${booking.amount}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Footer - Cancel Button
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12.0,
                          ),
                          child: ElevatedButton(
                            onPressed: () {
                              context
                                  .read<BookingCubit>()
                                  .deleteBooking(booking.id);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text(
                              "Cancel Booking",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is BookingFailure) {
              return Center(
                child: Text('Error: ${state.error}'),
              );
            } else {
              return const Center(
                child: Text("No data available."),
              );
            }
          },
        ),
      ),
    );
  }
}
