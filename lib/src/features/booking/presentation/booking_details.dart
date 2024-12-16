import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/cubit/booking_cubit.dart';
import 'package:futsal_booking_app/src/core/constants/constants.dart';

class BookingDetailsPage extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookingDetailsPage({
    super.key,
    required this.bookingData,
  });

  @override
  Widget build(BuildContext context) {
    final bookingCubit = context.read<BookingCubit>();
    // Parse the date and time
    final DateTime selectedDate = DateTime.parse(bookingData['date']);
    final int selectedTimeHour = bookingData['time'];

    // Format date as "YYYY-MM-DD"
    String formattedDate =
        "${selectedDate.year}-${_padZero(selectedDate.month)}-${_padZero(selectedDate.day)}";

    // Format time as "6 AM", "7 PM", etc.
    String formattedTime = _formatTime(selectedTimeHour);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Booking Details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Palette.primaryGreen,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Futsal Image
            ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: Image.network(
                bookingData['futsalImageUrl'],
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),

            // Booking Details Card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      icon: Icons.sports_soccer,
                      label: 'Futsal Name',
                      value: bookingData['futsalName'],
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      icon: Icons.grass,
                      label: 'Field Type',
                      value: bookingData['fieldType'],
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      icon: Icons.date_range,
                      label: 'Date',
                      value: formattedDate, // Only the formatted date
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      icon: Icons.access_time,
                      label: 'Time',
                      value: formattedTime, // Only the formatted time
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      icon: Icons.monetization_on,
                      label: 'Price',
                      value: 'Rs. ${bookingData['price']}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Confirm Booking Button
            ElevatedButton(
              onPressed: () async {
                try {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                  await bookingCubit.addBooking(
                    futsalId: bookingData['futsalId'],
                    packageType: bookingData['packageType'],
                    amount: bookingData['price'].toString(),
                    date: bookingData['date'],
                  );
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Booking Confirmed Successfuly!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst);
                } catch (e) {
                  Navigator.of(context).pop();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Failed to Confirm Booking!: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                backgroundColor: Palette.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
              ),
              child: const Text(
                'Confirm Booking',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Helper Widget to Build Detail Rows
  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: Palette.primaryGreen, size: 24),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }

  /// Helper method to format time to 12-hour format (6 AM, 7 PM, etc.)
  String _formatTime(int hour) {
    final h = hour % 12 == 0 ? 12 : hour % 12;
    final period = hour < 12 ? 'AM' : 'PM';
    return '$h $period';
  }

  /// Pad zero to single digit months or days
  String _padZero(int value) {
    return value < 10 ? '0$value' : '$value';
  }
}
