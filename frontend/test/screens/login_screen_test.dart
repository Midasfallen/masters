import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:service_platform/features/auth/screens/login_screen.dart';

void main() {
  group('LoginScreen', () {
    Future<void> pumpLoginScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(path: '/', builder: (context, state) => const Placeholder()),
                GoRoute(path: '/role-selection', builder: (context, state) => const Placeholder()),
                GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
              ],
              initialLocation: '/login',
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
    }

    testWidgets('renders login form elements', (tester) async {
      await pumpLoginScreen(tester);

      expect(find.text('Вход'), findsAtLeast(1));
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('shows password visibility toggle', (tester) async {
      await pumpLoginScreen(tester);

      // LoginScreen использует visibility_outlined / visibility_off_outlined
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      await tester.tap(find.byIcon(Icons.visibility_outlined));
      await tester.pump();
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
    });

    testWidgets('validates empty fields without crash', (tester) async {
      await pumpLoginScreen(tester);

      await tester.tap(find.byType(FilledButton));
      await tester.pump();

      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('shows back navigation button', (tester) async {
      await pumpLoginScreen(tester);

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}
