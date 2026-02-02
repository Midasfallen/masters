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

### ✅ Статус: ВЫПОЛНЕНО

**Что было сделано:**
1. ✅ Создана модель `CategoryModel` на основе `CategoryResponseDto` из бэкенда
2. ✅ Создан провайдер `categoriesProvider` для загрузки категорий из API (`GET /categories`)
3. ✅ Обновлен `feed_screen.dart` для использования провайдера вместо хардкода
4. ✅ Добавлена обработка переводов категорий с приоритетом русского языка
5. ✅ Фильтрация только активных категорий (`isActive: true`)

**Файлы изменены:**
- `frontend/lib/core/models/api/category_model.dart` - создана модель категорий
- `frontend/lib/core/providers/api/categories_provider.dart` - создан провайдер для категорий
- `frontend/lib/features/feed/screens/feed_screen.dart` - обновлен для использования API категорий

**Дата выполнения:** 2026-01-31

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

### ✅ Статус: ВЫПОЛНЕНО

**Что было сделано:**
1. ✅ Создан виджет `AppImagePreview` для универсального отображения изображений из XFile
2. ✅ Добавлен метод `uploadBytes` в `DioClient` с обязательным `filename` в `MultipartFile.fromBytes`
3. ✅ Добавлен метод `uploadPostMediaFromXFile` в `PostRepository` для Web-совместимой загрузки
4. ✅ Обновлен `CreatePostScreen` для использования `AppImagePreview` вместо `Image.file`
5. ✅ Убран импорт `dart:io` из `create_post_screen.dart`
6. ✅ Обновлен `feed_provider.dart` для поддержки загрузки через XFile

**Файлы изменены:**
- `frontend/lib/core/widgets/app_image_preview.dart` - создан новый виджет
- `frontend/lib/core/api/dio_client.dart` - добавлен метод `uploadBytes`
- `frontend/lib/core/repositories/post_repository.dart` - добавлен метод `uploadPostMediaFromXFile`
- `frontend/lib/core/providers/api/feed_provider.dart` - добавлен метод `uploadPostMediaFromXFile`
- `frontend/lib/features/feed/screens/create_post_screen.dart` - заменен `Image.file` на `AppImagePreview`

**Дата выполнения:** 2026-01-31

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

### ✅ Статус: ВЫПОЛНЕНО

**Что было сделано:**
1. ✅ Реализовано оптимистичное обновление лайков с мгновенным изменением UI
2. ✅ Добавлен флаг `_isLiking` для защиты от race conditions
3. ✅ Реализован откат состояния при ошибке API через локальное состояние `_optimisticPost`
4. ✅ Кнопка лайка блокируется во время выполнения запроса
5. ✅ Использован подход с локальным состоянием для FutureProvider (через `_optimisticPost`)

**Файлы изменены:**
- `frontend/lib/features/feed/screens/post_detail_screen.dart` - реализовано оптимистичное обновление лайков

**Дата выполнения:** 2026-01-31

---

## 4. ✅ Комментарии - ошибка при отправке (parent_id: null) [ВЫПОЛНЕНО]

### Проблема
**Ошибка:** `400 Bad Request: [property parent_id should not exist]`  
**Причина:** При создании комментария отправляется `parent_id: null`, а бэкенд не принимает null-значения для необязательных полей.

**Дополнительно исправлено:**
- Ошибка `TypeError: null: type 'Null' is not a subtype of type 'bool'` при парсинге комментариев (добавлены дефолтные значения для `isLiked` и `likesCount`)
- Проблема с маппингом `parentCommentId` → `parentId` (сервер возвращает `parentCommentId`)
- Отображение имени автора как "Аноним" вместо реального имени (добавлена подстановка информации о текущем пользователе)

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

### Статус: ✅ ВЫПОЛНЕНО
**Выполнено:**
1. ✅ Добавлен `@JsonKey(name: 'parent_id', includeIfNull: false)` в `CreateCommentRequest`
2. ✅ Исправлен парсинг комментариев с обработкой отсутствующих полей (`isLiked`, `likesCount`)
3. ✅ Добавлен маппинг `parentCommentId` → `parentId` в кастомном `fromJson`
4. ✅ Добавлена подстановка информации о текущем пользователе в `createComment` и `postComments` провайдерах
5. ✅ Исправлено отображение имени автора в комментариях (теперь показывается "Глеб Равинский" вместо "Аноним")

