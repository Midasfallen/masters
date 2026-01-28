// Базовый тест для Service Platform v2.0

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:service_platform/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Запускаем приложение с ProviderScope
    await tester.pumpWidget(
      const ProviderScope(
        child: ServicePlatformApp(),
      ),
    );

    // Ожидаем завершения таймеров splash screen
    await tester.pumpAndSettle(const Duration(seconds: 5));

    // Проверяем, что приложение запускается без ошибок
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
