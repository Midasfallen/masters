# Plan: Экран "Чаты" — полная интеграция frontend + backend

**Дата:** 6-7 февраля 2026
**Статус:** ✅ Выполнено (все 5 фаз завершены)

---

## Текущее состояние

**Backend** — реализован полностью: 2 контроллера, 2 сервиса, 3 entity, 10+ DTO, WebSocket gateway, seed данные.
**Frontend** — полностью интегрирован с backend API. Все 8 критических расхождений исправлены.

---

## Критические расхождения (все исправлены)

### 1. ✅ MessageType enum не совпадает — ИСПРАВЛЕНО
Frontend теперь использует 8 типов, идентичных backend: text, photo, video, voice, location, profileShare, postShare, bookingProposal.

### 2. ✅ API маршруты сообщений — ИСПРАВЛЕНО
Frontend корректно использует `GET/POST /messages` с `chat_id` в query/body.

### 3. ✅ MessageModel — ДОПОЛНЕНО
Все 12+ отсутствующих полей добавлены: `thumbnailUrl`, `mediaMetadata`, `locationLat/Lng/Name`, `sharedProfileId`, `sharedPostId`, `bookingProposalId`, `replyToId`, `readCount`, `isEdited`, `isDeleted`.

### 4. ✅ SendMessageRequest — ИСПРАВЛЕНО
`chatId` передаётся через `@JsonKey(name: 'chat_id')` в body.

### 5. ✅ MarkAsRead — ИСПРАВЛЕНО
Передаёт `{ message_id }` в body.

### 6. ✅ WebSocket connect() — ИСПРАВЛЕНО
Вызывается в `auth_provider.dart` после login/register/restore session. Disconnect при logout.

### 7. ✅ WebSocket event payload — ИСПРАВЛЕНО
Используется `ChatsMapper.toMessageDto()` для единообразного формата.

### 8. ✅ sender в toMessageDto() — ИСПРАВЛЕНО
Маппер включает `sender` в каждый DTO сообщения.

---

## Фаза 1: Backend — исправления и верификация ✅

### 1.1 ✅ Добавить `sender` в MessageResponseDto и mapper

**Файлы:**
- `backend/src/modules/chats/dto/message-response.dto.ts` — добавлено поле `sender?: ChatUserResponseDto`
- `backend/src/modules/chats/chats.mapper.ts` — добавлен маппинг sender

### 1.2 ✅ Исправить WebSocket event payload

**Файл:** `backend/src/modules/chats/messages.service.ts`

Ручной маппинг заменён на `ChatsMapper.toMessageDto(messageWithSender)`.

### 1.3 ✅ Добавить `lastMessage` в ChatResponseDto

**Файлы:**
- `backend/src/modules/chats/dto/chat-response.dto.ts` — добавлено `lastMessage?: MessageResponseDto`
- `backend/src/modules/chats/chats.service.ts` — в `findAll()` batch-загрузка последних сообщений через `In(lastMessageIds)`

### 1.4 ✅ Seed данные для чатов

**Файл:** `backend/src/database/seeds/test-data.seed.ts`

Добавлены:
- Чат 1: Мария ↔ Анна (6 сообщений о стрижке)
- Чат 2: Иван ↔ Дмитрий (8 сообщений о бороде, 2 непрочитанных)
- Чат 3: Ольга ↔ Елена (6 сообщений о маникюре)

### 1.5 ⏳ Ручное тестирование API

Через Swagger (`http://localhost:3000/api/v2/docs`):
1. `POST /chats` — создание direct чата
2. `GET /chats` — список чатов (проверить `otherUser`, `myParticipant`, `lastMessage`)
3. `POST /messages` с body `{ chat_id, type: "text", content: "test" }`
4. `GET /messages?chat_id=xxx` — получение сообщений (проверить `sender`)
5. `POST /chats/:id/read` с body `{ message_id: "xxx" }`
6. `POST /chats/:id/pin` и `POST /chats/:id/unpin`

---

## Фаза 2: Frontend — синхронизация моделей ✅

### 2.1 ✅ Обновить MessageType enum

**Файл:** `frontend/lib/core/models/api/chat_model.dart`

