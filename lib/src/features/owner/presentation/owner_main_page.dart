import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/cubit/navigation_cubit.dart';
import 'package:futsal_booking_app/src/features/owner/presentation/owner_account_page.dart';
import 'package:futsal_booking_app/src/features/owner/presentation/owner_bookings_page.dart';

class OwnerMainPage extends StatefulWidget {
  const OwnerMainPage({super.key});

  @override
  State<OwnerMainPage> createState() => _OwnerMainPageState();
}

class _OwnerMainPageState extends State<OwnerMainPage> {
  int tab = 0;

  // List of pages for the bottom navigation
  List<NavigationDestination> appBarDestinations = const [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      label: 'Home',
      selectedIcon: Icon(Icons.home),
    ),
    NavigationDestination(
      icon: Icon(Icons.person_2_outlined),
      label: 'Account',
      selectedIcon: Icon(Icons.person),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final pages = [
      const OwnerBookingsPage(
        futsalId: '',
      ),
      const OwnerAccountPage(),
    ];
    return Scaffold(
      body: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentTabIndex) {
          return pages[currentTabIndex];
        },
      ),

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
    );
  }
}
