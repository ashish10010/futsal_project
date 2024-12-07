import 'dart:async';
import 'package:flutter/material.dart';
import 'package:futsal_booking_app/src/core/constants/constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    // Wait for 3 seconds before navigating
    Timer(
      const Duration(seconds: 3),
      () {
        // Navigate directly to the signup page
        Navigator.pushReplacementNamed(context, '/signup');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Palette.backgroundColor, // Background color for splash screen
        child: Center(
          child: Container(
            width: 206,
            height: 206,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/logo.png"), // Your logo image
              ),
            ),
          ),
        ),
      ),
    );
  }
}
