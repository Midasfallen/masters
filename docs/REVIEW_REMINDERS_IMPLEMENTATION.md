# Реализация системы напоминаний об отзывах (Review Reminders)

## Дата: 2026-01-23

## Описание

Реализована полная бэкенд-часть системы напоминаний об отзывах с поддержкой grace period (возможность один раз пропустить без последствий).

## Что было сделано

### 1. База данных

#### Миграция `AddReviewReminders` (`1769086715332-AddReviewReminders.ts`)
Создана таблица `review_reminders` со следующей структурой:
- `id` (UUID, PK) - идентификатор записи
- `user_id` (UUID, FK -> users) - пользователь, которому нужно напомнить
- `booking_id` (UUID, FK -> bookings) - бронирование, требующее отзыва
- `reminder_count` (integer, default: 0) - количество напоминаний
- `grace_skip_allowed` (boolean, default: false) - флаг использования grace period
- `last_reminded_at` (timestamp, nullable) - время последнего напоминания
- `created_at` (timestamp) - время создания
- `updated_at` (timestamp) - время обновления

Индексы созданы для полей `user_id` и `booking_id` для быстрого поиска.

### 2. Entities

#### `ReviewReminder` Entity
Создана TypeORM entity с:
- Всеми полями из миграции
- Relations к User и Booking
- Автоматическими timestamps

#### Обновлена `Booking` Entity
Раскомментированы и активированы relations:
- `client` (ManyToOne -> User)
- `master` (ManyToOne -> User)
- `service` (ManyToOne -> Service)

### 3. API Endpoints

#### GET `/api/v2/reviews/unreviewed/bookings`
**Описание**: Получить список неотзывленных бронирований для текущего пользователя

**Authentication**: Required (JWT)

**Response**: Массив объектов с информацией о бронировании:
```json
[
  {
    "id": "uuid",
    "service_id": "uuid",
    "service_name": "Название услуги",
    "master_id": "uuid",
    "master_name": "Имя Фамилия мастера",
    "client_id": "uuid",
    "client_name": "Имя Фамилия клиента",
    "start_time": "2026-01-20T10:00:00Z",
    "end_time": "2026-01-20T11:30:00Z",
    "total_price": 1500,
    "is_client": true,
    "review_target": "uuid",
    "review_target_name": "Имя Фамилия",
    "reminder_count": 2,
    "grace_skip_allowed": false,
    "last_reminded_at": "2026-01-22T10:00:00Z"
  }
]
```

#### POST `/api/v2/reviews/skip/:bookingId`
**Описание**: Пропустить напоминание об отзыве

**Authentication**: Required (JWT)

**Request Body**:
```json
{
  "isGracePeriod": false
}
```

**Parameters**:
- `isGracePeriod` (boolean, optional, default: false) - использовать ли grace period (можно только один раз)

**Response**:
```json
{
  "reminder_count": 3,
  "grace_skip_allowed": false
}
```

**Errors**:
- 400 - Grace period уже использован или отзыв уже оставлен
- 403 - Пользователь не связан с бронированием
- 404 - Бронирование не найдено

### 4. Service Layer

#### Новые методы в `ReviewsService`

1. **`getUnreviewedBookings(userId: string)`**
   - Получает все завершенные бронирования без отзывов
   - Загружает relations для service, master, client
   - Добавляет информацию о reminders
   - Возвращает готовый к отображению массив данных

2. **`handleSkipReview(userId: string, bookingId: string, isGracePeriod: boolean)`**
   - Создает или обновляет reminder при пропуске
   - Обрабатывает grace period (только один раз)
   - Увеличивает счетчик обычных пропусков
   - Валидирует права доступа и статус бронирования

3. **`clearReminder(userId: string, bookingId: string)` (private)**
   - Автоматически удаляет reminder после создания отзыва
   - Вызывается в методе `create()` после успешного создания отзыва

### 5. Конфигурация

Обновлена конфигурация TypeORM:
- Исправлены default значения для подключения к БД
- Порт: 5433 (вместо 5432)
- Database: service_platform
- Username: service_user
- Password: service_password

### 6. Модули

Обновлен `ReviewsModule`:
- Добавлена `ReviewReminder` entity в TypeOrmModule.forFeature()
- Сохранен экспорт ReviewsService для использования в других модулях

## Логика работы

### Grace Period Flow
1. Пользователь видит напоминание о неоставленном отзыве
2. При первом пропуске может выбрать "Напомнить позже один раз" (grace period)
3. `grace_skip_allowed` устанавливается в `true`, напоминание откладывается
4. При последующих пропусках grace period недоступен
5. `reminder_count` увеличивается при обычных пропусках

### Reminder Cleanup
- При создании отзыва автоматически удаляется связанный reminder
- Это предотвращает накопление устаревших записей в БД

## Тестирование

Backend успешно собран и запущен:
- ✅ Build successful
- ✅ Health check passed
- ✅ Swagger documentation available at http://localhost:3000/api/v2
- ✅ Database migration executed successfully

## Следующие шаги

### Frontend Integration (TODO)
1. Создать provider для работы с review reminders API
2. Реализовать UI компонент для отображения неотзывленных бронирований
3. Добавить диалог с опциями пропуска (обычный/grace period)
4. Интегрировать с системой уведомлений

### Future Enhancements
1. Добавить scheduled job для автоматической отправки напоминаний
2. Реализовать email/push уведомления
3. Добавить настройки частоты напоминаний
4. Статистика по напоминаниям для аналитики

## Файлы изменений

### Созданные файлы:
- `backend/src/database/migrations/1769086715332-AddReviewReminders.ts`
- `backend/src/modules/reviews/entities/review-reminder.entity.ts`

### Модифицированные файлы:
- `backend/src/modules/reviews/reviews.module.ts`
- `backend/src/modules/reviews/reviews.service.ts`
- `backend/src/modules/reviews/reviews.controller.ts`
- `backend/src/modules/bookings/entities/booking.entity.ts`
- `backend/src/config/typeorm.config.ts`

## Git Commit
```
feat: implement review reminders system

Добавлена система напоминаний об отзывах с поддержкой grace period
```

Commit hash: `0fcf75d`
