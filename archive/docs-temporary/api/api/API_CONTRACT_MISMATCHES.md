# API Contract Mismatches: Backend vs Frontend

**Дата:** 2026-01-27
**Критичность:** 🔴 **CRITICAL** - блокирует корректную работу приложения

## Проблема

При ручном тестировании фронтенд не может корректно обрабатывать ответы от бэкенда из-за несоответствия формата данных:
- **Backend отправляет:** `snake_case` (например: `first_name`, `author_id`, `media_urls`)
- **Frontend ожидает:** `camelCase` (например: `firstName`, `authorId`, `mediaUrls`)

---

## 1. Auth Endpoints

### POST /api/v2/auth/register

**Backend Response (snake_case):**
```json
{
  "access_token": "eyJ...",
  "refresh_token": "eyJ...",
  "token_type": "Bearer",
  "expires_in": 604800,
  "user": {
    "id": "fd905c65-7b6f-401c-ae3e-dbbe5ce93f3c",
    "email": "test@example.com",
    "first_name": "Test",           // ❌ snake_case
    "last_name": "Contract",         // ❌ snake_case
    "avatar_url": null,              // ❌ snake_case
    "is_master": false,              // ❌ snake_case
    "is_verified": false,            // ❌ snake_case
    "is_premium": false              // ❌ snake_case
  }
}
```

**Frontend Expects (camelCase):**
```dart
class AuthResponse {
  final String accessToken;         // ✅ camelCase
  final String refreshToken;        // ✅ camelCase
  final String tokenType;           // ✅ camelCase
  final int expiresIn;              // ✅ camelCase
  final User user;
}

class User {
  final String firstName;           // ✅ camelCase
  final String lastName;            // ✅ camelCase
  final String? avatarUrl;          // ✅ camelCase
  final bool isMaster;              // ✅ camelCase
  final bool isVerified;            // ✅ camelCase
  final bool isPremium;             // ✅ camelCase
}
```

**Status:** ❌ **НЕСОВМЕСТИМО**

---

## 2. Posts Endpoints

### GET /api/v2/posts/feed

**Backend Response (snake_case):**
```json
{
  "data": [
    {
      "id": "09ed9757-f316-49bd-8a95-121da9eb76ca",
      "author_id": "915e21a1-9471-448b-92e1-4bc232912689",  // ❌ snake_case
      "type": "text",
      "content": "Спасибо моим постоянным клиентам...",
      "privacy": "public",
      "repost_of_id": null,                                 // ❌ snake_case
      "likes_count": 42,                                    // ❌ snake_case
      "comments_count": 11,                                 // ❌ snake_case
      "reposts_count": 0,                                   // ❌ snake_case
      "views_count": 206,                                   // ❌ snake_case
      "location_lat": null,                                 // ❌ snake_case
      "location_lng": null,                                 // ❌ snake_case
      "location_name": null,                                // ❌ snake_case
      "comments_disabled": false,                           // ❌ snake_case
      "is_pinned": false,                                   // ❌ snake_case
      "created_at": "2026-01-21T01:54:07.357Z",            // ❌ snake_case
      "updated_at": "2026-01-21T15:21:26.034Z",            // ❌ snake_case
      "author": {
        "id": "915e21a1-9471-448b-92e1-4bc232912689",
        "email": "elena.master@test.com",
        "phone": "+79003333333",
        "first_name": "Елена",                              // ❌ snake_case
        "last_name": "Смирнова",                            // ❌ snake_case
        "avatar_url": "http://localhost:9000/avatars/...",  // ❌ snake_case
        "is_master": true,                                  // ❌ snake_case
        "master_profile_completed": true,                   // ❌ snake_case
        "is_verified": true,                                // ❌ snake_case
        "is_premium": false,                                // ❌ snake_case
        "premium_until": null,                              // ❌ snake_case
        "is_admin": false,                                  // ❌ snake_case
        "is_active": true,                                  // ❌ snake_case
        "last_login_at": null,                              // ❌ snake_case
        "rating": "4.70",
        "reviews_count": 32,                                // ❌ snake_case
        "cancellations_count": 0,                           // ❌ snake_case
        "no_shows_count": 0,                                // ❌ snake_case
        "blacklists_count": 0,                              // ❌ snake_case
        "language": "en",
        "timezone": "UTC",
        "last_location_lat": null,                          // ❌ snake_case
        "last_location_lng": null,                          // ❌ snake_case
        "posts_count": 0,                                   // ❌ snake_case
        "friends_count": 0,                                 // ❌ snake_case
        "followers_count": 1,                               // ❌ snake_case
        "following_count": 0,                               // ❌ snake_case
        "created_at": "2026-01-21T15:21:25.695Z",          // ❌ snake_case
        "updated_at": "2026-01-21T15:21:26.093Z"           // ❌ snake_case
      },
      "media": [
        {
          "id": "a027e87a-52db-402c-8445-3861eb738c7d",
          "post_id": "09ed9757-f316-49bd-8a95-121da9eb76ca", // ❌ snake_case
          "type": "photo",
          "url": "http://localhost:9000/posts/...",
          "thumbnail_url": "http://localhost:9000/posts/...",// ❌ snake_case
          "order": 0,
          "width": 400,
          "height": 400,
          "duration": null
        }
      ],
      "repost_of": null                                     // ❌ snake_case
    }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 14,
    "totalPages": 1,                                        // ❌ camelCase (inconsistent!)
    "nextCursor": "2026-01-15T04:45:45.797Z",              // ❌ camelCase (inconsistent!)
    "hasMore": false                                        // ❌ camelCase (inconsistent!)
  }
}
```

