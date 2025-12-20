# 🚀 Service Platform - Flutter Прототип

## Быстрый старт

Этот гайд поможет запустить Flutter прототип Service Platform с Material 3 за **5 минут**.

---

## ✅ Что уже готово

- ✅ **Brand Book** - полный фирменный стиль
- ✅ **UX/UI Guide** - описание 20+ экранов
- ✅ **Структура проекта** - готовая архитектура
- ✅ **pubspec.yaml** - все зависимости

---

## 📋 Требования

```bash
# Установить Flutter (если ещё нет)
# Посетите: https://docs.flutter.dev/get-started/install

# Проверить установку
flutter doctor
```

---

## 🎯 Инструкция по созданию проекта

### Вариант 1: Автоматическая генерация (рекомендуется)

```bash
# 1. Перейти в директорию проекта
cd /home/user/masters

# 2. Выполнить скрипт генерации
./scripts/generate_flutter_app.sh

# 3. Запустить приложение
cd frontend
flutter pub get
flutter run
```

### Вариант 2: Ручное создание

```bash
# 1. Создать новый Flutter проект
flutter create --org com.serviceplatform service_platform

# 2. Скопировать уже подготовленные файлы
cp -r frontend/* service_platform/

# 3. Установить зависимости
cd service_platform
flutter pub get

# 4. Запустить
flutter run
```

---

## 🎨 Основные файлы (создать вручную)

### 1. `lib/app.dart` - Root Widget

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/theme/app_theme.dart';
import 'core/routing/app_router.dart';

class ServicePlatformApp extends StatefulWidget {
  const ServicePlatformApp({super.key});

  @override
  State<ServicePlatformApp> createState() => _ServicePlatformAppState();
}

class _ServicePlatformAppState extends State<ServicePlatformApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _changeTheme(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Service Platform',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      routerConfig: AppRouter.router,
    );
  }
}
```

### 2. `lib/core/theme/app_theme.dart` - Темы

```dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Цвета из Brand Book
  static const Color primaryColor = Color(0xFF6750A4);
  static const Color secondaryColor = Color(0xFFE91E63);
  static const Color tertiaryColor = Color(0xFF00BCD4);

  // Светлая тема
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
      ),
      textTheme: GoogleFonts.interTextTheme(),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // Тёмная тема
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        secondary: secondaryColor,
        tertiary: tertiaryColor,
        brightness: Brightness.dark,
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
      appBarTheme: const AppBarTheme(
        centerTitle: false,
        elevation: 0,
      ),
      cardTheme: CardTheme(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  // Кастомная тема (фиолетовая)
  static ThemeData get customTheme {
    final base = lightTheme;
    return base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        primary: const Color(0xFF9C27B0), // Purple
        secondary: const Color(0xFFFF4081), // Pink accent
        tertiary: const Color(0xFF7C4DFF), // Deep purple
      ),
    );
  }
}
```

### 3. `lib/core/routing/app_router.dart` - Навигация

```dart
import 'package:go_router/go_router.dart';
import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';
import '../../features/auth/screens/role_selection_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/home/screens/home_screen.dart';
import '../../shared/widgets/main_navigation.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Auth flow
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/role',
        builder: (context, state) => const RoleSelectionScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Main app with bottom navigation
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigation(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/favorites',
            builder: (context, state) => const FavoritesScreen(),
          ),
          GoRoute(
            path: '/bookings',
            builder: (context, state) => const BookingsScreen(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
    ],
  );
}
```

### 4. Mock данные

Создайте файл `lib/data/mock/mock_masters.dart`:

```dart
class MockMaster {
  final String id;
  final String name;
  final String category;
  final double rating;
  final int reviewsCount;
  final double distance;
  final String priceFrom;
  final String avatar;
  final bool verified;

  MockMaster({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.reviewsCount,
    required this.distance,
    required this.priceFrom,
    required this.avatar,
    this.verified = false,
  });
}

