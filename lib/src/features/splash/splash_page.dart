import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../cubit/auth_cubit.dart';
import '../../core/constants/constants.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    _showSplashAndNavigate();
  }

  Future<void> _showSplashAndNavigate() async {
 
    await Future.delayed(const Duration(seconds: 2));
    await _navigateBasedOnAuthStatus();
  }

  Future<void> _navigateBasedOnAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      // No token found, navigate to LoginPage
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    try {
      // Fetch the current user from AuthCubit
      final authCubit = context.read<AuthCubit>();
      await authCubit.getCurrentUser();

      if (!mounted) return;

      // Check the current AuthState
      final state = authCubit.state;
      if (state is AuthLoggedIn) {
        final role = state.user.role;

        // Role-based navigation
        if (role == 'user') {
          Navigator.pushReplacementNamed(context, '/mainpage');
        } else if (role == 'futsalOwner') {
          Navigator.pushReplacementNamed(context, '/ownerDashboard');
        } else if (role == 'admin') {
          Navigator.pushReplacementNamed(context, '/adminPanel');
        }
      } else {
        // If AuthState is AuthFailed or AuthInitial, navigate to LoginPage
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      // Handle errors gracefully by navigating to LoginPage
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/login');
    }
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
