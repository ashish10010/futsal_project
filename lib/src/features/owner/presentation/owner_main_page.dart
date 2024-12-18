import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/cubit/navigation_cubit.dart';
import 'package:futsal_booking_app/cubit/field_cubit.dart';
import 'package:futsal_booking_app/src/features/owner/presentation/owner_account_page.dart';
import 'package:futsal_booking_app/src/features/owner/presentation/owner_bookings_page.dart';

class OwnerMainPage extends StatefulWidget {
  const OwnerMainPage({super.key});

  @override
  State<OwnerMainPage> createState() => _OwnerMainPageState();
}

class _OwnerMainPageState extends State<OwnerMainPage> {
  String? futsalId;

  @override
  void initState() {
    super.initState();
    fetchFutsalId();
  }

  Future<void> fetchFutsalId() async {
    final fieldCubit = context.read<FieldCubit>();
    fieldCubit.fetchFieldsByOwner();
    if (fieldCubit.state is FieldSuccess) {
      final fields = (fieldCubit.state as FieldSuccess).fields;
      if (fields.isNotEmpty) {
        setState(() {
          futsalId = fields.first.id; // Get the first futsal ID
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      OwnerBookingsPage(futsalId: futsalId ?? ''),
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
          return Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade400,
                  blurRadius: 8,
                  spreadRadius: 2,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              child: NavigationBar(
                backgroundColor: Colors.white,
                elevation: 0,
                indicatorColor: Colors.teal.withOpacity(0.1),
                selectedIndex: currentTabIndex,
                onDestinationSelected: (index) {
                  context.read<NavigationCubit>().updateTab(index);
                },
                destinations: [
                  _buildNavDestination(
                    icon: Icons.home_outlined,
                    selectedIcon: Icons.home,
                    label: 'Home',
                    isSelected: currentTabIndex == 0,
                  ),
                  _buildNavDestination(
                    icon: Icons.person_outline,
                    selectedIcon: Icons.person,
                    label: 'Account',
                    isSelected: currentTabIndex == 1,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  NavigationDestination _buildNavDestination({
    required IconData icon,
    required IconData selectedIcon,
    required String label,
    required bool isSelected,
  }) {
    return NavigationDestination(
      icon: Icon(
        isSelected ? selectedIcon : icon,
        color: isSelected ? Colors.teal : Colors.grey,
        size: 28,
      ),
      label: label,
    );
  }
}
