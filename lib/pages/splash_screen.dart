import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/constants.dart';
import 'package:futsal_booking_app/cubit/auth_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 3), // Wait for 3 seconds before checking user status
      () {
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) {
          // Navigate to login page if no user is logged in
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Print user email for debugging (optional)
          print(user.email);

          // Fetch current user details and navigate to home page
          context.read<AuthCubit>().getCurrentUser(user.uid);
          Navigator.pushReplacementNamed(context, '/home'); // Use pushReplacementNamed to avoid splash screen in back stack
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Pallete.backgroundColor, // Background color for splash screen
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
