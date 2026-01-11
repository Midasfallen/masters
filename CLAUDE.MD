# CLAUDE.MD - Инструкции для Claude при работе с проектом Service Platform

**Версия:** 2.2
**Проект:** Service Platform (masters)
**Дата создания:** 9 января 2026
**Последнее обновление:** 12 января 2026

---

## 📋 Обзор проекта

**Service Platform** — социальная платформа с интегрированным маркетплейсом услуг красоты и велнеса. Концепция: "Instagram для мастеров" — гибрид социальной сети и маркетплейса.

### Ключевые особенности v2.0
- **Социальная лента (Feed)** — 3-колоночная сетка фото/видео как главный экран
- **Друзья и подписки** — двусторонние и односторонние связи
- **Real-time чаты** — WebSocket с 8 типами сообщений
- **Обязательные отзывы** — блокировка функционала без отзыва
- **Автопредложения** — умный подбор мастеров (премиум)
- **Роль мастера** — 5-шаговое создание профиля для любого пользователя

### Технологический стек
- **Frontend:** Flutter 3.x (iOS, Android, Web)
- **Backend:** NestJS 10.x + TypeScript 5.x
- **Database:** PostgreSQL 15+ с PostGIS
- **Cache:** Redis 7+
- **Search:** Meilisearch
- **Storage:** MinIO (S3-compatible)
- **Real-time:** Socket.IO + Redis Pub/Sub
- **State Management:** Riverpod 2.x
- **ORM:** TypeORM 0.3.x
- **Code Generation:** Freezed, JSON Serializable

### Текущий статус разработки (12 января 2026)

**📊 Общий прогресс MVP:** 305 / 485 очков (63%)

**✅ Завершенные фазы:**
- ✅ **ФАЗА 0:** Подготовка (25/25 очков) - 100%
- ✅ **ФАЗА 1:** Backend Core Modules (120/120 очков) - 100%
  - Auth, Users, Masters, Categories, Services, Bookings, Reviews, Search
- ✅ **ФАЗА 2:** Social & Real-time (80/80 очков) - 100%
  - Week 6: WebSocket Gateway реализован (Socket.IO + Redis Pub/Sub)
  - Week 7: Backend Testing завершено (129 unit тестов, покрытие 27.38%)
- ✅ **ФАЗА 3:** Frontend Integration (80/100 очков) - 80%
  - Week 8: Auth + User Profile интеграция (40 очков) ✅
  - Week 9: Feed + Posts интеграция (40 очков) ✅

**🚀 Ключевые достижения:**
- ✅ 8 backend модулей реализованы (Auth, Users, Masters, Bookings, Posts, Friends, Subscriptions, Reviews)
- ✅ WebSocket Gateway с 11 типами событий
- ✅ Real-time интеграция с Chats, Notifications, Social модулями
- ✅ 129 unit тестов написано для 9 сервисов
- ✅ Покрытие кода: 27.38%
- ✅ TypeORM entities для 29 таблиц
- ✅ JWT аутентификация с refresh tokens
- ✅ PostgreSQL database с PostGIS
- ✅ Redis Pub/Sub для WebSocket scaling
- ✅ **Frontend Auth интеграция** - Login, Register, Auto-login, Logout
- ✅ **Frontend Profile интеграция** - Avatar upload, User stats, Settings
- ✅ **Frontend Feed интеграция** - Infinite scroll, Pull-to-refresh, 3-колоночная сетка
- ✅ **Frontend Posts интеграция** - Post detail, Like/Unlike, Comments

**⏳ В разработке:**
- 🔄 ФАЗА 3: Frontend Integration (80/100 очков) - остались интеграции Friends, Subscriptions, Search
- 🔄 ФАЗА 4: Advanced Features (0/85 очков)
- 🔄 ФАЗА 5: Production Ready (0/75 очков)

