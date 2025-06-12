import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../features/auth/presentation/pages/login_screen.dart';
import '../../../features/auth/presentation/pages/registration_wizard_page.dart';
import '../../../features/chat/presentation/screens/chat_screen.dart';
import '../../../features/chat/presentation/screens/conversation_list_screen.dart';
import '../../../features/community/presentation/screens/community_screen.dart';
import '../../../features/discovery/presentation/screens/discovery_screen.dart';
import '../../../features/profile/presentation/screens/profile_screen.dart';
import '../../../features/settings/presentation/screens/settings_screen.dart';
import '../../../features/splash/presentation/screens/splash_screen.dart';
import '../../../features/video/presentation/screens/video_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegistrationWizardPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => ConversationListScreen(),
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ChatScreen(
            conversationId: state.pathParameters['id']!,
            participantName: extra?['participantName'] as String? ?? '',
          );
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/discovery',
        builder: (context, state) => const DiscoveryScreen(),
      ),
      GoRoute(
        path: '/community',
        builder: (context, state) => const CommunityScreen(),
      ),
      GoRoute(
        path: '/video',
        builder: (context, state) => const VideoScreen(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text(
          'Page not found: ${state.uri.path}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    ),
  );
}
