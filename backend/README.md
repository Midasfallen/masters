# Service Platform Backend v2.0

Backend API для социальной платформы поиска мастеров.

## 🚀 Технологии

- **Node.js** 18+
- **NestJS** 10.x - прогрессивный Node.js фреймворк
- **TypeORM** 0.3.x - ORM для работы с PostgreSQL
- **PostgreSQL** 15+ - основная база данных
- **Redis** 7+ - кеширование и real-time
- **Swagger** - документация API
- **JWT** - аутентификация
- **MinIO** - хранилище файлов
- **Meilisearch** - поиск

## 📁 Структура проекта

```
backend/
├── src/
│   ├── modules/           # Функциональные модули
│   │   ├── auth/         # Аутентификация
│   │   ├── users/        # Пользователи
│   │   ├── masters/      # Мастера
│   │   ├── services/     # Услуги
│   │   ├── bookings/     # Бронирования
│   │   ├── posts/        # Посты (социальные)
│   │   ├── friends/      # Друзья/подписки
│   │   ├── chats/        # Чаты
│   │   └── ...
│   ├── common/           # Общие компоненты
│   │   ├── decorators/   # Декораторы
│   │   ├── dto/          # DTO классы
│   │   ├── filters/      # Exception filters
│   │   ├── guards/       # Guards
│   │   ├── interceptors/ # Interceptors
│   │   └── pipes/        # Pipes
│   ├── config/           # Конфигурация
│   ├── database/         # Миграции
│   ├── app.module.ts
│   └── main.ts
├── test/                 # E2E тесты
├── package.json
└── README.md
```

## 🛠 Установка

### Предварительные требования

- Node.js 18+ и npm
- PostgreSQL 15+
- Redis 7+
- Docker и Docker Compose (опционально)

### Шаг 1: Клонирование репозитория

```bash
git clone https://github.com/Midasfallen/masters.git
cd masters/backend
```

### Шаг 2: Установка зависимостей

```bash
npm install
```

### Шаг 3: Настройка окружения

Скопируйте `.env.example` в `.env` и настройте переменные:

```bash
cp .env.example .env
```

Отредактируйте `.env` файл:

```env
NODE_ENV=development
PORT=3000
DB_HOST=localhost
DB_PORT=5432
DB_USERNAME=postgres
DB_PASSWORD=your_password
DB_DATABASE=service_platform
JWT_SECRET=your-secret-key
```

### Шаг 4: Запуск базы данных (Docker)

Если используете Docker Compose:

```bash
cd ..
docker-compose up -d postgres redis minio meilisearch
```

### Шаг 5: Запуск миграций

```bash
npm run migration:run
```

### Шаг 6: Запуск приложения

```bash
# Development mode с hot reload
npm run start:dev

# Production mode
npm run build
npm run start:prod
```

Приложение будет доступно по адресу: http://localhost:3000

## 📚 API Документация

После запуска приложения документация Swagger доступна по адресу:

http://localhost:3000/api/v2/docs

## 🧪 Тестирование

```bash
# Unit тесты
npm run test

# E2E тесты
npm run test:e2e

# Покрытие тестами
npm run test:cov
```

## 📊 База данных

### Создание миграции

```bash
npm run migration:generate -- src/database/migrations/MigrationName
```

### Применение миграций

```bash
npm run migration:run
```

### Откат миграции

```bash
npm run migration:revert
```

## 🔧 Разработка

### Создание нового модуля

```bash
nest g module modules/module-name
nest g controller modules/module-name
nest g service modules/module-name
```

### Линтинг и форматирование

```bash
# Форматирование кода
npm run format

# Линтинг
npm run lint
```

## 🌍 Переменные окружения

Основные переменные окружения:

| Переменная | Описание | Значение по умолчанию |
|------------|----------|----------------------|
| `NODE_ENV` | Окружение | `development` |
| `PORT` | Порт приложения | `3000` |
| `DB_HOST` | Хост PostgreSQL | `localhost` |
| `DB_PORT` | Порт PostgreSQL | `5432` |
| `JWT_SECRET` | Секретный ключ JWT | - |
| `REDIS_HOST` | Хост Redis | `localhost` |
| `MINIO_ENDPOINT` | Endpoint MinIO | `localhost` |

Полный список в файле `.env.example`.

## 🚢 Деплой

### Production build

```bash
npm run build
npm run start:prod
```

### Docker

```bash
docker build -t service-platform-backend .
docker run -p 3000:3000 service-platform-backend
```

## 📖 API Endpoints

### Authentication
- `POST /api/v2/auth/register` - Регистрация
- `POST /api/v2/auth/login` - Вход
- `POST /api/v2/auth/refresh` - Обновление токена

### Users
- `GET /api/v2/users/me` - Текущий пользователь
- `PATCH /api/v2/users/me` - Обновление профиля
- `GET /api/v2/users/:id` - Профиль пользователя

### Masters
- `POST /api/v2/masters` - Создание профиля мастера
- `GET /api/v2/masters/:id` - Профиль мастера
- `PATCH /api/v2/masters/:id` - Обновление профиля

### Services
- `GET /api/v2/services` - Список услуг
- `POST /api/v2/services` - Создание услуги (мастер)
- `GET /api/v2/services/:id` - Детали услуги

### Bookings
- `POST /api/v2/bookings` - Создание записи
- `GET /api/v2/bookings` - Мои записи
- `PATCH /api/v2/bookings/:id` - Обновление записи

Полная документация: http://localhost:3000/api/v2/docs

## 🔐 Безопасность

- Все пароли хешируются с использованием bcrypt
- JWT токены для аутентификации
- Валидация входных данных (class-validator)
- CORS настроен
- Rate limiting (в планах)
- Helmet для HTTP заголовков безопасности (в планах)

## 📝 Лицензия

Proprietary - All rights reserved

## 👥 Команда

- **Backend Developer:** TBD
- **Project Owner:** Глеб

## 🔗 Связанные репозитории

- [Frontend (Flutter)](../frontend) - Flutter приложение
- [Документация](../docs) - Полная документация проекта

## 📞 Контакты

- GitHub: [Midasfallen/masters](https://github.com/Midasfallen/masters)

---

**Версия:** 2.0.0
**Последнее обновление:** 29 декабря 2025
