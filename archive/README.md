# Архив устаревших файлов

Этот каталог содержит файлы, которые были перемещены из основного проекта как устаревшие или замененные более актуальными версиями.

**Дата архивации:** Февраль 2026

---

## Структура архива

### `scripts/` - Устаревшие скрипты

Скрипты, которые были заменены TypeScript версиями или больше не используются:

- **`seed-data.sql`** - Устаревший SQL скрипт для заполнения БД. Заменен на TypeScript seed (`npm run seed` в `backend/src/database/seeds/`).
- **`upload_to_minio.py`** - Устаревший Python скрипт для загрузки изображений в MinIO. Заменен на TypeScript версию (`npm run upload-images` в `backend/src/database/seeds/upload-local-images.ts`).
- **`test-db-connection.js`** - Тестовый скрипт для проверки подключения к БД. Не используется в CI/CD, был заменен на встроенные тесты.

### `docker/` - Устаревшие Docker конфигурации

Docker файлы, которые больше не актуальны:

- **`docker-compose.dev.yml`** - Устаревший Docker Compose файл для разработки. Основной `docker-compose.yml` уже содержит PostGIS (postgis/postgis:15-3.4-alpine) и используется для всех сценариев, включая разработку с геолокацией.
- **`Dockerfile.test`** - Тестовый Dockerfile, не используется в CI/CD. Был создан для тестирования подключения к БД, но не интегрирован в процесс разработки.

### `build-artifacts/` - Артефакты сборки

Артефакты сборки приложения, которые не должны находиться в репозитории:

- **`app-release.aab`** - Android App Bundle из директории `bundle/release/`
- **`flutter-apk/`** - APK файлы для разных архитектур (arm64-v8a, armeabi-v7a, x86_64)

> **Примечание:** Эти файлы теперь исключены из репозитория через `.gitignore`. Они сохранены здесь на случай необходимости восстановления конкретных версий сборок.

### `frontend-docs/` - Устаревшая документация Flutter

Документация по разработке Flutter прототипа, которая была актуальна на этапе прототипирования:

- **`BUILD_APK.md`** - Инструкции по сборке APK (актуальная информация в `.github/workflows/build-apk.yml`)
- **`FLUTTER_INTEGRATION_COMPLETED.md`** - Отчет о завершении интеграции с Backend
- **`FLUTTER_V2_README.md`** - Руководство по настройке Flutter v2.0 прототипа
- **`INTEGRATION_SETUP.md`** - Инструкции по настройке интеграции
- **`PROJECT_V2_STRUCTURE.md`** - Описание структуры проекта v2.0
- **`PROTOTYPE_COMPLIANCE_REPORT.md`** - Отчет о соответствии прототипа документации
- **`PROTOTYPE_V2_README.md`** - README для прототипа v2.0

> **Примечание:** Эта документация была актуальна на этапе прототипирования. Актуальная информация теперь находится в `frontend/README.md` и `docs/guides/FLUTTER_SETUP.md`.

### `docs-temporary/` - Временные отчеты и инструкции

Временные документы, созданные в процессе разработки и отладки, которые больше не актуальны:

**Отчеты о миграциях и завершении:**
- **`MIGRATION_COMPLETE_SUMMARY.md`** - Отчет о завершении миграции Backend API к camelCase
- **`PROJECT_COMPLETION_SUMMARY.md`** - Итоговый отчет о завершении MVP

**Планы исправлений и отчеты о тестировании:**
- **`BUGFIX_PLAN.md`** - План исправления проблем Feed и Post Detail
- **`BUGFIX_TESTING_RESULTS.md`** - Результаты тестирования исправлений
- **`BACKEND_FRONTEND_SYNC.md`** - Отчет о синхронизации фронтенда и бэкенда
- **`CREATE_POST_FIX.md`** - Исправление создания поста
- **`FEED_AND_SESSION_FIXES.md`** - Исправления обновления ленты и сохранения сессии
- **`FEED_REFRESH_FIX.md`** - Исправление обновления ленты
- **`FIXES_SUMMARY.md`** - Краткое резюме исправлений
- **`RUNTIME_ERRORS_FIX.md`** - Исправление Runtime ошибок

**Инструкции по настройке Cursor и MCP:**
- **`CURSOR_AUTOMATION_EXAMPLES.md`** - Примеры автоматизации в Cursor
- **`CURSOR_OPTIMIZATION.md`** - Оптимизация работы с Cursor
- **`CURSOR_ORCHESTRATION.md`** - Система оркестрации задач для Cursor
- **`CURSOR_ORCHESTRATION_COMPLETE.md`** - Завершение настройки оркестрации
- **`CURSOR_ORCHESTRATION_QUICK_START.md`** - Быстрый старт оркестрации
- **`CURSOR_QUICK_START.md`** - Быстрый старт работы с Cursor
- **`CURSOR_PLAN_MODE.md`** - Режим планирования в Cursor
- **`CURSOR_SETUP_COMPLETE.md`** - Завершение настройки Cursor
- **`MCP_FINAL_SETUP.md`** - Финальная настройка MCP серверов
- **`MCP_INSTALLATION_COMPLETE.md`** - Завершение установки MCP
- **`MCP_QUICK_START.md`** - Быстрый старт с MCP
- **`MCP_RECOMMENDATIONS.md`** - Рекомендации по использованию MCP
- **`MCP_SETUP.md`** - Установка MCP серверов
- **`MCP_STATUS.md`** - Статус MCP серверов

