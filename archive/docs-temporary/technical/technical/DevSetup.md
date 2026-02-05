# DEVELOPMENT SETUP - Платформа Service

**Версия:** 1.0
**Дата:** Декабрь 2025

---

## Обзор

Руководство по настройке окружения разработки для платформы Service.

---

## Требования

### Обязательные

- **Docker** 20.10+ и **Docker Compose** 2.0+
- **Node.js** 18+ (LTS) и **npm** 8+
- **Git** 2.30+

### Опциональные (для разработки без Docker)

- **PostgreSQL** 15+ с расширением **PostGIS** 3.4+
- **Redis** 7+
- **Meilisearch** 1.5+
- **MinIO** (или AWS S3)

### Для Flutter разработки

- **Flutter SDK** 3.16+
- **Dart** 3.2+
- **Android Studio** (для Android)
- **Xcode** (для iOS, только macOS)

---

## Быстрый старт

### 1. Клонирование репозитория

```bash
git clone https://github.com/your-org/service-platform.git
cd service-platform
```

---

### 2. Настройка окружения

#### Создайте файл .env

```bash
cp .env.example .env
```

#### Отредактируйте .env

Минимальные настройки для локальной разработки уже заданы в `.env.example`.

**Обязательно измените:**
- `JWT_SECRET` - случайная строка 32+ символа
- `GOOGLE_CLIENT_ID` и `GOOGLE_CLIENT_SECRET` (если тестируете OAuth)

---

### 3. Запуск сервисов через Docker Compose

#### Запустить все сервисы

```bash
docker-compose up -d
```

Это запустит:
- **PostgreSQL** (порт 5433) - база данных
- **Redis** (порт 6379) - кэш и сессии
- **Meilisearch** (порт 7700) - полнотекстовый поиск
- **MinIO** (порты 9000, 9001) - хранилище медиа
- **MailHog** (порты 1025, 8025) - SMTP для тестирования email
- **Adminer** (порт 8080) - веб-интерфейс для БД

#### Проверить статус

```bash
docker-compose ps
```

Все сервисы должны быть в статусе `Up` и `healthy`.

#### Остановить сервисы

```bash
docker-compose down
```

#### Остановить и удалить volumes (очистка данных)

```bash
docker-compose down -v
```

---

### ВАЖНО: Выбор Docker Compose файла

> ⚠️ **УСТАРЕЛО:** `docker-compose.dev.yml` был перемещен в архив, так как основной `docker-compose.yml` уже содержит PostGIS (postgis/postgis:15-3.4-alpine). Используйте только `docker-compose.yml` для всех сценариев.

**Для разработки (рекомендуется):**
```bash
docker-compose up -d
```

Основной `docker-compose.yml` уже включает:
- PostgreSQL с PostGIS (postgis/postgis:15-3.4-alpine)
- Порт 5433 для избежания конфликтов
- Все необходимые сервисы для разработки

> ⚠️ **Важно:** Убедитесь, что `backend/.env` настроен для `docker-compose.yml`:
> - `DB_PORT=5433`, `DB_USERNAME=service_user`, `DB_PASSWORD=service_password`

---

### 4. Настройка Backend (NestJS)

#### Установить зависимости

```bash
cd backend
npm install
```

#### Запустить миграции базы данных

```bash
npm run migration:run
```

#### Заполнить базу начальными данными (seed)

```bash
npm run seed
```

#### Запустить в режиме разработки

```bash
npm run start:dev
```

Backend будет доступен на `http://localhost:3000`.

#### API документация (Swagger)

Откройте в браузере: `http://localhost:3000/api/v2/docs`

---

### 5. Настройка Frontend (Flutter)

#### Установить зависимости

```bash
cd frontend
flutter pub get
```

#### Генерация кода (локализация, модели)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

#### Запустить в режиме разработки

**Web:**
```bash
flutter run -d chrome
```

**iOS симулятор:**
```bash
flutter run -d "iPhone 15 Pro"
```

