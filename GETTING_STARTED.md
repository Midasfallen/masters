# Getting Started - Service Platform

**Дата:** 13 января 2026
**Версия:** 1.0
**MVP Status:** 100% Complete ✅

---

## 📋 Содержание

1. [Требования к системе](#требования-к-системе)
2. [Установка зависимостей](#установка-зависимостей)
3. [Настройка окружения](#настройка-окружения)
4. [Запуск Backend](#запуск-backend)
5. [Запуск Frontend](#запуск-frontend)
6. [Запуск тестов](#запуск-тестов)
7. [Полезные команды](#полезные-команды)
8. [Troubleshooting](#troubleshooting)

---

## 🖥️ Требования к системе

### Общие требования:
- **OS:** Windows 10/11, macOS 10.15+, Linux (Ubuntu 20.04+)
- **RAM:** Минимум 8GB (рекомендуется 16GB)
- **Disk:** 10GB свободного места
- **Internet:** Стабильное подключение для загрузки зависимостей

### Установленное ПО:

#### Backend:
- **Node.js:** v18.x или выше ([скачать](https://nodejs.org/))
- **npm:** v9.x или выше (входит в Node.js)
- **Docker:** v24.x или выше ([скачать](https://www.docker.com/products/docker-desktop/))
- **Docker Compose:** v2.x или выше (входит в Docker Desktop)

#### Frontend:
- **Flutter:** v3.16.0 или выше ([скачать](https://docs.flutter.dev/get-started/install))
- **Android Studio:** 2023.x или выше (для Android development)
- **Xcode:** 15.x или выше (для iOS development, только macOS)

#### Опционально (для разработки):
- **Git:** v2.x или выше
- **VS Code:** с расширениями Flutter, Dart, ESLint
- **PostgreSQL Client:** pgAdmin, DBeaver, или psql CLI

---

## 📦 Установка зависимостей

### 1. Клонирование репозитория

```bash
# HTTPS
git clone https://github.com/Midasfallen/masters.git

# SSH
git clone git@github.com:Midasfallen/masters.git

cd masters
```

### 2. Проверка установленных инструментов

```bash
# Node.js и npm
node --version    # Должно быть v18.x или выше
npm --version     # Должно быть v9.x или выше

# Docker
docker --version          # Должно быть 24.x или выше
docker-compose --version  # Должно быть v2.x или выше

# Flutter
flutter --version  # Должно быть 3.16.0 или выше
flutter doctor     # Проверка окружения Flutter
```

### 3. Установка зависимостей Backend

```bash
cd backend

# Установка npm пакетов
npm install

# Проверка установки
npm list --depth=0
```

**Ожидаемые зависимости:**
- `@nestjs/core`: ^10.0.0
- `@nestjs/typeorm`: ^10.0.0
- `typeorm`: ^0.3.17
- `pg`: ^8.11.3
- `redis`: ^4.6.10
- `socket.io`: ^4.6.0
- И другие...

### 4. Установка зависимостей Frontend

```bash
cd ../frontend

# Установка Flutter packages
flutter pub get

# Генерация кода (Freezed, JSON Serializable)
flutter pub run build_runner build --delete-conflicting-outputs

# Проверка
flutter pub outdated
```

**Ожидаемые зависимости:**
- `flutter_riverpod`: ^2.4.9
- `freezed_annotation`: ^2.4.1
- `dio`: ^5.4.0
- `socket_io_client`: ^2.0.3+1
- И другие...

---

## ⚙️ Настройка окружения

### 1. Backend Environment Variables

Создайте файл `.env` в директории `backend/`:

```bash
cd backend
cp .env.example .env
```

Отредактируйте `.env`:

```env
# Application
NODE_ENV=development
PORT=3000
APP_URL=http://localhost:3000

# Database (PostgreSQL)
DATABASE_HOST=localhost
DATABASE_PORT=5432
DATABASE_USER=service_user
DATABASE_PASSWORD=service_password
DATABASE_NAME=service_platform
DATABASE_SYNCHRONIZE=false
DATABASE_LOGGING=true

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=
REDIS_DB=0

# JWT Authentication
JWT_SECRET=your_very_long_and_secure_secret_key_here_at_least_32_characters
JWT_EXPIRES_IN=15m
JWT_REFRESH_SECRET=your_refresh_token_secret_key_here_also_very_long
JWT_REFRESH_EXPIRES_IN=7d

# Email (для forgot password)
SMTP_HOST=smtp.gmail.com
SMTP_PORT=587
SMTP_USER=your_email@gmail.com
SMTP_PASSWORD=your_app_password
SMTP_FROM=noreply@serviceplatform.com

# File Upload
UPLOAD_DEST=./uploads
MAX_FILE_SIZE=10485760

# Meilisearch (опционально)
MEILISEARCH_HOST=http://localhost:7700
MEILISEARCH_MASTER_KEY=your_master_key

# MinIO / S3 (опционально)
MINIO_ENDPOINT=localhost
MINIO_PORT=9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin
MINIO_USE_SSL=false
MINIO_BUCKET=uploads
```

### 2. Docker Compose Setup

Файл `docker-compose.yml` уже настроен в корне проекта:

```yaml
version: '3.8'

services:
  postgres:
    image: postgres:15-alpine
    container_name: service_platform_postgres
    restart: unless-stopped
    ports:
      - "5432:5432"
    environment:
      POSTGRES_DB: service_platform
      POSTGRES_USER: service_user
      POSTGRES_PASSWORD: service_password
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./backend/database:/docker-entrypoint-initdb.d
    networks:
      - service_network

  redis:
    image: redis:7-alpine
    container_name: service_platform_redis
    restart: unless-stopped
    ports:
      - "6379:6379"
    volumes:
      - redis_data:/data
    networks:
      - service_network

volumes:
  postgres_data:
  redis_data:

networks:
  service_network:
    driver: bridge
```

---

## 🚀 Запуск Backend

### Шаг 1: Запуск Docker сервисов

```bash
# Запуск PostgreSQL и Redis
docker-compose up -d

# Проверка статуса
docker-compose ps

# Просмотр логов
docker-compose logs -f postgres
docker-compose logs -f redis
```

**Ожидаемый вывод:**
```
NAME                           STATUS    PORTS
service_platform_postgres      Up        0.0.0.0:5432->5432/tcp
service_platform_redis         Up        0.0.0.0:6379->6379/tcp
```

### Шаг 2: Инициализация базы данных

```bash
cd backend

# Проверка подключения к БД
npm run db:test

# Запуск миграций
npm run migration:run

# Заполнение базы тестовыми данными
npm run seed
```

**Что создается при seed:**
- 10 пользователей (5 клиентов + 5 мастеров)
- 20 услуг для мастеров
- 30 постов в ленте
- 10 категорий услуг
- Тестовые бронирования

### Шаг 3: Запуск Backend сервера

```bash
# Development mode (с hot-reload)
npm run start:dev

# Production mode
npm run build
npm run start:prod

# Debug mode
npm run start:debug
```

**Успешный запуск:**
```
[Nest] 12345  - 13.01.2026, 10:00:00   LOG [NestFactory] Starting Nest application...
[Nest] 12345  - 13.01.2026, 10:00:00   LOG [InstanceLoader] AppModule dependencies initialized
[Nest] 12345  - 13.01.2026, 10:00:00   LOG [RoutesResolver] UserController {/api/users}:
[Nest] 12345  - 13.01.2026, 10:00:00   LOG [RouterExplorer] Mapped {/api/users, GET} route
[Nest] 12345  - 13.01.2026, 10:00:00   LOG [NestApplication] Nest application successfully started
[Nest] 12345  - 13.01.2026, 10:00:00   LOG Application running on: http://localhost:3000
[Nest] 12345  - 13.01.2026, 10:00:00   LOG Swagger docs available at: http://localhost:3000/api/docs
```

### Шаг 4: Проверка работы API

```bash
# Health check
curl http://localhost:3000/health

# Swagger UI
open http://localhost:3000/api/docs
```

**Ожидаемый ответ health check:**
```json
{
  "status": "healthy",
  "timestamp": "2026-01-13T10:00:00.000Z",
  "uptime": 3600,
  "version": "1.0.0",
  "services": {
    "database": {
      "status": "up",
      "responseTime": 5
    },
    "redis": {
      "status": "up",
      "responseTime": 2
    },
    "memory": {
      "status": "ok",
      "usage": {
        "heapUsed": 50,
        "heapTotal": 100,
        "rss": 150,
        "external": 10
      },
      "percentage": 50
    }
  }
}
```

---

## 📱 Запуск Frontend

### Шаг 1: Подготовка Flutter окружения

```bash
cd frontend

# Проверка Flutter
flutter doctor

# Все должно быть ✓ (зеленые галочки)
# Если есть ✗, следуйте инструкциям flutter doctor
```

### Шаг 2: Настройка API endpoint

Отредактируйте `frontend/lib/core/constants/app_constants.dart`:

```dart
class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:3000/api'; // Backend URL
  static const String wsUrl = 'http://localhost:3000'; // WebSocket URL

  // Для Android эмулятора используйте:
  // static const String apiBaseUrl = 'http://10.0.2.2:3000/api';

  // Для iOS симулятора можно использовать localhost
  // Для реального устройства используйте IP компьютера
}
```

### Шаг 3: Генерация кода

```bash
# Генерация Freezed и JSON Serializable моделей
flutter pub run build_runner build --delete-conflicting-outputs

# Если нужно пересоздать все:
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

### Шаг 4: Запуск приложения

#### **Android:**

```bash
# Список доступных устройств
flutter devices

# Запуск на Android эмуляторе
flutter run -d emulator-5554

# Запуск на подключенном Android устройстве
flutter run -d <device-id>

# Debug mode (hot reload включен)
flutter run

# Release mode (для тестирования производительности)
flutter run --release
```

#### **iOS (только macOS):**

```bash
# Запуск на iOS симуляторе
flutter run -d iPhone

# Открыть iOS симулятор
open -a Simulator

# Запуск
flutter run
```

#### **Web:**

```bash
# Запуск web версии
flutter run -d chrome

# Или
flutter run -d web-server --web-port 8080
open http://localhost:8080
```

### Шаг 5: Тестовые аккаунты

После seed базы данных доступны следующие тестовые аккаунты:

**Клиенты:**
- Email: `client1@example.com` - Password: `password123`
- Email: `client2@example.com` - Password: `password123`
- Email: `client3@example.com` - Password: `password123`

**Мастера:**
- Email: `master1@example.com` - Password: `password123`
- Email: `master2@example.com` - Password: `password123`
- Email: `master3@example.com` - Password: `password123`

**Админ:**
- Email: `admin@example.com` - Password: `admin123`

---

## 🧪 Запуск тестов

### Backend Tests

```bash
cd backend

# Unit тесты
npm run test

# Unit тесты с покрытием
npm run test:cov

# E2E тесты
npm run test:e2e

# Все тесты
npm run test:all

# Watch mode (для разработки)
npm run test:watch

# Запуск конкретного теста
npm run test -- auth.service.spec.ts
```

**Ожидаемый вывод:**
```
PASS  src/modules/auth/auth.service.spec.ts
PASS  src/modules/users/users.service.spec.ts
PASS  src/modules/bookings/bookings.service.spec.ts
...

Test Suites: 15 passed, 15 total
Tests:       129 passed, 129 total
Snapshots:   0 total
Time:        45.123 s
Ran all test suites.

Coverage summary:
Statements   : 27.38% ( 456/1666 )
Branches     : 15.23% ( 89/584 )
Functions    : 23.45% ( 123/524 )
Lines        : 28.12% ( 412/1465 )
```

### E2E Tests

```bash
cd backend

# Убедитесь что PostgreSQL и Redis запущены
docker-compose up -d

# Запуск всех E2E тестов
npm run test:e2e

# Запуск конкретного E2E теста
npm run test:e2e -- bookings.e2e-spec.ts

# С детальным выводом
npm run test:e2e -- --verbose
```

**Ожидаемый вывод E2E:**
```
PASS  test/auth.e2e-spec.ts (11 tests)
  ✓ POST /auth/register - успешная регистрация (245ms)
  ✓ POST /auth/login - успешный логин (123ms)
  ✓ GET /auth/profile - получение профиля (89ms)
  ...

PASS  test/bookings.e2e-spec.ts (15 tests)
  ✓ POST /bookings - создание бронирования (156ms)
  ✓ PATCH /bookings/:id/confirm - подтверждение (98ms)
  ...

PASS  test/posts.e2e-spec.ts (24 tests)
PASS  test/admin.e2e-spec.ts (16 tests)

Test Suites: 4 passed, 4 total
Tests:       66 passed, 66 total
Time:        125.456 s
```

### Frontend Tests

```bash
cd frontend

# Unit и Widget тесты
flutter test

# С покрытием
flutter test --coverage

# Генерация HTML отчета покрытия
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Integration тесты
flutter test integration_test/

# Запуск конкретного теста
flutter test test/features/auth/auth_provider_test.dart
```

---

## 🛠️ Полезные команды

### Backend Commands

```bash
cd backend

# Development
npm run start:dev       # Запуск с hot-reload
npm run start:debug     # Запуск с debugger
npm run lint            # ESLint проверка
npm run format          # Prettier форматирование

# Database
npm run migration:generate -- -n MigrationName  # Создать миграцию
npm run migration:run                           # Применить миграции
npm run migration:revert                        # Откатить миграцию
npm run seed                                    # Seed database
npm run db:reset                                # Сброс БД (drop + create + seed)

# Testing
npm run test            # Unit тесты
npm run test:cov        # С покрытием
npm run test:e2e        # E2E тесты
npm run test:watch      # Watch mode

# Build
npm run build           # Production build
npm run start:prod      # Запуск production

# Docker
docker-compose up -d                    # Запуск сервисов
docker-compose down                     # Остановка сервисов
docker-compose logs -f postgres         # Логи PostgreSQL
docker-compose logs -f redis            # Логи Redis
docker-compose restart postgres         # Перезапуск PostgreSQL
docker-compose exec postgres psql -U service_user -d service_platform  # PostgreSQL CLI
```

### Frontend Commands

```bash
cd frontend

# Development
flutter run                             # Запуск приложения
flutter run --release                   # Release mode
flutter run -d chrome                   # Web version
flutter pub run build_runner build      # Генерация кода
flutter pub run build_runner watch      # Watch mode для генерации

# Testing
flutter test                            # Запуск тестов
flutter test --coverage                 # С покрытием
flutter analyze                         # Анализ кода

# Build
flutter build apk                       # Android APK
flutter build apk --release             # Release APK
flutter build ios                       # iOS build
flutter build web                       # Web build

# Clean
flutter clean                           # Очистка build артефактов
flutter pub get                         # Обновление зависимостей
```

### Docker Commands

```bash
# Сервисы
docker-compose up -d                    # Запуск в фоне
docker-compose up                       # Запуск с логами
docker-compose down                     # Остановка
docker-compose down -v                  # Остановка + удаление volumes
docker-compose restart                  # Перезапуск всех сервисов
docker-compose ps                       # Статус сервисов
docker-compose logs -f                  # Логи всех сервисов

# Конкретный сервис
docker-compose logs -f postgres         # Логи PostgreSQL
docker-compose restart postgres         # Перезапуск PostgreSQL
docker-compose exec postgres bash       # Shell в контейнере

# PostgreSQL
docker-compose exec postgres psql -U service_user -d service_platform
# SQL: \dt - список таблиц, \d users - описание таблицы, SELECT * FROM users LIMIT 10;

# Redis
docker-compose exec redis redis-cli
# Commands: KEYS *, GET key, FLUSHALL
```

---

## 🐛 Troubleshooting

### Backend Issues

#### **1. Ошибка подключения к PostgreSQL**

```
Error: connect ECONNREFUSED 127.0.0.1:5432
```

**Решение:**
```bash
# Проверить что PostgreSQL запущен
docker-compose ps

# Если не запущен:
docker-compose up -d postgres

# Проверить логи
docker-compose logs postgres

# Если проблема с портом 5432 (занят другим PostgreSQL):
# Измените порт в docker-compose.yml:
ports:
  - "5433:5432"  # Используем 5433 вместо 5432

# И в .env:
DATABASE_PORT=5433
```

#### **2. Ошибка подключения к Redis**

```
Error: connect ECONNREFUSED 127.0.0.1:6379
```

**Решение:**
```bash
# Проверить Redis
docker-compose ps redis

# Запустить
docker-compose up -d redis

# Проверить логи
docker-compose logs redis
```

#### **3. Ошибка миграции базы данных**

```
QueryFailedError: relation "users" does not exist
```

**Решение:**
```bash
# Проверить что миграции применены
npm run migration:run

# Если нужно пересоздать БД:
npm run db:reset

# Или вручную:
docker-compose down -v
docker-compose up -d postgres
npm run migration:run
npm run seed
```

#### **4. Порт 3000 уже занят**

```
Error: listen EADDRINUSE: address already in use :::3000
```

**Решение:**
```bash
# Найти процесс
# Linux/Mac:
lsof -i :3000
kill -9 <PID>

# Windows:
netstat -ano | findstr :3000
taskkill /PID <PID> /F

# Или измените порт в .env:
PORT=3001
```

### Frontend Issues

#### **1. Ошибка генерации кода**

```
[ERROR] ... conflicts with another ... freezed.dart
```

**Решение:**
```bash
# Удалить сгенерированные файлы и пересоздать
flutter pub run build_runner clean
flutter pub run build_runner build --delete-conflicting-outputs
```

#### **2. Ошибка подключения к API**

```
DioException: Connection refused
```

**Решение:**
```bash
# Проверить что Backend запущен
curl http://localhost:3000/health

# Для Android эмулятора используйте:
# lib/core/constants/app_constants.dart
static const String apiBaseUrl = 'http://10.0.2.2:3000/api';

# Для iOS симулятора localhost работает
# Для реального устройства используйте IP компьютера:
ipconfig getifaddr en0  # Mac
ip addr show           # Linux
ipconfig               # Windows
# Пример: http://192.168.1.100:3000/api
```

#### **3. Flutter SDK не найден**

```
Error: Unable to locate Android SDK
```

**Решение:**
```bash
# Запустить flutter doctor
flutter doctor

# Следовать инструкциям для установки недостающих компонентов
# Для Android: установить Android Studio
# Для iOS: установить Xcode (только macOS)

# Принять лицензии Android SDK
flutter doctor --android-licenses
```

#### **4. Зависимости не устанавливаются**

```
Error: Could not resolve dependencies
```

**Решение:**
```bash
# Очистить кеш
flutter clean
flutter pub cache clean

# Удалить lock файл
rm pubspec.lock

# Переустановить
flutter pub get
```

### Docker Issues

#### **1. Docker не запускается**

```
Cannot connect to the Docker daemon
```

**Решение:**
- Убедитесь что Docker Desktop запущен
- Перезапустите Docker Desktop
- На Linux: `sudo systemctl start docker`

#### **2. Volumes конфликтуют**

```
Error: Conflict. The container name is already in use
```

**Решение:**
```bash
# Остановить и удалить контейнеры
docker-compose down

# Удалить volumes
docker-compose down -v

# Запустить заново
docker-compose up -d
```

#### **3. Недостаточно памяти**

```
Error: ... out of memory
```

**Решение:**
- Docker Desktop → Settings → Resources → Memory
- Увеличить до минимум 4GB (рекомендуется 8GB)

---

## 📚 Дополнительные ресурсы

### Документация проекта:
- [ARCHITECTURE.md](./ARCHITECTURE.md) - Архитектура системы
- [API.md](./docs/technical/API-v2-Summary.md) - API документация
- [Database.md](./docs/technical/Database-v2.md) - Схема базы данных
- [CLAUDE.md](./CLAUDE.md) - Инструкции для разработчиков
- [PHASE_5_COMPLETION_SUMMARY.md](./PHASE_5_COMPLETION_SUMMARY.md) - Production Ready гайд

### Backend документация:
- [ADMIN_MODULE_SUMMARY.md](./backend/ADMIN_MODULE_SUMMARY.md) - Admin Panel
- [E2E_TESTING_SUMMARY.md](./backend/E2E_TESTING_SUMMARY.md) - E2E Tests
- [PERFORMANCE_OPTIMIZATION_SUMMARY.md](./backend/PERFORMANCE_OPTIMIZATION_SUMMARY.md) - Performance
- [SECURITY_AUDIT_SUMMARY.md](./backend/SECURITY_AUDIT_SUMMARY.md) - Security
- [MONITORING_SUMMARY.md](./backend/MONITORING_SUMMARY.md) - Monitoring & Logging

### CI/CD:
- [CI_CD_SUMMARY.md](./CI_CD_SUMMARY.md) - GitHub Actions workflows

### Swagger UI:
- **Local:** http://localhost:3000/api/docs
- Интерактивная документация всех API endpoints
- Возможность тестировать endpoints прямо в браузере

---

## 🎯 Быстрый старт (все команды)

### Первый запуск:

```bash
# 1. Клонирование
git clone https://github.com/Midasfallen/masters.git
cd masters

# 2. Backend setup
cd backend
npm install
cp .env.example .env
# Отредактировать .env (JWT_SECRET, DATABASE_PASSWORD и т.д.)

# 3. Запуск сервисов
docker-compose up -d

# 4. Инициализация БД
npm run migration:run
npm run seed

# 5. Запуск Backend
npm run start:dev

# 6. Frontend setup (новое окно терминала)
cd ../frontend
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# 7. Запуск Frontend
flutter run

# 8. Тестирование (опционально)
cd ../backend
npm run test:e2e
```

### Ежедневная разработка:

```bash
# Запуск всего проекта

# Терминал 1: Docker сервисы
docker-compose up

# Терминал 2: Backend
cd backend
npm run start:dev

# Терминал 3: Frontend
cd frontend
flutter run

# Готово! 🚀
```

---

## ✅ Проверка успешного запуска

После выполнения всех шагов проверьте:

- [ ] Backend запущен: http://localhost:3000/health → `{"status":"healthy"}`
- [ ] Swagger доступен: http://localhost:3000/api/docs
- [ ] PostgreSQL работает: `docker-compose ps postgres` → `Up`
- [ ] Redis работает: `docker-compose ps redis` → `Up`
- [ ] Frontend запущен и может войти с `client1@example.com` / `password123`
- [ ] WebSocket подключается (открыть чаты в приложении)
- [ ] Тесты проходят: `npm run test` → все зеленые ✓

---

## 💡 Советы для разработки

1. **Используйте hot-reload:**
   - Backend: `npm run start:dev` (автоматический перезапуск)
   - Frontend: `flutter run` (hot reload: `r`, hot restart: `R`)

2. **Логирование:**
   - Backend логи: `backend/logs/combined-YYYY-MM-DD.log`
   - Docker логи: `docker-compose logs -f`

3. **Debugging:**
   - Backend: `npm run start:debug` → VS Code debugger на порту 9229
   - Frontend: VS Code → Run → Start Debugging (F5)

4. **Database GUI:**
   - pgAdmin: http://localhost:5050 (если настроен)
   - DBeaver: Connect to localhost:5432
   - CLI: `docker-compose exec postgres psql -U service_user -d service_platform`

5. **Redis GUI:**
   - Redis Commander: http://localhost:8081 (если настроен)
   - CLI: `docker-compose exec redis redis-cli`

---

## 🆘 Поддержка

Если возникли проблемы:

1. Проверьте [Troubleshooting](#troubleshooting) секцию
2. Посмотрите логи: `docker-compose logs -f`
3. Проверьте Issues: https://github.com/Midasfallen/masters/issues
4. Создайте новый Issue с описанием проблемы

---

**Дата:** 13 января 2026
**Автор:** Claude Sonnet 4.5
**Версия:** 1.0

**🚀 Удачной разработки!**
