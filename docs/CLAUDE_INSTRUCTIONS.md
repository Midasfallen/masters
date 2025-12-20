# ИНСТРУКЦИИ ДЛЯ РАБОТЫ С ПРОЕКТАМИ MIDASFALLEN

**Автор:** Claude
**Дата создания:** Декабрь 2025
**Версия:** 1.1
**Последнее обновление:** Декабрь 2025

---

## ⚡ Автоматический Workflow (gh CLI)

### Настройка выполнена ✅

**GitHub CLI аутентифицирован** для автоматического управления репозиторием:
- Аккаунт: **Midasfallen**
- Токен: настроен с полными правами (repo, workflow)
- Протокол: HTTPS

### Автоматические операции

**Теперь я могу автоматически:**

1. **Создавать Pull Requests**
```bash
gh pr create --base main --head branch-name --title "Title" --body "Description"
```

2. **Мержить PR в main**
```bash
gh pr merge PR_NUMBER --merge --delete-branch
```

3. **Создать и сразу смержить**
```bash
gh pr create --fill && gh pr merge --auto --merge
```

4. **Проверять статус**
```bash
gh pr status
gh pr list
```

### Workflow процесс

**Стандартный процесс работы:**

1. Делаю изменения в коде
2. Коммичу в feature branch `claude/*-Cpb49`
3. Пушу в origin
4. Создаю PR через gh CLI
5. Автоматически мержу в main
6. Удаляю feature branch

**Пример полного цикла:**
```bash
# Создание изменений
git checkout -b claude/feature-name-Cpb49
# ... делаю изменения ...
git add .
git commit -m "Description"
git push -u origin claude/feature-name-Cpb49

# Автоматический PR и merge
gh pr create --fill
gh pr merge --auto --merge --delete-branch
```

**Важно:** Ветка main больше не блокируется - теперь все идет через автоматические PR!

---

## Обзор проектов

У пользователя **Midasfallen** на GitHub 4 репозитория:

| Проект | Технологии | Статус | Назначение |
|--------|------------|--------|------------|
| **masters** | Flutter, Node.js/Go/Python, PostgreSQL | Бизнес-анализ | Платформа поиска мастеров "Service" |
| **vpn** | Flutter, FastAPI, WireGuard | Production-ready | VPN приложение с IAP |
| **vpn-api** | FastAPI, PostgreSQL, WireGuard | Production-ready | Backend для VPN |
| **nefors** | Flutter | Начальная стадия | Flutter приложение (шаблон) |

---

## 1. Общие паттерны и подходы

### 1.1 Структура проектов

**Паттерн:** Пользователь использует связку **Flutter (frontend) + FastAPI (backend)**

**Типичная структура:**
```
project/
├── lib/                    # Flutter frontend
│   ├── screens/           # UI экраны
│   ├── services/          # Бизнес-логика, API клиенты
│   └── models/            # Модели данных
├── backend_api/           # FastAPI backend
│   ├── api/               # API endpoints
│   ├── models/            # SQLAlchemy модели
│   ├── services/          # Бизнес-логика
│   └── alembic/           # Миграции БД
├── test/                  # Тесты
├── docker-compose.yml     # Инфраструктура
└── README.md              # Документация
```

### 1.2 Технологический стек

**Frontend (Flutter):**
- Dart для мобильных приложений
- Поддержка iOS, Android, Web, Desktop
- Тестирование: unit tests + E2E tests

**Backend (FastAPI):**
- Python FastAPI для REST API
- SQLAlchemy ORM
- Alembic для миграций
- PostgreSQL в production, SQLite в dev
- JWT аутентификация

**Инфраструктура:**
- Docker Compose для оркестрации
- GitHub Actions для CI/CD
- Emphasis на comprehensive testing

### 1.3 Подход к документации

**Важно:** Пользователь ценит **comprehensive documentation**
- README.md с детальными инструкциями
- Deployment guides
- Troubleshooting sections
- Testing procedures
- "Any engineer with server access can deploy"

---

## 2. Специфика проекта "masters" (Service)

### 2.1 Текущая стадия
- **Фаза:** Бизнес-анализ и системный анализ ✅
- **Статус:** Документация готова, разработка еще не начата
- **Следующий шаг:** Backend и Frontend разработка

### 2.2 Структура документации

```
masters/
├── README.md
├── docs/
│   ├── business/      # Бизнес-требования
│   ├── technical/     # Технические спецификации
│   └── analysis/      # Аналитика и планирование
└── .docx файлы        # Исключены через .gitignore
```

### 2.3 Ключевые документы

1. **BRD.md** - Business Requirements Document
   - Миссия, ценность, позиционирование
   - Целевая аудитория
   - Бизнес-модель

