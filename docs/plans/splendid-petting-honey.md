# Исправление "Новый чат" + поиск по всем пользователям + план тестирования

## Проблема

При нажатии "Создать чат" диалог NewChatDialog показывает:
```
Ошибка: Type error: null: type 'Null' is not a subtype of type 'String'
```

## Корень проблемы

Backend `GET /subscriptions/following` возвращает raw **Subscription entity** (snake_case), а frontend пытает десериализовать как `UserModel` (camelCase). `json['firstName']` = null → Type error.

## Новое требование

Любой пользователь может написать любому другому пользователю. Диалог "Новый чат" должен показывать **серверный поиск по всем пользователям** через Meilisearch, а не только подписки.

---

## Часть 1: Backend — исправление /subscriptions/following

**Файл:** `backend/src/modules/friends/subscriptions.service.ts`

Импортировать `UsersMapper` и маппить результат:
```typescript
import { UsersMapper } from '../users/users.mapper';

// getFollowing(): строка ~85
data: subscriptions.map(s => UsersMapper.toDto(s.target)),

// getFollowers(): строка ~110
data: subscriptions.map(s => UsersMapper.toDto(s.subscriber)),
```

---

## Часть 2: Backend — Meilisearch индекс `users` + endpoint `GET /search/users`

### Шаг 2.1: search-response.dto.ts — добавить UserSearchResultDto

**Файл:** `backend/src/modules/search/dto/search-response.dto.ts`

Добавить новый DTO (по аналогии с MasterSearchResultDto, но для всех users):
```typescript
export class UserSearchResultDto {
  id: string;
  firstName: string;
  lastName: string;
  fullName: string;
  avatarUrl: string | null;
  isMaster: boolean;
  isVerified: boolean;
}
```

### Шаг 2.2: search-users.dto.ts — создать DTO запроса

**Файл:** `backend/src/modules/search/dto/search-users.dto.ts` (новый)

```typescript
export class SearchUsersDto {
  query?: string;
  page?: number;
  limit?: number;
}
```

### Шаг 2.3: search.service.ts — добавить индекс и методы

**Файл:** `backend/src/modules/search/search.service.ts`

1. Добавить `private usersIndex;`
2. В `onModuleInit()`:
   - Создать индекс: `this.usersIndex = this.meiliClient.index('users')`
   - Настроить searchable: `['first_name', 'last_name', 'email']`
   - filterable: `['is_master', 'is_verified']`
3. Добавить метод `indexUser(userId)` — индексирует одного пользователя
4. Добавить метод `searchUsers(dto)` — поиск по индексу users
5. В `reindexAll()` — добавить переиндексацию всех активных пользователей
6. Добавить fallback `fallbackSearchUsers()` через PostgreSQL ILIKE

### Шаг 2.4: search.controller.ts — добавить endpoint

**Файл:** `backend/src/modules/search/search.controller.ts`

Добавить `GET /search/users?q=...&page=1&limit=20` (с `@UseGuards(JwtAuthGuard)`, не Public):
- Возвращает `SearchResponseDto<UserSearchResultDto>`
- Исключает текущего пользователя из результатов (передавать userId)

### Шаг 2.5: Индексация при регистрации и обновлении профиля

**При регистрации:** `backend/src/modules/auth/auth.service.ts`
Вызывать `searchService.indexUser(userId)` после создания пользователя.

**При обновлении профиля:** `backend/src/modules/users/users.service.ts`
Вызывать `searchService.indexUser(userId)` после update (имя, аватар и т.д.), чтобы поиск отражал актуальные данные.

---

## Часть 3: Frontend — переделать NewChatDialog на поиск по всем пользователям

### Шаг 3.1: api_endpoints.dart — добавить endpoint

**Файл:** `frontend/lib/core/api/api_endpoints.dart`

```dart
static const String searchUsers = '/search/users';
```

### Шаг 3.2: chat_repository.dart — добавить метод поиска

**Файл:** `frontend/lib/core/repositories/chat_repository.dart`

```dart
Future<List<UserModel>> searchUsers(String query, {int page = 1, int limit = 20}) async {
  final response = await _client.get(ApiEndpoints.searchUsers, queryParameters: {
    'q': query, 'page': page, 'limit': limit,
  });
  final data = ApiHelpers.parseListResponse(response.data);
  return data.map((json) => UserModel.fromJson(json as Map<String, dynamic>)).toList();
}
```

### Шаг 3.3: chats_provider.dart — добавить провайдер поиска

**Файл:** `frontend/lib/core/providers/api/chats_provider.dart`

