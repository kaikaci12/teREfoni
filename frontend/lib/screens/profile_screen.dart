import 'package:flutter/material.dart';

import 'package:frontend/utils/http/auth/logout_user.dart';
import 'package:go_router/go_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  void handleLogout(BuildContext context) async {
    try {
      final response = await logoutUser(context, "api/auth/logout");
      debugPrint(response["message"]);
      GoRoute(path: "/");
    } catch (e) {
      debugPrint(e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Logout failed: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () => handleLogout(context),
          ),
        ],
      ),
      body: const Center(child: Text("Profile")),
    );
  }
}
