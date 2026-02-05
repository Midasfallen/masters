# ПЛАН РЕАЛИЗАЦИИ: Загрузка постов пользователя в ProfileScreen

**Дата:** 30 января 2026
**Статус:** Планирование
**Задача:** Реализовать TODO: "Load posts from API" в profile_screen.dart

---

## КОНТЕКСТ

В `profile_screen.dart:395` есть TODO-комментарий:
```dart
// TODO: Load posts from API
return Center(
  child: Text('$postsCount постов (загрузка в разработке)'),
);
```

### Уже выполнено:
1. Добавлен endpoint `ApiEndpoints.postsByUser(userId)` → `/posts/user/$userId`
2. Добавлен метод `PostRepository.getUserPosts(userId, {page, limit})`

### Требуется:
Интегрировать загрузку постов через API в метод `_buildPostsTab()`.

---

## АНАЛИЗ СУЩЕСТВУЮЩЕЙ АРХИТЕКТУРЫ

### Паттерн из FeedScreen (эталон):
```dart
// StateProviders для infinite scroll
final feedPageProvider = StateProvider<int>((ref) => 1);
final feedPostsListProvider = StateProvider<List<PostModel>>((ref) => []);
final feedHasMoreProvider = StateProvider<bool>((ref) => true);

// GridView.builder с PostCard
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 4,
    mainAxisSpacing: 4,
    childAspectRatio: 1.0,
  ),
  itemBuilder: (context, index) => PostCard(post: posts[index]),
);
```

### Доступные компоненты:
- `PostCard` — виджет отображения поста в сетке (`features/feed/widgets/post_card.dart`)
- `PostRepository.getUserPosts()` — метод загрузки постов пользователя
- `postRepositoryProvider` — Riverpod провайдер репозитория

---

## ПЛАН РЕАЛИЗАЦИИ

### Шаг 1: Создать провайдер для постов пользователя

**Файл:** `frontend/lib/core/providers/api/feed_provider.dart`

Добавить новый провайдер:
```dart
/// User Posts Provider
@riverpod
Future<List<PostModel>> userPosts(
  UserPostsRef ref,
  String userId, {
  int page = 1,
  int limit = 20,
}) async {
  final repository = ref.watch(postRepositoryProvider);
  return await repository.getUserPosts(
    userId,
    page: page,
    limit: limit,
  );
}
```

### Шаг 2: Модифицировать ProfileScreen

**Файл:** `frontend/lib/features/profile/screens/profile_screen.dart`

#### 2.1 Добавить импорты:
```dart
import '../../../core/providers/api/feed_provider.dart';
import '../../../core/models/api/post_model.dart';
import '../../feed/widgets/post_card.dart';
```

#### 2.2 Добавить StateProviders для профиля (после импортов):
```dart
/// Profile Posts Providers для infinite scroll
final profilePostsPageProvider = StateProvider<int>((ref) => 1);
final profilePostsListProvider = StateProvider<List<PostModel>>((ref) => []);
final profileHasMorePostsProvider = StateProvider<bool>((ref) => true);
final profilePostsLoadingProvider = StateProvider<bool>((ref) => false);
```

#### 2.3 Обновить метод `_buildPostsTab`:

Заменить текущую реализацию (строки 363-399) на:
```dart
Widget _buildPostsTab(String userId) {
  final posts = ref.watch(profilePostsListProvider);
  final hasMore = ref.watch(profileHasMorePostsProvider);
  final isLoading = ref.watch(profilePostsLoadingProvider);

  // Загружаем посты при первом показе
  if (posts.isEmpty && !isLoading) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadUserPosts(userId);
    });
  }

  if (posts.isEmpty && isLoading) {
    return const Center(child: CircularProgressIndicator());
  }

  if (posts.isEmpty) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.photo_library_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Нет постов',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Поделитесь своими работами',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  return NotificationListener<ScrollNotification>(
    onNotification: (notification) {
      if (notification is ScrollEndNotification &&
          notification.metrics.pixels >= notification.metrics.maxScrollExtent - 200) {
        if (!isLoading && hasMore) {
          _loadMoreUserPosts(userId);
        }
      }
      return false;
    },
    child: GridView.builder(
      padding: const EdgeInsets.all(4),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 4,
        mainAxisSpacing: 4,
        childAspectRatio: 1.0,
      ),
      itemCount: posts.length + (hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == posts.length) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        }
        return PostCard(post: posts[index]);
      },
    ),
  );
}
```

#### 2.4 Добавить методы загрузки постов:
```dart
Future<void> _loadUserPosts(String userId) async {
  ref.read(profilePostsLoadingProvider.notifier).state = true;
  ref.read(profilePostsPageProvider.notifier).state = 1;
  ref.read(profilePostsListProvider.notifier).state = [];
  ref.read(profileHasMorePostsProvider.notifier).state = true;

  try {
    final posts = await ref.read(userPostsProvider(userId).future);
    if (mounted) {
      ref.read(profilePostsListProvider.notifier).state = posts;
      if (posts.isEmpty || posts.length < 20) {
        ref.read(profileHasMorePostsProvider.notifier).state = false;
      }
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка загрузки постов: ${e.toString()}'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  } finally {
    if (mounted) {
      ref.read(profilePostsLoadingProvider.notifier).state = false;
    }
  }
}

Future<void> _loadMoreUserPosts(String userId) async {
  if (ref.read(profilePostsLoadingProvider)) return;
  ref.read(profilePostsLoadingProvider.notifier).state = true;

  try {
    final currentPage = ref.read(profilePostsPageProvider);
    final nextPage = currentPage + 1;
    ref.read(profilePostsPageProvider.notifier).state = nextPage;

    final newPosts = await ref.read(userPostsProvider(userId, page: nextPage).future);
    if (mounted) {
      final currentPosts = ref.read(profilePostsListProvider);
      ref.read(profilePostsListProvider.notifier).state = [...currentPosts, ...newPosts];

      if (newPosts.isEmpty || newPosts.length < 20) {
        ref.read(profileHasMorePostsProvider.notifier).state = false;
      }
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: ${e.toString()}')),
      );
    }
  } finally {
    if (mounted) {
      ref.read(profilePostsLoadingProvider.notifier).state = false;
    }
  }
}
```

#### 2.5 Обновить вызов _buildPostsTab:

Изменить строку 314:
```dart
// Было:
_buildPostsTab(user.postsCount),

// Стало:
_buildPostsTab(user.id),
```

### Шаг 3: Запустить build_runner

```bash
cd frontend && flutter pub run build_runner build --delete-conflicting-outputs
```

### Шаг 4: Проверить анализатор

```bash
flutter analyze
```

---

## КРИТИЧЕСКИЕ ФАЙЛЫ

| Файл | Действие |
|------|----------|
| `frontend/lib/core/providers/api/feed_provider.dart` | Добавить `userPostsProvider` |
| `frontend/lib/features/profile/screens/profile_screen.dart` | Реализовать загрузку постов |

---

## ВЕРИФИКАЦИЯ

1. **Запустить build_runner:**
   ```bash
   cd frontend && flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Проверить анализатор:**
   ```bash
   flutter analyze
   ```

3. **Запустить тесты:**
   ```bash
   flutter test
   ```

4. **Визуальная проверка:**
   - Запустить приложение
   - Перейти в профиль
   - Убедиться, что посты загружаются в виде сетки
   - Проверить infinite scroll (прокрутка вниз загружает новые посты)
   - Проверить переход на детали поста при клике

---

**План подготовлен:** Claude Code
**Дата:** 30 января 2026
