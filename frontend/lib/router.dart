import 'package:flutter/material.dart';
import 'package:frontend/layout/layout_scaffold.dart';
import 'package:frontend/screens/auth/auth_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/orders_screen.dart';
import 'package:frontend/screens/profile_screen.dart';
import 'package:go_router/go_router.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: "/",
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          LayoutScaffold(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => HomeScreen()),
            GoRoute(
              path: "/account",
              builder: (context, state) => AuthScreen(),
            ),
            GoRoute(
              path: "/orders",
              builder: (context, state) => OrdersScreen(),
            ),

            GoRoute(
              path: "/profile",
              builder: (context, state) => ProfileScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
