# PRODUCT BACKLOG - Платформа Service

**Версия:** 1.0
**Дата:** 22 декабря 2025
**Статус:** Актуальный бэклог для разработки MVP

---

## Содержание

1. [Введение](#введение)
2. [Методология](#методология)
3. [Эпики](#эпики)
4. [Product Backlog](#product-backlog)
5. [Sprint Planning](#sprint-planning)
6. [Definition of Done](#definition-of-done)
7. [Метрики](#метрики)

---

## Введение

### Цель бэклога

Этот документ содержит приоритизированный список всех задач для достижения MVP платформы Service. Бэклог структурирован по эпикам, с оценками сложности и зависимостями.

### Текущий статус проекта

**Готовность к MVP:** ~40%

| Компонент | Статус | Прогресс |
|-----------|--------|----------|
| Документация | ✅ Готово | 100% |
| Flutter прототип | ✅ Готово | 100% |
| Backend | ❌ Не начато | 0% |
| Интеграция | ❌ Не начато | 0% |
| Тестирование | 📝 Документация | 5% |
| CI/CD | ❌ Не начато | 0% |

---

## Методология

### Приоритизация: MoSCoW

- **Must Have** 🔴 - Критично для MVP, без этого релиз невозможен
- **Should Have** 🟠 - Важно для качественного MVP
- **Could Have** 🟡 - Желательно, но можно отложить
- **Won't Have** 🔵 - Не будет в MVP, для будущих версий

### Story Points (оценка сложности)

Используем шкалу Фибоначчи:
- **1 точка** - Trivial (< 1 час)
- **2 точки** - Simple (1-2 часа)
- **3 точки** - Medium (2-4 часа)
- **5 точек** - Complex (1 день)
- **8 точек** - Very Complex (2-3 дня)
- **13 точек** - Epic (5+ дней)
- **21 точка** - Mega Epic (1-2 недели)

### Velocity

**Целевая скорость:** 40-50 SP в 2-недельный спринт (1 разработчик)

---

## Эпики

### Epic 1: Backend Infrastructure 🔴 (Must Have)
**Цель:** Создать базовую инфраструктуру backend
**Story Points:** 55 SP
**Приоритет:** Максимальный
**Статус:** 🔴 Not Started

### Epic 2: Backend Authentication & Users 🔴 (Must Have)
**Цель:** Реализовать систему аутентификации
**Story Points:** 34 SP
**Приоритет:** Критический
**Статус:** 🔴 Not Started

### Epic 3: Backend Masters & Services 🔴 (Must Have)
**Цель:** Профили мастеров и управление услугами
**Story Points:** 42 SP
**Приоритет:** Критический
**Статус:** 🔴 Not Started

### Epic 4: Backend Bookings 🔴 (Must Have)
**Цель:** Система бронирования
**Story Points:** 55 SP
**Приоритет:** Критический
**Статус:** 🔴 Not Started

### Epic 5: Backend Search 🔴 (Must Have)
**Цель:** Поиск мастеров (гео + текст)
**Story Points:** 34 SP
**Приоритет:** Критический
**Статус:** 🔴 Not Started

### Epic 6: Flutter Integration 🔴 (Must Have)
**Цель:** Интеграция Flutter с Backend
**Story Points:** 55 SP
**Приоритет:** Высокий
**Статус:** 🔴 Not Started

### Epic 7: Testing 🟠 (Should Have)
**Цель:** Unit, Integration, E2E тесты
**Story Points:** 42 SP
**Приоритет:** Высокий
**Статус:** 🔴 Not Started

### Epic 8: Backend Reviews & Content 🟠 (Should Have)
**Цель:** Отзывы и контент (посты)
**Story Points:** 34 SP
**Приоритет:** Средний
**Статус:** 🔴 Not Started

### Epic 9: Real-time Features 🟡 (Could Have)
**Цель:** WebSocket чат и уведомления
**Story Points:** 34 SP
**Приоритет:** Средний
**Статус:** 🔴 Not Started

### Epic 10: CI/CD & Deployment 🟠 (Should Have)
**Цель:** Автоматизация и деплой
**Story Points:** 21 SP
**Приоритет:** Средний
**Статус:** 🔴 Not Started

---

## Product Backlog

### 📊 Сводная таблица

| # | Задача | Epic | Приоритет | SP | Статус | Спринт |
|---|--------|------|-----------|----|----|--------|
| 1 | Выбор Backend Tech Stack | E1 | 🔴 Must | 1 | 🔴 Todo | S1 |
| 2 | Инициализация Backend проекта | E1 | 🔴 Must | 3 | 🔴 Todo | S1 |
| 3 | Настройка TypeORM + PostgreSQL | E1 | 🔴 Must | 5 | 🔴 Todo | S1 |
| 4 | Создание Database схемы | E1 | 🔴 Must | 8 | 🔴 Todo | S1 |
| 5 | Database миграции (19 таблиц) | E1 | 🔴 Must | 13 | 🔴 Todo | S1 |
| 6 | Seed данные для разработки | E1 | 🔴 Must | 5 | 🔴 Todo | S1 |
| 7 | Настройка .env и конфигурации | E1 | 🔴 Must | 2 | 🔴 Todo | S1 |
| 8 | Запуск docker-compose инфраструктуры | E1 | 🔴 Must | 3 | 🔴 Todo | S1 |
| ... | ... | ... | ... | ... | ... | ... |

**Всего задач:** 120+
**Всего Story Points:** ~450 SP

---

## EPIC 1: Backend Infrastructure 🔴

**Общая оценка:** 55 SP
**Зависимости:** Нет (стартовый эпик)

### Задачи:

#### BAK-001: Выбор Backend Tech Stack
- **Описание:** Принять решение по tech stack
- **Приоритет:** 🔴 Must Have
- **Story Points:** 1 SP
- **Acceptance Criteria:**
  - [ ] Выбран один из: NestJS / Go / FastAPI
  - [ ] Решение задокументировано в README.md
  - [ ] Команда согласована с выбором
- **Рекомендация:** NestJS + TypeScript
- **Статус:** 🔴 Not Started

---

#### BAK-002: Инициализация NestJS проекта
- **Описание:** Создать базовую структуру backend
- **Приоритет:** 🔴 Must Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-001
- **Acceptance Criteria:**
  - [ ] Проект создан через `nest new backend`
  - [ ] Структура папок настроена
  - [ ] package.json содержит базовые зависимости
  - [ ] Проект запускается без ошибок
- **Команды:**
  ```bash
  npx @nestjs/cli new backend
  cd backend
  npm install
  npm run start:dev
  ```
- **Статус:** 🔴 Not Started

---

#### BAK-003: Настройка TypeORM + PostgreSQL
- **Описание:** Подключить ORM и БД
- **Приоритет:** 🔴 Must Have
- **Story Points:** 5 SP
- **Зависимости:** BAK-002
- **Acceptance Criteria:**
  - [ ] Установлены зависимости: `@nestjs/typeorm typeorm pg`
  - [ ] Настроен TypeOrmModule в app.module.ts
  - [ ] Подключение к PostgreSQL работает
  - [ ] Логи подключения видны в консоли
- **Конфигурация:**
  ```typescript
  TypeOrmModule.forRoot({
    type: 'postgres',
    host: 'localhost',
    port: 5432,
    username: 'service_user',
    password: 'service_password',
    database: 'service_db',
    entities: [],
    synchronize: false, // migrations only
  })
  ```
- **Статус:** 🔴 Not Started

---

#### BAK-004: Создание Database схемы (Entity классы)
- **Описание:** Создать TypeORM entities для 19 таблиц
- **Приоритет:** 🔴 Must Have
- **Story Points:** 8 SP
- **Зависимости:** BAK-003
- **Acceptance Criteria:**
  - [ ] Созданы entity классы для всех таблиц из Database.md:
    - users, masters, master_services, master_schedule
    - bookings, reviews, favorites
    - content_posts, chat_rooms, chat_messages
    - notifications, subscriptions, transactions
    - categories, catalog_services, i18n_translations
    - admin_actions, reports, user_settings
  - [ ] Все relationships (OneToMany, ManyToOne) настроены
  - [ ] Indexes добавлены через decorators
  - [ ] PostGIS Point типы для геолокации
- **Пример:**
  ```typescript
  @Entity('users')
  export class User {
    @PrimaryGeneratedColumn('uuid')
    id: string;

    @Column({ unique: true })
    email: string;

    @Column()
    password_hash: string;

    @Index()
    @Column({ type: 'geometry', spatialFeatureType: 'Point', srid: 4326, nullable: true })
    location: Point;

    // ... остальные поля
  }
  ```
- **Статус:** 🔴 Not Started

---

#### BAK-005: Database Migrations (19 таблиц)
- **Описание:** Создать и применить миграции
- **Приоритет:** 🔴 Must Have
- **Story Points:** 13 SP
- **Зависимости:** BAK-004
- **Acceptance Criteria:**
  - [ ] Настроен typeorm CLI
  - [ ] Созданы миграции для всех таблиц
  - [ ] Миграции применяются без ошибок
  - [ ] Rollback работает корректно
  - [ ] Все индексы созданы
  - [ ] PostGIS extension установлен
- **Команды:**
  ```bash
  npm run typeorm migration:generate -- -n InitialSchema
  npm run typeorm migration:run
  npm run typeorm migration:revert # test rollback
  ```
- **Статус:** 🔴 Not Started

---

#### BAK-006: Seed данные для разработки
- **Описание:** Создать тестовые данные
- **Приоритет:** 🔴 Must Have
- **Story Points:** 5 SP
- **Зависимости:** BAK-005
- **Acceptance Criteria:**
  - [ ] Скрипт seed.ts создан
  - [ ] Созданы:
    - 10 тестовых пользователей
    - 5 мастеров с профилями
    - 20 услуг
    - 10 категорий из Catalog.md
    - 15 записей (bookings)
    - 20 отзывов
  - [ ] Скрипт идемпотентный (можно запускать многократно)
- **Команда:**
  ```bash
  npm run seed
  ```
- **Статус:** 🔴 Not Started

---

#### BAK-007: Настройка .env и конфигурации
- **Описание:** Environment variables и ConfigModule
- **Приоритет:** 🔴 Must Have
- **Story Points:** 2 SP
- **Зависимости:** BAK-002
- **Acceptance Criteria:**
  - [ ] Установлен `@nestjs/config`
  - [ ] Создан .env файл
  - [ ] Создан .env.example
  - [ ] ConfigModule настроен
  - [ ] Переменные:
    - DATABASE_URL
    - JWT_SECRET
    - JWT_EXPIRES_IN
    - REDIS_URL
    - MINIO_ENDPOINT
    - MINIO_ACCESS_KEY
    - MINIO_SECRET_KEY
- **Статус:** 🔴 Not Started

---

#### BAK-008: Запуск Docker-compose инфраструктуры
- **Описание:** Запустить все сервисы
- **Приоритет:** 🔴 Must Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-007
- **Acceptance Criteria:**
  - [ ] PostgreSQL запущен и доступен
  - [ ] Redis запущен
  - [ ] Meilisearch запущен
  - [ ] MinIO запущен
  - [ ] Nginx настроен (опционально для dev)
  - [ ] Health checks проходят
- **Команды:**
  ```bash
  docker-compose up -d
  docker-compose ps
  docker-compose logs -f postgres
  ```
- **Статус:** 🔴 Not Started

---

#### BAK-009: Базовая структура модулей
- **Описание:** Создать пустые модули
- **Приоритет:** 🔴 Must Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-002
- **Acceptance Criteria:**
  - [ ] Созданы модули:
    - auth, users, masters, bookings
    - search, reviews, content
    - chat, notifications, admin
  - [ ] Каждый модуль имеет: module, controller, service
  - [ ] Модули зарегистрированы в app.module
- **Команды:**
  ```bash
  nest g module auth
  nest g service auth
  nest g controller auth
  # ... repeat for all modules
  ```
- **Статус:** 🔴 Not Started

---

#### BAK-010: Swagger API документация
- **Описание:** Настроить OpenAPI
- **Приоритет:** 🟠 Should Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-009
- **Acceptance Criteria:**
  - [ ] Установлен `@nestjs/swagger`
  - [ ] Swagger UI доступен на /api/docs
  - [ ] Базовые endpoints задокументированы
  - [ ] Schemas генерируются автоматически
- **URL:** http://localhost:3000/api/docs
- **Статус:** 🔴 Not Started

---

#### BAK-011: Логирование (Winston)
- **Описание:** Настроить логирование
- **Приоритет:** 🟡 Could Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-002
- **Acceptance Criteria:**
  - [ ] Установлен winston + nest-winston
  - [ ] Логи пишутся в файлы (logs/error.log, logs/combined.log)
  - [ ] Логи структурированные (JSON)
  - [ ] Разные уровни: error, warn, info, debug
- **Статус:** 🔴 Not Started

---

#### BAK-012: Error Handling и Exception Filters
- **Описание:** Глобальная обработка ошибок
- **Приоритет:** 🟠 Should Have
- **Story Points:** 5 SP
- **Зависимости:** BAK-009
- **Acceptance Criteria:**
  - [ ] Создан GlobalExceptionFilter
  - [ ] Все ошибки возвращают consistent format:
    ```json
    {
      "error": "ERROR_CODE",
      "message": "Human readable message",
      "timestamp": "2025-01-15T10:00:00Z",
      "path": "/api/v1/endpoint"
    }
    ```
  - [ ] HTTP коды корректные (400, 401, 403, 404, 500)
  - [ ] Логирование ошибок
- **Статус:** 🔴 Not Started

---

## EPIC 2: Backend Authentication & Users 🔴

**Общая оценка:** 34 SP
**Зависимости:** Epic 1

### Задачи:

#### BAK-101: Auth Module - Базовая структура
- **Описание:** Настроить Passport + JWT
- **Приоритет:** 🔴 Must Have
- **Story Points:** 5 SP
- **Зависимости:** BAK-009
- **Acceptance Criteria:**
  - [ ] Установлены: `@nestjs/jwt @nestjs/passport passport passport-jwt bcrypt`
  - [ ] JwtModule настроен
  - [ ] JwtStrategy создан
  - [ ] JwtAuthGuard создан
  - [ ] Работает декоратор @UseGuards(JwtAuthGuard)
- **Статус:** 🔴 Not Started

---

#### BAK-102: POST /api/v1/auth/register
- **Описание:** Регистрация нового пользователя
- **Приоритет:** 🔴 Must Have
- **Story Points:** 5 SP
- **Зависимости:** BAK-101
- **Acceptance Criteria:**
  - [ ] Endpoint принимает: email, password, first_name, last_name, phone
  - [ ] Email валидируется (формат + уникальность)
  - [ ] Пароль хэшируется bcrypt (10 rounds)
  - [ ] Пользователь создаётся в БД
  - [ ] Возвращается: user object + access_token + refresh_token
  - [ ] Пароль НЕ возвращается в ответе
  - [ ] Email верификация (mock для MVP)
- **Тест-кейс:** TC-030
- **Статус:** 🔴 Not Started

---

#### BAK-103: POST /api/v1/auth/login
- **Описание:** Вход пользователя
- **Приоритет:** 🔴 Must Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-102
- **Acceptance Criteria:**
  - [ ] Endpoint принимает: email, password
  - [ ] Проверка пароля через bcrypt.compare()
  - [ ] Возвращается: user + access_token + refresh_token
  - [ ] 401 если credentials неверные
  - [ ] Rate limiting: 5 попыток / 15 минут
- **Тест-кейс:** TC-032, TC-033
- **Статус:** 🔴 Not Started

---

#### BAK-104: POST /api/v1/auth/refresh
- **Описание:** Обновление access token
- **Приоритет:** 🔴 Must Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-103
- **Acceptance Criteria:**
  - [ ] Endpoint принимает: refresh_token
  - [ ] Валидирует refresh_token
  - [ ] Возвращает новый: access_token + refresh_token
  - [ ] Старый refresh_token инвалидируется
  - [ ] Rotation refresh tokens
- **Тест-кейс:** TC-034
- **Статус:** 🔴 Not Started

---

#### BAK-105: POST /api/v1/auth/logout
- **Описание:** Выход из системы
- **Приоритет:** 🟠 Should Have
- **Story Points:** 2 SP
- **Зависимости:** BAK-103
- **Acceptance Criteria:**
  - [ ] Endpoint требует JWT
  - [ ] Access token добавляется в blacklist (Redis)
  - [ ] Refresh token удаляется из БД
  - [ ] Возвращает 200 OK
- **Тест-кейс:** TC-035
- **Статус:** 🔴 Not Started

---

#### BAK-106: POST /api/v1/auth/forgot-password
- **Описание:** Сброс пароля
- **Приоритет:** 🟡 Could Have
- **Story Points:** 5 SP
- **Зависимости:** BAK-102
- **Acceptance Criteria:**
  - [ ] Endpoint принимает: email
  - [ ] Генерирует reset token (UUID)
  - [ ] Сохраняет token в БД с expiration (1 час)
  - [ ] Отправляет email с ссылкой (mock для MVP)
  - [ ] Rate limiting: 3 запроса / час
- **Статус:** 🔴 Not Started

---

#### BAK-107: POST /api/v1/auth/reset-password
- **Описание:** Установка нового пароля
- **Приоритет:** 🟡 Could Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-106
- **Acceptance Criteria:**
  - [ ] Endpoint принимает: token, new_password
  - [ ] Валидирует token (не истёк, существует)
  - [ ] Обновляет пароль (bcrypt hash)
  - [ ] Инвалидирует token
  - [ ] Возвращает 200 OK
- **Статус:** 🔴 Not Started

---

#### BAK-108: GET /api/v1/users/me
- **Описание:** Получить профиль текущего пользователя
- **Приоритет:** 🔴 Must Have
- **Story Points:** 2 SP
- **Зависимости:** BAK-101
- **Acceptance Criteria:**
  - [ ] Требует JWT (@UseGuards(JwtAuthGuard))
  - [ ] Возвращает user object
  - [ ] Поле password_hash НЕ возвращается
  - [ ] Включает: id, email, first_name, last_name, phone, avatar_url, role
- **Тест-кейс:** TC-036
- **Статус:** 🔴 Not Started

---

#### BAK-109: PATCH /api/v1/users/me
- **Описание:** Обновление профиля
- **Приоритет:** 🔴 Must Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-108
- **Acceptance Criteria:**
  - [ ] Требует JWT
  - [ ] Можно обновить: first_name, last_name, phone, bio, location
  - [ ] Email изменить нельзя (или требует reverification)
  - [ ] Валидация полей
  - [ ] Возвращает обновлённый user object
- **Тест-кейс:** TC-037
- **Статус:** 🔴 Not Started

---

#### BAK-110: POST /api/v1/users/me/avatar
- **Описание:** Загрузка аватара
- **Приоритет:** 🟠 Should Have
- **Story Points:** 5 SP
- **Зависимости:** BAK-108, MinIO
- **Acceptance Criteria:**
  - [ ] Endpoint принимает multipart/form-data
  - [ ] Валидирует файл: image/jpeg, image/png, < 5MB
  - [ ] Загружает в MinIO bucket: avatars/
  - [ ] Генерирует уникальное имя: {user_id}-{timestamp}.jpg
  - [ ] Удаляет старый аватар (если был)
  - [ ] Сохраняет URL в user.avatar_url
  - [ ] Возвращает: { avatar_url: "https://..." }
- **Тест-кейс:** TC-038
- **Статус:** 🔴 Not Started

---

## EPIC 3: Backend Masters & Services 🔴

**Общая оценка:** 42 SP
**Зависимости:** Epic 2

### Задачи:

#### BAK-201: POST /api/v1/masters
- **Описание:** Создание профиля мастера
- **Приоритет:** 🔴 Must Have
- **Story Points:** 8 SP
- **Зависимости:** BAK-108
- **Acceptance Criteria:**
  - [ ] Требует JWT + role check (только client или master может создать)
  - [ ] Принимает:
    - business_name, category_id, subcategory_id
    - bio, location (lat, lon, address)
    - working_radius_km, currency
  - [ ] Создаёт запись в masters
  - [ ] Обновляет user.role = 'master'
  - [ ] Location сохраняется как PostGIS Point
  - [ ] Валидирует category_id существует
  - [ ] Возвращает master object
- **Тест-кейс:** TC-039
- **Статус:** 🔴 Not Started

---

#### BAK-202: GET /api/v1/masters/:id
- **Описание:** Получение профиля мастера
- **Приоритет:** 🔴 Must Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-201
- **Acceptance Criteria:**
  - [ ] Публичный endpoint (без JWT)
  - [ ] Возвращает:
    - master info (business_name, bio, location, etc.)
    - user info (first_name, avatar_url)
    - rating, reviews_count
    - services[] (список услуг)
    - portfolio[] (массив фото)
  - [ ] 404 если мастер не найден
- **Статус:** 🔴 Not Started

---

#### BAK-203: PATCH /api/v1/masters/me
- **Описание:** Обновление профиля мастера
- **Приоритет:** 🔴 Must Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-201
- **Acceptance Criteria:**
  - [ ] Требует JWT + role = 'master'
  - [ ] Можно обновить: business_name, bio, location, working_radius_km
  - [ ] Валидация полей
  - [ ] Возвращает обновлённый master object
- **Статус:** 🔴 Not Started

---

#### BAK-204: POST /api/v1/masters/me/services
- **Описание:** Добавление услуги
- **Приоритет:** 🔴 Must Have
- **Story Points:** 5 SP
- **Зависимости:** BAK-201
- **Acceptance Criteria:**
  - [ ] Требует JWT + role = 'master'
  - [ ] Принимает:
    - catalog_service_id (из справочника)
    - price, currency, duration_minutes
    - description (опционально)
  - [ ] Создаёт запись в master_services
  - [ ] Валидирует catalog_service_id существует
  - [ ] Возвращает service object
- **Тест-кейс:** TC-040
- **Статус:** 🔴 Not Started

---

#### BAK-205: GET /api/v1/masters/me/services
- **Описание:** Список услуг мастера
- **Приоритет:** 🔴 Must Have
- **Story Points:** 2 SP
- **Зависимости:** BAK-204
- **Acceptance Criteria:**
  - [ ] Требует JWT + role = 'master'
  - [ ] Возвращает массив услуг
  - [ ] Включает: id, service_name, price, duration, is_active
- **Статус:** 🔴 Not Started

---

#### BAK-206: PATCH /api/v1/masters/me/services/:id
- **Описание:** Обновление услуги
- **Приоритет:** 🟠 Should Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-204
- **Acceptance Criteria:**
  - [ ] Требует JWT + role = 'master'
  - [ ] Можно обновить: price, duration, description, is_active
  - [ ] Валидация ownership (услуга принадлежит текущему мастеру)
  - [ ] Возвращает обновлённый service
- **Статус:** 🔴 Not Started

---

#### BAK-207: DELETE /api/v1/masters/me/services/:id
- **Описание:** Удаление услуги
- **Приоритет:** 🟠 Should Have
- **Story Points:** 2 SP
- **Зависимости:** BAK-204
- **Acceptance Criteria:**
  - [ ] Требует JWT + role = 'master'
  - [ ] Soft delete (is_active = false)
  - [ ] Проверка: нет активных bookings
  - [ ] Возвращает 204 No Content
- **Статус:** 🔴 Not Started

---

#### BAK-208: POST /api/v1/masters/me/schedule
- **Описание:** Установка рабочего расписания
- **Приоритет:** 🔴 Must Have
- **Story Points:** 8 SP
- **Зависимости:** BAK-201
- **Acceptance Criteria:**
  - [ ] Требует JWT + role = 'master'
  - [ ] Принимает массив расписания:
    ```json
    {
      "schedule": [
        {
          "day_of_week": 1, // Monday
          "start_time": "09:00",
          "end_time": "18:00",
          "is_working": true
        },
        ...
      ]
    }
    ```
  - [ ] Создаёт/обновляет записи в master_schedule
  - [ ] Валидирует: start_time < end_time
  - [ ] Возвращает полное расписание
- **Статус:** 🔴 Not Started

---

#### BAK-209: GET /api/v1/masters/:id/schedule
- **Описание:** Получение расписания мастера
- **Приоритет:** 🔴 Must Have
- **Story Points:** 2 SP
- **Зависимости:** BAK-208
- **Acceptance Criteria:**
  - [ ] Публичный endpoint
  - [ ] Возвращает расписание на неделю
  - [ ] Формат: массив из 7 элементов (Пн-Вс)
- **Статус:** 🔴 Not Started

---

#### BAK-210: POST /api/v1/masters/me/portfolio
- **Описание:** Загрузка фото в портфолио
- **Приоритет:** 🟠 Should Have
- **Story Points:** 5 SP
- **Зависимости:** BAK-201, MinIO
- **Acceptance Criteria:**
  - [ ] Требует JWT + role = 'master'
  - [ ] Multipart upload (image)
  - [ ] Валидация: jpeg/png, < 10MB
  - [ ] Загрузка в MinIO: portfolio/{master_id}/
  - [ ] Создание записи в portfolio_items
  - [ ] Возвращает: { id, url, created_at }
- **Статус:** 🔴 Not Started

---

#### BAK-211: GET /api/v1/masters/:id/portfolio
- **Описание:** Получение портфолио
- **Приоритет:** 🟠 Should Have
- **Story Points:** 2 SP
- **Зависимости:** BAK-210
- **Acceptance Criteria:**
  - [ ] Публичный endpoint
  - [ ] Возвращает массив фото
  - [ ] Pagination: ?page=1&limit=20
  - [ ] Сортировка по дате (новые первые)
- **Статус:** 🔴 Not Started

---

## EPIC 4: Backend Bookings 🔴

**Общая оценка:** 55 SP
**Зависимости:** Epic 3

### Задачи:

#### BAK-301: POST /api/v1/bookings
- **Описание:** Создание записи
- **Приоритет:** 🔴 Must Have
- **Story Points:** 13 SP
- **Зависимости:** BAK-201, BAK-204
- **Acceptance Criteria:**
  - [ ] Требует JWT + role = 'client'
  - [ ] Принимает:
    - master_id, service_id
    - start_time (ISO 8601)
    - notes (optional)
  - [ ] Валидирует:
    - Мастер существует и активен
    - Услуга принадлежит мастеру
    - Слот доступен (нет пересечений)
    - Время в рабочих часах мастера
  - [ ] Рассчитывает end_time на основе duration
  - [ ] Рассчитывает total_price
  - [ ] Создаёт booking со статусом 'pending'
  - [ ] Отправляет уведомление мастеру
  - [ ] Возвращает booking object
- **Тест-кейс:** TC-042
- **Статус:** 🔴 Not Started

---

#### BAK-302: GET /api/v1/bookings
- **Описание:** Список записей текущего пользователя
- **Приоритет:** 🔴 Must Have
- **Story Points:** 5 SP
- **Зависимости:** BAK-301
- **Acceptance Criteria:**
  - [ ] Требует JWT
  - [ ] Для клиента: bookings где client_id = user.id
  - [ ] Для мастера: bookings где master_id = user.master_id
  - [ ] Фильтры: ?status=pending,confirmed&from=2025-01-01
  - [ ] Pagination: ?page=1&limit=20
  - [ ] Сортировка: по start_time (upcoming first)
  - [ ] Включает: master info, service info
- **Статус:** 🔴 Not Started

---

#### BAK-303: GET /api/v1/bookings/:id
- **Описание:** Детали записи
- **Приоритет:** 🔴 Must Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-301
- **Acceptance Criteria:**
  - [ ] Требует JWT
  - [ ] Проверка ownership (client или master)
  - [ ] Возвращает полный booking object:
    - booking details
    - master info
    - client info (имя, аватар)
    - service info
  - [ ] 403 если не владелец
  - [ ] 404 если не найден
- **Статус:** 🔴 Not Started

---

#### BAK-304: GET /api/v1/masters/:id/slots
- **Описание:** Доступные слоты для записи
- **Приоритет:** 🔴 Must Have
- **Story Points:** 13 SP
- **Зависимости:** BAK-208, BAK-301
- **Acceptance Criteria:**
  - [ ] Публичный endpoint (или требует JWT)
  - [ ] Query params: ?date=2025-01-15&service_id=uuid
  - [ ] Получает расписание мастера на дату
  - [ ] Получает все существующие bookings
  - [ ] Рассчитывает свободные слоты с интервалом 30 мин
  - [ ] Учитывает duration услуги
  - [ ] Возвращает:
    ```json
    {
      "date": "2025-01-15",
      "slots": [
        { "start": "09:00", "end": "09:30", "available": true },
        { "start": "09:30", "end": "10:00", "available": false },
        ...
      ]
    }
    ```
- **Тест-кейс:** TC-043
- **Статус:** 🔴 Not Started

---

#### BAK-305: PATCH /api/v1/bookings/:id/status
- **Описание:** Изменение статуса записи
- **Приоритет:** 🔴 Must Have
- **Story Points:** 8 SP
- **Зависимости:** BAK-301
- **Acceptance Criteria:**
  - [ ] Требует JWT
  - [ ] State machine для статусов:
    - pending → confirmed (мастер)
    - pending → cancelled_by_master (мастер)
    - confirmed → in_progress (мастер)
    - in_progress → completed (мастер)
    - confirmed → no_show (мастер)
  - [ ] Проверка прав (только мастер может менять статус)
  - [ ] Отправка уведомления клиенту
  - [ ] Логирование изменений
  - [ ] Возвращает обновлённый booking
- **Статус:** 🔴 Not Started

---

#### BAK-306: DELETE /api/v1/bookings/:id
- **Описание:** Отмена записи клиентом
- **Приоритет:** 🔴 Must Have
- **Story Points:** 5 SP
- **Зависимости:** BAK-301
- **Acceptance Criteria:**
  - [ ] Требует JWT + client ownership
  - [ ] Принимает: { cancellation_reason }
  - [ ] Меняет status на 'cancelled_by_client'
  - [ ] Устанавливает cancelled_at = NOW()
  - [ ] Сохраняет cancellation_reason
  - [ ] Отправляет уведомление мастеру
  - [ ] Проверка: можно отменить только pending/confirmed
  - [ ] Проверка: не позже чем за 2 часа до start_time
  - [ ] Возвращает 200 OK
- **Тест-кейс:** TC-044
- **Статус:** 🔴 Not Started

---

#### BAK-307: POST /api/v1/bookings/:id/reschedule
- **Описание:** Перенос записи
- **Приоритет:** 🟡 Could Have
- **Story Points:** 8 SP
- **Зависимости:** BAK-301, BAK-304
- **Acceptance Criteria:**
  - [ ] Требует JWT + client ownership
  - [ ] Принимает: { new_start_time }
  - [ ] Проверяет новый слот доступен
  - [ ] Обновляет start_time и end_time
  - [ ] Отправляет уведомление мастеру
  - [ ] Логирует изменение
  - [ ] Возвращает обновлённый booking
- **Статус:** 🔴 Not Started

---

## EPIC 5: Backend Search 🔴

**Общая оценка:** 34 SP
**Зависимости:** Epic 3

### Задачи:

#### BAK-401: GET /api/v1/search/masters - Гео-поиск
- **Описание:** Поиск мастеров по геолокации
- **Приоритет:** 🔴 Must Have
- **Story Points:** 13 SP
- **Зависимости:** BAK-201
- **Acceptance Criteria:**
  - [ ] Query params: ?lat=55.75&lon=37.61&radius=5
  - [ ] Использует PostGIS ST_DWithin для поиска
  - [ ] Рассчитывает distance для каждого мастера
  - [ ] Фильтры:
    - ?category_id=uuid
    - ?min_rating=4.5
    - ?min_price=1000&max_price=5000
  - [ ] Сортировка: ?sort=distance,rating,price
  - [ ] Pagination: ?page=1&limit=20
  - [ ] Возвращает:
    ```json
    {
      "total": 45,
      "page": 1,
      "limit": 20,
      "data": [
        {
          "id": "uuid",
          "business_name": "Salon X",
          "rating": 4.8,
          "reviews_count": 234,
          "distance_km": 2.3,
          "avatar_url": "...",
          "services": [...],
          "location": { "lat": 55.75, "lon": 37.61 }
        },
        ...
      ]
    }
    ```
- **Тест-кейс:** TC-041
- **Статус:** 🔴 Not Started

---

#### BAK-402: Meilisearch Integration
- **Описание:** Настроить текстовый поиск
- **Приоритет:** 🔴 Must Have
- **Story Points:** 8 SP
- **Зависимости:** BAK-201, Meilisearch
- **Acceptance Criteria:**
  - [ ] Установлен meilisearch SDK
  - [ ] Создан индекс 'masters'
  - [ ] Синхронизация данных при создании/обновлении мастера
  - [ ] Индексируются поля:
    - business_name, bio
    - category_name, subcategory_name
    - service_names
  - [ ] Настроены searchable attributes
  - [ ] Настроены filterable attributes
  - [ ] Typo tolerance включен
- **Статус:** 🔴 Not Started

---

#### BAK-403: GET /api/v1/search/masters - Текстовый поиск
- **Описание:** Поиск по ключевым словам
- **Приоритет:** 🔴 Must Have
- **Story Points:** 8 SP
- **Зависимости:** BAK-402
- **Acceptance Criteria:**
  - [ ] Query param: ?q=парикмахер
  - [ ] Поиск через Meilisearch
  - [ ] Комбинация с гео-фильтрами (если указаны lat/lon)
  - [ ] Ранжирование по релевантности
  - [ ] Highlighting совпадений
  - [ ] Pagination
  - [ ] Возвращает тот же формат что и BAK-401
- **Тест-кейс:** TC-045
- **Статус:** 🔴 Not Started

---

#### BAK-404: GET /api/v1/categories
- **Описание:** Список категорий
- **Приоритет:** 🔴 Must Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-006 (seed)
- **Acceptance Criteria:**
  - [ ] Публичный endpoint
  - [ ] Возвращает все категории
  - [ ] Включает subcategories
  - [ ] i18n поддержка: ?lang=en,ru,de,es,fr
  - [ ] Кэширование в Redis (1 час)
- **Статус:** 🔴 Not Started

---

#### BAK-405: GET /api/v1/categories/:id/services
- **Описание:** Услуги по категории
- **Приоритет:** 🟠 Should Have
- **Story Points:** 2 SP
- **Зависимости:** BAK-404
- **Acceptance Criteria:**
  - [ ] Публичный endpoint
  - [ ] Возвращает catalog_services для категории
  - [ ] i18n поддержка
  - [ ] Кэширование
- **Статус:** 🔴 Not Started

---

## EPIC 6: Flutter Integration 🔴

**Общая оценка:** 55 SP
**Зависимости:** Epic 2, 3, 4, 5

### Задачи:

#### FLT-001: Установка зависимостей
- **Описание:** Добавить необходимые пакеты
- **Приоритет:** 🔴 Must Have
- **Story Points:** 2 SP
- **Зависимости:** Нет
- **Acceptance Criteria:**
  - [ ] Установлены пакеты:
    ```yaml
    dependencies:
      dio: ^5.4.0
      flutter_riverpod: ^2.4.9
      freezed_annotation: ^2.4.1
      json_annotation: ^4.8.1
      flutter_secure_storage: ^9.0.0
      logger: ^2.0.2

    dev_dependencies:
      build_runner: ^2.4.7
      freezed: ^2.4.6
      json_serializable: ^6.7.1
    ```
  - [ ] `flutter pub get` выполнен успешно
- **Статус:** 🔴 Not Started

---

#### FLT-002: Создание API Client (Dio)
- **Описание:** Настроить HTTP client
- **Приоритет:** 🔴 Must Have
- **Story Points:** 8 SP
- **Зависимости:** FLT-001
- **Acceptance Criteria:**
  - [ ] Создан `lib/data/api/api_client.dart`
  - [ ] Dio instance с:
    - baseURL (dev: localhost:3000/api/v1)
    - timeout: 30s
    - headers: Content-Type, Accept
  - [ ] Interceptor для логирования
  - [ ] Interceptor для JWT (добавляет Authorization header)
  - [ ] Interceptor для refresh token (401 → refresh → retry)
  - [ ] Error handling interceptor
- **Пример:**
  ```dart
  class ApiClient {
    final Dio _dio;

    ApiClient() : _dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:3000/api/v1',
        connectTimeout: Duration(seconds: 30),
      ),
    ) {
      _dio.interceptors.add(JwtInterceptor());
      _dio.interceptors.add(LogInterceptor());
    }
  }
  ```
- **Статус:** 🔴 Not Started

---

#### FLT-003: Token Storage (Secure Storage)
- **Описание:** Безопасное хранение токенов
- **Приоритет:** 🔴 Must Have
- **Story Points:** 3 SP
- **Зависимости:** FLT-001
- **Acceptance Criteria:**
  - [ ] Создан `lib/data/storage/token_storage.dart`
  - [ ] Методы:
    - `saveAccessToken(String token)`
    - `saveRefreshToken(String token)`
    - `getAccessToken()`
    - `getRefreshToken()`
    - `deleteTokens()`
  - [ ] Используется FlutterSecureStorage
  - [ ] Токены шифруются на устройстве
- **Статус:** 🔴 Not Started

---

#### FLT-004: Data Models с Freezed
- **Описание:** Создать модели данных
- **Приоритет:** 🔴 Must Have
- **Story Points:** 8 SP
- **Зависимости:** FLT-001
- **Acceptance Criteria:**
  - [ ] Созданы модели:
    - User, Master, Service, Booking
    - Review, Category, SearchResult
  - [ ] Использован Freezed для immutability
  - [ ] JSON serialization через json_serializable
  - [ ] copyWith, ==, hashCode генерируются автоматически
  - [ ] `build_runner` генерирует `.g.dart` и `.freezed.dart`
- **Пример:**
  ```dart
  @freezed
  class User with _$User {
    const factory User({
      required String id,
      required String email,
      required String firstName,
      required String lastName,
      String? phone,
      String? avatarUrl,
      required String role,
    }) = _User;

    factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  }
  ```
- **Статус:** 🔴 Not Started

---

#### FLT-005: Repositories Layer
- **Описание:** Создать репозитории для API
- **Приоритет:** 🔴 Must Have
- **Story Points:** 13 SP
- **Зависимости:** FLT-002, FLT-004
- **Acceptance Criteria:**
  - [ ] Созданы репозитории:
    - AuthRepository
    - UserRepository
    - MasterRepository
    - BookingRepository
    - SearchRepository
  - [ ] Каждый репозиторий инкапсулирует API calls
  - [ ] Обработка ошибок
  - [ ] Преобразование Response → Models
- **Пример:**
  ```dart
  class AuthRepository {
    final ApiClient _apiClient;

    Future<AuthResponse> register({
      required String email,
      required String password,
      required String firstName,
      required String lastName,
      required String phone,
    }) async {
      final response = await _apiClient.post('/auth/register', data: {
        'email': email,
        'password': password,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone,
      });
      return AuthResponse.fromJson(response.data);
    }
  }
  ```
- **Статус:** 🔴 Not Started

---

#### FLT-006: Riverpod Providers - Auth
- **Описание:** State management для аутентификации
- **Приоритет:** 🔴 Must Have
- **Story Points:** 8 SP
- **Зависимости:** FLT-005
- **Acceptance Criteria:**
  - [ ] Создан `lib/features/auth/providers/auth_provider.dart`
  - [ ] StateNotifier для auth state:
    ```dart
    @freezed
    class AuthState with _$AuthState {
      const factory AuthState.initial() = _Initial;
      const factory AuthState.loading() = _Loading;
      const factory AuthState.authenticated(User user) = _Authenticated;
      const factory AuthState.unauthenticated() = _Unauthenticated;
      const factory AuthState.error(String message) = _Error;
    }
    ```
  - [ ] Методы: login(), register(), logout(), checkAuth()
  - [ ] Автоматическая проверка токена при старте
  - [ ] Persist auth state
- **Статус:** 🔴 Not Started

---

#### FLT-007: Riverpod Providers - User
- **Описание:** State management для пользователя
- **Приоритет:** 🔴 Must Have
- **Story Points:** 5 SP
- **Зависимости:** FLT-006
- **Acceptance Criteria:**
  - [ ] Provider для текущего пользователя
  - [ ] Методы: getProfile(), updateProfile(), uploadAvatar()
  - [ ] Кэширование профиля
  - [ ] Автоматическое обновление при изменениях
- **Статус:** 🔴 Not Started

---

#### FLT-008: Riverpod Providers - Masters & Search
- **Описание:** State management для поиска
- **Приоритет:** 🔴 Must Have
- **Story Points:** 8 SP
- **Зависимости:** FLT-005
- **Acceptance Criteria:**
  - [ ] Provider для списка мастеров
  - [ ] Provider для фильтров поиска
  - [ ] Provider для geo-location
  - [ ] Методы: searchMasters(), getMaster(), getSlots()
  - [ ] Pagination support
  - [ ] Кэширование результатов
- **Статус:** 🔴 Not Started

---

#### FLT-009: Riverpod Providers - Bookings
- **Описание:** State management для записей
- **Приоритет:** 🔴 Must Have
- **Story Points:** 8 SP
- **Зависимости:** FLT-005
- **Acceptance Criteria:**
  - [ ] Provider для списка bookings
  - [ ] Методы: createBooking(), getBookings(), cancelBooking()
  - [ ] Фильтрация по статусу
  - [ ] Оптимистичные обновления
- **Статус:** 🔴 Not Started

---

#### FLT-010: Интеграция Login Screen
- **Описание:** Подключить API к экрану входа
- **Приоритет:** 🔴 Must Have
- **Story Points:** 5 SP
- **Зависимости:** FLT-006
- **Acceptance Criteria:**
  - [ ] Кнопка "Войти" вызывает login()
  - [ ] Показывается loading state
  - [ ] При успехе → переход на Home
  - [ ] При ошибке → SnackBar с сообщением
  - [ ] Форма очищается после успеха
- **Статус:** 🔴 Not Started

---

#### FLT-011: Интеграция Register Screen
- **Описание:** Подключить API к регистрации
- **Приоритет:** 🔴 Must Have
- **Story Points:** 5 SP
- **Зависимости:** FLT-006
- **Acceptance Criteria:**
  - [ ] Кнопка "Зарегистрироваться" вызывает register()
  - [ ] Loading state
  - [ ] При успехе → переход на Home (автоматический вход)
  - [ ] Ошибки отображаются под полями
- **Статус:** 🔴 Not Started

---

#### FLT-012: Интеграция Home Screen
- **Описание:** Загрузка мастеров на главной
- **Приоритет:** 🔴 Must Have
- **Story Points:** 8 SP
- **Зависимости:** FLT-008
- **Acceptance Criteria:**
  - [ ] При загрузке → skeleton screens
  - [ ] Запрос мастеров "рядом" (по geo)
  - [ ] Отображение реальных данных вместо mock
  - [ ] Pull-to-refresh
  - [ ] Обработка ошибок
- **Статус:** 🔴 Not Started

---

#### FLT-013: Интеграция Search Screen
- **Описание:** Поиск с фильтрами
- **Приоритет:** 🔴 Must Have
- **Story Points:** 8 SP
- **Зависимости:** FLT-008
- **Acceptance Criteria:**
  - [ ] Текстовый поиск работает
  - [ ] Фильтры применяются
  - [ ] Результаты обновляются динамически
  - [ ] Pagination (infinite scroll)
  - [ ] Empty state если ничего не найдено
- **Статус:** 🔴 Not Started

---

#### FLT-014: Интеграция Master Profile Screen
- **Описание:** Загрузка профиля мастера
- **Приоритет:** 🔴 Must Have
- **Story Points:** 8 SP
- **Зависимости:** FLT-008
- **Acceptance Criteria:**
  - [ ] Загрузка данных по master_id
  - [ ] Отображение портфолио (real images)
  - [ ] Отображение услуг с ценами
  - [ ] Отображение отзывов
  - [ ] Кнопка "Записаться" активна
- **Статус:** 🔴 Not Started

---

#### FLT-015: Интеграция Booking Flow
- **Описание:** Создание записи
- **Приоритет:** 🔴 Must Have
- **Story Points:** 13 SP
- **Зависимости:** FLT-009, FLT-014
- **Acceptance Criteria:**
  - [ ] Выбор услуги → переход на экран выбора даты/времени
  - [ ] Загрузка доступных слотов
  - [ ] Отображение календаря с доступными датами
  - [ ] Выбор времени
  - [ ] Подтверждение → создание booking
  - [ ] Переход на экран успеха
  - [ ] Обновление списка "Мои записи"
- **Статус:** 🔴 Not Started

---

#### FLT-016: Интеграция Bookings Screen
- **Описание:** Список записей пользователя
- **Приоритет:** 🔴 Must Have
- **Story Points:** 5 SP
- **Зависимости:** FLT-009
- **Acceptance Criteria:**
  - [ ] Загрузка реальных bookings
  - [ ] Вкладки: Активные / Завершённые / Отменённые
  - [ ] Фильтрация работает
  - [ ] Отображение деталей каждой записи
  - [ ] Кнопка "Отменить" (для активных)
- **Статус:** 🔴 Not Started

---

#### FLT-017: Error Handling & Loading States
- **Описание:** Глобальная обработка ошибок
- **Приоритет:** 🔴 Must Have
- **Story Points:** 8 SP
- **Зависимости:** FLT-002
- **Acceptance Criteria:**
  - [ ] Skeleton screens для всех списков
  - [ ] Loading indicators для кнопок
  - [ ] SnackBar для ошибок API
  - [ ] Retry механизм при сетевых ошибках
  - [ ] Offline mode detection
  - [ ] Error boundary для критических ошибок
- **Статус:** 🔴 Not Started

---

## EPIC 7: Testing 🟠

**Общая оценка:** 42 SP
**Зависимости:** Epic 1-6

### Задачи:

#### TST-001: Backend Unit Tests - Auth
- **Описание:** Тесты для Auth module
- **Приоритет:** 🟠 Should Have
- **Story Points:** 8 SP
- **Зависимости:** Epic 2
- **Acceptance Criteria:**
  - [ ] Тесты для AuthService:
    - register() - success, duplicate email
    - login() - success, wrong password, wrong email
    - refresh() - success, invalid token
  - [ ] Тесты для JwtStrategy
  - [ ] Coverage > 80%
- **Файл:** `backend/src/auth/auth.service.spec.ts`
- **Статус:** 🔴 Not Started

---

#### TST-002: Backend Unit Tests - Users
- **Описание:** Тесты для Users module
- **Приоритет:** 🟠 Should Have
- **Story Points:** 5 SP
- **Зависимости:** Epic 2
- **Acceptance Criteria:**
  - [ ] Тесты для UsersService
  - [ ] Тесты для profile update
  - [ ] Тесты для avatar upload
  - [ ] Coverage > 80%
- **Статус:** 🔴 Not Started

---

#### TST-003: Backend Unit Tests - Bookings
- **Описание:** Тесты для Bookings module
- **Приоритет:** 🟠 Should Have
- **Story Points:** 8 SP
- **Зависимости:** Epic 4
- **Acceptance Criteria:**
  - [ ] Тесты для создания booking
  - [ ] Тесты для валидации слотов
  - [ ] Тесты для state machine (статусы)
  - [ ] Тесты для расчёта available slots
  - [ ] Coverage > 80%
- **Статус:** 🔴 Not Started

---

#### TST-004: Backend Integration Tests
- **Описание:** E2E API тесты
- **Приоритет:** 🟠 Should Have
- **Story Points:** 13 SP
- **Зависимости:** Epic 2, 3, 4
- **Acceptance Criteria:**
  - [ ] Тесты для полных flow:
    - Register → Login → Get Profile
    - Create Master → Add Service → Search
    - Search Master → Create Booking → Check Bookings
  - [ ] Использование test database
  - [ ] Cleanup после тестов
  - [ ] 10+ critical scenarios
- **Файл:** `backend/test/integration/`
- **Статус:** 🔴 Not Started

---

#### TST-005: Flutter Unit Tests - Providers
- **Описание:** Тесты для Riverpod providers
- **Приоритет:** 🟠 Should Have
- **Story Points:** 8 SP
- **Зависимости:** Epic 6
- **Acceptance Criteria:**
  - [ ] Тесты для AuthProvider:
    - login, register, logout
    - state transitions
  - [ ] Тесты для BookingProvider
  - [ ] Тесты для SearchProvider
  - [ ] Моки для API calls
  - [ ] Coverage > 70%
- **Файл:** `frontend/test/providers/`
- **Статус:** 🔴 Not Started

---

#### TST-006: Flutter Widget Tests
- **Описание:** Тесты для UI компонентов
- **Приоритет:** 🟡 Could Have
- **Story Points:** 5 SP
- **Зависимости:** Epic 6
- **Acceptance Criteria:**
  - [ ] Тесты для Login Screen:
    - Валидация email/password
    - Кнопка disabled с невалидными данными
  - [ ] Тесты для MasterCard
  - [ ] Тесты для BookingCard
  - [ ] Golden tests для key screens
- **Файл:** `frontend/test/widgets/`
- **Статус:** 🔴 Not Started

---

#### TST-007: E2E Tests (Flutter Integration)
- **Описание:** Сквозные тесты
- **Приоритет:** 🟡 Could Have
- **Story Points:** 8 SP
- **Зависимости:** Epic 6
- **Acceptance Criteria:**
  - [ ] Тест: Регистрация → Home → Поиск → Booking
  - [ ] Тест: Login → Profile → Update
  - [ ] Тест: Search с фильтрами
  - [ ] Использование integration_test
  - [ ] 5+ critical scenarios
- **Файл:** `frontend/integration_test/`
- **Статус:** 🔴 Not Started

---

## EPIC 8: Backend Reviews & Content 🟠

**Общая оценка:** 34 SP
**Зависимости:** Epic 4

### Задачи:

#### BAK-501: POST /api/v1/reviews
- **Описание:** Создание отзыва
- **Приоритет:** 🟠 Should Have
- **Story Points:** 8 SP
- **Зависимости:** BAK-301
- **Acceptance Criteria:**
  - [ ] Требует JWT + role = 'client'
  - [ ] Принимает:
    - booking_id, rating (1-5), comment
  - [ ] Валидация:
    - Booking exists
    - Booking status = 'completed'
    - Client is booking owner
    - Отзыв ещё не оставлен
  - [ ] Создаёт review
  - [ ] Пересчитывает master.rating
  - [ ] Обновляет master.reviews_count
  - [ ] Возвращает review object
- **Статус:** 🔴 Not Started

---

#### BAK-502: GET /api/v1/masters/:id/reviews
- **Описание:** Список отзывов мастера
- **Приоритет:** 🟠 Should Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-501
- **Acceptance Criteria:**
  - [ ] Публичный endpoint
  - [ ] Pagination: ?page=1&limit=20
  - [ ] Сортировка: recent first
  - [ ] Включает: client info (name, avatar), rating, comment, date
  - [ ] Фильтр: ?rating=5 (только 5-звёздочные)
- **Статус:** 🔴 Not Started

---

#### BAK-503: POST /api/v1/content/posts
- **Описание:** Создание поста (фото/видео)
- **Приоритет:** 🟡 Could Have
- **Story Points:** 8 SP
- **Зависимости:** BAK-201, MinIO
- **Acceptance Criteria:**
  - [ ] Требует JWT + role = 'master'
  - [ ] Multipart upload: image или video
  - [ ] Валидация:
    - Фото: jpeg/png, < 10MB
    - Видео: mp4, < 50MB, < 60 sec
  - [ ] Загрузка в MinIO: posts/{master_id}/
  - [ ] Создание записи в content_posts
  - [ ] Caption (optional)
  - [ ] Возвращает post object
- **Статус:** 🔴 Not Started

---

#### BAK-504: GET /api/v1/feed
- **Описание:** Лента контента
- **Приоритет:** 🟡 Could Have
- **Story Points:** 13 SP
- **Зависимости:** BAK-503
- **Acceptance Criteria:**
  - [ ] Требует JWT
  - [ ] Показывает посты:
    - От мастеров, на которых подписан
    - Рекомендации (популярные)
  - [ ] Алгоритм ранжирования:
    - Recent posts первые
    - Engagement (likes, views)
  - [ ] Pagination (infinite scroll)
  - [ ] Prefetch video thumbnails
- **Статус:** 🔴 Not Started

---

#### BAK-505: POST /api/v1/masters/:id/follow
- **Описание:** Подписка на мастера
- **Приоритет:** 🟡 Could Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-201
- **Acceptance Criteria:**
  - [ ] Требует JWT
  - [ ] Создаёт запись в favorites (или отдельная таблица follows)
  - [ ] Инкрементирует master.followers_count
  - [ ] Отправляет уведомление мастеру
  - [ ] Idempotent (повторный follow игнорируется)
  - [ ] Возвращает 200 OK
- **Статус:** 🔴 Not Started

---

## EPIC 9: Real-time Features 🟡

**Общая оценка:** 34 SP
**Зависимости:** Epic 2

### Задачи:

#### BAK-601: WebSocket Gateway Setup
- **Описание:** Настроить WebSocket сервер
- **Приоритет:** 🟡 Could Have
- **Story Points:** 8 SP
- **Зависимости:** BAK-101
- **Acceptance Criteria:**
  - [ ] Установлен @nestjs/websockets
  - [ ] Создан ChatGateway
  - [ ] Authentication через JWT (в handshake)
  - [ ] Rooms для chat_rooms
  - [ ] Events:
    - message.send
    - message.received
    - typing.start
    - typing.stop
  - [ ] Подключение к Redis Pub/Sub (для масштабирования)
- **Статус:** 🔴 Not Started

---

#### BAK-602: POST /api/v1/chat/rooms
- **Описание:** Создание чата
- **Приоритет:** 🟡 Could Have
- **Story Points:** 5 SP
- **Зависимости:** BAK-301
- **Acceptance Criteria:**
  - [ ] Требует JWT
  - [ ] Принимает: master_id или client_id
  - [ ] Проверка: chat между этими пользователями не существует
  - [ ] Создаёт chat_room
  - [ ] Добавляет участников
  - [ ] Возвращает room_id
- **Статус:** 🔴 Not Started

---

#### BAK-603: POST /api/v1/chat/rooms/:id/messages
- **Описание:** Отправка сообщения
- **Приоритет:** 🟡 Could Have
- **Story Points:** 5 SP
- **Зависимости:** BAK-602
- **Acceptance Criteria:**
  - [ ] Требует JWT
  - [ ] Принимает: message_text
  - [ ] Проверка: user is member of room
  - [ ] Создаёт message в chat_messages
  - [ ] Отправляет WebSocket event получателю
  - [ ] Отправляет push notification (если offline)
  - [ ] Возвращает message object
- **Статус:** 🔴 Not Started

---

#### BAK-604: GET /api/v1/chat/rooms/:id/messages
- **Описание:** История чата
- **Приоритет:** 🟡 Could Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-603
- **Acceptance Criteria:**
  - [ ] Требует JWT
  - [ ] Проверка: user is member
  - [ ] Pagination: ?before=message_id&limit=50
  - [ ] Сортировка: latest first
  - [ ] Mark as read при загрузке
- **Статус:** 🔴 Not Started

---

#### BAK-605: Notifications System
- **Описание:** Система уведомлений
- **Приоритет:** 🟡 Could Have
- **Story Points:** 13 SP
- **Зависимости:** BAK-301
- **Acceptance Criteria:**
  - [ ] Создание notification при:
    - Новая запись (мастеру)
    - Подтверждение записи (клиенту)
    - Отмена записи
    - Новое сообщение в чате
    - Новый отзыв (мастеру)
  - [ ] WebSocket events для real-time
  - [ ] GET /api/v1/notifications (список)
  - [ ] PATCH /api/v1/notifications/:id/read
  - [ ] Push notifications (FCM) - опционально
- **Статус:** 🔴 Not Started

---

## EPIC 10: CI/CD & Deployment 🟠

**Общая оценка:** 21 SP
**Зависимости:** Epic 1, 2

### Задачи:

#### DEV-001: GitHub Actions - Backend CI
- **Описание:** Автоматические тесты backend
- **Приоритет:** 🟠 Should Have
- **Story Points:** 5 SP
- **Зависимости:** BAK-002
- **Acceptance Criteria:**
  - [ ] Создан `.github/workflows/backend-ci.yml`
  - [ ] Triggers: push, pull_request на main
  - [ ] Steps:
    - Checkout code
    - Setup Node.js
    - Install dependencies
    - Run linter (ESLint)
    - Run tests (Jest)
    - Generate coverage report
  - [ ] Fail build если coverage < 75%
  - [ ] Badge в README
- **Статус:** 🔴 Not Started

---

#### DEV-002: GitHub Actions - Flutter CI
- **Описание:** Автоматические тесты Flutter
- **Приоритет:** 🟠 Should Have
- **Story Points:** 5 SP
- **Зависимости:** FLT-001
- **Acceptance Criteria:**
  - [ ] Создан `.github/workflows/flutter-ci.yml`
  - [ ] Triggers: push, pull_request на main
  - [ ] Steps:
    - Checkout code
    - Setup Flutter
    - flutter pub get
    - flutter analyze
    - flutter test
    - Generate coverage
  - [ ] Fail если coverage < 70%
- **Статус:** 🔴 Not Started

---

#### DEV-003: Docker Build для Backend
- **Описание:** Dockerfile для production
- **Приоритет:** 🟠 Should Have
- **Story Points:** 3 SP
- **Зависимости:** BAK-002
- **Acceptance Criteria:**
  - [ ] Создан `backend/Dockerfile`
  - [ ] Multi-stage build (builder + runtime)
  - [ ] Оптимизирован размер image
  - [ ] Health check endpoint
  - [ ] Non-root user
- **Статус:** 🔴 Not Started

---

#### DEV-004: Staging Environment
- **Описание:** Deploy на staging сервер
- **Приоритет:** 🟡 Could Have
- **Story Points:** 8 SP
- **Зависимости:** DEV-003
- **Acceptance Criteria:**
  - [ ] VPS сервер настроен (DigitalOcean/AWS/Hetzner)
  - [ ] Docker compose для prod
  - [ ] Nginx reverse proxy
  - [ ] SSL сертификаты (Let's Encrypt)
  - [ ] Domain: staging-api.service.com
  - [ ] Auto-deploy on merge to develop branch
  - [ ] Database backups (daily)
- **Статус:** 🔴 Not Started

---

#### DEV-005: Monitoring & Logging
- **Описание:** Мониторинг production
- **Приоритет:** 🟡 Could Have
- **Story Points:** 5 SP
- **Зависимости:** DEV-004
- **Acceptance Criteria:**
  - [ ] Sentry для error tracking
  - [ ] Grafana + Prometheus для метрик
  - [ ] Loki для логов
  - [ ] Alerts в Telegram/Slack
  - [ ] Dashboard с key metrics:
    - API response time
    - Error rate
    - Active users
    - Database connections
- **Статус:** 🔴 Not Started

---

## Sprint Planning

### Sprint 1 (Weeks 1-2): Backend Foundation

**Цель:** Запустить базовый backend с auth

**Story Points:** 50 SP

**Задачи:**
- BAK-001 до BAK-012 (Epic 1: Infrastructure) - 55 SP
- Сократить scope:
  - BAK-011 (Logging) → отложить
  - BAK-012 (Error Handling) → упростить

**Deliverables:**
- [ ] Backend проект инициализирован
- [ ] Database схема создана и применена
- [ ] Seed данные загружены
- [ ] Swagger документация доступна
- [ ] Docker-compose инфраструктура запущена

**Definition of Done:**
- Все acceptance criteria выполнены
- Код ревьюнут
- Документация обновлена
- Backend запускается без ошибок

---

### Sprint 2 (Weeks 3-4): Authentication & Users

**Цель:** Реализовать полную аутентификацию

**Story Points:** 45 SP

**Задачи:**
- BAK-101 до BAK-110 (Epic 2: Auth & Users) - 34 SP
- Начать BAK-201 до BAK-203 (Epic 3: Masters) - 11 SP

**Deliverables:**
- [ ] Register, Login, Refresh endpoints
- [ ] JWT authentication работает
- [ ] Profile endpoints (get, update, avatar)
- [ ] Начат Masters module

**Testing:**
- Unit tests для Auth (coverage > 80%)
- Manual testing через Postman/Swagger

---

### Sprint 3 (Weeks 5-6): Masters & Services

**Цель:** Профили мастеров и управление услугами

**Story Points:** 42 SP

**Задачи:**
- Завершить Epic 3: Masters (BAK-201 до BAK-211)

**Deliverables:**
- [ ] CRUD для профилей мастеров
- [ ] Управление услугами
- [ ] Расписание мастера
- [ ] Портфолио upload

**Testing:**
- Unit tests для Masters
- Integration tests (Auth + Masters)

---

### Sprint 4 (Weeks 7-8): Bookings System

**Цель:** Система бронирования

**Story Points:** 55 SP

**Задачи:**
- Epic 4: Bookings (BAK-301 до BAK-307)

**Deliverables:**
- [ ] Создание записи
- [ ] Расчёт доступных слотов
- [ ] Управление статусами
- [ ] Отмена/перенос

**Testing:**
- Unit tests для Bookings (critical)
- Integration tests (full booking flow)

---

### Sprint 5 (Weeks 9-10): Search & Flutter Integration Start

**Цель:** Поиск мастеров + начало интеграции

**Story Points:** 48 SP

**Задачи:**
- Epic 5: Search (BAK-401 до BAK-405) - 34 SP
- Начать Epic 6: Flutter (FLT-001 до FLT-005) - 34 SP → взять 14 SP

**Deliverables:**
- [ ] Гео-поиск работает
- [ ] Текстовый поиск через Meilisearch
- [ ] Flutter: API client настроен
- [ ] Flutter: Models созданы

---

### Sprint 6 (Weeks 11-12): Flutter Integration

**Цель:** Подключить все основные экраны

**Story Points:** 55 SP

**Задачи:**
- Завершить Epic 6: Flutter Integration (FLT-006 до FLT-017)

**Deliverables:**
- [ ] Все providers настроены
- [ ] Auth screens интегрированы
- [ ] Home, Search интегрированы
- [ ] Master Profile интегрирован
- [ ] Booking flow работает

**Testing:**
- Manual testing всех flows
- Начать widget tests

---

### Sprint 7 (Weeks 13-14): Testing & Polish

**Цель:** Тестирование и доработка

**Story Points:** 42 SP

**Задачи:**
- Epic 7: Testing (TST-001 до TST-007)
- Bug fixes
- Performance optimization

**Deliverables:**
- [ ] Backend unit tests (coverage > 80%)
- [ ] Backend integration tests
- [ ] Flutter unit tests (coverage > 70%)
- [ ] E2E tests (5+ scenarios)

---

### Sprint 8 (Weeks 15-16): Deployment & MVP Launch

**Цель:** Deploy и запуск MVP

**Story Points:** 35 SP

**Задачи:**
- Epic 10: CI/CD (DEV-001 до DEV-004)
- Final testing
- Production deployment

**Deliverables:**
- [ ] CI/CD pipelines работают
- [ ] Staging environment готов
- [ ] Production deployment
- [ ] Monitoring настроен
- [ ] MVP LAUNCHED! 🚀

---

## Definition of Done

### Для каждой задачи:

**Code:**
- [ ] Код написан и соответствует acceptance criteria
- [ ] Код следует style guide (ESLint/Dart analyzer)
- [ ] Нет TODO/FIXME комментариев
- [ ] Нет закомментированного кода

**Testing:**
- [ ] Unit tests написаны (если применимо)
- [ ] Tests проходят
- [ ] Coverage требования выполнены
- [ ] Manual testing выполнен

**Documentation:**
- [ ] README обновлён (если нужно)
- [ ] API документация обновлена (Swagger)
- [ ] Код задокументирован (JSDoc/DartDoc)

**Review:**
- [ ] Code review выполнен
- [ ] Комментарии ревью исправлены
- [ ] Approved by reviewer

**Integration:**
- [ ] Ветка merged в develop
- [ ] CI/CD pipeline прошёл
- [ ] No merge conflicts

---

## Метрики

### Velocity Tracking

| Sprint | Planned SP | Completed SP | Velocity | Notes |
|--------|-----------|--------------|----------|-------|
| S1 | 50 | - | - | Backend Foundation |
| S2 | 45 | - | - | Auth & Users |
| S3 | 42 | - | - | Masters & Services |
| S4 | 55 | - | - | Bookings |
| S5 | 48 | - | - | Search + Flutter start |
| S6 | 55 | - | - | Flutter Integration |
| S7 | 42 | - | - | Testing |
| S8 | 35 | - | - | Deployment |
| **Total** | **372 SP** | **-** | **-** | **16 weeks** |

### Burn-down Chart

Обновлять после каждого спринта:
- Total remaining SP
- Completed tasks
- Blocked tasks

### Quality Metrics

**Целевые значения:**

| Метрика | Цель | Текущее |
|---------|------|---------|
| Backend Test Coverage | > 80% | 0% |
| Flutter Test Coverage | > 70% | 0% |
| Critical Bugs | 0 | 0 |
| High Bugs | < 5 | 0 |
| API Response Time (p95) | < 200ms | - |
| Frontend FPS | 60 | - |

---

## Риски и Митигация

### Технические риски:

**1. Backend занимает больше времени чем планировалось**
- **Вероятность:** Высокая
- **Влияние:** Критическое (блокирует Flutter)
- **Митигация:**
  - Начать с Backend в Sprint 1-4
  - Упростить scope если нужно (убрать Could Have)
  - Привлечь дополнительного разработчика

**2. PostGIS гео-поиск сложнее чем ожидалось**
- **Вероятность:** Средняя
- **Влияние:** Среднее
- **Митигация:**
  - Изучить примеры до Sprint 5
  - Fallback: простой поиск по координатам без радиуса
  - Оптимизация позже

**3. Flutter integration проблемы**
- **Вероятность:** Средняя
- **Влияние:** Высокое
- **Митигация:**
  - Тщательное тестирование API через Postman
  - Хорошая документация API (Swagger)
  - Mock API для Flutter разработки параллельно

---

## Приоритизация при сокращении scope

Если нужно сократить scope для более быстрого MVP:

### Must Keep (нельзя убрать):
- Epic 1: Backend Infrastructure
- Epic 2: Auth & Users
- Epic 3: Masters & Services (основное)
- Epic 4: Bookings (основное)
- Epic 5: Search (гео + текст)
- Epic 6: Flutter Integration

### Can Remove (можно отложить):
- BAK-106, BAK-107: Forgot/Reset Password
- BAK-210, BAK-211: Portfolio upload (использовать только аватар)
- BAK-307: Reschedule booking
- Epic 8: Reviews (можно добавить после MVP)
- Epic 9: Chat & Real-time (можно добавить после MVP)
- Epic 7: Testing (минимальные тесты, расширить позже)
- DEV-005: Monitoring (базовый мониторинг сначала)

---

## Связанные документы

- [Roadmap](Roadmap.md) - Общая дорожная карта проекта
- [User Stories](../business/UserStories.md) - User stories для функций
- [TechSpec](../technical/TechSpec.md) - Техническая спецификация
- [TestCases](../testing/TestCases.md) - Детальные тест-кейсы
- [TestPlan](../testing/TestPlan.md) - План тестирования

---

**Статус:** ✅ Готов к работе
**Последнее обновление:** 22 декабря 2025
**Версия:** 1.0
**Автор:** Product Team Service Platform

---

**Следующие действия:**
1. Review бэклога с командой
2. Подтвердить приоритеты
3. Начать Sprint 1
4. Настроить tracking (Jira/GitHub Projects/Linear)
5. Weekly sync meetings
