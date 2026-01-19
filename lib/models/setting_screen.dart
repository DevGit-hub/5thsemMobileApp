import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:recipe_app/Utils/constants.dart';
import 'package:recipe_app/services/auth_service.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current user details
    final User? user = AuthService().currentUser;

    return Scaffold(
      backgroundColor: kbackgroundColor,
      appBar: AppBar(
        backgroundColor: kbackgroundColor,
        elevation: 0,
        centerTitle: true,
        title: const Text("Settings", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: kprimaryColor,
                    child: Icon(Iconsax.user, color: Colors.white, size: 30),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("My Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      // Display dynamic email
                      Text(user?.email ?? "No Email", style: TextStyle(color: Colors.grey.shade600, fontSize: 14)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Settings Options
            _buildSettingItem(icon: Iconsax.notification, title: "Notifications", onTap: () {}),
            _buildSettingItem(icon: Iconsax.language_square, title: "Language", trailing: "English", onTap: () {}),

            const SizedBox(height: 30),
            _buildSettingItem(icon: Iconsax.info_circle, title: "Help Center", onTap: () {}),

            // Logout Button
            _buildSettingItem(
              icon: Iconsax.logout,
              title: "Log Out",
              isDestructive: true,
              onTap: () async {
                await AuthService().signOut();
                // Main.dart stream will handle navigation back to Login
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    String? trailing,
    bool isDestructive = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: ListTile(
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isDestructive ? Colors.red.withOpacity(0.1) : kprimaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: isDestructive ? Colors.red : kprimaryColor),
        ),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: isDestructive ? Colors.red : Colors.black)),
        trailing: trailing != null
            ? Text(trailing, style: const TextStyle(color: Colors.grey, fontSize: 14))
            : const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}