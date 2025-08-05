import 'package:flutter/material.dart';
import 'package:frontend/l10n/app_localizations.dart';
import 'package:frontend/utils/providers/auth_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    // Check if the selected index is different to avoid unnecessary rebuilds and navigation
    if (_selectedIndex == index) return;

    // This is the correct place to handle navigation logic,
    // as it is a direct consequence of a user action.
    final isAuth = context.read<AuthProvider>().isAuthenticated;

    switch (index) {
      case 0:
        GoRouter.of(context).go('/');
        break;
      case 1:
        // You can add logic here if the orders page requires authentication
        // or a specific state.
        GoRouter.of(context).go('/orders');
        break;
      case 2:
        if (isAuth) {
          GoRouter.of(context).go('/profile');
        } else {
          // If not authenticated, navigate to a login page or handle accordingly.
          // For now, let's go to the account page anyway, but this is where you'd
          // add a redirection.
          GoRouter.of(context).go('/account');
        }
        break;
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    // We don't need to check authentication status here anymore
    // We get the value from the provider using context.watch and then
    // we manage it on the tap handler.

    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        // Use localization for Home label for consistency
        BottomNavigationBarItem(
          icon: const Icon(Icons.home_outlined),
          label: "",
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.shopping_bag_outlined),
          label: t.orders,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.person_outline),
          label: t.account,
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.grey,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
    );
  }
}
