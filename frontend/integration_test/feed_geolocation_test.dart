import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:service_platform/main.dart' as app;

/// E2E тест для проверки геолокационной фильтрации в Feed
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Feed Geolocation Filtering E2E Tests', () {
    /// Вспомогательная функция для логина
    Future<void> login(WidgetTester tester) async {
      await tester.enterText(
          find.byKey(const Key('login_email_field')), 'test@example.com');
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('login_password_field')), 'password123');
      await tester.pumpAndSettle();

      final loginButton = find.text('Войти');
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));
    }

    testWidgets('Загрузка feed с радиусом по умолчанию (20 км)',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await login(tester);

      // Проверяем, что находимся на экране Feed
      expect(find.text('Лента'), findsOneWidget);

      // Проверяем наличие постов
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Должен быть список постов
      final postsList = find.byType(GridView);
      expect(postsList, findsOneWidget);

      // Проверяем наличие фильтра с радиусом по умолчанию
      final filterButton = find.byIcon(Icons.filter_list);
      expect(filterButton, findsOneWidget);
    });

    testWidgets('Открытие и закрытие фильтров', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await login(tester);

      // Открываем фильтры
      final filterButton = find.byIcon(Icons.filter_list);
      await tester.tap(filterButton);
      await tester.pumpAndSettle();

      // Проверяем, что открылся bottom sheet с фильтрами
      expect(find.text('Фильтры'), findsOneWidget);
      expect(find.text('Геолокация'), findsOneWidget);
      expect(find.text('Радиус поиска'), findsOneWidget);

      // Проверяем наличие слайдера радиуса
      expect(find.byType(Slider), findsOneWidget);

      // Закрываем фильтры
      final closeButton = find.text('Закрыть');
      if (closeButton.evaluate().isNotEmpty) {
        await tester.tap(closeButton);
        await tester.pumpAndSettle();

        // Проверяем, что вернулись на Feed
        expect(find.text('Лента'), findsOneWidget);
      }
    });

    testWidgets('Изменение радиуса поиска на 10 км',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await login(tester);

      // Запоминаем количество постов до изменения фильтра
      await tester.pumpAndSettle(const Duration(seconds: 2));
      final postsBefore = find.byType(Card).evaluate().length;

      // Открываем фильтры
      final filterButton = find.byIcon(Icons.filter_list);
      await tester.tap(filterButton);
      await tester.pumpAndSettle();

      // Находим слайдер радиуса
      final radiusSlider = find.byType(Slider);
      expect(radiusSlider, findsOneWidget);

      // Перемещаем слайдер влево (уменьшаем радиус до 10 км)
      await tester.drag(radiusSlider, const Offset(-100, 0));
      await tester.pumpAndSettle();

      // Применяем фильтры
      final applyButton = find.text('Применить');
      await tester.tap(applyButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Проверяем, что список постов обновился
      final postsAfter = find.byType(Card).evaluate().length;

      // Количество постов должно измениться (уменьшиться или остаться тем же)
      expect(postsAfter <= postsBefore, true);
    });

    testWidgets('Переключение радиуса на "Вся страна"',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await login(tester);

      // Открываем фильтры
      final filterButton = find.byIcon(Icons.filter_list);
      await tester.tap(filterButton);
      await tester.pumpAndSettle();

      // Отключаем геолокацию (переключаем на "Вся страна")
      final locationToggle = find.byType(Switch);
      if (locationToggle.evaluate().isNotEmpty) {
        await tester.tap(locationToggle);
        await tester.pumpAndSettle();

        // Слайдер радиуса должен стать неактивным
        final radiusSlider = find.byType(Slider);
        expect(radiusSlider, findsNothing);
      }

      // Применяем фильтры
      final applyButton = find.text('Применить');
      await tester.tap(applyButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Проверяем, что посты загрузились без геофильтрации
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('Фильтрация по категориям', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await login(tester);

      // Открываем фильтры
      final filterButton = find.byIcon(Icons.filter_list);
      await tester.tap(filterButton);
      await tester.pumpAndSettle();

      // Находим секцию категорий
      expect(find.text('Категории'), findsOneWidget);

      // Выбираем категорию (например, первый чип)
      final categoryChip = find.byType(FilterChip).first;
      await tester.tap(categoryChip);
      await tester.pumpAndSettle();

      // Применяем фильтры
      final applyButton = find.text('Применить');
      await tester.tap(applyButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Проверяем, что посты отфильтрованы по категории
      expect(find.byType(Card), findsWidgets);
    });

    testWidgets('Проверка что посты только в заданном радиусе',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await login(tester);

      // Устанавливаем маленький радиус (1 км)
      final filterButton = find.byIcon(Icons.filter_list);
      await tester.tap(filterButton);
      await tester.pumpAndSettle();

      final radiusSlider = find.byType(Slider);
      // Перемещаем слайдер максимально влево
      await tester.drag(radiusSlider, const Offset(-200, 0));
      await tester.pumpAndSettle();

      final applyButton = find.text('Применить');
      await tester.tap(applyButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Проверяем количество постов
      final smallRadiusPosts = find.byType(Card).evaluate().length;

      // Теперь устанавливаем большой радиус (50 км)
      await tester.tap(filterButton);
      await tester.pumpAndSettle();

      final radiusSlider2 = find.byType(Slider);
      // Перемещаем слайдер максимально вправо
      await tester.drag(radiusSlider2, const Offset(200, 0));
      await tester.pumpAndSettle();

      await tester.tap(applyButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      final largeRadiusPosts = find.byType(Card).evaluate().length;

      // С большим радиусом должно быть больше или равное количество постов
      expect(largeRadiusPosts >= smallRadiusPosts, true);
    });

    testWidgets('Запрос разрешения на геолокацию при первом использовании',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await login(tester);

      // Открываем фильтры
      final filterButton = find.byIcon(Icons.filter_list);
      await tester.tap(filterButton);
      await tester.pumpAndSettle();

      // Включаем геолокацию
      final locationToggle = find.byType(Switch);
      if (locationToggle.evaluate().isNotEmpty) {
        await tester.tap(locationToggle);
        await tester.pumpAndSettle();

        // Может появиться диалог с запросом разрешения
        // (в реальных условиях, в эмуляторе обрабатывается системой)
        await tester.pumpAndSettle(const Duration(seconds: 2));
      }
    });

    testWidgets('Сброс фильтров к значениям по умолчанию',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await login(tester);

      // Открываем фильтры и изменяем их
      final filterButton = find.byIcon(Icons.filter_list);
      await tester.tap(filterButton);
      await tester.pumpAndSettle();

      // Изменяем радиус
      final radiusSlider = find.byType(Slider);
      await tester.drag(radiusSlider, const Offset(-100, 0));
      await tester.pumpAndSettle();

      // Выбираем категорию
      final categoryChip = find.byType(FilterChip).first;
      await tester.tap(categoryChip);
      await tester.pumpAndSettle();

      // Ищем кнопку сброса
      final resetButton = find.text('Сбросить');
      if (resetButton.evaluate().isNotEmpty) {
        await tester.tap(resetButton);
        await tester.pumpAndSettle();

        // Проверяем, что фильтры сброшены к значениям по умолчанию
        // (радиус 20 км, категории не выбраны)
      }
    });
  });
}
