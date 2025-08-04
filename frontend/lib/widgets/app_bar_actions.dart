import 'package:flutter/material.dart';
import 'package:frontend/l10n/app_localizations.dart';

class AppBarActions extends StatelessWidget {
  const AppBarActions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Row(
      children: [
        // handle larger screen sizes later
        // Row(
        //   children: [
        //     Text(t.account, style: TextStyle()),
        //     SizedBox(width: 5),
        //     IconButton(
        //       icon: const Icon(Icons.person),
        //       onPressed: () {
        //         // Handle cart tap
        //       },
        //     ),
        //   ],
        // ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined),
          onPressed: () {
            // Handle cart tap
          },
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () {
            // Handle notification tap
          },
        ),
      ],
    );
  }
}
