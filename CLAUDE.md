# CLAUDE.MD — Правила разработки Service Platform

## 🎯 Архитектура (Монорепозиторий)
- **Frontend:** `./frontend` (Flutter + Riverpod).
- **Backend:** `./backend` (NestJS + TypeORM).

## ⚠️ СТАНДАРТ ИМЕНОВАНИЯ (РЕШЕНИЕ ТВОИХ ОШИБОК)
Всегда соблюдай этот маппинг, чтобы не ломать API:
- **JSON (API) & Database:** `snake_case` (пример: `first_name`, `is_master`).
- **Dart & TypeScript code:** `camelCase` (пример: `firstName`, `isMaster`).

### Frontend (Flutter):
Для каждой модели в `lib/core/models/` ОБЯЗАТЕЛЬНО:
1. Использовать `@JsonKey(name: 'snake_case_name')` для каждого поля.
2. Запускать генерацию: `flutter pub run build_runner build --delete-conflicting-outputs`.

### Backend (NestJS):
1. В Entities: `@Column({ name: 'snake_case_name' })`.
2. В DTO: Использовать `camelCase`, но проверять соответствие маппингу в контроллерах.

## 🛠 Команды проекта
### Backend
- Запуск: `npm run start:dev`
- Миграции: `npm run migration:run`
- Тесты: `npm run test` | `npm run test:e2e`

### Frontend
- Кодогенерация: `flutter pub run build_runner build --delete-conflicting-outputs`
- Линтер: `flutter analyze`
- Формат: `dart format lib/`

## 📋 Технические правила
- **State Management:** Только Riverpod 2.x (никаких прямых `setState` в сложных экранах).
- **Strings:** ВСЕГДА проверяй `if (user.firstName.isNotEmpty)` перед `user.firstName[0]`.
- **API:** Используй `DioClient` из `core/api/`. Не создавай новые экземпляры Dio.
- **Errors:** Оборачивай вызовы в `AsyncValue.guard` на фронте и `UseFilters(HttpExceptionFilter)` на бэке.

## 📂 Поиск документации
- API Эндпоинты: `./docs/technical/API-v2-Summary.md`
- Схема БД: `./docs/technical/Database-v2.md`
- Дизайн/Цвета: `./docs/design/BrandBook.md`