**Файлы изменены:**
- `frontend/lib/core/models/api/post_model.dart` - исправлен `CommentModel.fromJson` и `CreateCommentRequest`
- `frontend/lib/core/providers/api/feed_provider.dart` - добавлена подстановка информации о текущем пользователе

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

### ✅ Статус: ВЫПОЛНЕНО

**Что было сделано:**
1. ✅ Добавлен пакет `share_plus: ^7.2.1` в `pubspec.yaml`
2. ✅ Реализован метод `_sharePost` с поддержкой нативного шаринга
3. ✅ Добавлен обязательный fallback на `Clipboard.setData` для Web и десктопа
4. ✅ Обработка ошибок Share API с автоматическим переходом на копирование в буфер
5. ✅ Обновлена кнопка "Поделиться" для использования нового метода

**Файлы изменены:**
- `frontend/pubspec.yaml` - добавлен `share_plus: ^7.2.1`
- `frontend/lib/features/feed/screens/post_detail_screen.dart` - реализован метод `_sharePost` с fallback

**Дата выполнения:** 2026-01-31

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

### ✅ Статус: ВЫПОЛНЕНО

**Что было сделано:**
- Исправлена навигация с поста в профиль мастера - имя мастера теперь кликабельно
- Убрана кнопка "Мастер" внизу поста
- Кнопка "Записаться" растянута на всю ширину
- Исправлена архитектура поиска мастера: бэкенд теперь ищет по `id` профиля мастера или по `user_id`
- Убрана антипаттерн-логика перебора страниц в `master_repository.dart`
- Добавлены проверки на null в репозитории и UI для предотвращения `TypeError: null`
- Улучшена обработка ошибок в `MasterProfileScreen` с понятными сообщениями для пользователя
- Исправлен health check endpoint - добавлен декоратор `@Public()` для всех методов health check

**Файлы изменены:**
- `backend/src/modules/masters/masters.service.ts` - унифицирован поиск мастера по `id` и `user_id`
- `frontend/lib/core/repositories/master_repository.dart` - убрана логика перебора страниц, добавлены проверки на null
- `frontend/lib/core/providers/api/masters_provider.dart` - разделены провайдеры для `masterByProfileId` и `masterByUserId`
- `frontend/lib/features/feed/screens/post_detail_screen.dart` - имя мастера кликабельно, убрана кнопка "Мастер", растянута кнопка "Записаться"
- `frontend/lib/features/master/screens/master_profile_screen.dart` - улучшена обработка ошибок, интеграция с API
- `frontend/lib/core/routing/app_router.dart` - упрощен роутинг для профиля мастера
- `backend/src/common/controllers/health.controller.ts` - добавлен `@Public()` для health check endpoints

**Дата выполнения:** 2026-01-31

---

## Итоговая оценка времени

| Проблема | Приоритет | Время | Статус |
|----------|-----------|-------|--------|
| 1. Фильтры (UUID) | 🔴 | 2-4 ч | ✅ ВЫПОЛНЕНО |
| 2. Image.file на веб | 🔴 | 2-3 ч | ⏳ В ожидании |
| 3. Лайки не обновляются | 🟡 | 2-3 ч | ⏳ В ожидании |
| 4. Комментарии (parent_id) | 🔴 | 1 ч | ✅ ВЫПОЛНЕНО |
| 5. Кнопка "Поделиться" | 🟡 | 1-2 ч | ⏳ В ожидании |
| 6. Кнопка "Закладки" | 🟡 | 2-3 ч | ⏳ В ожидании |
| 7. Кнопка "Подписаться" | 🟡 | 2-3 ч | ⏳ В ожидании |
| 8. "Неизвестный Мастер" | 🔴 | 1-2 ч | ✅ ВЫПОЛНЕНО |
| 9. Кнопки "Мастер"/"Записаться" | 🔴 | 2-3 ч | ✅ ВЫПОЛНЕНО |
| 10. CORS (если проблема есть) | 🟢 | 0.5 ч | ✅ ВЫПОЛНЕНО |

