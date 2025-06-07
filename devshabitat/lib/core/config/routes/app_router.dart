import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      // TODO: Add routes
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const Scaffold(
          body: Center(
            child: Text('Splash Screen'),
          ),
        ),
      ),
    ],
  );
}
