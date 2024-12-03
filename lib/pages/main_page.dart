import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/constants.dart';
import 'package:futsal_booking_app/pages/home_page.dart';
import 'package:futsal_booking_app/widgets/color_button.dart';
import 'package:futsal_booking_app/widgets/theme_button.dart';

import '../cubit/navigation_cubit.dart';

class MainPage extends StatefulWidget {
  final void Function(bool useLightMode) changeTheme;
  final void Function(int value) changeColor;
  final ColorSelection colorSelected;
  final String appTitle;

  const MainPage({
    super.key,
    required this.changeTheme,
    required this.changeColor,
    required this.colorSelected,
    required this.appTitle,
  });

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int tab = 0;

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
      label: 'Settings',
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
      Container(
        color: Colors.blue,
      ),

      //Account page
      Container(
        color: Colors.green,
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.appTitle),
        elevation: 4.0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        actions: [
          ThemeButton(
            changeThemeMode: widget.changeTheme,
          ),
          ColorButton(
            changeColor: widget.changeColor,
            colorSelected: widget.colorSelected,
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
