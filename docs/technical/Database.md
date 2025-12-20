# СХЕМА БАЗЫ ДАННЫХ - Платформа Service

**СУБД:** PostgreSQL 15+
**Версия:** 1.0
**Дата:** Декабрь 2025

---

## Обзор структуры

База данных состоит из **19 таблиц**, охватывающих:
- Пользователей и профили
- Каталог услуг
- Расписание и бронирование
- Контент и социальные функции
- Коммуникации и уведомления

---

## Список таблиц

| # | Таблица | Описание |
|---|---------|----------|
| 1 | `users` | Основная таблица пользователей (клиенты и мастера) |
| 2 | `master_profiles` | Профили мастеров (расширение users) |
| 3 | `categories` | Категории услуг (дерево) |
| 4 | `category_translations` | Переводы категорий |
| 5 | `services` | Услуги мастеров |
| 6 | `schedule_slots` | Расписание мастера |
| 7 | `schedule_exceptions` | Исключения в расписании (выходные, отпуск) |
| 8 | `bookings` | Записи клиентов |
| 9 | `reviews` | Отзывы (двусторонние) |
| 10 | `posts` | Посты мастеров (лента) |
| 11 | `post_media` | Медиафайлы постов |
| 12 | `likes` | Лайки постов |
| 13 | `comments` | Комментарии к постам |
| 14 | `subscriptions` | Подписки на мастеров |
| 15 | `blacklists` | Чёрные списки мастеров |
| 16 | `chats` | Чаты между пользователями |
| 17 | `messages` | Сообщения в чатах |
| 18 | `notifications` | Уведомления |
| 19 | `referrals` | Реферальная программа |

---

## 1. users - Пользователи

Основная таблица всех пользователей системы.

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `email` | VARCHAR(255) | Email (уникальный) |
| `phone` | VARCHAR(20) | Телефон |
| `password_hash` | VARCHAR(255) | Хэш пароля |
| `first_name` | VARCHAR(100) | Имя |
| `last_name` | VARCHAR(100) | Фамилия |
| `avatar_url` | TEXT | URL аватара |
| `role` | ENUM | client, master, admin |
| `is_verified` | BOOLEAN | KYC верификация |
| `is_premium` | BOOLEAN | Премиум статус |
| `premium_until` | TIMESTAMP | Дата окончания премиума |
| `rating` | DECIMAL(3,2) | Средний рейтинг |
| `reviews_count` | INTEGER | Количество отзывов |
| `cancellations_count` | INTEGER | Количество отмен |
| `no_shows_count` | INTEGER | Количество неявок |
| `blacklists_count` | INTEGER | В скольких ЧС состоит |
| `language` | VARCHAR(5) | Язык интерфейса |
| `timezone` | VARCHAR(50) | Часовой пояс |
| `last_location_lat` | DECIMAL(10,8) | Последняя широта |
| `last_location_lng` | DECIMAL(11,8) | Последняя долгота |
| `created_at` | TIMESTAMP | Дата создания |
| `updated_at` | TIMESTAMP | Дата обновления |

**Индексы:**
- UNIQUE на `email`
- UNIQUE на `phone`
- INDEX на `role`
- GIST на `(last_location_lat, last_location_lng)`

---

## 2. master_profiles - Профили мастеров

Расширенная информация для мастеров.

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `user_id` FK | UUID | Связь с пользователем → users.id |
| `display_name` | VARCHAR(100) | Отображаемое имя |
| `bio` | TEXT | Описание мастера |
| `base_location_lat` | DECIMAL(10,8) | Базовая локация: широта |
| `base_location_lng` | DECIMAL(11,8) | Базовая локация: долгота |
| `base_address` | TEXT | Адрес базовой локации |
| `city` | VARCHAR(100) | Город |
| `country` | VARCHAR(100) | Страна |
| `travel_radius_km` | INTEGER | Радиус выезда (км) |
| `travel_fee_fixed` | DECIMAL(10,2) | Фикс. доплата за выезд |
| `travel_fee_per_km` | DECIMAL(10,2) | Доплата за км |
| `accepts_cash` | BOOLEAN | Принимает наличные |
| `accepts_card` | BOOLEAN | Принимает карты |
| `accepts_prepay` | BOOLEAN | Требует предоплату |
| `currencies` | VARCHAR[] | Принимаемые валюты |
| `views_count` | INTEGER | Просмотры профиля |
| `subscribers_count` | INTEGER | Подписчики |