8 типов: text, photo, video, voice, location, profileShare, postShare, bookingProposal.

### 2.2 ✅ Обновить MessageModel

Добавлены все поля из backend `MessageResponseDto`. `content` nullable. `isRead`/`readAt` заменены на `readCount`.

### 2.3 ✅ Обновить SendMessageRequest

Добавлен `chatId` с `@JsonKey(name: 'chat_id')` и все опциональные поля с snake_case JsonKeys.

### 2.4 ✅ Кодогенерация

`dart run build_runner build --delete-conflicting-outputs` — успешно.

---

## Фаза 3: Frontend — исправление API маршрутов ✅

### 3.1 ✅ Обновить API endpoints

**Файл:** `frontend/lib/core/api/api_endpoints.dart`

Удалены `chatMessages()`, `chatSendMessage()`. Добавлены `messages`, `chatPin()`, `chatUnpin()`.

### 3.2 ✅ Обновить ChatRepository

**Файл:** `frontend/lib/core/repositories/chat_repository.dart`

| Метод | Изменение |
|-------|-----------|
| `getMessages()` | URL: `ApiEndpoints.messages`, `chat_id` в queryParameters |
| `sendMessage()` | Единственный параметр `SendMessageRequest` (chatId в body) |
| `markAsRead()` | Добавлен `messageId`, передаётся в body |
| `deleteChat()` | Новый метод: `DELETE /chats/:id` |
| `pinChat/unpinChat` | Используют `ApiEndpoints.chatPin/chatUnpin` |

### 3.3 ✅ Обновить ChatNotifier

**Файл:** `frontend/lib/core/providers/api/chats_provider.dart`

- `sendMessage()` — chatId через `SendMessageRequest`, добавлен `replyToId`
- `markAsRead()` — добавлен `messageId`
- Добавлены `deleteChat()`, `unreadChatsCountProvider`

---

## Фаза 4: WebSocket интеграция ✅

### 4.1 ✅ Автоматическое подключение при авторизации

**Файл:** `frontend/lib/core/providers/api/auth_provider.dart`

- `_connectWebSocket()` вызывается после login/register/restore session
- `disconnect()` при logout

### 4.2 ✅ Гибридный подход: REST + WebSocket

**Файл:** `frontend/lib/features/chats/screens/chat_screen.dart`

Отправка через REST `chatNotifierProvider.notifier.sendMessage()`, получение через WS listener.

### 4.3 ✅ WebSocket listener с дедупликацией

Обработка `chat:message:new`:
- Парсинг через `MessageModel.fromJson(data)`
- Дедупликация: `senderId == currentUserId && messages.any(m.id == newMessage.id)`
- Добавление в список + автоскролл

### 4.4 ✅ Mark as read через REST

Единственный REST вызов `POST /chats/:id/read` с `{ message_id }` (ID последнего сообщения).

---

## Фаза 5: UI/UX — убирание заглушек ✅

### 5.1 ✅ "Новый чат" — диалог создания

**Файл:** `frontend/lib/features/chats/widgets/new_chat_dialog.dart`

DraggableScrollableSheet с поиском по подпискам пользователя. Выбор → `createChat(userId)` → переход на `ChatScreen`.

### 5.2 ✅ "Удаление чата"

**Файл:** `frontend/lib/features/chats/screens/chats_list_screen.dart`

AlertDialog подтверждение + `chatNotifier.deleteChat()`.

### 5.3 ✅ MessageBubble — новые типы

**Файл:** `frontend/lib/features/chats/widgets/message_bubble.dart`

- `text` — обычный текст
- `photo` — `CachedNetworkImage` из `message.mediaUrl`
- `video`, `voice`, `location`, `profileShare`, `postShare`, `bookingProposal` — placeholder-карточки
- Поддержка `isDeleted`, `isEdited`, `readCount`

### 5.4 ✅ Меню чата (три точки)

**Файл:** `frontend/lib/features/chats/screens/chat_screen.dart`

BottomSheet с действиями:
- Закрепить/открепить чат (pin/unpin)
- Удалить чат (с подтверждением)

### 5.5 ✅ Badge непрочитанных — реальный provider

