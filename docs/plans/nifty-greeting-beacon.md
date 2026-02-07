# Plan: Экран "Чаты" — полная интеграция frontend + backend

**Дата:** 6 февраля 2026
**Статус:** Планирование

---

## Текущее состояние

**Backend** — реализован полностью: 2 контроллера, 2 сервиса, 3 entity, 10+ DTO, WebSocket gateway.
**Frontend** — экраны написаны, но НЕ РАБОТАЮТ из-за 6 критических расхождений с backend API.

---

## Критические расхождения (блокирующие)

### 1. MessageType enum не совпадает
| Frontend (`chat_model.dart:113`) | Backend (`message.entity.ts`) |
|---|---|
| `text` | `text` |
| `image` | `photo` |
| `file` | **нет** |
| `booking` | `booking_proposal` |
| `system` | **нет** |
| **нет** | `video`, `voice`, `location`, `profile_share`, `post_share` |

### 2. API маршруты сообщений не совпадают
- Frontend шлет на: `GET/POST /chats/:chatId/messages`
- Backend слушает: `GET/POST /messages` (с `chat_id` в query/body)

### 3. MessageModel не содержит полей backend
Отсутствуют: `thumbnailUrl`, `mediaMetadata`, `locationLat/Lng/Name`, `sharedProfileId`, `sharedPostId`, `bookingProposalId`, `replyToId`, `readCount`, `isEdited`, `isDeleted`

### 4. SendMessageRequest не содержит `chat_id`
Frontend передает `chatId` через URL, но backend ожидает `chat_id` в body (route `/messages`)

### 5. MarkAsRead — frontend не передает `message_id`
Frontend: `POST /chats/:id/read` без body.
Backend: ожидает `{ message_id: UUID }` в body (`mark-as-read.dto.ts`)

### 6. WebSocket `connect()` нигде не вызывается
`websocket_service.dart` создается, но `connect()` не вызывается — весь real-time мертвый.

### 7. WebSocket event payload смешанный формат
`messages.service.ts:87-109` — `senderId` (camelCase) рядом с `sender_name` (snake_case). Нужно использовать `ChatsMapper.toMessageDto()`.

### 8. `sender` не маппится в `toMessageDto()`
`chats.mapper.ts:105-128` — поле `sender` не включается в DTO, хотя Swagger пример его показывает.

---

## Фаза 1: Backend — исправления и верификация

### 1.1 Добавить `sender` в MessageResponseDto и mapper

**Файлы:**
- `backend/src/modules/chats/dto/message-response.dto.ts` — добавить поле `sender?: ChatUserResponseDto`
- `backend/src/modules/chats/chats.mapper.ts:105-128` — добавить маппинг sender:
```typescript
static toMessageDto(message: Message): MessageResponseDto {
  const dto = { /* ...существующие поля... */ };
  if (message.sender) {
    (dto as any).sender = ChatsMapper.toUserDto(message.sender);
  }
  return dto;
}
```

### 1.2 Исправить WebSocket event payload

**Файл:** `backend/src/modules/chats/messages.service.ts:87-109`

Заменить ручной маппинг на:
```typescript
this.websocketGateway.sendMessageToChat(chat_id, 'chat:message:new',
  ChatsMapper.toMessageDto(messageWithSender)
);
```

### 1.3 Добавить `lastMessage` в ChatResponseDto

**Файлы:**
- `backend/src/modules/chats/dto/chat-response.dto.ts` — добавить `lastMessage?: MessageResponseDto`
- `backend/src/modules/chats/chats.mapper.ts` — в `toFullChatDto()` маппить lastMessage
- `backend/src/modules/chats/chats.service.ts` — в `findAll()` добавить join последнего сообщения

### 1.4 Seed данные для чатов

**Файл:** `backend/src/database/seeds/test-data.seed.ts`

Добавить:
- 2-3 direct чата между seed-пользователями
- 5-10 сообщений в каждом чате

### 1.5 Ручное тестирование API

Через Swagger (`http://localhost:3000/api/v2/docs`):
1. `POST /chats` — создание direct чата
2. `GET /chats` — список чатов (проверить `otherUser`, `myParticipant`, `lastMessage`)
3. `POST /messages` с body `{ chat_id, type: "text", content: "test" }`
4. `GET /messages?chat_id=xxx` — получение сообщений (проверить `sender`)
5. `POST /chats/:id/read` с body `{ message_id: "xxx" }`
6. `POST /chats/:id/pin` и `POST /chats/:id/unpin`

---

## Фаза 2: Frontend — синхронизация моделей

### 2.1 Обновить MessageType enum

**Файл:** `frontend/lib/core/models/api/chat_model.dart:113-124`