2. **UserStories.md** - 70 историй в 10 эпиках
   - Приоритизация MoSCoW
   - 260 story points

3. **TechSpec.md** - Техническое задание
   - Выбор стека (Flutter + Backend на выбор)
   - Архитектура
   - NFR требования

4. **Database.md** - 19 таблиц с полной схемой

5. **API.md** - 95 endpoints в 17 группах

6. **Risks.md** - 10 рисков с митигацией

7. **Roadmap.md** - План от MVP до v2.0

8. **Requirements.md** - 119 требований

### 2.4 Рекомендации по разработке

**Следовать паттернам из проекта VPN:**

1. **Начать с backend (FastAPI)**
   - Создать `backend/` директорию
   - Setup FastAPI проект
   - SQLAlchemy модели (19 таблиц из Database.md)
   - Alembic миграции
   - JWT аутентификация
   - Endpoints согласно API.md

2. **Frontend (Flutter)**
   - Создать `frontend/` или `mobile/` директорию
   - Flutter multi-platform setup
   - State management (BLoC/Riverpod)
   - API integration

3. **Testing**
   - Unit tests для backend (цель: 100% critical paths)
   - Flutter widget tests
   - E2E automated tests

4. **Docker Compose**
   - PostgreSQL
   - Redis
   - Meilisearch
   - Backend API
   - MinIO (S3-compatible storage)

5. **CI/CD**
   - GitHub Actions
   - Automated tests
   - Migration automation

---

## 3. Специфика проекта "vpn"

### 3.1 Архитектура

**Production-ready VPN приложение:**
- Flutter mobile app (iOS, Android)
- FastAPI backend
- WireGuard VPN server
- wg-easy management UI
- PostgreSQL database

### 3.2 Ключевые особенности

1. **Comprehensive testing**
   - 34/34 backend unit tests passing
   - 16/16 Flutter tests passing
   - 2/2 E2E automated tests passing
   - Manual testing on real device

2. **IAP Integration**
   - In-App Purchases для iOS/Android
   - Webhook support
   - Subscription lifecycle management

3. **WireGuard Integration**
   - Критичная зависимость: wg-easy
   - Автоматическое создание peers
   - SSH операции для удаленного WireGuard

### 3.3 Deployment подход

**Emphasis:** "Any engineer with server access can deploy"
- Comprehensive deployment documentation
- Troubleshooting guides
- SSH configuration
- Windows/Linux development support

---

## 4. Специфика проекта "vpn-api"

### 4.1 FastAPI Backend паттерны

**Структура:**
```
vpn_api/
├── api/
│   ├── auth.py         # JWT аутентификация
│   ├── peers.py        # VPN peer management
│   └── payments.py     # Payment processing
├── models/             # SQLAlchemy models
├── services/           # Business logic
└── alembic/            # Migrations
```

### 4.2 Ключевые компоненты

1. **Аутентификация**
   - JWT tokens
   - User registration/login
   - Admin promotion via bootstrap secret

2. **WireGuard Integration**
   - wg-easy HTTP API client
   - Automatic peer configuration
   - SSH scripts для операций

3. **Database**
   - SQLAlchemy ORM
   - Alembic migrations
   - PostgreSQL (prod), SQLite (dev)

4. **CI/CD**
   - GitHub Actions
   - Automated migration deployment
   - Testing pipelines

---

## 5. Инструкции для работы с проектами

### 5.1 При работе с документацией

**DO:**
✅ Конвертировать .docx в Markdown
✅ Создавать структурированные папки (business/, technical/, analysis/)
✅ Comprehensive README.md
✅ Детальные инструкции для deployment
✅ Troubleshooting sections
✅ Testing documentation

**DON'T:**
❌ Оставлять бинарные файлы (.docx) в репозитории
❌ Пропускать deployment инструкции
❌ Игнорировать тестирование

### 5.2 При разработке Backend (FastAPI)

**DO:**
✅ SQLAlchemy для моделей
✅ Alembic для миграций
✅ JWT аутентификация
✅ Comprehensive unit tests (цель: высокий coverage)
✅ Docker Compose для инфраструктуры
✅ GitHub Actions для CI/CD
✅ Документация API endpoints

**Структура:**
```python
# models.py
from sqlalchemy import Column, Integer, String
from database import Base

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    email = Column(String, unique=True)
    # ...

# api/auth.py
from fastapi import APIRouter, Depends
from services.auth import AuthService

router = APIRouter()

@router.post("/register")
async def register(user: UserCreate):
    # ...
```

### 5.3 При разработке Frontend (Flutter)