**Планы разработки и отчеты:**
- **`IMPLEMENTATION_PLAN.md`** - План реализации
- **`IMPLEMENTATION_ROADMAP_2026-01.md`** - Дорожная карта реализации на январь 2026
- **`DOCUMENTATION_AUDIT_REPORT.md`** - Отчет об аудите документации
- **`MANUAL_TESTING_CHECKLIST.md`** - Чеклист ручного тестирования
- **`PLAYWRIGHT_TESTING_REPORT.md`** - Отчет о тестировании Playwright

**Настройка окружения:**
- **`FLUTTER_WEB_SETUP.md`** - Настройка Flutter Web
- **`MOBILE_SETUP.md`** - Настройка мобильного приложения

**Исторические документы проекта:**
- **`CHANGELOG_V2.md`** - Changelog перехода от v1.0 к v2.0 (все изменения уже реализованы)
- **`CLAUDE_INSTRUCTIONS.md`** - Инструкции для работы с проектами Midasfallen (общие инструкции, не специфичные для текущего проекта)

**Быстрые старты (заменены на guides/GETTING_STARTED.md):**
- **`QUICK_START.md`** - Быстрый старт для разработки
- **`QUICK_TEST_START.md`** - Быстрый старт для тестирования

**Отчеты о спринтах и реализации:**
- **`SPRINT_2_COMPLETION_STATUS.md`** - Статус завершения спринта 2
- **`SPRINT_2_FINAL_REPORT.md`** - Финальный отчет по спринту 2
- **`SPRINT3_PROGRESS.md`** - Прогресс спринта 3
- **`SPRINT4_PROGRESS.md`** - Прогресс спринта 4

**Отчеты о реализации функций:**
- **`REVIEW_REMINDERS_COMPLETION_REPORT.md`** - Отчет о завершении напоминаний об отзывах
- **`REVIEW_REMINDERS_FULL_IMPLEMENTATION.md`** - Полная реализация напоминаний об отзывах
- **`REVIEW_REMINDERS_IMPLEMENTATION.md`** - Реализация напоминаний об отзывах
- **`SESSION_PERSISTENCE_IMPLEMENTATION.md`** - Реализация сохранения сессии
- **`SESSION_PERSISTENCE.md`** - Сохранение сессии
- **`SESSION_SUMMARY_2026-01-22.md`** - Резюме сессии от 22 января 2026
- **`SUBSCRIPTION_BUTTON_TEST_RESULTS.md`** - Результаты тестирования кнопки подписки
- **`SUBSCRIPTION_BUTTON_TESTING.md`** - Тестирование кнопки подписки
- **`SWAGGER_IMPROVEMENT_PLAN.md`** - План улучшения Swagger
- **`TESTING_CHECKLIST.md`** - Чеклист тестирования

**Целые директории документации (перемещены в архив):**
- **`testing/`** - Документация по тестированию (TestCases.md, TestPlan.md, README.md)
- **`technical/`** - Техническая документация (API.md, Database.md, DevSetup.md, DOCKER_CONFIGURATION.md, TechSpec.md, WebSocket-Specification.md, и др.)
- **`reports/`** - Отчеты о статусе проекта (E2E_TESTS_FINAL.md, PERFORMANCE.md, PHASE_5_COMPLETION.md, PROJECT_STATUS.md, SECURITY_AUDIT.md, и др.)
- **`migration/`** - Документация по миграциям (CAMELCASE_MIGRATION_SUMMARY, FRONTEND_INTEGRATION_GUIDE, FRONTEND_MIGRATION_PLAN)
- **`guides/`** - Руководства (GETTING_STARTED.md, INSTALLATION_GUIDE.md, FLUTTER_SETUP.md, CONTRIBUTING.md, и др.)
- **`development/`** - Документация по разработке (CI_CD.md, TESTING.md, MONITORING.md, E2E_TESTING_GUIDE.md)
- **`api/`** - Документация по API (API_CONTRACT_IMPLEMENTATION_PROGRESS.md, API_CONTRACT_MISMATCHES.md, API_RESPONSE_STANDARD.md)
- **`prompts/`** - Шаблоны промптов для AI-агентов (backend-agent.md, frontend-agent.md, database-agent.md, testing-agent.md, plan-examples.md, и др.)
- **`plans/`** - Планы разработки (cheeky-weaving-harbor.md, dapper-wishing-hinton.md)

**Файлы из директорий:**
- **`business/README.md`** - README из директории бизнес-документации
- **`analysis/MVP_ACTION_PLAN.md`** - План действий MVP
- **`analysis/MVP-Development-Plan.md`** - План разработки MVP
- **`analysis/README.md`** - README из директории анализа
- **`analysis/Roadmap.md`** - Дорожная карта проекта

> **Примечание:** Эти документы были созданы в процессе разработки и отладки. Актуальная информация находится в основных документах проекта: `README.md`, `docs/README.md`. Большая часть документации была перемещена в архив для упрощения структуры проекта.

---

## Причины архивации

1. **Дублирование функциональности** - Файлы были заменены более современными и поддерживаемыми версиями
2. **Упрощение конфигурации** - Объединение нескольких конфигураций в одну для упрощения поддержки
3. **Очистка репозитория** - Удаление временных файлов и артефактов сборки из основного дерева проекта

---

## Восстановление файлов

Если вам нужен какой-либо файл из архива:

1. Скопируйте файл из соответствующей поддиректории архива
2. Убедитесь, что понимаете, почему файл был архивирован
3. Проверьте, нет ли более актуальной альтернативы в основном проекте

---

## Связанные документы

- `README.md` - Основной README проекта
- `docs/README.md` - Навигация по документации
- `SEEDING.md` - Руководство по заполнению БД тестовыми данными

> **Примечание:** Большая часть технической документации была перемещена в архив. Для актуальной информации обращайтесь к основным документам проекта.
