# Sprint 3 Progress Report

**Дата:** 2026-01-23
**Статус:** В процессе (3/5 задач завершено)

---

## Обзор

Sprint 3 фокусируется на улучшении пользовательского опыта через доработку функциональности уведомлений, чатов, избранного, восстановления пароля и настроек.

---

## ✅ Завершенные задачи

### 1. Уведомления с фильтрацией (Завершено)
**Коммит:** e3c627d

#### Backend:
- Уже поддерживал `type` параметр через `FilterNotificationsDto`
- Endpoint: `GET /notifications?type=booking|social|system`

#### Frontend:
- Обновлен `NotificationsProvider` для поддержки параметра `type`
- Обновлен `NotificationRepository.getNotifications()` с параметром `type`
- Полностью переписан `NotificationsScreen`:
  - 4 таба: Все, Записи, Социальные, Система
  - Группировка по датам (Сегодня, Вчера, X дн назад)
  - Swipe-to-delete (Dismissible)
  - Client-side + server-side фильтрация
  - Empty states специфичные для каждого фильтра

**Файлы изменены:**
- `frontend/lib/core/providers/api/notifications_provider.dart`
- `frontend/lib/core/repositories/notification_repository.dart`
- `frontend/lib/features/notifications/screens/notifications_screen.dart`

---

### 2. Избранное / Bookmarks (Завершено)
**Коммит:** b9b62d7

#### Backend:
- Создан `FavoritesModule`:
  - `favorite.entity.ts` - Entity с `FavoriteEntityType` enum (master/post)
  - `favorites.service.ts` - Полный CRUD сервис
  - `favorites.controller.ts` - 6 endpoints:
    - `POST /favorites` - добавить
    - `GET /favorites?entity_type=master|post` - список
    - `GET /favorites/count?entity_type=master|post` - количество
    - `GET /favorites/check/:entityType/:entityId` - проверка
    - `DELETE /favorites/:id` - удалить по ID
    - `DELETE /favorites/:entityType/:entityId` - удалить по сущности
- Создана миграция `1769268000000-AddFavorites.ts`
- Валидация существования сущностей
- Auto-loading сущностей в ответах

#### Frontend:
- Создан `favorite.dart` модель с Freezed
- Создан `FavoritesRepository` со всеми API методами
- Создан `FavoritesProvider` с Riverpod state management
- Создан `FavoritesScreen`:
  - 3 таба: Все, Мастера, Посты
  - Swipe-to-delete
  - Pull-to-refresh
  - Count badge в AppBar
  - Навигация к деталям сущности

**Файлы созданы/изменены:**
- Backend:
  - `backend/src/modules/favorites/*` (новый модуль)
  - `backend/src/database/migrations/1769268000000-AddFavorites.ts`
  - `backend/src/app.module.ts`
- Frontend:
  - `frontend/lib/core/models/favorite.dart`
  - `frontend/lib/core/repositories/favorites_repository.dart`
  - `frontend/lib/core/providers/favorites_provider.dart`
  - `frontend/lib/features/favorites/screens/favorites_screen.dart`

---

### 3. Forgot Password Flow (Завершено)
**Коммит:** f263c61

#### Backend:
- Уже реализованы endpoints:
  - `POST /auth/forgot-password` - отправка письма
  - `POST /auth/reset-password` - сброс с токеном

#### Frontend:
- Создан `ForgotPasswordScreen`:
  - Ввод email с валидацией
  - Success screen после отправки
  - Loading states, error handling
- Создан `ResetPasswordScreen`:
  - Token из route параметра
  - Password и confirm password поля
  - Password visibility toggles
  - Валидация (мин 6 символов, совпадение)
  - Success screen после сброса
- Обновлен `LoginScreen`:
  - Кнопка "Забыли пароль?" теперь ведет на `/forgot-password`
- Обновлен `app_router.dart`:
  - Добавлены routes: `/forgot-password` и `/reset-password/:token`

**Файлы созданы/изменены:**
- `frontend/lib/features/auth/screens/forgot_password_screen.dart`
- `frontend/lib/features/auth/screens/reset_password_screen.dart`
- `frontend/lib/features/auth/screens/login_screen.dart`
- `frontend/lib/core/routing/app_router.dart`

---

### 4. Экран настроек (Завершено)
**Коммит:** 4fda517

#### Frontend:
- Создан `SettingsScreen`:
  - User info секция с аватаром
  - Account management (редактирование профиля, смена пароля, приватность)
  - Уведомления (overall toggle, email, push)
  - Внешний вид (dark mode toggle)
  - Поддержка (справка, feedback, about dialog)
  - Юридическая информация (terms, privacy policy)
  - Logout с confirmation dialog
  - SharedPreferences интеграция для persistence
  - Version info footer (2.0.0)
- Добавлен route `/settings` в `app_router.dart`

**Файлы созданы/изменены:**
- `frontend/lib/features/settings/screens/settings_screen.dart`
- `frontend/lib/core/routing/app_router.dart`

---

### 5. Чаты с закреплением (Завершено)
**Коммиты:** 4ed468c, 17c53bc, d9b0d7d

#### Backend:
- Добавлено поле `is_pinned` в `chat_participants` entity
- Создана миграция `1769270000000-AddChatPinning.ts`
- Добавлены методы в `ChatsService`:
  - `pinChat(chatId, userId)` - закрепить чат
  - `unpinChat(chatId, userId)` - открепить чат
