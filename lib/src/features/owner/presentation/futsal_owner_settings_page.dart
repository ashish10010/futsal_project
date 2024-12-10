import 'package:flutter/material.dart';
import 'package:futsal_booking_app/src/features/owner/presentation/view_futsal_details.dart';
import 'package:futsal_booking_app/src/features/owner/presentation/view_bookings.dart';
import 'add_futsal_court.dart';

class FutsalOwnerSettingsPage extends StatefulWidget {
  const FutsalOwnerSettingsPage({super.key});

  @override
  State<FutsalOwnerSettingsPage> createState() =>
      _FutsalOwnerSettingsPageState();
}

class _FutsalOwnerSettingsPageState extends State<FutsalOwnerSettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Futsal Owner Settings',
          style: TextStyle(fontSize: 20),
        ),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        children: [
          // Header Section with Circle Avatar, Name, and Email
          const UserHeader(
            name: "Futsal Owner",
            email: "owner@example.com",
            avatarUrl:
                "https://via.placeholder.com/150", // Replace with actual image URL
          ),
          const SizedBox(height: 20),

          // Section for Court Management
          SettingsSection(
            sectionTitle: "Court Management",
            items: [
              SettingsListTile(
                title: "Add Futsal Court",
                icon: Icons.add_circle_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddFutsal(),
                    ),
                  );
                },
              ),
              SettingsListTile(
                title: "View Futsal Details",
                icon: Icons.info_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewFutsalDetails(),
                    ),
                  );
                },
              ),
            ],
          ),

          // Section for Booking Overview
          SettingsSection(
            sectionTitle: "Bookings Overview",
            items: [
              SettingsListTile(
                title: "View All Bookings",
                icon: Icons.calendar_today_outlined,
                onTap: () {
                  // Navigate to the ViewBookingsPage
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ViewBookingsPage(),
                    ),
                  );
                },
              ),
            ],
          ),

          // Section for Account Management
          SettingsSection(
            sectionTitle: "Account Management",
            items: [
              SettingsListTile(
                title: "Logout",
                icon: Icons.logout,
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),

          // Section for App Information
          SettingsSection(
            sectionTitle: "App Information",
            items: [
              SettingsListTile(
                title: "FAQs",
                icon: Icons.help_outline,
                onTap: () {
                  // Add your navigation logic here
                },
              ),
              SettingsListTile(
                title: "About Us",
                icon: Icons.info_outline,
                onTap: () {
                  // Add your navigation logic here
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to show a confirmation dialog before logging out
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Logout"),
          content: const Text("Are you sure you want to log out?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _logout(); // Log the user out
              },
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  // Function to handle logout logic
  void _logout() {
    // Add your logout logic here, e.g., clearing the user session, navigating to the login screen, etc.
    Navigator.pushReplacementNamed(
      context,
      "/login",
    ); // Example: Navigate to login screen
  }
}

class UserHeader extends StatelessWidget {
  final String name;
  final String email;
  final String avatarUrl;

  const UserHeader({
    super.key,
    required this.name,
    required this.email,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircleAvatar(radius: 50, backgroundImage: NetworkImage(avatarUrl)),
        const SizedBox(height: 10),
        Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        Text(email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String sectionTitle;
  final List<Widget> items;

  const SettingsSection({
    super.key,
    required this.sectionTitle,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5, top: 15),
          child: Text(
            sectionTitle,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.green,
            ),
          ),
        ),
        Column(children: items),
        Divider(thickness: 1, color: Colors.grey.shade300),
      ],
    );
  }
}

class SettingsListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.green),
      title: Text(
        title,
        style: const TextStyle(fontSize: 16, color: Colors.black87),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 16,
        color: Colors.grey,
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      tileColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    );
  }
}
