// lib/screens/splash_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend/utils/providers/auth_provider.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  void _redirect(BuildContext context) {
    final authProvider = context.read<AuthProvider>();
    if (!authProvider.isLoading) {
      // Once we are no longer initializing, go to the appropriate route
      if (authProvider.isAuthenticated) {
        GoRouter.of(context).go('/profile');
      } else {
        GoRouter.of(context).go('/account');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // We use a listener to call the redirect function as soon as initialization is complete
    context.watch<AuthProvider>();
    _redirect(context);

    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
