# Service Platform - Backend

**Framework:** NestJS 10.3  
**Language:** TypeScript 5.3  
**Status:** ✅ Production Ready

---

## 🚀 Быстрый старт

```bash
# Установка зависимостей
npm install

# Запуск БД (Docker)
docker-compose up -d

# Применить миграции
npm run migration:run

# Заполнить тестовыми данными
npm run seed

# Запуск dev сервера
npm run start:dev

# Swagger UI
open http://localhost:3000/api/docs
```

---

## 📊 Статус

### Реализовано:
- ✅ **16 модулей** (Auth, Users, Masters, Bookings, Posts, Admin и др.)
- ✅ **165 REST endpoints**
- ✅ **11 WebSocket событий** (Socket.IO + Redis Pub/Sub)
- ✅ **29 таблиц БД** с миграциями
- ✅ **73/73 E2E тестов** (100%)
- ✅ **185/185 unit тестов** (100%)

### Production Ready:
- ✅ **Security:** Rate limiting, CSRF, Helmet, OWASP 9/10
- ✅ **Performance:** 70+ indexes, Redis caching
- ✅ **Monitoring:** Winston logger, Health checks
- ✅ **CI/CD:** GitHub Actions workflows

---

## 🏗️ Архитектура

### Модули:

```
src/modules/
├── auth/              # JWT аутентификация
├── users/             # Управление пользователями
├── masters/           # Профили мастеров
├── categories/        # Категории услуг
├── services/          # Услуги мастеров
├── bookings/          # Система бронирования
├── reviews/           # Отзывы и рейтинг
├── posts/             # Социальная лента
├── social/            # Likes, Comments, Reposts
├── friends/           # Друзья (двусторонние)
├── subscriptions/     # Подписки (односторонние)
├── chats/             # Real-time чаты
├── notifications/     # Уведомления
├── search/            # Поиск (Meilisearch + PostgreSQL)
├── auto-proposals/    # Умный подбор мастеров
└── admin/             # Админ-панель
```

### Database:

**29 таблиц:**
- Core: users, master_profiles, services, bookings, reviews
- Social: posts, post_media, likes, comments, friendships, subscriptions
- Communication: chats, chat_participants, messages, notifications
- Other: categories, auto_proposals, favorites, blocked_users

**Миграции:** TypeORM migrations в `src/database/migrations/`

---

## 🧪 Тестирование

### Unit Tests:
```bash
npm run test              # Запустить все тесты
npm run test:cov          # С покрытием
npm run test:watch        # Watch mode
```

**Результат:** 185/185 тестов (100%)

### E2E Tests:
```bash
npm run test:e2e          # Запустить E2E тесты
```

**Результат:** 73/73 тестов (100%)
- Auth: 11/11
- Bookings: 14/14
- Posts: 26/26
- Admin: 21/21

---

## 📝 API Documentation

**Swagger UI:** http://localhost:3000/api/docs

**165 REST endpoints:**
- Auth: 5 endpoints (register, login, refresh, forgot-password, reset-password)
- Users: 12 endpoints (CRUD, profile, stats)
- Masters: 15 endpoints (profile, services, reviews)
- Bookings: 10 endpoints (create, update, confirm, cancel, complete)
- Posts: 18 endpoints (CRUD, like, comment, repost)
- Social: 25 endpoints (likes, comments, friends, subscriptions)
- Chats: 8 endpoints (create, send, read)
- Admin: 7 endpoints (stats, users, bookings, health, analytics)
- И другие...

**WebSocket events:** 11 событий через Socket.IO

---

## 🔐 Security

- **JWT Authentication** с refresh tokens
- **Rate Limiting** (Redis-based, 100 req/min)
- **CSRF Protection** (Double Submit Cookie)
- **Security Headers** (Helmet.js)
- **Input Validation** (class-validator)
- **SQL Injection Protection** (TypeORM)
- **XSS Protection** (sanitization)

**OWASP Top 10:** 9/10 покрытие

---

## ⚡ Performance

- **70+ database indexes** для оптимизации запросов
- **Redis caching** (5-50x faster queries)
- **Cache Strategy:** getOrSet pattern
- **Expected hit rate:** 70-95%

---

## 📊 Monitoring

- **Winston Logger** (daily rotation, 14 days)
- **Health Checks:** /health, /liveness, /readiness
- **HTTP Request/Response logging**
- **Structured JSON logs**
- **Specialized logging:** auth, security, performance

---

## 🔧 Development

### Полезные команды:

```bash
# Development
npm run start:dev         # Dev server с hot-reload
npm run start:debug       # Debug mode

# Build
npm run build             # Production build
npm run start:prod        # Production server

# Database
npm run migration:generate -- MigrationName  # Создать миграцию
npm run migration:run                        # Применить миграции
npm run migration:revert                     # Откатить миграцию
npm run seed                                 # Заполнить БД тестовыми данными

# Linting
npm run lint              # ESLint check
npm run lint:fix          # ESLint fix

# Testing
npm run test              # Unit tests
npm run test:e2e          # E2E tests
npm run test:cov          # Coverage report
```

---

## 📚 Документация

**Полная документация:** [../docs/README.md](../docs/README.md)

**Ключевые документы:**
- [Architecture](../docs/architecture/ARCHITECTURE.md)
- [API v2.0](../docs/technical/API-v2-Summary.md)
- [Database Schema](../docs/technical/Database-v2.md)
- [Testing Guide](../docs/development/TESTING.md)
- [CI/CD](../docs/development/CI_CD.md)
- [Project Status](../docs/reports/PROJECT_STATUS.md)

---

## 🤝 Contributing

См. [Contributing Guide](../docs/guides/CONTRIBUTING.md)

---

**Версия:** 2.0  
**Статус:** Production Ready ✅  
**Последнее обновление:** 14 января 2026
