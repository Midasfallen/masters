# Frontend Integration Guide - camelCase API Migration

## 📋 Обзор

Backend API теперь возвращает **camelCase** responses. Frontend нужно обновить для корректной работы с новым форматом.

---

## ✅ Что уже сделано

### Backend (100% готов):
- ✅ 10 основных модулей мигрированы на camelCase responses
- ✅ Docker собран и запущен успешно
- ✅ API доступен: http://localhost:3000/api/v2
- ✅ Swagger обновлен: http://localhost:3000/api/v2/docs

### Frontend (Частично):
- ✅ `booking_model.dart` - обновлен на camelCase
- ✅ `service_model.dart` - обновлен на camelCase
- ✅ `notification_model.dart` - обновлен на camelCase
- ✅ `chat_model.dart` - обновлен на camelCase

---

## 🔄 Что нужно сделать

### 1. Обновить оставшиеся модели (7 файлов)

Убрать `@JsonKey(name: 'snake_case')` из **response моделей**:

#### Критические:
- `master_model.dart`
- `review_model.dart`
- `post_model.dart`
- `user_model.dart`

#### Дополнительные:
- `friend_model.dart`
- `auto_proposal_model.dart`
- `premium_subscription_model.dart`

---

## 📝 Инструкция по обновлению

### Шаг 1: Обновить модели вручную

Для каждой **response модели** убрать @JsonKey аннотации:

```dart
// ❌ БЫЛО (snake_case API):
@freezed
class BookingModel with _$BookingModel {
  const factory BookingModel({
    required String id,
    @JsonKey(name: 'client_id') required String clientId,
    @JsonKey(name: 'start_time') required DateTime startTime,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
}

// ✅ СТАЛО (camelCase API):
@freezed
class BookingModel with _$BookingModel {
  const factory BookingModel({
    required String id,
    required String clientId,
    required DateTime startTime,
    required DateTime createdAt,
  }) = _BookingModel;

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
}
```

### ⚠️ ВАЖНО: Request модели НЕ трогать!

**Request модели** (CreateBookingRequest, UpdateServiceRequest и т.д.) должны **ОСТАВИТЬ** `@JsonKey` аннотации, т.к. API endpoints по-прежнему принимают snake_case в request body:

```dart
// ✅ ОСТАВИТЬ КАК ЕСТЬ (request модели):
@freezed
class CreateBookingRequest with _$CreateBookingRequest {
  const factory CreateBookingRequest({
    @JsonKey(name: 'master_id') required String masterId,  // НЕ МЕНЯТЬ
    @JsonKey(name: 'service_id') required String serviceId, // НЕ МЕНЯТЬ
    @JsonKey(name: 'start_time') required DateTime startTime, // НЕ МЕНЯТЬ
  }) = _CreateBookingRequest;
}
```

---

### Шаг 2: Пересобрать Freezed файлы

После обновления моделей нужно пересоздать `.g.dart` и `.freezed.dart` файлы:

```bash
cd frontend
flutter pub run build_runner build --delete-conflicting-outputs
```

Эта команда:
- Удалит старые generated файлы
- Создаст новые с учетом camelCase
- Обновит JSON сериализацию

---

### Шаг 3: Проверить компиляцию

```bash
flutter analyze
```

Исправить все найденные ошибки (если есть).

---

### Шаг 4: Обновить тесты (если есть)

Если есть unit/widget тесты, обновить assertions:

```dart
// БЫЛО:
expect(booking.client_id, equals('123'));

// СТАЛО:
expect(booking.clientId, equals('123'));
```

---

### Шаг 5: Запустить приложение

```bash
flutter run
```

Проверить:
- ✅ Логин работает
- ✅ Загрузка данных с API работает
- ✅ Создание/редактирование записей работает

---

## 🔍 Как найти что изменить

### Найти все @JsonKey аннотации:
```bash
grep -rn "@JsonKey" frontend/lib/core/models/api/ --include="*.dart" | grep -v ".g.dart" | grep -v ".freezed.dart"
```

### Проверить конкретную модель:
```bash
cat frontend/lib/core/models/api/master_model.dart | grep -A 2 "@JsonKey"
```

---

## 📊 Маппинг полей

### Booking:
| Backend API (camelCase) | Frontend Model |
|-------------------------|----------------|
| `clientId` | `clientId` |
| `masterId` | `masterId` |
| `startTime` | `startTime` |
| `durationMinutes` | `durationMinutes` |
| `createdAt` | `createdAt` |

### Service:
| Backend API (camelCase) | Frontend Model |
|-------------------------|----------------|
| `masterId` | `masterId` |
| `categoryId` | `categoryId` |
| `durationMinutes` | `durationMinutes` |
| `isActive` | `isActive` |
| `bookingsCount` | `bookingsCount` |

### Notification:
| Backend API (camelCase) | Frontend Model |
|-------------------------|----------------|
| `userId` | `userId` |
| `isRead` | `isRead` |
| `relatedId` | `relatedId` |
| `actionUrl` | `actionUrl` |
| `createdAt` | `createdAt` |

---

## ⚠️ Типичные проблемы

### Проблема 1: "The getter 'client_id' isn't defined"

**Причина:** Код пытается обращаться к старому snake_case полю

**Решение:**
```dart
// БЫЛО:
final clientId = booking.client_id;

// СТАЛО:
final clientId = booking.clientId;
```

---

### Проблема 2: "type 'Null' is not a subtype of type 'String'"

**Причина:** Модель не распарсилась из JSON т.к. поля не совпадают

**Решение:**
- Проверить что модель обновлена на camelCase
- Убедиться что Freezed файлы пересобраны
- Проверить response от API (должен быть camelCase)

---

### Проблема 3: Freezed генерация не работает

**Решение:**
```bash
# Удалить все generated файлы
find frontend/lib/core/models/api -name "*.g.dart" -delete
find frontend/lib/core/models/api -name "*.freezed.dart" -delete

# Пересоздать
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## 🧪 Тестирование

### Ручное тестирование:

1. **Логин:**
   - Войти в аккаунт
   - Проверить что данные пользователя загрузились

2. **Bookings:**
   - Открыть список бронирований
   - Создать новое бронирование
   - Проверить детали бронирования

3. **Services:**
   - Открыть список услуг мастера
   - Создать/редактировать услугу

4. **Notifications:**
   - Проверить список уведомлений
   - Отметить как прочитанное

5. **Chats:**
   - Открыть чат
   - Отправить сообщение
   - Проверить историю

---

## 📞 Поддержка

При проблемах проверить:

1. **Backend работает:**
   ```bash
   curl http://localhost:3000/api/v2/health
   ```

2. **API возвращает camelCase:**
   ```bash
   curl http://localhost:3000/api/v2/bookings \
     -H "Authorization: Bearer YOUR_TOKEN"
   ```

3. **Freezed файлы актуальны:**
   ```bash
   ls -la frontend/lib/core/models/api/*.g.dart
   ```

---

## ✅ Checklist

- [ ] Обновлены все response модели (убраны @JsonKey)
- [ ] Request модели НЕ тронуты (оставлены @JsonKey)
- [ ] Пересобраны Freezed файлы
- [ ] `flutter analyze` проходит без ошибок
- [ ] Приложение запускается
- [ ] Логин работает
- [ ] Загрузка данных работает
- [ ] Создание/редактирование работает
- [ ] Тесты обновлены (если есть)

---

**Last Updated:** 2026-01-28
**Backend Status:** ✅ Ready
**Frontend Status:** 🔄 In Progress (40% complete)
