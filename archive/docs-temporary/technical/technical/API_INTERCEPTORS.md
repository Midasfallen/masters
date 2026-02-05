# API Interceptors Documentation

## Обзор

Файл `api_interceptors.dart` содержит набор interceptor'ов для Dio HTTP клиента, которые обрабатывают различные аспекты API коммуникации: аутентификацию, обновление токенов, логирование, повторные попытки и обработку ошибок.

**Расположение**: `frontend/lib/core/api/api_interceptors.dart`

---

## 🔐 1. Auth Interceptor (Аутентификация)

### Назначение
Автоматически добавлять JWT токен доступа в заголовки всех API запросов.

### Функциональность

- Перехватывает исходящие запросы перед отправкой на сервер
- Проверяет, не является ли текущий запрос одним из auth endpoints (логин, регистрация, обновление токена)
- Если это обычный запрос, получает access token из защищённого хранилища (Flutter Secure Storage)
- Добавляет токен в заголовок `Authorization: Bearer {token}`
- Пропускает запрос дальше в цепь interceptor'ов

### Особенности

- Пропускает auth endpoints, чтобы избежать циклических зависимостей
- Работает с Flutter Secure Storage для безопасного хранения токенов
- Не вызывает ошибку, если токена нет (он может быть добавлен позже)

### Код

```dart
class AuthInterceptor extends Interceptor {
  final FlutterSecureStorage _storage;

  AuthInterceptor(this._storage);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Skip adding token for auth endpoints
    if (_isAuthEndpoint(options.path)) {
      return handler.next(options);
    }

    // Get access token from secure storage
    final accessToken = await _storage.read(key: AppConfig.accessTokenKey);

    if (accessToken != null) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    return handler.next(options);
  }

  bool _isAuthEndpoint(String path) {
    return path.contains(ApiEndpoints.authLogin) ||
        path.contains(ApiEndpoints.authRegister) ||
        path.contains(ApiEndpoints.authRefresh);
  }
}
```

---

## 🔄 2. Refresh Token Interceptor (Обновление токена)

### Назначение
Автоматически обновлять access token при его истечении (ошибка 401).

### Функциональность

- Перехватывает ошибки, полученные от сервера
- Проверяет, является ли ошибка типом 401 Unauthorized и не исходит ли от refresh endpoint'а
- При положительной проверке:
  - Использует mutex для предотвращения одновременных refresh запросов
  - Извлекает refresh token из защищённого хранилища
  - Отправляет запрос на обновление токена на сервер
  - Получает новые access и refresh токены из ответа
  - Сохраняет их в защищённом хранилище
  - Повторно отправляет оригинальный запрос с новым access token'ом
- Если обновление не удаётся, очищает все сохранённые токены и пропускает ошибку дальше

### Особенности

- ✅ **Race Condition Protection**: Использует mutex (`_refreshFuture`) для предотвращения одновременных refresh запросов
- Решает проблему истекших токенов прозрачно для пользователя
- Поддерживает случай, когда refresh token также истёк (требует повторной аутентификации)
- Сохраняет как access, так и refresh токены, если они обновлены на сервере

### Код

```dart
class RefreshTokenInterceptor extends Interceptor {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  // Mutex to prevent concurrent refresh token requests
  Future<String?>? _refreshFuture;

  RefreshTokenInterceptor(this._dio, this._storage);

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Check if error is 401 and not from refresh endpoint
    if (err.response?.statusCode == 401 &&
        !err.requestOptions.path.contains(ApiEndpoints.authRefresh)) {
      try {
        // Use mutex to prevent concurrent refresh requests
        final newToken = await _getOrRefreshToken();

        if (newToken != null) {
          // Retry original request with new token
          final options = err.requestOptions;
          options.headers['Authorization'] = 'Bearer $newToken';

          final response = await _dio.fetch(options);
          return handler.resolve(response);
        }
      } catch (e) {
        // Refresh failed, clear tokens
        await _clearTokens();
        _refreshFuture = null;
        return handler.next(err);
      }
    }

    return handler.next(err);
  }

  /// Get or refresh token with mutex to prevent concurrent requests
  Future<String?> _getOrRefreshToken() async {
    // If refresh is already in progress, wait for it
    if (_refreshFuture != null) {
      return await _refreshFuture;
    }

    // Start new refresh operation
    _refreshFuture = _refreshToken();

    try {
      final token = await _refreshFuture;
      return token;
    } finally {
      // Clear refresh future after completion
      _refreshFuture = null;
    }
  }
}
```

### Mutex Pattern

Метод `_getOrRefreshToken()` реализует паттерн mutex:
1. Если refresh уже выполняется (`_refreshFuture != null`), новые запросы ждут его завершения
2. Иначе создается новый Future для refresh операции
3. После завершения mutex очищается в блоке `finally`

---

