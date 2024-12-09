import 'package:flutter/material.dart';

class ViewBookingsPage extends StatelessWidget {
  const ViewBookingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data for demonstration
    final bookings = [
      Booking(
        userName: "John Doe",
        userImage: "https://via.placeholder.com/150",
        courtName: "Everest Futsal Court",
        bookedSlots: ["6:00 AM - 7:00 AM", "7:00 AM - 8:00 AM"],
        bookingDateTime: DateTime(2024, 12, 10, 6, 0),
      ),
      Booking(
        userName: "Jane Smith",
        userImage: null, // No image, shows initials instead
        courtName: "Himalayan Futsal Court",
        bookedSlots: ["5:00 PM - 6:00 PM"],
        bookingDateTime: DateTime(2024, 12, 11, 17, 0),
      ),
      Booking(
        userName: "Rahul Sharma",
        userImage: "https://via.placeholder.com/150",
        courtName: "Everest Futsal Court",
        bookedSlots: ["7:00 PM - 8:00 PM", "8:00 PM - 9:00 PM"],
        bookingDateTime: DateTime(2024, 12, 12, 19, 0),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("View Bookings", style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _buildBookingCard(booking);
        },
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Info Row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserAvatar(booking.userName, booking.userImage),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    booking.userName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Court Name
            Row(
              children: [
                const Icon(Icons.sports_soccer, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    booking.courtName,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Booked Slots
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.calendar_today_outlined, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        booking.bookedSlots
                            .map(
                              (slot) => Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  slot,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // Booking Date and Time
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.green),
                const SizedBox(width: 8),
                Text(
                  _formatDateTime(booking.bookingDateTime),
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserAvatar(String userName, String? userImage) {
    if (userImage != null && userImage.isNotEmpty) {
      // Display user's image
      return CircleAvatar(radius: 24, backgroundImage: NetworkImage(userImage));
    } else {
      // Display initials if no image
      final initials = _getInitials(userName);
      return CircleAvatar(
        radius: 24,
        backgroundColor: Colors.green,
        child: Text(
          initials,
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      );
    }
  }

  String _getInitials(String name) {
    final parts = name.split(" ");
    if (parts.length > 1) {
      return parts[0][0].toUpperCase() + parts[1][0].toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }

  String _formatDateTime(DateTime dateTime) {
    // Format: "Dec 10, 2024 - 6:00 AM"
    final date =
        "${_monthName(dateTime.month)} ${dateTime.day}, ${dateTime.year}";
    final hour = dateTime.hour % 12 == 0 ? 12 : dateTime.hour % 12;
    final amPm = dateTime.hour < 12 ? "AM" : "PM";
    final minute = dateTime.minute.toString().padLeft(2, '0');

    return "$date - $hour:$minute $amPm";
  }

  String _monthName(int month) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec",
    ];
    return months[month - 1];
  }
}

class Booking {
  final String userName;
  final String? userImage;
  final String courtName;
  final List<String> bookedSlots;
  final DateTime bookingDateTime;

  Booking({
    required this.userName,
    this.userImage,
    required this.courtName,
    required this.bookedSlots,
    required this.bookingDateTime,
  });
}