# Frontend API Models Migration Plan

## Цель
Обновить все Freezed модели во Frontend для работы с новым camelCase Backend API

## Статус
🔄 **В процессе**

---

## Модели для обновления

### ✅ Обновлено:
1. `booking_model.dart` - убраны все @JsonKey аннотации
2. `service_model.dart` - убраны все @JsonKey аннотации для response
3. `notification_model.dart` - убраны все @JsonKey аннотации для response

### 🔄 В процессе:
4. `chat_model.dart` - ChatModel, ChatParticipantModel, MessageModel
5. `review_model.dart` - ReviewModel, ReviewStatsModel
6. `master_model.dart` - MasterProfileModel
7. `post_model.dart` - PostModel
8. `user_model.dart` - UserModel

### Дополнительные модели:
- `friend_model.dart`
- `auto_proposal_model.dart`
- `premium_subscription_model.dart`

---

## Важно!

### Response Models (получение с API)
Убрать все `@JsonKey(name: 'snake_case')` - API теперь возвращает camelCase:

```dart
// ❌ БЫЛО:
@JsonKey(name: 'client_id') required String clientId,

// ✅ СТАЛО:
required String clientId,
```

### Request Models (отправка на API)
**ОСТАВИТЬ** `@JsonKey(name: 'snake_case')` - API endpoints все еще принимают snake_case в request body:

```dart
// ✅ ОСТАВИТЬ КАК ЕСТЬ:
@JsonKey(name: 'client_id') required String clientId,
```

---

## После обновления моделей

1. **Regenerate Freezed files:**
```bash
cd frontend
flutter pub run build_runner build --delete-conflicting-outputs
```

2. **Проверить компиляцию:**
```bash
flutter analyze
```

3. **Run tests:**
```bash
flutter test
```

---

## Примеры изменений

### BookingModel
```dart
// БЫЛО:
const factory BookingModel({
  required String id,
  @JsonKey(name: 'client_id') required String clientId,
  @JsonKey(name: 'start_time') required DateTime startTime,
  @JsonKey(name: 'created_at') required DateTime createdAt,
}) = _BookingModel;

// СТАЛО:
const factory BookingModel({
  required String id,
  required String clientId,
  required DateTime startTime,
  required DateTime createdAt,
}) = _BookingModel;
```

---

## Команды

### Обновить все Freezed генерации:
```bash
cd frontend
flutter pub run build_runner build --delete-conflicting-outputs
```

### Найти все @JsonKey аннотации:
```bash
grep -r "@JsonKey" frontend/lib/core/models/api/
```

---

## Timeline

- **Phase 1:** Обновление моделей (30 мин)
- **Phase 2:** Regenerate Freezed (5 мин)
- **Phase 3:** Fix compilation errors (15 мин)
- **Phase 4:** Testing (30 мин)

**Total:** ~1.5 часа

---

**Last Updated:** 2026-01-28
