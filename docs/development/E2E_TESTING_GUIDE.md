# E2E ТЕСТИРОВАНИЕ - Service Platform

**Версия:** 2.0
**Дата:** Январь 2026
**Статус:** 73/73 E2E тестов (100%)

---

## Обзор

В проекте используются два типа E2E тестов:

### Тип 1: NestJS TestingModule (Интеграционные)

**Файлы:** `auth.e2e-spec.ts`, `posts.e2e-spec.ts`, `bookings.e2e-spec.ts`

- Запускаются через NestJS TestingModule
- Используют `app.getHttpServer()` для HTTP запросов
- Автоматически создают in-memory тестовую среду
- **Не требуют** запущенного Docker

### Тип 2: HTTP к Docker (E2E)

**Файлы:** `chats.e2e-spec.ts`, `notifications.e2e-spec.ts`, `reviews.e2e-spec.ts`, `admin.e2e-spec.ts`

- Отправляют реальные HTTP запросы к `http://localhost:3000/api/v2`
- **Требуют** запущенного Docker и Backend
- Регистрируют тестовых пользователей динамически
- Тестируют полную интеграцию

---

## Настройка тестовой среды

### Шаг 1: Запуск Docker сервисов

```bash
cd C:\masters\masters

# Вариант A: Production конфигурация (рекомендуется)
docker-compose up -d

# Вариант B: Development с PostGIS
docker-compose -f docker-compose.dev.yml up -d
```

### Шаг 2: Проверка готовности сервисов

```bash
docker-compose ps
```

Все сервисы должны быть в статусе `healthy`:
- `service_postgres` — PostgreSQL
- `service_redis` — Redis
- `service_meilisearch` — Meilisearch
- `service_minio` — MinIO

### Шаг 3: Настройка backend/.env

Убедитесь, что конфигурация соответствует выбранному docker-compose:

**Для `docker-compose.yml`:**
```env
DB_HOST=localhost
DB_PORT=5433
DB_DATABASE=service_db
DB_USERNAME=service_user
DB_PASSWORD=service_password
```

**Для `docker-compose.dev.yml`:**
```env
DB_HOST=localhost
DB_PORT=5432
DB_DATABASE=service_db
DB_USERNAME=postgres
DB_PASSWORD=postgres
```

### Шаг 4: Запуск миграций

```bash
cd backend
npm run migration:run
```

### Шаг 5: Запуск Backend

```bash
cd backend
npm run start:dev
```

Дождитесь сообщения:
```
🚀 Service Platform Backend v2.0 started!
📚 Swagger docs: http://0.0.0.0:3000/api/v2/docs
```

---

## Команды запуска тестов

### Unit тесты (185 тестов)

```bash
cd backend

# Все unit тесты (последовательно!)
npm run test -- --runInBand

# С покрытием
npm run test:cov -- --runInBand
```

### E2E тесты (73 теста)

```bash
cd backend

# Все E2E тесты (ОБЯЗАТЕЛЬНО последовательно!)
npm run test:e2e -- --runInBand

# Конкретный модуль
npm run test:e2e -- --testPathPattern="auth" --runInBand
npm run test:e2e -- --testPathPattern="chats" --runInBand
npm run test:e2e -- --testPathPattern="notifications" --runInBand
npm run test:e2e -- --testPathPattern="reviews" --runInBand
npm run test:e2e -- --testPathPattern="admin" --runInBand
```

> ⚠️ **Важно:** Флаг `--runInBand` обязателен для избежания конфликтов в БД.

---

## Решение проблемы 401 Unauthorized

### Симптом

```
Expected: 201
Received: 401 Unauthorized
```

### Диагностика

#### 1. Проверьте, что Backend запущен

```bash
curl http://localhost:3000/api/v2/health
# Ожидается: {"status":"ok"}
```

Если ошибка — запустите backend:
```bash
cd backend && npm run start:dev
```

#### 2. Проверьте конфигурацию БД

```bash
# Какой контейнер запущен?
docker ps --format "table {{.Names}}\t{{.Ports}}"
```

