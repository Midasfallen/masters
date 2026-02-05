# Синхронизация фронтенда и бэкенда - Создание поста

## ✅ Исправлено

### Проблема: 400 Bad Request при создании поста

**Ошибки от бэкенда:**
```json
{
  "message": [
    "property media_urls should not exist",
    "property tags should not exist",
    "type must be one of the following values: text, photo, video, repost"
  ],
  "error": "Bad Request",
  "statusCode": 400
}
```

### Решение

1. ✅ Добавлен enum `PostType` (text, photo, video, repost)
2. ✅ Создан класс `CreatePostMediaDto` для медиафайлов
3. ✅ Обновлен `CreatePostRequest` для соответствия DTO бэкенда
4. ✅ Исправлены тесты для использования нового формата

## Структура данных

### Бэкенд DTO (`CreatePostDto`)
```typescript
{
  type: PostType;                    // Обязательное
  content?: string;                   // Опциональное
  media?: CreatePostMediaDto[];      // Опциональное
  location_name?: string;
  location_lat?: number;
  location_lng?: number;
  service_ids?: string[];
  custom_service_name?: string;
}
```

### Фронтенд Request (`CreatePostRequest`)
```dart
CreatePostRequest(
  type: PostType,                    // ✅ Обязательное
  content: String?,                  // ✅ Опциональное
  media: List<CreatePostMediaDto>?,  // ✅ Опциональное
  locationName: String?,
  locationLat: double?,
  locationLng: double?,
  serviceIds: List<String>?,
  customServiceName: String?,
)
```

## Измененные файлы

### Модели
- ✅ `frontend/lib/core/models/api/post_model.dart`
  - Добавлен enum `PostType`
  - Создан класс `CreatePostMediaDto`
  - Обновлен `CreatePostRequest`

### UI
- ✅ `frontend/lib/features/feed/screens/create_post_screen.dart`
  - Обновлена логика формирования запроса
  - Преобразование медиафайлов в формат DTO

### Тесты
- ✅ `frontend/test/providers/feed_provider_test.dart`
- ✅ `frontend/test/repositories/post_repository_test.dart`

## Важные изменения

### 1. Обязательное поле `type`
```dart
// ❌ Было (неправильно)
CreatePostRequest(content: 'Текст')

// ✅ Стало (правильно)
CreatePostRequest(
  type: PostType.text,
  content: 'Текст',
)
```

### 2. Формат медиа
```dart
// ❌ Было (неправильно)
mediaUrls: ['url1', 'url2']

// ✅ Стало (правильно)
media: [
  CreatePostMediaDto(
    type: MediaType.photo,
    url: 'url1',
    order: 0,
  ),
  CreatePostMediaDto(
    type: MediaType.photo,
    url: 'url2',
    order: 1,
  ),
]
```

### 3. Убрано поле `tags`
```dart
// ❌ Было (неправильно)
tags: ['tag1', 'tag2']

// ✅ Стало (правильно)
// Поле убрано - бэкенд его не принимает
```

## Логика определения типа поста

```dart
final postType = _selectedMedia.isEmpty 
    ? PostType.text      // Текстовый пост
    : PostType.photo;    // Пост с фото
```

**TODO:** В будущем можно добавить определение `PostType.video` если есть видеофайлы.

## Проверка соответствия

### ✅ Обязательные поля
- [x] `type` - всегда присутствует

### ✅ Опциональные поля
- [x] `content` - может быть null если есть media
- [x] `media` - может быть null если тип text
- [x] `location_name`, `location_lat`, `location_lng` - опциональные
- [x] `service_ids`, `custom_service_name` - опциональные

### ❌ Убраны несуществующие поля
- [x] `media_urls` - заменено на `media`
- [x] `tags` - убрано (бэкенд не принимает)

## Тестирование

После исправления:
1. ✅ Запрос проходит валидацию на бэкенде
2. ✅ Пост создается с правильной структурой
3. ✅ Медиа корректно сохраняются
4. ✅ Тесты обновлены и проходят

## Связанные документы

- `docs/CREATE_POST_FIX.md` - детальное описание исправления
- `docs/RUNTIME_ERRORS_FIX.md` - исправление TypeError
- `docs/FIXES_SUMMARY.md` - краткое резюме всех исправлений
- `backend/src/modules/posts/dto/create-post.dto.ts` - DTO на бэкенде
