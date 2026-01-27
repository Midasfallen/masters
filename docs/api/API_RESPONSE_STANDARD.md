# API Response Format Standard

**Версия:** 2.0
**Дата:** 2026-01-27
**Статус:** 🟢 APPROVED

---

## Общие принципы

### 1. Naming Convention

**Стандарт:** **camelCase** для всех полей в API responses

**Причины:**
- ✅ Соответствует JavaScript/TypeScript конвенциям
- ✅ Соответствует Dart/Flutter конвенциям
- ✅ Более читаемо в JSON
- ✅ Совместимо с большинством modern web frameworks
- ✅ Уже используется во frontend models

**Примеры:**
```json
{
  "firstName": "John",          // ✅ Correct
  "lastName": "Doe",            // ✅ Correct
  "first_name": "John",         // ❌ Wrong
  "FirstName": "John",          // ❌ Wrong
  "FIRST_NAME": "John"          // ❌ Wrong
}
```

---

### 2. Boolean Fields

**Стандарт:** Используйте префикс `is`, `has`, `can` для boolean полей

```json
{
  "isActive": true,             // ✅ Correct
  "hasAvatar": false,           // ✅ Correct
  "canEdit": true,              // ✅ Correct
  "verified": true,             // ❌ Unclear
  "active": true                // ❌ Unclear
}
```

---

### 3. Date/Time Fields

**Стандарт:** ISO 8601 format, UTC timezone, с постфиксом `At` для timestamps

```json
{
  "createdAt": "2026-01-27T15:30:00.000Z",  // ✅ Correct
  "updatedAt": "2026-01-27T15:30:00.000Z",  // ✅ Correct
  "deletedAt": null,                         // ✅ Correct (nullable)
  "created": "2026-01-27",                   // ❌ Missing 'At' suffix
  "date": "27/01/2026"                       // ❌ Wrong format
}
```

---

### 4. ID Fields

**Стандарт:** Используйте постфикс `Id` для foreign keys

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",      // ✅ Correct (primary key)
  "userId": "550e8400-e29b-41d4-a716-446655440001",  // ✅ Correct (foreign key)
  "authorId": "550e8400-e29b-41d4-a716-446655440002", // ✅ Correct
  "author": "550e8400-...",                          // ❌ Unclear (string or object?)
  "user_id": "550e8400-..."                          // ❌ Wrong naming
}
```

---

### 5. Count Fields

**Стандарт:** Используйте постфикс `Count` для счетчиков

```json
{
  "likesCount": 42,             // ✅ Correct
  "commentsCount": 15,          // ✅ Correct
  "viewsCount": 1234,           // ✅ Correct
  "likes": 42,                  // ❌ Unclear (number or array?)
  "totalLikes": 42              // ❌ Inconsistent
}
```

---

### 6. URL Fields

**Стандарт:** Используйте постфикс `Url` для URL полей

```json
{
  "avatarUrl": "https://example.com/avatar.jpg",     // ✅ Correct
  "thumbnailUrl": "https://example.com/thumb.jpg",   // ✅ Correct
  "avatar": "https://example.com/avatar.jpg",        // ❌ Missing 'Url' suffix
  "avatarPath": "/uploads/avatar.jpg"                // ❌ Use 'Url' for full URLs
}
```

---

### 7. Nested Objects vs IDs

**Стандарт:** Возвращайте полные объекты для связанных данных, если они часто используются

```json
{
  "id": "post-123",
  "authorId": "user-456",       // ✅ Foreign key
  "author": {                   // ✅ Nested object (если нужен для UI)
    "id": "user-456",
    "firstName": "John",
    "lastName": "Doe",
    "avatarUrl": "https://..."
  }
}
```

**Правила:**
- Если nested object используется в 80%+ случаев → включать по умолчанию
- Если используется редко → возвращать только `*Id`, использовать query param `?include=author`
- Избегать глубокой вложенности (max 2-3 уровня)

---

### 8. Pagination

**Стандарт:** Unified pagination response format

```json
{
  "data": [...],                // ✅ Array of items
  "meta": {                     // ✅ Metadata object
    "page": 1,                  // ✅ Current page (1-indexed)
    "limit": 20,                // ✅ Items per page
    "total": 145,               // ✅ Total items
    "totalPages": 8,            // ✅ Total pages
    "hasMore": true,            // ✅ Has next page?
    "nextCursor": "2026-01-27T15:30:00.000Z"  // ✅ For cursor-based pagination
  }
}
```

**Альтернатива (cursor-based only):**
```json
{
  "data": [...],
  "meta": {
    "limit": 20,
    "nextCursor": "2026-01-27T15:30:00.000Z",
    "hasMore": true
  }
}
```

---

### 9. Error Responses

**Стандарт:** Consistent error format

```json
{
  "statusCode": 400,            // ✅ HTTP status code
  "message": "Validation failed", // ✅ Human-readable message (может быть string или array)
  "error": "Bad Request",       // ✅ Error type
  "timestamp": "2026-01-27T15:30:00.000Z", // ✅ Optional
  "path": "/api/v2/posts"       // ✅ Optional
}
```

**Validation errors:**
```json
{
  "statusCode": 400,
  "message": [
    "firstName should not be empty",
    "email must be an email"
  ],
  "error": "Bad Request"
}
```

---

### 10. Privacy/Visibility Fields

**Стандарт:** Используйте enum values в lowercase

```json
{
  "privacy": "public",          // ✅ Correct ('public' | 'friends' | 'private')
  "status": "active",           // ✅ Correct ('active' | 'inactive' | 'banned')
  "type": "photo",              // ✅ Correct ('text' | 'photo' | 'video')
  "Privacy": "PUBLIC",          // ❌ Wrong casing
  "privacy": "Public"           // ❌ Wrong casing
}
```

---

## Примеры правильных DTO

### User Entity

```typescript
// Backend DTO (NestJS)
export class UserResponseDto {
  id: string;
  email: string;
  phone?: string;
  firstName: string;              // ✅ camelCase
  lastName: string;               // ✅ camelCase
  avatarUrl?: string;             // ✅ camelCase + Url suffix
  isMaster: boolean;              // ✅ is prefix
  masterProfileCompleted: boolean;
  isVerified: boolean;            // ✅ is prefix
  isPremium: boolean;             // ✅ is prefix
  premiumUntil?: string;          // ✅ ISO 8601
  isAdmin: boolean;
  isActive: boolean;
  lastLoginAt?: string;           // ✅ At suffix
  rating?: string;
  reviewsCount: number;           // ✅ Count suffix
  cancellationsCount: number;     // ✅ Count suffix
  postsCount: number;
  friendsCount: number;
  followersCount: number;
  followingCount: number;
  createdAt: string;              // ✅ ISO 8601
  updatedAt: string;              // ✅ ISO 8601
}
```

```dart
// Frontend Model (Flutter/Freezed)
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? phone,
    required String firstName,
    required String lastName,
    String? avatarUrl,
    required bool isMaster,
    required bool masterProfileCompleted,
    required bool isVerified,
    required bool isPremium,
    DateTime? premiumUntil,
    required bool isAdmin,
    required bool isActive,
    DateTime? lastLoginAt,
    String? rating,
    required int reviewsCount,
    required int cancellationsCount,
    required int postsCount,
    required int friendsCount,
    required int followersCount,
    required int followingCount,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

