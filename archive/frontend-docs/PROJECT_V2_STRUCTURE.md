# Service Platform v2.0 - Flutter Project Structure

**Статус:** Кликабельный прототип с mock данными
**Дата:** Декабрь 2025

---

## 📁 Полная структура проекта

```
lib/
├── main.dart                          # ✅ Entry point with ProviderScope
│
├── core/                              # Ядро приложения
│   ├── constants/
│   │   ├── app_colors.dart           # Цветовая палитра
│   │   ├── app_sizes.dart            # Размеры и отступы
│   │   └── app_strings.dart          # Строки приложения
│   │
│   ├── theme/
│   │   └── app_theme.dart            # ✅ Светлая/темная темы
│   │
│   ├── routing/
│   │   └── app_router.dart           # ⏳ GoRouter navigation
│   │
│   ├── models/                        # Freezed models
│   │   ├── user.dart                 # ⏳ User model
│   │   ├── post.dart                 # ⏳ Post model (Feed)
│   │   ├── master.dart               # Master profile
│   │   ├── service.dart              # Service model
│   │   ├── booking.dart              # Booking model
│   │   ├── message.dart              # Chat message
│   │   ├── notification.dart         # Notification
│   │   └── comment.dart              # Comment model
│   │
│   └── providers/                     # Riverpod providers
│       ├── auth_provider.dart        # ⏳ Auth state
│       └── mock_data_provider.dart   # ⏳ Mock data generation
│
├── features/                          # Модули по фичам
│   ├── auth/                         # Аутентификация
│   │   ├── screens/
│   │   │   ├── splash_screen.dart    # ✅ Существует
│   │   │   ├── onboarding_screen.dart # ✅ 3 слайда
│   │   │   ├── role_selection_screen.dart # ✅ Client/Master
│   │   │   ├── login_screen.dart     # ✅ Вход
│   │   │   └── register_screen.dart  # ✅ Регистрация
│   │   │
│   │   └── providers/
│   │       └── auth_state_provider.dart # Auth logic
│   │
│   ├── feed/                         # 🆕 Feed (главный экран v2.0)
│   │   ├── screens/
│   │   │   ├── feed_screen.dart      # ⏳ 3-колоночная сетка
│   │   │   ├── post_detail_screen.dart # Детали поста
│   │   │   └── create_post_screen.dart # Создание поста
│   │   │
│   │   ├── widgets/
│   │   │   ├── post_card.dart        # Карточка поста
│   │   │   ├── like_button.dart      # Кнопка лайка
│   │   │   └── comment_widget.dart   # Виджет комментария
│   │   │
│   │   └── providers/
│   │       └── feed_provider.dart    # Feed state & logic
│   │
│   ├── social/                       # 🆕 Социальные функции
│   │   ├── screens/
│   │   │   ├── friends_screen.dart   # Список друзей
│   │   │   ├── subscriptions_screen.dart # Подписки
│   │   │   └── user_profile_screen.dart # Профиль юзера
│   │   │
│   │   └── providers/
│   │       ├── friends_provider.dart
│   │       └── subscriptions_provider.dart
│   │
│   ├── chats/                        # 🆕 Чаты (v2.0 с WebSocket)
│   │   ├── screens/
│   │   │   ├── chats_list_screen.dart # Список чатов
│   │   │   └── chat_screen.dart      # Окно чата
│   │   │
│   │   ├── widgets/
│   │   │   ├── message_bubble.dart   # Bubble сообщения
│   │   │   ├── typing_indicator.dart # "Печатает..."
│   │   │   └── message_type_selector.dart # 8 типов
│   │   │
│   │   └── providers/
│   │       └── chats_provider.dart   # Mock WebSocket
│   │
│   ├── notifications/                # 🆕 Уведомления
│   │   ├── screens/
│   │   │   └── notifications_screen.dart
│   │   │
│   │   ├── widgets/
│   │   │   └── notification_card.dart
│   │   │
│   │   └── providers/
│   │       └── notifications_provider.dart # 11 типов
│   │
│   ├── profile/                      # Профиль
│   │   ├── screens/
│   │   │   ├── profile_screen.dart   # ✅ Существует
│   │   │   └── edit_profile_screen.dart
│   │   │
│   │   └── providers/
│   │       └── profile_provider.dart
│   │
│   ├── search/                       # Поиск
│   │   ├── screens/
│   │   │   └── search_screen.dart    # ✅ Существует
│   │   │
│   │   └── providers/
│   │       └── search_provider.dart
│   │
│   ├── master/                       # Профиль мастера
│   │   ├── screens/
│   │   │   └── master_profile_screen.dart # ✅ Существует
│   │   │
│   │   └── providers/
│   │       └── master_provider.dart
│   │
│   ├── bookings/                     # Записи
│   │   ├── screens/
│   │   │   ├── bookings_screen.dart  # ✅ Существует
│   │   │   ├── create_booking_screen.dart
│   │   │   └── booking_detail_screen.dart
│   │   │
│   │   └── providers/
│   │       └── bookings_provider.dart
│   │
│   ├── favorites/                    # 🆕 Избранное
│   │   ├── screens/
│   │   │   └── favorites_screen.dart # ✅ Существует
│   │   │
│   │   └── providers/
│   │       └── favorites_provider.dart
│   │
│   └── settings/                     # Настройки
│       ├── screens/
│       │   └── settings_screen.dart
│       │
│       └── providers/
│           └── settings_provider.dart
│
└── shared/                            # Общие виджеты
    ├── widgets/
    │   ├── main_navigation.dart      # ✅ Bottom navigation
    │   ├── app_bar_widget.dart       # Custom AppBar
    │   ├── master_card.dart          # ✅ Карточка мастера
    │   ├── service_card.dart         # ✅ Карточка услуги
    │   ├── booking_card.dart         # ✅ Карточка записи
    │   ├── review_card.dart          # ✅ Карточка отзыва
    │   ├── search_bar_widget.dart    # ✅ Поисковая строка
    │   ├── loading_shimmer.dart      # Shimmer loading
    │   └── empty_state.dart          # Пустое состояние
    │
    └── utils/
        ├── formatters.dart            # Date/time/price форматтеры
        └── validators.dart            # Input валидаторы
```