**Android эмулятор:**
```bash
flutter run -d emulator-5554
```

---

## Доступ к сервисам

### Backend API
- **URL:** `http://localhost:3000`
- **Swagger docs:** `http://localhost:3000/api/v2/docs`

### PostgreSQL (через Adminer)
- **URL:** `http://localhost:8080`
- **System:** PostgreSQL
- **Server:** postgres
- **Username:** service_user
- **Password:** service_password
- **Database:** service_db

### Meilisearch Dashboard
- **URL:** `http://localhost:7700`
- **Master Key:** meilisearch_master_key

### MinIO Console
- **URL:** `http://localhost:9001`
- **Username:** minio_access_key
- **Password:** minio_secret_key

### MailHog (Email testing)
- **Web UI:** `http://localhost:8025`
- **SMTP:** `localhost:1025`

### Redis
- **Host:** localhost
- **Port:** 6379
- **Password:** redis_password

**Подключение через redis-cli:**
```bash
docker exec -it service_redis redis-cli -a redis_password
```

---

## Структура проекта

```
service-platform/
├── backend/                   # NestJS backend
│   ├── src/
│   │   ├── auth/             # Аутентификация
│   │   ├── users/            # Пользователи
│   │   ├── catalog/          # Каталог услуг
│   │   ├── search/           # Поиск
│   │   ├── booking/          # Бронирование
│   │   ├── content/          # Контент (посты)
│   │   ├── social/           # Лайки, комментарии
│   │   ├── chat/             # Чаты
│   │   ├── notifications/    # Уведомления
│   │   ├── admin/            # Админ-панель
│   │   └── i18n/             # Переводы
│   ├── database/
│   │   ├── migrations/       # TypeORM миграции
│   │   ├── seeds/            # Начальные данные
│   │   └── init.sql          # SQL инициализация
│   ├── test/                 # Тесты
│   └── package.json
│
├── frontend/                  # Flutter frontend
│   ├── lib/
│   │   ├── features/         # Фичи по модулям
│   │   ├── core/             # Core (DI, routing, theme)
│   │   ├── shared/           # Shared widgets/utils
│   │   └── l10n/             # Локализация
│   ├── test/                 # Тесты
│   └── pubspec.yaml
│
├── docs/                      # Документация
│   ├── business/             # BRD, User Stories, Catalog
│   ├── technical/            # TechSpec, API, Database, i18n
│   ├── analysis/             # Requirements, Roadmap, Risks
│   ├── testing/              # Test Plan
│   └── i18n/                 # Переводы каталога
│
├── docker-compose.yml         # Docker Compose конфигурация
├── .env.example               # Пример переменных окружения
└── README.md                  # Основной README
```

---

## Workflow разработки

### Git Flow

**Основные ветки:**
- `main` - production
- `develop` - development

**Feature branches:**
```bash
git checkout -b feature/user-authentication
# ... работа ...
git commit -m "feat(auth): add JWT authentication"
git push origin feature/user-authentication
# Создать Pull Request в develop
```

**Commit conventions:**
- `feat:` - новая фича
- `fix:` - исправление бага
- `docs:` - обновление документации
- `refactor:` - рефакторинг
- `test:` - добавление тестов
- `chore:` - прочее (зависимости, конфиги)

---

### Backend Development

#### Создание нового модуля

```bash
cd backend
nest g module users
nest g controller users
nest g service users
```

#### Создание миграции

```bash
# После изменения entities
npm run migration:generate -- -n AddUserRoles
```

#### Запуск тестов

```bash
# Unit tests
npm run test

# E2E tests
npm run test:e2e

# Coverage
npm run test:cov
```

#### Линтинг и форматирование

```bash
npm run lint
npm run format
```

---

### Frontend Development

#### Генерация кода

**Модели из OpenAPI:**
```bash
flutter pub run build_runner build
```

**Локализация:**
```bash
flutter gen-l10n
```

