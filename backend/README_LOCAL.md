# Локальный запуск Backend

## Быстрый старт

1. **Убедитесь, что Docker инфраструктура запущена:**
   ```bash
   docker-compose up -d
   ```

2. **Установите зависимости:**
   ```bash
   npm install
   ```

3. **Примените миграции:**
   ```bash
   npm run migration:run
   ```

4. **Запустите бэкенд локально:**
   ```bash
   npm run start:dev
   ```

## Переменные окружения

Бэкенд подключается к Docker сервисам через `localhost`:
- **PostgreSQL**: `localhost:5433` (пользователь: `service_user`, пароль: `service_password`, БД: `service_db`)
- **Redis**: `localhost:6379` (пароль: `redis_password`)
- **MinIO**: `localhost:9000` (ключи: `minio_access_key` / `minio_secret_key`)
- **Meilisearch**: `localhost:7700` (ключ: `meilisearch_master_key`)

## Важно

⚠️ **Перед запуском локально ОБЯЗАТЕЛЬНО остановите контейнер бэкенда:**
```bash
docker stop service_backend
```

Два одновременно запущенных бэкенда (в Docker и локально) вызовут конфликт портов!