**Frontend Expects (camelCase):**
```dart
class Post {
  final String id;
  final String authorId;           // ✅ camelCase
  final PostType type;
  final String content;
  final Privacy privacy;
  final String? repostOfId;        // ✅ camelCase
  final int likesCount;            // ✅ camelCase
  final int commentsCount;         // ✅ camelCase
  final int repostsCount;          // ✅ camelCase
  final int viewsCount;            // ✅ camelCase
  final double? locationLat;       // ✅ camelCase
  final double? locationLng;       // ✅ camelCase
  final String? locationName;      // ✅ camelCase
  final bool commentsDisabled;     // ✅ camelCase
  final bool isPinned;             // ✅ camelCase
  final DateTime createdAt;        // ✅ camelCase
  final DateTime updatedAt;        // ✅ camelCase
  final User author;
  final List<Media> media;
  final Post? repostOf;            // ✅ camelCase
}
```

**Status:** ❌ **НЕСОВМЕСТИМО**

**Дополнительная проблема:** В `meta` объекте бэкенд использует **СМЕШАННЫЙ** формат:
- `page`, `limit`, `total` - snake_case ✅
- `totalPages`, `nextCursor`, `hasMore` - camelCase ❌

---

### POST /api/v2/posts

**Backend Request Validation Error:**
```json
{
  "message": [
    "property media_urls should not exist",
    "type must be one of the following values: text, photo, video, repost"
  ],
  "error": "Bad Request",
  "statusCode": 400
}
```

**Проблема:** Backend **НЕ принимает** поле `media_urls`, но фронтенд его отправляет.

**Backend DTO (CreatePostDto):**
```typescript
class CreatePostDto {
  type: 'text' | 'photo' | 'video' | 'repost';
  content: string;
  privacy?: 'public' | 'friends' | 'private';
  location_lat?: number;          // ❌ snake_case
  location_lng?: number;          // ❌ snake_case
  location_name?: string;         // ❌ snake_case
  repost_of_id?: string;          // ❌ snake_case
  // НЕТ поля media_urls!
}
```

**Status:** ❌ **НЕСОВМЕСТИМО** - фронтенд отправляет поля, которые бэкенд не принимает

