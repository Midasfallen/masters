# Backend Phase 1-2 - Installation Guide

## Быстрая установка

### Шаг 1: Установка зависимостей

```bash
cd /home/user/masters/backend

# Winston Logger
npm install winston nest-winston winston-daily-rotate-file
npm install -D @types/winston

# Faker для seed данных
npm install -D @faker-js/faker

# Firebase Admin SDK для FCM/APNs
npm install firebase-admin
```

### Шаг 2: Обновить package.json

Добавьте скрипт для seed в `package.json`:

```json
{
  "scripts": {
    "seed": "ts-node src/database/seeds/seed.ts"
  }
}
```

### Шаг 3: Настроить переменные окружения

Создайте или обновите файл `.env`:

```env
# ===================================
# WINSTON LOGGER
# ===================================
NODE_ENV=development
LOG_LEVEL=debug          # debug, info, warn, error
LOG_CONSOLE=true         # Включить логи в консоль

# ===================================
# FIREBASE CLOUD MESSAGING (FCM)
# ===================================
# Получите эти значения из Firebase Console:
# 1. Перейдите в Project Settings > Service Accounts
# 2. Нажмите "Generate new private key"
# 3. Используйте значения из скачанного JSON файла

FCM_PROJECT_ID=your-firebase-project-id
FCM_CLIENT_EMAIL=firebase-adminsdk-xxxxx@your-project.iam.gserviceaccount.com

# Private key нужно закодировать в base64:
# node -e "console.log(Buffer.from(require('./firebase-key.json').private_key).toString('base64'))"
FCM_PRIVATE_KEY=LS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tCk1JSUV2UUlCQURBTkJna3Foa2lHOXcwQkFRRUZ...
```

### Шаг 4: Создать папку для логов

```bash
mkdir -p logs
echo "logs/" >> .gitignore
```

### Шаг 5: Запустить seed

```bash
# Убедитесь что PostgreSQL запущен и база данных создана
npm run seed

# Ожидаемый вывод:
# ✅ Database connected
# 📂 Creating categories...
# ✅ Created 10 categories
# 👥 Creating users...
# ✅ Created 10 users (5 masters)
# 🎨 Creating master profiles...
# ✅ Created 5 master profiles
# 💼 Creating services...
# ✅ Created 20 services
# 📅 Creating bookings...
# ✅ Created 15 bookings
# ⭐ Creating reviews...
# ✅ Created 20 reviews
# 🎉 Seed completed successfully!
```

### Шаг 6: Запустить приложение

```bash
npm run start:dev
```

Проверьте логи в консоли - должны появиться Winston логи с красивым форматированием.

### Шаг 7: Проверить Swagger

Откройте в браузере:
```
http://localhost:3000/api/v2/docs
```

Вы должны увидеть обновленную документацию с подробным описанием, тегами и примерами.

---

## Настройка Firebase для FCM

### Вариант 1: Через Firebase Console (рекомендуется)

1. Перейдите на https://console.firebase.google.com/
2. Создайте новый проект или выберите существующий
3. Перейдите в **Project Settings** (⚙️ > Project Settings)
4. Откройте вкладку **Service Accounts**
5. Нажмите **Generate new private key**
6. Скачается JSON файл с credentials

7. Извлеките значения из JSON файла:

```bash
# Из скачанного firebase-adminsdk-xxxxx.json извлеките:
# - project_id → FCM_PROJECT_ID
# - client_email → FCM_CLIENT_EMAIL
# - private_key → нужно закодировать в base64

# Закодировать private_key:
node -e "
const fs = require('fs');
const key = JSON.parse(fs.readFileSync('./firebase-adminsdk-xxxxx.json', 'utf8'));
console.log(Buffer.from(key.private_key).toString('base64'));
"
```

8. Добавьте значения в `.env`

### Вариант 2: Создать Service Account вручную

1. Перейдите в https://console.cloud.google.com/
2. Выберите ваш Firebase проект
3. Перейдите в **IAM & Admin** > **Service Accounts**
4. Нажмите **Create Service Account**
5. Назовите: `firebase-adminsdk`
6. Роль: **Firebase Admin SDK Administrator Service Agent**
7. Создайте и скачайте JSON ключ
8. Извлеките значения как в варианте 1

---

## Проверка установки

### 1. Winston Logger

```bash
# Запустите приложение
npm run start:dev

# Проверьте консоль - должны быть цветные логи
# Проверьте папку logs/
ls -la logs/

# Должны быть файлы:
# - application-YYYY-MM-DD.log
# - error-YYYY-MM-DD.log
# - http-YYYY-MM-DD.log
```

### 2. Seed Data

```bash
# Подключитесь к БД и проверьте данные
psql -d service_platform

# Выполните запросы:
SELECT COUNT(*) FROM users;                    -- Должно быть 10
SELECT COUNT(*) FROM master_profiles;          -- Должно быть 5
SELECT COUNT(*) FROM categories;               -- Должно быть 10
SELECT COUNT(*) FROM services;                 -- Должно быть 20
SELECT COUNT(*) FROM bookings;                 -- Должно быть 15
SELECT COUNT(*) FROM reviews;                  -- Должно быть 20

# Проверьте конкретные данные:
SELECT first_name, last_name, is_master FROM users;
SELECT name, price FROM services LIMIT 5;
```

### 3. Fallback Search

