# API СПЕЦИФИКАЦИЯ - Платформа Service

**REST API v2.0**
**Base URL:** `/api/v2`
**Версия:** 2.0
**Дата:** Декабрь 2025

---

## Обзор v2.0

**Service** — социальная платформа с интегрированным маркетплейсом услуг красоты и велнеса.

**Изменения API v2.0:**
- **v1.0:** 95 endpoints (базовый маркетплейс)
- **v2.0:** 165 endpoints (+70 новых для социальных функций)
- **WebSocket:** Real-time чаты и уведомления
- **10 новых групп:** Posts, Likes, Comments, Friends, Subscriptions, Enhanced Chats, Notifications, Favorites, Settings, Auto-proposals

**Ключевые особенности v2.0:**
- 📱 Feed API как главный endpoint (`GET /posts/feed`)
- 👥 Друзья (двусторонние) и подписки (односторонние)
- 💬 8 типов сообщений в чатах
- 🔔 11 типов уведомлений
- ⭐ Обязательные отзывы с блокировкой API
- 🤖 Автопредложения мастеров (премиум)

---

## Общая информация

### Аутентификация
- **Bearer Token (JWT)** в заголовке `Authorization: Bearer <token>`
- Токен получается при регистрации/входе
- Refresh token для обновления

### Формат данных
- Запросы и ответы в формате **JSON**
- Content-Type: `application/json`

### Пагинация
- Query параметры: `page`, `limit`
- Ответ включает: `total`, `has_more`
- По умолчанию: `page=1`, `limit=20`