**Результат:** ✅ **100% совместимость** без @JsonKey mapping!

---

### Post Entity

```typescript
// Backend DTO (NestJS)
export class PostResponseDto {
  id: string;
  authorId: string;               // ✅ Id suffix
  type: 'text' | 'photo' | 'video' | 'repost';
  content: string;
  privacy: 'public' | 'friends' | 'private';
  repostOfId?: string;            // ✅ Id suffix
  likesCount: number;             // ✅ Count suffix
  commentsCount: number;
  repostsCount: number;
  viewsCount: number;
  locationLat?: number;           // ✅ camelCase
  locationLng?: number;
  locationName?: string;
  commentsDisabled: boolean;      // ✅ no prefix for action-related booleans
  isPinned: boolean;              // ✅ is prefix for state booleans
  createdAt: string;              // ✅ ISO 8601
  updatedAt: string;

  // Nested objects
  author: UserResponseDto;        // ✅ Full object
  media: MediaResponseDto[];      // ✅ Array
  repostOf?: PostResponseDto;     // ✅ Optional nested
}
```

---

### Media Entity

```typescript
// Backend DTO (NestJS)
export class MediaResponseDto {
  id: string;
  postId: string;                 // ✅ Id suffix
  type: 'photo' | 'video';
  url: string;                    // ✅ Url suffix
  thumbnailUrl?: string;          // ✅ Url suffix
  order: number;
  width?: number;
  height?: number;
  duration?: number;              // ✅ for videos (in seconds)
}
```

---

### Booking Entity

```typescript
// Backend DTO (NestJS)
export class BookingResponseDto {
  id: string;
  userId: string;                 // ✅ Id suffix
  masterId: string;
  serviceId: string;
  status: 'pending' | 'confirmed' | 'in_progress' | 'completed' | 'cancelled';
  scheduledAt: string;            // ✅ ISO 8601
  startedAt?: string;
  completedAt?: string;
  cancelledAt?: string;
  price: number;
  currency: string;
  locationLat?: number;
  locationLng?: number;
  locationName?: string;
  notes?: string;
  cancellationReason?: string;
  canReview: boolean;             // ✅ can prefix
  createdAt: string;
  updatedAt: string;

  // Nested objects
  user: UserResponseDto;
  master: UserResponseDto;
  service: ServiceResponseDto;
}
```