---

## 🎨 Ключевые экраны v2.0

### Auth Flow
1. **SplashScreen** → 2сек анимация
2. **OnboardingScreen** → 3 слайда с описанием
3. **RoleSelectionScreen** → Выбор роли (Client/Master)
4. **LoginScreen** / **RegisterScreen**

### Main Flow (после входа)
1. **FeedScreen** (главный экран v2.0)
   - 3-колоночная сетка постов (staggered grid)
   - Pull-to-refresh
   - Infinite scroll
   - Like/Comment/Share buttons

2. **Search** → Поиск мастеров/услуг

3. **Chats** → Список чатов с последними сообщениями

4. **Profile** → Профиль пользователя

5. **BottomNavigation** → Feed | Search | Chats | Profile

---

## 📊 Mock Данные

### Генерация с Faker

```dart
// core/providers/mock_data_provider.dart

final mockPostsProvider = Provider<List<Post>>((ref) {
  final faker = Faker();
  return List.generate(50, (index) {
    return Post(
      id: faker.guid.guid(),
      masterId: faker.guid.guid(),
      masterName: faker.person.name(),
      masterAvatar: 'https://i.pravatar.cc/150?img=$index',
      description: faker.lorem.sentence(),
      mediaUrls: List.generate(
        Random().nextInt(3) + 1,
        (_) => 'https://picsum.photos/400/600?random=$index',
      ),
      likesCount: Random().nextInt(500),
      commentsCount: Random().nextInt(100),
      isLiked: Random().nextBool(),
      createdAt: DateTime.now().subtract(
        Duration(hours: Random().nextInt(48)),
      ),
    );
  });
});
```

