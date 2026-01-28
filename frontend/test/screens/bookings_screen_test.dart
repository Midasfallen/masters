import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:service_platform/features/bookings/screens/bookings_screen.dart';

void main() {
  group('BookingsScreen', () {
    Future<void> pumpBookingsScreen(WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp.router(
            routerConfig: GoRouter(
              routes: [
                GoRoute(path: '/bookings', builder: (context, state) => const BookingsScreen()),
                GoRoute(path: '/', builder: (context, state) => const Placeholder()),
              ],
              initialLocation: '/bookings',
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      await tester.pump(const Duration(milliseconds: 500));
    }

    testWidgets('renders bookings screen with title', (tester) async {
      await pumpBookingsScreen(tester);

      // AppBar title — "Записи"
      expect(find.text('Записи'), findsOneWidget);
    });

    testWidgets('shows tab bar', (tester) async {
      await pumpBookingsScreen(tester);

      expect(find.byType(TabBar), findsOneWidget);
    });

    testWidgets('shows client mode tabs by default', (tester) async {
      await pumpBookingsScreen(tester);

      expect(find.text('Предстоящие'), findsOneWidget);
      expect(find.text('История'), findsOneWidget);
    });
  });
}
