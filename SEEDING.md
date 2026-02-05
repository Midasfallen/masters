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

Текущий сид (`npm run seed` → `seed.cli.ts`) создаёт:

- **Каталог:** 10 категорий L0, 53 L1, 340 шаблонов услуг (при повторном запуске пересоздаётся).
- **Пользователи:** 10 случайных (faker) + **2 фиксированных тестовых:**
  - **master@test.com** (Тест Мастер) — мастер с профилем
  - **client@test.com** (Тест Клиент) — клиент
- **Остальное:** 5 мастеров и 5 клиентов со случайными email, 22+ услуг, бронирования, отзывы, **20 постов** (у части есть записи в `post_media` для типа PHOTO).

**Лента постов (GET /posts/feed) доступна только авторизованным пользователям.** Чтобы увидеть ленту после сида, войдите как **master@test.com** или **client@test.com**.

### Пароль для всех тестовых пользователей

```
qwerty123
```

(Все пользователи в сиде, включая фиксированных `master@test.com` и `client@test.com`, используют пароль `qwerty123`, который соответствует требованиям фронтенда: минимум 8 символов, буквы и цифры.)

### MinIO: посты и аватары

Сид сразу пишет в БД **корректные ссылки** на MinIO:

- **Посты:** `post_media.url` → `{MINIO_PUBLIC_URL}/posts/test-1.jpg` … `test-24.jpg` (циклически для PHOTO-постов).
- **Пользователи:** `users.avatar_url` → `{MINIO_PUBLIC_URL}/avatars/avatar-1.jpg` … `avatar-11.jpg` (циклически для 12 пользователей).

Чтобы картинки и аватары отображались, нужно один раз залить файлы в MinIO:

1. Положите изображения в две папки:
   - **`backend/src/database/seeds/test-images/posts/`** — до **24** файлов (JPG/PNG) → в MinIO появятся как `posts/test-1.jpg` … `test-24.jpg`.
   - **`backend/src/database/seeds/test-images/avatars/`** — до **11** файлов (JPG/PNG) → в MinIO как `avatars/avatar-1.jpg` … `avatar-11.jpg`.
2. Выполните:
   ```bash
   npm run upload-test-images
   ```

Скрипт загрузит оба набора в соответствующие бакеты MinIO. После этого при запуске сида ссылки в БД будут вести на эти файлы.

Для загрузки из своей папки с обновлением только постов можно по-прежнему использовать `npm run upload-images` (путь в `upload-local-images.ts`).

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

- Сид идемпотентен: повторный `npm run seed` очищает данные основного сида и каталог, затем создаёт всё заново.
- Фиксированные пользователи **master@test.com** и **client@test.com** (пароль **qwerty123**) всегда создаются для входа и проверки ленты.
- Эндпоинт **POST /auth/logout** доступен (200 OK); клиент сбрасывает токены локально.
- Подробный разбор проблемы «лента не грузится» и связь сидов с MinIO/API: [docs/analysis/FEED_AND_SEEDS_ANALYSIS.md](docs/analysis/FEED_AND_SEEDS_ANALYSIS.md).

### Дополнительные команды

```bash
# Загрузить тестовые изображения в MinIO (posts + avatars)
# Положите до 24 файлов в test-images/posts/ и до 11 в test-images/avatars/
npm run upload-test-images

# Загрузить свои изображения постов из произвольной папки (путь в upload-local-images.ts)
npm run upload-images

# Заполнить только каталог категорий из Catalog.md
npm run seed:catalog

# Полный сброс БД (миграции + seed)
npm run db:reset:dev
```