## 📝 3. Logging Interceptor (Логирование)

### Назначение
Вывести детальную информацию о всех HTTP запросах, ответах и ошибках для отладки.

### Функциональность

**На запрос (onRequest):**
- Логирует метод и URI запроса
- Логирует все заголовки
- Логирует тело запроса, если оно есть
- Логирует query параметры, если они есть

**На ответ (onResponse):**
- Логирует HTTP статус код и URI
- Логирует тело ответа

**На ошибку (onError):**
- Логирует текст ошибки
- Логирует URI запроса
- Логирует HTTP статус код (если ответ был получен)
- Логирует тело ошибки

### Особенности

- Форматирует вывод в виде красиво оформленных блоков для улучшенной читаемости
- Использует `debugPrint()` для вывода в debug консоль Flutter
- Помогает быстро идентифицировать проблемы с API запросами
- **Работает только в debug режиме** (включается через `AppConfig.isDevelopment`)

### Пример вывода

```
┌──────────────────────────────────────────────────────────
│ REQUEST: POST http://localhost:3000/api/v2/auth/login
│ Headers: {Content-Type: application/json, Accept: application/json}
│ Data: {email: user@example.com, password: ******}
└──────────────────────────────────────────────────────────
```

---

## 🔁 4. Retry Interceptor (Повторные попытки)

### Назначение
Автоматически повторять неудачные запросы определённое количество раз с задержкой.

### Функциональность

- Перехватывает ошибки от сервера
- Проверяет, является ли ошибка "повторяемой" (connection timeout, send timeout, receive timeout, connection error)
- Отслеживает количество предыдущих попыток через `extra['retryCount']` в RequestOptions
- Если количество попыток не превышено:
  - Ждёт перед повтором с экспоненциальной задержкой (1s, 2s, 3s и т.д.)
  - Увеличивает счётчик попыток
  - Повторно отправляет запрос с использованием переданного Dio instance
- Если максимум попыток превышен, пропускает ошибку дальше

### Параметры (по умолчанию)

- `maxRetries: 3` - максимум 3 повтора
- `retryDelay: 1 секунда` - базовая задержка между попытками

### Особенности

- ✅ **Использует переданный Dio instance**: Сохраняет всю конфигурацию, interceptors и настройки
- Работает только с сетевыми ошибками (timeouts, connection errors)
- Не повторяет client ошибки (4xx) и server ошибки (5xx)
- Экспоненциальная задержка предотвращает перегрузку сервера

### Код

```dart
class RetryInterceptor extends Interceptor {
  final Dio _dio;
  final int maxRetries;
  final Duration retryDelay;

  RetryInterceptor(
    this._dio, {
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Only retry on connection errors
    if (!_shouldRetry(err)) {
      return handler.next(err);
    }

    final retryCount = err.requestOptions.extra['retryCount'] as int? ?? 0;

    if (retryCount >= maxRetries) {
      return handler.next(err);
    }

    // Wait before retrying (exponential backoff)
    await Future.delayed(retryDelay * (retryCount + 1));

    // Increment retry count
    err.requestOptions.extra['retryCount'] = retryCount + 1;

    try {
      // Retry using the same Dio instance with all configurations
      final response = await _dio.fetch(err.requestOptions);
      return handler.resolve(response);
    } catch (e) {
      return handler.next(err);
    }
  }

  bool _shouldRetry(DioException err) {
    return err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.sendTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.connectionError;
  }
}
```

---

## ⚠️ 5. Error Handler Interceptor (Обработка ошибок)

### Назначение
Преобразовать низкоуровневые Dio ошибки в кастомные API исключения приложения.

### Функциональность

- Перехватывает все ошибки `DioException`
- Использует `ApiExceptionHandler.handleDioError()` для преобразования ошибки
- На основе типа ошибки (timeout, network, 400, 401, 403, 404, 422, 500+) создаёт соответствующее кастомное исключение
- Обёртывает преобразованное исключение обратно в DioException и отправляет его дальше в обработчик ошибок

### Особенности

- Централизованная обработка всех ошибок API
- Преобразует низкоуровневые HTTP ошибки в бизнес-логику приложения
- Позволяет остальной код приложения работать с кастомными исключениями (`UnauthorizedException`, `ValidationException` и т.д.)

### Типы кастомных исключений

| HTTP Status | Exception Type | Описание |
|-------------|---------------|----------|
| 400 | `BadRequestException` | Некорректный запрос |
| 401 | `UnauthorizedException` | Не авторизован |
| 403 | `ForbiddenException` | Доступ запрещён |
| 404 | `NotFoundException` | Ресурс не найден |
| 422 | `ValidationException` | Ошибка валидации |
| 500+ | `ServerException` | Ошибка сервера |
| Timeout | `TimeoutException` | Превышено время ожидания |
| Network | `NetworkException` | Ошибка сети |