**📱 Frontend:**
- ✅ Flutter прототип реализован (11 экранов)
- ✅ Brand Book и UX/UI Guide v2.0 созданы
- ✅ **Dio HTTP Client** с interceptors (Auth, Refresh Token, Retry, Error Handler)
- ✅ **Auth Flow интегрирован** - Login, Register, JWT storage, Auto-login
- ✅ **Profile Screen интегрирован** - Avatar upload, User info, Logout
- ✅ **Feed Screen интегрирован** - Infinite scroll, Pagination (20 posts/page)
- ✅ **Post Detail Screen интегрирован** - Full-screen view, Like/Unlike, Comments
- ✅ **Comments интегрированы** - Load comments, Create comment, Real-time display
- ✅ API endpoints v2.0 добавлены (19 новых: Friends, Subscriptions, Auto Proposals)
- 🔄 WebSocket интеграция - следующий этап

---

## 🏗️ Архитектура проекта

### Структура репозитория

```
masters/
├── frontend/              # Flutter приложение
│   ├── lib/
│   │   ├── core/          # Ядро приложения
│   │   │   ├── api/       # API клиенты (Dio)
│   │   │   ├── models/    # Freezed модели
│   │   │   ├── providers/ # Riverpod providers
│   │   │   ├── repositories/ # Репозитории
│   │   │   ├── routing/   # go_router
│   │   │   ├── theme/     # Material 3 темы
│   │   │   └── constants/ # Константы
│   │   ├── features/      # Модули приложения
│   │   │   ├── auth/      # Авторизация (4 экрана)
│   │   │   ├── feed/      # Лента контента (v2.0)
│   │   │   ├── posts/     # Просмотр постов
│   │   │   ├── chats/     # Чаты (v2.0)
│   │   │   ├── friends/   # Друзья (v2.0)
│   │   │   ├── subscriptions/ # Подписки (v2.0)
│   │   │   ├── search/    # Поиск мастеров
│   │   │   ├── bookings/  # Записи
│   │   │   ├── master/    # Профиль мастера
│   │   │   ├── profile/   # Профиль пользователя
│   │   │   └── notifications/ # Уведомления (v2.0)
│   │   ├── shared/        # Общие компоненты
│   │   │   ├── widgets/   # Переиспользуемые виджеты
│   │   │   └── utils/     # Утилиты
│   │   └── main.dart
│   ├── test/              # Тесты
│   ├── pubspec.yaml       # Зависимости
│   └── analysis_options.yaml # Линтер
│
├── backend/               # NestJS backend (активная разработка)
│   ├── src/
│   │   ├── modules/       # ✅ 8 модулей реализовано
│   │   │   ├── auth/      # ✅ JWT аутентификация
│   │   │   ├── users/     # ✅ Управление пользователями
│   │   │   ├── masters/   # ✅ Профили мастеров
│   │   │   ├── bookings/  # ✅ Система бронирования
│   │   │   ├── posts/     # ✅ Социальная лента
│   │   │   ├── friends/   # ✅ Друзья и подписки
│   │   │   ├── chats/     # ⏳ В планах
│   │   │   └── notifications/ # ⏳ В планах
│   │   ├── common/        # Guards, filters, decorators
│   │   ├── database/      # TypeORM entities (29 таблиц)
│   │   ├── websocket/     # ✅ WebSocket Gateway
│   │   ├── jobs/          # Background jobs
│   │   └── main.ts
│   └── test/              # ✅ 129 unit тестов, 27.38% покрытие
│
├── docs/                  # Документация
│   ├── business/          # BRD, UserStories, Catalog
│   ├── technical/         # TechSpec, Database, API
│   ├── design/            # BrandBook, UXUI Guide
│   ├── analysis/          # Risks, Roadmap, Requirements
│   └── testing/           # TestPlan, TestCases
│
├── ARCHITECTURE.md        # Архитектура системы
├── CONTRIBUTING.md        # Гайд для контрибьюторов
├── CLAUDE.MD             # Этот файл
└── README.md             # Главный README
```

### Паттерны архитектуры

#### Frontend (Flutter)
**Clean Architecture + Feature-First подход:**
```
features/
  └── feature_name/
      ├── data/           # Repositories, API clients, Models
      ├── domain/         # Entities, Use cases (опционально)
      └── presentation/   # Screens, Widgets, Providers
```

