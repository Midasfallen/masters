# Flutter v2.0 Prototype - Setup Guide

**Статус:** Foundation готов, требуется создание feature screens
**Версия:** 2.0.0
**Дата:** Декабрь 2025

---

## ✅ Что УЖЕ ГОТОВО

### 1. Инфраструктура
- ✅ `pubspec.yaml` обновлен с всеми необходимыми пакетами:
  - flutter_riverpod (state management)
  - freezed (immutable models)
  - go_router (navigation)
  - faker (mock data)
  - flutter_staggered_grid_view (Feed grid)
  - image_picker, cached_network_image

- ✅ `main.dart` настроен с ProviderScope
- ✅ Существующие screens (v1.0):
  - SplashScreen
  - OnboardingScreen
  - RoleSelectionScreen
  - LoginScreen
  - RegisterScreen
  - HomeScreen, SearchScreen, ProfileScreen, etc.

### 2. Документация
- ✅ `PROJECT_V2_STRUCTURE.md` - полная структура проекта
- ✅ Этот README с инструкциями

---

## ⏳ Что НУЖНО СОЗДАТЬ для рабочего прототипа

Я создал blueprint всего проекта. Теперь нужно реализовать ключевые компоненты:

### Priority 1: Core Foundation (1-2 часа)

#### 1. Models (Freezed)

**Создать:** `lib/core/models/post.dart`
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'post.freezed.dart';
part 'post.g.dart';

@freezed
class Post with _$Post {
  const factory Post({
    required String id,
    required String masterId,
    required String masterName,
    required String masterAvatar,
    required String description,
    required List<String> mediaUrls,
    required int likesCount,
    required int commentsCount,
    required bool isLiked,
    required DateTime createdAt,
    List<String>? tags,
  }) = _Post;

  factory Post.fromJson(Map<String, dynamic> json) => _$PostFromJson(json);
}
```

**Создать:** `lib/core/models/user.dart`
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    required String avatar,
    required String role, // 'client' | 'master'
    String? bio,
    int? followersCount,
    int? followingCount,
    bool? isFollowing,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

**Создать:** `lib/core/models/message.dart`
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'message.freezed.dart';
part 'message.g.dart';

@freezed
class Message with _$Message {
  const factory Message({
    required String id,
    required String chatId,
    required String senderId,
    required String senderName,
    required String senderAvatar,
    required String type, // 'text', 'image', 'video', etc.
    required String content,
    required DateTime createdAt,
    required String status, // 'sent', 'delivered', 'read'
    String? mediaUrl,
  }) = _Message;

  factory Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);
}
```

#### 2. Mock Data Provider

**Создать:** `lib/core/providers/mock_data_provider.dart`
```dart
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:faker/faker.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../models/message.dart';

final mockPostsProvider = Provider<List<Post>>((ref) {
  final faker = Faker();
  final random = Random();

  return List.generate(50, (index) {
    return Post(
      id: faker.guid.guid(),
      masterId: faker.guid.guid(),
      masterName: faker.person.name(),
      masterAvatar: 'https://i.pravatar.cc/150?img=$index',
      description: faker.lorem.sentence(),
      mediaUrls: List.generate(
        random.nextInt(3) + 1,
        (i) => 'https://picsum.photos/400/${400 + random.nextInt(200)}?random=${index}_$i',
      ),
      likesCount: random.nextInt(500),
      commentsCount: random.nextInt(100),
      isLiked: random.nextBool(),
      createdAt: DateTime.now().subtract(Duration(hours: random.nextInt(48))),
      tags: ['Маникюр', 'Красота', 'Москва'].take(random.nextInt(3)).toList(),
    );
  });
});

final mockUsersProvider = Provider<List<User>>((ref) {
  final faker = Faker();
  return List.generate(20, (index) {
    return User(
      id: faker.guid.guid(),
      name: faker.person.name(),
      email: faker.internet.email(),
      avatar: 'https://i.pravatar.cc/150?img=${index + 50}',
      role: index % 3 == 0 ? 'master' : 'client',
      bio: faker.lorem.sentence(),
      followersCount: Random().nextInt(1000),
      followingCount: Random().nextInt(500),
      isFollowing: Random().nextBool(),
    );
  });
});

final mockMessagesProvider = Provider.family<List<Message>, String>((ref, chatId) {
  final faker = Faker();
  return List.generate(20, (index) {
    return Message(
      id: faker.guid.guid(),
      chatId: chatId,
      senderId: index % 2 == 0 ? 'me' : 'other',
      senderName: index % 2 == 0 ? 'Вы' : faker.person.name(),
      senderAvatar: 'https://i.pravatar.cc/150?img=$index',
      type: 'text',
      content: faker.lorem.sentence(),
      createdAt: DateTime.now().subtract(Duration(minutes: index * 5)),
      status: ['sent', 'delivered', 'read'][Random().nextInt(3)],
    );
  });
});
```

