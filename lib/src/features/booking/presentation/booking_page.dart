import 'package:flutter/material.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({super.key});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  DateTime? selectedDate;
  final List<int> bookedSlots = [];
  final List<int> bookedMonthlySlots = [];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 30)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Book Your Slot"),
        backgroundColor: Colors.green[700],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Select Date Button
            ElevatedButton(
              onPressed: () => _selectDate(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                selectedDate == null
                    ? "Select Date"
                    : "Selected Date: ${selectedDate!.toLocal()}".split(' ')[0],
                style: const TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            // Available Slots Text
            const Text(
              "Available Slots",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Legend
            const Row(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.green,
                    ),
                    SizedBox(width: 6),
                    Text("Available"),
                  ],
                ),
                SizedBox(width: 20),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 6,
                      backgroundColor: Colors.red,
                    ),
                    SizedBox(width: 6),
                    Text("Booked"),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Slots List
            Expanded(
              child: ListView.builder(
                itemCount: 14, // Slots from 6 AM to 8 PM
                itemBuilder: (context, index) {
                  final startHour = 6 + index;
                  final endHour = startHour + 1;
                  final slotTime =
                      '$startHour:00 ${startHour < 12 ? "AM" : "PM"} - $endHour:00 ${endHour < 12 ? "AM" : "PM"}';
                  final isBooked = bookedSlots.contains(index);
                  final isBookedMonthly = bookedMonthlySlots.contains(index);

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isBooked || isBookedMonthly
                          ? Colors.red[100]
                          : Colors.green[50],
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          slotTime,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isBooked || isBookedMonthly
                                ? Colors.red[900]
                                : Colors.green[900],
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: isBooked || isBookedMonthly
                                  ? null
                                  : () {
                                      setState(() {
                                        bookedSlots.add(index);
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isBooked || isBookedMonthly
                                    ? Colors.grey
                                    : Colors.green[700],
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Book",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: isBooked || isBookedMonthly
                                  ? null
                                  : () {
                                      setState(() {
                                        bookedMonthlySlots.add(index);
                                      });
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isBooked || isBookedMonthly
                                    ? Colors.grey
                                    : Colors.orange[700],
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                "Book Monthly",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
