# Service Platform Frontend

Flutter приложение для платформы Service с Material 3 дизайном.

## Особенности

✨ **Material 3** - современный дизайн с динамическими цветами
🎨 **3 темы** - Светлая, Тёмная, Кастомная (фиолетовая)
📱 **Адаптивный** - работает на iOS, Android и Web
🎯 **Чистая архитектура** - features, shared, core разделение
🧭 **Навигация** - go_router с type-safe роутингом
🎭 **Mock данные** - готовые данные для прототипа

## Требования

- Flutter SDK ≥ 3.2.0
- Dart SDK ≥ 3.2.0

## Установка

```bash
# 1. Установить зависимости
flutter pub get

# 2. Запустить на нужном устройстве
flutter run

# Для Web
flutter run -d chrome

# Для конкретного устройства
flutter devices
flutter run -d <device_id>
```

## Структура проекта

```
lib/
├── main.dart                    # Точка входа
├── app.dart                     # Root widget
│
├── core/                        # Ядро приложения
│   ├── theme/
│   │   ├── app_theme.dart      # Определение тем
│   │   ├── color_schemes.dart  # Цветовые схемы
│   │   └── text_styles.dart    # Типографика
│   ├── routing/
│   │   └── app_router.dart     # Конфигурация роутинга
│   └── constants/
│       ├── app_sizes.dart      # Размеры и отступы
│       └── app_strings.dart    # Текстовые константы
│
├── features/                    # Функциональные модули
│   ├── auth/
│   │   └── screens/
│   │       ├── splash_screen.dart
│   │       ├── onboarding_screen.dart
│   │       ├── role_selection_screen.dart
│   │       ├── login_screen.dart
│   │       └── register_screen.dart
│   ├── home/
│   │   └── screens/
│   │       └── home_screen.dart
│   ├── search/
│   │   └── screens/
│   │       ├── search_screen.dart
│   │       └── master_profile_screen.dart
│   ├── bookings/
│   │   └── screens/
│   │       ├── bookings_screen.dart
│   │       ├── service_selection_screen.dart
│   │       ├── datetime_selection_screen.dart
│   │       └── booking_confirmation_screen.dart
│   ├── profile/
│   │   └── screens/
│   │       ├── profile_screen.dart
│   │       └── settings_screen.dart
│   └── master/
│       └── screens/
│           ├── master_dashboard_screen.dart
│           ├── manage_services_screen.dart
│           └── manage_schedule_screen.dart
│
├── shared/                      # Общие компоненты
│   ├── widgets/
│   │   ├── common/
│   │   │   ├── app_button.dart
│   │   │   ├── app_text_field.dart
│   │   │   ├── app_card.dart
│   │   │   └── loading_indicator.dart
│   │   ├── master_card.dart
│   │   ├── category_chip.dart
│   │   └── bottom_nav_bar.dart
│   └── models/
│       ├── master.dart
│       ├── service.dart
│       ├── booking.dart
│       └── user.dart
│
└── data/
    └── mock/
        ├── mock_masters.dart
        ├── mock_services.dart
        └── mock_bookings.dart
```

## Темы

### Переключение темы

Приложение поддерживает 3 темы:

1. **Светлая** - дневной режим
2. **Тёмная** - ночной режим
3. **Кастомная** - фиолетовая тема

Переключение: Профиль → Настройки → Тема

### Цвета

**Primary:** Purple `#6750A4`
**Secondary:** Pink `#E91E63`
**Tertiary:** Teal `#00BCD4`

Подробнее в [Brand Book](../docs/design/BrandBook.md)

## Экраны

Реализовано **20+ экранов**:

### Auth Flow
- Splash Screen
- Onboarding (3 страницы)
- Role Selection
- Login
- Register

### Main App
- Home (лента + рекомендации)
- Search (поиск с фильтрами)
- Master Profile
- Service Selection
- Date & Time Selection
- Booking Confirmation
- My Bookings
- Profile (Client)
- Profile (Master)
- Settings

Подробное описание всех экранов в [UX/UI Guide](../docs/design/UXUI-Guide.md)

## Навигация

Используется **go_router** с type-safe роутингом:

```dart
context.go('/home');
context.push('/master/${masterId}');
context.pushNamed('booking', params: {'id': bookingId});
```

### Роуты

```
/                     → Splash
/onboarding           → Onboarding
/role                 → Role Selection
/login                → Login
/register             → Register
/home                 → Home (with bottom nav)
  /home/search        → Search
  /home/favorites     → Favorites
  /home/bookings      → Bookings
  /home/profile       → Profile
/master/:id           → Master Profile
/booking/service      → Service Selection
/booking/datetime     → Date/Time Selection
/booking/confirmation → Confirmation
/settings             → Settings
```

## Mock Данные

Для демонстрации используются **mock данные**:

- 20 мастеров (разные категории)
- 50+ услуг
- 10 предстоящих записей
- 15 завершённых записей

Данные в `lib/data/mock/`

## Запуск без бэкенда

Приложение полностью функционально **БЕЗ бэкенда**:

- Все данные из mock файлов
- Навигация работает полностью
- Можно "походить" по всем экранам
- Интерактивные элементы (кнопки, формы)
- Смена темы в реальном времени

## Команды

```bash
# Запустить приложение
flutter run

# Запустить на Web
flutter run -d chrome

# Сборка для production
flutter build apk                # Android
flutter build ios                # iOS
flutter build web                # Web

# Анализ кода
flutter analyze

# Форматирование
dart format lib/

# Тесты
flutter test
```

## Скриншоты

После запуска вы увидите:

1. **Splash Screen** с логотипом
2. **Onboarding** (можно пропустить)
3. **Выбор роли** (Клиент/Мастер)
4. **Home Screen** с категориями и мастерами
5. **Navigation** между экранами

## Переключение темы

1. Открыть **Profile** (последняя вкладка)
2. Нажать **Настройки** (⚙️)
3. Выбрать **Тема**
4. Выбрать: Светлая / Тёмная / Кастомная

Тема применяется мгновенно!

## Следующие шаги

После тестирования прототипа:

1. ✅ Утвердить дизайн и навигацию
2. ⏭️ Подключить к API (backend)
3. ⏭️ Добавить state management (Riverpod)
4. ⏭️ Реализовать бизнес-логику
5. ⏭️ Добавить тесты

## Документация

- [Brand Book](../docs/design/BrandBook.md) - фирменный стиль
- [UX/UI Guide](../docs/design/UXUI-Guide.md) - описание всех экранов
- [API Specification](../docs/technical/API.md) - спецификация API

## Проблемы?

Если приложение не запускается:

```bash
# Очистить кэш
flutter clean

# Переустановить зависимости
flutter pub get

# Проверить устройства
flutter devices

# Включить Web
flutter config --enable-web

# Проверить Flutter
flutter doctor
```

## Лицензия

© 2025 Service Platform
