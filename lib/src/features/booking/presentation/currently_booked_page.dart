import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/cubit/booking_cubit.dart';
import 'package:futsal_booking_app/src/features/booking/data/booking_model.dart';

class CurrentlyBookedPage extends StatelessWidget {
  const CurrentlyBookedPage({super.key});

  void _cancelBooking(BuildContext context, BookingModel booking) {
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
                const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.red,
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  "Cancel Booking",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  "Are you sure you want to cancel this booking?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.grey.shade300,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Back",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          context
                              .read<BookingCubit>()
                              .deleteBooking(booking.id);
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          "Cancel Booking",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
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
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<BookingCubit>()..fetchUserBookings(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Currently Booked",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.green,
          centerTitle: true,
          elevation: 0,
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
                    "No current bookings available.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  final field = booking.futsalid[0]; // Fetched Futsal Field

                  return Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Image with Fixed Aspect Ratio
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(15),
                          ),
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: CachedNetworkImage(
                              imageUrl: field.cardImg,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                "Location: ${field.location}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Date: ${booking.date}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "Time: ${booking.packageType}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Footer with Price and Cancel Button
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 12,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Rs. ${booking.amount}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () =>
                                    _cancelBooking(context, booking),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                child: const Text(
                                  "Cancel Booking",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is BookingFailure) {
              return Center(child: Text('Error: ${state.error}'));
            } else {
              return const Center(child: Text('No data available.'));
            }
          },
        ),
      ),
    );
  }
}
