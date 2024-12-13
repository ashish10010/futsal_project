import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/cubit/booking_cubit.dart';

class BookingHistoryPage extends StatelessWidget {
  const BookingHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<BookingCubit>()..fetchUserBookings(), // Fetch user's bookings
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Booking History",
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

              // Filter out past bookings
              final now = DateTime.now();
              final pastBookings = bookings.where((booking) {
                final bookingDate = booking.date;
                return bookingDate.isBefore(now);
              }).toList();

              if (pastBookings.isEmpty) {
                return const Center(
                  child: Text(
                    "No past bookings available.",
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: pastBookings.length,
                itemBuilder: (context, index) {
                  final booking = pastBookings[index];
                  final field = booking.futsalid[0]; 

                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Futsal Image
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: field.cardImg,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Futsal Details
                              Expanded(
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
                                      "Date: ${booking.date.toLocal()}",
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey,
                                      ),
                                    ),
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
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Price and Status
                          Row(
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
                              const Text(
                                "Completed",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blueGrey,
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
