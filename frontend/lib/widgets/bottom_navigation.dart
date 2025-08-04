import 'package:flutter/material.dart';
import 'package:frontend/l10n/app_localizations.dart';

class BottomNavigationWidget extends StatefulWidget {
  const BottomNavigationWidget({super.key});

  @override
  State<BottomNavigationWidget> createState() => _BottomNavigationWidgetState();
}

class _BottomNavigationWidgetState extends State<BottomNavigationWidget> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),

        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          label: t.orders,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          label: t.account,
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.black, // Color for the selected icon/label
      unselectedItemColor: Colors.grey, // Color for unselected icons/labels
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed, // Ensures all items are visible
    );
  }
}
