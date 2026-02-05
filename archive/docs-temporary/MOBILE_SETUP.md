# Настройка мобильного приложения

## Содержание
- [Требования](#требования)
- [Настройка для USB-подключения](#настройка-для-usb-подключения)
- [Настройка для WiFi](#настройка-для-wifi)
- [Частые проблемы и решения](#частые-проблемы-и-решения)

## Требования

- Flutter SDK 3.35.3 или выше
- Android SDK
- Устройство Android или эмулятор
- Docker Desktop (для backend)

## Настройка для USB-подключения

### 1. Запуск backend инфраструктуры

```bash
cd backend
docker-compose up -d
```

Проверьте статус всех контейнеров:
```bash
docker-compose ps
```

Все сервисы должны быть `healthy`:
- PostgreSQL (порт 5433)
- Redis (порт 6379)
- MinIO (порт 9000)
- Backend API (порт 3000)
- Meilisearch (порт 7700)
- MailHog (порт 8025)

### 2. Настройка ADB Reverse

ADB reverse позволяет устройству обращаться к `localhost` хоста через USB.

```bash
# Проверьте подключенные устройства
adb devices

# Настройте проброс портов (нужно делать после каждого переподключения)
adb -s <DEVICE_ID> reverse tcp:3000 tcp:3000  # Backend API
adb -s <DEVICE_ID> reverse tcp:9000 tcp:9000  # MinIO

# Проверьте активные пробросы
adb reverse --list
```

### 3. Конфигурация приложения

В файле `frontend/lib/core/config/app_config.dart`:

```dart
static const bool _isAdbReverse = true;  // Для USB
static const String _localIp = '192.168.1.4';  // Для WiFi
```

### 4. Сборка и установка

```bash
cd frontend

# Соберите APK
flutter build apk --debug

# Установите на устройство
adb -s <DEVICE_ID> install build/app/outputs/flutter-apk/app-debug.apk

# Или запустите напрямую
flutter run -d <DEVICE_ID>
```

## Настройка для WiFi

### 1. Узнайте IP адрес вашего ПК

**Windows:**
```bash
ipconfig
# Найдите IPv4 адрес (обычно 192.168.x.x)
```

**macOS/Linux:**
```bash
ifconfig | grep "inet "
```

### 2. Обновите конфигурацию

В `frontend/lib/core/config/app_config.dart`:

```dart
static const bool _isAdbReverse = false;  // Отключите adb reverse
static const String _localIp = '192.168.1.4';  // Ваш IP адрес
```

### 3. Убедитесь, что устройство в той же сети WiFi

Устройство и ПК должны быть подключены к одному WiFi роутеру.

### 4. Пересоберите приложение

```bash
flutter build apk --debug
adb install -r build/app/outputs/flutter-apk/app-debug.apk
```

## Частые проблемы и решения

### Проблема: "No internet connection"

**Причины:**
1. Отсутствуют разрешения в AndroidManifest.xml
2. Не настроен adb reverse
3. Backend не запущен

**Решение:**

1. Проверьте AndroidManifest.xml:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- Разрешения интернета -->
    <uses-permission android:name="android.permission.INTERNET"/>
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>

    <application
        android:usesCleartextTraffic="true"
        android:networkSecurityConfig="@xml/network_security_config">
    </application>
</manifest>
```

2. Настройте adb reverse (см. раздел выше)

3. Проверьте backend:
```bash
curl http://localhost:3000/api/v2/auth/login
```

### Проблема: "type '_Map<String, dynamic>' is not a subtype of type 'List<dynamic>'"

**Причина:** API возвращает данные в формате `{data: [...], meta: {...}}`, но код ожидает прямой массив.

**Решение:** Используйте `ApiHelpers.parseListResponse()`:

```dart
// Неправильно
final List<dynamic> data = response.data;

// Правильно
final data = ApiHelpers.parseListResponse(response.data);
```

### Проблема: "type 'Null' is not a subtype of type 'String' in type cast"

**Причина:** Модель ожидает обязательные поля, которые API не возвращает.

**Решение:** Сделайте поля опциональными или добавьте значения по умолчанию:

```dart
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    String? fullName,  // Опциональное
    @Default(0.0) double rating,  // Значение по умолчанию
  }) = _UserModel;
}
```

### Проблема: "type 'String' is not a subtype of type 'num?' in type cast"

**Причина:** Backend возвращает числа как строки (например, `"4.70"` вместо `4.70`).

**Решение:** Используйте конвертер:

```dart
class StringToDoubleConverter implements JsonConverter<double, dynamic> {
  const StringToDoubleConverter();

  @override
  double fromJson(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0.0;
    return 0.0;
  }

  @override
  dynamic toJson(double value) => value;
}

// Использование
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @StringToDoubleConverter() @Default(0.0) double rating,
  }) = _UserModel;
}
```

После изменений моделей обязательно регенерируйте код:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Проблема: Изображения не загружаются

**Причины:**
1. MinIO недоступен с устройства
2. Не настроен adb reverse для порта 9000

**Решение:**

1. Настройте adb reverse для MinIO:
```bash
adb reverse tcp:9000 tcp:9000
```

2. Проверьте доступность MinIO с устройства:
```bash
adb shell curl -I http://localhost:9000/minio/health/live
```

3. Проверьте, что MinIO запущен:
```bash
docker-compose ps minio
curl http://localhost:9000/minio/health/live
```

### Проблема: Backend возвращает 401 Unauthorized

**Причина:** Токен авторизации отсутствует или недействителен.

**Решение:**

1. Проверьте, сохраняется ли токен после логина
2. Проверьте `AuthInterceptor` в `dio_client.dart`
3. Попробуйте повторно залогиниться

### Проблема: Ошибки при сборке после изменения моделей

**Решение:**

```bash
# Очистите кэш
flutter clean

