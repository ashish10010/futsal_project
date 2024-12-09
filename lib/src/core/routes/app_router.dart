import 'package:flutter/material.dart';
import 'package:futsal_booking_app/src/features/admin/presentation/admin_panel.dart';
import 'package:futsal_booking_app/src/features/auth/presentation/pages/login/login_page.dart';
import 'package:futsal_booking_app/src/features/auth/presentation/pages/register/sign_up_page.dart';
import 'package:futsal_booking_app/src/features/booking/presentation/booking_page.dart';
import 'package:futsal_booking_app/src/features/futsal/presentation/detail_page.dart';
import 'package:futsal_booking_app/src/features/futsal/presentation/home_page.dart';
import 'package:futsal_booking_app/src/features/owner/presentation/futsal_owner_settings_page.dart';
import '../../../models/field_model.dart';
import '../../features/futsal/presentation/main_page.dart';

class AppRouter {
  static Route<dynamic> route(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const MainPage());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case '/mainpage':
          return MaterialPageRoute(builder: (_)=> const MainPage());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomePage());
      case '/details':
        final field = settings.arguments as FieldModel;
        return MaterialPageRoute(builder: (_) => DetailPage(field: field));
      case '/booking':
        return MaterialPageRoute(builder: (_) => const ScheduleSlotsPage());

      case '/adminPanel':
        return MaterialPageRoute(builder: (_) => const AdminDashboard());
      case '/ownerDashboard':
        return MaterialPageRoute(builder: (_) => const FutsalOwnerSettingsPage());

      default:
        return MaterialPageRoute(builder: (_) => const InvalidPage());
    }
  }
}

class InvalidPage extends StatelessWidget {
  const InvalidPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Invalid Page'),
      ),
    );
  }
}
