# DOCKER КОНФИГУРАЦИЯ - Service Platform

**Версия:** 2.0
**Дата:** Январь 2026

---

> ⚠️ **УСТАРЕЛО:** Этот документ содержит информацию о `docker-compose.dev.yml`, который был перемещен в `archive/docker/` как устаревший. Основной `docker-compose.yml` уже содержит PostGIS (postgis/postgis:15-3.4-alpine) и используется для всех сценариев, включая разработку с геолокацией.

## Обзор

Проект использует один основной Docker Compose файл:

| Файл | Назначение | PostGIS | Рекомендуется для |
|------|------------|---------|-------------------|
| `docker-compose.yml` | Production / Development | ✅ Да | Все сценарии (CI/CD, staging, production, разработка) |
| ~~`docker-compose.dev.yml`~~ | ~~Development~~ | ~~Да~~ | ~~Устарел, перемещен в архив~~ |

---

## docker-compose.yml (Production)

### Сервисы

| Сервис | Образ | Порт | Описание |
|--------|-------|------|----------|
| `postgres` | postgres:15-alpine | 5433:5432 | PostgreSQL (без PostGIS) |
| `redis` | redis:7-alpine | 6379 | Кэш и сессии |
| `meilisearch` | getmeili/meilisearch:v1.5 | 7700 | Полнотекстовый поиск |
| `minio` | minio/minio:latest | 9000, 9002 | S3-совместимое хранилище |
| `mailhog` | mailhog/mailhog:latest | 1025, 8025 | SMTP для тестирования |
| `adminer` | adminer:latest | 8080 | Web UI для БД |
| `backend` | ./backend/Dockerfile | 3000 | NestJS backend (опционально) |
| `minio_createbuckets` | minio/mc:latest | - | Создание buckets |

### Credentials

```env
# PostgreSQL
POSTGRES_DB=service_db
POSTGRES_USER=service_user
POSTGRES_PASSWORD=service_password

# Redis
REDIS_PASSWORD=redis_password

# MinIO
MINIO_ROOT_USER=minio_access_key
MINIO_ROOT_PASSWORD=minio_secret_key

# Meilisearch
MEILI_MASTER_KEY=meilisearch_master_key
```

### Команды

```bash
# Запуск всех сервисов
docker-compose up -d

# Запуск только инфраструктуры (без backend)
docker-compose up -d postgres redis meilisearch minio mailhog

# Статус
docker-compose ps

# Логи
docker-compose logs -f postgres

# Остановка
docker-compose down

# Полная очистка (включая данные)
docker-compose down -v
```

---

## docker-compose.dev.yml (Development)

### Сервисы

| Сервис | Образ | Порт | Описание |
|--------|-------|------|----------|
| `postgres` | postgis/postgis:15-3.4 | 5432:5432 | PostgreSQL с PostGIS |
| `redis` | redis:7-alpine | 6379 | Кэш (без пароля) |
| `meilisearch` | getmeili/meilisearch:v1.5 | 7700 | Полнотекстовый поиск |
| `minio` | minio/minio:latest | 9000, 9001 | S3-совместимое хранилище |
| `pgadmin` | dpage/pgadmin4:latest | 5050 | PgAdmin (альтернатива Adminer) |

### Credentials

```env
# PostgreSQL
POSTGRES_DB=service_db
POSTGRES_USER=postgres
POSTGRES_PASSWORD=postgres

# Redis
# Без пароля

# MinIO
MINIO_ROOT_USER=minioadmin
MINIO_ROOT_PASSWORD=minioadmin

# PgAdmin
PGADMIN_DEFAULT_EMAIL=admin@service-platform.local
PGADMIN_DEFAULT_PASSWORD=admin
```

### Команды

```bash
# Запуск
docker-compose -f docker-compose.dev.yml up -d

# Статус
docker-compose -f docker-compose.dev.yml ps

# Остановка
docker-compose -f docker-compose.dev.yml down
```

---

## Сравнение конфигураций

| Параметр | docker-compose.yml | docker-compose.dev.yml |
|----------|-------------------|----------------------|
| **PostgreSQL образ** | postgres:15-alpine | postgis/postgis:15-3.4 |
| **PostGIS** | ❌ Нет | ✅ Да |
| **Порт PostgreSQL** | 5433 | 5432 |
| **POSTGRES_USER** | service_user | postgres |
| **POSTGRES_PASSWORD** | service_password | postgres |
| **Redis пароль** | redis_password | (нет) |
| **MinIO Console** | 9002 | 9001 |
| **MinIO credentials** | minio_access_key / minio_secret_key | minioadmin / minioadmin |
| **DB Admin** | Adminer (8080) | PgAdmin (5050) |
| **Backend контейнер** | ✅ Да | ❌ Нет (локально) |

