# Service Platform - Setup Guide

Полное руководство по настройке и запуску проекта локально.

## 📋 Предварительные требования

### Обязательно
- **Node.js** 18+ и npm
- **Flutter** 3.x
- **Docker** и **Docker Compose**
- **Git**

### Опционально (если не используете Docker)
- PostgreSQL 15+
- Redis 7+

## 🚀 Быстрый старт

### 1. Клонирование репозитория

```bash
git clone https://github.com/Midasfallen/masters.git
cd masters
```

### 2. Запуск инфраструктуры (Docker)

Запустите все необходимые сервисы (PostgreSQL, Redis, MinIO, Meilisearch):

```bash
docker-compose -f docker-compose.dev.yml up -d
```

Проверьте, что все контейнеры запущены:

```bash
docker-compose -f docker-compose.dev.yml ps
```

Вы должны увидеть:
- ✅ postgres (порт 5432)
- ✅ redis (порт 6379)
- ✅ minio (порты 9000, 9001)
- ✅ meilisearch (порт 7700)
- ✅ pgadmin (порт 5050) - опционально

### 3. Настройка Backend

```bash
cd backend

# Установка зависимостей
npm install

# Создание .env файла
cp .env.example .env

# Отредактируйте .env если нужно (для локальной разработки должно работать из коробки)
```

Запуск backend:

```bash
# Development mode с hot reload
npm run start:dev
```

Backend будет доступен:
- 📡 API: http://localhost:3000/api/v2
- 📚 Swagger документация: http://localhost:3000/api/v2/docs

### 4. Настройка Frontend (Flutter)

В новом терминале:

```bash
cd frontend

# Установка зависимостей
flutter pub get

# Запуск приложения
flutter run
```

Выберите устройство для запуска (Chrome, iOS Simulator, Android Emulator).

## 🛠 Детальная настройка

### Backend Environment Variables

Файл `backend/.env`:

```env
# Application
NODE_ENV=development
PORT=3000
API_PREFIX=api/v2

# Database (Docker)
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=postgres
DB_DATABASE=service_platform

# JWT
JWT_SECRET=your-super-secret-jwt-key-change-in-production
JWT_EXPIRES_IN=7d

# Redis (Docker)
REDIS_HOST=localhost
REDIS_PORT=6379

# MinIO (Docker)
MINIO_ENDPOINT=localhost
MINIO_PORT=9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin
MINIO_BUCKET=service-platform

# Meilisearch (Docker)
MEILISEARCH_HOST=http://localhost:7700
```

### Доступ к сервисам

После запуска Docker Compose доступны:

| Сервис | URL | Credentials |
|--------|-----|-------------|
| Backend API | http://localhost:3000 | - |
| Swagger Docs | http://localhost:3000/api/v2/docs | - |
| PostgreSQL | localhost:5432 | postgres / postgres |
| PgAdmin | http://localhost:5050 | admin@service-platform.local / admin |
| MinIO Console | http://localhost:9001 | minioadmin / minioadmin |
| Meilisearch | http://localhost:7700 | - |
| Redis | localhost:6379 | - |

## 🔧 Полезные команды

### Docker

```bash
# Запустить все сервисы
docker-compose -f docker-compose.dev.yml up -d

# Остановить все сервисы
docker-compose -f docker-compose.dev.yml down

# Посмотреть логи
docker-compose -f docker-compose.dev.yml logs -f

# Посмотреть логи конкретного сервиса
docker-compose -f docker-compose.dev.yml logs -f postgres

# Перезапустить сервис
docker-compose -f docker-compose.dev.yml restart postgres

# Удалить все данные (осторожно!)
docker-compose -f docker-compose.dev.yml down -v
```

### Backend

```bash
cd backend

# Запуск в dev режиме
npm run start:dev

# Запуск в production режиме
npm run build
npm run start:prod

# Тесты
npm run test
npm run test:e2e
npm run test:cov

# Линтинг
npm run lint
npm run format

# Миграции
npm run migration:generate -- src/database/migrations/MigrationName
npm run migration:run
npm run migration:revert
```

### Frontend

```bash
cd frontend

# Установка зависимостей
flutter pub get

# Генерация кода (для freezed, json_serializable)
flutter pub run build_runner build --delete-conflicting-outputs

# Запуск на конкретном устройстве
flutter run -d chrome
flutter run -d macos
flutter run -d ios

# Сборка
flutter build apk
flutter build ios
flutter build web

# Тесты
flutter test
```

## 🐛 Решение проблем

### Backend не запускается

1. Проверьте, что все Docker контейнеры запущены:
   ```bash
   docker-compose -f docker-compose.dev.yml ps
   ```

2. Проверьте логи PostgreSQL:
   ```bash
   docker-compose -f docker-compose.dev.yml logs postgres
   ```

3. Убедитесь, что порты не заняты другими приложениями:
   ```bash
   lsof -i :3000  # Backend
   lsof -i :5432  # PostgreSQL
   ```

### Ошибка подключения к БД

1. Проверьте, что PostgreSQL запущен и доступен:
   ```bash
   docker-compose -f docker-compose.dev.yml exec postgres pg_isready
   ```

2. Проверьте credentials в `.env` файле

3. Попробуйте подключиться вручную:
   ```bash
   psql -h localhost -U postgres -d service_platform
   ```

### Flutter ошибки

1. Очистите кеш:
   ```bash
   flutter clean
   flutter pub get
   ```

2. Перегенерируйте код:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

3. Обновите Flutter:
   ```bash
   flutter upgrade
   ```

## 📊 Структура проекта

```
masters/
├── backend/              # NestJS Backend
│   ├── src/
│   │   ├── modules/     # Функциональные модули
│   │   ├── common/      # Общие компоненты
│   │   ├── config/      # Конфигурация
│   │   └── main.ts
│   ├── .env.example
│   └── package.json
├── frontend/            # Flutter Frontend
│   ├── lib/
│   │   ├── features/   # Feature-based модули
│   │   ├── core/       # Ядро приложения
│   │   └── shared/     # Общие компоненты
│   └── pubspec.yaml
├── docs/               # Документация
├── docker-compose.dev.yml
└── SETUP.md           # Этот файл
```

## 🎯 Следующие шаги

После успешного запуска:

1. **Backend разработка:**
   - Создайте entities для User, Master, Service, Booking
   - Реализуйте Auth модуль (JWT)
   - Создайте основные CRUD endpoints

2. **Frontend интеграция:**
   - Замените mock данные на API calls
   - Настройте Dio для HTTP запросов
   - Реализуйте state management с Riverpod

3. **Тестирование:**
   - Напишите unit тесты для backend
   - Напишите widget тесты для Flutter
   - Проверьте интеграцию

## 📞 Помощь

Если у вас возникли проблемы:

1. Проверьте [Issues на GitHub](https://github.com/Midasfallen/masters/issues)
2. Посмотрите документацию в папке `docs/`
3. Создайте новый Issue с описанием проблемы

---

**Успешной разработки!** 🚀
