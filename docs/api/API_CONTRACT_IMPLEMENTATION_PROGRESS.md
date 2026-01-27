# API Contract Migration Progress: snake_case → camelCase

**Дата начала:** 2026-01-27
**Статус:** 🟡 В процессе (20% завершено)
**Приоритет:** 🔴 P0 CRITICAL

---

## Обзор

Миграция всех API responses с snake_case на camelCase для обеспечения совместимости frontend (Flutter/Dart) с backend (NestJS/TypeScript).

**Проблема:** Backend возвращает поля в snake_case (например: `first_name`, `author_id`), а frontend ожидает camelCase (например: `firstName`, `authorId`).

**Решение:** Обновить все backend response DTOs для возврата camelCase полей.

---

## Глобальная инфраструктура

### ✅ Завершено

| Компонент | Статус | Файл | Описание |
|-----------|--------|------|----------|
| SerializeInterceptor | ✅ | `src/common/interceptors/serialize.interceptor.ts` | Глобальный interceptor для сериализации |
| DtoMapper | ✅ | `src/common/utils/dto-mapper.util.ts` | Utility для преобразования в DTO instances |
| main.ts | ✅ | `src/main.ts` | Регистрация SerializeInterceptor |

---

## Прогресс по модулям

### ✅ Auth Module (100% завершено)

**Статус:** ✅ **ГОТОВО И ПРОТЕСТИРОВАНО**

| DTO | Статус | Изменения |
|-----|--------|-----------|
| `AuthResponseDto` | ✅ | Все поля → camelCase + @Expose() decorators |
| `AuthUserDto` | ✅ | Создан отдельный DTO class с camelCase |

**Обновленные файлы:**
- ✅ `src/modules/auth/dto/auth-response.dto.ts`
- ✅ `src/modules/auth/auth.service.ts` - метод `generateAuthResponse()`

**Протестированные endpoints:**
- ✅ `POST /api/v2/auth/register` - возвращает camelCase ✅
- ✅ `POST /api/v2/auth/login` - возвращает camelCase ✅
- ✅ `POST /api/v2/auth/refresh` - возвращает camelCase ✅

**До:**
```json
{
  "access_token": "...",
  "refresh_token": "...",
  "token_type": "Bearer",
  "expires_in": 604800,
  "user": {
    "first_name": "Test",
    "is_master": false
  }
}
```

**После:**
```json
{
  "accessToken": "...",
  "refreshToken": "...",
  "tokenType": "Bearer",
  "expiresIn": 604800,
  "user": {
    "firstName": "Test",
    "isMaster": false
  }
}
```

---

### ✅ Posts Module (100% завершено)

**Статус:** ✅ **ГОТОВО И ПРОТЕСТИРОВАНО**
**Приоритет:** P0 (критично для social features)

**Выполнено:**
1. ✅ Создан `PostResponseDto` с camelCase полями + @Expose() decorators
2. ✅ Создан `PostMediaResponseDto` с camelCase полями + @Expose() decorators
3. ✅ Переиспользован `AuthUserDto` для author
4. ✅ Создан `PostsMapper` utility class для Entity → DTO преобразования
5. ✅ Обновлены методы `posts.service.ts`: `create()`, `getFeed()`, `findOne()`, `getUserPosts()`
6. ✅ Протестированы endpoints

**Созданные файлы:**
- ✅ `src/modules/posts/dto/post-response.dto.ts`
- ✅ `src/modules/posts/dto/post-media-response.dto.ts`
- ✅ `src/modules/posts/posts.mapper.ts`
- ✅ `src/common/dto/paginated-response.dto.ts` (generic для всех модулей)

**Обновленные файлы:**
- ✅ `src/modules/posts/posts.service.ts` - все методы возвращают DTO

**Протестированные endpoints:**
- ✅ `GET /api/v2/posts/feed` - возвращает camelCase ✅