**Общее время: 15-25 часов** (включая CORS, если проблема проявится)  
**Выполнено: 6-10 часов** (пункт 1 - Фильтры, пункт 4 - Комментарии, пункт 8 - "Неизвестный Мастер", пункт 9 - Кнопки "Мастер"/"Записаться")

*Время сокращено благодаря упрощению решения для Image.file (XFile.readAsBytes() работает везде)*

---

## Рекомендуемый порядок исправления

1. **День 1 (критичные):**
   - ✅ Проблема 1 (Фильтры) - 2-4 ч [ВЫПОЛНЕНО]
   - ✅ Проблема 4 (Комментарии) - 1 ч [ВЫПОЛНЕНО]
   - ✅ Проблема 8 ("Неизвестный Мастер") - 1-2 ч [ВЫПОЛНЕНО]

2. **День 2 (критичные):**
   - Проблема 2 (Image.file) - 2-3 ч (упрощено благодаря XFile.readAsBytes())
   - ✅ Проблема 9 (Кнопки "Мастер"/"Записаться") - 2-3 ч [ВЫПОЛНЕНО]

3. **День 3 (UX):**
   - Проблема 3 (Лайки) - 2-3 ч
   - Проблема 5 (Поделиться) - 1-2 ч
   - Проблема 6 (Закладки) - 2-3 ч
   - Проблема 7 (Подписаться) - 2-3 ч

---

## 10. 🟢 CORS (Cross-Origin Resource Sharing) - потенциальная проблема

### Проблема
**⚠️ Важное замечание от специалиста:**  
Поскольку вы запускаете проект на Web (Flutter Web в Chrome) и обращаетесь к локальному API (`localhost:3000`), было важно гарантировать отсутствие **CORS ошибок** при любых запросах (GET/POST/PUT/DELETE).

### Решение

**Backend (NestJS):**

Включен CORS с конфигурацией через переменную окружения `CORS_ORIGIN` (для локальной разработки используется `*`):

```typescript
// В main.ts
app.enableCors({
  origin: process.env.CORS_ORIGIN?.split(',') || '*',
  credentials: true,
});
```

В локальном `.env` настроено:

```dotenv
CORS_ORIGIN=*
```

Это позволяет Flutter Web (Chrome) стабильно обращаться к `http://localhost:3000/api/v2` без ошибок CORS.

### Проверка
1. Открыть DevTools → Network
2. Выполнить запросы (загрузка ленты, лайки, избранное)
3. Убедиться, что в консоли нет ошибок CORS

### Оценка времени: 30 минут (если проблема есть)

### ✅ Статус: ВЫПОЛНЕНО

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

Начнем с пункта 8 (Неизвестный Мастер - парсинг данных). Пункт 4 (Комментарии) уже выполнен.

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

---

## 11. 🔴 Многоуровневые фильтры по каталогу категорий

### Проблема
**Описание:** Отсутствуют фильтры по каталогу из `docs/business/Catalog.md`. Должны быть фильтры по:
- Верхнему уровню: Красота и уход, Здоровье и массаж, Психология и коучинг и т.д.
- Среднему уровню: Парикмахерские услуги, Ногтевой сервис, Косметология и т.д.
- Нижнему уровню: Мужская стрижка, Женская стрижка, Детская стрижка и т.д.

Каталог должен быть в базе данных, сейчас таблица `categories` пустая.

Геолокация должна быть по предустановленным значениям: 5 км, 10 км, 15 км, 20 км. Фильтр по геолокации может отсутствовать, тогда доступны все посты.

Кастомных услуг в фильтре страницы feed быть не должно.

### Файлы для изменения
- `backend/src/database/seeds/seed-catalog.ts` - создан seed-скрипт
- `backend/package.json` - добавлен скрипт `seed:catalog`
- `frontend/lib/core/providers/api/categories_tree_provider.dart` - создан провайдер для дерева категорий
- `frontend/lib/core/api/api_endpoints.dart` - добавлен endpoint `/categories/tree`
- `frontend/lib/features/feed/widgets/feed_filters_sheet.dart` - полностью переписан с многоуровневыми фильтрами
- `frontend/lib/features/feed/screens/feed_screen.dart` - обновлен для использования нового формата фильтров
- `frontend/lib/core/providers/api/feed_provider.dart` - убраны `serviceIds` и `customServiceName`
- `frontend/lib/core/repositories/post_repository.dart` - убраны `serviceIds` и `customServiceName`
- `backend/src/modules/posts/dto/filter-posts.dto.ts` - убраны `service_ids` и `custom_service_name`
- `backend/src/modules/posts/posts.service.ts` - обновлена логика фильтрации по категориям с использованием closure table