```dart
@riverpod
Future<List<UserModel>> searchUsersForChat(SearchUsersForChatRef ref, String query) async {
  if (query.trim().isEmpty) return [];
  final repository = ref.watch(chatRepositoryProvider);
  return await repository.searchUsers(query);
}
```

### Шаг 3.4: new_chat_dialog.dart — переделать UI

**Файл:** `frontend/lib/features/chats/widgets/new_chat_dialog.dart`

Вместо `mySubscriptionsListProvider()` использовать `searchUsersForChatProvider(query)`:
- При пустой строке поиска → показывать подсказку "Введите имя пользователя"
- При вводе текста (debounce ~300ms) → серверный поиск через `GET /search/users?q=...`
- Показывать результаты поиска как список пользователей
- При пустых результатах → "Никого не найдено"
- Убрать зависимость от `subscriptions_provider.dart`

---

## Часть 4: Backend type-check

```bash
npx tsc --noEmit
```

---

## Критические файлы

| Файл | Действие |
|------|----------|
| `backend/src/modules/friends/subscriptions.service.ts` | Маппинг через UsersMapper |
| `backend/src/modules/search/search.service.ts` | Новый индекс `users`, методы `indexUser()`, `searchUsers()` |
| `backend/src/modules/search/search.controller.ts` | Новый endpoint `GET /search/users` |
| `backend/src/modules/search/dto/search-response.dto.ts` | Новый `UserSearchResultDto` |
| `backend/src/modules/search/dto/search-users.dto.ts` | Новый файл — DTO запроса |
| `frontend/lib/core/api/api_endpoints.dart` | Добавить `searchUsers` |
| `frontend/lib/core/repositories/chat_repository.dart` | Метод `searchUsers()` |
| `frontend/lib/core/providers/api/chats_provider.dart` | Провайдер `searchUsersForChat` |
| `frontend/lib/features/chats/widgets/new_chat_dialog.dart` | Переделать на серверный поиск |

**Переиспользуемые утилиты (без изменений):**
| Файл | Что используем |
|------|---------------|
| `backend/src/modules/users/users.mapper.ts` | `UsersMapper.toDto()` |
| `frontend/lib/core/models/api/user_model.dart` | `UserModel.fromJson()` |
| `frontend/lib/core/api/api_helpers.dart` | `ApiHelpers.parseListResponse()` |

---

## План тестирования

### Подготовка
1. Пересидировать БД: `npm run seed`
2. Запустить backend: `npm run start:dev` (Meilisearch проиндексирует users при старте)
3. Запустить frontend: `flutter run -d chrome`

### Seed-аккаунты
| Email | Имя | Роль | Пароль |
|-------|-----|------|--------|
| maria.student@test.com | Мария Козлова | Клиент | qwerty123 |
| ivan.student@test.com | Иван Сидоров | Клиент | qwerty123 |
| anna.master@test.com | Анна Иванова | Мастер | qwerty123 |
| dmitry.master@test.com | Дмитрий Петров | Мастер | qwerty123 |
| elena.master@test.com | Елена Смирнова | Мастер | qwerty123 |

### Тесты

**Тест 1: Диалог "Новый чат" — начальное состояние**
1. Войти как maria.student@test.com
2. Открыть "Создать чат"
3. Ожидание: подсказка "Введите имя пользователя" (поле поиска пустое)

**Тест 2: Поиск пользователя по имени**
1. Ввести "Анна" в строку поиска
2. Ожидание: появляется Анна Иванова (мастер) в результатах

**Тест 3: Поиск обычного пользователя (не мастера)**
1. Ввести "Иван"
2. Ожидание: появляется Иван Сидоров (клиент) — подтверждает, что поиск по ВСЕМ users

**Тест 4: Пустой результат поиска**
1. Ввести "xyz12345"
2. Ожидание: "Никого не найдено"

**Тест 5: Создание нового чата**
1. Найти и выбрать пользователя
2. Ожидание: переход на экран чата, чат в списке

**Тест 6: Открытие существующего чата (дедупликация)**
1. Выбрать Анну (с которой у Марии уже есть seed-чат)
2. Ожидание: переход в существующий чат (backend не создаёт дубль)

**Тест 7: Отправка сообщения**
1. В открытом чате набрать и отправить текст
2. Ожидание: сообщение появляется, `lastMessage` обновляется

**Тест 8: WebSocket real-time**
1. Открыть 2 вкладки (Мария + Анна)
2. Отправить от Марии → сообщение появляется у Анны

**Тест 9: Текущий пользователь не в результатах поиска**
1. Ввести "Мария" (своё имя)
2. Ожидание: текущий пользователь НЕ отображается в результатах
