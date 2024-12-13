import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Primary Color Palette for the Green Theme
class Palette {
  static const Color primaryGreen = Color(0xFF2ECC71); // Light green
  static const Color darkGreen = Color(0xFF27AE60); // Dark green
  static const Color lightGreen = Color(0xFFD4EFDF); // Subtle background green
  static const Color backgroundColor = Color(0xFFF3F4F6); // Soft white background
  static const Color white = Colors.white; // Pure white
  static const Color grey = Color(0xFFB0BEC5); // Neutral grey
  static const Color error = Colors.redAccent;
  static const Color black = Colors.black87; // Error red
  static const Color transparent = Colors.transparent; // Transparent
}

/// Text Styles for Consistent Typography
TextStyle headlineTextStyle = GoogleFonts.poppins(
  fontSize: 32,
  fontWeight: FontWeight.bold,
  color: Palette.darkGreen,
);

TextStyle subtitleTextStyle = GoogleFonts.poppins(
  fontSize: 18,
  fontWeight: FontWeight.w500,
  color: Palette.primaryGreen,
);

TextStyle bodyTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  color: Palette.black,
);

TextStyle whiteTextStyle = GoogleFonts.poppins(
  fontSize: 14,
  color: Palette.grey,
);

TextStyle greenTextStyle = GoogleFonts.poppins(
  fontSize: 16,
  color: Palette.primaryGreen,
);

/// Font Weights
FontWeight light = FontWeight.w300;
FontWeight regular = FontWeight.w400;
FontWeight medium = FontWeight.w500;
FontWeight semiBold = FontWeight.w600;
FontWeight bold = FontWeight.w700;

/// Default Spacing
double defaultMargin = 24.0;

/// Green Gradient for Buttons and Backgrounds
LinearGradient greenGradient = const LinearGradient(
  colors: [
    Palette.primaryGreen,
    Palette.darkGreen,
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

/// Border Styling for Forms
OutlineInputBorder border(Color color, {double width = 1.0}) {
  return OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide(color: color, width: width),
  );
}
