import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:service_platform/features/feed/screens/feed_screen.dart';

void main() {
  group('FeedScreen', () {
    Future<void> pumpFeedScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(path: '/', builder: (context, state) => const FeedScreen()),
                GoRoute(path: '/post/:id', builder: (context, state) => const Placeholder()),
                GoRoute(path: '/search', builder: (context, state) => const Placeholder()),
                GoRoute(path: '/notifications', builder: (context, state) => const Placeholder()),
                GoRoute(path: '/create-post', builder: (context, state) => const Placeholder()),
              ],
              initialLocation: '/',
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    }

    testWidgets('renders feed screen with app bar', (tester) async {
      await pumpFeedScreen(tester);

      expect(find.byType(AppBar), findsOneWidget);
    });

    testWidgets('has action buttons in app bar', (tester) async {
      await pumpFeedScreen(tester);

      expect(find.byType(IconButton), findsWidgets);
    });

    testWidgets('renders without crash', (tester) async {
      await pumpFeedScreen(tester);

      expect(find.byType(ProviderScope), findsOneWidget);
    });
  });
}