---

## Реализация в NestJS

### 1. Глобальный Serialization Interceptor

```typescript
// src/common/interceptors/transform.interceptor.ts
import {
  Injectable,
  NestInterceptor,
  ExecutionContext,
  CallHandler,
} from '@nestjs/common';
import { Observable } from 'rxjs';
import { map } from 'rxjs/operators';
import { classToPlain } from 'class-transformer';

@Injectable()
export class TransformInterceptor implements NestInterceptor {
  intercept(context: ExecutionContext, next: CallHandler): Observable<any> {
    return next.handle().pipe(
      map((data) =>
        classToPlain(data, {
          strategy: 'excludeAll', // Only expose fields with @Expose()
          excludeExtraneousValues: true,
        }),
      ),
    );
  }
}
```

### 2. Регистрация в main.ts

```typescript
// src/main.ts
import { TransformInterceptor } from './common/interceptors/transform.interceptor';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  // Global interceptor для serialization
  app.useGlobalInterceptors(new TransformInterceptor());

  await app.listen(3000);
}
```

### 3. Обновление DTOs с @Expose()

```typescript
// src/modules/users/dto/user-response.dto.ts
import { Expose } from 'class-transformer';

export class UserResponseDto {
  @Expose()
  id: string;

  @Expose()
  email: string;

  @Expose()
  firstName: string;  // ✅ Будет сериализован как "firstName" в JSON

  @Expose()
  lastName: string;

  @Expose()
  avatarUrl?: string;

  @Expose()
  isMaster: boolean;

  // ... rest of fields
}
```

### 4. Mapping Entity → DTO

```typescript
// src/modules/users/users.service.ts
import { plainToClass } from 'class-transformer';

export class UsersService {
  async findOne(id: string): Promise<UserResponseDto> {
    const user = await this.usersRepository.findOne({ where: { id } });

    // Преобразуем Entity (snake_case в DB) → DTO (camelCase)
    return plainToClass(UserResponseDto, user);
  }
}
```

---

## Миграция: Checklist

### Backend (NestJS)

- [ ] Установить `class-transformer` (уже установлен)
- [ ] Создать `TransformInterceptor`
- [ ] Зарегистрировать interceptor в `main.ts`
- [ ] Обновить все Response DTOs:
  - [ ] `auth/*.dto.ts` (5 файлов)
  - [ ] `users/*.dto.ts` (3 файла)
  - [ ] `posts/*.dto.ts` (4 файла)
  - [ ] `bookings/*.dto.ts` (3 файла)
  - [ ] `reviews/*.dto.ts` (2 файла)
  - [ ] `services/*.dto.ts` (3 файла)
  - [ ] `masters/*.dto.ts` (2 файла)
  - [ ] `chats/*.dto.ts` (4 файла)
  - [ ] `notifications/*.dto.ts` (2 файла)
  - [ ] `social/*.dto.ts` (3 файла)
- [ ] Добавить `@Expose()` для всех полей
- [ ] Обновить Entity `@Column()` decorators (опционально):
  ```typescript
  @Column({ name: 'first_name' })  // DB column name (snake_case)
  firstName: string;                 // Class property (camelCase)
  ```
- [ ] Запустить тесты
- [ ] Обновить Swagger docs (автоматически обновятся)

### Frontend (Flutter)

- [ ] Удалить все `@JsonKey(name: 'snake_case')` mappings
- [ ] Запустить `flutter pub run build_runner build --delete-conflicting-outputs`
- [ ] Запустить тесты
- [ ] Ручное тестирование API интеграции

---

## Время выполнения

| Этап | Время | Приоритет |
|------|-------|-----------|
| Backend: Interceptor + DTOs | 3-4 часа | P0 |
| Backend: Tests | 1 час | P0 |
| Frontend: Удаление @JsonKey | 1 час | P0 |
| Frontend: Code generation | 15 минут | P0 |
| Frontend: Tests | 1 час | P0 |
| Integration testing | 1-2 часа | P0 |
| **ИТОГО** | **7-9 часов** | **P0** |

---

## Заключение

**Решение:** Backend переходит на **camelCase** для всех API responses.

**Преимущества:**
- ✅ Единый стандарт для JS/TS/Dart экосистемы
- ✅ Минимальные изменения во Frontend (просто удалить @JsonKey)
- ✅ Улучшенная читаемость API
- ✅ Соответствие industry best practices
- ✅ Автоматическая генерация правильных типов в Swagger

**Статус:** 🟢 **READY TO IMPLEMENT**
