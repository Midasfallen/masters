# План MVP запуска Service Platform

## Резюме анализа

Проект Service Platform (Flutter + NestJS) в целом готов к MVP. Backend работает в Docker, frontend имеет правильную архитектуру (Riverpod 2.x, Freezed, правильный snake_case маппинг в моделях).

**Однако обнаружена критичная проблема**, которая вызовет crash при любом вызове API с ID.

---

## КРИТИЧНАЯ ПРОБЛЕМА: Type Mismatch (int vs String UUID)

### Суть проблемы
Backend использует UUID строки для всех ID (например: `550e8400-e29b-41d4-a716-446655440000`).
Frontend в `ApiEndpoints` объявляет функции с `int id`, а в репозиториях вызывает `int.parse(id)`.

**Результат:** `FormatException` при runtime на любом вызове `*ById()`.

### Затронутые файлы

| Файл | Проблемные строки |
|------|-------------------|
| `frontend/lib/core/api/api_endpoints.dart` | 15, 22, 26-27, 31, 33-34, 38-39, 43, 45-47, 52, 54-55, 64, 66-70, 75, 77-79, 83-84, 91 |
| `frontend/lib/core/repositories/booking_repository.dart` | 58, 70, 85, 98, 113 |
| `frontend/lib/core/repositories/master_repository.dart` | 50, 91, 109 |
| `frontend/lib/core/repositories/user_repository.dart` | 29 |

---

## План действий

### Фаза 1: Исправление критичной проблемы

#### 1.1 Изменить `api_endpoints.dart`

Заменить все функции с `int id` на `String id`:

```dart
// БЫЛО:
static String userById(int id) => '/users/$id';
static String masterById(int id) => '/masters/$id';
static String bookingById(int id) => '/bookings/$id';
// ... и остальные 25+ функций

// СТАНЕТ:
static String userById(String id) => '/users/$id';
static String masterById(String id) => '/masters/$id';
static String bookingById(String id) => '/bookings/$id';
```

**Полный список функций для изменения:**
- `userById`, `masterById`, `masterServices`, `masterReviews`
- `serviceById`, `serviceUpdate`, `serviceDelete`
- `categoryById`, `categoryServices`
- `bookingById`, `bookingConfirm`, `bookingCancel`, `bookingComplete`
- `reviewById`, `reviewUpdate`, `reviewDelete`
- `postById`, `postUpdate`, `postDelete`, `postLike`, `postUnlike`, `postComments`
- `chatById`, `chatMessages`, `chatSendMessage`, `chatMarkRead`
- `notificationById`, `notificationMarkRead`
- `favoriteRemove`

#### 1.2 Удалить `int.parse()` в репозиториях

**booking_repository.dart:**
```dart
// Строки 58, 70, 85, 98, 113 - убрать int.parse():
ApiEndpoints.bookingById(id)  // вместо int.parse(id)
```

**master_repository.dart:**
```dart
// Строки 50, 91, 109 - убрать int.parse():
ApiEndpoints.masterById(id)
ApiEndpoints.masterServices(masterId)
ApiEndpoints.masterReviews(masterId)
```

**user_repository.dart:**
```dart
// Строка 29 - убрать int.parse():
ApiEndpoints.userById(id)
```

---

### Фаза 2: Валидация

```bash
# 2.1 Кодогенерация (если есть изменения в моделях)
cd frontend
flutter pub run build_runner build --delete-conflicting-outputs

# 2.2 Статический анализ
flutter analyze

# 2.3 Тесты Frontend
flutter test

# 2.4 Тесты Backend
cd ../backend
npm run test
npm run test:e2e
```

---

### Фаза 3: Smoke Testing

Проверить основные API flows:

1. **Auth:** `POST /auth/register`, `POST /auth/login`
2. **User:** `GET /users/me`
3. **Master:** `GET /masters/{uuid}` - критично, использует исправленный код
4. **Booking:** `POST /bookings`, `GET /bookings/{uuid}` - критично
5. **Feed:** `GET /posts/feed`

---

## Файлы для изменения

| Файл | Действие | Приоритет |
|------|----------|-----------|
| `frontend/lib/core/api/api_endpoints.dart` | Изменить `int` → `String` в 28 функциях | КРИТИЧНО |
| `frontend/lib/core/repositories/booking_repository.dart` | Удалить `int.parse()` в 5 местах | КРИТИЧНО |
| `frontend/lib/core/repositories/master_repository.dart` | Удалить `int.parse()` в 3 местах | КРИТИЧНО |
| `frontend/lib/core/repositories/user_repository.dart` | Удалить `int.parse()` в 1 месте | КРИТИЧНО |

---

## Что НЕ требует исправления

После анализа подтверждено, что следующие компоненты работают корректно:

- **@JsonKey маппинг** в моделях - все Request модели правильно используют `@JsonKey(name: 'snake_case')`
- **Backend DTO** - Response DTO возвращают camelCase через mapper
- **Retry Interceptor** - повторяет только timeout/connection ошибки, не дублирует POST/PUT
- **NotificationModel.isRead** - backend mapper преобразует `is_read` → `isRead`
- **Riverpod архитектура** - правильно использует AsyncValue.guard()

---

## Отложено (post-MVP)

| Задача | Причина |
|--------|---------|
| WebSocket для real-time чатов | Работает через polling |
| Production AppConfig | Нужен production URL |
| Client-side file size validation | Backend валидирует |
| Создание API-v2-Summary.md | Swagger доступен |

---

## Верификация

После внесения изменений:

1. Запустить Flutter приложение
2. Выполнить регистрацию/логин
3. Открыть профиль мастера по ID
4. Создать бронирование
5. Проверить список бронирований

Если все операции выполняются без `FormatException` - исправление успешно.
