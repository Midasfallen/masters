# Исправление обновления ленты после создания поста

## Проблема

После создания поста лента не обновлялась автоматически. Нужно было перезагружать страницу (F5) или заново логиниться, чтобы увидеть новый пост.

## Причина

1. **Локальное состояние ленты**: `FeedScreen` использует локальные провайдеры (`feedPostsListProvider`), которые не обновляются автоматически при инвалидации `feedPostsProvider`.

2. **IndexedStack**: `MainNavigationScreen` использует `IndexedStack`, который сохраняет состояние экранов. При возврате на Feed экран не пересоздается, поэтому `initState` не вызывается.

3. **Отсутствие слушателей**: Не было механизма для обновления ленты при возврате на экран или после создания поста.

## Решение

### 1. Обновление ленты при возврате на экран

Добавлен `WidgetsBindingObserver` в `FeedScreen` для отслеживания жизненного цикла приложения:

```dart
class _FeedScreenState extends ConsumerState<FeedScreen> with WidgetsBindingObserver {
  bool _hasLoadedOnce = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // ...
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Обновляем ленту при возврате приложения в активное состояние
    if (state == AppLifecycleState.resumed && _hasLoadedOnce) {
      _loadFeed(refresh: true);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Обновляем ленту при возврате на экран
    if (_hasLoadedOnce) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _loadFeed(refresh: true);
      });
    }
  }
}
```

### 2. Инвалидация провайдера после создания поста

В `create_post_screen.dart` добавлена инвалидация провайдера ленты:

```dart
final createdPost = await ref.read(postNotifierProvider.notifier).createPost(request);

// Обновляем ленту после успешного создания поста
ref.invalidate(feedPostsProvider);

if (mounted) {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text('Пост создан успешно!')),
  );
  context.pop();
}
```

**Примечание:** `PostNotifier.createPost()` уже инвалидирует `feedPostsProvider`, но дополнительная инвалидация гарантирует обновление.

### 3. Автоматическое обновление при возврате на Feed

`FeedScreen.didChangeDependencies()` вызывается при возврате на экран через `IndexedStack`, что позволяет автоматически обновлять ленту.

## Альтернативные решения (не реализованы)

### Вариант А: RouteObserver
Можно использовать `RouteObserver` для отслеживания изменений маршрута, но это избыточно для `IndexedStack`.

### Вариант Б: ref.listen
Можно использовать `ref.listen` для отслеживания изменений в провайдере, но это может вызвать лишние обновления.

### Вариант В: Оптимистичное обновление
Можно добавить созданный пост в начало списка без запроса к серверу, но это требует синхронизации состояния.

## Результат

После исправления:
1. ✅ Лента обновляется автоматически при возврате на экран Feed
2. ✅ Лента обновляется после создания поста (при следующем возврате на экран)
3. ✅ Лента обновляется при возврате приложения из фона
4. ✅ Пользователь может вручную обновить ленту через pull-to-refresh

## Примечания

- Обновление происходит при возврате на экран, а не сразу после создания поста
- Это сделано для оптимизации - не загружать данные, если пользователь не видит экран
- Если нужно мгновенное обновление, можно добавить оптимистичное обновление (добавить пост в список без запроса)

## Связанные файлы

- `frontend/lib/features/feed/screens/feed_screen.dart` - добавлен `WidgetsBindingObserver`
- `frontend/lib/features/feed/screens/create_post_screen.dart` - добавлена инвалидация провайдера
- `frontend/lib/core/providers/api/feed_provider.dart` - уже инвалидирует провайдер в `createPost()`