### Решение

**1. Seed-скрипт для наполнения категорий:**
- Создан `backend/src/database/seeds/seed-catalog.ts`
- Парсит структуру из `Catalog.md` (3 уровня: корневые, подкатегории, услуги)
- Генерирует slug из русского текста
- Создает категории с переводами на русском языке
- Использование: `npm run seed:catalog`

**2. Многоуровневые фильтры в UI:**
- Используется `categoriesTreeProvider` для загрузки дерева категорий
- Отображается иерархическая структура с возможностью раскрытия/сворачивания
- Можно выбирать категории любого уровня (корневые, подкатегории, услуги)
- Убраны фильтры по услугам и кастомным услугам

**3. Предустановленные значения радиуса:**
- Заменен слайдер на FilterChip с предустановленными значениями: 5, 10, 15, 20 км

**4. Логика фильтрации на бэкенде:**
- Используется closure table (`categories_closure`) для поиска всех потомков выбранных категорий
- Фильтрация работает для категорий любого уровня
- Убрана фильтрация по `service_ids` и `custom_service_name`

### Оценка времени: 8-12 часов

### ✅ Статус: ВЫПОЛНЕНО

**Что было сделано:**
1. ✅ Создан seed-скрипт для наполнения категорий из Catalog.md (3 уровня)
2. ✅ Обновлен UI фильтров: убраны кастомные услуги, добавлены многоуровневые фильтры
3. ✅ Заменен слайдер радиуса на предустановленные значения (5, 10, 15, 20 км)
4. ✅ Обновлена логика фильтрации на бэкенде для поддержки категорий всех уровней
5. ✅ Убраны `service_ids` и `custom_service_name` из фильтров

**Файлы изменены:**
- `backend/src/database/seeds/seed-catalog.ts` - создан seed-скрипт
- `backend/package.json` - добавлен скрипт `seed:catalog`
- `frontend/lib/core/providers/api/categories_tree_provider.dart` - создан провайдер
- `frontend/lib/core/api/api_endpoints.dart` - добавлен endpoint
- `frontend/lib/features/feed/widgets/feed_filters_sheet.dart` - полностью переписан
- `frontend/lib/features/feed/screens/feed_screen.dart` - обновлен
- `frontend/lib/core/providers/api/feed_provider.dart` - обновлен
- `frontend/lib/core/repositories/post_repository.dart` - обновлен
- `backend/src/modules/posts/dto/filter-posts.dto.ts` - обновлен
- `backend/src/modules/posts/posts.service.ts` - обновлена логика фильтрации

**Дата выполнения:** 2026-01-31

**Следующие шаги:**
1. Запустить seed-скрипт: `cd backend && npm run seed:catalog`
2. Проверить работу фильтров в UI
3. Протестировать фильтрацию по категориям разных уровней

---

## 12. 🔴 500 ошибки в `/posts/feed`, `/favorites` и связь с категориями/услугами

### Проблема
**Симптомы:**
- `500 Internal Server Error` при запросах:
  - `GET /posts/feed`
  - `GET /favorites`
  - `GET /posts/user/:userId`
- Ошибки в логах:
  - `column post.custom_service_name does not exist`
  - `No metadata for "Favorite" was found`
  - `column "descendant_id" does not exist`
  - `column "location_geography" does not exist`

**Причины (основные):**
- В таблице `posts` отсутствовали колонки:
  - `custom_service_name`
  - `category_ids`
  - `location_geography` (PostGIS)
- Сущность `Favorite` не была зарегистрирована в общем списке `entities` TypeORM.
- Таблица `categories_closure` имеет колонки `id_ancestor` / `id_descendant`, а в SQL использовались `ancestor_id` / `descendant_id`.
- Логика фильтрации по категориям использовала несовместимый синтаксис для массивов UUID.
- Координаты (`location_lat`, `location_lng`) приходили как `DECIMAL` и в JSON могли быть строками, что ломало фронтенд (`type 'String' is not a subtype of type 'num?'`).

