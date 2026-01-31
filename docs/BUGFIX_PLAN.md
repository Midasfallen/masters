# План исправления проблем Feed и Post Detail

## Приоритеты
- 🔴 **КРИТИЧНО** - блокирует основную функциональность
- 🟡 **ВЫСОКИЙ** - влияет на UX, но не блокирует
- 🟢 **СРЕДНИЙ** - улучшение качества

---

## 1. 🔴 Фильтры Feed - неправильный формат ID категорий

### Проблема
**Ошибка:** `400 Bad Request: [each value in category_ids must be a UUID]`  
**Причина:** В `feed_screen.dart` используются тестовые ID (`cat-1`, `cat-2`), а бэкенд ожидает UUID.

### Файлы для изменения
- `frontend/lib/features/feed/screens/feed_screen.dart` (строки 153-158)

### Решение
1. **Вариант А (рекомендуется):** Получать список категорий из API
   - Создать endpoint `GET /categories` (если его нет)
   - Создать provider `categoriesProvider`
   - Заменить хардкод на динамический список

2. **Вариант Б (быстрое решение):** Заменить тестовые ID на реальные UUID из БД
   - Запросить у бэкенд-разработчика список UUID категорий
   - Обновить `availableCategories` в `feed_screen.dart`

### Шаги
```dart
// 1. Создать API endpoint для категорий (если нет)
// backend/src/modules/categories/categories.controller.ts

// 2. Создать provider
// frontend/lib/core/providers/api/categories_provider.dart
@riverpod
Future<List<CategoryModel>> categories(CategoriesRef ref) async {
  final response = await ref.read(dioClientProvider).get('/categories');
  return (response.data as List)
      .map((json) => CategoryModel.fromJson(json))
      .toList();
}

// 3. Обновить feed_screen.dart
final categories = ref.watch(categoriesProvider);
availableCategories: categories.when(
  data: (cats) => cats.map((c) => CategoryOption(
    id: c.id,
    name: c.name,
    icon: c.icon ?? '📋',
  )).toList(),
  loading: () => [],
  error: (_, __) => [],
),
```

### Оценка времени: 2-4 часа

---

## 2. 🔴 Загрузка фото при создании поста - Image.file на веб

### Проблема
**Ошибка:** `Assertion failed: Image.file is not supported on Flutter Web`  
**Причина:** `Image.file(File(path))` не работает на веб. Нужно использовать `Image.memory` или `Image.network`.

**⚠️ Важное замечание от специалиста:**  
**XFile из пакета `image_picker` — ваш лучший друг!** Вам **не нужно** вручную проверять платформу для чтения байтов. Метод `file.readAsBytes()` работает везде:
- **На Mobile:** он прочитает файл с диска
- **На Web:** он прочитает файл из оперативной памяти (Blob)

**Совет:** Чтобы не плодить лишние `Map<int, Uint8List>`, вы можете создать обертку-виджет `AppImagePreview(file: xFile)`, которая внутри себя делает `FutureBuilder` на `file.readAsBytes()` и показывает `Image.memory`. Это сильно разгрузит код экрана создания поста.

### Файлы для изменения
- `frontend/lib/features/feed/screens/create_post_screen.dart` (строки 354, 498)
- Создать новый файл: `frontend/lib/core/widgets/app_image_preview.dart`

### Решение (рекомендуется)

**Шаг 1: Создать универсальный виджет-обертку**

```dart
// frontend/lib/core/widgets/app_image_preview.dart
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

/// Универсальный виджет для отображения изображений из XFile
/// Работает на всех платформах (Mobile, Web)
class AppImagePreview extends StatelessWidget {
  final XFile file;
  final BoxFit fit;
  final double? width;
  final double? height;

  const AppImagePreview({
    super.key,
    required this.file,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: file.readAsBytes(), // ⚠️ Работает везде!
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return Container(
            width: width,
            height: height,
            color: Colors.grey[300],
            child: const Icon(Icons.error_outline),
          );
        }

        return Image.memory(
          snapshot.data!,
          fit: fit,
          width: width,
          height: height,
        );
      },
    );
  }
}
```

**Шаг 2: Использовать виджет в create_post_screen.dart**

