# ARCHITECTURE - Архитектура платформы Service

**Версия:** 2.0
**Дата:** 5 февраля 2026

---

> **Примечание:** Этот документ описывает **целевую архитектуру v2.0**. Текущая реализация MVP использует Docker Compose (PostgreSQL + PostGIS, Redis, MinIO, Meilisearch) и модульный монолит на NestJS. Kubernetes и продовая инфраструктура рассматриваются как следующий этап после MVP.

## 📋 Содержание

1. [Обзор архитектуры](#обзор-архитектуры)
2. [High-Level Architecture](#high-level-architecture)
3. [Backend Architecture](#backend-architecture)
4. [Frontend Architecture](#frontend-architecture)
5. [Database Architecture](#database-architecture)
6. [Real-time Architecture (WebSocket)](#real-time-architecture-websocket)
7. [Feed Algorithm Architecture](#feed-algorithm-architecture)
8. [Infrastructure](#infrastructure)
9. [Security Architecture](#security-architecture)
10. [Scalability & Performance](#scalability--performance)

---

## 🌐 Обзор архитектуры

**Service Platform v2.0** — социальная платформа с интегрированным маркетплейсом услуг красоты и велнеса.

**Ключевые компоненты:**
- **Frontend:** Flutter (iOS, Android, Web)
- **Backend:** NestJS (TypeScript)
- **Database:** PostgreSQL 15+ с PostGIS
- **Cache:** Redis 7+
- **Real-time:** Socket.IO + Redis Pub/Sub
- **Search:** Meilisearch
- **Storage:** MinIO (S3-compatible)
- **Notifications:** Firebase Cloud Messaging (FCM)

**Архитектурный стиль:**
- Microservices-ready monolith (модульный монолит)
- RESTful API для HTTP
- WebSocket для real-time
- Event-driven для асинхронных операций

---

## 🏗️ High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                         CLIENTS                                 │
├─────────────┬──────────────┬──────────────┬────────────────────┤
│   iOS App   │  Android App │   Web App    │   Admin Panel      │
│  (Flutter)  │   (Flutter)  │  (Flutter)   │   (React/Flutter)  │
└─────────────┴──────────────┴──────────────┴────────────────────┘
                              │
                              │ HTTPS / WebSocket
                              │
┌─────────────────────────────▼─────────────────────────────────┐
│                       LOAD BALANCER                            │
│                      (Nginx / HAProxy)                         │
└─────────────────────────────┬─────────────────────────────────┘
                              │
           ┌──────────────────┼──────────────────┐
           │                  │                  │
┌──────────▼──────┐  ┌────────▼────────┐  ┌─────▼──────────┐
│  Backend API 1  │  │  Backend API 2  │  │  Backend API N │
│    (NestJS)     │  │    (NestJS)     │  │    (NestJS)    │
└────────┬────────┘  └────────┬────────┘  └────────┬────────┘
         │                    │                     │
         └────────────────────┼─────────────────────┘
                              │
        ┌─────────────────────┼─────────────────────┐
        │                     │                     │
┌───────▼───────┐   ┌─────────▼────────┐   ┌───────▼───────┐
│  PostgreSQL   │   │   Redis Cluster  │   │     MinIO     │
│   (Primary)   │   │  (Cache + Pub/Sub│   │  (S3 Storage) │
└───────┬───────┘   └──────────────────┘   └───────────────┘
        │
┌───────▼───────┐   ┌──────────────────┐   ┌───────────────┐
│  PostgreSQL   │   │   Meilisearch    │   │      FCM      │
│   (Replica)   │   │   (Full-text)    │   │ (Push Notif.) │
└───────────────┘   └──────────────────┘   └───────────────┘
```

**Потоки данных:**

1. **HTTP REST API:** Клиенты → Load Balancer → Backend API → Database
2. **WebSocket:** Клиенты ↔ Backend (sticky sessions) ↔ Redis Pub/Sub
3. **Media Upload:** Клиенты → Backend (presigned URL) → MinIO
4. **Search:** Backend → Meilisearch (indexing), Клиенты → Backend → Meilisearch (query)
5. **Notifications:** Backend → Redis Queue → Worker → FCM → Клиенты

---

## 🔧 Backend Architecture

### Модульная структура (NestJS)

```
backend/src/
├── modules/
│   ├── auth/              # Аутентификация (JWT, OAuth)
│   ├── users/             # Пользователи
│   ├── masters/           # Мастера
│   ├── services/          # Услуги
│   ├── bookings/          # Записи
│   ├── posts/             # Посты Feed (v2.0)
│   ├── likes/             # Лайки (v2.0)
│   ├── comments/          # Комментарии (v2.0)
│   ├── friends/           # Друзья (v2.0)
│   ├── subscriptions/     # Подписки (v2.0)
│   ├── chats/             # Чаты (v2.0)
│   ├── websocket/         # WebSocket Gateway (v2.0)
│   ├── notifications/     # Уведомления (v2.0)
│   ├── auto-proposals/    # Автопредложения (v2.0)
│   ├── favorites/         # Избранное (v2.0)
│   ├── reviews/           # Отзывы
│   ├── search/            # Поиск
│   ├── premium/           # Премиум-подписки
│   └── admin/             # Админ-панель
│
├── common/
│   ├── guards/            # Auth guards, Role guards
│   ├── filters/           # Exception filters
│   ├── interceptors/      # Logging, Transform, Cache
│   ├── decorators/        # Custom decorators
│   ├── pipes/             # Validation pipes
│   └── middleware/        # Rate limiting, CORS
│
├── database/
│   ├── entities/          # TypeORM entities (29 таблиц)
│   ├── migrations/        # Database migrations
│   ├── seeds/             # Seed data
│   └── repositories/      # Custom repositories
│
├── jobs/                  # Background jobs (BullMQ)
│   ├── feed-scoring/      # Feed score recalculation
│   ├── notifications/     # Notification batching
│   └── cleanup/           # Data cleanup
│
└── main.ts
```

### Слоистая архитектура

```
┌────────────────────────────────────┐
│         Controllers                │  HTTP/WebSocket endpoints
│  (REST API, WebSocket Gateway)    │
└────────────────┬───────────────────┘
                 │
┌────────────────▼───────────────────┐
│           Services                 │  Business logic
│      (Use cases, orchestration)   │
└────────────────┬───────────────────┘
                 │
┌────────────────▼───────────────────┐
│         Repositories               │  Data access
│    (TypeORM, Redis, Meilisearch)  │
└────────────────┬───────────────────┘
                 │
┌────────────────▼───────────────────┐
│          Database                  │  PostgreSQL, Redis, MinIO
│                                    │
└────────────────────────────────────┘
```

### Ключевые паттерны

**1. Dependency Injection:**
```typescript
@Injectable()
export class UserService {
  constructor(
    private readonly userRepo: UserRepository,
    private readonly cacheService: CacheService,
  ) {}
}
```

**2. Repository Pattern:**
```typescript
@EntityRepository(User)
export class UserRepository extends Repository<User> {
  async findByEmail(email: string): Promise<User | null> {
    return this.findOne({ where: { email } });
  }
}
```

**3. DTO (Data Transfer Objects):**
```typescript
export class CreateUserDto {
  @IsEmail()
  email: string;

  @IsString()
  @MinLength(8)
  password: string;
}
```

**4. Guards для авторизации:**
```typescript
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('master')
@Post('services')
async createService(@Body() dto: CreateServiceDto) {
  return this.servicesService.create(dto);
}
```

---

## 📱 Frontend Architecture

### Clean Architecture (Flutter)

```
frontend/lib/
├── features/                # Фичи (modular approach)
│   ├── auth/
│   │   ├── data/           # Repositories, Data sources, Models
│   │   ├── domain/         # Entities, Use cases
│   │   ├── presentation/   # Screens, Widgets, Providers
│   │   └── auth_module.dart
│   │
│   ├── feed/               # Feed (v2.0)
│   ├── posts/              # Посты (v2.0)
│   ├── social/             # Друзья, подписки (v2.0)
│   ├── chats/              # Чаты (v2.0)
│   ├── bookings/
│   ├── search/
│   └── profile/
│
├── core/
│   ├── providers/          # Riverpod providers
│   ├── services/           # API, WebSocket, Storage
│   ├── models/             # Shared models (Freezed)
│   ├── constants/          # Colors, Strings, Routes
│   └── theme/              # Theme configuration
│
├── shared/
│   ├── widgets/            # Reusable widgets
│   ├── utils/              # Helpers, Extensions
│   └── validators/         # Input validators
│
└── main.dart
```

### State Management (Riverpod)

```dart
// Provider definition
final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier(ref.read(userRepositoryProvider));
});

// Notifier
class UserNotifier extends StateNotifier<User?> {
  UserNotifier(this.repository) : super(null);

  final UserRepository repository;

  Future<void> loadUser(String id) async {
    state = await repository.getUserById(id);
  }
}

// Usage in Widget
class UserProfile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return user == null
      ? CircularProgressIndicator()
      : Text(user.name);
  }
}
```

### Data Flow

```
┌────────────────────────────────────┐
│         UI (Widgets)               │
│   ConsumerWidget / StatelessWidget │
└────────────────┬───────────────────┘
                 │ ref.watch / ref.read
┌────────────────▼───────────────────┐
│      Providers (Riverpod)          │
│   StateNotifierProvider, Provider  │
└────────────────┬───────────────────┘
                 │
┌────────────────▼───────────────────┐
│       Repositories                 │
│  (Data sources abstraction)        │
└────────────────┬───────────────────┘
                 │
┌────────────────▼───────────────────┐
│      Data Sources                  │
│  (API Client, Local Storage,       │
│   WebSocket)                       │
└────────────────────────────────────┘
```

---

## 🗄️ Database Architecture

### PostgreSQL Schema

**29 таблиц** разделены на домены:

**Core (v1.0):**
- `users` - Пользователи
- `masters` - Мастера
- `master_services` - Услуги мастеров
- `master_schedule` - Расписание
- `bookings` - Записи
- `reviews` - Отзывы
- `categories` - Категории услуг

**Social (v2.0):**
- `posts` - Посты в Feed
- `post_media` - Медиафайлы постов
- `likes` - Лайки
- `comments` - Комментарии
- `friendships` - Друзья
- `subscriptions` - Подписки
- `reposts` - Репосты

**Communication (v2.0):**
- `chats` - Чаты
- `chat_participants` - Участники чатов
- `messages` - Сообщения

**Other (v2.0):**
- `notifications` - Уведомления
- `auto_proposals` - Автопредложения
- `favorites` - Избранное
- `blocked_users` - Черный список

### Индексы

**Ключевые индексы для производительности:**

```sql
-- Feed query optimization
CREATE INDEX idx_posts_score_created ON posts(score DESC, created_at DESC);
CREATE INDEX idx_posts_master_city ON posts(master_id, city_id);

-- Geo search
CREATE INDEX idx_masters_location ON masters USING GIST(location);

-- Full-text search (Meilisearch handles this)

-- Booking queries
CREATE INDEX idx_bookings_master_time ON bookings(master_id, start_time);
CREATE INDEX idx_bookings_client_status ON bookings(client_id, status);

-- WebSocket online status
CREATE INDEX idx_users_last_seen ON users(last_seen DESC) WHERE online = true;
```

### Партиционирование (планируется)

```sql
-- Партиционирование posts по created_at (monthly)
CREATE TABLE posts (
  ...
) PARTITION BY RANGE (created_at);

CREATE TABLE posts_2026_01 PARTITION OF posts
  FOR VALUES FROM ('2026-01-01') TO ('2026-02-01');
```

---

## ⚡ Real-time Architecture (WebSocket)

### Socket.IO + Redis Pub/Sub

```
┌──────────────────────────────────────────────────────────┐
│                    Clients (Flutter)                      │
└─────┬────────┬────────┬────────┬────────┬────────────────┘
      │        │        │        │        │
      │ WS     │ WS     │ WS     │ WS     │ WS
      │        │        │        │        │
┌─────▼────┐ ┌▼────────┐ ┌──────▼───┐ ┌──▼─────┐ ┌────────▼──┐
│ Backend  │ │ Backend │ │ Backend  │ │ Backend│ │ Backend   │
│  Node 1  │ │ Node 2  │ │  Node 3  │ │ Node 4 │ │  Node N   │
│(Socket.IO│ │(Socket.IO│ │(Socket.IO│ │(Socket.│ │(Socket.IO)│
└─────┬────┘ └┬────────┘ └──────┬───┘ └──┬─────┘ └────────┬──┘
      │       │                 │        │                │
      └───────┴─────────────────┴────────┴────────────────┘
                              │
                    ┌─────────▼──────────┐
                    │   Redis Pub/Sub    │
                    │  (Message Broker)  │
                    └────────────────────┘
```

### WebSocket Flow

**1. Подключение:**
```typescript
// Client connects
const socket = io('wss://api.service.com', {
  auth: { token: jwtToken }
});

// Server validates JWT
@WebSocketGateway()
export class ChatGateway {
  @SubscribeMessage('connect')
  handleConnection(client: Socket) {
    const user = this.validateToken(client.handshake.auth.token);
    client.join(`user:${user.id}`);
  }
}
```

**2. Отправка сообщения:**
```typescript
// Client sends message
socket.emit('message:send', {
  chat_id: 'uuid',
  type: 'text',
  content: 'Hello!'
});

// Server processes
@SubscribeMessage('message:send')
async handleMessage(client: Socket, data: SendMessageDto) {
  const message = await this.chatsService.createMessage(data);

  // Emit to all participants via Redis Pub/Sub
  this.server.to(`chat:${data.chat_id}`).emit('message:new', message);

  return { status: 'sent', message_id: message.id };
}
```

**3. Доставка (Redis Pub/Sub):**
```typescript
// Backend Node 1 publishes to Redis
await this.redisClient.publish('chat:uuid', JSON.stringify(message));

// Backend Nodes 2-N subscribe and emit to local clients
this.redisClient.subscribe('chat:uuid');
this.redisClient.on('message', (channel, data) => {
  this.server.to(channel).emit('message:new', JSON.parse(data));
});
```

### Message Statuses

```
Client A                  Server                   Client B
   │                        │                        │
   ├─ send "Hello" ────────>│                        │
   │                        ├─ save to DB            │
   │<─── status: sent ──────┤                        │
   │                        ├─────── deliver ───────>│
   │                        │<─── ack ───────────────┤
   │<── status: delivered ──┤                        │
   │                        │                        ├─ user reads
   │                        │<─── read ack ──────────┤
   │<─── status: read ──────┤                        │
```

---

## 📊 Feed Algorithm Architecture

### Алгоритм ранжирования

**Formula:**
```
Score = 0.4 × geo_score + 0.25 × freshness_score + 0.2 × popularity_score
        + 0.1 × subscription_score + 0.05 × category_score
```

### Pipeline

```
┌─────────────────────────────────────────────────────────────┐
│  1. Data Collection                                         │
├─────────────────────────────────────────────────────────────┤
│  - New post created                                         │
│  - User geolocation updated                                 │
│  - Like/comment added                                       │
│  - Subscription changed                                     │
└─────────────────┬───────────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────────┐
│  2. Score Calculation (Cron Job - every 15 min)            │
├─────────────────────────────────────────────────────────────┤
│  - Calculate geo_score (distance from user city)           │
│  - Calculate freshness_score (time decay)                  │
│  - Calculate popularity_score (likes + comments)           │
│  - Calculate subscription_score (is_subscribed)            │
│  - Calculate category_score (user interests match)        │
│  - Compute final score                                     │
│  - Save to posts.score column                              │
└─────────────────┬───────────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────────┐
│  3. Feed Generation (on user request)                      │
├─────────────────────────────────────────────────────────────┤
│  - Check Redis cache for user feed                         │
│  - If cache miss: query DB with ORDER BY score DESC        │
│  - Apply user's blocked/hidden content filters             │
│  - Paginate (limit 20)                                     │
│  - Cache in Redis for 5 minutes                            │
└─────────────────┬───────────────────────────────────────────┘
                  │
┌─────────────────▼───────────────────────────────────────────┐
│  4. Personalization (future ML enhancement)                │
├─────────────────────────────────────────────────────────────┤
│  - User interaction history (likes, views, bookings)       │
│  - Collaborative filtering (similar users)                 │
│  - Content-based filtering (similar posts)                 │
└─────────────────────────────────────────────────────────────┘
```

### Кэширование стратегия

**L1 Cache (Redis):**
```typescript
// Cache key structure
const cacheKey = `feed:${userId}:page:${page}`;

// TTL: 5 minutes
await redis.setex(cacheKey, 300, JSON.stringify(feed));

// Invalidation
await redis.del(`feed:${userId}:*`); // On user action (like, subscribe)
```

**L2 Cache (Materialized Views):**
```sql
CREATE MATERIALIZED VIEW popular_posts AS
SELECT post_id, COUNT(*) as engagement
FROM (
  SELECT post_id FROM likes
  UNION ALL
  SELECT post_id FROM comments
) AS interactions
GROUP BY post_id
ORDER BY engagement DESC;

REFRESH MATERIALIZED VIEW popular_posts; -- Every hour
```

---

## 🔒 Security Architecture

### Authentication Flow

```
┌────────────┐          ┌────────────┐          ┌────────────┐
│   Client   │          │   Backend  │          │ PostgreSQL │
└─────┬──────┘          └─────┬──────┘          └─────┬──────┘
      │                       │                       │
      ├─ POST /auth/login ──>│                       │
      │  { email, password }  │                       │
      │                       ├─ query user ────────>│
      │                       │<─ user data ──────────┤
      │                       ├─ bcrypt.compare       │
      │                       ├─ generate JWT         │
      │<─ { access_token } ───┤                       │
      │                       │                       │
      ├─ GET /users/me ─────>│                       │
      │  Authorization: Bearer│                       │
      │                       ├─ verify JWT           │
      │                       ├─ extract user_id      │
      │                       ├─ query user ────────>│
      │<─ { user data } ──────┤                       │
```

### JWT Structure

```json
{
  "header": {
    "alg": "HS256",
    "typ": "JWT"
  },
  "payload": {
    "sub": "user-uuid",
    "email": "user@example.com",
    "role": "client",
    "iat": 1640000000,
    "exp": 1640086400
  },
  "signature": "..."
}
```

**TTL:**
- Access Token: 15 minutes
- Refresh Token: 30 days

### Security Layers

**1. Transport Layer:**
- HTTPS/TLS 1.3
- WebSocket over WSS

**2. Application Layer:**
- JWT authentication
- Role-based access control (RBAC)
- Rate limiting (100 req/min per IP)
- CORS configuration
- Helmet.js headers

**3. Data Layer:**
- Password hashing (bcrypt, salt rounds: 10)
- Sensitive data encryption at rest
- SQL injection prevention (TypeORM prepared statements)
- XSS sanitization

**4. Network Layer:**
- DDoS protection (Cloudflare)
- Firewall rules
- VPC isolation

---

## 📈 Scalability & Performance

### Horizontal Scaling

**Backend (Stateless):**
```
Load Balancer (sticky sessions for WebSocket)
    │
    ├──> Backend Node 1 (PM2: 4 processes)
    ├──> Backend Node 2 (PM2: 4 processes)
    ├──> Backend Node 3 (PM2: 4 processes)
    └──> Backend Node N (Auto-scaling based on CPU > 70%)
```

**Database (Read Replicas):**
```
       ┌─────────────────┐
       │ Primary (Write) │
       └────────┬────────┘
                │ Replication
       ┌────────┼────────┐
       │        │        │
┌──────▼──┐ ┌──▼──────┐ ┌▼────────┐
│Replica 1│ │Replica 2│ │Replica N│
│ (Read)  │ │ (Read)  │ │ (Read)  │
└─────────┘ └─────────┘ └─────────┘
```

**Redis (Cluster Mode):**
```
Redis Cluster (3 masters + 3 replicas)
    ├─ Master 1 (slots 0-5460)    + Replica 1
    ├─ Master 2 (slots 5461-10922) + Replica 2
    └─ Master 3 (slots 10923-16383) + Replica 3
```

### Performance Targets

| Metric | Target | Monitoring |
|--------|--------|-----------|
| API Response Time (p95) | < 200ms | Prometheus + Grafana |
| Feed Load Time (p95) | < 200ms | Custom metrics |
| WebSocket Latency (p95) | < 100ms | Socket.IO metrics |
| Database Query Time (p95) | < 100ms | PostgreSQL logs |
| Cache Hit Rate | > 80% | Redis INFO |
| Uptime | > 99.9% | UptimeRobot |
| Message Delivery Rate | > 99.9% | Custom tracking |

### Caching Strategy

**Multi-level caching:**

```
┌─────────────────────────────────────────────────┐
│  L1: Application Cache (in-memory)             │
│  - Frequently accessed data                     │
│  - TTL: 1-5 minutes                             │
└────────────────┬────────────────────────────────┘
                 │ Miss
┌────────────────▼────────────────────────────────┐
│  L2: Redis Cache                                │
│  - Feed, User profiles, Search results          │
│  - TTL: 5-60 minutes                            │
└────────────────┬────────────────────────────────┘
                 │ Miss
┌────────────────▼────────────────────────────────┐
│  L3: Database (PostgreSQL)                      │
│  - Source of truth                              │
│  - Read from replicas when possible             │
└─────────────────────────────────────────────────┘
```

---

## 🚀 Deployment Architecture

### Kubernetes Cluster

```yaml
# Simplified K8s architecture
Namespaces:
  - production
  - staging
  - development

Deployments:
  - backend-api (3 replicas, auto-scale to 10)
  - websocket-gateway (3 replicas, sticky sessions)
  - background-workers (2 replicas)
  - postgresql (StatefulSet)
  - redis (StatefulSet, cluster mode)
  - minio (StatefulSet)

Services:
  - backend-api-service (LoadBalancer)
  - websocket-service (LoadBalancer, sticky)
  - postgresql-service (ClusterIP)
  - redis-service (ClusterIP)

Ingress:
  - api.service.com → backend-api-service
  - ws.service.com → websocket-service
```

### CI/CD Pipeline

```
┌──────────────┐
│  Git Push    │
└──────┬───────┘
       │
┌──────▼───────┐
│ GitHub       │
│ Actions      │
└──────┬───────┘
       │
       ├─ Lint & Test
       ├─ Build Docker Image
       ├─ Push to Registry
       │
┌──────▼───────┐
│ Kubernetes   │
│ Deployment   │
└──────┬───────┘
       │
       ├─ Rolling Update (zero-downtime)
       ├─ Health Checks
       └─ Auto-rollback on failure
```

---

## 📚 Связанные документы

- BRD, User Stories, Catalog — актуальные бизнес-документы (`docs/business/`)
- TechSpec, Database Schema, API Specification — перенесены в архив (`archive/docs-temporary/`)

---

**Последнее обновление:** 5 февраля 2026
**Версия:** 2.0
**Статус:** ✅ Целевая архитектура, согласована с реализованным MVP