**DO:**
✅ Multi-platform setup (iOS, Android, Web, Desktop)
✅ Proper state management (BLoC/Riverpod/Provider)
✅ API client services
✅ Widget tests
✅ E2E tests
✅ Proper error handling

**Структура:**
```
lib/
├── main.dart
├── screens/
│   ├── home_screen.dart
│   └── profile_screen.dart
├── services/
│   ├── api_client.dart
│   └── auth_service.dart
├── models/
│   └── user.dart
└── widgets/
    └── custom_button.dart
```

### 5.4 При тестировании

**Backend tests pattern:**
```python
# test_auth.py
import pytest
from httpx import AsyncClient

@pytest.mark.asyncio
async def test_register_success(client: AsyncClient):
    response = await client.post("/api/auth/register", json={
        "email": "test@example.com",
        "password": "secure123"
    })
    assert response.status_code == 200
    assert "access_token" in response.json()
```

**Flutter tests pattern:**
```dart
// widget_test.dart
testWidgets('Login button test', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  expect(find.text('Login'), findsOneWidget);
  await tester.tap(find.text('Login'));
  await tester.pump();
  // assertions...
});
```

### 5.5 Git workflow

**Branches:**
- `main` - основная ветка (защищена, требует PR)
- `claude/*-<session-id>` - feature ветки для разработки с Claude
- Push только в feature ветки, затем PR в main

**Commit messages:**
```bash
git commit -m "$(cat <<'EOF'
Add user authentication module

- Implement JWT token generation
- Add user registration endpoint
- Add login endpoint
- Include unit tests (12/12 passing)

Related to: Feature #123
EOF
)"
```

### 5.6 Docker Compose pattern

```yaml
version: '3.8'

services:
  db:
    image: postgres:15
    environment:
      POSTGRES_DB: myapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7
    ports:
      - "6379:6379"

  api:
    build: ./backend
    ports:
      - "8000:8000"
    depends_on:
      - db
      - redis
    environment:
      DATABASE_URL: postgresql://user:password@db:5432/myapp
      REDIS_URL: redis://redis:6379

volumes:
  postgres_data:
```

---

## 6. Checklist для нового проекта

### Phase 1: Документация (как в masters)
- [ ] README.md с обзором проекта
- [ ] BRD.md - бизнес-требования
- [ ] UserStories.md - пользовательские истории
- [ ] TechSpec.md - техническое задание
- [ ] Database.md - схема БД
- [ ] API.md - спецификация API
- [ ] Risks.md - риски и митигация
- [ ] Roadmap.md - дорожная карта
- [ ] Requirements.md - требования

### Phase 2: Backend Setup (как в vpn-api)
- [ ] FastAPI проект setup
- [ ] SQLAlchemy модели
- [ ] Alembic миграции
- [ ] JWT аутентификация
- [ ] API endpoints
- [ ] Unit tests (цель: >80% coverage)
- [ ] Docker Compose для dev
- [ ] CI/CD pipeline

### Phase 3: Frontend Setup (как в vpn)
- [ ] Flutter проект setup
- [ ] Multi-platform конфигурация
- [ ] State management
- [ ] API client
- [ ] Базовые экраны
- [ ] Widget tests
- [ ] E2E tests

### Phase 4: Integration & Testing
- [ ] Backend + Frontend integration
- [ ] End-to-End tests
- [ ] Manual testing на real device
- [ ] Performance testing
- [ ] Security audit

### Phase 5: Deployment
- [ ] Production Docker Compose
- [ ] Deployment documentation
- [ ] Troubleshooting guide
- [ ] Monitoring setup

---

## 7. Специфичные команды и скрипты

### Backend (FastAPI)

```bash
# Development
cd backend
python -m venv venv
source venv/bin/activate  # Linux/Mac
# или venv\Scripts\activate  # Windows
pip install -r requirements.txt

# Миграции
alembic revision --autogenerate -m "Description"
alembic upgrade head

# Тесты
pytest
pytest --cov=vpn_api --cov-report=html

# Запуск
uvicorn vpn_api.main:app --reload
```

### Frontend (Flutter)

```bash
# Development
cd frontend
flutter pub get
flutter run

# Тесты
flutter test
flutter test integration_test/

# Build
flutter build apk        # Android
flutter build ios        # iOS
flutter build web        # Web
```

### Docker

```bash
# Development
docker-compose up -d
docker-compose logs -f api

# Production
docker-compose -f docker-compose.prod.yml up -d

# Миграции в Docker
docker-compose exec api alembic upgrade head
```

---

## 8. Типичные проблемы и решения

### Проблема 1: WireGuard integration (из vpn проекта)
**Симптом:** VPN connects but has no internet
**Решение:** Проверить wg-easy интеграцию, это критическая зависимость

