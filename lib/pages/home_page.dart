import 'package:flutter/material.dart';
import 'package:futsal_booking_app/constants.dart';
import 'package:futsal_booking_app/widgets/color_button.dart';
import 'package:futsal_booking_app/widgets/theme_button.dart';

class Home extends StatefulWidget {
  final void Function(bool useLightMode) changeTheme;
  final void Function(int value) changeColor;
  final ColorSelection colorSelected;
  final String appTitle;

  const Home(
      {super.key,
      required this.changeTheme,
      required this.changeColor,
      required this.colorSelected, 
      required this.appTitle,});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int tab = 0;

  // tab bar destinations
  List<NavigationDestination> appBarDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.home),
      label: 'Home',
      selectedIcon: Icon(Icons.credit_card),
    ),
    NavigationDestination(
      icon: Icon(Icons.credit_card),
      label: 'Booking',
      selectedIcon: Icon(Icons.credit_card),
    ),
    NavigationDestination(
      icon: Icon(Icons.credit_card),
      label: 'Settings',
      selectedIcon: Icon(Icons.credit_card),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    //pages to navigate
    final pages = [
      //main screen
      Container(
        color: Colors.red,
      ),
      //booking page
      Container(
        color: Colors.blue,
      ),
      //settins page
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
          ThemeButton(changeThemeMode: widget.changeTheme),
          ColorButton(
            changeColor: widget.changeColor,
            colorSelected: widget.colorSelected,
          ),
        ],
      ),
      // switch between pages
      body: IndexedStack(
        index: tab,
        children: pages,
      ),
      //navbar
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (index) {
          setState(() {
            tab = index;
          });
        },
        destinations: appBarDestinations,
      ),
    );
  }
}
