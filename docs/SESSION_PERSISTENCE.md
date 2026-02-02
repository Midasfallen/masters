# Сохранение сессии (Session Persistence)

## Текущая реализация

### ✅ Токены сохраняются
Токены сохраняются в `FlutterSecureStorage` через `AuthRepository._storeTokens()`:
- `accessToken` - сохраняется в secure storage
- `refreshToken` - сохраняется в secure storage  
- `userId` - сохраняется в secure storage

### ✅ Auto-login работает
`AuthNotifier.build()` проверяет наличие токена и загружает пользователя:
```dart
@override
Future<AuthState> build() async {
  final repository = ref.watch(authRepositoryProvider);
  final isLoggedIn = await repository.isLoggedIn();

  if (isLoggedIn) {
    try {
      final user = await repository.getMe();
      return AuthState(user: user, isAuthenticated: true);
    } catch (e) {
      return const AuthState(isAuthenticated: false);
    }
  }

  return const AuthState(isAuthenticated: false);
}
```

### ✅ Interceptor добавляет токен
`AuthInterceptor` автоматически добавляет токен в заголовки запросов из secure storage.

## Проблема: Сессия не сохраняется после F5

### Возможные причины

1. **FlutterSecureStorage на Web**
   - На Web `FlutterSecureStorage` использует `localStorage` или `sessionStorage`
   - Может быть проблема с CORS или настройками безопасности браузера
   - Проверить: DevTools → Application → Local Storage

2. **Провайдеры не сохраняют состояние**
   - Riverpod провайдеры не сохраняют состояние между перезагрузками страницы
   - Это нормально - состояние должно восстанавливаться из secure storage

3. **SplashScreen не ждет загрузки**
   - `SplashScreen` может переходить на `/login` до того, как `AuthNotifier` успеет проверить токен
   - Проверить таймаут в `_checkAuthAndNavigate()`

## Решение

### Проверка 1: FlutterSecureStorage на Web

На Web `FlutterSecureStorage` использует `localStorage`. Проверить:
1. Открыть DevTools → Application → Local Storage
2. Найти ключи: `access_token`, `refresh_token`, `user_id`
3. Если ключи есть - проблема в логике проверки
4. Если ключей нет - проблема в сохранении

### Проверка 2: Таймаут в SplashScreen

`SplashScreen` ждет 2 секунды перед проверкой:
```dart
Future<void> _checkAuthAndNavigate() async {
  await Future.delayed(const Duration(seconds: 2));
  // ...
}
```

Это может быть недостаточно для загрузки токена из secure storage. Можно увеличить таймаут или дождаться загрузки `AuthNotifier`.

### Проверка 3: Логика проверки в SplashScreen

Текущая логика:
```dart
final authState = ref.read(authNotifierProvider);
final isAuthenticated = authState.value?.user != null;
```

Проблема: `ref.read()` не ждет загрузки провайдера. Нужно использовать `ref.watch()` или `await ref.read(authNotifierProvider.future)`.

## Рекомендуемое исправление

### Вариант 1: Ждать загрузки AuthNotifier
```dart
Future<void> _checkAuthAndNavigate() async {
  await Future.delayed(const Duration(seconds: 1));

  if (!mounted) return;

  // Ждем загрузки AuthNotifier
  final authState = await ref.read(authNotifierProvider.future);
  final isAuthenticated = authState.isAuthenticated;

  // ... остальная логика
}
```

### Вариант 2: Использовать ref.watch
```dart
@override
Widget build(BuildContext context) {
  final authState = ref.watch(authNotifierProvider);
  
  return authState.when(
    data: (state) {
      // Проверка и навигация
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateBasedOnAuth(state.isAuthenticated);
      });
      return _buildSplash();
    },
    loading: () => _buildSplash(),
    error: (_, __) => _buildSplash(),
  );
}
```

## Проверка работоспособности

1. **Залогиниться** в приложении
2. **Проверить DevTools** → Application → Local Storage → должны быть ключи токенов
3. **Нажать F5** для перезагрузки страницы
4. **Проверить** - должен автоматически залогиниться без ввода пароля

## Если проблема сохраняется

1. Проверить консоль браузера на ошибки
2. Проверить Network tab - должен быть запрос `/auth/me` или `/users/me` при старте
3. Проверить, что токены действительно сохраняются в localStorage
4. Проверить, что `AuthInterceptor` добавляет токен в заголовки

## Связанные файлы

- `frontend/lib/core/repositories/auth_repository.dart` - сохранение токенов
- `frontend/lib/core/providers/api/auth_provider.dart` - проверка токена при старте
- `frontend/lib/features/auth/screens/splash_screen.dart` - логика навигации
- `frontend/lib/core/api/api_interceptors.dart` - добавление токена в запросы