```dart
// В create_post_screen.dart
import 'package:service_platform/core/widgets/app_image_preview.dart';

// Убрать Map<int, Uint8List> _mediaBytes = {}; - больше не нужно!

// В методе отображения изображений
Widget _buildImagePreview(XFile file, int index) {
  return Stack(
    fit: StackFit.expand,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: AppImagePreview(
          file: file,
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        top: 4,
        right: 4,
        child: GestureDetector(
          onTap: () => _removeMedia(index),
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.6),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              size: 16,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ],
  );
}
```

### Альтернативное решение (если не хотите создавать виджет)

```dart
// В create_post_screen.dart
Widget _buildImagePreview(XFile file, int index) {
  return FutureBuilder<Uint8List>(
    future: file.readAsBytes(), // ⚠️ Работает везде без проверки платформы!
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Container(
          color: Colors.grey[300],
          child: const Center(child: CircularProgressIndicator()),
        );
      }

      if (snapshot.hasError || !snapshot.hasData) {
        return Container(
          color: Colors.grey[300],
          child: const Icon(Icons.error_outline),
        );
      }

      return Image.memory(
        snapshot.data!,
        fit: BoxFit.cover,
      );
    },
  );
}
```

### Шаги
1. **Создать виджет `AppImagePreview`** (рекомендуется) или использовать `FutureBuilder` напрямую
2. **Убрать проверки `kIsWeb`** - они больше не нужны
3. **Убрать `Map<int, Uint8List> _mediaBytes`** - больше не нужно хранить байты
4. **Заменить `Image.file(File(path))`** на `AppImagePreview(file: xFile)` или `FutureBuilder` с `Image.memory`
5. **Обновить метод `uploadPostMedia`** - использовать `file.readAsBytes()` для получения байтов

### Оценка времени: 2-3 часа (упрощено благодаря XFile.readAsBytes())

---

## 3. 🟡 Лайки не обновляются визуально

### Проблема
**Симптомы:** 
- При нажатии на лайк запрос отправляется (видно в логах)
- Иконка не становится красной
- Счетчик не обновляется
- После перезагрузки страницы лайк отображается

**Причина:** После успешного лайка не обновляется локальное состояние (StateProvider).

### Файлы для изменения
- `frontend/lib/features/feed/screens/post_detail_screen.dart` (строки 31-45)
- `frontend/lib/core/providers/api/feed_provider.dart` (метод `likePost`)

### Визуализация процесса: Оптимистичное обновление

**⚠️ Важное замечание от специалиста:**  
Для понимания того, как теперь будет работать логика лайков, представьте следующую схему взаимодействия:

```
┌─────────────────────────────────────────────────────────┐
│  User Action: Нажатие на кнопку ❤️                      │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│  Local State: Мгновенно меняется                        │
│  ✅ Сердце краснеет                                     │
│  ✅ Счетчик +1                                          │
│  (Пользователь видит результат СРАЗУ)                   │
└────────────────────┬────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────┐
│  API Call: Уходит в фоне                                │
│  POST /posts/:id/like                                   │
└────────────────────┬────────────────────────────────────┘
                     │
         ┌───────────┴───────────┐
         │                       │
         ▼                       ▼
┌─────────────────┐    ┌─────────────────┐
│  Success ✅      │    │  Error ❌        │
│                 │    │                 │
│  Ничего не      │    │  Состояние      │
│  происходит     │    │  «откатывается» │
│  (пользователь  │    │  назад:         │
│  уже видит      │    │  • Сердце      │
│  результат)      │    │    бледнеет     │
│                 │    │  • Счетчик -1  │
│                 │    │  • SnackBar    │
│                 │    │    с ошибкой   │
└─────────────────┘    └─────────────────┘
```

**Самый коварный момент:** Если не реализовать откат при ошибке, пользователь увидит лайк, но на сервере его не будет. Это критично!

### Решение (оптимистичное обновление - рекомендуется)

