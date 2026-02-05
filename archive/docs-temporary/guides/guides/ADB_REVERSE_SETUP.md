# ADB Reverse Setup для Мобильного Тестирования

Это руководство описывает как настроить подключение мобильного Android устройства к локальному backend через USB с использованием `adb reverse`.

## Предварительные требования

1. **Android Debug Bridge (adb)** установлен на вашем ПК
   - Входит в Android SDK Platform-Tools
   - Скачать: https://developer.android.com/studio/releases/platform-tools

2. **USB отладка** включена на Android устройстве
   - Настройки → О телефоне → Нажмите 7 раз на "Номер сборки"
   - Настройки → Для разработчиков → Включить "Отладка по USB"

3. **Устройство подключено** к ПК через USB кабель

4. **Docker Desktop** установлен и запущен

---

## Шаг 1: Проверка подключения устройства

Откройте терминал и выполните:

```bash
adb devices
```

**Ожидаемый вывод:**
```
List of devices attached
ABC123XYZ       device
```

Если устройство показывает статус `unauthorized`, разрешите отладку на экране устройства.

Если устройство не отображается:
```bash
# Перезапустить adb сервер
adb kill-server
adb start-server
adb devices
```

---

## Шаг 2: Настройка Port Forwarding

Пробросьте порты с устройства на ваш ПК:

```bash
# Backend API (основной)
adb reverse tcp:3000 tcp:3000

# PostgreSQL (опционально, для отладки)
adb reverse tcp:5433 tcp:5433

# Redis (опционально)
adb reverse tcp:6379 tcp:6379

# MinIO (опционально)
adb reverse tcp:9000 tcp:9000
```

**Проверка успешной настройки:**
```bash
adb reverse --list
```

**Ожидаемый вывод:**
```
(reverse) tcp:3000 tcp:3000
(reverse) tcp:5433 tcp:5433
(reverse) tcp:6379 tcp:6379
(reverse) tcp:9000 tcp:9000
```

---

## Шаг 3: Проверка соединения с устройства

Проверьте что устройство может подключиться к localhost:3000:

```bash
# Через adb shell
adb shell

# Внутри shell устройства
curl http://localhost:3000/api/v2/health
exit
```

**Ожидаемый ответ:**
```json
{"status":"ok","timestamp":"2026-01-20T...","uptime":123.45}
```

Если команда `curl` не найдена, используйте альтернативный способ:
```bash
# На Windows PowerShell
Invoke-WebRequest -Uri http://localhost:3000/api/v2/health | ConvertFrom-Json

# На Linux/Mac
curl http://localhost:3000/api/v2/health
```

---

## Шаг 4: Запуск Backend в Docker

### 4.1 Остановить старые контейнеры (если есть)

```bash
cd C:\masters\masters
docker-compose down -v
```

### 4.2 Запустить все сервисы

```bash
docker-compose up -d
```

### 4.3 Проверить статус

```bash
# Проверить все контейнеры
docker-compose ps

# Проверить логи backend
docker-compose logs backend

# Проверить логи всех сервисов
docker-compose logs -f
```

**Ожидаемый вывод `docker-compose ps`:**
```
NAME               IMAGE              STATUS
service_backend    backend:latest     Up (healthy)
service_postgres   postgres:15        Up (healthy)
service_redis      redis:7            Up (healthy)
service_minio      minio/minio        Up (healthy)
service_meilisearch meilisearch/...   Up (healthy)
```

### 4.4 Проверить health endpoint

```bash
curl http://localhost:3000/api/v2/health
```

---

## Шаг 5: Запуск Flutter Приложения

### 5.1 Проверить конфигурацию

Откройте `frontend/lib/core/config/app_config.dart` и убедитесь:

```dart
static const bool _isAdbReverse = true; // Должно быть true для USB
```

### 5.2 Установить Flutter приложение

```bash
cd frontend
flutter clean
flutter pub get
flutter run
```

Выберите ваше USB устройство из списка.

---

## Шаг 6: Тестирование Функционала

После запуска приложения проверьте:

1. **Регистрация нового пользователя**
   - Откройте экран регистрации
   - Заполните форму
   - Проверьте что запрос прошел успешно

2. **Вход в систему**
   - Email: любой из seed данных
   - Password: `Password123!`

3. **Просмотр Feed**
   - Лента постов должна загрузиться
   - Infinite scroll должен работать

4. **Фильтры**
   - Откройте фильтры
   - Выберите категорию
   - Проверьте что посты фильтруются

---

## Troubleshooting

### Проблема: "Connection refused" в приложении

