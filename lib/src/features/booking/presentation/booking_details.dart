import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/src/core/constants/constants.dart';
import 'package:futsal_booking_app/src/features/booking/data/booking_model.dart';
import '../../../../cubit/booking_cubit.dart';

class BookedDetailsPage extends StatelessWidget {
  final Map<String, dynamic> bookingData;

  const BookedDetailsPage({
    super.key,
    required this.bookingData,
  });

  @override
  Widget build(BuildContext context) {
    final bookingCubit = context.read<BookingCubit>();

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
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              (loadingProgress.expectedTotalBytes ?? 1)
                          : null,
                    ),
                  );
                },
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  size: 100,
                  color: Colors.grey,
                ),
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
                    // Futsal Name
                    _buildDetailRow(
                      icon: Icons.sports_soccer,
                      // label: 'Futsal Name',
                      label: '${DateTime.parse(bookingData['date'])}',
                      value: bookingData['futsalName'],
                    ),
                    const SizedBox(height: 12),

                    // Field Type
                    _buildDetailRow(
                      icon: Icons.grass,
                      label: 'Field Type',
                      value: bookingData['fieldType'],
                    ),
                    const SizedBox(height: 12),

                    // Date
                    _buildDetailRow(
                      icon: Icons.date_range,
                      label: 'Date',
                      value: bookingData['date'], // Format the date
                    ),
                    const SizedBox(height: 12),

                    // Time
                    _buildDetailRow(
                      icon: Icons.access_time,
                      label: 'Time',
                      value: bookingData['time'],
                    ),
                    const SizedBox(height: 12),

                    // Price
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
                  // Show loading indicator
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );

                  // Make API call to create booking
                  await bookingCubit.addBooking(
                    futsalId: bookingData['futsalId'],
                    packageType: bookingData['packageType'],
                    amount: bookingData['price'].toString(),
                    date: bookingData['date'],
                  );
                  Navigator.of(context).pop(); // Close the loading indicator

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Booking confirmed successfully!"),
                      backgroundColor: Colors.green,
                    ),
                  );

                  Navigator.of(context).popUntil((route) => route.isFirst);
                } catch (e) {
                  Navigator.of(context).pop(); // Close the loading indicator

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Failed to confirm booking: $e"),
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
                    color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper Widget to Build Detail Rows
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
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ],
    );
  }
}
