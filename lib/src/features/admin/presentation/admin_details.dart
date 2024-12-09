import 'package:flutter/material.dart';

class AdminDetailsPage extends StatelessWidget {
  final Map<String, dynamic> court;

  const AdminDetailsPage({super.key, required this.court});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Court Details",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green,
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
                court['imageUrl'],
                height: 220,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 24),

            // Court Details Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow(
                      icon: Icons.sports_soccer,
                      label: "Name",
                      value: court["name"],
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      icon: Icons.location_on,
                      label: "Location",
                      value: court["location"],
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      icon: Icons.grass,
                      label: "Field Type",
                      value: court["fieldType"],
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      icon: null, // No icon, using Rs. as text
                      label: "Price",
                      value: "Rs. ${court["price"]}",
                      isCustomIcon: true,
                      customIconText: "Rs.",
                    ),
                    const SizedBox(height: 12),
                    _buildDetailRow(
                      icon: Icons.date_range,
                      label: "Date Added",
                      value: _formatDate(court["dateAdded"]),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build detail rows
  Widget _buildDetailRow({
    IconData? icon,
    required String label,
    required String value,
    bool isCustomIcon = false,
    String? customIconText,
  }) {
    return Row(
      children: [
        isCustomIcon
            ? Text(
              customIconText ?? "",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            )
            : Icon(icon, color: Colors.green, size: 24),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
        ),
      ],
    );
  }

  // Helper method to format dates
  String _formatDate(String dateTime) {
    try {
      DateTime parsedDate = DateTime.parse(dateTime);
      return '${parsedDate.year}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.day.toString().padLeft(2, '0')}';
    } catch (e) {
      return dateTime; // If parsing fails, return original value
    }
  }
}