### Ошибки
Формат ошибок:
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable message",
    "details": {}
  }
}
```

### Rate Limiting
- **100 req/min** для аутентифицированных пользователей
- **20 req/min** для анонимных

---

## Сводка endpoints v2.0

**Всего:** 165 endpoints в 20 групп

| Группа | v1.0 | v2.0 | Изменение |
|--------|------|------|-----------|
| 🔐 Аутентификация | 5 | 5 | - |
| 👤 Пользователи | 8 | 10 | +2 |
| 👨‍🔧 Профиль мастера | 12 | 15 | +3 |
| 🔍 Поиск мастеров | 10 | 12 | +2 |
| 📂 Каталог услуг | 6 | 6 | - |
| 💼 Услуги мастера | 10 | 10 | - |
| 📅 Расписание | 6 | 6 | - |
| 📝 Бронирование | 15 | 18 | +3 |
| ⭐ Отзывы | 8 | 8 | - |
| 📱 **Posts (Лента)** 🆕 | 0 | 15 | +15 |
| ❤️ **Likes (Лайки)** 🆕 | 0 | 6 | +6 |
| 💬 **Comments (Комментарии)** 🆕 | 0 | 8 | +8 |
| 👥 **Friends (Друзья)** 🆕 | 0 | 10 | +10 |
| 📲 **Subscriptions (Подписки)** 🆕 | 0 | 8 | +8 |
| 💬 **Chats (Чаты)** 🆕 | 0 | 12 | +12 |
| 🔔 **Notifications (Уведомления)** 🆕 | 0 | 8 | +8 |
| ⭐ **Favorites (Избранное)** | 4 | 8 | +4 |
| ⚙️ **Settings (Настройки)** 🆕 | 0 | 6 | +6 |
| 🤖 **Auto-proposals (Автопредложения)** 🆕 | 0 | 6 | +6 |
| 🔧 **Админ-панель** | 15 | 18 | +3 |
| **ИТОГО** | **95** | **165** | **+70** |

---

## 1. Аутентификация

### POST /auth/register
Регистрация нового пользователя

**Request:**
```json
{
  "email": "user@example.com",
  "phone": "+1234567890",
  "password": "SecurePass123!",
  "first_name": "John",
  "last_name": "Doe"
}
```

**Response:**
```json
{
  "user": { /* user object */ },
  "tokens": {
    "access_token": "eyJhbGc...",
    "refresh_token": "eyJhbGc...",
    "expires_in": 3600
  }
}
```

---

### POST /auth/login
Вход по email/телефону

**Request:**
```json
{
  "email": "user@example.com",
  "password": "SecurePass123!"
}
```

**Response:**
```json
{
  "user": { /* user object */ },
  "tokens": {
    "access_token": "eyJhbGc...",
    "refresh_token": "eyJhbGc...",
    "expires_in": 3600
  }
}
```

---

### POST /auth/oauth
OAuth (Google, Apple)

**Request:**
```json
{
  "provider": "google",
  "token": "google_oauth_token"
}
```

**Response:**
```json
{
  "user": { /* user object */ },
  "tokens": {
    "access_token": "eyJhbGc...",
    "refresh_token": "eyJhbGc...",
    "expires_in": 3600
  }
}
```

---

### POST /auth/refresh
Обновление токена

**Request:**
```json
{
  "refresh_token": "eyJhbGc..."
}
```

**Response:**
```json
{
  "tokens": {
    "access_token": "eyJhbGc...",
    "refresh_token": "eyJhbGc...",
    "expires_in": 3600
  }
}
```

---

### POST /auth/logout
Выход

**Response:**
```json
{
  "success": true
}
```

---

### POST /auth/password/reset
Запрос сброса пароля

**Request:**
```json
{
  "email": "user@example.com"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Reset code sent to email"
}
```

---

### POST /auth/password/confirm
Подтверждение сброса пароля

**Request:**
```json
{
  "email": "user@example.com",
  "code": "123456",
  "new_password": "NewSecurePass123!"
}
```

**Response:**
```json
{
  "success": true
}
```

---

### POST /auth/verify/send
Отправка кода верификации

**Request:**
```json
{
  "method": "email"  // or "phone"
}
```

**Response:**
```json
{
  "success": true
}
```

---

### POST /auth/verify/confirm
Подтверждение кода

**Request:**
```json
{
  "code": "123456"
}
```

**Response:**
```json
{
  "success": true
}
```

---

## 2. Пользователи

### GET /users/me
Текущий пользователь

**Response:**
```json
{
  "id": "uuid",
  "email": "user@example.com",
  "first_name": "John",
  "last_name": "Doe",
  "avatar_url": "https://...",
  "role": "client",
  "is_verified": true,
  "is_premium": false,
  "rating": 4.8,
  "reviews_count": 15
}
```

---

### PATCH /users/me
Обновление профиля

**Request:**
```json
{
  "first_name": "Jane",
  "avatar_url": "https://..."
}
```

**Response:**
```json
{
  /* updated user object */
}
```

---

### DELETE /users/me
Удаление аккаунта

**Response:**
```json
{
  "success": true
}
```

---

### GET /users/:id
Профиль пользователя (публичный)

**Response:**
```json
{
  "id": "uuid",
  "first_name": "John",
  "avatar_url": "https://...",
  "rating": 4.8,
  "reviews_count": 15
}
```

---

### POST /users/me/location
Обновление геолокации

**Request:**
```json
{
  "lat": 55.7558,
  "lng": 37.6173
}
```

**Response:**
```json
{
  "success": true
}
```

---

### GET /users/me/settings
Настройки уведомлений

**Response:**
```json
{
  "push_enabled": true,
  "email_enabled": true,
  "booking_reminders": true,
  "marketing": false
}
```

---

### PATCH /users/me/settings
Обновление настроек

**Request:**
```json
{
  "push_enabled": false
}
```

**Response:**
```json
{
  /* updated settings */
}
```

---

## 3. Профиль мастера

### POST /masters
Создание профиля мастера

**Request:**
```json
{
  "display_name": "John's Barbershop",
  "bio": "Professional barber with 10 years experience",
  "base_location_lat": 55.7558,
  "base_location_lng": 37.6173,
  "base_address": "Moscow, Red Square",
  "city": "Moscow",
  "country": "Russia",
  "travel_radius_km": 10,
  "currencies": ["RUB", "USD"]
}
```

**Response:**
```json
{
  /* master_profile object */
}
```

---

### GET /masters/me
Мой профиль мастера (полный)

**Response:**
```json
{
  "id": "uuid",
  "user_id": "uuid",
  "display_name": "John's Barbershop",
  "bio": "...",
  "base_location_lat": 55.7558,
  "base_location_lng": 37.6173,
  "city": "Moscow",
  "views_count": 1542,
  "subscribers_count": 87
}
```

---

### PATCH /masters/me
Обновление профиля мастера

**Request:**
```json
{
  "bio": "Updated bio",
  "travel_radius_km": 15
}
```

**Response:**
```json
{
  /* updated master_profile */
}
```

---

### GET /masters/:id
Профиль мастера (публичный)

**Response:**
```json
{
  "id": "uuid",
  "display_name": "John's Barbershop",
  "bio": "...",
  "city": "Moscow",
  "rating": 4.9,
  "reviews_count": 234,
  "subscribers_count": 87
}
```

---

### GET /masters/:id/portfolio
Портфолио мастера

**Response:**
```json
{
  "posts": [
    {
      "id": "uuid",
      "type": "photo",
      "caption": "New haircut style",
      "media": [
        {
          "type": "image",
          "url": "https://...",
          "thumbnail_url": "https://..."
        }
      ],
      "likes_count": 45,
      "created_at": "2025-12-20T10:00:00Z"
    }
  ]
}
```

---

### GET /masters/:id/services
Услуги мастера

**Response:**
```json
{
  "services": [
    {
      "id": "uuid",
      "name": "Men's Haircut",
      "description": "Classic men's haircut",
      "price": 1500,
      "currency": "RUB",
      "duration_minutes": 30
    }
  ]
}
```

---

### GET /masters/:id/reviews
Отзывы о мастере

**Query params:** `page`, `limit`

**Response:**
```json
{
  "reviews": [
    {
      "id": "uuid",
      "author": {
        "id": "uuid",
        "first_name": "Jane",
        "avatar_url": "https://..."
      },
      "rating": 5,
      "text": "Great service!",
      "created_at": "2025-12-20T10:00:00Z"
    }
  ],
  "stats": {
    "average_rating": 4.9,
    "total_count": 234,
    "rating_distribution": {
      "5": 200,
      "4": 30,
      "3": 3,
      "2": 1,
      "1": 0
    }
  }
}
```

---

### GET /masters/:id/available-slots
Доступные слоты для записи

**Query params:** `date`, `service_id`

**Response:**
```json
{
  "slots": [
    {
      "start_time": "2025-12-20T10:00:00Z",
      "end_time": "2025-12-20T10:30:00Z",
      "available": true
    },
    {
      "start_time": "2025-12-20T10:30:00Z",
      "end_time": "2025-12-20T11:00:00Z",
      "available": false
    }
  ]
}
```

---

### GET /masters/me/stats
Статистика мастера

**Query params:** `from`, `to` (даты)

**Response:**
```json
{
  "views": 1542,
  "bookings": {
    "total": 156,
    "completed": 145,
    "cancelled": 11
  },
  "revenue": {
    "amount": 125000,
    "currency": "RUB"
  },
  "conversion": 0.095
}
```

---

### GET /masters/me/clients
Клиенты мастера

**Response:**
```json
{
  "clients": [
    {
      "id": "uuid",
      "first_name": "Jane",
      "avatar_url": "https://...",
      "total_bookings": 5,
      "last_booking_at": "2025-12-20T10:00:00Z"
    }
  ]
}
```

---

## 4. Поиск мастеров

### GET /search/masters
Поиск мастеров

**Query params:**
- `q` - поисковый запрос
- `category_id` - категория
- `lat`, `lng` - геолокация
- `radius_km` - радиус поиска
- `min_price`, `max_price` - ценовой диапазон
- `min_rating` - минимальный рейтинг
- `verified_only` - только верифицированные
- `home_visit` - с выездом на дом
- `sort` - сортировка (distance, rating, price, popularity)
- `page`, `limit`

**Response:**
```json
{
  "masters": [
    {
      "id": "uuid",
      "display_name": "John's Barbershop",
      "avatar_url": "https://...",
      "city": "Moscow",
      "rating": 4.9,
      "reviews_count": 234,
      "distance_km": 2.5,
      "min_price": 1000,
      "currency": "RUB"
    }
  ],
  "total": 145,
  "has_more": true
}
```

---

### GET /search/masters/map
Мастера на карте

**Query params:** те же что в `/search/masters`

**Response:**
```json
{
  "markers": [
    {
      "id": "uuid",
      "lat": 55.7558,
      "lng": 37.6173,
      "display_name": "John's Barbershop",
      "rating": 4.9,
      "min_price": 1000
    }
  ]
}
```

---

### GET /search/suggestions
Автодополнение поиска

**Query params:** `q` - поисковый запрос

**Response:**
```json
{
  "suggestions": [
    {
      "type": "category",
      "id": "uuid",
      "name": "Barbershop",
      "icon": "✂️"
    },
    {
      "type": "master",
      "id": "uuid",
      "name": "John's Barbershop"
    }
  ]
}
```

---

## 5. Каталог услуг

### GET /categories
Дерево категорий

**Response:**
```json
{
  "categories": [
    {
      "id": "uuid",
      "slug": "beauty",
      "name": "Красота и уход",
      "icon": "💇",
      "children": [
        {
          "id": "uuid",
          "slug": "hairdressers",
          "name": "Парикмахерские услуги",
          "icon": "✂️"
        }
      ]
    }
  ]
}
```

---

### GET /categories/:id
Категория с подкатегориями

**Response:**
```json
{
  "id": "uuid",
  "slug": "beauty",
  "name": "Красота и уход",
  "description": "...",
  "icon": "💇",
  "children": [/* subcategories */]
}
```

---

### GET /categories/:id/services
Услуги в категории

**Response:**
```json
{
  "services": [
    {
      "id": "uuid",
      "name": "Men's Haircut",
      "description": "...",
      "avg_price": 1500,
      "avg_duration": 30
    }
  ]
}
```

---

### POST /categories/suggest
Предложить новую категорию

**Request:**
```json
{
  "name": "Suggested Category",
  "description": "..."
}
```

**Response:**
```json
{
  "suggestion_id": "uuid",
  "status": "pending"
}
```

---

## 6. Услуги мастера

### GET /services
Мои услуги (для мастера)

**Response:**
```json
{
  "services": [
    {
      "id": "uuid",
      "category_id": "uuid",
      "name": "Men's Haircut",
      "description": "...",
      "price": 1500,
      "currency": "RUB",
      "duration_minutes": 30,
      "is_active": true
    }
  ]
}
```

---

### POST /services
Создать услугу

**Request:**
```json
{
  "category_id": "uuid",
  "name": "Men's Haircut",
  "description": "...",
  "price": 1500,
  "currency": "RUB",
  "duration_minutes": 30
}
```

**Response:**
```json
{
  /* created service */
}
```

---

### PATCH /services/:id
Обновить услугу

**Request:**
```json
{
  "price": 1800
}
```

**Response:**
```json
{
  /* updated service */
}
```

---

### DELETE /services/:id
Удалить услугу

**Response:**
```json
{
  "success": true
}
```

---

### PATCH /services/reorder
Изменить порядок услуг

**Request:**
```json
{
  "service_ids": ["uuid1", "uuid2", "uuid3"]
}
```

**Response:**
```json
{
  "success": true
}
```

---

## 7. Расписание

### GET /schedule
Моё расписание (для мастера)

**Response:**
```json
{
  "slots": [
    {
      "day_of_week": 1,
      "start_time": "09:00",
      "end_time": "18:00",
      "is_working": true
    }
  ],
  "exceptions": [
    {
      "date": "2025-12-25",
      "is_working": false,
      "reason": "Christmas"
    }
  ]
}
```

---

### PUT /schedule/slots
Установить рабочие часы

**Request:**
```json
{
  "slots": [
    {
      "day_of_week": 1,
      "start_time": "09:00",
      "end_time": "18:00",
      "is_working": true
    }
  ]
}
```

**Response:**
```json
{
  "slots": [/* updated slots */]
}
```

---

### POST /schedule/exceptions
Добавить исключение

**Request:**
```json
{
  "date": "2025-12-25",
  "is_working": false,
  "reason": "Christmas"
}
```

**Response:**
```json
{
  /* created exception */
}
```

---

### DELETE /schedule/exceptions/:id
Удалить исключение

**Response:**
```json
{
  "success": true
}
```

---

### POST /schedule/sync
Синхронизация с внешним календарём

**Request:**
```json
{
  "calendar_type": "google",
  "auth_code": "..."
}
```

**Response:**
```json
{
  "success": true
}
```

---

## 8. Бронирование

### GET /bookings
Мои записи (клиент/мастер)

**Query params:** `status`, `page`, `limit`

**Response:**
```json
{
  "bookings": [
    {
      "id": "uuid",
      "client": { /* client info */ },
      "master": { /* master info */ },
      "service": { /* service info */ },
      "status": "confirmed",
      "start_time": "2025-12-20T10:00:00Z",
      "end_time": "2025-12-20T10:30:00Z",
      "total_price": 1500,
      "currency": "RUB"
    }
  ]
}
```

---

### POST /bookings
Создать запись

**Request:**
```json
{
  "master_id": "uuid",
  "service_id": "uuid",
  "start_time": "2025-12-20T10:00:00Z",
  "is_home_visit": false,
  "client_notes": "Please bring..."
}
```

**Response:**
```json
{
  /* created booking */
}
```

---

### GET /bookings/:id
Детали записи

**Response:**
```json
{
  "id": "uuid",
  "client": { /* full client info */ },
  "master": { /* full master info */ },
  "service": { /* service info */ },
  "status": "confirmed",
  "start_time": "2025-12-20T10:00:00Z",
  "total_price": 1500,
  "client_notes": "...",
  "master_notes": "..."
}
```

---

### PATCH /bookings/:id/confirm
Подтвердить запись (мастер)

**Response:**
```json
{
  /* updated booking with status=confirmed */
}
```

---

### PATCH /bookings/:id/reschedule
Перенести запись

**Request:**
```json
{
  "start_time": "2025-12-21T10:00:00Z"
}
```

**Response:**
```json
{
  /* updated booking */
}
```

---

### PATCH /bookings/:id/cancel
Отменить запись

**Request:**
```json
{
  "reason": "Can't make it"
}
```

**Response:**
```json
{
  /* updated booking with status=cancelled */
}
```

---

### PATCH /bookings/:id/complete
Завершить запись (мастер)

**Response:**
```json
{
  /* updated booking with status=completed */
}
```

---

### PATCH /bookings/:id/no-show
Отметить неявку (мастер)

**Response:**
```json
{
  /* updated booking with status=no_show */
}
```

---

### POST /bookings/:id/rebook
Повторная запись

**Request:**
```json
{
  "start_time": "2025-12-27T10:00:00Z"
}
```

**Response:**
```json
{
  /* new booking */
}
```

---

## 9. Отзывы

### GET /reviews/received
Полученные отзывы

**Response:**
```json
{
  "reviews": [/* review objects */]
}
```

---

### GET /reviews/sent
Отправленные отзывы

**Response:**
```json
{
  "reviews": [/* review objects */]
}
```

---

### POST /reviews
Оставить отзыв

**Request:**
```json
{
  "booking_id": "uuid",
  "rating": 5,
  "text": "Great service!"
}
```

**Response:**
```json
{
  /* created review */
}
```

---

### PATCH /reviews/:id
Редактировать отзыв

**Request:**
```json
{
  "text": "Updated review text"
}
```

**Response:**
```json
{
  /* updated review */
}
```

---

### DELETE /reviews/:id
Удалить отзыв

**Response:**
```json
{
  "success": true
}
```

---

## 10. Лента и посты

### GET /feed
Лента постов

**Query params:** `type` (recommendations/subscriptions/nearby), `page`, `limit`

**Response:**
```json
{
  "posts": [
    {
      "id": "uuid",
      "master": { /* master info */ },
      "type": "photo",
      "caption": "New work",
      "media": [
        {
          "type": "image",
          "url": "https://...",
          "thumbnail_url": "https://..."
        }
      ],
      "likes_count": 45,
      "comments_count": 12,
      "created_at": "2025-12-20T10:00:00Z",
      "is_liked": false
    }
  ]
}
```

---

### GET /posts/:id
Пост

**Response:**
```json
{
  /* full post object */
}
```

---

### POST /posts
Создать пост

**Request:**
```json
{
  "type": "photo",
  "caption": "New haircut style",
  "service_id": "uuid",
  "media": [
    {
      "type": "image",
      "url": "https://..."
    }
  ]
}
```

**Response:**
```json
{
  /* created post */
}
```

---

### PATCH /posts/:id
Редактировать пост

**Request:**
```json
{
  "caption": "Updated caption"
}
```

**Response:**
```json
{
  /* updated post */
}
```

---

### DELETE /posts/:id
Удалить пост

**Response:**
```json
{
  "success": true
}
```

---

### POST /posts/:id/like
Лайкнуть

**Response:**
```json
{
  "success": true,
  "likes_count": 46
}
```

---

### DELETE /posts/:id/like
Убрать лайк

**Response:**
```json
{
  "success": true,
  "likes_count": 45
}
```

---

### GET /posts/:id/comments
Комментарии

**Response:**
```json
{
  "comments": [
    {
      "id": "uuid",
      "user": { /* user info */ },
      "text": "Great work!",
      "created_at": "2025-12-20T10:00:00Z"
    }
  ]
}
```

---

### POST /posts/:id/comments
Добавить комментарий

**Request:**
```json
{
  "text": "Great work!"
}
```

**Response:**
```json
{
  /* created comment */
}
```

---

### DELETE /comments/:id
Удалить комментарий

**Response:**
```json
{
  "success": true
}
```

---

## 11. Подписки

### GET /subscriptions
Мои подписки

**Response:**
```json
{
  "masters": [/* master objects */]
}
```

---

### POST /subscriptions/:master_id
Подписаться

**Response:**
```json
{
  "success": true
}
```

---

### DELETE /subscriptions/:master_id
Отписаться

**Response:**
```json
{
  "success": true
}
```

---

### GET /masters/me/subscribers
Мои подписчики

**Response:**
```json
{
  "users": [/* user objects */]
}
```

---

## 12. Чёрный список

### GET /blacklist
Мой чёрный список

**Response:**
```json
{
  "users": [/* user objects with reason */]
}
```

---

### POST /blacklist/:user_id
Добавить в ЧС

**Request:**
```json
{
  "reason": "No-show multiple times"
}
```

**Response:**
```json
{
  "success": true
}
```

---

### DELETE /blacklist/:user_id
Удалить из ЧС

**Response:**
```json
{
  "success": true
}
```

---

## 13. Чат

### GET /chats
Список чатов

**Response:**
```json
{
  "chats": [
    {
      "id": "uuid",
      "participant": { /* user info */ },
      "last_message": {
        "text": "Hello!",
        "created_at": "2025-12-20T10:00:00Z"
      },
      "unread_count": 3
    }
  ]
}
```

---

### GET /chats/:id
Чат с сообщениями

**Response:**
```json
{
  "chat": {
    "id": "uuid",
    "participant": { /* user info */ }
  },
  "messages": [
    {
      "id": "uuid",
      "sender_id": "uuid",
      "text": "Hello!",
      "attachment_url": null,
      "is_read": true,
      "created_at": "2025-12-20T10:00:00Z"
    }
  ]
}
```

---

### POST /chats
Создать чат

**Request:**
```json
{
  "participant_id": "uuid"
}
```

**Response:**
```json
{
  /* created chat */
}
```

---

### POST /chats/:id/messages
Отправить сообщение

**Request:**
```json
{
  "text": "Hello!",
  "attachment_url": "https://..."
}
```

**Response:**
```json
{
  /* created message */
}
```

---

### PATCH /chats/:id/read
Отметить прочитанным

**Response:**
```json
{
  "success": true
}
```

---

## 14. Уведомления

### GET /notifications
Список уведомлений

**Response:**
```json
{
  "notifications": [
    {
      "id": "uuid",
      "type": "booking",
      "title": "New booking",
      "body": "You have a new booking from Jane",
      "data": {
        "booking_id": "uuid"
      },
      "is_read": false,
      "created_at": "2025-12-20T10:00:00Z"
    }
  ]
}
```

---

### PATCH /notifications/:id/read
Прочитать уведомление

**Response:**
```json
{
  "success": true
}
```

---

### PATCH /notifications/read-all
Прочитать все

**Response:**
```json
{
  "success": true
}
```

---

### POST /devices
Регистрация устройства для push

**Request:**
```json
{
  "token": "fcm_device_token",
  "platform": "ios"
}
```

**Response:**
```json
{
  "success": true
}
```

---

### DELETE /devices/:token
Удалить устройство

**Response:**
```json
{
  "success": true
}
```

---

## 15. Премиум и верификация

### GET /premium/plans
Тарифы премиум

**Response:**
```json
{
  "plans": [
    {
      "id": "premium_client",
      "name": "Премиум клиент",
      "price": 299,
      "currency": "RUB",
      "period": "month",
      "benefits": ["5% discount", "No ads"]
    }
  ]
}
```

---

### POST /premium/subscribe
Оформить премиум

**Request:**
```json
{
  "plan_id": "premium_client"
}
```

**Response:**
```json
{
  "subscription": {
    "id": "uuid",
    "plan_id": "premium_client",
    "active_until": "2026-01-20T10:00:00Z"
  }
}
```

---

### DELETE /premium/cancel
Отменить премиум

**Response:**
```json
{
  "success": true
}
```

---

### POST /verification/start
Начать KYC верификацию

**Response:**
```json
{
  "session_url": "https://verification-service.com/session/..."
}
```

---

### GET /verification/status
Статус верификации

**Response:**
```json
{
  "status": "pending",  // or "approved", "rejected"
  "submitted_at": "2025-12-20T10:00:00Z"
}
```

---

## 16. Реферальная программа

### GET /referrals
Мои рефералы

**Response:**
```json
{
  "referrals": [
    {
      "id": "uuid",
      "referred_user": { /* user info */ },
      "bonus_amount": 500,
      "is_paid": true,
      "created_at": "2025-12-20T10:00:00Z"
    }
  ],
  "stats": {
    "total_referrals": 5,
    "total_bonus": 2500
  }
}
```

---

### GET /referrals/code
Мой реферальный код

**Response:**
```json
{
  "code": "JOHN2025",
  "link": "https://service.app/ref/JOHN2025"
}
```

---

### POST /referrals/apply
Применить реферальный код

**Request:**
```json
{
  "code": "JANE2025"
}
```

**Response:**
```json
{
  "success": true,
  "bonus": 500
}
```

---

## 17. Загрузка файлов

### POST /upload/image
Загрузить изображение

**Request:** multipart/form-data with `file`

**Response:**
```json
{
  "url": "https://cdn.service.app/images/...",
  "thumbnail_url": "https://cdn.service.app/thumbs/..."
}
```

---

### POST /upload/video
Загрузить видео

**Request:** multipart/form-data with `file`

**Response:**
```json
{
  "url": "https://cdn.service.app/videos/...",
  "thumbnail_url": "https://cdn.service.app/thumbs/...",
  "duration_seconds": 15
}
```

---

### POST /upload/document
Загрузить документ

**Request:** multipart/form-data with `file`

**Response:**
```json
{
  "url": "https://cdn.service.app/docs/...",
  "filename": "certificate.pdf"
}
```

---

## 18. Админ-панель

**Требуется роль:** `admin`
**Аутентификация:** Bearer Token с admin правами

### GET /admin/dashboard
Дашборд с метриками

**Response:**
```json
{
  "stats": {
    "users": {
      "total": 15420,
      "clients": 14200,
      "masters": 1220,
      "verified": 340,
      "premium": 580,
      "new_this_month": 1250
    },
    "bookings": {
      "total": 45230,
      "pending": 125,
      "confirmed": 230,
      "completed": 44200,
      "cancelled": 675,
      "completion_rate": 0.97
    },
    "revenue": {
      "total_gmv": 2500000,
      "platform_fee": 125000,
      "currency": "RUB",
      "avg_booking_value": 1500
    },
    "content": {
      "posts": 8920,
      "pending_moderation": 45,
      "flagged": 12
    }
  },
  "charts": {
    "daily_users": [/* array of daily data */],
    "daily_bookings": [/* array of daily data */],
    "daily_revenue": [/* array of daily data */]
  }
}
```

---

### GET /admin/users
Список всех пользователей

**Query params:**
- `role` - client/master/admin
- `status` - active/banned
- `premium` - true/false
- `verified` - true/false
- `search` - поиск по email/имени
- `page`, `limit`

**Response:**
```json
{
  "users": [
    {
      "id": "uuid",
      "email": "user@example.com",
      "first_name": "John",
      "last_name": "Doe",
      "role": "master",
      "is_premium": true,
      "is_verified": true,
      "is_banned": false,
      "created_at": "2025-12-01T10:00:00Z",
      "last_login": "2025-12-20T09:30:00Z"
    }
  ],
  "total": 15420,
  "has_more": true
}
```

---

### GET /admin/users/:id
Детальная информация о пользователе

**Response:**
```json
{
  "user": {
    /* full user object */
  },
  "master_profile": {
    /* master profile if exists */
  },
  "stats": {
    "total_bookings": 245,
    "completed_bookings": 238,
    "cancellations": 5,
    "no_shows": 2,
    "reviews_received": 230,
    "average_rating": 4.8
  },
  "activity": {
    "last_login": "2025-12-20T09:30:00Z",
    "registration_date": "2025-06-15T10:00:00Z",
    "devices": [
      {"platform": "ios", "last_used": "2025-12-20T09:30:00Z"}
    ]
  },
  "moderation": {
    "reports_count": 0,
    "warnings_count": 0,
    "bans_count": 0
  }
}
```

---

### PATCH /admin/users/:id/ban
Заблокировать пользователя

**Request:**
```json
{
  "reason": "Violation of terms",
  "duration_days": 30  // null = permanent
}
```

**Response:**
```json
{
  "success": true,
  "user": {
    "is_banned": true,
    "ban_until": "2026-01-20T00:00:00Z",
    "ban_reason": "Violation of terms"
  }
}
```

---

### PATCH /admin/users/:id/unban
Разблокировать пользователя

**Response:**
```json
{
  "success": true,
  "user": {
    "is_banned": false
  }
}
```

---

### GET /admin/content/posts
Модерация постов

**Query params:**
- `status` - all/pending/approved/rejected/flagged
- `master_id` - фильтр по мастеру
- `page`, `limit`

**Response:**
```json
{
  "posts": [
    {
      "id": "uuid",
      "master": {
        "id": "uuid",
        "display_name": "John's Barbershop"
      },
      "type": "photo",
      "caption": "New haircut",
      "media": [/* media objects */],
      "moderation_status": "pending",
      "reports_count": 0,
      "created_at": "2025-12-20T10:00:00Z"
    }
  ]
}
```

---

### PATCH /admin/content/posts/:id/approve
Одобрить пост

**Response:**
```json
{
  "success": true,
  "post": {
    "moderation_status": "approved"
  }
}
```

---

### PATCH /admin/content/posts/:id/reject
Отклонить пост

**Request:**
```json
{
  "reason": "Inappropriate content"
}
```

**Response:**
```json
{
  "success": true,
  "post": {
    "moderation_status": "rejected",
    "rejection_reason": "Inappropriate content"
  }
}
```

---

### DELETE /admin/content/posts/:id
Удалить пост

**Response:**
```json
{
  "success": true
}
```

---

### GET /admin/content/reports
Жалобы от пользователей

**Query params:**
- `status` - pending/reviewed/resolved
- `type` - post/user/review/message
- `page`, `limit`

**Response:**
```json
{
  "reports": [
    {
      "id": "uuid",
      "reporter": {
        "id": "uuid",
        "email": "reporter@example.com"
      },
      "type": "post",
      "target_id": "uuid",
      "reason": "spam",
      "description": "Advertising external services",
      "status": "pending",
      "created_at": "2025-12-20T10:00:00Z"
    }
  ]
}
```

---

### PATCH /admin/content/reports/:id/resolve
Разрешить жалобу

**Request:**
```json
{
  "action": "delete_content",  // or "warn_user", "ban_user", "ignore"
  "notes": "Content removed as spam"
}
```

**Response:**
```json
{
  "success": true,
  "report": {
    "status": "resolved",
    "resolved_at": "2025-12-20T11:00:00Z"
  }
}
```

---

### GET /admin/categories
Управление каталогом

**Response:**
```json
{
  "categories": [/* full category tree */]
}
```

---

### POST /admin/categories
Создать категорию

**Request:**
```json
{
  "parent_id": "uuid",  // null for top-level
  "slug": "new-category",
  "icon": "🎨",
  "translations": {
    "en": {"name": "New Category", "description": "Description"},
    "ru": {"name": "Новая категория", "description": "Описание"}
  }
}
```

**Response:**
```json
{
  /* created category */
}
```

---

### PATCH /admin/categories/:id
Обновить категорию

**Request:**
```json
{
  "is_active": false
}
```

**Response:**
```json
{
  /* updated category */
}
```

---

### DELETE /admin/categories/:id
Удалить категорию

**Response:**
```json
{
  "success": true
}
```

---

## Error Codes Reference

### Формат ошибки
```json
{
  "error": {
    "code": "ERROR_CODE",
    "message": "Human readable message",
    "details": {
      "field": "additional info"
    }
  }
}
```

### Коды ошибок

#### Общие ошибки (1000-1099)
| Code | HTTP | Описание |
|------|------|----------|
| `INTERNAL_SERVER_ERROR` | 500 | Внутренняя ошибка сервера |
| `SERVICE_UNAVAILABLE` | 503 | Сервис временно недоступен |
| `INVALID_REQUEST` | 400 | Некорректный запрос |
| `VALIDATION_ERROR` | 400 | Ошибка валидации данных |
| `RATE_LIMIT_EXCEEDED` | 429 | Превышен лимит запросов |

#### Аутентификация (2000-2099)
| Code | HTTP | Описание |
|------|------|----------|
| `UNAUTHORIZED` | 401 | Требуется аутентификация |
| `INVALID_TOKEN` | 401 | Невалидный токен |
| `TOKEN_EXPIRED` | 401 | Токен истёк |
| `INVALID_CREDENTIALS` | 401 | Неверный email/пароль |
| `EMAIL_ALREADY_EXISTS` | 409 | Email уже зарегистрирован |
| `PHONE_ALREADY_EXISTS` | 409 | Телефон уже зарегистрирован |
| `VERIFICATION_REQUIRED` | 403 | Требуется верификация email/телефона |
| `INVALID_VERIFICATION_CODE` | 400 | Неверный код верификации |

#### Авторизация (2100-2199)
| Code | HTTP | Описание |
|------|------|----------|
| `FORBIDDEN` | 403 | Доступ запрещён |
| `INSUFFICIENT_PERMISSIONS` | 403 | Недостаточно прав |
| `ACCOUNT_BANNED` | 403 | Аккаунт заблокирован |
| `PREMIUM_REQUIRED` | 403 | Требуется премиум подписка |

#### Ресурсы (3000-3099)
| Code | HTTP | Описание |
|------|------|----------|
| `NOT_FOUND` | 404 | Ресурс не найден |
| `USER_NOT_FOUND` | 404 | Пользователь не найден |
| `MASTER_NOT_FOUND` | 404 | Мастер не найден |
| `BOOKING_NOT_FOUND` | 404 | Запись не найдена |
| `POST_NOT_FOUND` | 404 | Пост не найден |
| `CHAT_NOT_FOUND` | 404 | Чат не найден |

#### Бронирование (4000-4099)
| Code | HTTP | Описание |
|------|------|----------|
| `SLOT_NOT_AVAILABLE` | 409 | Слот недоступен |
| `BOOKING_ALREADY_EXISTS` | 409 | Запись уже существует |
| `CANNOT_CANCEL_BOOKING` | 400 | Невозможно отменить запись |
| `BOOKING_TOO_LATE` | 400 | Слишком поздно для изменений |
| `MASTER_NOT_ACCEPTING_BOOKINGS` | 400 | Мастер не принимает записи |
| `CLIENT_BLACKLISTED` | 403 | Клиент в чёрном списке |

#### Контент (5000-5099)
| Code | HTTP | Описание |
|------|------|----------|
| `FILE_TOO_LARGE` | 413 | Файл слишком большой |
| `INVALID_FILE_TYPE` | 400 | Неподдерживаемый тип файла |
| `VIDEO_TOO_LONG` | 400 | Видео слишком длинное (>15 сек) |
| `POST_REJECTED` | 403 | Пост отклонён модерацией |
| `CONTENT_MODERATION_PENDING` | 202 | Контент на модерации |

#### Платежи (6000-6099) - v1.0
| Code | HTTP | Описание |
|------|------|----------|
| `PAYMENT_FAILED` | 402 | Платёж не прошёл |
| `INSUFFICIENT_FUNDS` | 402 | Недостаточно средств |
| `INVALID_PAYMENT_METHOD` | 400 | Неверный способ оплаты |
| `REFUND_FAILED` | 500 | Возврат не удался |

#### Бизнес-логика (7000-7099)
| Code | HTTP | Описание |
|------|------|----------|
| `CANNOT_REVIEW_OWN_SERVICE` | 400 | Нельзя оставить отзыв себе |
| `REVIEW_ALREADY_EXISTS` | 409 | Отзыв уже оставлен |
| `CANNOT_MESSAGE_UNTIL_BOOKING` | 403 | Чат доступен после подтверждения |
| `ALREADY_SUBSCRIBED` | 409 | Уже подписан |
| `CANNOT_SUBSCRIBE_TO_SELF` | 400 | Нельзя подписаться на себя |

---

## WebSocket Events

### Подключение
```
wss://api.service.com/ws?token=JWT
```

### События

#### new_message
Новое сообщение в чате
```json
{
  "event": "new_message",
  "data": {
    "chat_id": "uuid",
    "message": { /* message object */ }
  }
}
```

#### booking_update
Изменение статуса записи
```json
{
  "event": "booking_update",
  "data": {
    "booking_id": "uuid",
    "status": "confirmed"
  }
}
```

#### notification
Новое уведомление
```json
{
  "event": "notification",
  "data": {
    /* notification object */
  }
}
```

#### typing
Индикатор набора текста
```json
{
  "event": "typing",
  "data": {
    "chat_id": "uuid",
    "user_id": "uuid",
    "is_typing": true
  }
}
```

---

## 📱 НОВЫЕ ENDPOINTS v2.0

---

## 11. Posts (Посты) - v2.0 🆕

### GET /posts/feed
Лента контента с алгоритмом ранжирования

**Query Parameters:**
```
?page=1&limit=20&category_id=uuid&lat=55.7558&lon=37.6173
```

**Response:**
```json
{
  "posts": [
    {
      "id": "uuid",
      "master_id": "uuid",
      "master_name": "Anna Ivanova",
      "description": "Новый маникюр с дизайном",
      "media": [
        {
          "type": "image",
          "url": "https://cdn.service.com/posts/image1.jpg",
          "thumbnail_url": "https://cdn.service.com/posts/image1_thumb.jpg"
        }
      ],
      "service_id": "uuid",
      "service_name": "Маникюр",
      "location": { "lat": 55.7558, "lon": 37.6173, "city": "Москва" },
      "likes_count": 42,
      "comments_count": 15,
      "is_liked": false,
      "created_at": "2025-12-20T10:30:00Z"
    }
  ],
  "total": 1250,
  "has_more": true
}
```

### POST /posts
Создать пост (только мастера)

**Request:**
```json
{
  "description": "Новая работа - балаяж",
  "service_ids": ["uuid1", "uuid2"],
  "location": { "lat": 55.7558, "lon": 37.6173 },
  "media_files": ["file1_id", "file2_id"]
}
```

**Response:** 201 Created
```json
{
  "post": { /* post object */ }
}
```

### POST /posts/{id}/repost
Репостнуть пост в свой профиль

**Response:** 201 Created

### DELETE /posts/{id}
Удалить пост (только автор)

**Response:** 204 No Content

---

## 12. Likes (Лайки) - v2.0 🆕

### POST /posts/{id}/like
Лайкнуть пост

**Response:** 201 Created
```json
{
  "like": {
    "id": "uuid",
    "post_id": "uuid",
    "user_id": "uuid",
    "created_at": "2025-12-20T10:30:00Z"
  },
  "total_likes": 43
}
```

### DELETE /posts/{id}/like
Убрать лайк

**Response:** 204 No Content

### GET /posts/{id}/likes
Список пользователей, лайкнувших пост

**Response:**
```json
{
  "likes": [
    {
      "user": { "id": "uuid", "name": "John Doe", "avatar_url": "..." },
      "created_at": "2025-12-20T10:30:00Z"
    }
  ],
  "total": 43
}
```

### POST /comments/{id}/like
Лайкнуть комментарий

**Response:** 201 Created

### DELETE /comments/{id}/like
Убрать лайк с комментария

**Response:** 204 No Content

---

## 13. Comments (Комментарии) - v2.0 🆕

### GET /posts/{id}/comments
Комментарии к посту (вложенные до 2 уровней)

**Response:**
```json
{
  "comments": [
    {
      "id": "uuid",
      "post_id": "uuid",
      "user": { "id": "uuid", "name": "John Doe", "avatar_url": "..." },
      "text": "Красиво!",
      "likes_count": 5,
      "is_liked": false,
      "replies_count": 2,
      "parent_comment_id": null,
      "created_at": "2025-12-20T10:30:00Z",
      "updated_at": "2025-12-20T10:30:00Z"
    }
  ],
  "total": 15
}
```

### POST /posts/{id}/comments
Добавить комментарий

**Request:**
```json
{
  "text": "Очень красивая работа!"
}
```

**Response:** 201 Created

### POST /comments/{id}/reply
Ответить на комментарий (вложенность до 2 уровней)

**Request:**
```json
{
  "text": "Спасибо!"
}
```

**Response:** 201 Created

### PUT /comments/{id}
Редактировать комментарий (только автор, в течение 15 минут)

**Request:**
```json
{
  "text": "Исправленный текст"
}
```

**Response:** 200 OK

### DELETE /comments/{id}
Удалить комментарий (автор или автор поста)

**Response:** 204 No Content

### POST /comments/{id}/report
Пожаловаться на комментарий

**Request:**
```json
{
  "reason": "spam",
  "comment": "Рекламный спам"
}
```

**Response:** 201 Created

---

## 14. Friends (Друзья) - v2.0 🆕

### GET /friends
Мои друзья

**Response:**
```json
{
  "friends": [
    {
      "id": "uuid",
      "user": { "id": "uuid", "name": "Jane Smith", "avatar_url": "..." },
      "friendship_since": "2025-01-15T00:00:00Z",
      "mutual_friends_count": 5
    }
  ],
  "total": 42
}
```

### POST /friends/request
Отправить запрос в друзья

**Request:**
```json
{
  "user_id": "uuid"
}
```

**Response:** 201 Created
```json
{
  "request": {
    "id": "uuid",
    "from_user_id": "uuid",
    "to_user_id": "uuid",
    "status": "pending",
    "created_at": "2025-12-20T10:30:00Z"
  }
}
```

### PUT /friends/request/{id}/accept
Принять запрос в друзья

**Response:** 200 OK
```json
{
  "friendship": { /* friendship object */ }
}
```

### PUT /friends/request/{id}/reject
Отклонить запрос в друзья

**Response:** 200 OK

### DELETE /friends/{userId}
Удалить из друзей

**Response:** 204 No Content

### GET /friends/requests/pending
Входящие запросы в друзья

**Response:**
```json
{
  "requests": [
    {
      "id": "uuid",
      "from_user": { "id": "uuid", "name": "John Doe", "avatar_url": "..." },
      "created_at": "2025-12-20T10:30:00Z",
      "mutual_friends_count": 3
    }
  ],
  "total": 5
}
```

### GET /friends/requests/sent
Отправленные запросы в друзья

**Response:**
```json
{
  "requests": [
    {
      "id": "uuid",
      "to_user": { "id": "uuid", "name": "Jane Smith", "avatar_url": "..." },
      "status": "pending",
      "created_at": "2025-12-20T10:30:00Z"
    }
  ],
  "total": 2
}
```

### GET /friends/suggestions
Рекомендации друзей (на основе взаимных друзей)

**Response:**
```json
{
  "suggestions": [
    {
      "user": { "id": "uuid", "name": "Mike Johnson", "avatar_url": "..." },
      "mutual_friends_count": 7,
      "mutual_friends": [
        { "id": "uuid", "name": "Anna Ivanova" }
      ]
    }
  ],
  "total": 10
}
```

### POST /friends/block
Заблокировать пользователя

**Request:**
```json
{
  "user_id": "uuid",
  "reason": "spam"
}
```

**Response:** 201 Created

### DELETE /friends/block/{userId}
Разблокировать пользователя

**Response:** 204 No Content

---

## 15. Subscriptions (Подписки) - v2.0 🆕

### POST /users/{id}/subscribe
Подписаться на пользователя (мгновенно, без подтверждения)

**Response:** 201 Created
```json
{
  "subscription": {
    "id": "uuid",
    "follower_id": "uuid",
    "following_id": "uuid",
    "created_at": "2025-12-20T10:30:00Z"
  }
}
```

### DELETE /users/{id}/unsubscribe
Отписаться от пользователя

**Response:** 204 No Content

### GET /users/{id}/followers
Подписчики пользователя

**Response:**
```json
{
  "followers": [
    {
      "user": { "id": "uuid", "name": "John Doe", "avatar_url": "..." },
      "subscribed_at": "2025-11-01T00:00:00Z",
      "is_mutual": true
    }
  ],
  "total": 150
}
```

### GET /users/{id}/following
Подписки пользователя

**Response:**
```json
{
  "following": [
    {
      "user": { "id": "uuid", "name": "Jane Smith", "avatar_url": "..." },
      "subscribed_at": "2025-10-15T00:00:00Z",
      "is_mutual": false
    }
  ],
  "total": 75
}
```

### GET /subscriptions/my/followers
Мои подписчики

**Response:** (аналогично `/users/{id}/followers`)

### GET /subscriptions/my/following
Мои подписки

**Response:** (аналогично `/users/{id}/following`)

### GET /subscriptions/feed
Лента только от подписок (без алгоритма)

**Response:**
```json
{
  "posts": [ /* post objects */ ],
  "total": 250,
  "has_more": true
}
```

### GET /subscriptions/check/{userId}
Проверка подписки на пользователя

**Response:**
```json
{
  "is_subscribed": true,
  "is_mutual": false,
  "subscribed_at": "2025-11-01T00:00:00Z"
}
```

---

## 16. Chats (Чаты) - v2.0 🆕

### GET /chats
Список чатов пользователя

**Response:**
```json
{
  "chats": [
    {
      "id": "uuid",
      "participant": { "id": "uuid", "name": "Jane Smith", "avatar_url": "..." },
      "last_message": {
        "text": "Спасибо!",
        "type": "text",
        "sender_id": "uuid",
        "created_at": "2025-12-20T15:30:00Z"
      },
      "unread_count": 2,
      "is_pinned": false,
      "updated_at": "2025-12-20T15:30:00Z"
    }
  ],
  "total": 15
}
```

### POST /chats
Создать чат

**Request:**
```json
{
  "participant_id": "uuid"
}
```

**Response:** 201 Created

### GET /chats/{id}/messages
Сообщения чата с пагинацией

**Query Parameters:**
```
?page=1&limit=50&before_id=uuid
```

**Response:**
```json
{
  "messages": [
    {
      "id": "uuid",
      "chat_id": "uuid",
      "sender_id": "uuid",
      "type": "text",
      "content": {
        "text": "Привет! Можно записаться?"
      },
      "status": "read",
      "created_at": "2025-12-20T14:00:00Z",
      "updated_at": "2025-12-20T14:05:00Z"
    },
    {
      "id": "uuid2",
      "type": "image",
      "content": {
        "url": "https://cdn.service.com/chat/image1.jpg",
        "thumbnail_url": "https://cdn.service.com/chat/image1_thumb.jpg"
      },
      "status": "delivered",
      "created_at": "2025-12-20T14:10:00Z"
    }
  ],
  "total": 150,
  "has_more": true
}
```

### POST /chats/{id}/messages
Отправить сообщение (8 типов)

**Request (text):**
```json
{
  "type": "text",
  "content": {
    "text": "Привет!"
  }
}
```

**Request (image):**
```json
{
  "type": "image",
  "content": {
    "file_id": "uuid"
  }
}
```

**Request (location):**
```json
{
  "type": "location",
  "content": {
    "lat": 55.7558,
    "lon": 37.6173,
    "address": "Москва, ул. Тверская, 1"
  }
}
```

**Request (booking):**
```json
{
  "type": "booking",
  "content": {
    "booking_id": "uuid"
  }
}
```

**Request (service):**
```json
{
  "type": "service",
  "content": {
    "service_id": "uuid"
  }
}
```

**Response:** 201 Created

### PUT /messages/{id}
Редактировать сообщение (только text, в течение 15 минут)

**Request:**
```json
{
  "text": "Исправленный текст"
}
```

**Response:** 200 OK

### DELETE /messages/{id}
Удалить сообщение

**Query Parameters:**
```
?for_everyone=false
```

**Response:** 204 No Content

### PUT /messages/{id}/read
Отметить сообщение прочитанным

**Response:** 200 OK

### POST /chats/{id}/pin
Закрепить чат

**Response:** 200 OK

### DELETE /chats/{id}/pin
Открепить чат

**Response:** 200 OK

### POST /chats/search
Поиск чатов и сообщений

**Request:**
```json
{
  "query": "маникюр",
  "search_in": ["messages", "contacts"]
}
```

**Response:**
```json
{
  "chats": [ /* chat objects */ ],
  "messages": [ /* message objects with context */ ],
  "total": 10
}
```

---

## 17. Notifications (Уведомления) - v2.0 🆕

### GET /notifications
Список уведомлений (11 типов)

**Response:**
```json
{
  "notifications": [
    {
      "id": "uuid",
      "type": "new_follower",
      "title": "Новый подписчик",
      "message": "Anna Ivanova подписалась на вас",
      "data": {
        "user_id": "uuid",
        "user_name": "Anna Ivanova",
        "user_avatar_url": "..."
      },
      "is_read": false,
      "created_at": "2025-12-20T10:00:00Z"
    },
    {
      "id": "uuid2",
      "type": "post_like",
      "title": "Новый лайк",
      "message": "John Doe лайкнул ваш пост",
      "data": {
        "user_id": "uuid",
        "post_id": "uuid",
        "post_thumbnail_url": "..."
      },
      "is_read": false,
      "created_at": "2025-12-20T09:30:00Z"
    },
    {
      "id": "uuid3",
      "type": "review_required",
      "title": "Требуется отзыв",
      "message": "Оставьте отзыв о записи у Anna Ivanova",
      "data": {
        "booking_id": "uuid",
        "master_name": "Anna Ivanova",
        "service": "Маникюр"
      },
      "is_read": false,
      "priority": "high",
      "created_at": "2025-12-20T09:00:00Z"
    }
  ],
  "total": 25,
  "unread_count": 15
}
```

### GET /notifications/unread-count
Счетчик непрочитанных уведомлений

**Response:**
```json
{
  "unread_count": 15,
  "by_type": {
    "new_follower": 3,
    "friend_request": 2,
    "post_like": 5,
    "post_comment": 3,
    "chat_message": 2
  }
}
```

### PUT /notifications/{id}/read
Отметить уведомление прочитанным

**Response:** 200 OK

### PUT /notifications/read-all
Прочитать все уведомления

**Response:** 200 OK

### DELETE /notifications/{id}
Удалить уведомление

**Response:** 204 No Content

### DELETE /notifications/clear
Очистить все прочитанные уведомления

**Response:** 204 No Content

### POST /notifications/settings
Настройки уведомлений

**Request:**
```json
{
  "push_enabled": true,
  "email_enabled": false,
  "types": {
    "new_follower": true,
    "friend_request": true,
    "post_like": false,
    "post_comment": true,
    "chat_message": true,
    "booking_confirmed": true,
    "booking_reminder": true,
    "review_required": true,
    "auto_proposal": true,
    "system": true
  },
  "quiet_hours": {
    "enabled": true,
    "start": "22:00",
    "end": "08:00"
  }
}
```

**Response:** 200 OK

---

## 18. Favorites (Избранное) - v2.0 🆕

### POST /favorites/masters/{id}
Добавить мастера в избранное

**Response:** 201 Created

### DELETE /favorites/masters/{id}
Удалить мастера из избранного

**Response:** 204 No Content

### GET /favorites/masters
Избранные мастера

**Response:**
```json
{
  "masters": [ /* master objects */ ],
  "total": 15
}
```

### POST /favorites/posts/{id}
Добавить пост в избранное (закладки)

**Response:** 201 Created

### DELETE /favorites/posts/{id}
Удалить пост из избранного

**Response:** 204 No Content

### GET /favorites/posts
Избранные посты

**Response:**
```json
{
  "posts": [ /* post objects */ ],
  "total": 42
}
```

### GET /favorites/check/master/{id}
Проверка, в избранном ли мастер

**Response:**
```json
{
  "is_favorite": true,
  "added_at": "2025-11-01T00:00:00Z"
}
```

### GET /favorites/check/post/{id}
Проверка, в избранном ли пост

**Response:**
```json
{
  "is_favorite": false
}
```

---

## 19. Settings (Настройки) - v2.0 🆕

### GET /settings
Настройки пользователя

**Response:**
```json
{
  "user_id": "uuid",
  "privacy": {
    "profile_visibility": "public",
    "show_location": true,
    "allow_friend_requests": true,
    "allow_messages_from": "everyone"
  },
  "notifications": {
    "push_enabled": true,
    "email_enabled": true,
    "types": { /* см. POST /notifications/settings */ }
  },
  "feed_filters": {
    "preferred_categories": ["uuid1", "uuid2"],
    "hide_categories": [],
    "show_only_followed": false
  },
  "auto_proposals": {
    "enabled": true,
    "max_distance_km": 10,
    "price_range": { "min": 1000, "max": 5000 },
    "blacklist_master_ids": ["uuid1"]
  }
}
```

### PUT /settings
Обновить настройки

**Request:**
```json
{
  "privacy": {
    "profile_visibility": "friends_only"
  }
}
```

**Response:** 200 OK

### PUT /settings/auto-proposals
Настройки автопредложений (только премиум)

**Request:**
```json
{
  "enabled": true,
  "max_distance_km": 15,
  "price_range": { "min": 1500, "max": 8000 },
  "preferred_categories": ["uuid1", "uuid2"],
  "preferred_time_slots": ["morning", "afternoon"]
}
```

**Response:** 200 OK или 403 Forbidden (не премиум)

### POST /settings/auto-proposals/blacklist
Добавить мастера в черный список автопредложений

**Request:**
```json
{
  "master_id": "uuid"
}
```

**Response:** 201 Created

### DELETE /settings/auto-proposals/blacklist/{masterId}
Убрать мастера из черного списка

**Response:** 204 No Content

### PUT /settings/feed-filters
Сохранить фильтры ленты

**Request:**
```json
{
  "preferred_categories": ["uuid1", "uuid2"],
  "hide_categories": ["uuid3"],
  "show_only_followed": false
}
```

**Response:** 200 OK

---

## 20. Auto Bookings (Автопредложения) - v2.0 🆕

**Премиум-функция:** Все endpoints доступны только для пользователей с премиум-подпиской.

### GET /auto-bookings/settings
Настройки автопредложений для мастера

**Response:**
```json
{
  "settings": [
    {
      "id": "uuid",
      "service_id": "uuid",
      "max_distance_km": 20,
      "min_price": 2000,
      "preferred_client_types": ["new", "returning"],
      "auto_accept": false,
      "is_active": true
    }
  ]
}
```

### POST /auto-bookings/settings
Создать настройку автопредложения

**Request:**
```json
{
  "service_id": "uuid",
  "max_distance_km": 20,
  "min_price": 2000,
  "preferred_client_types": ["new"],
  "auto_accept": false
}
```

**Response:** 201 Created

### PUT /auto-bookings/settings/{id}
Обновить настройку

**Request:**
```json
{
  "max_distance_km": 25,
  "is_active": false
}
```

**Response:** 200 OK

### DELETE /auto-bookings/settings/{id}
Удалить настройку

**Response:** 204 No Content

### POST /auto-bookings/propose/{clientId}
Предложить запись клиенту вручную

**Request:**
```json
{
  "service_id": "uuid",
  "proposed_slots": [
    "2025-12-25T10:00:00Z",
    "2025-12-25T14:00:00Z"
  ],
  "message": "Привет! У меня есть свободное время, хотите записаться?"
}
```

**Response:** 201 Created
```json
{
  "proposal": {
    "id": "uuid",
    "client_id": "uuid",
    "master_id": "uuid",
    "service_id": "uuid",
    "proposed_slots": [ /* slots */ ],
    "status": "pending",
    "match_percentage": 85,
    "created_at": "2025-12-20T10:00:00Z"
  }
}
```

### GET /auto-bookings/history
История автопредложений

**Response:**
```json
{
  "proposals": [
    {
      "id": "uuid",
      "client": { "id": "uuid", "name": "John Doe" },
      "service": { "id": "uuid", "name": "Маникюр" },
      "match_percentage": 92,
      "status": "accepted",
      "created_at": "2025-12-15T10:00:00Z",
      "accepted_at": "2025-12-15T11:30:00Z"
    },
    {
      "id": "uuid2",
      "client": { "id": "uuid", "name": "Jane Smith" },
      "match_percentage": 78,
      "status": "rejected",
      "created_at": "2025-12-14T14:00:00Z"
    }
  ],
  "stats": {
    "total_proposals": 50,
    "accepted": 25,
    "rejected": 15,
    "pending": 10,
    "conversion_rate": 50
  }
}
```

---

## 🔄 WebSocket Events v2.0

**WebSocket URL:** `wss://api.serviceplatform.com/ws`

