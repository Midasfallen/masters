# E2E Тестирование Backend

## Требования

E2E тесты выполняются **против запущенного Docker контейнера**, а не создают собственный экземпляр приложения.

### Перед запуском тестов:
1. Убедитесь, что Docker контейнеры запущены:
   ```bash
   docker-compose up -d
   ```
2. Проверьте, что backend доступен:
   ```bash
   curl http://localhost:3000/api/v2/admin/health
   ```

## Запуск тестов

```bash
# Все E2E тесты
npm run test:e2e

# Конкретный модуль
npm run test:e2e -- --testPathPattern="chats"
npm run test:e2e -- --testPathPattern="notifications"
npm run test:e2e -- --testPathPattern="reviews"

# С подробным выводом
npm run test:e2e -- --testPathPattern="chats" --verbose
```

## Важные особенности API

### Формат ответов

API возвращает данные в **camelCase**:
- `accessToken` (не `access_token`)
- `refreshToken` (не `refresh_token`)
- `firstName` (не `first_name`)

### Пагинация

Пагинированные ответы имеют структуру:
```json
{
  "data": [...],
  "meta": {
    "total": 10,
    "page": 1,
    "limit": 20,
    "totalPages": 1
  }
}
```

### Создание чата

```typescript
// ПРАВИЛЬНО:
{
  type: 'direct',           // или 'group'
  participant_ids: ['uuid'] // массив UUID
}

// НЕПРАВИЛЬНО:
{
  chat_type: 'direct',      // НЕ используется
  participant_id: 'uuid'    // НЕ используется (единственное число)
}
```

### Регистрация пользователя

Запрос использует **snake_case**:
```typescript
{
  email: 'test@example.com',
  password: 'Password123',
  first_name: 'Test',     // snake_case
  last_name: 'User'       // snake_case
}
```

Ответ использует **camelCase**:
```typescript
{
  accessToken: '...',      // camelCase
  refreshToken: '...',
  user: {
    id: 'uuid',
    firstName: 'Test',     // camelCase
    lastName: 'User'
  }
}
```

## Переменные окружения

| Переменная | По умолчанию | Описание |
|------------|--------------|----------|
| API_URL | http://localhost:3000/api/v2 | Базовый URL API |

## Структура тестов

```
test/
├── chats.e2e-spec.ts       # Тесты чатов
├── notifications.e2e-spec.ts # Тесты уведомлений
├── reviews.e2e-spec.ts     # Тесты отзывов
├── auth.e2e-spec.ts        # Тесты авторизации
├── posts.e2e-spec.ts       # Тесты постов
├── bookings.e2e-spec.ts    # Тесты бронирований
├── admin.e2e-spec.ts       # Тесты админки
├── jest-e2e.json           # Конфигурация Jest
└── README.md               # Эта документация
```

## Типичные ошибки

### "relation users does not exist"
База данных не инициализирована. Запустите backend и дождитесь синхронизации схемы.

### 401 Unauthorized на авторизованных эндпоинтах
Проверьте, что `accessToken` получен корректно (camelCase, не snake_case).

### 400 Bad Request при создании чата
Проверьте формат данных: `type` + `participant_ids` (массив).
