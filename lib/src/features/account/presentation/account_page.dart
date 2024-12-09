import 'package:flutter/material.dart';

import '../../booking/presentation/booking_history.dart';
import '../../booking/presentation/booking_page.dart';
import '../../booking/presentation/currently_booked_page.dart';
import '../../owner/presentation/futsal_owner_settings_page.dart';
import 'change_password.dart';

class AccountPagePage extends StatefulWidget {
  const AccountPagePage({super.key});

  @override
  State<AccountPagePage> createState() => _AccountPagePageState();
}

class _AccountPagePageState extends State<AccountPagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings', style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        children: [
          // Header Section with Circle Avatar, Name, and Email
          const UserHeader(
            name: "John Doe",
            email: "john.doe@example.com",
            avatarUrl:
                "https://via.placeholder.com/150", // Replace with actual image URL
          ),
          const SizedBox(height: 20),

          // Section for Account Management
          SettingsSection(
            sectionTitle: "Account Management",
            items: [
              SettingsListTile(
                title: "Change Password",
                icon: Icons.lock_outline,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ChangePasswordPage(),
                    ),
                  );
                },
              ),
              SettingsListTile(
                title: "Logout",
                icon: Icons.logout,
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),

          // Section for Booking Management
          SettingsSection(
            sectionTitle: "Booking Management",
            items: [
              SettingsListTile(
                title: "My Bookings",
                icon: Icons.bookmark_added,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CurrentlyBookedPage(),
                    ),
                  );
                },
              ),
              SettingsListTile(
                title: "Book Futsal",
                icon: Icons.schedule,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ScheduleSlotsPage(),
                    ),
                  );
                },
              ),
              SettingsListTile(
                title: "Booking History",
                icon: Icons.history,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingHistoryPage(),
                    ),
                  );
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
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Confirm Logout',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Are you sure you want to log out?',
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop(); // Close the dialog
                          _logout(); // Log the user out
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Function to handle logout logic
  void _logout() {
    Navigator.pushReplacementNamed(
      context,
      "/login",
    ); // Example: Navigate to login screen
  }

  
}



