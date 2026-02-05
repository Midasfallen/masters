# Service Platform - Flutter Frontend

**Версия:** 2.0.0  
**Статус:** ✅ Production Ready  
**Последнее обновление:** 5 февраля 2026

---

## Описание

Flutter приложение для социальной платформы Service Platform v2.0. Полнофункциональное приложение с интеграцией Backend API, WebSocket чатами и real-time обновлениями.

---

## Быстрый старт

```bash
# 1. Установить зависимости
flutter pub get

# 2. Сгенерировать код (Freezed, JSON serialization)
flutter pub run build_runner build --delete-conflicting-outputs

# 3. Запустить приложение
flutter run -d chrome  # Web
# или
flutter run  # Выбрать устройство интерактивно
```

---

## Структура проекта

```
lib/
├── main.dart                    # Entry point
├── app.dart                     # Root widget
├── core/                        # Ядро приложения
│   ├── api/                     # API клиент (Dio)
│   ├── config/                  # Конфигурация
│   ├── models/                  # Freezed модели
│   ├── providers/               # Riverpod providers
│   ├── repositories/            # Репозитории для API
│   ├── routing/                 # GoRouter навигация
│   ├── services/                # Сервисы (WebSocket, etc.)
│   ├── theme/                   # Material 3 темы
│   └── widgets/                 # Базовые виджеты
├── features/                    # Feature модули
│   ├── auth/                    # Авторизация
│   ├── feed/                    # Лента контента
│   ├── search/                  # Поиск мастеров
│   ├── chats/                   # Чаты
│   ├── bookings/                # Записи
│   ├── profile/                 # Профиль
│   └── ...                      # Другие фичи
└── shared/                       # Общие компоненты
    ├── models/                  # Shared модели
    └── widgets/                 # Переиспользуемые виджеты
```

---

## Технологический стек

- **Flutter 3.x** - Framework
- **Riverpod 2.x** - State management
- **Freezed** - Immutable models
- **go_router** - Navigation
- **Dio** - HTTP client
- **Socket.IO** - WebSocket для чатов
- **Material Design 3** - UI компоненты

---

## Основные функции

- ✅ Авторизация и регистрация
- ✅ Лента контента (Feed) с постами
- ✅ Поиск мастеров и услуг
- ✅ Чаты с real-time сообщениями
- ✅ Бронирование услуг
- ✅ Профили пользователей и мастеров
- ✅ Уведомления
- ✅ Социальные функции (лайки, комментарии, подписки)

---

## Команды разработки

```bash
# Установка зависимостей
flutter pub get

# Генерация кода
flutter pub run build_runner build --delete-conflicting-outputs

# Запуск в режиме разработки
flutter run

# Анализ кода
flutter analyze

# Форматирование
flutter format .

# Тесты
flutter test

# E2E тесты
flutter test integration_test/
```

---

## Конфигурация

### API URL

Настройка базового URL API в `lib/core/config/app_config.dart`:

```dart
static const String apiBaseUrl = 'http://localhost:3000/api/v2';
```

### Переменные окружения

Для production используйте `.env` файл или переменные окружения для:
- API URL
- WebSocket URL
- Firebase credentials (для push уведомлений)

---

## Документация

- **[Getting Started Guide](../docs/guides/GETTING_STARTED.md)** - Полное руководство по запуску
- **[Flutter Setup Guide](../docs/guides/FLUTTER_SETUP.md)** - Настройка Flutter окружения
- **[Architecture](../docs/architecture/ARCHITECTURE.md)** - Архитектура приложения
- **[API Documentation](../docs/technical/API-v2-Summary.md)** - API спецификация

---

## Тестирование

```bash
# Unit тесты
flutter test

# Widget тесты
flutter test test/widget_test.dart

# E2E тесты (Playwright)
cd frontend
npm test
```

---

## Сборка

### Web
```bash
flutter build web --release
```

### Android
```bash
flutter build apk --release
flutter build appbundle --release
```

### iOS
```bash
flutter build ios --release
```

---

## Статус проекта

- ✅ **Backend Integration** - 100% (165 endpoints)
- ✅ **WebSocket Chats** - 100% (real-time сообщения)
- ✅ **E2E Tests** - 73/73 (100%)
- ✅ **Unit Tests** - 185/185 (100%)
- ✅ **Production Ready** - Security, Performance, CI/CD

---

**Для подробной информации см. [START_HERE.md](../START_HERE.md)**
