import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/constants.dart';
import 'package:futsal_booking_app/firebase_options.dart';
import 'package:futsal_booking_app/pages/home_page.dart';
import 'package:futsal_booking_app/pages/login_page.dart';
import 'package:futsal_booking_app/cubit/auth_cubit.dart';
import 'package:futsal_booking_app/service/auth_service.dart';
import 'package:futsal_booking_app/service/user_service.dart';
import 'pages/sign_up_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const QuickSal());
}

class QuickSal extends StatefulWidget {
  const QuickSal({super.key});

  @override
  State<QuickSal> createState() => _QuickSalState();
}

class _QuickSalState extends State<QuickSal> {
  ThemeMode themeMode = ThemeMode.light;
  ColorSelection colorSelected = ColorSelection.pink;

      static OutlineInputBorder _border(Color color) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide:  BorderSide(
          color: color,
          width: 3,
        ),
      );

  void changeThemeMode(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  void changeColor(int value) {
    setState(() {
      colorSelected = ColorSelection.values[value];
    });
  }

  @override
  Widget build(BuildContext context) {
    const appTitle = 'QuickSal';

    return BlocProvider(
      create: (_) => AuthCubit(AuthService(), UserService()),
      child: MaterialApp(
        title: appTitle,
        debugShowCheckedModeBanner: false, // Hides the debug banner
        themeMode: themeMode,
        theme: ThemeData(
          colorSchemeSeed: colorSelected.color,
          useMaterial3: true,
          brightness: Brightness.light,
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.all(27),
            enabledBorder: _border(Pallete.borderColor),
            focusedBorder: _border(Pallete.gradient2),
          )
          
        ),
        darkTheme: ThemeData(
          colorSchemeSeed: colorSelected.color,
          useMaterial3: true,
          brightness: Brightness.dark,
          inputDecorationTheme:  InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      enabledBorder:  _border(Pallete.borderColor),
      focusedBorder: _border(Pallete.gradient2),
    ),
        ),
        initialRoute: '/login', // Define the initial route
        routes: {
          '/login': (context) => const LoginPage(), // Login Page Route
          '/signup': (context) => const SignUpPage(), // Sign-Up Page Route
          '/home': (context) => Home(
                appTitle: appTitle,
                changeTheme: changeThemeMode,
                changeColor: changeColor,
                colorSelected: colorSelected,
              ), // Home Page Route
        },
      ),
    );
  }
}
