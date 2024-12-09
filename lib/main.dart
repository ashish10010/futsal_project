import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/src/core/constants/constants.dart';
import 'package:futsal_booking_app/cubit/field_cubit.dart';
import 'package:futsal_booking_app/cubit/navigation_cubit.dart';
import 'package:futsal_booking_app/cubit/ratings_cubit.dart';
import 'package:futsal_booking_app/src/core/constants/string.dart';
import 'package:futsal_booking_app/src/core/routes/app_router.dart';
import 'package:futsal_booking_app/src/core/services/firebase_options.dart';
import 'package:futsal_booking_app/cubit/auth_cubit.dart';
import 'package:futsal_booking_app/service/auth_service.dart';
import 'package:futsal_booking_app/service/field_service.dart';
import 'package:futsal_booking_app/service/user_service.dart';
import 'package:futsal_booking_app/src/core/theme/theme.dart';

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
  @override
  Widget build(BuildContext context) {
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
        title: AppString.title,
        debugShowCheckedModeBanner: false,
        themeMode: themeMode, 
        theme: ThemeData(
          scaffoldBackgroundColor: Palette.backgroundColor,
          appBarTheme: const AppBarTheme(
            backgroundColor: Palette.primaryGreen,
            foregroundColor: Palette.white,
            elevation: 0,
          ),
          colorScheme: const ColorScheme.light(
            primary: Palette.primaryGreen,
            secondary: Palette.darkGreen,
            error: Palette.error,
            surface: Palette.backgroundColor,
            onSurface: Palette.grey,
          ),
         textTheme: TextTheme(
            displayLarge: headlineTextStyle,
            bodyLarge: bodyTextStyle,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Palette.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              textStyle: whiteTextStyle,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            contentPadding: const EdgeInsets.all(27),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Palette.darkGreen),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Palette.primaryGreen, width: 2),
            ),
          ),
        ),
        darkTheme: ThemeData(
          scaffoldBackgroundColor: Palette.backgroundColor,
          colorScheme: const ColorScheme.dark(
            primary: Palette.primaryGreen,
            secondary: Palette.darkGreen,
            error: Palette.error,
            surface: Palette.backgroundColor,
            onSurface: Palette.white,
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: AppRouter.route,
      ),
    );
  }
}
