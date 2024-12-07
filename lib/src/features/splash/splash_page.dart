import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/src/core/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../cubit/auth_cubit.dart';
import '../admin/presentation/admin_panel.dart';
import '../auth/presentation/pages/login/login_page.dart';
import '../futsal/presentation/main_page.dart';
import '../owner/presentation/owner_dashboard.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _navigateBasedOnRole();
  }

  Future<void> _navigateBasedOnRole() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      // No token found, navigate to LoginPage
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
      return;
    }
    // If token exists, fetch the user and check role
    context.read<AuthCubit>().getCurrentUser();

    // Listen for AuthCubit state changes
    context.read<AuthCubit>().stream.listen((state) {
      if (!mounted) return;
      if (state is AuthSuccess) {
        final role = state.user.role;

        // Role-based navigation
        if (role == 'user') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainPage()),
          );
        } else if (role == 'futsalOwner') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const OwnerDashboard()),
          );
        } else if (role == 'admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminPanel()),
          );
        }
      } else if (state is AuthFailed || state is AuthInitial) {
        // Navigate to LoginPage if authentication fails or is not initialized
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Palette.backgroundColor,
        child: Center(
          child: Container(
            width: 206,
            height: 206,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/logo.png"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