---

## 3. Bookings Endpoints

### GET /api/v2/bookings

**Backend Response (snake_case):**
```json
{
  "data": [],
  "total": 0,
  "page": 1,
  "limit": 20
}
```

**Frontend Expects (camelCase):**
```dart
class PaginatedResponse<T> {
  final List<T> data;
  final int total;
  final int page;
  final int limit;
}
```

**Status:** ⚠️ **ЧАСТИЧНО СОВМЕСТИМО** - базовые поля пагинации совпадают, но не протестированы объекты Booking

---

## Итоговая таблица несоответствий

| Endpoint | Backend Format | Frontend Expects | Impact | Priority |
|----------|---------------|------------------|--------|----------|
| POST /auth/register | `first_name`, `last_name`, `avatar_url`, `is_*` | `firstName`, `lastName`, `avatarUrl`, `is*` | 🔴 CRITICAL | P0 |
| POST /auth/login | То же | То же | 🔴 CRITICAL | P0 |
| GET /posts/feed | `author_id`, `likes_count`, `comments_count`, `created_at`, `updated_at`, etc. (40+ полей) | `authorId`, `likesCount`, `commentsCount`, `createdAt`, `updatedAt`, etc. | 🔴 CRITICAL | P0 |
| POST /posts | НЕ принимает `media_urls`, требует `location_*` | Отправляет `media_urls`, `location*` | 🔴 CRITICAL | P0 |
| GET /bookings | `snake_case` | `camelCase` | 🟡 HIGH | P1 |
| Все endpoints с User | 30+ полей в `snake_case` | 30+ полей в `camelCase` | 🔴 CRITICAL | P0 |
| Все endpoints с Post | 40+ полей в `snake_case` | 40+ полей в `camelCase` | 🔴 CRITICAL | P0 |
| Все endpoints с Media | `post_id`, `thumbnail_url` | `postId`, `thumbnailUrl` | 🔴 CRITICAL | P0 |

---

## Рекомендации по решению

### Вариант 1: Изменить Backend на camelCase (РЕКОМЕНДУЕТСЯ)

**Плюсы:**
- Соответствует JavaScript/TypeScript конвенциям
- Frontend уже готов к camelCase
- Swagger документация будет более читаемой для JS-разработчиков

**Минусы:**
- Требует изменений в backend DTOs
- Нужно обновить базу данных (опционально - можно использовать @Column({name: 'snake_case'}))

**Реализация:**
1. Добавить глобальный SerializerInterceptor с class-transformer
2. Использовать @Expose() декораторы в DTOs
3. Настроить class-transformer: `{ strategy: 'excludeAll', exposeDefaultValues: true }`

### Вариант 2: Изменить Frontend на snake_case

**Плюсы:**
- Соответствует PostgreSQL конвенциям
- Меньше изменений в backend

**Минусы:**
- Нарушает Dart/Flutter конвенции (linter будет ругаться)
- Нужно переписать все Freezed модели
- Ухудшает читаемость кода на фронтенде

### Вариант 3: Использовать @JsonKey mapping в Frontend

**Плюсы:**
- Минимальные изменения в backend
- Сохраняет правильные конвенции на обеих сторонах

**Минусы:**
- Требует добавить @JsonKey для КАЖДОГО поля (200+ полей)
- Увеличивает размер кода
- Сложнее поддерживать

**Пример:**
```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_master') required bool isMaster,
    // ... еще 30 полей
  }) = _User;
}
```

---

## Решение: Вариант 1 (Backend → camelCase)

Изменим backend для использования camelCase в API responses с помощью class-transformer.

**Время выполнения:** 3-4 часа
**Файлов затронуто:** ~15-20 DTOs
**Тестирование:** 1-2 часа

См. детали в [IMPLEMENTATION_ROADMAP_2026-01.md](../IMPLEMENTATION_ROADMAP_2026-01.md) → Task 1.0
