import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/src/core/constants/string.dart';
import 'package:futsal_booking_app/src/core/theme/theme.dart';
import 'package:futsal_booking_app/src/features/booking/presentation/booking_page.dart';
import 'package:futsal_booking_app/src/features/futsal/presentation/home_page.dart';
import 'package:futsal_booking_app/src/core/widgets/theme_button.dart';
import '../../../../cubit/navigation_cubit.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    super.key,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int tab = 0;

  void changeThemeMode(bool useLightMode) {
    setState(() {
      themeMode = useLightMode ? ThemeMode.light : ThemeMode.dark;
    });
  }

  // tab bar destinations
  List<NavigationDestination> appBarDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      label: 'Home',
      selectedIcon: Icon(Icons.home),
    ),
    NavigationDestination(
      icon: Icon(Icons.list_outlined),
      label: 'Booking',
      selectedIcon: Icon(Icons.list),
    ),
    NavigationDestination(
      icon: Icon(Icons.person_2_outlined),
      label: 'Account',
      selectedIcon: Icon(Icons.person),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    //pages to navigate
    final pages = [
      //main screen
      const HomePage(),

      //booking page
      const BookingPage(),

      //Account page
      Container(
        color: Colors.green,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(AppString.title),
        elevation: 4.0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          ThemeButton(
            changeThemeMode: changeThemeMode,
          ),
        ],
      ),
      body: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentTabIndex) {
          return pages[currentTabIndex];
        },
      ),
      // Navigation bar with Cubit integration
      bottomNavigationBar: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentTabIndex) {
          return NavigationBar(
            selectedIndex: currentTabIndex,
            onDestinationSelected: (index) {
              // Update the tab index using Cubit
              context.read<NavigationCubit>().updateTab(index);
            },
            destinations: appBarDestinations,
          );
        },
      ),
      // switch between pages
    );
  }
}