**State Management: Riverpod**
```dart
// Provider definition
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<UserModel>>((ref) {
  return UserNotifier(ref.read(userRepositoryProvider));
});

// Notifier
class UserNotifier extends StateNotifier<AsyncValue<UserModel>> {
  UserNotifier(this.repository) : super(const AsyncValue.loading());

  final UserRepository repository;

  Future<void> loadUser(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => repository.getUserById(id));
  }
}

// Usage in Widget
class UserProfile extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider);

    return userAsync.when(
      data: (user) => Text(user.name),
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
```

#### Backend (NestJS)
**Модульная архитектура + Слоистая структура:**
```typescript
// Controller Layer (HTTP/WebSocket endpoints)
@Controller('users')
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get(':id')
  async getUser(@Param('id') id: string) {
    return this.userService.findById(id);
  }
}

// Service Layer (Business logic)
@Injectable()
export class UserService {
  constructor(
    private readonly userRepo: UserRepository,
    private readonly cacheService: CacheService,
  ) {}

  async findById(id: string): Promise<User> {
    const cached = await this.cacheService.get(`user:${id}`);
    if (cached) return cached;

    const user = await this.userRepo.findById(id);
    await this.cacheService.set(`user:${id}`, user, 300);
    return user;
  }
}

// Repository Layer (Data access)
@EntityRepository(User)
export class UserRepository extends Repository<User> {
  async findById(id: string): Promise<User> {
    return this.findOne({ where: { id } });
  }
}
```

---

## 🎨 Дизайн-система (Brand Book)

### Цветовая палитра

**Primary (Фиолетовый):**
- `#6750A4` (RGB: 103, 80, 164)
- Использование: основные кнопки, активные состояния, акценты

**Secondary (Розовый):**
- `#E91E63` (RGB: 233, 30, 99)
- Использование: избранное, премиум функции, важные уведомления

**Tertiary (Бирюзовый):**
- `#00BCD4` (RGB: 0, 188, 212)
- Использование: успешные действия, подтверждения

**Семантические цвета:**
- Success: `#4CAF50` (зеленый)
- Warning: `#FF9800` (оранжевый)
- Error: `#F44336` (красный)
- Info: `#2196F3` (синий)

### Градиенты

```dart
// Primary Gradient (Purple → Pink)
LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [Color(0xFF6750A4), Color(0xFF9C27B0), Color(0xFFE91E63)],
)

// Success Gradient (Green)
LinearGradient(
  colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
)

// Premium Gradient (Gold)
LinearGradient(
  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
)
```

### Типографика (Inter Font Family)

```dart
// Заголовки
displayLarge: TextStyle(fontSize: 57, fontWeight: FontWeight.w700)
displayMedium: TextStyle(fontSize: 45, fontWeight: FontWeight.w700)
displaySmall: TextStyle(fontSize: 36, fontWeight: FontWeight.w700)

headlineLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.w600)
headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600)
headlineSmall: TextStyle(fontSize: 24, fontWeight: FontWeight.w600)

// Основной текст
bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400)
bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)
bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.w400)

// Лейблы
labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w600)
labelMedium: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)
labelSmall: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)
```

### Размеры и отступы (AppSizes)

```dart
// Padding
static const double paddingXs = 4.0;
static const double paddingSm = 8.0;
static const double paddingMd = 16.0;
static const double paddingLg = 24.0;
static const double paddingXl = 32.0;

// Border Radius
static const double radiusXs = 4.0;
static const double radiusSm = 8.0;
static const double radiusMd = 12.0;
static const double radiusLg = 16.0;
static const double radiusXl = 24.0;
static const double radiusFull = 999.0;

// Elevation
static const double elevation0 = 0.0;
static const double elevation1 = 1.0;
static const double elevation2 = 2.0;
static const double elevation3 = 4.0;
static const double elevation4 = 6.0;
static const double elevation5 = 8.0;
```

---

## 🔧 Правила разработки

### 1. Flutter Code Style

#### Naming Conventions
```dart
// Classes: PascalCase
class UserProfile {}
class AuthProvider {}

// Functions/variables: camelCase
final getUserById = () {};
final currentUser;

// Constants: lowerCamelCase
const maxRetries = 3;
const apiBaseUrl = 'https://api.example.com';

// Private: prefix with _
final _privateMethod = () {};
final _internalState;

// Providers: xxxProvider suffix
final userProvider = StateNotifierProvider(...);
final authRepositoryProvider = Provider(...);

// Notifiers: XxxNotifier suffix
class UserNotifier extends StateNotifier<User> {}
```