**Файл:** `frontend/lib/core/providers/api/chats_provider.dart`

Новый `unreadChatsCountProvider` — суммирует `myParticipant.unreadCount` по всем чатам.

**Файл:** `frontend/lib/shared/widgets/main_navigation_screen.dart`

Заменён `unreadMessagesCountProvider` (mock) на `unreadChatsCountProvider` (реальный API).

### 5.6 ✅ Удалить старые mock модели

Удалены:
- `frontend/lib/core/models/chat.dart` + `.freezed.dart` + `.g.dart`
- `frontend/lib/core/models/message.dart` + `.freezed.dart` + `.g.dart`
- `mockChatsProvider`, `mockMessagesProvider`, `unreadMessagesCountProvider` из `mock_data_provider.dart`

---

## Приоритетный порядок реализации

| # | Задача | Статус |
|---|--------|--------|
| 1 | Backend: sender в DTO + mapper | ✅ Выполнено |
| 2 | Backend: WS payload через mapper | ✅ Выполнено |
| 3 | Backend: lastMessage в ChatResponseDto | ✅ Выполнено |
| 4 | Frontend: chat_model.dart (MessageType, MessageModel, SendMessageRequest, MediaMetadataModel) | ✅ Выполнено |
| 5 | Frontend: кодогенерация freezed + riverpod | ✅ Выполнено |
| 6 | Frontend: api_endpoints + repository + provider | ✅ Выполнено |
| 7 | Frontend: WS connect() в auth flow | ✅ Выполнено |
| 8 | Frontend: chat_screen.dart (REST + WS + дедупликация) | ✅ Выполнено |
| 9 | Frontend: UI/UX — MessageBubble типы, удаление чата, lastMessage preview | ✅ Выполнено |
| 10 | Backend: seed данные для чатов | ✅ Выполнено |
| 11 | Backend: тестирование API через Swagger | ⏳ Ручное |
| 12 | Frontend: "Новый чат" диалог | ✅ Выполнено |
| 13 | Frontend: Меню чата (три точки) | ✅ Выполнено |
| 14 | Frontend: Badge непрочитанных (реальный provider) | ✅ Выполнено |
| 15 | Frontend: Очистка mock моделей | ✅ Выполнено |

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

## Изменённые файлы (финальный список)

**Backend:**
- `backend/src/modules/chats/dto/message-response.dto.ts` — sender поле
- `backend/src/modules/chats/chats.mapper.ts` — маппинг sender
- `backend/src/modules/chats/messages.service.ts` — WS payload через mapper
- `backend/src/modules/chats/chats.service.ts` — lastMessage batch-загрузка
- `backend/src/modules/chats/dto/chat-response.dto.ts` — lastMessage поле
- `backend/src/database/seeds/test-data.seed.ts` — 3 чата с сообщениями

**Frontend:**
- `frontend/lib/core/models/api/chat_model.dart` — все модели синхронизированы
- `frontend/lib/core/api/api_endpoints.dart` — корректные маршруты
- `frontend/lib/core/repositories/chat_repository.dart` — URL, параметры, deleteChat
- `frontend/lib/core/providers/api/chats_provider.dart` — notifier + unreadChatsCount
- `frontend/lib/core/providers/api/auth_provider.dart` — WS connect/disconnect
- `frontend/lib/features/chats/screens/chat_screen.dart` — REST отправка, WS listener, дедупликация, меню
- `frontend/lib/features/chats/screens/chats_list_screen.dart` — новый чат, удаление, preview
- `frontend/lib/features/chats/widgets/message_bubble.dart` — 8 типов сообщений
- `frontend/lib/features/chats/widgets/new_chat_dialog.dart` — NEW: диалог создания чата
- `frontend/lib/shared/widgets/main_navigation_screen.dart` — реальный badge provider
- `frontend/lib/core/providers/mock_data_provider.dart` — очищены чат-моки

**Удалены:**
- `frontend/lib/core/models/chat.dart` + `.freezed.dart` + `.g.dart`
- `frontend/lib/core/models/message.dart` + `.freezed.dart` + `.g.dart`

**Тесты обновлены:**
- `frontend/test/repositories/chat_repository_test.dart` — новые сигнатуры
