# Database Agent - Шаблон промпта

## Использование

Скопируйте этот шаблон для делегирования задач по базе данных.

---

## Шаблон

```
[Database Agent] [Название задачи]:

КОНТЕКСТ (обязательно):
- Существующие миграции:
  - [путь к похожей миграции]
- Связанные таблицы:
  - [список таблиц]
- Документация:
  - docs/technical/Database.md

ТРЕБОВАНИЯ:
1. [требование 1]
2. [требование 2]

КРИТЕРИИ ВАЛИДАЦИИ:
- Миграция применяется без ошибок
- Структура БД соответствует требованиям
- Индексы созданы корректно

ОГРАНИЧЕНИЯ:
- Используй snake_case для имен колонок
- Всегда добавляй created_at и updated_at
- Используй UUID для primary keys
```

---

## Примеры

### Создание миграции

```
[Database Agent] Создай миграцию для таблицы notifications:

КОНТЕКСТ:
- Существующие миграции:
  - backend/src/database/migrations/1234567890-CreatePosts.ts
- Связанные таблицы:
  - users (связь через user_id)
  - posts (опциональная связь через post_id)

ТРЕБОВАНИЯ:
1. Таблица notifications с полями:
   - id (UUID, primary key)
   - user_id (UUID, foreign key → users.id)
   - post_id (UUID, nullable, foreign key → posts.id)
   - type (enum: like, comment, follow, etc.)
   - title (varchar 255)
   - content (text, nullable)
   - is_read (boolean, default false)
   - created_at, updated_at
2. Индексы:
   - user_id (для быстрого поиска по пользователю)
   - created_at (для сортировки)
   - is_read (для фильтрации непрочитанных)
3. Foreign key constraints

КРИТЕРИИ ВАЛИДАЦИИ:
- npm run migration:run проходит
- Структура таблицы соответствует требованиям
- Индексы созданы

ОГРАНИЧЕНИЯ:
- Используй snake_case
- Всегда created_at и updated_at
- UUID для primary keys
```