#### Freezed Models (обязательно)
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @Default(false) @JsonKey(name: 'is_master') bool isMaster,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}
```

#### Riverpod Providers
```dart
// StateNotifierProvider для изменяемого состояния
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<UserModel>>((ref) {
  return UserNotifier(ref.read(userRepositoryProvider));
});

// Provider для неизменяемых зависимостей
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(baseUrl: ref.read(configProvider).apiUrl);
});

// FutureProvider для асинхронных данных
final userFutureProvider = FutureProvider.family<UserModel, String>((ref, userId) {
  return ref.read(userRepositoryProvider).getUserById(userId);
});
```

#### Widget Structure
```dart
class UserCard extends ConsumerWidget {
  const UserCard({
    super.key,
    required this.userId,
    this.onTap,
  });

  final String userId;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(userProvider(userId));

    return userAsync.when(
      data: (user) => _buildCard(context, user),
      loading: () => const ShimmerCard(),
      error: (error, stack) => ErrorCard(error: error),
    );
  }

  Widget _buildCard(BuildContext context, UserModel user) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundImage: user.avatarUrl != null
              ? NetworkImage(user.avatarUrl!)
              : null,
        ),
        title: Text(user.fullName),
        subtitle: Text(user.email),
        onTap: onTap,
      ),
    );
  }
}
```

### 2. Backend (NestJS) Code Style

#### Module Structure
```typescript
// user.module.ts
@Module({
  imports: [TypeOrmModule.forFeature([User])],
  controllers: [UserController],
  providers: [UserService, UserRepository],
  exports: [UserService],
})
export class UserModule {}
```

#### Controller
```typescript
@Controller('users')
@UseGuards(JwtAuthGuard)
export class UserController {
  constructor(private readonly userService: UserService) {}

  @Get(':id')
  @ApiOperation({ summary: 'Get user by ID' })
  @ApiResponse({ status: 200, type: UserDto })
  async getUser(@Param('id') id: string): Promise<UserDto> {
    return this.userService.findById(id);
  }

  @Post()
  @Roles('admin')
  @UseGuards(RolesGuard)
  async createUser(@Body() dto: CreateUserDto): Promise<UserDto> {
    return this.userService.create(dto);
  }
}
```

#### Service
```typescript
@Injectable()
export class UserService {
  constructor(
    private readonly userRepo: UserRepository,
    private readonly cacheService: CacheService,
    private readonly logger: Logger,
  ) {}

  async findById(id: string): Promise<User> {
    this.logger.log(`Finding user by ID: ${id}`);

    const user = await this.userRepo.findById(id);
    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    return user;
  }

  async create(dto: CreateUserDto): Promise<User> {
    const hashedPassword = await bcrypt.hash(dto.password, 10);

    const user = this.userRepo.create({
      ...dto,
      password: hashedPassword,
    });

    return this.userRepo.save(user);
  }
}
```

#### DTO (Data Transfer Objects)
```typescript
import { IsEmail, IsString, MinLength, IsOptional } from 'class-validator';
import { ApiProperty } from '@nestjs/swagger';

export class CreateUserDto {
  @ApiProperty({ example: 'user@example.com' })
  @IsEmail()
  email: string;

  @ApiProperty({ example: 'SecurePass123' })
  @IsString()
  @MinLength(8)
  password: string;

  @ApiProperty({ example: 'John' })
  @IsString()
  firstName: string;

  @ApiProperty({ example: 'Doe' })
  @IsString()
  lastName: string;

  @ApiProperty({ example: '+1234567890', required: false })
  @IsOptional()
  @IsString()
  phone?: string;
}
```

#### TypeORM Entity
```typescript
import { Entity, PrimaryGeneratedColumn, Column, CreateDateColumn, UpdateDateColumn } from 'typeorm';

@Entity('users')
export class User {
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @Column({ unique: true })
  email: string;

  @Column({ select: false })
  password: string;