---

## 🔗 Порядок выполнения (цепь Interceptor'ов)

### При запросе:

1. **LoggingInterceptor** → логирует запрос (только в development)
2. **AuthInterceptor** → добавляет JWT токен
3. Запрос отправляется на сервер

### При ответе:

1. **LoggingInterceptor** → логирует ответ
2. Ответ передается в приложение

### При ошибке:

1. **RefreshTokenInterceptor** → проверяет 401 и обновляет токен если нужно
2. **RetryInterceptor** → повторяет запрос при сетевых ошибках
3. **ErrorHandlerInterceptor** → преобразует ошибки в кастомные исключения
4. **LoggingInterceptor** → логирует ошибку
5. Исключение передаётся в UI слой

---

## 📌 Интеграция с приложением

Все interceptor'ы регистрируются в Dio клиента при его инициализации в `dio_client.dart`:

```dart
@riverpod
Dio dio(DioRef ref) {
  final storage = ref.watch(secureStorageProvider);

  final dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      sendTimeout: AppConfig.sendTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add interceptors in order (ВАЖНО!)
  dio.interceptors.addAll([
    // 1. Logging (first to log everything)
    if (AppConfig.isDevelopment) LoggingInterceptor(),

    // 2. Auth (add JWT token to requests)
    AuthInterceptor(storage),

    // 3. Refresh token (handle 401 errors)
    RefreshTokenInterceptor(dio, storage),

    // 4. Retry (retry failed requests)
    RetryInterceptor(dio, maxRetries: 3, retryDelay: const Duration(seconds: 1)),

    // 5. Error handler (convert errors to custom exceptions)
    ErrorHandlerInterceptor(),
  ]);

  return dio;
}
```

**⚠️ ВАЖНО**: Порядок регистрации interceptor'ов критичен, так как он определяет последовательность обработки запросов и ответов!

---

## 🔧 Исправленные проблемы (21.01.2026)

### 1. RetryInterceptor - Потеря конфигурации при повторных запросах

**Проблема**: Создавал новый голый `Dio()` instance без конфигурации
```dart
// Было (НЕПРАВИЛЬНО):
final response = await Dio().fetch(err.requestOptions);
```

**Последствия**: Повторные запросы теряли:
- baseUrl конфигурацию
- Все interceptors (auth, logging, error handling)
- Таймауты и другие настройки

**Решение**: Передавать Dio instance в конструктор
```dart
// Стало (ПРАВИЛЬНО):
class RetryInterceptor extends Interceptor {
  final Dio _dio;  // ✅ Сохраняем ссылку на Dio

  RetryInterceptor(this._dio, {...});

  // Используем переданный instance
  final response = await _dio.fetch(err.requestOptions);
}
```

### 2. RefreshTokenInterceptor - Race Condition

**Проблема**: Несколько одновременных 401 ошибок вызывали множественные refresh запросы

**Последствия**:
- Перегрузка сервера множественными refresh запросами
- Потенциальная инвалидация токенов
- Непредсказуемое поведение

**Решение**: Добавлен mutex паттерн
```dart
// ✅ Mutex для синхронизации
Future<String?>? _refreshFuture;

Future<String?> _getOrRefreshToken() async {
  // Если refresh уже выполняется, ждем его
  if (_refreshFuture != null) {
    return await _refreshFuture;
  }

  // Иначе запускаем новый refresh
  _refreshFuture = _refreshToken();

  try {
    return await _refreshFuture;
  } finally {
    _refreshFuture = null;  // Очищаем mutex
  }
}
```

---

## 📚 Связанные файлы

- `frontend/lib/core/api/api_interceptors.dart` - Реализация interceptors
- `frontend/lib/core/api/dio_client.dart` - Конфигурация Dio клиента
- `frontend/lib/core/api/api_exceptions.dart` - Кастомные исключения
- `frontend/lib/core/api/api_endpoints.dart` - API endpoints
- `frontend/lib/core/config/app_config.dart` - Конфигурация приложения

---

## 🧪 Тестирование

### Проверка компиляции
```bash
cd frontend
flutter analyze lib/core/api/api_interceptors.dart
```

### Ожидаемый результат
```
No issues found!
```

---

## 📖 История изменений

### v2.1.0 (21.01.2026)
- ✅ Исправлен RetryInterceptor - теперь использует переданный Dio instance
- ✅ Исправлен RefreshTokenInterceptor - добавлена защита от race condition
- ✅ Обновлена документация с описанием исправлений

### v2.0.0 (Initial)
- ✅ Реализованы все 5 interceptors
- ✅ Интеграция с Flutter Secure Storage
- ✅ Поддержка JWT аутентификации

---

**Дата последнего обновления**: 21 января 2026
**Версия**: 2.1.0
**Статус**: ✅ Актуально
