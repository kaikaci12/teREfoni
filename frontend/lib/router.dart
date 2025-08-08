import 'package:flutter/material.dart';
import 'package:frontend/layout/layout_scaffold.dart';
import 'package:frontend/screens/auth/auth_screen.dart';
import 'package:frontend/screens/home_screen.dart';
import 'package:frontend/screens/orders_screen.dart';
import 'package:frontend/screens/profile_screen.dart';
import 'package:frontend/screens/wishlists_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:frontend/utils/providers/auth_provider.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: "/",

  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          LayoutScaffold(navigationShell: navigationShell),
      branches: [
        // Branch 1: Home
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/', builder: (context, state) => const HomeScreen()),
          ],
        ),
        // Branch 2: Orders
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/orders',
              builder: (context, state) => const OrdersScreen(),
            ),
          ],
        ),
        // Branch 3: Wishlists
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/wishlists',
              builder: (context, state) => const WishlistsScreen(),
            ),
          ],
        ),
        // Branch 4: Account/Profile
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/account',
              builder: (context, state) => const AuthScreen(),
              redirect: (context, state) {
                // If the user is authenticated, redirect them to the profile page.
                final isAuth = context.read<AuthProvider>().isAuthenticated;

                debugPrint("user logged in:  $isAuth");

                if (isAuth) {
                  return '/profile';
                }
                // Otherwise, allow them to go to the account page (AuthScreen).
                return null;
              },
            ),
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
              redirect: (context, state) {
                // If the user is not authenticated, redirect them to the account page.
                final isAuth = context.read<AuthProvider>().isAuthenticated;
                debugPrint("user logged in:  $isAuth");
                if (!isAuth) {
                  return '/account';
                }
                // Otherwise, allow them to go to the profile page.
                return null;
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