  @Column({ name: 'first_name' })
  firstName: string;

  @Column({ name: 'last_name' })
  lastName: string;

  @Column({ name: 'is_master', default: false })
  isMaster: boolean;

  @CreateDateColumn({ name: 'created_at' })
  createdAt: Date;

  @UpdateDateColumn({ name: 'updated_at' })
  updatedAt: Date;
}
```

### 3. Git Workflow

#### Branch Naming
```bash
# Feature branches
feature/add-post-likes
feature/implement-chat-websocket

# Bug fixes
fix/websocket-reconnection
fix/feed-scroll-bug

# Documentation
docs/update-api-spec
docs/add-setup-guide

# Tests
test/add-user-service-tests

# Refactoring
refactor/extract-auth-service
```

#### Commit Messages (Conventional Commits)
```bash
# Format
<type>(<scope>): <subject>

<body>

<footer>

# Examples
feat(feed): add infinite scroll to feed screen

- Implement pagination with offset/limit
- Add loading indicator at bottom
- Cache fetched posts in Riverpod

fix(websocket): handle reconnection on network loss

- Add exponential backoff for reconnection
- Persist undelivered messages in local storage
- Fixes #123

docs(api): update API.md with new endpoints

- Add documentation for POST /posts/:id/like
- Add WebSocket events section
```

#### Commit Types
- `feat`: Новая фича
- `fix`: Багфикс
- `docs`: Изменения в документации
- `style`: Форматирование (не влияет на код)
- `refactor`: Рефакторинг
- `test`: Добавление тестов
- `chore`: Изменения в build process, dependencies
- `perf`: Улучшение производительности

### 4. Тестирование

#### Flutter Tests
```dart
// Unit Test
void main() {
  group('UserNotifier', () {
    late UserNotifier notifier;
    late MockUserRepository mockRepo;

    setUp(() {
      mockRepo = MockUserRepository();
      notifier = UserNotifier(mockRepo);
    });

    test('loadUser should update state with user data', () async {
      final user = UserModel(id: '1', email: 'test@test.com');
      when(mockRepo.getUserById('1')).thenAnswer((_) async => user);

      await notifier.loadUser('1');

      expect(notifier.state.value, equals(user));
    });
  });
}

// Widget Test
testWidgets('UserCard should display user info', (tester) async {
  final user = UserModel(id: '1', firstName: 'John', lastName: 'Doe');

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        userProvider.overrideWith((ref) => user),
      ],
      child: MaterialApp(
        home: UserCard(userId: '1'),
      ),
    ),
  );

  expect(find.text('John Doe'), findsOneWidget);
});
```

#### Backend Tests
```typescript
// Unit Test
describe('UserService', () => {
  let service: UserService;
  let mockRepo: jest.Mocked<UserRepository>;

  beforeEach(async () => {
    const module = await Test.createTestingModule({
      providers: [
        UserService,
        {
          provide: UserRepository,
          useValue: {
            findById: jest.fn(),
          },
        },
      ],
    }).compile();

    service = module.get<UserService>(UserService);
    mockRepo = module.get(UserRepository);
  });

  it('should return user if found', async () => {
    const user = { id: '1', email: 'test@test.com' };
    mockRepo.findById.mockResolvedValue(user);

    const result = await service.findById('1');

    expect(result).toEqual(user);
  });

  it('should throw NotFoundException if user not found', async () => {
    mockRepo.findById.mockResolvedValue(null);

    await expect(service.findById('1')).rejects.toThrow(NotFoundException);
  });
});

