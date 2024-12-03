import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/constants.dart';
import 'package:futsal_booking_app/cubit/field_cubit.dart';
import 'package:futsal_booking_app/cubit/navigation_cubit.dart';
import 'package:futsal_booking_app/cubit/ratings_cubit.dart';
import 'package:futsal_booking_app/firebase_options.dart';
import 'package:futsal_booking_app/pages/details_page.dart';
import 'package:futsal_booking_app/pages/main_page.dart';
import 'package:futsal_booking_app/pages/login_page.dart';
import 'package:futsal_booking_app/cubit/auth_cubit.dart';
import 'package:futsal_booking_app/pages/splash_screen.dart';
import 'package:futsal_booking_app/service/auth_service.dart';
import 'package:futsal_booking_app/service/field_service.dart';
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
        borderSide: BorderSide(
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

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => NavigationCubit(),
        ),
        BlocProvider(
          create: (_) => AuthCubit(
            AuthService(),
            UserService(),
          ),
        ),
        BlocProvider(
          create: (_) => FieldCubit(
            FieldService(),
          ),
        ),
        BlocProvider(
          create: (_) => RatingCubit(),
        ),
      ],
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
              focusedBorder: _border(Pallete.borderColor),
            )),
        darkTheme: ThemeData(
          colorSchemeSeed: colorSelected.color,
          useMaterial3: true,
          brightness: Brightness.dark,
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.all(27),
            enabledBorder: _border(Pallete.borderColor),
            focusedBorder: _border(Pallete.borderColor),
          ),
        ),
        initialRoute: '/SplashScreen', // Define the initial route
        routes: {
          '/SplashScreen': (context) => const SplashScreen(),
          '/login': (context) => const LoginPage(), // Login Page Route
          '/signup': (context) => const SignUpPage(), // Sign-Up Page Route
          '/home': (context) => MainPage(
                appTitle: appTitle,
                changeTheme: changeThemeMode,
                changeColor: changeColor,
                colorSelected: colorSelected,
              ),
          '/details': (context) => const DetailsPage() // MainScreenRoute
        },
      ),
    );
  }
}