**Индексы:**
- UNIQUE на `user_id`
- GIST на `(base_location_lat, base_location_lng)`
- INDEX на `city`
- INDEX на `country`

---

## 3. categories - Категории услуг

Иерархическая структура категорий.

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `parent_id` FK | UUID | Родительская категория → categories.id |
| `slug` | VARCHAR(100) | URL-slug |
| `icon` | VARCHAR(50) | Иконка (emoji или код) |
| `sort_order` | INTEGER | Порядок сортировки |
| `is_active` | BOOLEAN | Активна ли категория |

**Индексы:**
- INDEX на `parent_id`
- UNIQUE на `slug`

---

## 4. category_translations - Переводы категорий

Локализация названий категорий.

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `category_id` FK | UUID | Категория → categories.id |
| `language` | VARCHAR(5) | Код языка (ru, en, de...) |
| `name` | VARCHAR(200) | Название |
| `description` | TEXT | Описание |

**Индексы:**
- INDEX на `category_id`
- INDEX на `language`
- UNIQUE на `(category_id, language)`

---

## 5. services - Услуги мастеров

Прайс-лист мастера.

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `master_id` FK | UUID | Мастер → master_profiles.id |
| `category_id` FK | UUID | Категория → categories.id |
| `name` | VARCHAR(200) | Название услуги |
| `description` | TEXT | Описание |
| `price` | DECIMAL(10,2) | Цена |
| `currency` | VARCHAR(3) | Валюта (USD, EUR, RUB...) |
| `duration_minutes` | INTEGER | Длительность (мин) |
| `is_custom` | BOOLEAN | Кастомная услуга |
| `is_active` | BOOLEAN | Активна |
| `sort_order` | INTEGER | Порядок |

**Индексы:**
- INDEX на `master_id`
- INDEX на `category_id`
- INDEX на `is_active`

---

## 6. schedule_slots - Слоты расписания

Рабочие часы мастера.

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `master_id` FK | UUID | Мастер → master_profiles.id |
| `day_of_week` | INTEGER | День недели (0-6) |
| `start_time` | TIME | Начало работы |
| `end_time` | TIME | Конец работы |
| `is_working` | BOOLEAN | Рабочий день |

**Индексы:**
- INDEX на `master_id`
- INDEX на `day_of_week`

---

## 7. schedule_exceptions - Исключения расписания

Отпуск, выходные, особые дни.

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `master_id` FK | UUID | Мастер → master_profiles.id |
| `date` | DATE | Дата |
| `is_working` | BOOLEAN | Рабочий/выходной |
| `start_time` | TIME | Начало (если рабочий) |
| `end_time` | TIME | Конец (если рабочий) |
| `reason` | VARCHAR(200) | Причина |

**Индексы:**
- INDEX на `master_id`
- INDEX на `date`

---

## 8. bookings - Бронирования

