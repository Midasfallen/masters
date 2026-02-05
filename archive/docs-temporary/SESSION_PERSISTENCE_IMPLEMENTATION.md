# Реализация сохранения сессии в браузере

## Проблема

После перезагрузки страницы (F5) пользователь выходил из системы и должен был заново вводить логин и пароль, хотя токены сохранялись в `FlutterSecureStorage`.

## Решение

### 1. Изменен SplashScreen для использования `ref.watch()`

**Файл:** `frontend/lib/features/auth/screens/splash_screen.dart`

**Изменения:**
- Используется `ref.watch(authNotifierProvider)` вместо `ref.read()` для реактивного отслеживания состояния
- Убрана фиксированная задержка в 2 секунды
- Навигация происходит только после загрузки состояния авторизации
- Добавлен флаг `_hasNavigated` для предотвращения множественных навигаций

**Код:**
```dart
@override
Widget build(BuildContext context) {
  // Watch auth state reactively - this will rebuild when state changes
  final authState = ref.watch(authNotifierProvider);

  // Handle navigation based on auth state
  authState.when(
    data: (state) {
      // Navigate after frame is built to avoid navigation during build
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _hasNavigated) return;
        _navigateBasedOnAuth(state.isAuthenticated);
      });
    },
    loading: () {
      // Show splash screen while loading
    },
    error: (error, stackTrace) {
      // On error, navigate to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _hasNavigated) return;
        _hasNavigated = true;
        context.go('/login');
      });
    },
  );
  // ...
}
```

### 2. Добавлена минимальная задержка для плавного перехода

**Файл:** `frontend/lib/core/providers/api/auth_provider.dart`

**Изменения:**
- Добавлена параллельная задержка в 500ms для плавного перехода
- Задержка выполняется параллельно с проверкой авторизации через `Future.wait()`
- Это предотвращает "моргание" splash screen при быстрой загрузке

**Код:**
```dart
@override
Future<AuthState> build() async {
  final repository = ref.watch(authRepositoryProvider);
  
  // Parallel execution: check auth and minimum delay for smooth transition
  final results = await Future.wait([
    _initializeAuth(repository),
    Future.delayed(const Duration(milliseconds: 500)), // Smooth transition delay
  ]);
  
  return results[0] as AuthState;
}
```

### 3. Улучшена обработка ошибок авторизации

**Файл:** `frontend/lib/core/providers/api/auth_provider.dart`

**Изменения:**
- При ошибке `getMe()` (например, 401) автоматически вызывается `repository.logout()`
- Это гарантирует, что токены очищаются при невалидном токене
- Возвращается `AuthState(isAuthenticated: false)` для корректной навигации

**Код:**
```dart
Future<AuthState> _initializeAuth(AuthRepository repository) async {
  final isLoggedIn = await repository.isLoggedIn();

  if (isLoggedIn) {
    try {
      final user = await repository.getMe();
      return AuthState(user: user, isAuthenticated: true);
    } catch (e) {
      // If getMe fails (e.g., 401), clear tokens and return unauthenticated
      await repository.logout();
      return const AuthState(isAuthenticated: false);
    }
  }

  return const AuthState(isAuthenticated: false);
}
```

### 4. Защита от множественных навигаций

**Файл:** `frontend/lib/features/auth/screens/splash_screen.dart`

**Изменения:**
- Добавлен флаг `_hasNavigated` для предотвращения повторных вызовов навигации
- Проверка флага выполняется перед каждой навигацией

## Проверка работоспособности

### Чек-лист перед запуском

- [x] Проверено, что `AuthNotifier.build()` помечен как `Future<AuthState>`
- [x] Убедились, что `FlutterSecureStorage` на Web инициализирован правильно (использует `localStorage`)
- [x] Проверено, что нет зацикливания навигации:
  - `/splash` → `/onboarding` (если `isFirstRun`)
  - `/splash` → `/` (если `isAuthenticated`)
  - `/splash` → `/login` (если не авторизован)
  - `/login` → `/` (при успешном логине)
  - `/login` не ведет обратно на `/splash` ✅

### Тестирование

1. **Залогиниться** в приложении
2. **Проверить DevTools** → Application → Local Storage:
   - Должны быть ключи: `access_token`, `refresh_token`, `user_id`
3. **Нажать F5** для перезагрузки страницы
4. **Проверить результат:**
   - Должен автоматически залогиниться без ввода пароля
   - Должен перейти на экран Feed (не на Login)
   - Splash screen должен показываться минимум 500ms для плавного перехода

## Обработка 401 ошибки

### Текущая реализация

**RefreshTokenInterceptor** (`frontend/lib/core/api/api_interceptors.dart`):
- При получении 401 ошибки пытается обновить токен через `refresh_token`
- Если refresh успешен - повторяет оригинальный запрос с новым токеном
- Если refresh неудачен - очищает токены через `_clearTokens()`

**AuthNotifier** (`frontend/lib/core/providers/api/auth_provider.dart`):
- При ошибке `getMe()` (например, 401 после неудачного refresh) автоматически вызывает `repository.logout()`
- Это гарантирует, что состояние авторизации обновляется корректно

### Автоматический logout при 401

Когда `RefreshTokenInterceptor` очищает токены после неудачного refresh:
1. Токены удаляются из `FlutterSecureStorage`
2. При следующем обращении к `AuthNotifier.build()` он видит, что токенов нет
3. Возвращается `AuthState(isAuthenticated: false)`
4. `SplashScreen` автоматически перенаправляет на `/login`

## FlutterSecureStorage на Web

На Web `FlutterSecureStorage` использует `localStorage` браузера. Это означает:
- Токены сохраняются между перезагрузками страницы
- Токены доступны только для текущего домена
- Токены не передаются между вкладками (если не используется `SharedPreferences`)

**Проверка:**
- DevTools → Application → Local Storage → `http://localhost:XXXX`
- Должны быть ключи: `access_token`, `refresh_token`, `user_id`

## Защита от зацикливания навигации

### Проверенные маршруты

- `/splash` → `/onboarding` (только если `isFirstRun`)
- `/splash` → `/` (только если `isAuthenticated`)
- `/splash` → `/login` (если не авторизован)
- `/login` → `/` (при успешном логине) ✅
- `/login` → `/splash` ❌ (не ведет обратно)

**Защита:**
- Флаг `_hasNavigated` предотвращает множественные вызовы навигации
- Навигация происходит только один раз при загрузке состояния

## Измененные файлы

1. ✅ `frontend/lib/features/auth/screens/splash_screen.dart`
   - Использование `ref.watch()` вместо `ref.read()`
   - Убрана фиксированная задержка
   - Добавлен флаг `_hasNavigated`

2. ✅ `frontend/lib/core/providers/api/auth_provider.dart`
   - Добавлена минимальная задержка 500ms для плавного перехода
   - Улучшена обработка ошибок в `_initializeAuth()`

## Результат

После исправления:
- ✅ Сессия сохраняется между перезагрузками страницы
- ✅ Автоматический логин работает корректно
- ✅ Плавный переход без "моргания" splash screen
- ✅ Корректная обработка 401 ошибок
- ✅ Нет зацикливания навигации

## Связанные документы

- `docs/SESSION_PERSISTENCE.md` - информация о сохранении сессии
- `docs/FEED_AND_SESSION_FIXES.md` - итоговое резюме исправлений
- `docs/BUGFIX_PLAN.md` - задача #14