### Типы Mock данных:
- ✅ 50+ постов для Feed
- ✅ 20+ мастеров
- ✅ 10+ чатов с сообщениями
- ✅ 15+ уведомлений (11 типов)
- ✅ 5+ друзей
- ✅ 10+ подписок

---

## 🔄 Navigation (GoRouter)

```dart
// core/routing/app_router.dart

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isOnboarding = authState.isFirstLaunch;

      // Logic для редиректов
      if (state.location == '/splash') return null;
      if (!isOnboarding) return '/onboarding';
      if (!isLoggedIn) return '/login';
      return null;
    },
    routes: [
      GoRoute(path: '/splash', builder: (_, __) => SplashScreen()),
      GoRoute(path: '/onboarding', builder: (_, __) => OnboardingScreen()),
      GoRoute(path: '/role', builder: (_, __) => RoleSelectionScreen()),
      GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
      GoRoute(path: '/register', builder: (_, __) => RegisterScreen()),

      // Main app routes
      GoRoute(
        path: '/',
        builder: (_, __) => MainNavigationScreen(),
        routes: [
          GoRoute(path: 'feed', builder: (_, __) => FeedScreen()),
          GoRoute(path: 'post/:id', builder: (_, state) {
            return PostDetailScreen(postId: state.params['id']!);
          }),
          GoRoute(path: 'create-post', builder: (_, __) => CreatePostScreen()),
          GoRoute(path: 'chat/:id', builder: (_, state) {
            return ChatScreen(chatId: state.params['id']!);
          }),
          GoRoute(path: 'profile/:id', builder: (_, state) {
            return UserProfileScreen(userId: state.params['id']!);
          }),
        ],
      ),
    ],
  );
});
```

---

## 🎯 Приоритетные файлы для создания

### High Priority (для рабочего прототипа):

1. **core/models/post.dart** - Post model (Freezed)
2. **core/models/user.dart** - User model
3. **core/providers/mock_data_provider.dart** - Mock data
4. **core/routing/app_router.dart** - Navigation
5. **features/feed/screens/feed_screen.dart** - Главный экран
6. **features/feed/widgets/post_card.dart** - Карточка поста
7. **shared/widgets/main_navigation.dart** - Bottom nav

### Medium Priority:

8. **features/feed/screens/post_detail_screen.dart**
9. **features/feed/screens/create_post_screen.dart**
10. **features/chats/screens/chats_list_screen.dart**
11. **features/chats/screens/chat_screen.dart**
12. **features/social/screens/friends_screen.dart**

---

## 🚀 Запуск прототипа

```bash
cd frontend

# Установка зависимостей
flutter pub get

# Генерация кода (Freezed, Riverpod)
flutter pub run build_runner build --delete-conflicting-outputs

# Запуск
flutter run
```

---

## ✅ Текущий статус

| Компонент | Статус | Описание |
|-----------|--------|----------|
| pubspec.yaml | ✅ Готов | Все пакеты добавлены |
| main.dart | ✅ Готов | ProviderScope настроен |
| Theme | ✅ Готов | Светлая/темная темы |
| Auth screens (v1.0) | ✅ Есть | Onboarding, Login, Register |
| Feed screen | ⏳ TODO | Главный экран v2.0 |
| Models | ⏳ TODO | Freezed models |
| Providers | ⏳ TODO | Mock data providers |
| Navigation | ⏳ TODO | GoRouter setup |
| Chats | ⏳ TODO | Mock WebSocket |

---

## 📝 Следующие шаги

1. ✅ **Создать models** (Post, User, Message, etc.) с Freezed
2. ✅ **Создать mock providers** с Faker
3. ✅ **Реализовать FeedScreen** с staggered grid
4. ✅ **Настроить GoRouter** navigation
5. ✅ **Создать ChatScreen** с mock сообщениями
6. ⏳ **Добавить анимации** и transitions
7. ⏳ **Тестирование** прототипа

---

**Готово к разработке!** 🚀