### Решение

**1. Схема БД и связи:**
- Добавлена колонка `custom_service_name` в таблицу `posts`:
  - Тип: `TEXT`
  - Создан GIN индекс для полнотекстового поиска:
    - `IDX_posts_custom_service_gin ON posts USING gin(to_tsvector('russian', COALESCE(custom_service_name, '')))`
- Добавлена колонка `category_ids UUID[]` в таблицу `posts`:
  - Используется для прямой связи поста с категориями (в дополнение к `post_services`).
  - Заполняется при seeding:
    - по категориям услуг, связанным через `post_services`
    - либо по `master_profiles.category_ids`, если услуг нет.
- Создана сущность `PostService` и таблица `post_services`:
  - Связь многие-ко-многим между `posts` и `services`.
  - Уникальный ключ на (`post_id`, `service_id`).
  - Индексы по `post_id` и `service_id`.

**2. PostGIS и геопоиск:**
- В `init.sql` включён PostGIS:
  - `CREATE EXTENSION IF NOT EXISTS postgis;`
- В таблицу `posts` добавлена колонка:
  - `location_geography geography(POINT, 4326)`
- Создан GIST-индекс:
  - `IDX_posts_location_geography`
- Данные для `location_geography` заполняются из `location_lat` / `location_lng`:
  - `UPDATE posts SET location_geography = ST_SetSRID(ST_MakePoint(location_lng, location_lat), 4326)::geography WHERE ...`
- В `PostsService.getFeed`:
  - Используется `ST_DWithin` для фильтрации по радиусу.
  - Используется `ST_Distance` для выборки расстояния (в км).

**3. Closure table и фильтрация по категориям:**
- В `categories_closure` реальные колонки: `id_ancestor`, `id_descendant`.
- SQL-запрос в `posts.service.ts` исправлен:
  - Было: `SELECT DISTINCT descendant_id FROM categories_closure WHERE ancestor_id = ANY($1::uuid[])`
  - Стало: `SELECT DISTINCT id_descendant FROM categories_closure WHERE id_ancestor = ANY($1::uuid[])`
- Маппинг результата:
  - `row: { id_descendant: string } => row.id_descendant`
- Общая логика:
  1. Берём `category_ids` из запроса.
  2. Ищем всех потомков через closure table.
  3. Объединяем исходные ID + потомков → `uniqueCategoryIds`.
  4. Фильтруем посты:
     - `post.category_ids && :uniqueCategoryIds` (оператор пересечения массивов).

**4. DTO и обработка массива `category_ids`:**
- В `FilterPostsDto` добавлен `@Transform`, чтобы корректно обрабатывать как строку, так и массив:

```ts
@ApiPropertyOptional({
  description: 'Фильтр по категориям (любого уровня: корневые, подкатегории, услуги)',
  type: [String],
  example: ['uuid-1', 'uuid-2'],
})
@IsOptional()
@Transform(({ value }) => {
  if (Array.isArray(value)) return value;
  if (typeof value === 'string') return [value];
  return [];
})
@IsUUID('4', { each: true })
category_ids?: string[];
```

Это соответствует тому, как Flutter Web отправляет query-параметры:
- `category_ids=id1&id=category_ids=id2&...`

**5. Сущность Favorite и 500 в `/favorites`:**
- Сущность `Favorite` добавлена в `backend/src/config/entities.ts`:
  - импорт: `Favorite` из `modules/favorites/entities/favorite.entity.ts`
  - добавлена в массив `entities`.
- После этого TypeORM видит метаданные, и `/favorites` работает без ошибок.

**6. Координаты и типы (backend + frontend):**
- В `PostsMapper` (`posts.mapper.ts`) явно конвертируем `location_lat` / `location_lng` в числа:

```ts
const locationLat = post.location_lat != null
  ? (typeof post.location_lat === 'string' ? parseFloat(post.location_lat) : post.location_lat)
  : null;
const locationLng = post.location_lng != null
  ? (typeof post.location_lng === 'string' ? parseFloat(post.location_lng) : post.location_lng)
  : null;
```

