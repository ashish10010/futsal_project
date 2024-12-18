import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_booking_app/cubit/auth_cubit.dart';

class OwnerAccountPage extends StatefulWidget {
  const OwnerAccountPage({super.key});

  @override
  State<OwnerAccountPage> createState() => _OwnerAccountPageState();
}

class _OwnerAccountPageState extends State<OwnerAccountPage> {
  // final UserService _userService = UserService();
  // String ownerName = "Loading...";
  // String ownerEmail = "Loading...";

  // @override
  // void initState() {
  //   super.initState();
  //   _fetchOwnerDetails();
  // }

  // Fetch owner name and email
  // Future<void> _fetchOwnerDetails() async {
  //   try {
  //     final userData = await _userService.fetchCurrentUser();
  //     setState(() {
  //       ownerName = userData.name;
  //       ownerEmail = userData.email;
  //     });
  //   } catch (e) {
  //     setState(() {
  //       ownerName = "Error";
  //       ownerEmail = "Unable to load";
  //     });
  //   }
  // }

  // Logout function
  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Logout"),
        content: const Text("Are you sure you want to log out?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<AuthCubit>().signOut(); // Logout via AuthCubit
              Navigator.pushNamedAndRemoveUntil(
                  context, "/login", (route) => false);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Logout", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = (context.read<AuthCubit>().state as AuthLoggedIn).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Owner Account', style: TextStyle(fontSize: 20)),
        backgroundColor: Colors.teal[400],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        children: [
          // User Profile Section
          UserHeader(
            name: user.name,
            email: user.email,
            avatarAsset: 'assets/images/defaultPic.jpg',
          ),
          const SizedBox(height: 20),

          // Manage Futsal Courts Section
          SettingsSection(
            sectionTitle: "Manage Futsal Courts",
            items: [
              SettingsListTile(
                title: "Add Futsal Court",
                icon: Icons.add,
                onTap: () {
                  Navigator.pushNamed(context, '/addFutsal');
                },
              ),
              SettingsListTile(
                title: "View/Edit Futsal Courts",
                icon: Icons.edit,
                onTap: () {
                  Navigator.pushNamed(context, '/viewFutsalDetails');
                },
              ),
            ],
          ),
          // Account Management Section
          SettingsSection(
            sectionTitle: "Account Management",
            items: [
              SettingsListTile(
                title: "Logout",
                icon: Icons.logout,
                onTap: _logout,
              ),
            ],
          ),

          // App Information Section (FAQs and About Us)
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
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

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
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(avatarAsset),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          name,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
      leading: Icon(icon, color: Colors.teal),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}

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
            color: Colors.teal,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(children: items),
        ),
      ],
    );
  }
}
