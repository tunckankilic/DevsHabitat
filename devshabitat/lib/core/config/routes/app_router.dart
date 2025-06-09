import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'route_names.dart';
import '../../../features/auth/presentation/pages/login_screen.dart';
import '../../../features/auth/presentation/pages/registration_wizard_page.dart';
import '../../../features/profile/presentation/screens/profile_view_screen.dart';
import '../../../features/splash/presentation/screens/splash_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (context, state) =>
            const ResponsiveLoginScreen(isLoading: false),
      ),
      GoRoute(
        path: RouteNames.register,
        builder: (context, state) => const RegistrationWizardPage(),
      ),
      GoRoute(
        path: RouteNames.profile,
        builder: (context, state) {
          final userId = state.uri.queryParameters['userId'];
          if (userId == null) {
            return const Scaffold(
              body: Center(
                child: Text('User ID is required'),
              ),
            );
          }
          return ProfileViewScreen(userId: userId);
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  );
}