#### Запуск тестов

```bash
# Unit/Widget tests
flutter test

# Integration tests
flutter drive --target=test_driver/app.dart
```

#### Линтинг

```bash
flutter analyze
```

---

## Troubleshooting

### PostgreSQL не стартует

**Проблема:** порт 5432 уже занят

**Решение:**
```bash
# Найти процесс
lsof -i :5432

# Остановить PostgreSQL на хосте
brew services stop postgresql  # macOS
sudo systemctl stop postgresql  # Linux

# Или изменить порт в docker-compose.yml:
ports:
  - "5433:5432"
```

---

### Meilisearch не индексирует

**Проблема:** master key неверный

**Решение:**
Проверьте, что `MEILISEARCH_KEY` в `.env` совпадает с `MEILI_MASTER_KEY` в `docker-compose.yml`.

---

### MinIO buckets не создаются

**Проблема:** контейнер `minio_createbuckets` упал

**Решение:**
```bash
docker-compose logs minio_createbuckets
# Пересоздать buckets вручную
docker-compose up minio_createbuckets
```

---

### Backend не подключается к БД

**Проблема:** Несоответствие конфигурации БД

**Решение:**

1. **Проверьте какой docker-compose используется:**

| Файл | PostgreSQL | Порт | БД |
|------|------------|------|-----|
| `docker-compose.yml` | postgres:15-alpine | 5433 | service_db |
| `docker-compose.dev.yml` | postgis/postgis:15-3.4 | 5432 | service_db |

2. **Убедитесь, что в `backend/.env` порт совпадает:**

Для `docker-compose.yml` (production):
```env
DB_HOST=localhost
DB_PORT=5433
DB_DATABASE=service_db
DB_USERNAME=service_user
DB_PASSWORD=service_password
```

Для `docker-compose.dev.yml` (development с PostGIS):
```env
DB_HOST=localhost
DB_PORT=5432
DB_DATABASE=service_db
DB_USERNAME=postgres
DB_PASSWORD=postgres
```

3. **Если backend в Docker**, используйте имя сервиса:
```env
DB_HOST=postgres
DB_PORT=5432
```

---

### Flutter hot reload не работает

**Проблема:** изменения не применяются

**Решение:**
```bash
# Перезапустить Flutter
r  # hot reload
R  # hot restart

# Очистить кэш
flutter clean
flutter pub get
```

---

## Production Setup

### Environment Variables

**Обязательно измените в production:**
- `NODE_ENV=production`
- `JWT_SECRET` - криптографически стойкий ключ
- `DATABASE_PASSWORD` - надёжный пароль
- `REDIS_PASSWORD` - надёжный пароль
- Настройте **реальные** OAuth credentials
- Настройте **реальный** SMTP (SendGrid, AWS SES, etc.)
- Включите **Sentry** для отслеживания ошибок

---

### Docker Production Build

```bash
# Backend
cd backend
docker build -t service-backend:latest .

# Frontend (Web)
cd frontend
flutter build web --release
```

---

### Database Migrations

**Production миграции:**
```bash
npm run migration:run
```

❌ **НЕ используйте** `synchronize: true` в production!

---

## CI/CD

### GitHub Actions (пример)

Создайте `.github/workflows/ci.yml`:

```yaml
name: CI

on: [push, pull_request]

jobs:
  backend-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: cd backend && npm ci
      - run: cd backend && npm run test
      - run: cd backend && npm run test:e2e

  frontend-test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.16.0'
      - run: cd frontend && flutter pub get
      - run: cd frontend && flutter test
```

---

## Связанные документы

- [TechSpec](./TechSpec.md) - Техническая спецификация
- [Database](./Database.md) - Схема базы данных
- [API](./API.md) - API спецификация
- [i18n](./i18n.md) - Локализация
- [TestPlan](../testing/TestPlan.md) - План тестирования

---

**Статус:** Актуально
**Последнее обновление:** Декабрь 2025