// E2E Test
describe('UserController (e2e)', () => {
  let app: INestApplication;

  beforeAll(async () => {
    const moduleFixture = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();
  });

  it('/users/:id (GET)', () => {
    return request(app.getHttpServer())
      .get('/users/1')
      .expect(200)
      .expect((res) => {
        expect(res.body).toHaveProperty('id');
        expect(res.body).toHaveProperty('email');
      });
  });
});
```

---

## 📚 Ключевые документы

### Бизнес-документация
- **[BRD.md](docs/business/BRD.md)** - Бизнес-требования, миссия, монетизация
- **[UserStories.md](docs/business/UserStories.md)** - 70 user stories в 10 эпиках
- **[Catalog.md](docs/business/Catalog.md)** - Каталог услуг (10 категорий, 340+ услуг)

### Техническая документация
- **[TechSpec.md](docs/technical/TechSpec.md)** - Техническое задание
- **[Database.md](docs/technical/Database-v2.md)** - Схема БД v2.0 (29 таблиц)
- **[API.md](docs/technical/API-v2-Summary.md)** - API v2.0 (165 endpoints)
- **[DevSetup.md](docs/technical/DevSetup.md)** - Настройка окружения

### Дизайн-документация
- **[BrandBook.md](docs/design/BrandBook.md)** - Фирменный стиль, цвета, типографика
- **[UXUI-Guide-v2.md](docs/design/UXUI-Guide-v2.md)** - UX/UI v2.0 (30+ экранов)

### Аналитика
- **[Risks.md](docs/analysis/Risks.md)** - Риски и митигация
- **[Roadmap.md](docs/analysis/Roadmap.md)** - Дорожная карта (MVP → v2.0)
- **[Requirements.md](docs/analysis/Requirements.md)** - 119 требований

---

## 🚀 Запуск проекта

### Frontend (Flutter)

```bash
# Клонирование репозитория
git clone https://github.com/Midasfallen/masters.git
cd masters/frontend

# Установка зависимостей
flutter pub get

# Генерация кода (Freezed, JSON Serializable, Riverpod)
flutter pub run build_runner build --delete-conflicting-outputs

# Запуск приложения
flutter run

# Запуск тестов
flutter test

# Анализ кода
flutter analyze

# Форматирование
dart format lib/
```

### Backend (NestJS)

```bash
cd backend

# Установка зависимостей
npm install

# Настройка окружения
cp .env.example .env

# Миграции
npm run migration:run

# Seed database
npm run seed

# Запуск dev сервера
npm run start:dev

# Запуск тестов
npm run test              # Unit тесты (129 тестов)
npm run test:cov          # С покрытием (27.38%)
npm run test:e2e          # E2E тесты

# Линтинг
npm run lint

# Проверка покрытия тестами
npm run test:cov -- --coverage
```

### Docker Compose (для локальной разработки)

```bash
# Запуск всех сервисов
docker-compose up -d

# Просмотр логов
docker-compose logs -f

# Остановка
docker-compose down
```

---

## ⚠️ Важные моменты при работе

### 1. Всегда используй Freezed для моделей
```dart
// ✅ Правильно
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    required String id,
    required String email,
  }) = _UserModel;

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

// ❌ Неправильно
class UserModel {
  final String id;
  final String email;

  UserModel({required this.id, required this.email});
}
```

### 2. Используй Riverpod для state management
```dart
// ✅ Правильно - Riverpod
final userProvider = StateNotifierProvider<UserNotifier, AsyncValue<UserModel>>((ref) {
  return UserNotifier(ref.read(userRepositoryProvider));
});

// ❌ Неправильно - StatefulWidget для сложного состояния
class UserScreen extends StatefulWidget {
  // Избегай для сложной бизнес-логики
}
```

### 3. Следуй naming conventions для snake_case в JSON
```dart
// ✅ Правильно
@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
  }) = _UserModel;
}

// ❌ Неправильно
const factory UserModel({
  required String first_name,  // Dart использует camelCase
  required String last_name,
}) = _UserModel;
```

### 4. Всегда обрабатывай ошибки
```dart
// ✅ Правильно
Future<void> loadUser(String id) async {
  state = const AsyncValue.loading();
  state = await AsyncValue.guard(() async {
    final user = await repository.getUserById(id);
    return user;
  });
}

// Usage
userAsync.when(
  data: (user) => Text(user.name),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => ErrorWidget(error: error),
);

// ❌ Неправильно - без обработки ошибок
Future<void> loadUser(String id) async {
  final user = await repository.getUserById(id);
  state = user; // Что если ошибка?
}
```

### 5. Используй const конструкторы где возможно
```dart
// ✅ Правильно
const UserCard({super.key, required this.user});

const SizedBox(height: 16);

const Text('Hello');

