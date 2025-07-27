import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            GoRouter.of(context).go("/account");
          },
          child: Text("go to account page"),
        ),
      ),
    );
  }
}