```dart
// В post_detail_screen.dart
Future<void> _handleLike(String postId, bool isLiked) async {
  // 1. Сохранить текущее состояние для отката
  final currentPost = ref.read(postByIdProvider(postId)).value;
  if (currentPost == null) return;

  // 2. ⚠️ ОПТИМИСТИЧНОЕ ОБНОВЛЕНИЕ - меняем UI СРАЗУ
  final optimisticPost = currentPost.copyWith(
    isLiked: !isLiked,
    likesCount: isLiked 
        ? currentPost.likesCount - 1 
        : currentPost.likesCount + 1,
  );
  ref.read(postByIdProvider(postId).notifier).state = 
      AsyncValue.data(optimisticPost);

  // 3. Отправляем запрос в фоне
  try {
    final updatedPost = isLiked
        ? await ref.read(postNotifierProvider.notifier).unlikePost(postId)
        : await ref.read(postNotifierProvider.notifier).likePost(postId);
    
    // 4. ✅ Success: Обновляем состояние реальными данными (на случай, если счетчик изменился)
    ref.read(postByIdProvider(postId).notifier).state = 
        AsyncValue.data(updatedPost);
  } catch (e) {
    // 5. ❌ Error: ОТКАТЫВАЕМ изменения
    ref.read(postByIdProvider(postId).notifier).state = 
        AsyncValue.data(currentPost); // Возвращаем исходное состояние
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
```

### Альтернативное решение (без оптимистичного обновления)

Если не хотите использовать оптимистичное обновление:

```dart
// В post_detail_screen.dart
Future<void> _handleLike(String postId, bool isLiked) async {
  try {
    final updatedPost = isLiked
        ? await ref.read(postNotifierProvider.notifier).unlikePost(postId)
        : await ref.read(postNotifierProvider.notifier).likePost(postId);
    
    // Обновить локальное состояние
    ref.read(postByIdProvider(postId).notifier).state = 
        AsyncValue.data(updatedPost);
    
    // Или инвалидировать провайдер
    // ref.invalidate(postByIdProvider(postId));
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
      );
    }
  }
}
```

### Шаги
1. **Проверить, что `likePost` возвращает обновленный `PostModel`**
2. **Реализовать оптимистичное обновление** (рекомендуется):
   - Сохранить текущее состояние
   - Обновить UI сразу
   - Отправить запрос в фоне
   - При успехе - обновить реальными данными
   - При ошибке - откатить изменения
3. **Добавить обработку ошибок** с откатом состояния
4. **Протестировать** с медленным интернетом (Network Throttling в DevTools)

### Оценка времени: 2-3 часа

---

## 4. 🔴 Комментарии - ошибка при отправке (parent_id: null)

### Проблема
**Ошибка:** `400 Bad Request: [property parent_id should not exist]`  
**Причина:** При создании комментария отправляется `parent_id: null`, а бэкенд не принимает null-значения для необязательных полей.

### Файлы для изменения
- `frontend/lib/core/models/api/post_model.dart` (CreateCommentRequest)
- `frontend/lib/features/feed/screens/post_detail_screen.dart` (строка 442)

### Решение
Не отправлять `parent_id`, если он `null`:

```dart
// В post_model.dart
@freezed
class CreateCommentRequest with _$CreateCommentRequest {
  const factory CreateCommentRequest({
    required String content,
    @JsonKey(name: 'parent_id', includeIfNull: false) String? parentId,
  }) = _CreateCommentRequest;
}
```

Или вручную фильтровать при сериализации:

```dart
// В post_repository.dart или feed_provider.dart
Future<CommentModel> createComment(
  String postId,
  CreateCommentRequest request,
) async {
  final data = request.toJson();
  // Удалить parent_id если null
  if (data['parent_id'] == null) {
    data.remove('parent_id');
  }
  
  final response = await _client.post(
    '/posts/$postId/comments',
    data: data,
  );
  return CommentModel.fromJson(response.data);
}
```

### Шаги
1. Добавить `includeIfNull: false` в `@JsonKey` для `parentId`
2. Или фильтровать null-значения перед отправкой
3. Протестировать создание комментария

### Оценка времени: 1 час

---

## 5. 🟡 Кнопка "Поделиться" не работает

### Проблема
**Симптомы:** Кнопка показывает только SnackBar, не копирует ссылку и не открывает диалог.

