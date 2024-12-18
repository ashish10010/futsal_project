import 'package:flutter/material.dart';
import 'package:futsal_booking_app/src/core/constants/constants.dart';

class AuthGradientButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onTap;

  const AuthGradientButton({
    super.key,
    required this.buttonText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient:
            greenGradient, // Using the reusable gradient from constants.dart
        borderRadius: BorderRadius.circular(12), // Updated for a modern look
      ),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor:
              Colors.transparent, // Ensures the gradient is visible
          shadowColor: Colors.transparent, // Removes button shadow
          elevation: 0, // Flat look
          minimumSize: const Size(double.infinity, 55), // Full-width button
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Matches container radius
          ),
        ),
        child: Text(
          buttonText,
          style: whiteTextStyle.copyWith(
            // Reusing whiteTextStyle from constants.dart
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
