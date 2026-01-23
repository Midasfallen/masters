import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:service_platform/main.dart' as app;

/// E2E тест для проверки потока авторизации и регистрации
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Authentication Flow E2E Tests', () {
    testWidgets('Успешная регистрация нового пользователя',
        (WidgetTester tester) async {
      // Запускаем приложение
      app.main();
      await tester.pumpAndSettle();

      // Находим кнопку "Регистрация" на экране логина
      final registerButton = find.text('Регистрация');
      expect(registerButton, findsOneWidget);

      // Переходим на экран регистрации
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Проверяем, что мы на экране регистрации
      expect(find.text('Создать аккаунт'), findsOneWidget);

      // Заполняем форму регистрации
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final email = 'test_user_$timestamp@example.com';
      final password = 'TestPassword123!';

      await tester.enterText(find.byKey(const Key('firstName_field')), 'Тест');
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('lastName_field')), 'Пользователь');
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('email_field')), email);
      await tester.pumpAndSettle();

      await tester.enterText(find.byKey(const Key('password_field')), password);
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('confirmPassword_field')), password);
      await tester.pumpAndSettle();

      // Нажимаем кнопку регистрации
      final submitButton = find.text('Зарегистрироваться');
      expect(submitButton, findsOneWidget);

      await tester.tap(submitButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Проверяем, что регистрация прошла успешно
      // Должны перейти на главный экран (Feed)
      expect(find.text('Лента'), findsOneWidget);
    });

    testWidgets('Успешный логин с валидными credentials',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Вводим существующие credentials
      await tester.enterText(
          find.byKey(const Key('login_email_field')), 'test@example.com');
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('login_password_field')), 'password123');
      await tester.pumpAndSettle();

      // Нажимаем кнопку входа
      final loginButton = find.text('Войти');
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Проверяем, что вошли в систему
      expect(find.text('Лента'), findsOneWidget);
    });

    testWidgets('Неудачный логин с неверными credentials',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Вводим неверные credentials
      await tester.enterText(
          find.byKey(const Key('login_email_field')), 'wrong@example.com');
      await tester.pumpAndSettle();

      await tester.enterText(
          find.byKey(const Key('login_password_field')), 'wrongpassword');
      await tester.pumpAndSettle();

      // Нажимаем кнопку входа
      final loginButton = find.text('Войти');
      await tester.tap(loginButton);
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Проверяем, что показывается ошибка
      expect(find.text('Неверный email или пароль'), findsOneWidget);
    });

    testWidgets('Валидация формы регистрации', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Переходим на экран регистрации
      final registerButton = find.text('Регистрация');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Пытаемся зарегистрироваться с пустыми полями
      final submitButton = find.text('Зарегистрироваться');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Проверяем, что показываются ошибки валидации
      expect(find.text('Введите имя'), findsOneWidget);
      expect(find.text('Введите фамилию'), findsOneWidget);
      expect(find.text('Введите email'), findsOneWidget);
      expect(find.text('Введите пароль'), findsOneWidget);
    });

    testWidgets('Проверка невалидного email', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      final registerButton = find.text('Регистрация');
      await tester.tap(registerButton);
      await tester.pumpAndSettle();

      // Вводим невалидный email
      await tester.enterText(
          find.byKey(const Key('email_field')), 'invalid-email');
      await tester.pumpAndSettle();

      final submitButton = find.text('Зарегистрироваться');
      await tester.tap(submitButton);
      await tester.pumpAndSettle();

      // Проверяем ошибку валидации email
      expect(find.text('Введите корректный email'), findsOneWidget);
    });

    testWidgets('Token refresh после истечения срока',
        (WidgetTester tester) async {
      // Этот тест требует моков для симуляции истечения токена
      // Пропускаем в базовой реализации
    }, skip: true);
  });
}