**⚠️ Важное замечание от специалиста:**  
Для Web-версии `share_plus` работает через стандартный API браузера `navigator.share`. Если браузер его не поддерживает (например, десктопный Chrome без HTTPS), библиотека может ничего не сделать. **Fallback с `Clipboard.setData` обязателен!** Без него на ПК кнопка будет казаться «мертвой».

### Файлы для изменения
- `frontend/lib/features/feed/screens/post_detail_screen.dart` (строки 176-186)

### Решение
Использовать пакет `share_plus` с обязательным fallback:

```dart
// 1. Добавить в pubspec.yaml
dependencies:
  share_plus: ^7.2.1

// 2. В post_detail_screen.dart
import 'package:share_plus/share_plus.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

Future<void> _sharePost(PostModel post) async {
  final postUrl = 'https://your-domain.com/post/${post.id}';
  final text = post.content != null 
      ? '${post.content}\n\n$postUrl'
      : 'Посмотри этот пост: $postUrl';
  
  try {
    // Попытка использовать нативный шаринг
    final result = await Share.share(
      text,
      subject: 'Пост от ${post.author?.fullName ?? "мастера"}',
    );
    
    // На веб Share.share может вернуть null, если не поддерживается
    if (kIsWeb && result.status == ShareResultStatus.unavailable) {
      throw Exception('Share API not available');
    }
  } catch (e) {
    // ⚠️ ОБЯЗАТЕЛЬНЫЙ FALLBACK для веба и десктопа
    await Clipboard.setData(ClipboardData(text: postUrl));
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ссылка скопирована в буфер обмена'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }
}
```

### Альтернативное решение (только копирование)
Если не хотите добавлять зависимости:

```dart
import 'package:flutter/services.dart';

Future<void> _sharePost(PostModel post) async {
  final postUrl = 'https://your-domain.com/post/${post.id}';
  await Clipboard.setData(ClipboardData(text: postUrl));
  
  if (mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Ссылка скопирована в буфер обмена'),
        duration: Duration(seconds: 2),
      ),
    );
  }
}
```

### Шаги
1. Добавить `share_plus` в `pubspec.yaml`
2. Реализовать метод `_sharePost` с обязательным fallback
3. Обновить обработчик кнопки "Поделиться"
4. **Протестировать на веб (особенно десктопный Chrome)**
5. Убедиться, что fallback работает корректно

### Оценка времени: 1-2 часа

---

## 6. 🟡 Кнопка "Закладки" не работает

### Проблема
**Симптомы:**
- Иконка не меняется на красную
- Нет уведомления о сохранении
- Не сохраняется в избранное

**Причина:** Кнопка только показывает SnackBar, не вызывает API.

### Файлы для изменения
- `frontend/lib/features/feed/screens/post_detail_screen.dart` (строки 189-199)
- `frontend/lib/core/providers/favorites_provider.dart` (если есть)

### Решение
Интегрировать с API избранного:

```dart
// 1. Проверить, есть ли пост в избранном
final favoritesAsync = ref.watch(favoritesProvider(
  entityType: FavoriteEntityType.post,
));

final isFavorite = favoritesAsync.when(
  data: (favorites) => favorites.any((f) => f.entityId == post.id),
  loading: () => false,
  error: (_, __) => false,
);

// 2. Обработчик кнопки
Future<void> _toggleFavorite(PostModel post) async {
  try {
    if (isFavorite) {
      // Удалить из избранного
      await ref.read(favoritesNotifierProvider.notifier)
          .removeFavorite(post.id, FavoriteEntityType.post);
    } else {
      // Добавить в избранное
      await ref.read(favoritesNotifierProvider.notifier)
          .addFavorite(
            AddFavoriteRequest(
              entityType: FavoriteEntityType.post,
              entityId: post.id,
            ),
          );
    }
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isFavorite 
              ? 'Удалено из закладок' 
              : 'Сохранено в закладки'),
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
      );
    }
  }
}

// 3. Обновить иконку
_buildActionButton(
  icon: isFavorite ? Icons.bookmark : Icons.bookmark_border,
  color: isFavorite ? Colors.amber : Colors.white,
  label: '',
  onTap: () => _toggleFavorite(post),
),
```