Записи клиентов к мастерам.

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `client_id` FK | UUID | Клиент → users.id |
| `master_id` FK | UUID | Мастер → master_profiles.id |
| `service_id` FK | UUID | Услуга → services.id |
| `status` | ENUM | pending, confirmed, completed, cancelled, no_show |
| `start_time` | TIMESTAMP | Начало |
| `end_time` | TIMESTAMP | Конец |
| `price` | DECIMAL(10,2) | Цена |
| `travel_fee` | DECIMAL(10,2) | Доплата за выезд |
| `discount` | DECIMAL(10,2) | Скидка |
| `total_price` | DECIMAL(10,2) | Итого |
| `currency` | VARCHAR(3) | Валюта |
| `is_home_visit` | BOOLEAN | Выезд на дом |
| `location_lat` | DECIMAL(10,8) | Широта места |
| `location_lng` | DECIMAL(11,8) | Долгота места |
| `location_address` | TEXT | Адрес |
| `client_notes` | TEXT | Заметки клиента |
| `master_notes` | TEXT | Заметки мастера |
| `cancelled_by` | UUID | Кто отменил |
| `cancellation_reason` | TEXT | Причина отмены |
| `created_at` | TIMESTAMP | Создано |
| `updated_at` | TIMESTAMP | Обновлено |

**Индексы:**
- INDEX на `client_id`
- INDEX на `master_id`
- INDEX на `status`
- INDEX на `start_time`

---

## 9. reviews - Отзывы

Двусторонние отзывы.

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `booking_id` FK | UUID | Запись → bookings.id |
| `author_id` FK | UUID | Автор → users.id |
| `target_id` FK | UUID | Кому отзыв → users.id |
| `rating` | INTEGER | Оценка (1-5) |
| `text` | TEXT | Текст отзыва |
| `is_visible` | BOOLEAN | Видимость |
| `created_at` | TIMESTAMP | Создано |

**Индексы:**
- INDEX на `booking_id`
- INDEX на `author_id`
- INDEX на `target_id`

---

## 10. posts - Посты мастеров

Контент в ленте.

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `master_id` FK | UUID | Мастер → master_profiles.id |
| `type` | ENUM | photo, video, story |
| `caption` | TEXT | Подпись |
| `service_id` FK | UUID | Привязка к услуге → services.id |
| `likes_count` | INTEGER | Лайки |
| `comments_count` | INTEGER | Комментарии |
| `views_count` | INTEGER | Просмотры |
| `is_active` | BOOLEAN | Активен |
| `expires_at` | TIMESTAMP | Истечение (для stories) |
| `created_at` | TIMESTAMP | Создано |

**Индексы:**
- INDEX на `master_id`
- INDEX на `type`
- INDEX на `created_at`
- INDEX на `is_active`

---

## 11. post_media - Медиафайлы постов

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `post_id` FK | UUID | Пост → posts.id |
| `type` | ENUM | image, video |
| `url` | TEXT | URL файла |
| `thumbnail_url` | TEXT | URL превью |
| `duration_seconds` | INTEGER | Длительность видео |
| `sort_order` | INTEGER | Порядок |

**Индексы:**
- INDEX на `post_id`

---

## 12. likes - Лайки

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `post_id` FK | UUID | Пост → posts.id |
| `user_id` FK | UUID | Пользователь → users.id |
| `created_at` | TIMESTAMP | Создано |

**Индексы:**
- INDEX на `post_id`
- INDEX на `user_id`
- UNIQUE на `(post_id, user_id)`

---

## 13. comments - Комментарии

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `post_id` FK | UUID | Пост → posts.id |
| `user_id` FK | UUID | Автор → users.id |
| `text` | TEXT | Текст |
| `created_at` | TIMESTAMP | Создано |

**Индексы:**
- INDEX на `post_id`
- INDEX на `user_id`

---

## 14. subscriptions - Подписки

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `follower_id` FK | UUID | Подписчик → users.id |
| `master_id` FK | UUID | Мастер → master_profiles.id |
| `created_at` | TIMESTAMP | Создано |

**Индексы:**
- INDEX на `follower_id`
- INDEX на `master_id`
- UNIQUE на `(follower_id, master_id)`

---

## 15. blacklists - Чёрный список

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `master_id` FK | UUID | Мастер → master_profiles.id |
| `client_id` FK | UUID | Клиент → users.id |
| `reason` | TEXT | Причина |
| `created_at` | TIMESTAMP | Создано |