# Получите зависимости
flutter pub get

# Регенерируйте код
flutter pub run build_runner build --delete-conflicting-outputs

# Пересоберите приложение
flutter build apk --debug
```

## Быстрая диагностика

### Проверка инфраструктуры Docker

```bash
cd backend

# Статус контейнеров
docker-compose ps

# Проверка базы данных
docker-compose exec postgres psql -U service_user -d service_db -c "SELECT COUNT(*) FROM posts;"

# Проверка MinIO
docker-compose exec minio mc ls local/posts/ | head -10
```

### Проверка сети с устройства

```bash
# Backend API
adb shell curl http://localhost:3000/api/v2/auth/login

# MinIO
adb shell curl -I http://localhost:9000/minio/health/live

# Регистрация пользователя
adb shell curl -X POST http://localhost:3000/api/v2/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@example.com","password":"Password123","first_name":"Test","last_name":"User","phone":"+79991234567"}'
```

### Проверка логов приложения

```bash
# Очистить логи
adb logcat -c

# Смотреть логи Flutter
adb logcat -s flutter:V

# Смотреть логи с фильтром
adb logcat | grep "Loading feed\|Loaded\|error"
```

## Команды для разработки

```bash
# Запуск в режиме разработки
flutter run -d <DEVICE_ID>

# Hot reload
# Нажмите 'r' в консоли

# Hot restart
# Нажмите 'R' в консоли

# Открыть DevTools
flutter pub global activate devtools
flutter pub global run devtools

# Анализ кода
flutter analyze

# Запуск тестов
flutter test

# Сборка release APK
flutter build apk --release
```

## Полезные ссылки

- [Flutter Installation](https://flutter.dev/docs/get-started/install)
- [ADB Documentation](https://developer.android.com/studio/command-line/adb)
- [Freezed Package](https://pub.dev/packages/freezed)
- [Riverpod Documentation](https://riverpod.dev/)