| Контейнер | Порт | .env настройки |
|-----------|------|----------------|
| `service_postgres` | 5433 | `DB_PORT=5433`, `DB_USERNAME=service_user` |
| `service-platform-postgres` | 5432 | `DB_PORT=5432`, `DB_USERNAME=postgres` |

#### 3. Проверьте, что миграции выполнены

```bash
cd backend
npm run migration:run
```

#### 4. Очистите тестовых пользователей (опционально)

```bash
# Для docker-compose.yml
docker exec -it service_postgres psql -U service_user -d service_db \
  -c "DELETE FROM users WHERE email LIKE 'test-%@%';"

# Для docker-compose.dev.yml
docker exec -it service-platform-postgres psql -U postgres -d service_db \
  -c "DELETE FROM users WHERE email LIKE 'test-%@%';"
```

#### 5. Проверьте JWT_SECRET

В `backend/.env`:
```env
JWT_SECRET=your-super-secret-jwt-key-change-in-production
```

---

## Матрица соответствия конфигураций

| Параметр | docker-compose.yml | docker-compose.dev.yml |
|----------|-------------------|----------------------|
| **Образ PostgreSQL** | postgres:15-alpine | postgis/postgis:15-3.4 |
| **PostGIS** | Нет | Да |
| **Порт PostgreSQL** | 5433:5432 | 5432:5432 |
| **POSTGRES_DB** | service_db | service_db |
| **POSTGRES_USER** | service_user | postgres |
| **POSTGRES_PASSWORD** | service_password | postgres |
| **Контейнер** | service_postgres | service-platform-postgres |

---

## Структура E2E тестов

```
backend/test/
├── jest-e2e.json           # Jest конфигурация (maxWorkers: 1)
├── auth.e2e-spec.ts        # Аутентификация (NestJS TestingModule)
├── admin.e2e-spec.ts       # Админ-панель (HTTP к Docker)
├── bookings.e2e-spec.ts    # Бронирования (NestJS TestingModule)
├── posts.e2e-spec.ts       # Посты (NestJS TestingModule)
├── chats.e2e-spec.ts       # Чаты (HTTP к Docker)
├── notifications.e2e-spec.ts # Уведомления (HTTP к Docker)
└── reviews.e2e-spec.ts     # Отзывы (HTTP к Docker)
```

---

## Переменные окружения для тестов

| Переменная | Default | Описание |
|------------|---------|----------|
| `API_URL` | `http://localhost:3000/api/v2` | Base URL для HTTP тестов |
| `DB_HOST` | `localhost` | Хост PostgreSQL |
| `DB_PORT` | `5433` | Порт PostgreSQL |
| `JWT_SECRET` | - | Секрет для JWT (обязателен) |
| `NODE_ENV` | `test` | Окружение |

---

## Чеклист перед запуском тестов

- [ ] Docker контейнеры запущены: `docker-compose ps`
- [ ] Все сервисы в статусе `healthy`
- [ ] `DB_PORT` в `backend/.env` совпадает с портом в compose
- [ ] `DB_DATABASE` = `service_db`
- [ ] `DB_USERNAME` соответствует compose файлу
- [ ] Миграции выполнены: `npm run migration:run`
- [ ] Backend запущен: `npm run start:dev`
- [ ] Тесты запускаются с `--runInBand`

---

## Известные особенности

### 1. Response format различается

**Chats API** (meta wrapper):
```json
{
  "data": [...],
  "meta": {
    "total": 10,
    "page": 1,
    "limit": 20
  }
}
```

**Notifications API** (flat):
```json
{
  "data": [...],
  "total": 10,
  "page": 1,
  "limit": 20
}
```

### 2. Таймауты

- `beforeAll` timeout: 30000-60000ms
- `testTimeout`: 30000ms

На медленных машинах увеличьте в `jest-e2e.json`:
```json
{
  "testTimeout": 60000
}
```

---

## Связанные документы

- [DevSetup.md](../technical/DevSetup.md) — Настройка окружения
- [DOCKER_CONFIGURATION.md](../technical/DOCKER_CONFIGURATION.md) — Конфигурация Docker
- [API.md](../technical/API.md) — API спецификация

---

**Последнее обновление:** Январь 2026