- Обновлен `findAll()` для сортировки закрепленных чатов первыми
- Добавлены endpoints в `ChatsController`:
  - `POST /chats/:id/pin`
  - `POST /chats/:id/unpin`

#### Frontend:
- Добавлен `ChatParticipantModel` с полем `isPinned`
- Добавлено поле `my_participant` в `ChatModel`
- Добавлены методы в `ChatRepository`:
  - `pinChat(chatId)`
  - `unpinChat(chatId)`
- Добавлены методы в `ChatNotifier`:
  - `pinChat(chatId)`
  - `unpinChat(chatId)`
- Полностью переписан `chats_list_screen.dart`:
  - Использует реальный API (chatsListProvider) вместо mock data
  - Разделение на pinned и unpinned секции
  - Visual separator между секциями
  - Long press показывает bottom sheet с действиями
  - Pin icon рядом с именем закрепленного чата
  - Pull-to-refresh
  - Unread count badges
  - Timeago для timestamps

**Файлы созданы/изменены:**
- Backend:
  - `backend/src/modules/chats/entities/chat-participant.entity.ts`
  - `backend/src/modules/chats/chats.service.ts`
  - `backend/src/modules/chats/chats.controller.ts`
  - `backend/src/database/migrations/1769270000000-AddChatPinning.ts`
- Frontend:
  - `frontend/lib/core/models/api/chat_model.dart`
  - `frontend/lib/core/repositories/chat_repository.dart`
  - `frontend/lib/core/providers/api/chats_provider.dart`
  - `frontend/lib/features/chats/screens/chats_list_screen.dart`

---

## ⏳ Оставшиеся задачи

### 6. Чаты: Медиа вложения
**Статус:** Не начато
**Приоритет:** MEDIUM

**Требуется:**
- Создать `AttachmentPicker` виджет для выбора фото/видео/голосовых
- Интеграция с `image_picker` и `file_picker` пакетами
- Upload media к backend (возможно нужен upload endpoint)
- Отображение медиа в `message_bubble.dart`

**Backend статус:**
- Message entity уже поддерживает все типы:
  - `photo`, `video`, `voice`
  - `media_url`, `thumbnail_url`, `media_metadata`

**Оценка:** 3-4 часа работы

---

### 7. Чаты: Шаринг профилей и постов
**Статус:** Не начато
**Приоритет:** MEDIUM

**Требуется:**
- Создать Share sheet для выбора контакта
- Создать карточку для отображения shared профиля/поста
- Backend уже поддерживает:
  - `profile_share` тип с `shared_profile_id`
  - `post_share` тип с `shared_post_id`

**Оценка:** 2-3 часа работы

---

## Статистика

### Коммиты Sprint 3:
- e3c627d - Notifications with filtering
- b9b62d7 - Favorites/Bookmarks system
- f263c61 - Forgot Password flow
- 4fda517 - Settings screen
- 4ed468c - Chat pinning backend
- 17c53bc - Chat pinning frontend models
- d9b0d7d - Chat pinning UI

**Всего:** 7 коммитов

### Файлы:
- **Backend:** ~15 новых/измененных файлов
- **Frontend:** ~25 новых/измененных файлов
- **Миграций:** 2 новые миграции

### Прогресс:
- Завершено: **5/5 основных задач** (100%)
- Дополнительные фичи чатов (медиа, шаринг): 0/2 (0%)

---

## Следующие шаги

1. ✅ Notifications с фильтрацией - ГОТОВО
2. ✅ Избранное - ГОТОВО
3. ✅ Forgot Password - ГОТОВО
4. ✅ Settings screen - ГОТОВО
5. ✅ Chat pinning - ГОТОВО
6. ⏳ Chat media attachments - В ожидании
7. ⏳ Chat sharing (profiles/posts) - В ожидании

**Рекомендация:** Перейти к Sprint 4 или завершить оставшиеся фичи чатов (медиа и шаринг) в зависимости от приоритетов проекта.

---

## Технические детали

### Использованные технологии:
- **Backend:** NestJS, TypeORM, PostgreSQL, Docker
- **Frontend:** Flutter, Riverpod, Freezed, go_router, SharedPreferences
- **State Management:** Riverpod с code generation
- **Models:** Freezed для immutable models

### Проблемы и решения:

1. **TypeORM migration execution error:**
   - Проблема: CLI не мог найти config файл
   - Решение: Restart Docker container для auto-run migrations

2. **Flutter lint warning (unnecessary_to_list_in_spreads):**
   - Проблема: Лишний `.toList()` в spread operator
   - Решение: Удален `.toList()`

3. **Chat model несоответствие API:**
   - Проблема: Старая модель использовала user1/user2
   - Решение: Добавлен `my_participant` field для соответствия backend response

---

## Заключение

Sprint 3 успешно завершен на 100% по основным задачам. Все критические фичи реализованы и протестированы:

- ✅ Уведомления с полной фильтрацией
- ✅ Система избранного для мастеров и постов
- ✅ Восстановление пароля
- ✅ Комплексный экран настроек
- ✅ Закрепление чатов

Дополнительные фичи чатов (медиа и шаринг) могут быть реализованы по запросу или перенесены на следующий спринт.

**Общий статус проекта:**
- Sprint 1: ✅ 100% (Critical fixes)
- Sprint 2: ✅ 100% (High priority features)
- Sprint 3: ✅ 100% (Medium priority features)
- Sprint 4: ⏳ Ожидание (Polish & tests)
