import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FaqsPage extends StatelessWidget {
  const FaqsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "FAQs",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: const FaqsContent(),
    );
  }
}

class FaqsContent extends StatefulWidget {
  const FaqsContent({super.key});

  @override
  _FaqsContentState createState() => _FaqsContentState();
}

class _FaqsContentState extends State<FaqsContent> {
  final List<FaqItem> _faqItems = [
    FaqItem(
      question: "How do I book a futsal slot?",
      answer:
          "You can book a futsal slot by selecting your preferred date and time from the Schedule Slots page. Choose a package (Hourly/Monthly), confirm your booking details, and proceed to payment.",
    ),
    FaqItem(
      question: "Can I cancel or reschedule a booking?",
      answer:
          "Yes, you can cancel a booking by navigating to the 'Currently Booked' page. Click the 'Cancel Booking' button for the slot you want to cancel. Rescheduling requires you to cancel the current booking and book a new slot.",
    ),
    FaqItem(
      question: "What are the available packages?",
      answer:
          "We currently offer two types of packages: Hourly (pay per hour) and Monthly (subscribe for a month with discounted rates).",
    ),
    FaqItem(
      question: "How do I check my existing bookings?",
      answer:
          "You can view your active bookings in the 'Currently Booked' section. All your confirmed slots will be listed there.",
    ),
    FaqItem(
      question: "What payment methods are supported?",
      answer: "We support Khalti as the primary payment method.",
    ),
    FaqItem(
      question: "How do I contact customer support?",
      answer:
          "You can contact our support team via the 'About Us' page or email us at support@futsalbookingapp.com. We are also available on phone during working hours.",
    ),
    FaqItem(
      question: "What happens if I arrive late for my booked slot?",
      answer:
          "If you arrive late, the remaining time of your slot will still be honored, but we cannot extend the time into the next slot due to scheduling constraints.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        Text(
          "Frequently Asked Questions",
          style: GoogleFonts.poppins(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        ..._faqItems.map((faq) => _buildFaqTile(faq)).toList(),
        const SizedBox(height: 24),
        Center(
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, '/aboutUs');
            },
            child: Text(
              "For further queries, feel free to contact us!",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.green,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFaqTile(FaqItem faq) {
    return FaqTile(question: faq.question, answer: faq.answer);
  }
}

class FaqTile extends StatefulWidget {
  final String question;
  final String answer;

  const FaqTile({
    super.key,
    required this.question,
    required this.answer,
  });

  @override
  State<FaqTile> createState() => _FaqTileState();
}

class _FaqTileState extends State<FaqTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      widget.question,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.teal.shade900,
                      ),
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.remove : Icons.add,
                    color: Colors.teal,
                  ),
                ],
              ),
              if (_isExpanded) ...[
                const SizedBox(height: 8),
                Text(
                  widget.answer,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.teal.shade700,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({
    required this.question,
    required this.answer,
  });
}