```bash
# Остановите Meilisearch
docker stop meilisearch

# Или если через docker-compose:
docker-compose stop meilisearch

# Выполните поиск через API
curl -X GET "http://localhost:3000/api/v2/search/masters?query=test" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"

# В логах должно появиться:
# ⚠️  Using fallback PostgreSQL search (Meilisearch unavailable)

# Запустите Meilisearch обратно
docker start meilisearch
```

### 4. FCM Service

Создайте тестовый endpoint (необязательно):

```typescript
// В любом контроллере
@Get('test-fcm')
async testFCM() {
  const isReady = this.fcmService.isReady();

  if (!isReady) {
    return { status: 'FCM not configured' };
  }

  // Отправьте тестовое уведомление
  await this.fcmService.sendToTopic('test', {
    title: 'Test Notification',
    body: 'FCM is working!'
  });

  return { status: 'FCM is ready and notification sent' };
}
```

### 5. Swagger Documentation

1. Откройте http://localhost:3000/api/v2/docs
2. Проверьте что:
   - Есть подробное описание вверху страницы
   - Теги отображаются с иконками
   - Есть раздел "Servers" с выбором серверов
   - Работает "Authorize" кнопка
   - Endpoints сгруппированы по тегам
   - Есть примеры и описания

---

## Troubleshooting

### Winston Logger не работает

**Проблема**: Логи не появляются

**Решение**:
```bash
# Проверьте что модуль импортирован в app.module.ts
grep -r "LoggerModule" src/app.module.ts

# Проверьте что установлены зависимости
npm list winston nest-winston

# Проверьте переменные окружения
cat .env | grep LOG
```

### Seed script падает с ошибкой

**Проблема**: Error: connect ECONNREFUSED

**Решение**:
```bash
# Проверьте что PostgreSQL запущен
docker ps | grep postgres

# Проверьте переменные окружения БД
echo $DB_HOST
echo $DB_PORT
echo $DB_NAME

# Проверьте подключение
psql -h localhost -U postgres -d service_platform -c "SELECT 1;"
```

**Проблема**: Ошибка duplicate key

**Решение**:
```bash
# Очистите БД перед повторным запуском
# Раскомментируйте секцию очистки в seed.ts:
# await reviewRepository.delete({});
# await bookingRepository.delete({});
# ...
```

### FCM не инициализируется

**Проблема**: FCM credentials not configured

**Решение**:
```bash
# Проверьте переменные окружения
echo $FCM_PROJECT_ID
echo $FCM_CLIENT_EMAIL
echo $FCM_PRIVATE_KEY | wc -c  # Должно быть > 0

# Проверьте что private key правильно закодирован
# Он должен начинаться с: LS0tLS1CRUdJTi...

# Попробуйте раскодировать обратно
echo $FCM_PRIVATE_KEY | base64 -d | head -1
# Должно показать: -----BEGIN PRIVATE KEY-----
```

**Проблема**: Failed to initialize Firebase Admin SDK

**Решение**:
- Проверьте формат private_key (должны быть `\n` для переносов строк)
- Убедитесь что используете правильный project_id
- Проверьте что service account имеет права

### Fallback Search не работает

**Проблема**: Пустые результаты при fallback

**Решение**:
```sql
-- Проверьте что есть данные мастеров
SELECT COUNT(*) FROM users WHERE is_master = true;

-- Проверьте что профили активны
SELECT COUNT(*) FROM master_profiles WHERE is_active = true;

-- Проверьте связь между users и profiles
SELECT u.id, u.first_name, mp.id as profile_id
FROM users u
LEFT JOIN master_profiles mp ON mp.user_id = u.id
WHERE u.is_master = true;
```

### Swagger не показывает описания

**Проблема**: Endpoints без описаний

**Решение**:
- Убедитесь что контроллеры используют декораторы `@ApiTags()`
- Добавьте `@ApiOperation()` для каждого endpoint
- Добавьте `@ApiResponse()` для описания ответов
- Перезапустите приложение

---

## Дополнительные команды

### Просмотр логов Winston

```bash
# Последние логи приложения
tail -f logs/application-$(date +%Y-%m-%d).log

# Последние ошибки
tail -f logs/error-$(date +%Y-%m-%d).log

# HTTP запросы
tail -f logs/http-$(date +%Y-%m-%d).log

# Поиск в логах
grep "ERROR" logs/application-*.log
grep "search" logs/http-*.log
```

### Управление seed данными

```bash
# Запуск с переменными окружения
DB_HOST=localhost DB_PORT=5432 npm run seed

# Очистка только определенных таблиц
psql -d service_platform -c "TRUNCATE reviews, bookings CASCADE;"

# Проверка целостности данных
psql -d service_platform -f scripts/check_data_integrity.sql
```

### Firebase управление

```bash
# Проверка валидности JSON ключа
cat firebase-adminsdk-xxxxx.json | jq '.'

# Тест подключения к Firebase
node -e "
const admin = require('firebase-admin');
const serviceAccount = require('./firebase-adminsdk-xxxxx.json');
admin.initializeApp({ credential: admin.credential.cert(serviceAccount) });
console.log('✅ Firebase connected successfully');
"
```

---

## Полезные ссылки

- Winston: https://github.com/winstonjs/winston
- nest-winston: https://github.com/gremo/nest-winston
- Faker.js: https://fakerjs.dev/
- Firebase Admin SDK: https://firebase.google.com/docs/admin/setup
- NestJS Swagger: https://docs.nestjs.com/openapi/introduction

---

**Готово!** Все компоненты фазы 1-2 установлены и настроены.
