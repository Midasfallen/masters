import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/forgot_password_screen.dart';
import '../../features/auth/screens/reset_password_screen.dart';
import '../../features/feed/screens/post_detail_screen.dart';
import '../../features/chats/screens/chat_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/master/screens/master_profile_screen.dart';
import '../../features/master/screens/create_profile/create_master_profile_screen.dart';
import '../../features/friends/screens/friends_screen.dart';
import '../../features/subscriptions/screens/subscriptions_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../shared/widgets/main_navigation_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/splash', // Start with splash screen to check auth
    debugLogDiagnostics: true,
    routes: [
      // Auth routes
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password/:token',
        builder: (context, state) {
          final token = state.pathParameters['token']!;
          return ResetPasswordScreen(token: token);
        },
      ),

      // Main app route (v2.0 with bottom navigation)
      GoRoute(
        path: '/',
        builder: (context, state) => const MainNavigationScreen(),
        routes: [
          // Post detail
          GoRoute(
            path: 'post/:id',
            name: 'postDetail',
            builder: (context, state) {
              final postId = state.pathParameters['id']!;
              return PostDetailScreen(postId: postId);
            },
          ),

          // Chat
          GoRoute(
            path: 'chat/:id',
            name: 'chat',
            builder: (context, state) {
              final chatId = state.pathParameters['id']!;
              return ChatScreen(chatId: chatId);
            },
          ),

          // Notifications
          GoRoute(
            path: 'notifications',
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),

          // User profile
          GoRoute(
            path: 'user/:id',
            name: 'userProfile',
            builder: (context, state) {
              final userId = state.pathParameters['id']!;
              return Scaffold(
                appBar: AppBar(title: const Text('Profile')),
                body: Center(child: Text('User Profile: $userId')),
              );
            },
          ),

          // Master profile
          GoRoute(
            path: 'master/:id',
            name: 'masterProfile',
            builder: (context, state) {
              final masterId = state.pathParameters['id']!;
              return MasterProfileScreen(masterId: masterId);
            },
          ),

          // Friends
          GoRoute(
            path: 'friends',
            name: 'friends',
            builder: (context, state) => const FriendsScreen(),
          ),

          // Subscriptions
          GoRoute(
            path: 'subscriptions',
            name: 'subscriptions',
            builder: (context, state) => const SubscriptionsScreen(),
          ),

          // Create Master Profile
          GoRoute(
            path: 'create-master-profile',
            name: 'createMasterProfile',
            builder: (context, state) => const CreateMasterProfileScreen(),
          ),

          // Settings
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64),
            const SizedBox(height: 16),
            Text('Page not found: ${state.uri}'),
          ],
        ),
      ),
    ),
  );
});
