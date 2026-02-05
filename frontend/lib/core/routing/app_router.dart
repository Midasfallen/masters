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
import '../../features/feed/screens/create_post_screen.dart';
import '../../features/chats/screens/chat_screen.dart';
import '../../features/notifications/screens/notifications_screen.dart';
import '../../features/master/screens/master_profile_screen.dart';
import '../../features/master/screens/create_profile/create_master_profile_screen.dart';
import '../../features/friends/screens/friends_screen.dart';
import '../../features/subscriptions/screens/subscriptions_screen.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../features/settings/screens/feedback_screen.dart';
import '../../features/settings/screens/help_screen.dart';
import '../../features/settings/screens/privacy_policy_screen.dart';
import '../../features/settings/screens/privacy_settings_screen.dart';
import '../../features/settings/screens/settings_screen.dart';
import '../../features/settings/screens/terms_screen.dart';
import '../../shared/widgets/main_navigation_screen.dart';
import '../../features/search/screens/category_services_screen.dart';
import '../../features/search/screens/service_masters_screen.dart';
import '../../features/search/screens/template_masters_screen.dart';

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

          // Create post
          GoRoute(
            path: 'create-post',
            name: 'createPost',
            builder: (context, state) => const CreatePostScreen(),
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
          // API теперь поддерживает поиск как по ID профиля мастера, так и по user_id
          GoRoute(
            path: 'master/:id',
            name: 'masterProfile',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              // API автоматически определит тип ID (master profile id или user_id)
              return MasterProfileScreen(masterId: id, isUserId: false);
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

          // Edit Profile
          GoRoute(
            path: 'edit-profile',
            name: 'editProfile',
            builder: (context, state) => const EditProfileScreen(),
          ),

          // Privacy Settings
          GoRoute(
            path: 'privacy-settings',
            name: 'privacySettings',
            builder: (context, state) => const PrivacySettingsScreen(),
          ),

          // Help
          GoRoute(
            path: 'help',
            name: 'help',
            builder: (context, state) => const HelpScreen(),
          ),

          // Feedback
          GoRoute(
            path: 'feedback',
            name: 'feedback',
            builder: (context, state) => const FeedbackScreen(),
          ),

          // Terms of Service
          GoRoute(
            path: 'terms',
            name: 'terms',
            builder: (context, state) => const TermsOfServiceScreen(),
          ),

          // Privacy Policy
          GoRoute(
            path: 'privacy-policy',
            name: 'privacyPolicy',
            builder: (context, state) => const PrivacyPolicyScreen(),
          ),

          // Settings
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),

          // Search - Category Services
          GoRoute(
            path: 'search/category/:id',
            name: 'categoryServices',
            builder: (context, state) {
              final categoryId = state.pathParameters['id']!;
              final extra = state.extra as Map<String, dynamic>?;
              final categoryName = extra?['categoryName'] as String? ?? 'Категория';
              return CategoryServicesScreen(
                categoryId: categoryId,
                categoryName: categoryName,
              );
            },
          ),

          // Search - Service Masters
          GoRoute(
            path: 'search/service/:id',
            name: 'serviceMasters',
            builder: (context, state) {
              final serviceId = state.pathParameters['id']!;
              final extra = state.extra as Map<String, dynamic>?;
              final serviceName = extra?['serviceName'] as String? ?? 'Услуга';
              final categoryId = extra?['categoryId'] as String? ?? '';
              return ServiceMastersScreen(
                serviceId: serviceId,
                serviceName: serviceName,
                categoryId: categoryId,
              );
            },
          ),

          // Search - Template Masters (по шаблону услуги)
          GoRoute(
            path: 'search/template/:slug',
            name: 'templateMasters',
            builder: (context, state) {
              final templateSlug = state.pathParameters['slug']!;
              final extra = state.extra as Map<String, dynamic>?;
              final templateName = extra?['templateName'] as String? ?? 'Услуга';
              final templateId = extra?['templateId'] as String? ?? '';
              final categoryId = extra?['categoryId'] as String? ?? '';
              return TemplateMastersScreen(
                templateId: templateId,
                templateSlug: templateSlug,
                templateName: templateName,
                categoryId: categoryId,
              );
            },
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
