# Technical Documentation - Техническая документация

**Версия:** 2.0
**Дата:** Декабрь 2025

---

## 📋 Содержание папки

Техническая документация **Service Platform v2.0** — социальной платформы с маркетплейсом услуг.

### Документы

| Файл | Описание | Версия | Размер |
|------|----------|--------|--------|
| **[TechSpec.md](./TechSpec.md)** | Technical Specification - Полная техническая спецификация | v2.0 | 822 строк |
| **[API.md](./API.md)** | API Specification - REST API + WebSocket (165 endpoints) | v2.0 | 3704 строк |
| **[Database.md](./Database.md)** | Database Schema - Схема БД (29 таблиц) | v2.0 | 889 строк |

---

## 📄 Краткое описание документов

### 1. TechSpec.md - Technical Specification

**Что внутри:**
- Обзор технологий и архитектуры
- Technology Stack (Backend, Frontend, Infrastructure)
- Модули системы (15+ модулей)
- WebSocket архитектура (real-time)
- Feed алгоритм ранжирования
- Security & Performance требования
- Deployment стратегия

**Технологии:**

**Backend:**
- NestJS 10.x (TypeScript 5.x)
- PostgreSQL 15+ с PostGIS
- TypeORM 0.3.x
- Redis 7+ (cache + pub/sub)
- Socket.IO (WebSocket)
- Meilisearch (full-text search)
- MinIO (S3-compatible storage)
- BullMQ (job queues)

**Frontend:**
- Flutter 3.x (Dart 3.x)
- Riverpod (state management)
- Freezed (immutable models)
- Dio (HTTP client)
- Socket.IO client (WebSocket)

**Infrastructure:**
- Docker + Docker Compose
- Kubernetes (production)
- Nginx (reverse proxy)
- GitHub Actions (CI/CD)
- Grafana + Prometheus (monitoring)

**Когда читать:**
- Перед началом разработки
- При выборе технологий для новой фичи
- Для understanding архитектурных решений

### 2. API.md - API Specification

**Что внутри:**
- **165 REST endpoints** (95 v1.0 + 70 v2.0)
- 20 групп endpoints
- Request/Response examples
- WebSocket events (8 событий)
- Error codes и обработка
- Authentication (JWT)
- Rate limiting

**Группы endpoints v1.0:**
- 🔐 Authentication (5)
- 👤 Users (10)
- 👨‍🎨 Masters (12)
- 🛍️ Services (10)
- 📅 Bookings (15)
- 💬 Chats (10)
- ⭐ Reviews (8)
- 🔍 Search (10)
- 🏷️ Categories (5)
- 💎 Premium (10)

**Группы endpoints v2.0 (новые):**
- 📱 Posts/Feed (15)
- ❤️ Likes (6)
- 💬 Comments (8)
- 👥 Friends (10)
- 📲 Subscriptions (8)
- 💬 Chats v2.0 (12)
- 🔔 Notifications (8)
- ⭐ Favorites (8)
- ⚙️ Settings (6)
- 🤖 Auto Bookings (6)

**WebSocket Events:**
- message:new
- message:delivered
- message:read
- typing:start / typing:stop
- user:online / user:offline
- notification:new

**Когда читать:**
- При разработке API endpoints
- При интеграции с frontend
- Для написания API тестов

**Примеры endpoints:**

```http
# Feed
GET /api/v1/posts/feed?page=1&limit=20

# Like post
POST /api/v1/posts/:id/like

# Send message
POST /api/v1/chats/:id/messages

# WebSocket connection
WS wss://api.service.com/ws?token=jwt_token
```

### 3. Database.md - Database Schema

**Что внутри:**
- **29 таблиц** (19 v1.0 + 10 v2.0)
- TypeORM entities
- Relationships (one-to-many, many-to-many)
- Индексы для производительности
- Constraints и validations
- Миграции

**Таблицы v1.0 (Core):**
- `users` - Пользователи
- `masters` - Мастера
- `master_services` - Услуги мастеров
- `master_schedule` - Расписание
- `bookings` - Записи
- `reviews` - Отзывы
- `categories` - Категории
- `chats`, `messages` - Чаты
- `premium_subscriptions` - Подписки

**Таблицы v2.0 (Social):**
- `posts` - Посты Feed
- `post_media` - Медиафайлы постов
- `likes` - Лайки
- `comments` - Комментарии
- `friendships` - Друзья
- `subscriptions` - Подписки
- `notifications` - Уведомления
- `auto_proposals` - Автопредложения
- `favorites` - Избранное
- `blocked_users` - Черный список

**Key indexes:**
```sql
-- Feed performance
CREATE INDEX idx_posts_score_created
  ON posts(score DESC, created_at DESC);

-- Geo search
CREATE INDEX idx_masters_location
  ON masters USING GIST(location);

-- Bookings lookup
CREATE INDEX idx_bookings_master_time
  ON bookings(master_id, start_time);
```

**Когда читать:**
- При создании новых entities
- При написании database migrations
- Для понимания data model

---

## 🏗️ Архитектура проекта

### High-Level Components