### Шаги
1. Проверить наличие `favorites_provider.dart`
2. Создать provider для избранного (если нет)
3. Реализовать `_toggleFavorite`
4. Обновить UI кнопки с проверкой состояния
5. Добавить обновление состояния после успешного запроса

### Оценка времени: 2-3 часа

---

## 7. 🟡 Кнопка "Подписаться" - не уверен, что работает

### Проблема
**Симптомы:** Показывает уведомление, но не уверен, что подписка создается.

### Файлы для изменения
- `frontend/lib/features/feed/screens/post_detail_screen.dart` (строки 257-276)

### Решение
Интегрировать с API подписок:

```dart
// 1. Проверить, подписан ли пользователь
final isFollowing = post.author?.isFollowing ?? false; // если есть в UserModel

// 2. Обработчик
Future<void> _toggleFollow(String authorId, bool isFollowing) async {
  try {
    if (isFollowing) {
      await ref.read(socialNotifierProvider.notifier)
          .unfollowUser(authorId);
    } else {
      await ref.read(socialNotifierProvider.notifier)
          .followUser(authorId);
    }
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(isFollowing 
              ? 'Отписались от мастера' 
              : 'Подписались на мастера'),
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
      );
    }
  }
}

// 3. Обновить кнопку
OutlinedButton(
  onPressed: () => _toggleFollow(post.authorId, isFollowing),
  child: Text(isFollowing ? 'Отписаться' : 'Подписаться'),
),
```

### Шаги
1. Проверить наличие API подписок (`POST /users/:id/follow`, `DELETE /users/:id/unfollow`)
2. Создать provider для подписок (если нет)
3. Реализовать `_toggleFollow`
4. Обновить UI кнопки

### Оценка времени: 2-3 часа

---

## 8. 🔴 "Неизвестный Мастер" - проблема парсинга данных

### Проблема
**Симптомы:** 
- В логах видно: `author: {firstName: Елена, lastName: Смирнова...}`
- В UI отображается: "Неизвестный мастер"
- `post.author?.fullName` возвращает `null`

**⚠️ Важное замечание от специалиста:**  
**Будьте осторожны с именованием полей!** В логах от бэкенда ключи приходят в **camelCase** (`firstName`, `lastName`), а во Flutter моделях часто используется **snake_case** (`first_name`, `last_name`).

**Причина:** 
1. `UserModel.fromJson` не парсит `fullName` правильно
2. Бэкенд не отправляет поле `fullName` (только `firstName` и `lastName`)
3. Несоответствие именования полей между API и моделью

### Файлы для изменения
- `frontend/lib/core/models/api/user_model.dart`
- `frontend/lib/core/models/api/user_model.g.dart` (автогенерируемый)
- `frontend/lib/features/feed/screens/post_detail_screen.dart` (строка 249)

### Решение

**Шаг 1: Проверить текущее именование**

В вашем `user_model.g.dart` видно, что используется **camelCase**:
```dart
firstName: json['firstName'] as String,  // ✅ camelCase
lastName: json['lastName'] as String,    // ✅ camelCase
fullName: json['fullName'] as String?,   // ✅ camelCase
```

Это правильно, если бэкенд отправляет camelCase. Но нужно проверить, приходит ли `fullName`.

**Шаг 2: Добавить кастомный `fromJson` с fallback**

```dart
// В user_model.dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    String? phone,
    required String firstName,  // без @JsonKey, т.к. уже camelCase
    required String lastName,
    String? fullName,
    String? avatarUrl,
    // ...
  }) = _UserModel;
  
  // ⚠️ Кастомный fromJson для обработки отсутствующего fullName
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // Если fullName не приходит, создать из firstName + lastName
    if (json['fullName'] == null && 
        json['firstName'] != null && 
        json['lastName'] != null) {
      json['fullName'] = '${json['firstName']} ${json['lastName']}';
    }
    return _$UserModelFromJson(json);
  }
}
```

**⚠️ Важно:** Если вы используете `freezed`, убедитесь, что в начале файла модели стоит `@Default` или настроен `json_serializable` с параметром `fieldRename: FieldRename.snake` (или `camel`, в зависимости от API).

**Шаг 3: Fallback в UI (рекомендуется)**