```dart
enum MessageType {
  @JsonValue('text') text,
  @JsonValue('photo') photo,
  @JsonValue('video') video,
  @JsonValue('voice') voice,
  @JsonValue('location') location,
  @JsonValue('profile_share') profileShare,
  @JsonValue('post_share') postShare,
  @JsonValue('booking_proposal') bookingProposal,
}
```

### 2.2 Обновить MessageModel

**Файл:** `frontend/lib/core/models/api/chat_model.dart:92-111`

Добавить все поля из backend `MessageResponseDto`:
- `thumbnailUrl`, `mediaMetadata` (Map), `locationLat/Lng/Name`
- `sharedProfileId`, `sharedPostId`, `bookingProposalId`, `replyToId`
- `readCount` (int), `isEdited` (bool), `isDeleted` (bool)
- Убрать `isRead` и `readAt` (заменить на `readCount`)
- Сделать `content` nullable (String?)

### 2.3 Обновить SendMessageRequest

**Файл:** `frontend/lib/core/models/api/chat_model.dart:141-152`

Добавить `chatId` (`@JsonKey(name: 'chat_id')`) и все опциональные поля:
- `thumbnailUrl`, `mediaMetadata`, `locationLat/Lng/Name`
- `sharedProfileId`, `sharedPostId`, `bookingProposalId`, `replyToId`

### 2.4 Кодогенерация

```bash
cd frontend && flutter pub run build_runner build --delete-conflicting-outputs
```

---

## Фаза 3: Frontend — исправление API маршрутов

### 3.1 Обновить API endpoints

**Файл:** `frontend/lib/core/api/api_endpoints.dart:92-98`

```dart
// CHATS
static const String chats = '/chats';
static String chatById(String id) => '/chats/$id';
static const String chatCreate = '/chats';
static const String messages = '/messages';                    // NEW: POST/GET
static String chatMarkRead(String chatId) => '/chats/$chatId/read';
static String chatPin(String chatId) => '/chats/$chatId/pin';     // NEW
static String chatUnpin(String chatId) => '/chats/$chatId/unpin'; // NEW
```

Удалить: `chatMessages()`, `chatSendMessage()`

### 3.2 Обновить ChatRepository

**Файл:** `frontend/lib/core/repositories/chat_repository.dart`

| Метод | Изменение |
|-------|-----------|
| `getMessages()` | URL: `ApiEndpoints.messages`, добавить `chat_id` в queryParameters |
| `sendMessage()` | URL: `ApiEndpoints.messages`, `chatId` теперь в body через DTO |
| `markAsRead()` | Добавить параметр `messageId`, передавать в body: `{'message_id': messageId}` |
| `pinChat()` | Использовать `ApiEndpoints.chatPin(chatId)` вместо хардкода |
| `unpinChat()` | Использовать `ApiEndpoints.chatUnpin(chatId)` вместо хардкода |
| `deleteChat()` | **НОВЫЙ** метод: `DELETE /chats/:id` |

### 3.3 Обновить ChatNotifier

**Файл:** `frontend/lib/core/providers/api/chats_provider.dart`

- `sendMessage()` — передавать `chatId` через `SendMessageRequest`
- `markAsRead()` — добавить параметр `messageId`
- Добавить метод `deleteChat()`

---

## Фаза 4: WebSocket интеграция

### 4.1 Автоматическое подключение при авторизации

**Файл:** `frontend/lib/core/providers/api/auth_provider.dart` (или аналог)

После успешного login:
```dart
ref.read(webSocketServiceProvider).connect('http://localhost:3000');
```
При logout:
```dart
ref.read(webSocketServiceProvider).disconnect();
```

### 4.2 Гибридный подход: REST + WebSocket

**Принцип:** Отправка через REST API (надёжно, с сохранением), получение через WebSocket (real-time).

**Файл:** `frontend/lib/features/chats/screens/chat_screen.dart`

`_sendMessage()` — заменить WebSocket отправку на REST:
```dart
await ref.read(chatNotifierProvider.notifier).sendMessage(chatId, content);
// Сообщение придёт обратно через WS event 'chat:message:new'
```

### 4.3 WebSocket listener с дедупликацией

**Файл:** `frontend/lib/features/chats/screens/chat_screen.dart`

Обработка `chat:message:new`:
- Парсить через `MessageModel.fromJson(data)`
- Проверять на дубликат (мы сами отправили через REST)
- Добавлять в список + автоскролл

### 4.4 Mark as read через REST

**Файл:** `frontend/lib/features/chats/screens/chat_screen.dart`

Заменить WebSocket mark-as-read на REST endpoint (`POST /chats/:id/read`).

---

## Фаза 5: UI/UX — убирание заглушек

### 5.1 "Новый чат" — экран/диалог создания

**Файл:** `frontend/lib/features/chats/screens/chats_list_screen.dart`