#### 3. Router

**Создать:** `lib/core/routing/app_router.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/feed/screens/feed_screen.dart';
import '../../shared/widgets/main_navigation.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/feed', // Для прототипа сразу в Feed
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/',
        builder: (context, state) => const MainNavigationScreen(),
        routes: [
          GoRoute(
            path: 'feed',
            builder: (context, state) => const FeedScreen(),
          ),
        ],
      ),
    ],
  );
});
```

### Priority 2: Main Screens (2-3 часа)

#### 4. Feed Screen (главный экран v2.0)

**Создать:** `lib/features/feed/screens/feed_screen.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../../../core/providers/mock_data_provider.dart';
import '../widgets/post_card.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(mockPostsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Feed'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box_outlined),
            onPressed: () {
              // Navigate to Create Post
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Refresh logic
        },
        child: MasonryGridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return PostCard(post: posts[index]);
          },
        ),
      ),
    );
  }
}
```

#### 5. Post Card Widget

**Создать:** `lib/features/feed/widgets/post_card.dart`
```dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../core/models/post.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          CachedNetworkImage(
            imageUrl: post.mediaUrls.first,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 200,
              color: Colors.grey[300],
            ),
          ),

          // Master info
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 12,
                  backgroundImage: CachedNetworkImageProvider(post.masterAvatar),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    post.masterName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Icon(
                  post.isLiked ? Icons.favorite : Icons.favorite_border,
                  size: 18,
                  color: post.isLiked ? Colors.red : null,
                ),
                const SizedBox(width: 4),
                Text('${post.likesCount}', style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 12),
                const Icon(Icons.comment_outlined, size: 18),
                const SizedBox(width: 4),
                Text('${post.commentsCount}', style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
```

#### 6. Main Navigation

**Обновить:** `lib/shared/widgets/main_navigation.dart`
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/feed/screens/feed_screen.dart';
import '../../features/search/screens/search_screen.dart';
import '../../features/chats/screens/chats_list_screen.dart';
import '../../features/profile/screens/profile_screen.dart';

final selectedIndexProvider = StateProvider<int>((ref) => 0);

class MainNavigationScreen extends ConsumerWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedIndex = ref.watch(selectedIndexProvider);

    final screens = [
      const FeedScreen(),
      const SearchScreen(),
      const ChatsListScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      body: screens[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) => ref.read(selectedIndexProvider.notifier).state = index,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Поиск'),
          BottomNavigationBarItem(icon: Icon(Icons.chat_bubble_outline), label: 'Чаты'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}
```

---

## 🚀 Команды для запуска

```bash
# 1. Установка зависимостей
cd /home/user/masters/frontend
flutter pub get

# 2. Генерация кода (Freezed, JSON serialization)
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Запуск приложения
flutter run

# Если есть ошибки компиляции, очистить:
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter run
```

---

## 📝 Следующие шаги (опционально)

После создания базового прототипа можно добавить:

### Дополнительные экраны:
- **Post Detail Screen** - детальный просмотр поста с комментариями
- **Create Post Screen** - создание нового поста с image picker
- **Chat Screen** - экран чата с сообщениями
- **Friends Screen** - список друзей
- **Notifications Screen** - уведомления

### Улучшения:
- Анимации переходов
- Pull-to-refresh на Feed
- Shimmer loading
- Hero transitions для изображений
- Swipe gestures

---

## 🐛 Troubleshooting

### Ошибка: "No pubspec.lock file found"
```bash
flutter pub get
```

### Ошибка: "Missing generated files"
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Ошибка: "Undefined name 'Post'"
- Убедитесь что создали файлы моделей
- Запустите build_runner
- Проверьте import в файлах

### Ошибка компиляции после генерации
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

---

## ✅ Чеклист готовности прототипа

- [ ] Создать models (Post, User, Message)
- [ ] Создать mock_data_provider.dart
- [ ] Создать app_router.dart
- [ ] Создать feed_screen.dart
- [ ] Создать post_card.dart
- [ ] Обновить main_navigation.dart
- [ ] Запустить build_runner
- [ ] Запустить приложение
- [ ] Протестировать навигацию
- [ ] Проверить отображение Feed

---

## 📞 Помощь

Если нужна помощь с созданием недостающих файлов - попросите создать конкретные компоненты!

**Пример:** "Создай ChatScreen с mock сообщениями" или "Создай Notifications screen"

---

**Статус:** Готов к разработке! 🚀
**Next:** Создайте файлы из Priority 1 и запустите прототип