**Индексы:**
- INDEX на `master_id`
- INDEX на `client_id`
- UNIQUE на `(master_id, client_id)`

---

## 16. chats - Чаты

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `client_id` FK | UUID | Клиент → users.id |
| `master_id` FK | UUID | Мастер → master_profiles.id |
| `last_message_at` | TIMESTAMP | Последнее сообщение |
| `created_at` | TIMESTAMP | Создано |

**Индексы:**
- INDEX на `client_id`
- INDEX на `master_id`
- UNIQUE на `(client_id, master_id)`

---

## 17. messages - Сообщения

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `chat_id` FK | UUID | Чат → chats.id |
| `sender_id` FK | UUID | Отправитель → users.id |
| `text` | TEXT | Текст |
| `attachment_url` | TEXT | Вложение |
| `attachment_type` | ENUM | image, file |
| `is_read` | BOOLEAN | Прочитано |
| `created_at` | TIMESTAMP | Создано |

**Индексы:**
- INDEX на `chat_id`
- INDEX на `created_at`

---

## 18. notifications - Уведомления

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `user_id` FK | UUID | Получатель → users.id |
| `type` | ENUM | booking, message, review, reminder, promo |
| `title` | VARCHAR(200) | Заголовок |
| `body` | TEXT | Текст |
| `data` | JSONB | Дополнительные данные |
| `is_read` | BOOLEAN | Прочитано |
| `created_at` | TIMESTAMP | Создано |

**Индексы:**
- INDEX на `user_id`
- INDEX на `type`
- INDEX на `is_read`

---

## 19. referrals - Реферальная программа

| Поле | Тип | Описание |
|------|-----|----------|
| `id` PK | UUID | Первичный ключ |
| `referrer_id` FK | UUID | Пригласивший → users.id |
| `referred_id` FK | UUID | Приглашённый → users.id |
| `bonus_amount` | DECIMAL(10,2) | Бонус |
| `is_paid` | BOOLEAN | Выплачено |
| `created_at` | TIMESTAMP | Создано |

**Индексы:**
- INDEX на `referrer_id`
- INDEX на `referred_id`

---

## Рекомендуемые индексы (сводка)

```sql
-- users
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_phone ON users(phone);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_location ON users USING GIST(ll_to_earth(last_location_lat, last_location_lng));

-- master_profiles
CREATE INDEX idx_master_profiles_user_id ON master_profiles(user_id);
CREATE INDEX idx_master_profiles_location ON master_profiles USING GIST(ll_to_earth(base_location_lat, base_location_lng));
CREATE INDEX idx_master_profiles_city ON master_profiles(city);
CREATE INDEX idx_master_profiles_country ON master_profiles(country);

-- services
CREATE INDEX idx_services_master_id ON services(master_id);
CREATE INDEX idx_services_category_id ON services(category_id);
CREATE INDEX idx_services_is_active ON services(is_active);

-- bookings
CREATE INDEX idx_bookings_client_id ON bookings(client_id);
CREATE INDEX idx_bookings_master_id ON bookings(master_id);
CREATE INDEX idx_bookings_status ON bookings(status);
CREATE INDEX idx_bookings_start_time ON bookings(start_time);

-- posts
CREATE INDEX idx_posts_master_id ON posts(master_id);
CREATE INDEX idx_posts_type ON posts(type);
CREATE INDEX idx_posts_created_at ON posts(created_at);
CREATE INDEX idx_posts_is_active ON posts(is_active);

-- messages
CREATE INDEX idx_messages_chat_id ON messages(chat_id);
CREATE INDEX idx_messages_created_at ON messages(created_at);
```

---

## Связанные документы

- [BRD](../business/BRD.md) - Бизнес-требования
- [API Specification](./API.md) - API спецификация
- [Technical Specification](./TechSpec.md) - Техническое задание

---

**Статус:** Утверждён
**Последнее обновление:** Декабрь 2025