- На фронтенде в `PostModel` добавлен конвертер:

```dart
class NullableStringToDoubleConverter implements JsonConverter<double?, dynamic> {
  const NullableStringToDoubleConverter();

  @override
  double? fromJson(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  @override
  dynamic toJson(double? value) => value;
}
```

и используется для полей:

```dart
@NullableStringToDoubleConverter() @JsonKey(name: 'location_lat') double? locationLat,
@NullableStringToDoubleConverter() @JsonKey(name: 'location_lng') double? locationLng,
```

Это устранило ошибки вида:
- `TypeError: "55.97275504": type 'String' is not a subtype of type 'num?'`

### Оценка времени: 8–12 часов

### ✅ Статус: ВЫПОЛНЕНО

**Что было сделано:**
1. ✅ Добавлены и проиндексированы `custom_service_name`, `category_ids`, `location_geography` в `posts`.
2. ✅ Реализована таблица `post_services` и сущность `PostService`, связь постов с услугами.
3. ✅ Исправлены запросы к closure table (`id_ancestor` / `id_descendant`), стабилизирована фильтрация по категориям.
4. ✅ Добавлен `@Transform` для `category_ids` в `FilterPostsDto`.
5. ✅ Зарегистрирована сущность `Favorite` в `entities.ts`, починен `/favorites`.
6. ✅ Исправлены типы координат (backend + frontend), устранены соответствующие `TypeError` во Flutter.

**Файлы изменены (ключевые):**
- `backend/src/config/entities.ts`
- `backend/src/config/typeorm.config.ts`
- `backend/src/database/migrations/1769962944841-AddPostServicesAndCustomService.ts`
- `backend/src/database/migrations/20260202021329-AddCategoryIdsToPosts.ts`
- `backend/src/modules/posts/entities/post.entity.ts`
- `backend/src/modules/posts/entities/post-service.entity.ts`
- `backend/src/modules/posts/dto/create-post.dto.ts`
- `backend/src/modules/posts/dto/filter-posts.dto.ts`
- `backend/src/modules/posts/dto/post-response.dto.ts`
- `backend/src/modules/posts/posts.service.ts`
- `backend/src/modules/posts/posts.mapper.ts`
- `backend/src/modules/favorites/entities/favorite.entity.ts`
- `backend/src/common/controllers/health.controller.ts`
- `backend/database/init.sql`
- `frontend/lib/core/models/api/post_model.dart`

---

## 13. 🟢 MinIO, шрифты и Flutter Web

### Проблема
1. Минорные проблемы с MinIO:
   - Потенциальная разница между внутренним endpoint (`minio`) и публичным URL (`localhost:9000`).
   - Неочевидная конфигурация CORS.
2. Веб-клиент Flutter:
   - Предупреждение: `Could not find a set of Noto fonts to display all missing characters`.
   - Неидеальная поддержка кириллицы по умолчанию.

### Решение

**1. MinIO: публичные URL и CORS**
- Добавлен `MINIO_PUBLIC_URL` в `.env` и `.env.docker` бэкенда:

```dotenv
MINIO_PUBLIC_URL=http://localhost:9000
```

- В `minio.config.ts` добавлено поле `publicUrl`, бэкенд использует его для генерации публичных ссылок:

```ts
publicUrl: process.env.MINIO_PUBLIC_URL || 'http://localhost:9000',
```

- В `UploadService` ссылки теперь строятся через `MINIO_PUBLIC_URL`, а не через внутренний endpoint.
- В Docker настроен CORS для бакетов через `docker/minio-cors.json` и сервис `minio_createbuckets`.

**2. Flutter Web: шрифты и CanvasKit**
- В `pubspec.yaml` уже был подключен `google_fonts`.
- В `AppTheme` заменён шрифт:
  - Было: `GoogleFonts.interTextTheme()`
  - Стало: `GoogleFonts.robotoTextTheme()` — лучшая поддержка кириллицы.
- Рекомендованный запуск Flutter Web:

```bash
cd frontend && flutter run -d chrome
```

**Примечание:** В Flutter 3.35+ флаг `--web-renderer` удален. Рендерер выбирается автоматически.

CanvasKit даёт более предсказуемый рендеринг шрифтов и устранение предупреждений по Noto.

