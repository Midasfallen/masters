# Порты и Сервисы - Руководство разработчика

## Обзор Docker-сервисов

### HTTP-сервисы (доступны через браузер)

| Сервис | URL | Назначение |
|--------|-----|-----------|
| Backend API | http://localhost:3000/api/v2/docs | Swagger UI документация API |
| MinIO Console | http://localhost:9002 | Web-интерфейс для управления файлами |
| MailHog Web UI | http://localhost:8025 | Web-интерфейс для просмотра отправленных email |
| Adminer | http://localhost:8080 | Web-интерфейс для управления PostgreSQL |

### TCP-сервисы (подключение через клиенты, НЕ HTTP)

| Сервис | Хост:Порт | Тип | Клиент | Назначение |
|--------|-----------|-----|--------|-----------|
| PostgreSQL | localhost:5433 | SQL Database | psql, DBeaver, Adminer | База данных |
| Redis | localhost:6379 | Key-Value Cache | redis-cli | Кеширование |
| MinIO API | localhost:9000 | S3-compatible Storage | AWS CLI, SDK | Хранилище файлов |
| Meilisearch | localhost:7700 | Search Engine | HTTP API | Полнотекстовый поиск |
| MailHog SMTP | localhost:1025 | SMTP Server | Nodemailer | Отправка email (dev) |

---

## Почему PostgreSQL недоступен через браузер?

PostgreSQL - это TCP-сервис базы данных, а не HTTP-сервер.
- ❌ НЕ работает: http://localhost:5433
- ✅ Работает: подключение через `psql -h localhost -p 5433 -U service_user -d service_db`
- ✅ Работает: Web UI через Adminer на http://localhost:8080

## Почему Redis недоступен через браузер?

Redis - это TCP-сервис кеширования, работает по бинарному протоколу.
- ❌ НЕ работает: http://localhost:6379
- ✅ Работает: `redis-cli -h localhost -p 6379 -a redis_password ping`

---

## Как проверить работоспособность каждого сервиса?

### 1. PostgreSQL
```bash
# Через psql
psql -h localhost -p 5433 -U service_user -d service_db -c "SELECT 1"

# Через Adminer (Web UI)
Открыть: http://localhost:8080
System: PostgreSQL
Server: postgres
Username: service_user
Password: service_password
Database: service_db
```

### 2. Redis
```bash
# Через redis-cli
redis-cli -h localhost -p 6379 -a redis_password ping
# Ожидается: PONG

# Через redis-cli (интерактивный режим)
redis-cli -h localhost -p 6379 -a redis_password
> SET test "hello"
> GET test
```

### 3. MinIO
```bash
# MinIO API (S3-compatible)
curl http://localhost:9000/minio/health/live
# Ожидается: пустой ответ со статусом 200

# MinIO Console (Web UI)
Открыть: http://localhost:9002
Username: minio_access_key
Password: minio_secret_key
```

### 4. Meilisearch
```bash
# HTTP API health check
curl http://localhost:7700/health
# Ожидается: {"status":"available"}

# Список индексов
curl -H "Authorization: Bearer meilisearch_master_key" \
  http://localhost:7700/indexes
```

### 5. MailHog
```bash
# SMTP порт (не HTTP)
telnet localhost 1025
# Должно подключиться к SMTP-серверу

# Web UI для просмотра писем
Открыть: http://localhost:8025
```

### 6. Backend API
```bash
# Health check endpoint
curl http://localhost:3000/api/v2/health
# Ожидается: JSON с состоянием всех сервисов

# Swagger UI документация
Открыть: http://localhost:3000/api/v2/docs
```

---

## Подключение из кода бэкенда

### Из Docker-контейнера (backend в docker-compose)
Используйте имена Docker-сервисов (внутренняя сеть):
```typescript
DB_HOST=postgres       // НЕ localhost
DB_PORT=5432           // Внутренний порт контейнера
REDIS_HOST=redis       // НЕ localhost
MINIO_ENDPOINT=minio   // НЕ localhost
SMTP_HOST=mailhog      // НЕ localhost
```

### Из хост-машины (npm run start:dev)
Используйте localhost с внешними портами:
```typescript
DB_HOST=localhost
DB_PORT=5433           // Внешний порт (5432 внутри контейнера)
REDIS_HOST=localhost
MINIO_ENDPOINT=localhost
SMTP_HOST=localhost
```

---

## Часто задаваемые вопросы

**Q: Почему MinIO Console на 9002, а не на 9001?**
A: Порт 9001 мог конфликтовать с другими сервисами на хост-машине. В docker-compose.yml указан маппинг `9002:9001`.

**Q: Почему Backend возвращает 404 на http://localhost:3000/?**
A: У бэкенда нет главной страницы. API доступен через `/api/v2/*`. Документация: http://localhost:3000/api/v2/docs

**Q: Как отличить HTTP-сервис от TCP-сервиса?**
A: Если сервис открывается в браузере - это HTTP. Если нужен специальный клиент (psql, redis-cli) - это TCP.

---

## Резюме: Все порты в одном месте

| Порт | Сервис | Тип | URL/Команда |
|------|--------|-----|-------------|
| 3000 | Backend API | HTTP | http://localhost:3000/api/v2/docs |
| 5433 | PostgreSQL | TCP | `psql -h localhost -p 5433 -U service_user -d service_db` |
| 6379 | Redis | TCP | `redis-cli -h localhost -p 6379 -a redis_password ping` |
| 7700 | Meilisearch | HTTP | http://localhost:7700/health |
| 8025 | MailHog Web UI | HTTP | http://localhost:8025 |
| 8080 | Adminer | HTTP | http://localhost:8080 |
| 9000 | MinIO API | HTTP | http://localhost:9000/minio/health/live |
| 9002 | MinIO Console | HTTP | http://localhost:9002 |
| 1025 | MailHog SMTP | TCP | SMTP сервер для отправки email |
