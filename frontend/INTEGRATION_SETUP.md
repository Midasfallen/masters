# Flutter Backend Integration Setup Guide

## После интеграции выполните следующие шаги:

### 1. Установите зависимости
```bash
cd frontend
flutter pub get
```

### 2. Запустите code generation
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Эта команда сгенерирует все необходимые файлы:
- `*.g.dart` - JSON serialization
- `*.freezed.dart` - Freezed models
- Provider files

### 3. Настройте API базовый URL

Откройте `lib/core/config/app_config.dart` и измените `apiBaseUrl`:
```dart
static const String apiBaseUrl = 'http://localhost:8000'; // для локальной разработки
// static const String apiBaseUrl = 'https://your-api.com'; // для production
```

### 4. Тестирование API

Пример использования Auth:
```dart
// В вашем виджете
final authNotifier = ref.read(authNotifierProvider.notifier);

// Login
await authNotifier.login('email@example.com', 'password');

// Register
await authNotifier.register(
  email: 'email@example.com',
  password: 'password',
  firstName: 'John',
  lastName: 'Doe',
);
```

## Структура интеграции

### API Layer
- `lib/core/config/app_config.dart` - Конфигурация API
- `lib/core/api/api_endpoints.dart` - Все endpoints
- `lib/core/api/api_exceptions.dart` - Custom exceptions
- `lib/core/api/api_interceptors.dart` - JWT, Refresh, Error handling
- `lib/core/api/dio_client.dart` - Dio HTTP client

### Models
- `lib/core/models/api/user_model.dart` - User + Auth
- `lib/core/models/api/master_model.dart` - Master Profile
- `lib/core/models/api/service_model.dart` - Services
- `lib/core/models/api/booking_model.dart` - Bookings
- `lib/core/models/api/review_model.dart` - Reviews
- `lib/core/models/api/post_model.dart` - Posts (v2.0)
- `lib/core/models/api/chat_model.dart` - Chats
- `lib/core/models/api/message_model.dart` - Messages (встроен в chat_model)

### Repositories
- `lib/core/repositories/auth_repository.dart` - Auth operations
- `lib/core/repositories/user_repository.dart` - User CRUD
- `lib/core/repositories/master_repository.dart` - Master operations
- `lib/core/repositories/booking_repository.dart` - Booking management
- `lib/core/repositories/search_repository.dart` - Search masters/services
- `lib/core/repositories/post_repository.dart` - Social feed (v2.0)
- `lib/core/repositories/chat_repository.dart` - Chat/messaging

### Providers (Riverpod)
- `lib/core/providers/api/auth_provider.dart` - Auth state
- `lib/core/providers/api/user_provider.dart` - User state
- `lib/core/providers/api/masters_provider.dart` - Masters list/detail
- `lib/core/providers/api/bookings_provider.dart` - Bookings management
- `lib/core/providers/api/feed_provider.dart` - Posts feed (v2.0)
- `lib/core/providers/api/chats_provider.dart` - Chats/messages

## Примеры использования

### Authentication
```dart
// Login
final authNotifier = ref.read(authNotifierProvider.notifier);
await authNotifier.login(email, password);

// Get current user
final currentUser = ref.watch(currentUserProvider);

// Logout
await authNotifier.logout();
```

### Masters
```dart
// Get masters list
final masters = ref.watch(mastersListProvider());

// Get master by ID
final master = ref.watch(masterByIdProvider('master_id'));

// Create master profile
final masterNotifier = ref.read(masterNotifierProvider.notifier);
await masterNotifier.createProfile(request);
```

### Bookings
```dart
// Get my bookings
final bookings = ref.watch(myBookingsProvider());

// Create booking
final bookingNotifier = ref.read(bookingNotifierProvider.notifier);
await bookingNotifier.createBooking(request);

// Confirm booking (master)
await bookingNotifier.confirmBooking(bookingId);
```

### Posts (Social Feed)
```dart
// Get feed
final posts = ref.watch(feedPostsProvider());

// Create post
final postNotifier = ref.read(postNotifierProvider.notifier);
await postNotifier.createPost(request);

// Like post
await postNotifier.likePost(postId);
```

### Chats
```dart
// Get chats list
final chats = ref.watch(chatsListProvider());

// Send message
final chatNotifier = ref.read(chatNotifierProvider.notifier);
await chatNotifier.sendMessage(chatId, 'Hello!');

// Mark as read
await chatNotifier.markAsRead(chatId);
```

## Error Handling

Все ошибки API обрабатываются автоматически:
- Network errors → NetworkException
- Timeout → TimeoutException
- 401 → UnauthorizedException (auto refresh token)
- 403 → ForbiddenException
- 404 → NotFoundException
- 422 → ValidationException
- 500+ → ServerException

Пример обработки:
```dart
try {
  await authNotifier.login(email, password);
} on ValidationException catch (e) {
  // Показать ошибки валидации
  print(e.getFieldError('email'));
} on UnauthorizedException {
  // Показать ошибку авторизации
} on ApiException catch (e) {
  // Общая ошибка
  print(e.message);
}
```

## Security

- Токены хранятся в `flutter_secure_storage`
- JWT автоматически добавляется ко всем запросам
- Refresh token автоматически обновляется при 401
- Все пароли передаются через HTTPS

## Следующие шаги

1. Запустите backend сервер
2. Обновите `apiBaseUrl` в `app_config.dart`
3. Запустите `flutter pub run build_runner build`
4. Протестируйте интеграцию
5. Замените mock данные на реальные API вызовы в UI
