import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/cubit/booking_cubit.dart';

class OwnerBookingsPage extends StatelessWidget {
  final String futsalId;

  const OwnerBookingsPage({
    super.key,
    required this.futsalId,
  });

  // Function to format Date: Extract only 'YYYY-MM-DD'
  String _formatDate(String dateTime) {
    final parsedDate = DateTime.parse(dateTime);
    return "${parsedDate.year}-${_padZero(parsedDate.month)}-${_padZero(parsedDate.day)}";
  }

  // Generate slot time
  String _generateSlot(String dateTime) {
    final parsedTime = DateTime.parse(dateTime);
    final startHour = parsedTime.hour;
    final endHour = startHour + 1;

    String formatHour(int hour) {
      final period = hour < 12 ? 'AM' : 'PM';
      final hour12 = hour % 12 == 0 ? 12 : hour % 12;
      return "$hour12:00 $period";
    }

    return "${formatHour(startHour)} - ${formatHour(endHour)}";
  }

  String _padZero(int value) => value < 10 ? '0$value' : '$value';

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: context.read<BookingCubit>()..fetchBookingsByFutsal(futsalId),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "View Bookings",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00BFA5), Color(0xFF00E676)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          elevation: 0,
        ),
        backgroundColor: Colors.grey.shade100,
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
                padding: const EdgeInsets.all(12.0),
                itemCount: bookings.length,
                itemBuilder: (context, index) {
                  final booking = bookings[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.white,
                          Colors.grey.shade50,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                booking.futsalid[0].name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const Icon(
                                Icons.sports_soccer,
                                color: Colors.teal,
                                size: 24,
                              ),
                            ],
                          ),
                          const Divider(),
                          _buildDetailRow(
                            icon: Icons.calendar_today,
                            label: "Date",
                            value: _formatDate(booking.date),
                          ),
                          _buildDetailRow(
                            icon: Icons.access_time,
                            label: "Slot",
                            value: _generateSlot(booking.date),
                          ),
                          _buildDetailRow(
                            icon: Icons.attach_money,
                            label: "Price",
                            value: "Rs. ${booking.amount}",
                          ),
                          _buildDetailRow(
                            icon: Icons.category,
                            label: "Package",
                            value: booking.packageType,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            } else if (state is BookingFailure) {
              return Center(
                child: Text(
                  'Error: ${state.error}',
                  style: const TextStyle(color: Colors.red),
                ),
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

  // Helper Widget to build booking details with an icon
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.teal, size: 20),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Colors.black87,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
