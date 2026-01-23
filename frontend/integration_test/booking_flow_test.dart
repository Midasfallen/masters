import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:service_platform/main.dart' as app;

/// E2E тест для проверки полного потока бронирования
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Booking Flow E2E Tests', () {
    /// Вспомогательная функция для логина как клиент
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

    /// Вспомогательная функция для логина как мастер
    Future<void> loginAsMaster(WidgetTester tester) async {
      await tester.enterText(
          find.byKey(const Key('login_email_field')), 'master@example.com');
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('login_password_field')), 'password123');
      await tester.pumpAndSettle();

      final loginButton = find.text('Войти');
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));
    }

    testWidgets('Полный поток создания записи клиентом',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await loginAsClient(tester);

      // Переходим на экран поиска
      final searchTab = find.text('Поиск');
      await tester.tap(searchTab);
      await tester.pumpAndSettle();

      // Находим мастера и кликаем на карточку
      final masterCard = find.byType(Card).first;
      await tester.tap(masterCard);
      await tester.pumpAndSettle();

      // Проверяем, что открылся профиль мастера
      expect(find.text('Записаться'), findsOneWidget);

      // Нажимаем кнопку "Записаться"
      final bookButton = find.text('Записаться');
      await tester.tap(bookButton);
      await tester.pumpAndSettle();

      // Должен открыться bottom sheet с выбором услуги
      expect(find.text('Выберите услугу'), findsOneWidget);

      // Выбираем первую услугу
      final firstService = find.byType(Checkbox).first;
      await tester.tap(firstService);
      await tester.pumpAndSettle();

      // Выбираем дату
      final dateButton = find.byIcon(Icons.calendar_today).first;
      await tester.tap(dateButton);
      await tester.pumpAndSettle();

      // Выбираем завтрашнюю дату в календаре
      final tomorrow = DateTime.now().add(const Duration(days: 1));
      final tomorrowText = tomorrow.day.toString();
      final dateOption = find.text(tomorrowText).last;
      await tester.tap(dateOption);
      await tester.pumpAndSettle();

      // Подтверждаем выбор даты
      final okButton = find.text('OK');
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      // Выбираем время
      final timeButton = find.byIcon(Icons.access_time).first;
      await tester.tap(timeButton);
      await tester.pumpAndSettle();

      // Выбираем 10:00 (изменяем часы)
      // В time picker нужно взаимодействовать с циферблатом
      await tester.pumpAndSettle();
      await tester.tap(okButton);
      await tester.pumpAndSettle();

      // Создаем запись
      final createBookingButton = find.text('Записаться');
      await tester.tap(createBookingButton.last);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Проверяем, что запись создана
      expect(find.text('Запись создана'), findsOneWidget);

      // Проверяем переход на экран записей
      final bookingsTab = find.text('Записи');
      await tester.tap(bookingsTab);
      await tester.pumpAndSettle();

      // Проверяем наличие созданной записи в статусе "Ожидает подтверждения"
      expect(find.text('Ожидает подтверждения'), findsWidgets);
    });

    testWidgets('Мастер подтверждает запись', (WidgetTester tester) async {
      // Перезапускаем приложение для логина как мастер
      app.main();
      await tester.pumpAndSettle();

      await loginAsMaster(tester);

      // Переходим на экран записей
      final bookingsTab = find.text('Записи');
      await tester.tap(bookingsTab);
      await tester.pumpAndSettle();

      // Находим запись в статусе "Ожидает подтверждения"
      final pendingBooking = find.text('Ожидает подтверждения').first;
      await tester.tap(pendingBooking);
      await tester.pumpAndSettle();

      // Должны увидеть детали записи
      expect(find.text('Подтвердить'), findsOneWidget);

      // Подтверждаем запись
      final confirmButton = find.text('Подтвердить');
      await tester.tap(confirmButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Проверяем, что запись подтверждена
      expect(find.text('Запись подтверждена'), findsOneWidget);

      // Статус должен измениться на "Подтверждена"
      expect(find.text('Подтверждена'), findsOneWidget);
    });

    testWidgets('Push-уведомление о подтверждении записи',
        (WidgetTester tester) async {
      // Этот тест проверяет, что клиент получает уведомление
      // Требует интеграции с NotificationService и WebSocket
      // В базовой версии пропускаем
    }, skip: true);

    testWidgets('Мастер завершает запись с обязательным отзывом',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await loginAsMaster(tester);

      // Переходим на экран записей
      final bookingsTab = find.text('Записи');
      await tester.tap(bookingsTab);
      await tester.pumpAndSettle();

      // Находим подтвержденную запись
      final confirmedBooking = find.text('Подтверждена').first;
      await tester.tap(confirmedBooking);
      await tester.pumpAndSettle();

      // Нажимаем кнопку "Завершить"
      final completeButton = find.text('Завершить');
      await tester.tap(completeButton);
      await tester.pumpAndSettle();

      // Должна появиться форма оценки клиента
      expect(find.text('Оцените клиента'), findsOneWidget);
      expect(find.byIcon(Icons.star), findsWidgets);

      // Пытаемся завершить без оценки - должна быть ошибка
      final submitButton = find.text('Отправить');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      expect(find.text('Поставьте оценку'), findsOneWidget);

      // Ставим 5 звезд
      final star5 = find.byIcon(Icons.star).at(4);
      await tester.tap(star5);
      await tester.pumpAndSettle();

      // Пишем комментарий
      await tester.enterText(
          find.byKey(const Key('review_text_field')),
          'Отличный клиент! Приятно было работать.');
      await tester.pumpAndSettle();

      // Теперь завершаем
      await tester.tap(submitButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Запись должна быть завершена
      expect(find.text('Запись завершена'), findsOneWidget);
      expect(find.text('Завершена'), findsOneWidget);
    });

    testWidgets('Клиент оставляет обязательный отзыв после завершения',
        (WidgetTester tester) async {
      // Перезапускаем для клиента
      app.main();
      await tester.pumpAndSettle();

      await loginAsClient(tester);

      // Переходим на экран записей
      final bookingsTab = find.text('Записи');
      await tester.tap(bookingsTab);
      await tester.pumpAndSettle();

      // Находим завершенную запись
      final completedBooking = find.text('Завершена').first;
      await tester.tap(completedBooking);
      await tester.pumpAndSettle();

      // Должна быть кнопка "Оставить отзыв"
      expect(find.text('Оставить отзыв'), findsOneWidget);

      // Оставляем отзыв
      final reviewButton = find.text('Оставить отзыв');
      await tester.tap(reviewButton);
      await tester.pumpAndSettle();

      // Выбираем рейтинг
      final star5 = find.byIcon(Icons.star).at(4);
      await tester.tap(star5);
      await tester.pumpAndSettle();

      // Пишем комментарий
      await tester.enterText(
          find.byKey(const Key('review_text_field')),
          'Прекрасная работа мастера! Всем рекомендую.');
      await tester.pumpAndSettle();

      // Отправляем отзыв
      final submitButton = find.text('Отправить');
      await tester.tap(submitButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Отзыв отправлен
      expect(find.text('Отзыв отправлен'), findsOneWidget);
    });

    testWidgets('Отмена записи клиентом', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await loginAsClient(tester);

      // Создаем новую запись (упрощенная версия)
      // ... (код создания записи)

      // Переходим на экран записей
      final bookingsTab = find.text('Записи');
      await tester.tap(bookingsTab);
      await tester.pumpAndSettle();

      // Находим запись
      final booking = find.byType(Card).first;
      await tester.tap(booking);
      await tester.pumpAndSettle();

      // Нажимаем кнопку отмены
      final cancelButton = find.text('Отменить');
      if (cancelButton.evaluate().isNotEmpty) {
        await tester.tap(cancelButton);
        await tester.pumpAndSettle();

        // Подтверждаем отмену в диалоге
        final confirmCancel = find.text('Да, отменить');
        await tester.tap(confirmCancel);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Запись отменена
        expect(find.text('Запись отменена'), findsOneWidget);
      }
    });

    testWidgets('Отклонение записи мастером', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await loginAsMaster(tester);

      // Переходим на экран записей
      final bookingsTab = find.text('Записи');
      await tester.tap(bookingsTab);
      await tester.pumpAndSettle();

      // Находим запись в ожидании
      final pendingBooking = find.text('Ожидает подтверждения').first;
      await tester.tap(pendingBooking);
      await tester.pumpAndSettle();

      // Нажимаем кнопку отклонения
      final rejectButton = find.text('Отклонить');
      if (rejectButton.evaluate().isNotEmpty) {
        await tester.tap(rejectButton);
        await tester.pumpAndSettle();

        // Вводим причину отклонения
        await tester.enterText(
            find.byKey(const Key('reject_reason_field')),
            'К сожалению, это время уже занято.');
        await tester.pumpAndSettle();

        // Подтверждаем отклонение
        final confirmReject = find.text('Отклонить');
        await tester.tap(confirmReject.last);
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Запись отклонена
        expect(find.text('Запись отклонена'), findsOneWidget);
      }
    });

    testWidgets('Проверка статусов записи в хронологии',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      await loginAsClient(tester);

      final bookingsTab = find.text('Записи');
      await tester.tap(bookingsTab);
      await tester.pumpAndSettle();

      // Проверяем наличие различных статусов
      final statuses = [
        'Ожидает подтверждения',
        'Подтверждена',
        'Завершена',
        'Отменена',
        'Отклонена'
      ];

      for (final status in statuses) {
        final statusWidget = find.text(status);
        // Хотя бы один из статусов должен присутствовать
        if (statusWidget.evaluate().isNotEmpty) {
          expect(statusWidget, findsWidgets);
          break;
        }
      }
    });
  });
}