Более безопасный подход - использовать fallback в UI:

```dart
// В post_detail_screen.dart
Text(
  post.author?.fullName ?? 
  (post.author != null 
      ? '${post.author!.firstName} ${post.author!.lastName}'
      : 'Неизвестный мастер'),
  style: const TextStyle(
    color: Colors.white,
    fontSize: 15,
    fontWeight: FontWeight.w600,
  ),
),
```

### Шаги
1. **Проверить логи:** Убедиться, что бэкенд отправляет `fullName` в camelCase
2. **Проверить `@JsonKey` аннотации:** Убедиться, что нет конфликта именования
3. **Добавить fallback в UI** (рекомендуется) или кастомный `fromJson`
4. **Перегенерировать `.g.dart` файлы:** `flutter pub run build_runner build --delete-conflicting-outputs`

### Оценка времени: 1-2 часа

---

## 9. 🔴 Кнопки "Мастер" и "Записаться" ведут на "Мастер не найден"

### Проблема
**Симптомы:**
- Кнопки ведут на `/master/${post.authorId}`
- Страница показывает "Мастер не найден"
- В логах видно правильный `authorId`

**⚠️ Важное замечание от специалиста:**  
Здесь может быть **третья причина: проблема с роутингом GoRouter**. Если вы передаете ID в путь, например `/master/:id`, а в ID содержится спецсимвол или роут неверно сконфигурирован в `app_router.dart`, страница просто не инициализируется.

**Проверьте:** Не пытается ли страница Мастера сделать еще один запрос `GET /masters/:id` при загрузке, который падает с 404.

**Причина:** 
1. Роут `/master/:id` ожидает `masterId`, а не `authorId`
2. Мастер не имеет профиля мастера (`isMaster: false`)
3. **Проблема с роутингом GoRouter** (неправильная конфигурация или спецсимволы в ID)

### Файлы для изменения
- `frontend/lib/features/feed/screens/post_detail_screen.dart` (строки 313, 326)
- `frontend/lib/core/routing/app_router.dart` (проверить роут)
- `frontend/lib/features/master/screens/master_profile_screen.dart` (проверить загрузку данных)

### Решение

**Шаг 1: Проверить конфигурацию роута**

```dart
// В app_router.dart
GoRoute(
  path: '/master/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    // ⚠️ Проверить, что ID правильно извлекается
    print('Master ID from route: $id');
    return MasterProfileScreen(masterId: id);
  },
),
```

**Шаг 2: Проверить, какой ID ожидает страница мастера**

```dart
// В master_profile_screen.dart
class MasterProfileScreen extends ConsumerWidget {
  final String masterId; // или authorId?
  
  // Проверить, какой запрос делается:
  // GET /masters/:id или GET /users/:id?
  final masterAsync = ref.watch(masterByIdProvider(masterId));
}
```

**Шаг 3: Исправить навигацию с проверкой**

```dart
// В post_detail_screen.dart
onPressed: () {
  // ⚠️ Проверить, что автор является мастером
  if (post.author?.isMaster != true) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Этот пользователь не является мастером'),
      ),
    );
    return;
  }
  
  // ⚠️ Проверить, что ID валидный (нет спецсимволов)
  final masterId = post.authorId;
  if (masterId.isEmpty || !RegExp(r'^[a-zA-Z0-9-]+$').hasMatch(masterId)) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Некорректный ID мастера')),
    );
    return;
  }
  
  // Навигация
  context.push('/master/$masterId');
},
```

**Шаг 4: Добавить обработку ошибок на странице мастера**

```dart
// В master_profile_screen.dart
final masterAsync = ref.watch(masterByIdProvider(masterId));

return masterAsync.when(
  data: (master) => _buildMasterProfile(master),
  loading: () => const CircularProgressIndicator(),
  error: (error, stack) {
    // ⚠️ Проверить, что это не 404 из-за неправильного ID
    if (error.toString().contains('404')) {
      return Center(
        child: Column(
          children: [
            const Text('Мастер не найден'),
            Text('ID: $masterId'), // для отладки
            ElevatedButton(
              onPressed: () => context.pop(),
              child: const Text('Назад'),
            ),
          ],
        ),
      );
    }
    return ErrorWidget(error);
  },
);
```

