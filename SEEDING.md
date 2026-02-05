# Database Seeding Guide

> **Примечание:** Устаревший SQL скрипт `seed-data.sql` был перемещен в `archive/scripts/`. Используйте TypeScript seed через `npm run seed`.

## Наполнение базы данных тестовыми данными

### Быстрый старт

1. **Запуск инфраструктуры:**
```bash
docker-compose up -d
```

2. **Очистка базы данных (при необходимости):**
```bash
docker exec service_postgres psql -U service_user -d service_db -c "TRUNCATE TABLE users, posts, post_media, subscriptions, master_profiles CASCADE;"
```

3. **Загрузка тестовых данных:**
```bash
cd backend
npm run seed
```

### Что будет создано

Seed создает следующие тестовые данные:

- **3 мастера** с профилями:
  - anna.master@test.com (Анна Иванова)
  - dmitry.master@test.com (Дмитрий Петров)
  - elena.master@test.com (Елена Смирнова)

- **3 студента/клиента**:
  - maria.student@test.com (Мария Козлова)
  - ivan.student@test.com (Иван Сидоров)
  - olga.student@test.com (Ольга Васильева)

- **6 постов** с медиа контентом
- **6 подписок** между пользователями

### Пароль для всех пользователей

```
test123
```

### MinIO интеграция

Seed автоматически:
- Скачивает тестовые аватары с placeholder-сервисов
- Загружает их в MinIO buckets (avatars, posts)
- Сохраняет MinIO URLs в базе данных

### Доступ к сервисам

- **Backend API**: http://localhost:3000
- **Swagger Docs**: http://localhost:3000/api
- **MinIO Console**: http://localhost:9002 (user: minio_access_key, password: minio_secret_key)
- **Adminer**: http://localhost:8080 (system: PostgreSQL, server: postgres, username: service_user, password: service_password, database: service_db)
- **MailHog**: http://localhost:8025

### Проверка данных

```bash
# Проверить пользователей
docker exec service_postgres psql -U service_user -d service_db -c "SELECT email, first_name, is_master FROM users;"

# Проверить файлы в MinIO
curl http://localhost:9000/avatars/

# Проверить посты
docker exec service_postgres psql -U service_user -d service_db -c "SELECT author_id, type, LEFT(content, 50) FROM posts;"
```

### Примечания

- Seed использует TypeScript (`backend/src/database/seeds/seed.cli.ts`)
- Аватары загружаются с `pravatar.cc` в MinIO bucket `avatars`
- Медиа постов используют `picsum.photos` (можно обновить для загрузки в MinIO)
- Все данные создаются с фиксированными email для удобства тестирования
- MinIO buckets создаются автоматически при запуске docker-compose
- Для загрузки локальных изображений используйте: `npm run upload-images`

### Дополнительные команды

```bash
# Загрузить локальные изображения из папки images/ в MinIO
npm run upload-images

# Заполнить только каталог категорий из Catalog.md
npm run seed:catalog

# Полный сброс БД (миграции + seed + загрузка изображений)
npm run db:reset:dev
```
