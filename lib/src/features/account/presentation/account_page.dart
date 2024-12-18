import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../cubit/auth_cubit.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthCubit>().state as AuthLoggedIn).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Settings', style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.green,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        children: [
          UserHeader(
            name: user.name,
            email: user.email,
            avatarAsset:
                'assets/images/defaultPic.jpg', 
          ),

          const SizedBox(height: 20),

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
          SettingsSection(
            sectionTitle: "Booking Management",
            items: [
              SettingsListTile(
                title: "My Bookings",
                icon: Icons.bookmark_added,
                onTap: () {
                  Navigator.pushNamed(context, '/currentlybooked');
                },
              ),
              // SettingsListTile(
              //   title: "Booking History",
              //   icon: Icons.history,
              //   onTap: () {
              //     Navigator.pushNamed(context, '/bookinghistory');
              //   },
              // ),
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
                  Navigator.pushNamed(context, '/faqs');
                },
              ),
              SettingsListTile(
                title: "About Us",
                icon: Icons.info_outline,
                onTap: () {
                  Navigator.pushNamed(context, '/aboutUs');
                  // Add navigation logic for About Us
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
                          Navigator.of(context).pop(); // Close dialog
                          context.read<AuthCubit>().signOut();
                          Navigator.pushReplacementNamed(
                            context,
                            "/login",
                          ); // Navigate to Login
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
}

// User Header Widget
class UserHeader extends StatelessWidget {
  final String name;
  final String email;
  final String avatarAsset;

  const UserHeader({
    super.key,
    required this.name,
    required this.email,
    required this.avatarAsset,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipOval(
          child: Container(
            width: 80, // Diameter of the circle
            height: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(avatarAsset),
                fit: BoxFit.cover, // Ensures the image covers the entire circle
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          email,
          style: const TextStyle(fontSize: 14, color: Colors.black54),
        ),
      ],
    );
  }
}

// Section List Tile Widget
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
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

// Section Wrapper Widget
class SettingsSection extends StatelessWidget {
  final String sectionTitle;
  final List<SettingsListTile> items;

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
        const SizedBox(height: 12),
        Text(
          sectionTitle,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }
}