// Список мастеров для демо
final List<MockMaster> mockMasters = [
  MockMaster(
    id: '1',
    name: 'Anna Ivanova',
    category: 'Парикмахер',
    rating: 4.9,
    reviewsCount: 234,
    distance: 2.3,
    priceFrom: '2000₽',
    avatar: 'https://i.pravatar.cc/150?img=1',
    verified: true,
  ),
  MockMaster(
    id: '2',
    name: 'Maria Smirnova',
    category: 'Косметолог',
    rating: 4.8,
    reviewsCount: 189,
    distance: 1.5,
    priceFrom: '3000₽',
    avatar: 'https://i.pravatar.cc/150?img=5',
    verified: true,
  ),
  MockMaster(
    id: '3',
    name: 'Elena Petrova',
    category: 'Мастер маникюра',
    rating: 5.0,
    reviewsCount: 412,
    distance: 0.8,
    priceFrom: '1500₽',
    avatar: 'https://i.pravatar.cc/150?img=9',
    verified: true,
  ),
  // Добавьте ещё мастеров...
];
```

---

## 📱 Основные экраны

### Splash Screen

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  void _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primary,
              Theme.of(context).colorScheme.secondary,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Icon(
                Icons.star_rounded,
                size: 100,
                color: Colors.white,
              ),
              const SizedBox(height: 24),
              Text(
                'SERVICE',
                style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'Platform',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 48),
              const CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
```

### Home Screen (пример)

```dart
import 'package:flutter/material.dart';
import '../../../data/mock/mock_masters.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Hero title
          Text(
            'Найди своего мастера',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // Search bar
          SearchBar(
            hintText: 'Поиск мастера или услуги...',
            leading: const Icon(Icons.search),
            onTap: () {
              // Navigate to search
            },
          ),
          const SizedBox(height: 24),

          // Categories
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Категории',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {},
                child: const Text('Все'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _CategoryChip(icon: '💇', label: 'Beauty'),
                _CategoryChip(icon: '💆', label: 'Spa'),
                _CategoryChip(icon: '🏋️', label: 'Fitness'),
                _CategoryChip(icon: '📚', label: 'Education'),
                _CategoryChip(icon: '🔧', label: 'Repair'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Masters nearby
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Рядом с вами',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              TextButton(
                onPressed: () {},
                child: const Text('На карте'),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Masters list
          ...mockMasters.map((master) => _MasterCard(master: master)),
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String icon;
  final String label;

  const _CategoryChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ActionChip(
        avatar: Text(icon, style: const TextStyle(fontSize: 24)),
        label: Text(label),
        onPressed: () {},
      ),
    );
  }
}

class _MasterCard extends StatelessWidget {
  final MockMaster master;

  const _MasterCard({required this.master});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage(master.avatar),
        ),
        title: Row(
          children: [
            Text(master.name),
            if (master.verified) ...[
              const SizedBox(width: 4),
              const Icon(Icons.verified, size: 16, color: Colors.blue),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('⭐ ${master.rating} (${master.reviewsCount}) · ${master.distance} км'),
            Text('${master.category} · от ${master.priceFrom}'),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.favorite_outline),
          onPressed: () {},
        ),
        onTap: () {
          // Navigate to master profile
        },
      ),
    );
  }
}
```

---

## 🎨 Переключение темы

Добавьте в Settings Screen:

```dart
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Настройки')),
      body: ListView(
        children: [
          ListTile(
            leading: const Icon(Icons.palette_outlined),
            title: const Text('Тема'),
            subtitle: const Text('Светлая'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              // Show theme selection dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Выбрать тему'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RadioListTile(
                        title: const Text('Системная'),
                        value: ThemeMode.system,
                        groupValue: ThemeMode.light,
                        onChanged: (value) {},
                      ),
                      RadioListTile(
                        title: const Text('Светлая'),
                        value: ThemeMode.light,
                        groupValue: ThemeMode.light,
                        onChanged: (value) {},
                      ),
                      RadioListTile(
                        title: const Text('Тёмная'),
                        value: ThemeMode.dark,
                        groupValue: ThemeMode.light,
                        onChanged: (value) {},
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
```

---

## 🚀 Следующие шаги

1. **Запустить приложение** и проверить навигацию
2. **Протестировать смену темы**
3. **Пройтись по всем экранам**
4. **Оценить UX/UI**
5. **Утвердить дизайн**

После утверждения дизайна:
- Подключить к Backend API
- Добавить state management (Riverpod)
- Реализовать бизнес-логику
- Добавить тесты

---

## 📚 Документация

- [Brand Book](docs/design/BrandBook.md)
- [UX/UI Guide](docs/design/UXUI-Guide.md)
- [API Specification](docs/technical/API.md)
- [Tech Spec](docs/technical/TechSpec.md)

---

## ❓ Помощь

Если возникли проблемы:

```bash
flutter doctor        # Проверить установку
flutter clean         # Очистить кэш
flutter pub get       # Переустановить зависимости
flutter run -v        # Запустить с verbose логами
```

---

**Статус:** Готов к разработке
**Версия:** 1.0
**Дата:** Декабрь 2025