// ❌ Неправильно
UserCard({Key? key, required this.user}) : super(key: key);

SizedBox(height: 16);

Text('Hello');
```

### 6. Группируй imports правильно
```dart
// ✅ Правильно
// 1. Dart SDK
import 'dart:async';

// 2. Flutter
import 'package:flutter/material.dart';

// 3. Packages
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 4. Project imports
import '../../core/models/user_model.dart';
import '../widgets/user_card.dart';

// ❌ Неправильно - случайный порядок
import '../widgets/user_card.dart';
import 'package:flutter/material.dart';
import '../../core/models/user_model.dart';
```

### 7. Backend - используй DTO для валидации
```typescript
// ✅ Правильно
export class CreateUserDto {
  @IsEmail()
  email: string;

  @IsString()
  @MinLength(8)
  password: string;
}

// ❌ Неправильно - без валидации
export class CreateUserDto {
  email: string;
  password: string;
}
```

### 8. Backend - используй Guards для авторизации
```typescript
// ✅ Правильно
@UseGuards(JwtAuthGuard, RolesGuard)
@Roles('master')
@Post('services')
async createService(@Body() dto: CreateServiceDto) {
  return this.servicesService.create(dto);
}

// ❌ Неправильно - проверка внутри метода
@Post('services')
async createService(@Body() dto: CreateServiceDto, @Headers('authorization') token: string) {
  if (!token) throw new UnauthorizedException();
  // проверка роли вручную...
}
```

---

## 🔍 Чеклист перед commit

### Frontend (Flutter)
- [ ] `flutter analyze` проходит без ошибок
- [ ] `flutter test` - все тесты проходят
- [ ] Код отформатирован: `dart format lib/`
- [ ] Все Freezed модели сгенерированы
- [ ] Все imports отсортированы правильно
- [ ] Используются const конструкторы где возможно
- [ ] Ошибки обрабатываются через AsyncValue
- [ ] Нет хардкода строк (используй локализацию)
- [ ] Нет magic numbers (используй константы)

### Backend (NestJS)
- [ ] `npm run lint` проходит без ошибок
- [ ] `npm run test` - все тесты проходят
- [ ] Все DTO имеют валидацию
- [ ] Guards используются для авторизации
- [ ] Swagger документация обновлена
- [ ] TypeORM entities синхронизированы с БД
- [ ] Ошибки обрабатываются через NestJS exceptions
- [ ] Логирование добавлено для критичных операций

### Общее
- [ ] Commit message следует Conventional Commits
- [ ] Документация обновлена (если нужно)
- [ ] Нет TODO комментариев в коде
- [ ] Нет закомментированного кода
- [ ] Нет console.log / print statements

---

## 🎯 Приоритеты разработки

### ✅ ФАЗА 0: Подготовка (ЗАВЕРШЕНО - 25/25 очков)
- ✅ Инициализация проекта (Git, структура)
- ✅ Настройка окружения (Docker Compose)
- ✅ TypeORM конфигурация
- ✅ База данных (29 таблиц)
- ✅ Seed данные

### ✅ ФАЗА 1: Backend Core Modules (ЗАВЕРШЕНО - 120/120 очков)
1. ✅ **Auth Module** - JWT, refresh tokens, forgot/reset password
2. ✅ **Users Module** - CRUD, profile management, statistics
3. ✅ **Masters Module** - Profile creation, services, reviews
4. ✅ **Categories Module** - Service categories и translations
5. ✅ **Services Module** - Service management для мастеров
6. ✅ **Bookings Module** - Система бронирования
7. ✅ **Reviews Module** - Отзывы и рейтинг
8. ✅ **Search Module** - Поиск мастеров и услуг

### ✅ ФАЗА 2: Social & Real-time (ЗАВЕРШЕНО - 80/80 очков)
1. ✅ **Posts Module** - Feed, likes, comments, reposts
2. ✅ **Friends Module** - Двусторонние связи
3. ✅ **Subscriptions Module** - Односторонние подписки
4. ✅ **WebSocket Gateway** - Socket.IO + Redis Pub/Sub
5. ✅ **Real-time Integration** - Chats, Notifications, Social events
6. ✅ **Backend Testing** - 129 unit тестов, 27.38% покрытие

### 🔄 ФАЗА 3: Frontend Integration (СЛЕДУЮЩАЯ - 0/100 очков)
1. ⏳ **API Integration** - Dio клиент, interceptors
2. ⏳ **Auth Flow** - Login, Register, Forgot Password
3. ⏳ **Feed Screen** - 3-колоночная сетка контента
4. ⏳ **Post Detail Screen** - Полноэкранный просмотр
5. ⏳ **Chats Integration** - WebSocket клиент
6. ⏳ **Friends & Subscriptions** - Social features
7. ⏳ **Notifications** - Real-time уведомления
8. ⏳ **Master Profile Creation** - 5-шаговый флоу

### ⏳ ФАЗА 4: Advanced Features (0/85 очков)
1. ⏳ **Chats Module (Backend)** - 8 типов сообщений
2. ⏳ **Notifications Module (Backend)** - 11 типов, FCM/APNs
3. ⏳ **Auto Proposals** - ML/эвристики подбора мастеров
4. ⏳ **Media Upload** - MinIO интеграция
5. ⏳ **Full-text Search** - Meilisearch интеграция
6. ⏳ **Geolocation** - PostGIS интеграция
7. ⏳ **Premium Features** - Подписка, премиум функции

### ⏳ ФАЗА 5: Production Ready (0/75 очков)
1. ⏳ **Admin Module** - Админ-панель
2. ⏳ **E2E Testing** - Полное покрытие
3. ⏳ **Performance Optimization** - Кеширование, индексы
4. ⏳ **Security Audit** - Проверка безопасности
5. ⏳ **CI/CD Pipeline** - Автоматизация деплоя
6. ⏳ **Monitoring** - Logging, metrics, alerts
7. ⏳ **Documentation** - API docs, deployment guide

---

## 📞 Ресурсы и контакты

### GitHub
- **Репозиторий:** https://github.com/Midasfallen/masters
- **Issues:** https://github.com/Midasfallen/masters/issues
- **Pull Requests:** https://github.com/Midasfallen/masters/pulls

### Другие проекты пользователя
- **vpn** - Flutter VPN приложение (production-ready)
- **vpn-api** - FastAPI backend для VPN
- **nefors** - Flutter template

### Документация
- Flutter: https://docs.flutter.dev
- Riverpod: https://riverpod.dev
- NestJS: https://docs.nestjs.com
- TypeORM: https://typeorm.io

---

## 🔄 Changelog

### v2.2 (12 января 2026)
- ✅ Обновлен раздел "Текущий статус" с прогрессом MVP (63%)
- ✅ Отражено завершение Week 8 (Auth + User Profile Integration)
- ✅ Отражено завершение Week 9 (Feed + Posts Integration)
- ✅ Добавлена информация о Dio HTTP Client с 4 interceptors
- ✅ Добавлена информация о Frontend интеграциях (Auth, Profile, Feed, Posts, Comments)
- ✅ ФАЗА 3: Frontend Integration теперь 80% завершена (80/100 очков)
- ✅ Добавлены 19 новых API endpoints v2.0 (Friends, Subscriptions, Auto Proposals)
- ✅ Добавлена информация о Infinite scroll и Pull-to-refresh

### v2.1 (11 января 2026)
- ✅ Обновлен раздел "Текущий статус" с прогрессом MVP (46%)
- ✅ Отражено завершение ФАЗА 2 (Social & Real-time)
- ✅ Добавлена информация о WebSocket Gateway
- ✅ Добавлена информация о 129 unit тестах (27.38% покрытие)
- ✅ Обновлены приоритеты разработки с детальным разбивкой фаз
- ✅ Изменен статус backend с "в планах" на "активная разработка"
- ✅ Добавлена информация о реализованных модулях

### v2.0 (9 января 2026)
- Создан CLAUDE.MD с полными инструкциями
- Описаны все паттерны и best practices проекта
- Добавлены примеры кода для Flutter и NestJS
- Документированы правила разработки и тестирования

---

**Последнее обновление:** 12 января 2026
**Версия:** 2.2
**Автор:** Claude (по запросу пользователя)