---

## Настройка backend/.env

### Для docker-compose.yml

```env
# Database
DB_HOST=localhost
DB_PORT=5433
DB_DATABASE=service_db
DB_USERNAME=service_user
DB_PASSWORD=service_password

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
REDIS_PASSWORD=redis_password

# MinIO
MINIO_ENDPOINT=localhost
MINIO_PORT=9000
MINIO_ACCESS_KEY=minio_access_key
MINIO_SECRET_KEY=minio_secret_key

# Meilisearch
MEILISEARCH_HOST=http://localhost:7700
MEILISEARCH_KEY=meilisearch_master_key
```

### Для docker-compose.dev.yml

```env
# Database
DB_HOST=localhost
DB_PORT=5432
DB_DATABASE=service_db
DB_USERNAME=postgres
DB_PASSWORD=postgres

# Redis
REDIS_HOST=localhost
REDIS_PORT=6379
# REDIS_PASSWORD= (не требуется)

# MinIO
MINIO_ENDPOINT=localhost
MINIO_PORT=9000
MINIO_ACCESS_KEY=minioadmin
MINIO_SECRET_KEY=minioadmin

# Meilisearch
MEILISEARCH_HOST=http://localhost:7700
# MEILISEARCH_KEY= (не требуется в dev)
```

---

## Healthchecks

Все сервисы имеют healthchecks:

| Сервис | Команда | Интервал | Таймаут |
|--------|---------|----------|---------|
| PostgreSQL | `pg_isready` | 10s | 5s |
| Redis | `redis-cli ping` | 10s | 5s |
| Meilisearch | `curl /health` | 10s | 5s |
| MinIO | `curl /minio/health/live` | 30s | 20s |

Проверка готовности:
```bash
docker-compose ps
# Все сервисы должны быть "healthy"
```

---

## Volumes

### docker-compose.yml

```yaml
volumes:
  service_postgres:     # PostgreSQL данные
  service_redis:        # Redis данные
  service_meilisearch:  # Meilisearch индексы
  service_minio:        # MinIO файлы
  service_mailhog:      # MailHog данные
  service_adminer:      # Adminer сессии
```

### docker-compose.dev.yml

```yaml
volumes:
  postgres_data:        # PostgreSQL данные
  redis_data:           # Redis данные
  minio_data:           # MinIO файлы
  meilisearch_data:     # Meilisearch индексы
  pgadmin_data:         # PgAdmin настройки
```

---

## Сети

### docker-compose.yml

```yaml
networks:
  service_network:
    driver: bridge
```

### docker-compose.dev.yml

```yaml
networks:
  service-platform-network:
    driver: bridge
```

---

## MinIO Buckets

Автоматически создаются 4 bucket'а:

| Bucket | Назначение |
|--------|------------|
| `avatars` | Аватары пользователей |
| `posts` | Медиа для постов |
| `videos` | Видео контент |
| `portfolios` | Портфолио мастеров |

В `docker-compose.yml` buckets создаются через `minio_createbuckets` сервис.

В `docker-compose.dev.yml` buckets нужно создать вручную:
```bash
docker exec -it service-platform-minio mc alias set local http://localhost:9000 minioadmin minioadmin
docker exec -it service-platform-minio mc mb local/avatars local/posts local/videos local/portfolios
```

---

## Troubleshooting

### Порт уже занят

```bash
# Найти процесс
netstat -ano | findstr :5432  # Windows
lsof -i :5432                  # macOS/Linux

# Остановить локальный PostgreSQL
# Windows: services.msc → PostgreSQL → Stop
# macOS: brew services stop postgresql
# Linux: sudo systemctl stop postgresql
```

### Контейнер не стартует

```bash
# Проверить логи
docker-compose logs postgres

# Пересоздать контейнер
docker-compose down
docker-compose up -d postgres
```

### Healthcheck failed

```bash
# Проверить статус
docker inspect service_postgres --format='{{.State.Health.Status}}'

# Подождать и проверить снова
sleep 30 && docker-compose ps
```

---

## Связанные документы

- [DevSetup.md](./DevSetup.md) — Настройка окружения разработки
- [E2E_TESTING_GUIDE.md](../development/E2E_TESTING_GUIDE.md) — Гайд по E2E тестированию
- [TechSpec.md](./TechSpec.md) — Техническая спецификация

---

**Последнее обновление:** Январь 2026