**Аутентификация:** JWT token в query параметре при подключении:
```
wss://api.serviceplatform.com/ws?token={access_token}
```

### События от клиента

#### typing:start
Пользователь начал печатать
```json
{
  "event": "typing:start",
  "data": {
    "chat_id": "uuid"
  }
}
```

#### typing:stop
Пользователь прекратил печатать
```json
{
  "event": "typing:stop",
  "data": {
    "chat_id": "uuid"
  }
}
```

#### message:read
Прочитать сообщение
```json
{
  "event": "message:read",
  "data": {
    "message_id": "uuid"
  }
}
```

### События от сервера

#### message:new
Новое сообщение в чате
```json
{
  "event": "message:new",
  "data": {
    "chat_id": "uuid",
    "message": { /* message object */ }
  }
}
```

#### message:delivered
Сообщение доставлено получателю
```json
{
  "event": "message:delivered",
  "data": {
    "message_id": "uuid",
    "chat_id": "uuid",
    "delivered_at": "2025-12-20T10:30:00Z"
  }
}
```

#### message:read
Сообщение прочитано получателем
```json
{
  "event": "message:read",
  "data": {
    "message_id": "uuid",
    "chat_id": "uuid",
    "read_at": "2025-12-20T10:31:00Z"
  }
}
```

