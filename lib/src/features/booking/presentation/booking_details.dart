import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/src/core/constants/constants.dart';
import '../../../../cubit/booking_cubit.dart';

class BookedDetailsPage extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookedDetailsPage({
    super.key,
    required this.bookingData,
  });

  void _confirmBooking(BuildContext context) {
    final bookingCubit = context.read<BookingCubit>();

    // Extract data for booking
    final futsalName = bookingData['futsalName'];
    final futsalId = bookingData['futsalId'];
    final packageType = bookingData['packageType'];
    final price = bookingData['price'];
    final date = bookingData['date'];
    final time = bookingData['time'];

    bookingCubit.addBooking(
      futsalId: futsalId,
      packageType: packageType,
      amount: double.parse(price),
      date: date,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Booking confirmed successfully!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.popUntil(context, ModalRoute.withName('/home'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Booking Details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Palette.primaryGreen,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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

              // Booking Details
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
                        iconWidget: const Icon(
                          Icons.sports_soccer,
                          color: Palette.primaryGreen,
                        ),
                        title: 'Futsal Name',
                        value: bookingData['futsalName'],
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        iconWidget: const Icon(
                          Icons.grass,
                          color: Palette.primaryGreen,
                        ),
                        title: 'Field Type',
                        value: bookingData['fieldType'],
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        iconWidget: const Icon(
                          Icons.date_range,
                          color: Palette.primaryGreen,
                        ),
                        title: 'Date',
                        value: _formatDate(bookingData['date']),
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        iconWidget: const Icon(
                          Icons.access_time,
                          color: Palette.primaryGreen,
                        ),
                        title: 'Time',
                        value: bookingData['time'],
                      ),
                      const SizedBox(height: 12),
                      _buildDetailRow(
                        iconWidget: const Text(
                          'Rs.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Palette.primaryGreen,
                          ),
                        ),
                        title: 'Price',
                        value: 'Rs. ${bookingData['price']}',
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Confirm Booking Button
              ElevatedButton.icon(
                onPressed: () => _confirmBooking(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Palette.primaryGreen,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                icon: const Icon(Icons.check_circle_outline),
                label: const Text(
                  "Confirm Booking",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required Widget iconWidget,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        iconWidget,
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  String _formatDate(String isoDate) {
    try {
      final date = DateTime.parse(isoDate);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return isoDate;
    }
  }
}