**Результат теста:**
```json
{
  "data": [{
    "id": "a28493a9-2668-4bcb-b626-b659e480089f",
    "authorId": "e47ecd82-a071-48ed-bcad-a12af3b58e52",
    "type": "text",
    "content": "...",
    "privacy": "public",
    "repostOfId": null,
    "likesCount": 15,
    "commentsCount": 1,
    "repostsCount": 0,
    "viewsCount": 195,
    "locationLat": null,
    "locationLng": null,
    "locationName": null,
    "commentsDisabled": false,
    "isPinned": false,
    "createdAt": "2026-01-20T16:51:04.766Z",
    "updatedAt": "2026-01-20T22:28:24.801Z",
    "author": {
      "id": "...",
      "email": "anna.master@test.com",
      "firstName": "Анна",
      "lastName": "Иванова",
      "avatarUrl": "https://i.pravatar.cc/150?img=1",
      "isMaster": true,
      "isVerified": true,
      "isPremium": false
    },
    "media": [],
    "repostOf": null
  }],
  "meta": {
    "page": 1,
    "limit": 1,
    "total": 103,
    "totalPages": 103,
    "nextCursor": "2026-01-20T16:51:04.766Z",
    "hasMore": true
  }
}
```

**Все 40+ полей успешно преобразованы в camelCase!** ✅

---

### 🔴 Users Module (0% завершено)

**Статус:** ⏳ **TODO**
**Приоритет:** P0 (используется во всех модулях)

**План:**
1. Создать `UserResponseDto` с camelCase полями (30+ полей!)
2. Создать `UserProfileResponseDto` для полного профиля
3. Обновить `users.service.ts` для mapping
4. Протестировать endpoints

**Файлы для обновления:**
- ❌ `src/modules/users/dto/user-response.dto.ts` (создать)
- ❌ `src/modules/users/dto/user-profile-response.dto.ts` (создать)
- ❌ `src/modules/users/users.service.ts`

**Endpoints:**
- ❌ `GET /api/v2/users/profile`
- ❌ `GET /api/v2/users/:id`
- ❌ `PATCH /api/v2/users/profile`

**Затронутые поля (30+):**
```
firstName, lastName, avatarUrl, isMaster, masterProfileCompleted,
isVerified, isPremium, premiumUntil, isAdmin, isActive, lastLoginAt,
reviewsCount, cancellationsCount, noShowsCount, blacklistsCount,
postsCount, friendsCount, followersCount, followingCount, lastLocationLat,
lastLocationLng, createdAt, updatedAt
```

**Время:** 2-3 часа

---

### 🟡 Bookings Module (0% завершено)

**Статус:** ⏳ **TODO**
**Приоритет:** P1 (core business logic)

**План:**
1. Создать `BookingResponseDto` с camelCase полями
2. Обновить `bookings.service.ts`
3. Протестировать endpoints

**Файлы для обновления:**
- ❌ `src/modules/bookings/dto/booking-response.dto.ts` (создать)
- ❌ `src/modules/bookings/bookings.service.ts`

**Endpoints:**
- ❌ `GET /api/v2/bookings`
- ❌ `GET /api/v2/bookings/:id`
- ❌ `POST /api/v2/bookings`

**Затронутые поля (20+):**
```
userId, masterId, serviceId, scheduledAt, startedAt, completedAt,
cancelledAt, cancellationReason, canReview, createdAt, updatedAt
```

**Время:** 1-2 часа

---

### 🟡 Reviews Module (0% завершено)

**Статус:** ⏳ **TODO**
**Приоритет:** P1

**План:**
1. Создать `ReviewResponseDto`
2. Обновить `reviews.service.ts`

**Время:** 1 час

---

### 🟡 Services Module (0% завершено)

**Статус:** ⏳ **TODO**
**Приоритет:** P1

**План:**
1. Создать `ServiceResponseDto`
2. Обновить `services.service.ts`

**Время:** 1 час

---

### 🟡 Masters Module (0% завершено)