```
┌─────────────────────────────────────────────┐
│         Clients (Flutter App)               │
│   iOS / Android / Web / Admin Panel         │
└────────────────┬────────────────────────────┘
                 │
                 │ HTTPS / WebSocket
                 │
┌────────────────▼────────────────────────────┐
│         Backend API (NestJS)                │
│  ┌──────────┬──────────┬──────────┐         │
│  │ REST API │ WebSocket│Background│         │
│  │          │ Gateway  │ Jobs     │         │
│  └──────────┴──────────┴──────────┘         │
└────────────────┬────────────────────────────┘
                 │
      ┌──────────┼──────────┐
      │          │          │
┌─────▼────┐ ┌──▼───────┐ ┌▼─────────┐
│PostgreSQL│ │  Redis   │ │  MinIO   │
│ (29 tbl) │ │(Cache+   │ │  (S3)    │
│          │ │ Pub/Sub) │ │          │
└──────────┘ └──────────┘ └──────────┘
```

### Backend Modules

```
backend/src/modules/
├── auth/              # JWT, OAuth
├── users/             # User management
├── masters/           # Master profiles
├── bookings/          # Booking system
├── posts/             # Feed posts (v2.0)
├── likes/             # Post likes (v2.0)
├── comments/          # Comments (v2.0)
├── friends/           # Friendships (v2.0)
├── subscriptions/     # Subscriptions (v2.0)
├── chats/             # Real-time chat (v2.0)
├── websocket/         # WebSocket Gateway (v2.0)
├── notifications/     # Push notifications (v2.0)
├── auto-proposals/    # Auto suggestions (v2.0)
└── admin/             # Admin panel
```

---

## 🔒 Security & Performance

### Security

**Authentication:**
- JWT tokens (15 min TTL)
- Refresh tokens (30 days)
- OAuth 2.0 (Google, Apple)

**Authorization:**
- Role-based access control (RBAC)
- Guards для endpoints

**Data Protection:**
- Bcrypt password hashing (salt: 10)
- Sensitive data encryption at rest
- HTTPS/TLS 1.3
- Rate limiting (100 req/min)

### Performance Targets

| Metric | Target | Monitoring |
|--------|--------|-----------|
| API Response (p95) | < 200ms | Prometheus |
| Feed Load (p95) | < 200ms | Custom |
| WebSocket Latency (p95) | < 100ms | Socket.IO |
| Database Query (p95) | < 100ms | Logs |
| Cache Hit Rate | > 80% | Redis |
| Uptime | > 99.9% | UptimeRobot |

---

## 📡 Real-time Architecture (WebSocket)

### Socket.IO + Redis Pub/Sub

```
┌──────────────────────────────────────────┐
│  Backend Nodes (Socket.IO)               │
│  ┌────────┬────────┬────────┬────────┐   │
│  │ Node 1 │ Node 2 │ Node 3 │ Node N │   │
│  └───┬────┴───┬────┴───┬────┴───┬────┘   │
└──────┼────────┼────────┼────────┼────────┘
       │        │        │        │
       └────────┴────────┴────────┘
                 │
        ┌────────▼────────┐
        │  Redis Pub/Sub  │
        │  (Message Bus)  │
        └─────────────────┘
```

**Use Cases:**
- Real-time chat messages
- Typing indicators
- Online/offline status
- Push notifications
- Live updates in Feed

**Events:**
- `message:new` - Новое сообщение
- `message:delivered` - Доставлено
- `message:read` - Прочитано
- `typing:start` / `typing:stop` - Печатает
- `user:online` / `user:offline` - Статус
- `notification:new` - Новое уведомление

---

## 🔍 Feed Algorithm

### Ranking Formula

```
Score = 0.4 × geo_score + 0.25 × freshness_score
      + 0.2 × popularity_score + 0.1 × subscription_score
      + 0.05 × category_score
```

**Factors:**
1. **Geolocation (40%):** Приоритет мастерам из города пользователя
2. **Freshness (25%):** Новые посты выше (time decay)
3. **Popularity (20%):** Лайки + комментарии за 7 дней
4. **Subscriptions (10%):** Контент от подписок
5. **Categories (5%):** Релевантность интересам пользователя

**Implementation:**
- Score recalculation: каждые 15 минут (cron job)
- Feed caching: Redis, TTL 5 minutes
- Personalization: история взаимодействий

---

## 🧪 Testing

**Backend:**
- Unit tests: Jest (coverage > 85%)
- Integration tests: Supertest
- E2E tests: Jest + Supertest

**Frontend:**
- Unit tests: Flutter Test (coverage > 75%)
- Widget tests
- Integration tests

**Тестовые файлы:**
- [Test Plan](../testing/TestPlan.md) - План тестирования
- [Test Cases](../testing/TestCases.md) - 130 тест-кейсов

---

## 🔗 Связанные документы

**Business:**
- [BRD](../business/BRD.md) - Бизнес-требования
- [User Stories](../business/UserStories.md) - 148 user stories

**Analysis:**
- [Requirements](../analysis/Requirements.md) - Системные требования
- [Roadmap](../analysis/Roadmap.md) - Дорожная карта (30 недель)
- [Risks](../analysis/Risks.md) - 18 рисков и митигация

**Root:**
- [ARCHITECTURE.md](../../ARCHITECTURE.md) - Архитектура проекта
- [CONTRIBUTING.md](../../CONTRIBUTING.md) - Гайд для разработчиков

---

## 🚀 Quick Start

### Backend Setup

```bash
cd backend

# Install dependencies
npm install

# Setup environment
cp .env.example .env

# Run migrations
npm run migration:run

# Start dev server
npm run start:dev
```

### Frontend Setup

```bash
cd frontend

# Get dependencies
flutter pub get

# Generate code
flutter pub run build_runner build

# Run app
flutter run
```

---

**Последнее обновление:** Декабрь 2025
**Статус:** ✅ Актуален (v2.0)