### Проблема 2: Database migrations
**Симптом:** Migration conflicts
**Решение:** Использовать alembic revision --autogenerate, проверять generated migrations

### Проблема 3: Flutter platform issues
**Симптом:** Platform-specific build errors
**Решение:** Проверить platform-specific конфигурации (android/, ios/, etc.)

### Проблема 4: JWT token expiration
**Симптом:** Unauthorized errors
**Решение:** Implement refresh token mechanism

---

## 9. Метрики качества (стандарты пользователя)

**Из проекта VPN (эталон):**
- ✅ 34/34 backend unit tests passing
- ✅ 16/16 Flutter tests passing
- ✅ 2/2 E2E automated tests passing
- ✅ Manual testing verified on real device

**Цели для новых проектов:**
- Backend test coverage: >80%
- Flutter test coverage: >70%
- All critical paths tested
- E2E tests for main user flows
- Real device testing before production

---

## 10. Приоритеты пользователя

**High Priority:**
1. 📚 **Comprehensive documentation** - "Any engineer can deploy"
2. 🧪 **Thorough testing** - Unit + Integration + E2E
3. 🏗️ **Proper architecture** - Clean, maintainable code
4. 🐳 **Docker-first** - Easy deployment
5. 🔐 **Security** - JWT, proper auth, data protection

**Technology Preferences:**
- Flutter для mobile/cross-platform
- FastAPI для backend (предпочтение Python)
- PostgreSQL для production database
- Docker Compose для инфраструктуры
- GitHub Actions для CI/CD

**Workflow Preferences:**
- Детальная документация на каждом этапе
- Structured project layout
- Clear separation of concerns
- Test-driven approach

---

## 11. Шаблоны для быстрого старта

### README.md template

```markdown
# PROJECT_NAME

> Brief description

## Overview
[Detailed description]

## Tech Stack
- Frontend: Flutter
- Backend: FastAPI
- Database: PostgreSQL
- Cache: Redis

## Getting Started

### Prerequisites
- Python 3.11+
- Flutter 3.x
- Docker & Docker Compose

### Installation

Backend:
\`\`\`bash
cd backend
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
alembic upgrade head
uvicorn app.main:app --reload
\`\`\`

Frontend:
\`\`\`bash
cd frontend
flutter pub get
flutter run
\`\`\`

Docker:
\`\`\`bash
docker-compose up -d
\`\`\`

## Testing
[Testing instructions]

## Deployment
[Deployment guide]

## Troubleshooting
[Common issues and solutions]

## License
Proprietary
```

---

## 12. Действия при работе с новым проектом

### Когда пользователь просит "создать проект":

1. **Изучить требования** - что за проект, какие функции
2. **Создать документацию** (если проект сложный):
   - README.md
   - docs/business/ - бизнес-требования
   - docs/technical/ - технические спецификации
   - docs/analysis/ - риски, roadmap, requirements

3. **Setup backend** (FastAPI):
   - Создать структуру проекта
   - SQLAlchemy модели
   - Alembic migrations
   - JWT auth
   - API endpoints
   - Tests

4. **Setup frontend** (Flutter):
   - Multi-platform setup
   - State management
   - API client
   - Screens
   - Tests

5. **Docker Compose**:
   - Настроить сервисы
   - Volumes
   - Networks

6. **CI/CD**:
   - GitHub Actions
   - Automated tests
   - Deployment automation

### Когда пользователь просит "обновить документацию":

1. Конвертировать .docx в Markdown
2. Создать структуру docs/
3. Обновить README.md
4. Добавить недостающие разделы
5. Commit и push

### Когда пользователь просит "добавить функцию":

1. Обновить документацию (если нужно)
2. Backend: модель + endpoint + tests
3. Frontend: UI + service + tests
4. Integration tests
5. Update README если нужно
6. Commit и push

---

## 13. Ссылки на референсные проекты

- **masters** - https://github.com/Midasfallen/masters
  - Эталон документации
  - Бизнес-анализ и системный анализ

- **vpn** - https://github.com/Midasfallen/vpn
  - Эталон production-ready приложения
  - Flutter + FastAPI integration
  - Comprehensive testing

- **vpn-api** - https://github.com/Midasfallen/vpn-api
  - Эталон FastAPI backend
  - Database migrations
  - CI/CD

- **nefors** - https://github.com/Midasfallen/nefors
  - Flutter template
  - Multi-platform setup

---

**Последнее обновление:** Декабрь 2025
**Версия:** 1.0

**Примечание:** Эти инструкции созданы на основе анализа существующих проектов пользователя Midasfallen и будут обновляться по мере появления новых паттернов и практик.
