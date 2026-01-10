# WEBSOCKET API SPECIFICATION - Service Platform v2.0

**Версия:** 2.0
**Дата:** 9 января 2026
**Статус:** Спецификация для реализации

---

## Содержание

1. [Обзор](#обзор)
2. [Подключение](#подключение)
3. [Аутентификация](#аутентификация)
4. [Системные события](#системные-события)
5. [События чатов](#события-чатов)
6. [События уведомлений](#события-уведомлений)
7. [События онлайн-статуса](#события-онлайн-статуса)
8. [События социальных функций](#события-социальных-функций)
9. [Обработка ошибок](#обработка-ошибок)
10. [Reconnection Strategy](#reconnection-strategy)
11. [Примеры использования](#примеры-использования)

---

## Обзор

WebSocket API используется для real-time коммуникаций в Service Platform v2.0:
- 💬 Чаты (8 типов сообщений)
- 🔔 Уведомления (11 типов)
- 🟢 Онлайн-статус пользователей
- ❤️ Live обновления (лайки, комментарии)

**Протокол:** Socket.IO v4.x
**Transport:** WebSocket (fallback: long-polling)
**Endpoint:** `ws://localhost:3000` (dev), `wss://api.service.com` (prod)

---

## Подключение

### Client (Flutter)

```dart
import 'package:socket_io_client/socket_io_client.dart' as IO;

IO.Socket socket = IO.io('ws://localhost:3000', <String, dynamic>{
  'transports': ['websocket'],
  'autoConnect': false,
  'auth': {
    'token': 'your-jwt-token',
  },
});

// Подключение
socket.connect();

// Слушать событие подключения
socket.on('connect', (_) {
  print('Connected: ${socket.id}');
});

// Слушать событие отключения
socket.on('disconnect', (_) {
  print('Disconnected');
});
```

### Server (NestJS)

```typescript
@WebSocketGateway({
  cors: {
    origin: '*',
  },
})
export class ChatGateway implements OnGatewayConnection, OnGatewayDisconnect {
  @WebSocketServer()
  server: Server;

  async handleConnection(client: Socket) {
    const token = client.handshake.auth.token;
    const user = await this.validateToken(token);

    if (!user) {
      client.disconnect();
      return;
    }

    // Join user's personal room
    client.join(`user:${user.id}`);

    // Broadcast online status
    this.server.emit('user:online', { userId: user.id });
  }

  handleDisconnect(client: Socket) {
    // Broadcast offline status
    const userId = this.getUserIdFromSocket(client);
    this.server.emit('user:offline', { userId });
  }
}
```

---

## Аутентификация

### 1. JWT в handshake

**Client:**
```dart
socket = IO.io('ws://localhost:3000', {
  'auth': {
    'token': jwtToken, // JWT access token
  },
});
```

**Server валидация:**
```typescript
async handleConnection(client: Socket) {
  const token = client.handshake.auth.token;

  try {
    const payload = this.jwtService.verify(token);
    const user = await this.userService.findById(payload.sub);

    if (!user) throw new UnauthorizedException();

    // Сохранить user в socket data
    client.data.user = user;
    client.join(`user:${user.id}`);
  } catch (error) {
    client.emit('error', { message: 'Invalid token' });
    client.disconnect();
  }
}
```

### 2. Token Refresh

Если токен истек:
```dart
socket.on('error', (data) {
  if (data['message'] == 'Invalid token') {
    // Refresh JWT token
    final newToken = await authRepository.refreshToken();

    // Переподключиться с новым токеном
    socket.auth = {'token': newToken};
    socket.connect();
  }
});
```

---

## Системные события

### 1. Подключение установлено

**Event:** `connected`

**Server → Client (при успешном подключении):**
```json
{
  "socket_id": "abc123socket",
  "user_id": "uuid-user-id",
  "timestamp": "2026-01-10T12:00:00.000Z"
}
```

**Client:**
```dart
socket.on('connected', (data) {
  print('Connected with socket_id: ${data['socket_id']}');
  print('User ID: ${data['user_id']}');
});
```

### 2. Требуется синхронизация

**Event:** `sync:required`

**Server → Client (при подключении или после reconnection):**
```json
{
  "user_id": "uuid-user-id",
  "reason": "connection_established",
  "timestamp": "2026-01-10T12:00:00.000Z"
}
```

**Client должен:**
1. Запросить список чатов: `GET /api/v2/chats` для получения актуального `unread_count`
2. Запросить уведомления: `GET /api/v2/notifications?is_read=false`
3. Обновить UI с актуальными данными

**Client:**
```dart
socket.on('sync:required', (data) async {
  print('Sync required: ${data['reason']}');

  // Запросить список чатов с непрочитанными сообщениями
  final chats = await chatRepository.getChats();

  // Запросить непрочитанные уведомления
  final notifications = await notificationRepository.getUnread();

  // Обновить UI
  ref.read(chatsProvider.notifier).updateChats(chats);
  ref.read(notificationsProvider.notifier).updateNotifications(notifications);
});
```

**Причины (reason):**
- `connection_established` - первичное подключение
- `reconnection` - переподключение после разрыва
- `token_refresh` - токен был обновлен

**Hybrid подход:**
- **WebSocket** используется для real-time событий (новые сообщения, уведомления)
- **REST API** используется для получения истории и непрочитанных данных
- При подключении клиент всегда синхронизирует данные через REST API
- Offline сообщения сохраняются в БД и доступны через REST API

---

## События чатов

### 1. Отправка сообщения

**Event:** `chat:message:send`

**Client → Server:**
```dart
socket.emit('chat:message:send', {
  'chat_id': 'uuid-chat-id',
  'type': 'text', // text, photo, video, voice, location, profile_share, post_share, booking_proposal
  'content': 'Hello!',
  'metadata': {}, // Опционально: зависит от типа
});
```

**Payload типов сообщений:**

**Text:**
```json
{
  "type": "text",
  "content": "Hello, how are you?"
}
```

**Photo:**
```json
{
  "type": "photo",
  "content": "https://storage.service.com/photos/123.jpg",
  "metadata": {
    "width": 1080,
    "height": 1920,
    "thumbnail": "https://storage.service.com/photos/123_thumb.jpg"
  }
}
```

**Video:**
```json
{
  "type": "video",
  "content": "https://storage.service.com/videos/456.mp4",
  "metadata": {
    "duration": 30,
    "thumbnail": "https://storage.service.com/videos/456_thumb.jpg"
  }
}
```

**Voice:**
```json
{
  "type": "voice",
  "content": "https://storage.service.com/voice/789.m4a",
  "metadata": {
    "duration": 15
  }
}
```

**Location:**
```json
{
  "type": "location",
  "content": "55.7558,37.6173",
  "metadata": {
    "lat": 55.7558,
    "lng": 37.6173,
    "address": "Красная площадь, Москва"
  }
}
```

**Profile Share:**
```json
{
  "type": "profile_share",
  "content": "user-uuid",
  "metadata": {
    "name": "Анна Иванова",
    "avatar": "https://storage.service.com/avatars/user.jpg",
    "is_master": true
  }
}
```

**Post Share:**
```json
{
  "type": "post_share",
  "content": "post-uuid",
  "metadata": {
    "author_name": "Мария",
    "media_url": "https://storage.service.com/posts/post.jpg"
  }
}
```

**Booking Proposal:**
```json
{
  "type": "booking_proposal",
  "content": "Хотите записаться на маникюр?",
  "metadata": {
    "service_id": "service-uuid",
    "service_name": "Маникюр",
    "price": 2000,
    "duration": 60
  }
}
```

**Server ответ (ACK):**
```json
{
  "status": "sent",
  "message_id": "uuid-message-id",
  "created_at": "2026-01-09T12:00:00Z"
}
```

### 2. Получение сообщения

**Event:** `chat:message:new`

**Server → Client:**
```dart
socket.on('chat:message:new', (data) {
  final message = MessageModel.fromJson(data);
  // Добавить в UI
  setState(() {
    messages.add(message);
  });
});
```

**Payload:**
```json
{
  "id": "uuid",
  "chat_id": "chat-uuid",
  "sender_id": "user-uuid",
  "sender_name": "Анна",
  "sender_avatar": "https://...",
  "type": "text",
  "content": "Hello!",
  "metadata": {},
  "created_at": "2026-01-09T12:00:00Z",
  "status": "sent"
}
```

### 3. Индикатор "печатает..."

**Event:** `chat:typing`

**Client → Server:**
```dart
// Пользователь начал печатать
socket.emit('chat:typing', {
  'chat_id': 'uuid',
  'is_typing': true,
});

// Пользователь закончил печатать
socket.emit('chat:typing', {
  'chat_id': 'uuid',
  'is_typing': false,
});
```

**Server → Client (broadcast to room):**
```dart
socket.on('chat:typing', (data) {
  if (data['is_typing']) {
    // Показать "печатает..."
    setState(() {
      isTyping = true;
    });
  } else {
    setState(() {
      isTyping = false;
    });
  }
});
```

**Payload:**
```json
{
  "chat_id": "uuid",
  "user_id": "user-uuid",
  "user_name": "Анна",
  "is_typing": true
}
```

### 4. Прочтение сообщения

**Event:** `chat:message:read`

**Client → Server:**
```dart
socket.emit('chat:message:read', {
  'message_id': 'uuid',
  'chat_id': 'chat-uuid',
});
```

**Server → Client (to sender):**
```dart
socket.on('chat:message:read', (data) {
  // Обновить статус сообщения на "прочитано" (✓✓ синий)
  final messageId = data['message_id'];
  updateMessageStatus(messageId, 'read');
});
```

**Payload:**
```json
{
  "message_id": "uuid",
  "chat_id": "chat-uuid",
  "read_by": "user-uuid",
  "read_at": "2026-01-09T12:05:00Z"
}
```

### 5. Доставка сообщения

**Event:** `chat:message:delivered`

**Автоматически от сервера после доставки:**

**Server → Client (to sender):**
```json
{
  "message_id": "uuid",
  "chat_id": "chat-uuid",
  "delivered_to": "user-uuid",
  "delivered_at": "2026-01-09T12:00:05Z"
}
```

---

## События уведомлений

### 1. Новое уведомление

**Event:** `notification:new`

**Server → Client:**
```dart
socket.on('notification:new', (data) {
  final notification = NotificationModel.fromJson(data);

  // Показать локальное уведомление
  showNotification(notification);

  // Обновить бейдж
  updateNotificationBadge();
});
```

**Payload:**
```json
{
  "id": "uuid",
  "type": "booking_confirmed", // 11 типов
  "title": "Запись подтверждена",
  "body": "Мастер Анна подтвердила вашу запись на 10 января в 14:00",
  "data": {
    "booking_id": "uuid",
    "master_id": "uuid"
  },
  "created_at": "2026-01-09T12:00:00Z",
  "is_read": false
}
```

**11 типов уведомлений:**
1. `booking_request` - Новая заявка на запись
2. `booking_confirmed` - Запись подтверждена
3. `booking_cancelled` - Запись отменена
4. `friend_request` - Запрос в друзья
5. `friend_accepted` - Запрос принят
6. `post_liked` - Лайк на посте
7. `post_commented` - Комментарий к посту
8. `post_reposted` - Репост поста
9. `mention` - Упоминание в посте/комментарии
10. `review_received` - Получен отзыв
11. `auto_booking_proposal` - Автопредложение записи

### 2. Прочтение уведомления

**Event:** `notification:read`

**Client → Server:**
```dart
socket.emit('notification:read', {
  'notification_id': 'uuid',
});
```

**Server → Client (ACK):**
```json
{
  "notification_id": "uuid",
  "is_read": true,
  "read_at": "2026-01-09T12:10:00Z"
}
```

---

## События онлайн-статуса

### 1. Пользователь онлайн

**Event:** `user:online`

**Server → Clients (broadcast):**
```dart
socket.on('user:online', (data) {
  final userId = data['user_id'];
  // Обновить статус в UI
  updateUserStatus(userId, true);
});
```

**Payload:**
```json
{
  "user_id": "uuid",
  "online": true,
  "last_seen": "2026-01-09T12:00:00Z"
}
```

### 2. Пользователь оффлайн

**Event:** `user:offline`

**Server → Clients (broadcast):**
```dart
socket.on('user:offline', (data) {
  final userId = data['user_id'];
  // Обновить статус в UI
  updateUserStatus(userId, false);
});
```

**Payload:**
```json
{
  "user_id": "uuid",
  "online": false,
  "last_seen": "2026-01-09T12:15:00Z"
}
```

---

## События социальных функций

### 1. Лайк поста (Live)

**Event:** `post:liked`

**Server → Clients (to followers):**
```dart
socket.on('post:liked', (data) {
  final postId = data['post_id'];
  final likesCount = data['likes_count'];

  // Обновить счетчик лайков в реальном времени
  updatePostLikes(postId, likesCount);
});
```

**Payload:**
```json
{
  "post_id": "uuid",
  "user_id": "who-liked-uuid",
  "user_name": "Анна",
  "likes_count": 125
}
```

### 2. Новый комментарий (Live)

**Event:** `post:commented`

**Server → Clients (to post author):**
```dart
socket.on('post:commented', (data) {
  final postId = data['post_id'];
  final comment = CommentModel.fromJson(data['comment']);

  // Добавить комментарий в список
  addCommentToPost(postId, comment);
});
```

**Payload:**
```json
{
  "post_id": "uuid",
  "comment": {
    "id": "comment-uuid",
    "author_id": "user-uuid",
    "author_name": "Мария",
    "author_avatar": "https://...",
    "content": "Классная работа!",
    "created_at": "2026-01-09T12:00:00Z"
  },
  "comments_count": 42
}
```

---

## Обработка ошибок

### Error Events

**Event:** `error`

**Server → Client:**
```dart
socket.on('error', (data) {
  print('WebSocket error: ${data['message']}');

  switch (data['code']) {
    case 'UNAUTHORIZED':
      // Refresh token и переподключиться
      break;
    case 'INVALID_DATA':
      // Показать ошибку пользователю
      break;
    case 'RATE_LIMIT':
      // Слишком много запросов
      break;
  }
});
```

**Error Codes:**
```json
{
  "code": "UNAUTHORIZED",
  "message": "Invalid or expired token",
  "timestamp": "2026-01-09T12:00:00Z"
}
```

**Коды ошибок:**
- `UNAUTHORIZED` - Невалидный токен
- `INVALID_DATA` - Невалидные данные в payload
- `RATE_LIMIT` - Превышен лимит запросов
- `CHAT_NOT_FOUND` - Чат не найден
- `MESSAGE_TOO_LARGE` - Сообщение слишком большое
- `FORBIDDEN` - Нет доступа к ресурсу

---

## Reconnection Strategy

### Exponential Backoff

```dart
class WebSocketService {
  int reconnectAttempts = 0;
  int maxReconnectAttempts = 5;

  void setupReconnection() {
    socket.on('disconnect', (_) {
      reconnect();
    });
  }

  Future<void> reconnect() async {
    if (reconnectAttempts >= maxReconnectAttempts) {
      print('Max reconnection attempts reached');
      return;
    }

    // Exponential backoff: 1s, 2s, 4s, 8s, 16s
    final delay = Duration(seconds: pow(2, reconnectAttempts).toInt());

    await Future.delayed(delay);

    reconnectAttempts++;
    socket.connect();
  }

  void onConnect() {
    // Reset counter on successful connect
    reconnectAttempts = 0;
  }
}
```

### Offline Queue

```dart
class OfflineQueue {
  final List<Map<String, dynamic>> queue = [];

  void addToQueue(String event, Map<String, dynamic> data) {
    queue.add({
      'event': event,
      'data': data,
      'timestamp': DateTime.now(),
    });
  }

  void flushQueue() {
    for (final item in queue) {
      socket.emit(item['event'], item['data']);
    }
    queue.clear();
  }
}
```

---

## Примеры использования

### Flutter: Полный пример чата

```dart
class ChatService {
  late IO.Socket socket;
  final String chatId;

  ChatService(this.chatId) {
    _initSocket();
  }

  void _initSocket() {
    socket = IO.io('ws://localhost:3000', {
      'transports': ['websocket'],
      'auth': {'token': getJwtToken()},
    });

    socket.connect();

    socket.on('connect', (_) {
      print('Connected to chat');
      _joinChatRoom();
    });

    socket.on('chat:message:new', (data) {
      _handleNewMessage(data);
    });

    socket.on('chat:typing', (data) {
      _handleTyping(data);
    });

    socket.on('chat:message:read', (data) {
      _handleMessageRead(data);
    });
  }

  void _joinChatRoom() {
    socket.emit('chat:join', {'chat_id': chatId});
  }

  void sendMessage(String content, String type) {
    socket.emit('chat:message:send', {
      'chat_id': chatId,
      'type': type,
      'content': content,
    });
  }

  void sendTyping(bool isTyping) {
    socket.emit('chat:typing', {
      'chat_id': chatId,
      'is_typing': isTyping,
    });
  }

  void markAsRead(String messageId) {
    socket.emit('chat:message:read', {
      'message_id': messageId,
      'chat_id': chatId,
    });
  }

  void _handleNewMessage(Map<String, dynamic> data) {
    final message = MessageModel.fromJson(data);
    // Добавить в state management (Riverpod)
    ref.read(chatMessagesProvider(chatId).notifier).addMessage(message);
  }

  void _handleTyping(Map<String, dynamic> data) {
    if (data['user_id'] != currentUserId) {
      // Показать индикатор "печатает..."
      ref.read(typingIndicatorProvider(chatId).notifier).state = data['is_typing'];
    }
  }

  void _handleMessageRead(Map<String, dynamic> data) {
    // Обновить статус сообщения
    ref.read(chatMessagesProvider(chatId).notifier)
      .updateMessageStatus(data['message_id'], 'read');
  }

  void dispose() {
    socket.dispose();
  }
}
```

---

## Room Management

### Server: Join/Leave rooms

```typescript
@SubscribeMessage('chat:join')
async handleJoinChat(client: Socket, payload: { chat_id: string }) {
  const user = client.data.user;
  const chat = await this.chatsService.findOne(payload.chat_id);

  // Проверка доступа
  if (!this.chatsService.isParticipant(chat, user.id)) {
    throw new WsException('Access denied');
  }

  // Join room
  client.join(`chat:${payload.chat_id}`);

  return { status: 'joined', chat_id: payload.chat_id };
}

@SubscribeMessage('chat:leave')
handleLeaveChat(client: Socket, payload: { chat_id: string }) {
  client.leave(`chat:${payload.chat_id}`);
  return { status: 'left', chat_id: payload.chat_id };
}
```

---

## Метрики и мониторинг

### Metrics to track

- **Concurrent connections:** Количество одновременных подключений
- **Messages per second:** Сообщений в секунду
- **Average latency:** Средняя задержка доставки
- **Reconnection rate:** Частота переподключений
- **Error rate:** Частота ошибок

### Prometheus metrics (NestJS)

```typescript
import { Counter, Histogram } from 'prom-client';

const messageCounter = new Counter({
  name: 'websocket_messages_total',
  help: 'Total number of WebSocket messages',
  labelNames: ['event', 'status'],
});

const latencyHistogram = new Histogram({
  name: 'websocket_message_latency_seconds',
  help: 'WebSocket message latency',
  buckets: [0.1, 0.5, 1, 2, 5],
});
```

---

## Заключение

WebSocket API обеспечивает real-time функциональность Service Platform v2.0:
- ✅ Мгновенные сообщения (<500ms latency)
- ✅ Live обновления (лайки, комментарии)
- ✅ Онлайн-статус пользователей
- ✅ Push уведомления через WebSocket

**Следующий шаг:** Реализация WebSocket Gateway в NestJS (Неделя 6 по плану).

---

**Версия:** 2.0
**Последнее обновление:** 9 января 2026
**Статус:** ✅ Готова к реализации
