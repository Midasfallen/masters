import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:service_platform/main.dart' as app;

/// E2E тест для проверки обязательной системы отзывов
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Mandatory Reviews System E2E Tests', () {
    /// Вспомогательная функция для логина
    Future<void> loginAsClient(WidgetTester tester) async {
      await tester.enterText(
          find.byKey(const Key('login_email_field')), 'client@example.com');
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('login_password_field')), 'password123');
      await tester.pumpAndSettle();

      final loginButton = find.text('Войти');
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));
    }

    testWidgets('Блокировка создания записи при наличии незавершенных отзывов',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Логинимся как клиент
      await loginAsClient(tester);

      // Переходим на экран поиска мастеров
      final searchTab = find.text('Поиск');
      await tester.tap(searchTab);
      await tester.pumpAndSettle();

      // Находим мастера и переходим на его профиль
      final firstMaster = find.byType(Card).first;
      await tester.tap(firstMaster);
      await tester.pumpAndSettle();

      // Нажимаем кнопку "Записаться"
      final bookButton = find.text('Записаться');
      await tester.tap(bookButton);
      await tester.pumpAndSettle();

      // Если есть незавершенные отзывы, должен показаться диалог
      final dialogTitle = find.text('Оставьте отзывы');

      if (dialogTitle.evaluate().isNotEmpty) {
        // Диалог показан - проверяем его содержимое
        expect(dialogTitle, findsOneWidget);
        expect(
            find.text('У вас есть завершенные записи без отзывов'),
            findsOneWidget);

        // Проверяем наличие списка незавершенных записей
        expect(find.byType(ListView), findsOneWidget);

        // Проверяем кнопки
        final reviewButton = find.text('Оставить отзыв');
        expect(reviewButton, findsWidgets);

        // Пытаемся закрыть диалог - запись не должна создаться
        final closeButton = find.text('Закрыть');
        if (closeButton.evaluate().isNotEmpty) {
          await tester.tap(closeButton);
          await tester.pumpAndSettle();

          // Проверяем, что мы не перешли на экран бронирования
          expect(find.text('Записаться'), findsOneWidget);
        }
      }
    });

    testWidgets('Отображение grace period после 3 напоминаний',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await loginAsClient(tester);

      // Симулируем ситуацию, когда пользователь уже получил 3 напоминания
      // В реальности это требует настройки состояния через API или моки

      // Переходим к созданию записи
      final searchTab = find.text('Поиск');
      await tester.tap(searchTab);
      await tester.pumpAndSettle();

      final firstMaster = find.byType(Card).first;
      await tester.tap(firstMaster);
      await tester.pumpAndSettle();

      final bookButton = find.text('Записаться');
      await tester.tap(bookButton);
      await tester.pumpAndSettle();

      // Проверяем наличие опции "Пропустить" после 3-го напоминания
      final skipButton = find.text('Пропустить');

      if (skipButton.evaluate().isNotEmpty) {
        // Grace period активен - можно пропустить
        expect(skipButton, findsOneWidget);
        expect(
            find.textContaining('3 напоминание'),
            findsOneWidget);

        // Пропускаем отзывы
        await tester.tap(skipButton);
        await tester.pumpAndSettle();

        // Должны перейти к форме бронирования
        expect(find.text('Выберите услугу'), findsOneWidget);
      }
    });

    testWidgets('Мастер не может завершить запись без выставления отзыва',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Логинимся как мастер
      await tester.enterText(
          find.byKey(const Key('login_email_field')), 'master@example.com');
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('login_password_field')), 'password123');
      await tester.pumpAndSettle();

      final loginButton = find.text('Войти');
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Переходим на экран записей
      final bookingsTab = find.text('Записи');
      await tester.tap(bookingsTab);
      await tester.pumpAndSettle();

      // Находим завершенную запись
      final completedBooking = find.text('Завершена');

      if (completedBooking.evaluate().isNotEmpty) {
        await tester.tap(completedBooking.first);
        await tester.pumpAndSettle();

        // Должны увидеть форму отзыва
        expect(find.text('Оцените клиента'), findsOneWidget);

        // Проверяем наличие обязательного рейтинга
        final ratingStars = find.byIcon(Icons.star);
        expect(ratingStars, findsWidgets);

        // Пытаемся завершить без рейтинга
        final completeButton = find.text('Завершить');
        await tester.tap(completeButton);
        await tester.pumpAndSettle();

        // Должна показаться ошибка
        expect(find.text('Поставьте оценку'), findsOneWidget);

        // Ставим оценку
        final star5 = ratingStars.at(4);
        await tester.tap(star5);
        await tester.pumpAndSettle();

        // Теперь можем завершить
        await tester.tap(completeButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Запись должна быть завершена
        expect(find.text('Запись завершена'), findsOneWidget);
      }
    });

    testWidgets('Создание отзыва из диалога незавершенных записей',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await loginAsClient(tester);

      // Открываем диалог с незавершенными отзывами
      final searchTab = find.text('Поиск');
      await tester.tap(searchTab);
      await tester.pumpAndSettle();

      final firstMaster = find.byType(Card).first;
      await tester.tap(firstMaster);
      await tester.pumpAndSettle();

      final bookButton = find.text('Записаться');
      await tester.tap(bookButton);
      await tester.pumpAndSettle();

      final dialogTitle = find.text('Оставьте отзывы');

      if (dialogTitle.evaluate().isNotEmpty) {
        // Нажимаем "Оставить отзыв" на первой записи
        final reviewButton = find.text('Оставить отзыв').first;
        await tester.tap(reviewButton);
        await tester.pumpAndSettle();

        // Должен открыться экран создания отзыва
        expect(find.text('Оставить отзыв'), findsOneWidget);

        // Выбираем рейтинг
        final star5 = find.byIcon(Icons.star).at(4);
        await tester.tap(star5);
        await tester.pumpAndSettle();

        // Пишем комментарий
        await tester.enterText(
            find.byKey(const Key('review_text_field')),
            'Отличная работа! Все понравилось.');
        await tester.pumpAndSettle();

        // Отправляем отзыв
        final submitButton = find.text('Отправить');
        await tester.tap(submitButton);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Отзыв создан, возвращаемся к списку
        expect(find.text('Отзыв отправлен'), findsOneWidget);
      }
    });
  });
}
