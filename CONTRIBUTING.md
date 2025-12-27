# CONTRIBUTING - Гайд для контрибьюторов

**Версия:** 2.0
**Дата:** Декабрь 2025

---

## 👋 Добро пожаловать!

Спасибо за интерес к проекту **Service Platform**! Мы рады любому вкладу — багфиксам, новым фичам, улучшению документации или тестам.

Этот гайд поможет вам начать contributing в проект.

---

## 📋 Содержание

1. [Как начать](#как-начать)
2. [Структура проекта](#структура-проекта)
3. [Настройка окружения](#настройка-окружения)
4. [Процесс разработки](#процесс-разработки)
5. [Code Style](#code-style)
6. [Тестирование](#тестирование)
7. [Pull Request Process](#pull-request-process)
8. [Commit Guidelines](#commit-guidelines)
9. [Где нужна помощь](#где-нужна-помощь)

---

## 🚀 Как начать

### 1. Fork репозитория

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/masters.git
cd masters

# Add upstream remote
git remote add upstream https://github.com/Midasfallen/masters.git
```

### 2. Создайте feature branch

```bash
git checkout -b feature/your-feature-name
```

### 3. Сделайте изменения

Следуйте [Code Style](#code-style) и [Testing Guidelines](#тестирование).

### 4. Push и создайте Pull Request

```bash
git push origin feature/your-feature-name
```

Затем откройте Pull Request на GitHub.

---

## 📁 Структура проекта

```
masters/
├── backend/               # NestJS backend
│   ├── src/
│   │   ├── modules/       # Модули приложения
│   │   ├── common/        # Общий код (guards, filters, decorators)
│   │   ├── database/      # TypeORM entities
│   │   └── main.ts
│   ├── test/              # E2E и integration тесты
│   └── package.json
│
├── frontend/              # Flutter frontend
│   ├── lib/
│   │   ├── features/      # Фичи приложения
│   │   ├── core/          # Ядро (providers, services, models)
│   │   ├── shared/        # Общие виджеты и утилиты
│   │   └── main.dart
│   ├── test/              # Unit и widget тесты
│   └── pubspec.yaml
│
├── docs/                  # Документация
│   ├── business/          # Бизнес-документы
│   ├── technical/         # Техническая документация
│   ├── analysis/          # Аналитика
│   └── testing/           # Тестовая документация
│
├── infra/                 # Infrastructure as Code
│   ├── docker/
│   ├── kubernetes/
│   └── terraform/
│
└── README.md
```

---

## 🔧 Настройка окружения

### Backend (NestJS)

**Требования:**
- Node.js 18+
- PostgreSQL 15+
- Redis 7+
- MinIO (для локальной разработки)

**Установка:**

```bash
cd backend

# Install dependencies
npm install

# Setup environment
cp .env.example .env
# Edit .env with your local config

# Run migrations
npm run migration:run

# Seed database
npm run seed

# Start development server
npm run start:dev
```

Backend будет доступен на `http://localhost:3000`.

### Frontend (Flutter)

**Требования:**
- Flutter 3.x
- Dart 3.x
- Android Studio или Xcode (для мобильной разработки)

**Установка:**

```bash
cd frontend

# Get dependencies
flutter pub get

# Generate code (Freezed, JSON serialization)
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run
```

### Database (PostgreSQL)

**Docker Compose для локальной разработки:**

```bash
cd infra/docker

# Start all services (Postgres, Redis, MinIO, Meilisearch)
docker-compose up -d

# Check services
docker-compose ps
```

---

## 💻 Процесс разработки

### 1. Выберите задачу

- Посмотрите [Issues](https://github.com/Midasfallen/masters/issues)
- Найдите задачи с label `good first issue` или `help wanted`
- Оставьте комментарий, что берете задачу

### 2. Создайте ветку

Используйте naming convention:

- `feature/short-description` - новая фича
- `fix/short-description` - багфикс
- `docs/short-description` - изменения в документации
- `test/short-description` - добавление тестов
- `refactor/short-description` - рефакторинг

Примеры:
```bash
git checkout -b feature/add-post-likes
git checkout -b fix/websocket-reconnection
git checkout -b docs/update-api-spec
```

### 3. Разработка

- Пишите clean code
- Следуйте [Code Style](#code-style)
- Добавьте тесты для новой функциональности
- Обновите документацию, если нужно

### 4. Commit

Следуйте [Commit Guidelines](#commit-guidelines).

### 5. Push и Pull Request

```bash
git push origin feature/add-post-likes
```

Откройте Pull Request с:
- **Понятным названием**
- **Описанием изменений**
- **Скриншотами** (для UI изменений)
- **Связью с issue** (e.g., "Fixes #123")

---

## 📏 Code Style

### Backend (TypeScript/NestJS)

**ESLint:** Мы используем ESLint для линтинга.

```bash
# Run linter
npm run lint

# Fix auto-fixable issues
npm run lint:fix
```

**Правила:**

1. **Naming Conventions:**
   ```typescript
   // Classes: PascalCase
   class UserService {}

   // Functions/variables: camelCase
   const getUserById = () => {};

   // Constants: UPPER_SNAKE_CASE
   const MAX_RETRIES = 3;

   // Interfaces: PascalCase with 'I' prefix
   interface IUser {}
   ```

2. **Imports:** Группируйте imports
   ```typescript
   // 1. Node modules
   import { Injectable } from '@nestjs/common';

   // 2. Internal modules
   import { UserRepository } from './user.repository';

   // 3. Types
   import type { User } from '@/types';
   ```

3. **Async/Await:** Используйте async/await вместо Promises
   ```typescript
   // Good
   const user = await userService.findById(id);

   // Bad
   userService.findById(id).then(user => { ... });
   ```

4. **Error Handling:** Используйте NestJS exceptions
   ```typescript
   throw new BadRequestException('Invalid email');
   throw new NotFoundException('User not found');
   ```

### Frontend (Dart/Flutter)

**Analyzer:** Мы используем Dart Analyzer.

```bash
# Run analyzer
flutter analyze

# Format code
dart format lib/
```

**Правила:**

1. **Naming Conventions:**
   ```dart
   // Classes: PascalCase
   class UserProvider {}

   // Functions/variables: camelCase
   final getUserById = () {};

   // Constants: lowerCamelCase
   const maxRetries = 3;

   // Private: prefix with _
   final _privateMethod = () {};
   ```

2. **Riverpod Providers:**
   ```dart
   // Provider naming: xxxProvider
   final userProvider = StateNotifierProvider<UserNotifier, User>(...);

   // Notifier naming: XxxNotifier
   class UserNotifier extends StateNotifier<User> {}
   ```

3. **Widgets:**
   ```dart
   // Stateless widgets preferred
   class UserCard extends StatelessWidget {
     const UserCard({super.key, required this.user});

     final User user;

     @override
     Widget build(BuildContext context) {
       return Card(...);
     }
   }
   ```

4. **Freezed Models:**
   ```dart
   @freezed
   class User with _$User {
     const factory User({
       required String id,
       required String name,
     }) = _User;

     factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
   }
   ```

---

## 🧪 Тестирование

### Backend Tests

**Unit Tests:**

```bash
# Run all tests
npm run test

# Run tests for specific file
npm run test -- user.service.spec.ts

# Watch mode
npm run test:watch

# Coverage
npm run test:cov
```

**Пример:**

```typescript
describe('UserService', () => {
  let service: UserService;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [UserService, UserRepository],
    }).compile();

    service = module.get<UserService>(UserService);
  });

  describe('findById', () => {
    it('should return user if found', async () => {
      const user = await service.findById('uuid');
      expect(user).toBeDefined();
      expect(user.id).toBe('uuid');
    });

    it('should throw NotFoundException if not found', async () => {
      await expect(service.findById('invalid')).rejects.toThrow(NotFoundException);
    });
  });
});
```

**E2E Tests:**

```bash
npm run test:e2e
```

### Frontend Tests

**Unit & Widget Tests:**

```bash
# Run all tests
flutter test

# Run specific test
flutter test test/features/auth/login_test.dart

# Coverage
flutter test --coverage
```

**Пример:**

```dart
testWidgets('LoginScreen should show error on invalid email', (tester) async {
  await tester.pumpWidget(MyApp());

  await tester.enterText(find.byKey(Key('email_field')), 'invalid-email');
  await tester.tap(find.byKey(Key('login_button')));
  await tester.pump();

  expect(find.text('Invalid email format'), findsOneWidget);
});
```

### Требования к тестам

✅ **Unit Tests:**
- Покрытие > 80% для backend
- Покрытие > 70% для frontend

✅ **Integration Tests:**
- Критичные user flows

✅ **E2E Tests:**
- Основные сценарии (регистрация, booking, чаты)

---

## 🔄 Pull Request Process

### 1. Перед созданием PR

- [ ] Код следует [Code Style](#code-style)
- [ ] Все тесты проходят
- [ ] Нет lint ошибок
- [ ] Документация обновлена (если нужно)
- [ ] Коммиты следуют [Commit Guidelines](#commit-guidelines)

### 2. Checklist для PR

**Template Pull Request:**

```markdown
## Description
[Опишите ваши изменения]

## Type of Change
- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Related Issue
Fixes #[issue number]

## Testing
- [ ] Unit tests added/updated
- [ ] Integration tests added/updated
- [ ] Manual testing performed

## Screenshots (if applicable)
[Add screenshots for UI changes]

## Checklist
- [ ] Code follows project style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex logic
- [ ] Documentation updated
- [ ] No new warnings generated
```

### 3. Code Review

После создания PR:
- Reviewer будет назначен автоматически
- Ответьте на комментарии
- Внесите изменения, если требуется
- После approve - PR будет смержен

**Требования для merge:**
- ✅ 1+ approvals
- ✅ CI/CD проходит (tests, linting, build)
- ✅ Нет конфликтов с main
- ✅ Все комментарии resolved

---

## 📝 Commit Guidelines

Мы используем [Conventional Commits](https://www.conventionalcommits.org/).

### Формат

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: Новая фича
- `fix`: Багфикс
- `docs`: Изменения в документации
- `style`: Форматирование (не влияет на код)
- `refactor`: Рефакторинг
- `test`: Добавление тестов
- `chore`: Изменения в build process, dependencies
- `perf`: Улучшение производительности

### Примеры

```bash
# Feature
git commit -m "feat(feed): add post likes functionality

- Implement POST /posts/:id/like endpoint
- Add likes count to post model
- Update Feed UI to show like button"

# Bug fix
git commit -m "fix(websocket): handle reconnection on network loss

- Add exponential backoff for reconnection
- Persist undelivered messages in local storage
- Fixes #123"

# Documentation
git commit -m "docs(api): update API.md with new endpoints

- Add documentation for POST /posts/:id/like
- Add WebSocket events section"

# Refactor
git commit -m "refactor(auth): extract JWT logic to separate service

- Create JwtService for token operations
- Improve testability"
```

### Rules

- ✅ Используйте imperative mood ("add" not "added")
- ✅ Первая строка <= 72 символов
- ✅ Body объясняет "why", не "what"
- ✅ Упомяните issue в footer (`Fixes #123`, `Closes #456`)

---

## 🆘 Где нужна помощь

### Good First Issues

Ищите issues с labels:
- `good first issue` - Простые задачи для новичков
- `help wanted` - Задачи, где нужна помощь
- `documentation` - Улучшение документации

### Priority Areas

**Backend:**
- Оптимизация Feed алгоритма
- WebSocket масштабирование
- Кэширование стратегия
- Real-time уведомления

**Frontend:**
- Feed UI/UX улучшения
- Оптимизация производительности
- Accessibility improvements
- Анимации и микровзаимодействия

**Documentation:**
- API примеры
- Tutorial для начинающих
- Архитектурная документация
- Translation (English)

**Testing:**
- Увеличение test coverage
- E2E тесты для новых фич
- Performance тесты
- Load testing scripts

---

## 📞 Контакты

- **GitHub Issues:** [github.com/Midasfallen/masters/issues](https://github.com/Midasfallen/masters/issues)
- **Discussions:** [github.com/Midasfallen/masters/discussions](https://github.com/Midasfallen/masters/discussions)
- **Email:** [contact@service-platform.com](mailto:contact@service-platform.com)

---

## 📜 License

Делая contributing в этот проект, вы соглашаетесь с тем, что ваш код будет лицензирован под той же лицензией, что и проект.

---

## 🙏 Спасибо!

Ваш вклад делает **Service Platform** лучше для всех! 🎉

**Полезные ссылки:**
- [Architecture Overview](./ARCHITECTURE.md)
- [API Specification](./docs/technical/API.md)
- [Technical Specification](./docs/technical/TechSpec.md)
- [Test Plan](./docs/testing/TestPlan.md)

---

**Последнее обновление:** Декабрь 2025
**Версия:** 2.0
