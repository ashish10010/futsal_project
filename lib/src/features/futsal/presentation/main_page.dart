import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/src/features/futsal/presentation/home_page.dart';
import '../../../../cubit/navigation_cubit.dart';
import '../../account/presentation/account_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Navigation bar destinations
  final List<NavigationDestination> appBarDestinations = const [
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

  // Pages to navigate
  final List<Widget> pages = [
    const HomePage(),
    const AccountPage(),
  ];

  // Function to navigate to the Maps Page
  void _navigateToMapsPage(BuildContext context) {
    Navigator.pushNamed(context, '/map');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Main Body: Displays the selected page
      body: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentTabIndex) {
          return pages[currentTabIndex];
        },
      ),

      // BottomAppBar with FAB notch
      bottomNavigationBar: BlocBuilder<NavigationCubit, int>(
        builder: (context, currentTabIndex) {
          return BottomAppBar(
            shape: const CircularNotchedRectangle(), // Curve for the FAB
            notchMargin: 8.0,
            elevation: 10,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Home Tab
                IconButton(
                  icon: Icon(
                    currentTabIndex == 0 ? Icons.home : Icons.home_outlined,
                    color: currentTabIndex == 0 ? Colors.green : Colors.black54,
                    size: 28,
                  ),
                  onPressed: () {
                    context.read<NavigationCubit>().updateTab(0);
                  },
                ),

                // Spacer to account for the FAB
                const SizedBox(width: 50),

                // Account Tab
                IconButton(
                  icon: Icon(
                    currentTabIndex == 1
                        ? Icons.person
                        : Icons.person_2_outlined,
                    color: currentTabIndex == 1 ? Colors.green : Colors.black54,
                    size: 28,
                  ),
                  onPressed: () {
                    context.read<NavigationCubit>().updateTab(1);
                  },
                ),
              ],
            ),
          );
        },
      ),

      // Floating Action Button for Navigation to Maps Page
      floatingActionButton: SizedBox(
        height: 65,
        width: 65,
        child: FloatingActionButton(
          onPressed: () =>
              _navigateToMapsPage(context), // Navigate to Maps Page
          backgroundColor: Colors.green,
          elevation: 6,
          shape: const CircleBorder(),
          child: const Icon(
            Icons.location_on, // Location icon
            size: 32,
            color: Colors.white,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}