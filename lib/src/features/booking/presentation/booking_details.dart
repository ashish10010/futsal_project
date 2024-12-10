import 'package:flutter/material.dart';

class BookedDetailsPage extends StatelessWidget {
  const BookedDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    final String futsalName = args['futsalName'];
    final String futsalImageUrl = args['futsalImageUrl'];
    final String fieldType = args['fieldType'];
    final String price = args['price'];
    final String date = args['date'];
    final String time = args['time'];

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
                      _buildDetailRow(
                        iconWidget: const Icon(
                          Icons.access_time,
                          color: Colors.green,
                          size: 24,
                        ),
                        title: 'Time',
                        value: time,
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

  String _formatDate(String dateTime) {
    final parsedDate = DateTime.parse(dateTime);
    return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
  }

  void _showConfirmationDialog(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Booked!"),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