Заменить заглушку "Новый чат (в разработке)" на:
- Диалог поиска пользователей или навигация на экран выбора
- Вызов `createChat(userId)` → переход на `ChatScreen`

**Новый файл (опционально):** `frontend/lib/features/chats/widgets/new_chat_dialog.dart`

### 5.2 "Удаление чата"

**Файл:** `frontend/lib/features/chats/screens/chats_list_screen.dart`

Заменить заглушку "Удаление чата (в разработке)" на AlertDialog + вызов `deleteChat()`.

### 5.3 MessageBubble — новые типы

**Файл:** `frontend/lib/features/chats/widgets/message_bubble.dart`

MVP-реализация:
- `text` — как есть
- `photo` — `CachedNetworkImage` из `message.mediaUrl`
- `video`, `voice`, `location`, `profileShare`, `postShare`, `bookingProposal` — placeholder-карточки с описанием типа

### 5.4 Меню чата (три точки)

**Файл:** `frontend/lib/features/chats/screens/chat_screen.dart`

Заменить заглушку "Меню (в разработке)" на BottomSheet:
- Закрепить/открепить чат
- Удалить чат

Звонки и видеозвонки — оставить заглушки (отдельная большая фича).

### 5.5 Badge непрочитанных — реальный provider

**Файл:** `frontend/lib/core/providers/api/chats_provider.dart`

Новый provider:
```dart
int unreadChatsCount => chats.fold(0, (sum, c) => sum + (c.myParticipant?.unreadCount ?? 0));
```

**Файл:** `frontend/lib/shared/widgets/main_navigation_screen.dart`
Заменить `unreadMessagesCountProvider` (из mock_data_provider) на `unreadChatsCountProvider`.

### 5.6 Удалить старые mock модели

**Удалить:**
- `frontend/lib/core/models/chat.dart`
- `frontend/lib/core/models/message.dart`
- Очистить `mockChatsProvider` из `mock_data_provider.dart`

---

## Порядок выполнения

```
Фаза 1 (Backend)        Фаза 2 (Модели)     ← параллельно
  1.1 sender в DTO         2.1 MessageType
  1.2 WS payload           2.2 MessageModel
  1.3 lastMessage           2.3 SendMessageRequest
  1.4 Seed данные          2.4 Кодогенерация
  1.5 Тестирование API
        │                      │
        └──────────┬───────────┘
                   ▼
           Фаза 3 (API маршруты)
             3.1 Endpoints
             3.2 Repository
             3.3 Provider
                   │
                   ▼
           Фаза 4 (WebSocket)
             4.1 Auto-connect
             4.2 REST отправка
             4.3 WS listener
             4.4 Mark as read
                   │
                   ▼
           Фаза 5 (UI/UX)
             5.1 Новый чат
             5.2 Удаление чата
             5.3 MessageBubble
             5.4 Меню чата
             5.5 Badge
             5.6 Очистка моков
```

**MVP (минимум для работающего чата):** Фазы 1-4 + шаги 5.3, 5.5

---

## Верификация

1. Запустить backend: `cd backend && npm run start:dev`
2. Запустить frontend: `cd frontend && flutter run -d chrome`
3. Авторизоваться пользователем из seed
4. Перейти на вкладку "Чаты" — должен загружаться список из API
5. Открыть чат — должны загружаться сообщения
6. Отправить текстовое сообщение — должно сохраниться в БД
7. Открыть второе окно браузера (другой пользователь) — проверить real-time доставку
8. Проверить typing indicator
9. Проверить badge непрочитанных на вкладке "Чаты"
10. Проверить pin/unpin чата

---

## Критические файлы

**Backend (изменения):**
- `backend/src/modules/chats/dto/message-response.dto.ts` — добавить sender
- `backend/src/modules/chats/chats.mapper.ts` — маппинг sender
- `backend/src/modules/chats/messages.service.ts:87-109` — WS payload
- `backend/src/modules/chats/chats.service.ts` — lastMessage join
- `backend/src/modules/chats/dto/chat-response.dto.ts` — lastMessage поле
- `backend/src/database/seeds/test-data.seed.ts` — seed чатов

**Frontend (изменения):**
- `frontend/lib/core/models/api/chat_model.dart` — ВСЕ модели
- `frontend/lib/core/api/api_endpoints.dart` — маршруты
- `frontend/lib/core/repositories/chat_repository.dart` — URL, параметры
- `frontend/lib/core/providers/api/chats_provider.dart` — notifier + badge
- `frontend/lib/core/services/websocket_service.dart` — connect()
- `frontend/lib/features/chats/screens/chat_screen.dart` — отправка, WS listener
- `frontend/lib/features/chats/screens/chats_list_screen.dart` — новый чат, удаление
- `frontend/lib/features/chats/widgets/message_bubble.dart` — новые типы
- `frontend/lib/shared/widgets/main_navigation_screen.dart` — badge provider
