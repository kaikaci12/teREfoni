import 'package:flutter/material.dart';
import 'package:frontend/utils/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';

import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final isAuth = context.watch<AuthProvider>().isAuthenticated;

    return Scaffold(
      body: Center(
        child: isAuth
            ? Text("Welcome to terefoni! You are logged in")
            : ElevatedButton(
                onPressed: () {
                  GoRouter.of(context).go("/account");
                },
                child: Text("Welcome to terefoni, go to account page"),
              ),
      ),
    );
  }
}