**Решение 1: Проверить adb reverse**
```bash
adb reverse --list
# Если пусто, настроить заново:
adb reverse tcp:3000 tcp:3000
```

**Решение 2: Проверить что backend слушает на 0.0.0.0**
```bash
docker-compose logs backend | grep "Host:"
# Должно показать: Host: 0.0.0.0
```

**Решение 3: Перезапустить adb**
```bash
adb kill-server
adb start-server
adb reverse tcp:3000 tcp:3000
```

---

### Проблема: "Cleartext HTTP traffic not permitted"

Убедитесь что `network_security_config.xml` подключен в `AndroidManifest.xml`:

```xml
<!-- frontend/android/app/src/main/AndroidManifest.xml -->
<application
    android:networkSecurityConfig="@xml/network_security_config"
    ...>
```

И что файл `frontend/android/app/src/main/res/xml/network_security_config.xml` содержит:

```xml
<?xml version="1.0" encoding="utf-8"?>
<network-security-config>
    <domain-config cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">localhost</domain>
        <domain includeSubdomains="true">10.0.2.2</domain>
    </domain-config>
</network-security-config>
```

---

### Проблема: Backend не запускается в Docker

**Проверить логи:**
```bash
docker-compose logs backend
```

**Проверить переменные окружения:**
```bash
docker-compose exec backend env | grep DB_HOST
# Должно показать: DB_HOST=postgres
```

**Пересобрать образ:**
```bash
docker-compose build backend
docker-compose up -d backend
```

---

### Проблема: Устройство не отображается в `adb devices`

1. **Проверить кабель USB** - используйте кабель с передачей данных
2. **Включить передачу файлов** на устройстве (при подключении выбрать "Передача файлов")
3. **Установить драйверы** (Windows может требовать драйверы производителя)
4. **Разрешить отладку** на экране устройства

---

### Проблема: Backend отвечает медленно

1. **Проверить ресурсы Docker:**
   - Docker Desktop → Settings → Resources
   - Выделить минимум 4GB RAM и 2 CPU

2. **Очистить неиспользуемые контейнеры:**
   ```bash
   docker system prune -a
   ```

3. **Проверить логи на ошибки:**
   ```bash
   docker-compose logs backend | grep ERROR
   ```

---

## Переключение на WiFi Тестирование

Если хотите тестировать через WiFi вместо USB:

### 1. Узнать IP адрес вашего ПК

**Windows:**
```bash
ipconfig
# Найдите IPv4 адрес (например, 192.168.1.4)
```

**Linux/Mac:**
```bash
ifconfig
# или
ip addr show
```

### 2. Обновить AppConfig

```dart
// frontend/lib/core/config/app_config.dart
static const bool _isAdbReverse = false; // Изменить на false
static const String _localIp = '192.168.1.4'; // Ваш IP
```

### 3. Разрешить порт в Firewall (Windows)

```powershell
# PowerShell от имени администратора
netsh advfirewall firewall add rule name="Node.js Server" dir=in action=allow protocol=TCP localport=3000
```

### 4. Убрать adb reverse

```bash
adb reverse --remove-all
```

### 5. Пересобрать Flutter приложение

```bash
cd frontend
flutter clean
flutter pub get
flutter run
```

---

## Полезные Команды

```bash
# Проверить статус контейнеров
docker-compose ps

# Перезапустить backend
docker-compose restart backend

# Посмотреть логи backend в реальном времени
docker-compose logs -f backend

# Зайти в контейнер backend
docker-compose exec backend sh

# Проверить подключение к PostgreSQL
docker-compose exec backend sh -c "wget -qO- http://postgres:5432 || echo 'Connection failed'"

# Остановить все контейнеры
docker-compose down

# Остановить и удалить все данные
docker-compose down -v

# Пересобрать backend образ
docker-compose build backend

# Проверить health check
curl http://localhost:3000/api/v2/health

# Список port forwarding
adb reverse --list

# Удалить все port forwarding
adb reverse --remove-all
```

---

## Дополнительные Ресурсы

- [Android ADB Documentation](https://developer.android.com/studio/command-line/adb)
- [Docker Compose Documentation](https://docs.docker.com/compose/)
- [Flutter DevTools](https://docs.flutter.dev/development/tools/devtools/overview)
- [NestJS Documentation](https://docs.nestjs.com/)

---

## Контакты для Помощи

При возникновении проблем:
1. Проверьте логи Docker: `docker-compose logs backend`
2. Проверьте логи adb: `adb logcat | grep -i error`
3. Создайте issue в репозитории проекта