#### typing:indicator
Индикатор печатания
```json
{
  "event": "typing:indicator",
  "data": {
    "chat_id": "uuid",
    "user_id": "uuid",
    "is_typing": true
  }
}
```

#### notification:new
Новое уведомление
```json
{
  "event": "notification:new",
  "data": {
    "notification": { /* notification object */ }
  }
}
```

#### user:online
Пользователь онлайн
```json
{
  "event": "user:online",
  "data": {
    "user_id": "uuid"
  }
}
```

#### user:offline
Пользователь оффлайн
```json
{
  "event": "user:offline",
  "data": {
    "user_id": "uuid",
    "last_seen": "2025-12-20T10:30:00Z"
  }
}
```

---

## 📋 Особенности v2.0

### 1. Блокировка создания записей без отзыва

При попытке создать новую запись без завершения предыдущих отзывов:

**Response 403:**
```json
{
  "error": {
    "code": "PENDING_REVIEWS",
    "message": "You cannot create a new booking until you leave pending reviews",
    "pending_reviews": [
      {
        "booking_id": "uuid",
        "master_name": "Anna Ivanova",
        "service": "Маникюр",
        "completed_at": "2025-12-18T14:00:00Z",
        "days_overdue": 2
      }
    ]
  }
}
```

### 2. Ограничение репостов