### Альтернативное решение
Если автор поста не всегда мастер, нужно проверить `isMaster`:

```dart
// В post_detail_screen.dart
if (post.author?.isMaster == true) {
  // Показать кнопки "Записаться" и "Мастер"
} else {
  // Скрыть или показать альтернативные кнопки
}
```

### Шаги
1. **Проверить роут `/master/:id`** в `app_router.dart` - правильно ли извлекается ID
2. **Проверить, какой параметр ожидает страница мастера** (`masterId` vs `authorId`)
3. **Проверить, какой API endpoint вызывается** (`GET /masters/:id` vs `GET /users/:id`)
4. **Проверить, есть ли у автора поста профиль мастера** (`isMaster: true`)
5. **Добавить логирование** для отладки (вывести ID в консоль)
6. **Обновить навигацию** с правильными параметрами и валидацией
7. **Добавить проверку `isMaster`** перед показом кнопок

### Оценка времени: 2-3 часа

---

## Итоговая оценка времени

| Проблема | Приоритет | Время |
|----------|-----------|-------|
| 1. Фильтры (UUID) | 🔴 | 2-4 ч |
| 2. Image.file на веб | 🔴 | 2-3 ч |
| 3. Лайки не обновляются | 🟡 | 2-3 ч |
| 4. Комментарии (parent_id) | 🔴 | 1 ч |
| 5. Кнопка "Поделиться" | 🟡 | 1-2 ч |
| 6. Кнопка "Закладки" | 🟡 | 2-3 ч |
| 7. Кнопка "Подписаться" | 🟡 | 2-3 ч |
| 8. "Неизвестный Мастер" | 🔴 | 1-2 ч |
| 9. Кнопки "Мастер"/"Записаться" | 🔴 | 2-3 ч |
| 10. CORS (если проблема есть) | 🟢 | 0.5 ч |

**Общее время: 15-25 часов** (включая CORS, если проблема проявится)

*Время сокращено благодаря упрощению решения для Image.file (XFile.readAsBytes() работает везде)*

---

## Рекомендуемый порядок исправления

1. **День 1 (критичные):**
   - Проблема 4 (Комментарии) - 1 ч
   - Проблема 8 ("Неизвестный Мастер") - 1-2 ч
   - Проблема 1 (Фильтры) - 2-4 ч

2. **День 2 (критичные):**
   - Проблема 2 (Image.file) - 2-3 ч (упрощено благодаря XFile.readAsBytes())
   - Проблема 9 (Кнопки "Мастер"/"Записаться") - 2-3 ч

3. **День 3 (UX):**
   - Проблема 3 (Лайки) - 2-3 ч
   - Проблема 5 (Поделиться) - 1-2 ч
   - Проблема 6 (Закладки) - 2-3 ч
   - Проблема 7 (Подписаться) - 2-3 ч

---

## 10. 🟢 CORS (Cross-Origin Resource Sharing) - потенциальная проблема

### Проблема
**⚠️ Важное замечание от специалиста:**  
Поскольку вы запускаете проект на Web (`localhost:63261`) и обращаетесь к локальному API (`localhost:3000`), вы можете столкнуться с **CORS ошибками** при отправке POST запросов (лайки, комментарии), даже если GET запросы проходят.

**Симптомы:**
- GET запросы работают нормально
- POST/PUT/DELETE запросы падают с ошибкой CORS
- В консоли браузера: `Access to XMLHttpRequest has been blocked by CORS policy`

### Решение

**Backend (NestJS):**

```typescript
// В main.ts или app.module.ts
app.enableCors({
  origin: [
    'http://localhost:3000',
    'http://localhost:63261', // Flutter Web dev server
    'http://localhost:8080',  // альтернативный порт
  ],
  credentials: true,
  methods: ['GET', 'POST', 'PUT', 'DELETE', 'PATCH', 'OPTIONS'],
  allowedHeaders: ['Content-Type', 'Authorization', 'Accept'],
});
```

**Проверка:**
1. Открыть DevTools → Network
2. Попробовать поставить лайк или отправить комментарий
3. Проверить, есть ли ошибка CORS в консоли
4. Проверить заголовки ответа: должны быть `Access-Control-Allow-Origin`, `Access-Control-Allow-Methods`