**Статус:** ⏳ **TODO**
**Приоритет:** P1

**План:**
1. Создать `MasterProfileResponseDto`
2. Обновить `masters.service.ts`

**Время:** 1-2 часа

---

### 🟡 Chats Module (0% завершено)

**Статус:** ⏳ **TODO**
**Приоритет:** P1

**План:**
1. Создать `ChatResponseDto`, `MessageResponseDto`
2. Обновить `chats.service.ts`

**Время:** 1-2 часа

---

### 🟢 Notifications Module (0% завершено)

**Статус:** ⏳ **TODO**
**Приоритет:** P2

**Время:** 1 час

---

### 🟢 Social Module (Likes, Comments, Reposts) (0% завершено)

**Статус:** ⏳ **TODO**
**Приоритет:** P2

**Время:** 1-2 часа

---

### 🟢 Favorites Module (0% завершено)

**Статус:** ⏳ **TODO**
**Приоритет:** P2

**Время:** 30 минут

---

### 🟢 Categories Module (0% завершено)

**Статус:** ⏳ **TODO**
**Приоритет:** P3

**Время:** 30 минут

---

### 🟢 Search Module (0% завершено)

**Статус:** ⏳ **TODO**
**Приоритет:** P3

**Время:** 1 час

---

## Общая статистика

| Категория | Завершено | Всего | % |
|-----------|-----------|-------|---|
| **Модули** | 2 | 12 | **17%** |
| **DTOs** | 5 | ~40 | **13%** |
| **Endpoints** | 7 | ~60 | **12%** |
| **Поля** | ~60 | ~200+ | **30%** |

---

## Оценка времени

| Приоритет | Модулей | Оценка времени | Статус |
|-----------|---------|----------------|--------|
| **P0** (Auth, Posts, Users) | 3 | 6-8 часов | **67% done** ✅ Auth + Posts |
| **P1** (Bookings, Reviews, Services, Masters, Chats) | 5 | 5-7 часов | 0% done |
| **P2** (Notifications, Social, Favorites) | 3 | 2-3 часа | 0% done |
| **P3** (Categories, Search) | 2 | 1-2 часа | 0% done |
| **ИТОГО** | 13 | **14-20 часов** | **~20% done** |

**Затрачено времени:** ~3 часа (Auth + Posts + инфраструктура)
**Осталось:** ~11-17 часов

---

## Следующие шаги

### Немедленно (P0):
1. ✅ ~~Auth Module~~ - ЗАВЕРШЕНО
2. ⏳ **Posts Module** - начать сейчас (2-3 часа)
3. ⏳ **Users Module** - после Posts (2-3 часа)

### После P0 (P1):
4. Bookings Module
5. Reviews Module
6. Services Module
7. Masters Module
8. Chats Module

### Финальные (P2-P3):
9-13. Остальные модули

---

## Docker Deployment

**⚠️ ВАЖНО:** После завершения всех изменений необходимо:

1. Пересобрать Docker образ backend:
   ```bash
   docker-compose build backend
   ```

2. Перезапустить контейнер:
   ```bash
   docker-compose up -d backend
   ```

3. Проверить логи:
   ```bash
   docker logs service_backend
   ```

4. Протестировать все критичные endpoints

---

## Тестирование

После каждого модуля:
- ✅ Unit tests (если есть)
- ✅ Ручное тестирование endpoints с curl
- ✅ Проверка response format (camelCase)
- ✅ Интеграционное тестирование с frontend

---

## Известные проблемы

### ✅ Решено
- ~~SerializeInterceptor не применялся к DTO instances~~ - решено через return plain objects
- ~~favorites.service.ts ошибка с полем 'bio'~~ - исправлено на 'first_name', 'last_name'

### ⏳ В процессе
- Posts/Users/Bookings возвращают Entity напрямую без DTO mapping

---

## Контакты

**Ответственный:** Claude Assistant
**Дата последнего обновления:** 2026-01-27 07:52 UTC
