import 'package:flutter/material.dart';

class BookedDetailsPage extends StatelessWidget {
  final String futsalName;
  final String futsalImageUrl;
  final String fieldType;
  final String price;
  final String date;
  final String time;

  const BookedDetailsPage({
    super.key,
    required this.futsalName,
    required this.futsalImageUrl,
    required this.fieldType,
    required this.price,
    required this.date,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          futsalName,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Futsal Image
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  futsalImageUrl,
                  height: 220,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),

              // Details Card
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
                        iconWidget: const Icon(
                          Icons.sports_soccer,
                          color: Colors.green,
                          size: 24,
                        ),
                        title: 'Futsal Name',
                        value: futsalName,
                      ),
                      const SizedBox(height: 12),

                      // Field Type
                      _buildDetailRow(
                        iconWidget: const Icon(
                          Icons.grass,
                          color: Colors.green,
                          size: 24,
                        ),
                        title: 'Field Type',
                        value: fieldType,
                      ),
                      const SizedBox(height: 12),

                      // Price
                      _buildDetailRow(
                        iconWidget: const Text(
                          'Rs.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        title: 'Price',
                        value: price,
                      ),
                      const SizedBox(height: 12),

                      // Date
                      _buildDetailRow(
                        iconWidget: const Icon(
                          Icons.date_range,
                          color: Colors.green,
                          size: 24,
                        ),
                        title: 'Date',
                        value: _formatDate(date),
                      ),
                      const SizedBox(height: 12),

                      // Time
                      _buildDetailRow(
                        iconWidget: const Icon(
                          Icons.access_time,
                          color: Colors.green,
                          size: 24,
                        ),
                        title: 'Time',
                        value: _formatTime(time),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Booked Summary Action
              ElevatedButton.icon(
                onPressed: () {
                  _showConfirmationDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                ),
                icon: const Icon(Icons.check_circle_outline, size: 24),
                label: const Text(
                  'Confirm Booking',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to build a detail row with icon widget and value
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
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 18, color: Colors.black87),
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  // Method to format the date to show only year, month, and day
  String _formatDate(String dateTime) {
    try {
      DateTime parsedDate = DateTime.parse(dateTime);
      return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTime; // If parsing fails, return the original value
    }
  }

  // Method to format the time to show only hour and minutes
  String _formatTime(String dateTime) {
    try {
      DateTime parsedTime = DateTime.parse(dateTime);
      return '${parsedTime.hour}:${parsedTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTime; // If parsing fails, return the original value
    }
  }

  // Method to show a confirmation or cancellation dialog
  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Confirm Booking',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Are you sure you want to confirm this booking?',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                          _showSnackBar(context, 'Booking Cancelled');
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          _showSnackBar(context, 'Booking Confirmed');
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Confirm',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
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

  // Method to show a snackbar with a message
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }
}