### Оценка времени: 30 минут (если проблема есть)

---

## Дополнительные рекомендации

### 1. Тестирование
После каждого исправления протестировать на:
- **Web** (Chrome, Firefox, Safari)
- **Мобильных платформах** (Android, iOS, если доступно)

### 2. Логирование
Добавить логирование для отладки API запросов:
```dart
// В dio_client.dart или interceptor
dio.interceptors.add(LogInterceptor(
  requestBody: true,
  responseBody: true,
  error: true,
));
```

### 3. Обработка ошибок
Улучшить обработку ошибок во всех местах:
- Показывать понятные сообщения пользователю
- Логировать технические детали для разработчиков
- Предлагать действия (повторить, вернуться назад)

### 4. Оптимистичные обновления ⭐
**Это то, что отделяет «учебный» проект от профессионального!**

Использовать для лучшего UX (лайки, закладки, подписки):
- Обновлять UI **сразу**, без ожидания ответа сервера
- Откатывать изменения только при ошибке
- Пользователь не должен ждать секунду, пока иконка лайка станет красной

Пример (см. Проблема 3):
```dart
// Оптимистичное обновление
final currentPost = ref.read(postByIdProvider(postId)).value;
if (currentPost != null) {
  final optimisticPost = currentPost.copyWith(
    isLiked: !isLiked,
    likesCount: isLiked 
        ? currentPost.likesCount - 1 
        : currentPost.likesCount + 1,
  );
  ref.read(postByIdProvider(postId).notifier).state = 
      AsyncValue.data(optimisticPost);
}

// Затем выполнить запрос (в фоне)
try {
  await ref.read(postNotifierProvider.notifier).likePost(postId);
} catch (e) {
  // Откатить изменения при ошибке
  ref.invalidate(postByIdProvider(postId));
}
```

---

## Использование плана как Master-Prompt для Cursor

**Совет от специалиста:**  
Этот план можно превратить в Master-Prompt для Cursor Composer.

### Как использовать:

1. Открыть Cursor Composer (`Ctrl + I` или `Cmd + I`)
2. Выбрать режим "Act" или "Review"
3. Вставить следующий промпт:

```
Я составил план исправления багов в проекте Flutter. Давай пойдем по порядку.

Начнем с пункта 4 (Комментарии - parent_id: null) и пункта 8 (Неизвестный Мастер - парсинг данных).

Вот мой детальный план: [ВСТАВИТЬ СОДЕРЖИМОЕ ЭТОГО ФАЙЛА]

Пожалуйста:
1. Прочитай план
2. Начни с исправления пункта 4 (самый быстрый - 1 час)
3. Затем перейди к пункту 8
4. После каждого исправления покажи мне изменения и объясни, что было сделано

Готов начать?
```

### Преимущества:
- Cursor поможет с кодом
- Можно идти по порядку, не теряя контекст
- Автоматическая проверка синтаксиса
- Предложения по улучшению

---

## Итоговые замечания от специалиста

### ✅ Что в плане самое сильное:

1. **Разделение на Web и Mobile (Пункт 2):** 
   - Это критично. Ошибка `Image.file` — классическая ловушка при переходе с мобилок на веб.
   - Использование `Image.memory` с `Uint8List` — самый стабильный путь для веба.

2. **Оптимистичные обновления (Пункт 3):** 
   - Это то, что отделяет «учебный» проект от профессионального.
   - Пользователь не должен ждать секунду, пока иконка лайка станет красной.

3. **Работа с UUID (Пункт 1):** 
   - Правильно подмечено, что это ошибка типов.

### ⚠️ Тонкие моменты:

1. **Именование полей (Пункт 8):** 
   - Будьте осторожны с camelCase vs snake_case
   - Проверьте `@JsonKey` аннотации

2. **Роутинг GoRouter (Пункт 9):** 
   - Проверьте конфигурацию роутов
   - Убедитесь, что ID правильно извлекается

3. **CORS (новый пункт 10):** 
   - Может проявиться при POST запросах
   - Проверьте настройки на бэкенде