### Оценка времени: 1–2 часа

### ✅ Статус: ВЫПОЛНЕНО

**Что было сделано:**
1. ✅ Минімізирован риск несоответствия MinIO URL между бэкендом и фронтендом.
2. ✅ Настроен CORS для MinIO бакетов.
3. ✅ Улучшена поддержка кириллицы на Flutter Web (Roboto + CanvasKit).

**Файлы изменены (ключевые):**
- `backend/.env`
- `backend/.env.docker`
- `backend/src/config/minio.config.ts`
- `backend/src/modules/upload/upload.service.ts`
- `docker/minio-cors.json`
- `backend/scripts/check-minio-access.ps1`
- `backend/scripts/check-minio-access.sh`
- `frontend/pubspec.yaml`
- `frontend/lib/core/theme/app_theme.dart`

---

## 14. 🟡 Сохранение сессии в браузере (Session Persistence)

### Проблема
**Симптомы:** После перезагрузки страницы (F5) пользователь выходит из системы и должен заново вводить логин и пароль.  
**Причина:** Сессия не сохраняется между перезагрузками страницы, хотя токены должны храниться в `FlutterSecureStorage` (на Web используется `localStorage`).

### Файлы для изменения
- `frontend/lib/core/repositories/auth_repository.dart` - проверка сохранения токенов
- `frontend/lib/core/providers/api/auth_provider.dart` - проверка auto-login
- `frontend/lib/features/auth/screens/splash_screen.dart` - логика проверки при старте
- `frontend/lib/core/api/api_interceptors.dart` - добавление токена в запросы

### Решение

**1. Проверка сохранения токенов**
- Убедиться, что `FlutterSecureStorage` корректно работает на Web
- Проверить DevTools → Application → Local Storage на наличие ключей:
  - `access_token`
  - `refresh_token`
  - `user_id`

**2. Улучшение логики проверки в SplashScreen**
- Использовать `ref.watch(authNotifierProvider)` вместо `ref.read()` для ожидания загрузки
- Или использовать `await ref.read(authNotifierProvider.future)` для явного ожидания

**3. Проверка работы AuthInterceptor**
- Убедиться, что токен автоматически добавляется в заголовки запросов
- Проверить Network tab в DevTools - должен быть заголовок `Authorization: Bearer <token>`

### Шаги

```dart
// Вариант 1: Использовать ref.watch в SplashScreen
@override
Widget build(BuildContext context) {
  final authState = ref.watch(authNotifierProvider);
  
  return authState.when(
    data: (state) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigateBasedOnAuth(state.isAuthenticated);
      });
      return _buildSplash();
    },
    loading: () => _buildSplash(),
    error: (_, __) => _buildSplash(),
  );
}

// Вариант 2: Явно ждать загрузки
Future<void> _checkAuthAndNavigate() async {
  await Future.delayed(const Duration(seconds: 1));
  
  if (!mounted) return;
  
  // Ждем загрузки AuthNotifier
  final authState = await ref.read(authNotifierProvider.future);
  final isAuthenticated = authState.isAuthenticated;
  
  // ... остальная логика навигации
}
```

### Оценка времени: 2-4 часа

### 🟡 Статус: В РАБОТЕ

**Текущее состояние:**
1. ✅ Токены сохраняются в `FlutterSecureStorage` (на Web используется `localStorage`)
2. ✅ Auto-login реализован через `AuthNotifier.build()`
3. ✅ `AuthInterceptor` добавляет токен в запросы
4. ⚠️ Возможна проблема с таймаутом в `SplashScreen` или логикой проверки

**Что нужно проверить:**
1. Проверить DevTools → Application → Local Storage - есть ли ключи токенов
2. Проверить Network tab - добавляется ли токен в заголовки запросов
3. Улучшить логику проверки в `SplashScreen` для явного ожидания загрузки `AuthNotifier`

**Файлы для изменения:**
- `frontend/lib/features/auth/screens/splash_screen.dart` - улучшить логику проверки
- `frontend/lib/core/providers/api/auth_provider.dart` - проверить работу auto-login
- `frontend/lib/core/repositories/auth_repository.dart` - проверить сохранение токенов

**Дата начала:** 2026-02-02

---