Репостнуть можно только если:
- Пост публичный
- Вы упомянуты в посте (для приватных)
- Вы подписаны на автора

**Response 403:**
```json
{
  "error": {
    "code": "CANNOT_REPOST",
    "message": "You cannot repost this post"
  }
}
```

### 3. Автопредложения только для премиум

**Response 403:**
```json
{
  "error": {
    "code": "PREMIUM_REQUIRED",
    "message": "Auto-booking proposals are only available for premium users"
  }
}
```

### 4. Rate Limiting по типам запросов

| Группа | Лимит | Окно |
|--------|-------|------|
| Общий | 100 req | 1 минута |
| Auth (login/register) | 20 req | 1 минута |
| Posts создание | 10 req | 1 час |
| Comments | 50 req | 1 минута |
| Likes | 100 req | 1 минута |
| WebSocket messages | 100 msg | 1 минута |

---

## Связанные документы

- [BRD v2.0](../business/BRD.md) - Бизнес-требования
- [Requirements v2.0](../business/Requirements.md) - Функциональные требования
- [User Stories v2.0](../business/UserStories.md) - Пользовательские истории
- [Database Schema v2.0](./Database.md) - Схема базы данных (29 таблиц)
- [Technical Specification v2.0](./TechSpec.md) - Техническое задание
- [Test Plan v2.0](../testing/TestPlan.md) - План тестирования

---

**Статус:** Утверждён v2.0
**Последнее обновление:** Декабрь 2025
**Общее количество endpoints:** 165 (95 v1.0 + 70 v2.0)
