# Service Platform - Документация

**Версия:** 2.0  
**Статус:** ✅ Production Ready  
**Последнее обновление:** 5 февраля 2026

---

## 📚 Навигация по документации

> **Примечание:** Детализированные технические документы (TechSpec, Database-v2, API-v2, CI/CD, Testing, отчёты и планы) перенесены в архив `archive/docs-temporary/` и описаны в `archive/README.md`. Здесь остаются ссылки только на ключевые актуальные документы верхнего уровня.

### 🚀 Быстрый старт

Начните здесь, если вы новичок в проекте:

1. **[Getting Started Guide](guides/GETTING_STARTED.md)** - полное руководство по запуску проекта
2. **[Installation Guide](guides/INSTALLATION_GUIDE.md)** - установка зависимостей
3. **[Contributing Guide](guides/CONTRIBUTING.md)** - как внести вклад в проект

---

## 📖 Основные разделы

### 🏗️ Архитектура

Понимание структуры и дизайна системы:

- **[Architecture Overview](architecture/ARCHITECTURE.md)** - общая архитектура проекта
- **[AI Development Guide (CLAUDE.md)](architecture/CLAUDE.md)** - инструкции для AI-разработки
- **[Database Schema](../docs/technical/Database-v2.md)** - схема БД (29 таблиц)

### 💻 Разработка

Инструменты и процессы для разработчиков:

- **[CI/CD Pipeline](development/CI_CD.md)** - автоматизация сборки и деплоя
- **[Testing Guide](development/TESTING.md)** - unit, E2E, Flutter тесты
- **[Monitoring & Logging](development/MONITORING.md)** - мониторинг и логирование

### 📊 Отчеты

Статус проекта и достижения:

- **[Project Status](reports/PROJECT_STATUS.md)** ⭐ - итоговый статус MVP 100%
- **[E2E Tests Final Report](reports/E2E_TESTS_FINAL.md)** - 73/73 тестов (100%)
- **[Phase 5 Completion](reports/PHASE_5_COMPLETION.md)** - Production Ready features
- **[Security Audit](reports/SECURITY_AUDIT.md)** - OWASP Top 10 (9/10)
- **[Performance Optimization](reports/PERFORMANCE.md)** - оптимизации БД и кеширование

### 🗂️ Архив

Исторические документы (для справки):

- **[Session Summaries](archive/sessions/)** - E2E testing sessions 2-7
- **[Phase Completions](archive/phases/)** - Phase 1-3 progress reports
- **[Old Analysis](archive/old-analysis/)** - устаревшие аналитические отчеты

---

## 🎯 Ключевые ссылки

### Бизнес-документация
- [BRD - Business Requirements](business/BRD.md)
- [User Stories](business/UserStories.md) - 70 user stories
- [Service Catalog](business/Catalog.md) - 340+ услуг

### Техническая документация
- [Technical Specification](technical/TechSpec.md)
- [API Documentation v2.0](technical/API-v2-Summary.md) - 165 endpoints
- [WebSocket Specification](technical/WebSocket-Specification.md)

### Дизайн-документация
- [Brand Book](design/BrandBook.md) - фирменный стиль
- [UX/UI Guide v2.0](design/UXUI-Guide-v2.md) - 30+ экранов

---

## ✅ Чеклист перед стартом

Если вы только начинаете работу с проектом:

- [ ] Прочитать [Getting Started Guide](guides/GETTING_STARTED.md)
- [ ] Настроить окружение (Docker, PostgreSQL, Redis)
- [ ] Запустить backend: `cd backend && npm run start:dev`
- [ ] Запустить frontend: `cd frontend && flutter run`
- [ ] Проверить тесты: `npm run test:e2e`
- [ ] Изучить [Architecture Overview](architecture/ARCHITECTURE.md)
- [ ] Ознакомиться с [Contributing Guide](guides/CONTRIBUTING.md)

---

## 📈 Статус проекта

**MVP: 485/485 очков (100%)** ✅

- ✅ Backend: 16 модулей, 165 REST endpoints, 11 WebSocket событий
- ✅ Frontend: 14 feature modules, 30+ экранов
- ✅ Database: 29 таблиц с миграциями
- ✅ E2E Tests: 73/73 (100%)
- ✅ Unit Tests: 185/185 (100%)
- ✅ Production Ready: Security, Performance, Monitoring, CI/CD

**Проект готов к production deployment!** 🚀

---

## 🔍 Поиск информации

### По задачам:

- **Настройка окружения** → [Getting Started](guides/GETTING_STARTED.md)
- **Архитектура системы** → [Architecture](architecture/ARCHITECTURE.md)
- **API endpoints** → [API v2.0](../docs/technical/API-v2-Summary.md)
- **Схема БД** → [Database](../docs/technical/Database-v2.md)
- **Запуск тестов** → [Testing Guide](development/TESTING.md)
- **CI/CD setup** → [CI/CD](development/CI_CD.md)
- **Мониторинг** → [Monitoring](development/MONITORING.md)
- **Безопасность** → [Security Audit](reports/SECURITY_AUDIT.md)
- **Производительность** → [Performance](reports/PERFORMANCE.md)

### По ролям:

**Backend разработчик:**
1. [Architecture](architecture/ARCHITECTURE.md)
2. [API v2.0](../docs/technical/API-v2-Summary.md)
3. [Database](../docs/technical/Database-v2.md)
4. [Testing](development/TESTING.md)

**Frontend разработчик:**
1. [Flutter Setup](guides/FLUTTER_SETUP.md)
2. [UX/UI Guide](design/UXUI-Guide-v2.md)
3. [API v2.0](../docs/technical/API-v2-Summary.md)
4. [Brand Book](design/BrandBook.md)

**DevOps инженер:**
1. [CI/CD](development/CI_CD.md)
2. [Monitoring](development/MONITORING.md)
3. [Security](reports/SECURITY_AUDIT.md)
4. [Performance](reports/PERFORMANCE.md)

**Product Manager:**
1. [Project Status](reports/PROJECT_STATUS.md)
2. [BRD](business/BRD.md)
3. [User Stories](business/UserStories.md)
4. [Phase 5 Completion](reports/PHASE_5_COMPLETION.md)

---

## 📞 Контакты и поддержка

- **GitHub Repository:** https://github.com/Midasfallen/masters
- **Issues:** https://github.com/Midasfallen/masters/issues
- **Documentation:** Этот раздел

---

**Структура документации обновлена:** 14 января 2026  
**Версия проекта:** 2.0  
**Статус:** Production Ready ✅
