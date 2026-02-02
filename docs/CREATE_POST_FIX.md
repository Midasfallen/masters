# Исправление создания поста - соответствие с бэкендом

## Проблема

Бэкенд возвращал **400 Bad Request** с ошибками:
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

## Причина

Фронтенд отправлял данные в формате, который не соответствовал DTO бэкенда (`CreatePostDto`).

### Что было неправильно:
1. ❌ Отсутствовало обязательное поле `type: PostType`
2. ❌ Использовалось поле `media_urls` (массив строк) вместо `media` (массив объектов)
3. ❌ Отправлялось поле `tags`, которого нет в DTO бэкенда
4. ❌ `content` был обязательным, хотя на бэкенде он опциональный

## Решение

### 1. Добавлен enum `PostType`
```dart
enum PostType {
  @JsonValue('text')
  text,
  @JsonValue('photo')
  photo,
  @JsonValue('video')
  video,
  @JsonValue('repost')
  repost,
}
```

### 2. Создан `CreatePostMediaDto`
Соответствует `CreatePostMediaDto` на бэкенде:
```dart
@freezed
class CreatePostMediaDto with _$CreatePostMediaDto {
  const factory CreatePostMediaDto({
    required MediaType type,
    required String url,
    @JsonKey(name: 'thumbnail_url') String? thumbnailUrl,
    int? order,
    int? width,
    int? height,
    int? duration,
  }) = _CreatePostMediaDto;
}
```

### 3. Обновлен `CreatePostRequest`
Теперь соответствует DTO бэкенда:
```dart
@freezed
class CreatePostRequest with _$CreatePostRequest {
  const factory CreatePostRequest({
    required PostType type,           // ✅ Обязательное поле
    String? content,                   // ✅ Опциональное
    List<CreatePostMediaDto>? media,   // ✅ Правильный формат
    @JsonKey(name: 'location_name') String? locationName,
    @JsonKey(name: 'location_lat') double? locationLat,
    @JsonKey(name: 'location_lng') double? locationLng,
    @JsonKey(name: 'service_ids') List<String>? serviceIds,
    @JsonKey(name: 'custom_service_name') String? customServiceName,
    // ❌ tags убраны - бэкенд их не принимает
  }) = _CreatePostRequest;
}
```

### 4. Обновлена логика создания поста
В `create_post_screen.dart`:
```dart
// Определяем тип поста
final postType = _selectedMedia.isEmpty 
    ? PostType.text 
    : PostType.photo;

// Upload media files and create media DTOs
final mediaList = <CreatePostMediaDto>[];
for (int i = 0; i < _selectedMedia.length; i++) {
  final file = _selectedMedia[i];
  final url = await uploadPostMediaFromXFile(file);
  
  mediaList.add(CreatePostMediaDto(
    type: MediaType.photo,
    url: url,
    order: i,
  ));
}

// Формируем запрос согласно DTO бэкенда
final request = CreatePostRequest(
  type: postType,
  content: content.isEmpty ? null : content,
  media: mediaList.isNotEmpty ? mediaList : null,
);
```

## Структура данных

### До исправления (неправильно):
```json
{
  "content": "Текст поста",
  "media_urls": ["url1", "url2"],
  "tags": ["tag1", "tag2"]
}
```

### После исправления (правильно):
```json
{
  "type": "photo",
  "content": "Текст поста",
  "media": [
    {
      "type": "photo",
      "url": "https://storage.example.com/posts/photo.jpg",
      "order": 0
    }
  ]
}
```

## Измененные файлы

1. ✅ `frontend/lib/core/models/api/post_model.dart`
   - Добавлен enum `PostType`
   - Создан класс `CreatePostMediaDto`
   - Обновлен `CreatePostRequest`

2. ✅ `frontend/lib/features/feed/screens/create_post_screen.dart`
   - Обновлена логика формирования запроса
   - Преобразование `mediaUrls` в `media` с объектами

3. ✅ Автогенерированные файлы (через `build_runner`)
   - `post_model.freezed.dart`
   - `post_model.g.dart`

## Примечания

### Теги (tags)
- Поле `tags` убрано из запроса, так как бэкенд его не принимает
- UI для тегов оставлен в `create_post_screen.dart` для возможного будущего использования
- Если бэкенд добавит поддержку тегов, нужно будет добавить поле в DTO

### Тип медиа
- Сейчас все медиа определяются как `MediaType.photo`
- В будущем можно добавить определение типа файла (photo/video) на основе MIME-типа

### Тип поста
- Автоматически определяется: `text` если нет медиа, `photo` если есть
- В будущем можно добавить определение `video` если есть видеофайлы

## Тестирование

После исправления:
1. ✅ Запрос должен успешно проходить валидацию на бэкенде
2. ✅ Пост должен создаваться с правильной структурой данных
3. ✅ Медиа должны корректно сохраняться

## Связанные документы

- `docs/RUNTIME_ERRORS_FIX.md` - исправление TypeError
- `docs/FIXES_SUMMARY.md` - краткое резюме всех исправлений
- `backend/src/modules/posts/dto/create-post.dto.ts` - DTO на бэкенде
