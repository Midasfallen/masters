# TEST PLAN - Платформа Service

**Версия:** 2.0
**Дата:** Декабрь 2025

---

## Обзор v2.0

Тестовый план расширен для покрытия **социальной платформы** с real-time функциями.

**Новые области тестирования v2.0:**
- 📱 Feed с алгоритмом ранжирования (производительность, персонализация)
- 💬 WebSocket чаты с real-time доставкой (8 типов сообщений)
- ❤️ Социальные взаимодействия (лайки, комментарии, репосты)
- 👥 Друзья и подписки (двусторонние/односторонние связи)
- 🔔 Система уведомлений (11 типов, FCM/APNs)
- 🤖 Автопредложения мастеров (алгоритм Match %)
- ⭐ Обязательные отзывы с блокировкой

**Увеличение тест-кейсов:** 50 базовых (v1.0) + 80 новых (v2.0) = **130 тест-кейсов**

---

## 1. Цели тестирования

### 1.1 Основные цели
- Обеспечить качество продукта перед запуском v2.0
- Верифицировать все функциональные требования (v1.0 + v2.0)
- Гарантировать производительность Feed и WebSocket под нагрузкой
- Протестировать real-time функции на стабильность
- Минимизировать критические баги в production

### 1.2 Целевые метрики качества v2.0

| Метрика | Цель v2.0 | Метод измерения |
|---------|-----------|-----------------|
| **Backend Test Coverage** | > 85% | Jest coverage report |
| **Critical Paths Coverage** | 100% | Manual tracking |
| **Flutter Test Coverage** | > 75% | Flutter test coverage |
| **E2E Tests** | 18+ scenarios | Automated E2E suite |
| **Critical Bugs** | 0 | Bug tracking |
| **Major Bugs** | < 3 | Bug tracking |
| **API Response Time** | < 200ms (p95) | Load testing |
| **Feed Load Time** | < 200ms (p95) | Performance monitoring |
| **WebSocket Latency** | < 100ms (p95) | Real-time monitoring |
| **WebSocket Uptime** | > 99.5% | Monitoring |
| **Message Delivery Rate** | > 99.9% | Message tracking |
| **UI Performance** | 60 FPS | Profiling |
| **Feed Scroll FPS** | > 55 FPS | Performance profiling |

---

## 2. Уровни тестирования

### 2.1 Unit Testing (Backend)

**Технологии:** Jest + Supertest
**Цель:** > 80% code coverage

#### Модули для тестирования:

**Auth Module:**
- ✅ Регистрация пользователя (валидация, хэширование пароля)
- ✅ Вход (проверка credentials, генерация JWT)
- ✅ OAuth flow (Google, Apple)
- ✅ Refresh token mechanism
- ✅ Password reset flow
- ✅ Email/Phone verification

**Users Module:**
- ✅ CRUD операции для пользователей
- ✅ Обновление профиля
- ✅ Геолокация (валидация координат)
- ✅ Settings management

**Masters Module:**
- ✅ Создание профиля мастера
- ✅ Обновление профиля
- ✅ Валидация радиуса выезда
- ✅ Currency validation

**Search Module:**
- ✅ Гео-поиск (PostGIS queries)
- ✅ Текстовый поиск (Meilisearch)
- ✅ Фильтрация и сортировка
- ✅ Pagination

**Booking Module:**
- ✅ Создание записи
- ✅ Расчет доступных слотов
- ✅ Валидация времени записи
- ✅ Статусы записи (state machine)
- ✅ Cancellation logic

**Content Module:**
- ✅ Создание постов
- ✅ Upload медиафайлов
- ✅ Валидация видео (длительность, размер)
- ✅ Лента (алгоритм рекомендаций)

**Chat Module:**
- ✅ Создание чатов
- ✅ Отправка сообщений
- ✅ Privacy rules (контакты скрыты до подтверждения)

**Reviews Module:**
- ✅ Создание отзывов
- ✅ Расчет рейтинга
- ✅ Валидация (только после completed booking)

**Premium Module:**
- ✅ Subscription management
- ✅ Feature access control

**Admin Module:**
- ✅ User management (ban/unban)
- ✅ Content moderation
- ✅ Dashboard stats calculation

**Posts/Feed Module (v2.0):**
- ✅ Создание постов с медиафайлами
- ✅ Валидация лимитов (макс 10 фото, 3 видео)
- ✅ Алгоритм ранжирования Feed
- ✅ Персонализация Feed по геолокации
- ✅ Кэширование Feed в Redis
- ✅ Упоминания (@mentions)
- ✅ Теги услуг в постах

**Likes Module (v2.0):**
- ✅ Лайк/анлайк постов
- ✅ Подсчет лайков
- ✅ Проверка дублей (один лайк на пост)
- ✅ Уведомления о лайках

**Comments Module (v2.0):**
- ✅ Создание комментариев
- ✅ Вложенные комментарии (replies)
- ✅ Упоминания в комментариях
- ✅ Удаление комментариев
- ✅ Подсчет комментариев

**Friends/Subscriptions Module (v2.0):**
- ✅ Отправка запроса в друзья
- ✅ Принятие/отклонение запроса
- ✅ Двусторонняя связь друзей
- ✅ Подписки (односторонние)
- ✅ Отписка
- ✅ Блокировка пользователей

**Real-time Chat Module (v2.0):**
- ✅ WebSocket подключение и авторизация
- ✅ Отправка 8 типов сообщений
- ✅ Доставка сообщений (sent → delivered → read)
- ✅ Typing indicator
- ✅ Online/offline статусы
- ✅ Redis Pub/Sub для масштабирования
- ✅ Reconnection logic

**Notifications Module (v2.0):**
- ✅ Создание 11 типов уведомлений
- ✅ Приоритизация (важные vs обычные)
- ✅ Батчинг неважных уведомлений
- ✅ Отправка через FCM/APNs
- ✅ Fallback chain (WebSocket → Push → Email)
- ✅ Дедупликация
- ✅ Настройки уведомлений пользователя

**Auto Proposals Module (v2.0):**
- ✅ Алгоритм Match % (категория, гео, цена, рейтинг)
- ✅ Генерация предложений для клиента
- ✅ Принятие/отклонение предложений
- ✅ Feedback loop для улучшения алгоритма
- ✅ Премиум-подписка проверка

**Favorites Module (v2.0):**
- ✅ Добавление в избранное
- ✅ Удаление из избранного
- ✅ Список избранных мастеров
- ✅ Уведомления об избранных мастерах

#### Примеры Unit Tests:

```typescript
// auth.service.spec.ts
describe('AuthService', () => {
  describe('register', () => {
    it('should hash password before saving', async () => {
      const user = await authService.register({
        email: 'test@example.com',
        password: 'password123'
      });
      expect(user.password_hash).not.toBe('password123');
      expect(await bcrypt.compare('password123', user.password_hash)).toBe(true);
    });

    it('should throw error if email already exists', async () => {
      await expect(
        authService.register({ email: 'existing@example.com', password: '123' })
      ).rejects.toThrow('EMAIL_ALREADY_EXISTS');
    });
  });
});

// booking.service.spec.ts
describe('BookingService', () => {
  it('should not allow booking outside master working hours', async () => {
    await expect(
      bookingService.create({
        master_id: 'uuid',
        start_time: '2026-01-15T02:00:00Z'  // 2 AM
      })
    ).rejects.toThrow('SLOT_NOT_AVAILABLE');
  });

  it('should calculate available slots correctly', async () => {
    const slots = await bookingService.getAvailableSlots({
      master_id: 'uuid',
      date: '2026-01-15',
      service_id: 'uuid'  // 30 min service
    });
    expect(slots).toEqual([
      { start: '09:00', end: '09:30', available: true },
      { start: '09:30', end: '10:00', available: false },  // booked
      // ...
    ]);
  });
});

// feed.service.spec.ts (v2.0)
describe('FeedService', () => {
  describe('calculateFeedScore', () => {
    it('should rank posts by algorithm correctly', () => {
      const score = feedService.calculateScore({
        post_created_at: new Date('2026-01-15T10:00:00Z'),
        user_city: 'Moscow',
        master_city: 'Moscow',
        likes_count: 50,
        comments_count: 10,
        is_subscribed: true,
        user_interests: ['beauty', 'nails'],
        post_categories: ['nails']
      });

      // Score = 0.4*geo + 0.25*freshness + 0.2*popularity + 0.1*subscription + 0.05*category
      expect(score).toBeGreaterThan(0.7);
    });
  });

  describe('getFeed', () => {
    it('should return cached feed if available', async () => {
      const userId = 'user-123';
      await redisClient.set(`feed:${userId}`, JSON.stringify(mockFeed));

      const feed = await feedService.getFeed(userId, { page: 1, limit: 20 });

      expect(feed).toEqual(mockFeed);
      expect(redisClient.get).toHaveBeenCalledWith(`feed:${userId}`);
    });
  });
});

// websocket.service.spec.ts (v2.0)
describe('WebSocketService', () => {
  it('should deliver message with status tracking', async () => {
    const message = await websocketService.sendMessage({
      chat_id: 'chat-uuid',
      sender_id: 'user-1',
      type: 'text',
      content: 'Hello!'
    });

    expect(message.status).toBe('sent');

    // Simulate delivery
    await websocketService.markAsDelivered(message.id);
    const updated = await messageRepo.findOne(message.id);

    expect(updated.status).toBe('delivered');
    expect(updated.delivered_at).toBeDefined();
  });

  it('should send typing indicator to room', async () => {
    const spy = jest.spyOn(socketServer.to('chat-uuid'), 'emit');

    await websocketService.sendTypingIndicator({
      chat_id: 'chat-uuid',
      user_id: 'user-1',
      is_typing: true
    });

    expect(spy).toHaveBeenCalledWith('typing:start', {
      chat_id: 'chat-uuid',
      user_id: 'user-1'
    });
  });
});

// notifications.service.spec.ts (v2.0)
describe('NotificationsService', () => {
  it('should batch non-urgent notifications', async () => {
    // Create 5 non-urgent notifications
    for (let i = 0; i < 5; i++) {
      await notificationService.create({
        user_id: 'user-1',
        type: 'like',
        priority: 'normal'
      });
    }

    // Should not send immediately
    expect(fcmService.send).not.toHaveBeenCalled();

    // After 1 hour, should batch and send
    jest.advanceTimersByTime(60 * 60 * 1000);

    expect(fcmService.send).toHaveBeenCalledTimes(1);
    expect(fcmService.send).toHaveBeenCalledWith({
      title: 'You have 5 new notifications',
      body: '...'
    });
  });
});
```

---

### 2.2 Unit Testing (Frontend)

**Технологии:** Flutter Test
**Цель:** > 70% code coverage

#### Тестируемые компоненты:

**Providers (Riverpod):**
- ✅ Auth state management
- ✅ User profile state
- ✅ Booking state
- ✅ Search filters state
- ✅ Chat state

**Models:**
- ✅ JSON serialization/deserialization
- ✅ Data validation
- ✅ Freezed equality

**Services:**
- ✅ API client (mocked responses)
- ✅ Local storage
- ✅ WebSocket connection

**Utilities:**
- ✅ Date/time formatting
- ✅ Distance calculation
- ✅ Price formatting

#### Примеры Widget Tests:

```dart
// login_screen_test.dart
testWidgets('Login button should be disabled with invalid email', (tester) async {
  await tester.pumpWidget(MyApp());
  await tester.enterText(find.byKey(Key('email_field')), 'invalid-email');
  await tester.enterText(find.byKey(Key('password_field')), 'password123');

  expect(find.byType(ElevatedButton), findsOneWidget);
  expect(tester.widget<ElevatedButton>(find.byType(ElevatedButton)).enabled, false);
});

// master_card_test.dart
testWidgets('Master card should display rating and distance', (tester) async {
  final master = Master(id: '1', name: 'John', rating: 4.8, distance: 2.5);
  await tester.pumpWidget(MasterCard(master: master));

  expect(find.text('4.8'), findsOneWidget);
  expect(find.text('2.5 km'), findsOneWidget);
});
```

---

### 2.3 Integration Testing

**Backend Integration Tests:**

Тестируют взаимодействие модулей и работу с реальной БД (test database).

```typescript
// booking.integration.spec.ts
describe('Booking Integration', () => {
  it('should create booking and send notification', async () => {
    const booking = await request(app)
      .post('/api/v1/bookings')
      .set('Authorization', `Bearer ${clientToken}`)
      .send({
        master_id: masterId,
        service_id: serviceId,
        start_time: '2026-01-15T10:00:00Z'
      })
      .expect(201);

    // Check notification was sent
    const notifications = await notificationRepo.find({ user_id: masterId });
    expect(notifications).toHaveLength(1);
    expect(notifications[0].type).toBe('new_booking');
  });
});
```

**Flutter Integration Tests:**

```dart
// integration_test/booking_flow_test.dart
testWidgets('Complete booking flow', (tester) async {
  app.main();
  await tester.pumpAndSettle();

  // Login
  await tester.tap(find.byKey(Key('login_button')));
  await tester.pumpAndSettle();

  // Search master
  await tester.enterText(find.byKey(Key('search_field')), 'Barber');
  await tester.tap(find.byKey(Key('search_button')));
  await tester.pumpAndSettle();

  // Select first master
  await tester.tap(find.byType(MasterCard).first);
  await tester.pumpAndSettle();

  // Book service
  await tester.tap(find.text('Mens Haircut'));
  await tester.tap(find.text('Book'));
  await tester.pumpAndSettle();

  // Verify success
  expect(find.text('Booking created'), findsOneWidget);
});
```

---

### 2.4 End-to-End Testing

**Технологии:** Playwright / Cypress (Web), Flutter Driver (Mobile)
**Цель:** 10+ critical scenarios

#### E2E Test Scenarios:

**Scenario 1: User Registration & Onboarding**
1. Open app
2. Click "Sign Up"
3. Enter email, password
4. Verify email (mock)
5. Complete profile
6. Allow location access
7. See home screen

**Scenario 2: Search & Book Master**
1. Login as client
2. Search "barber" near location
3. Apply filters (price, rating)
4. View master profile
5. Select service
6. Choose time slot
7. Create booking
8. Verify booking in "My Bookings"

**Scenario 3: Master Profile Setup**
1. Login as new master
2. Create master profile
3. Add services with prices
4. Set working hours
5. Upload portfolio photo
6. Publish profile
7. Verify profile is searchable

**Scenario 4: Complete Booking Lifecycle**
1. Client creates booking
2. Master receives notification
3. Master confirms booking
4. Booking appears as "confirmed"
5. Master completes service
6. Client leaves review
7. Review appears on master profile

**Scenario 5: Chat Communication**
1. Client views master profile
2. Click "Message"
3. Send text message
4. Master receives real-time notification
5. Master replies
6. Client sees message in real-time

**Scenario 6: Premium Subscription**
1. Client views premium page
2. Select subscription plan
3. Complete payment (test mode)
4. Verify premium status active
5. Check "no ads" feature works

**Scenario 7: Admin Moderation**
1. Login as admin
2. View dashboard stats
3. Navigate to "Pending Posts"
4. Review post
5. Approve post
6. Verify post visible to users

**Scenario 8: Cancellation Flow**
1. Client has confirmed booking
2. Cancel booking
3. Verify cancellation email sent
4. Check booking status = "cancelled"
5. Verify slot becomes available

**Scenario 9: No-Show Handling**
1. Client misses appointment
2. Master marks as "no-show"
3. Verify counter incremented
4. Check if blacklist triggered (after 3 no-shows)

**Scenario 10: Multi-language Support**
1. Open app in English
2. Change language to Russian
3. Verify UI translated
4. Verify categories translated
5. Search works in Russian

**Scenario 11: Feed Scrolling & Liking (v2.0)**
1. Login as client
2. Open Feed (main screen)
3. Scroll through posts
4. Like a post
5. Verify like count increased
6. Unlike the post
7. Verify like count decreased
8. Tap on post to view details
9. Leave comment
10. Verify comment appears

**Scenario 12: Friends Request Flow (v2.0)**
1. Login as User A
2. Search for User B
3. Send friend request
4. Logout
5. Login as User B
6. See friend request notification
7. Accept friend request
8. Verify friendship status = "friends"
9. Check User A's friend list
10. Verify User B appears as friend

**Scenario 13: Real-time Chat (v2.0)**
1. Login as Client (Device 1)
2. Login as Master (Device 2)
3. Client opens chat with Master
4. Client sends text message
5. Verify Master receives message in real-time
6. Master starts typing
7. Verify Client sees "typing..." indicator
8. Master sends image message
9. Verify Client sees image
10. Check message statuses: sent → delivered → read

**Scenario 14: Mandatory Review Blocking (v2.0)**
1. Client has completed booking
2. Try to create new booking
3. Verify blocked with "Leave review first" message
4. Leave review for completed booking
5. Try to create new booking again
6. Verify booking created successfully

**Scenario 15: Auto Proposals (v2.0)**
1. Client subscribes to Premium
2. Enable auto-proposals in settings
3. System generates 3 proposals
4. Client receives notification
5. View proposals list
6. Accept one proposal
7. Verify booking created with accepted master
8. Decline another proposal
9. Verify proposal removed from list

**Scenario 16: Feed → Booking Conversion (v2.0)**
1. Client scrolls Feed
2. Sees master's post with great work
3. Taps "Book" button on post
4. Select service
5. Choose time slot
6. Complete booking
7. Verify booking created
8. Verify master receives notification

**Scenario 17: Notifications Settings (v2.0)**
1. Open Settings
2. Navigate to Notifications
3. Disable "Likes" notifications
4. Someone likes user's post
5. Verify NO push notification sent
6. Enable "Messages" notifications
7. Receive new message
8. Verify push notification sent

**Scenario 18: Post Creation with Media (v2.0)**
1. Login as Master
2. Tap "Create Post"
3. Upload 5 photos
4. Add description
5. Tag 2 services
6. Mention another master
7. Publish post
8. Verify post appears in Feed
9. Verify mentioned user receives notification

---

## 3. Нефункциональное тестирование

### 3.1 Performance Testing

**Tools:** Artillery, k6, Lighthouse

**Load Test Scenarios:**

| Scenario | Virtual Users | Duration | Target RPS | Success Criteria |
|----------|--------------|----------|------------|------------------|
| **Baseline** | 100 | 5 min | 50 | < 200ms (p95), 0 errors |
| **Normal Load** | 500 | 10 min | 100 | < 200ms (p95), < 1% errors |
| **Peak Load** | 1000 | 5 min | 200 | < 300ms (p95), < 2% errors |
| **Stress Test** | 2000 | 3 min | 300+ | Identify breaking point |

**Key Endpoints to Test:**
- `GET /posts/feed` - Most frequent (v2.0, critical performance)
- `GET /search/masters` - Frequent
- `POST /bookings` - Critical path
- `POST /posts/:id/like` - High volume (v2.0)
- `POST /posts/:id/comments` - Moderate volume (v2.0)
- `WebSocket /ws` - Concurrent connections (v2.0, stress test)

**WebSocket Load Testing (v2.0):**

| Scenario | Connections | Duration | Messages/sec | Success Criteria |
|----------|-------------|----------|--------------|------------------|
| **Baseline** | 1,000 | 10 min | 50 | < 100ms latency, 0 drops |
| **Normal** | 5,000 | 15 min | 200 | < 150ms latency, < 0.1% drops |
| **Peak** | 10,000 | 10 min | 500 | < 200ms latency, < 1% drops |
| **Stress** | 20,000 | 5 min | 1000+ | Identify breaking point |

**Feed Performance Testing (v2.0):**

| Test | Target | Tools | Success Criteria |
|------|--------|-------|------------------|
| **Algorithm Speed** | Score calculation | Benchmarks | < 50ms per post |
| **Feed Load** | GET /posts/feed | k6 | < 200ms (p95) |
| **Cache Hit Rate** | Redis cache | Monitoring | > 80% hits |
| **DB Query Time** | PostgreSQL | Explain Analyze | < 100ms |
| **Scroll Performance** | Infinite scroll | Flutter DevTools | > 55 FPS |

**Frontend Performance:**
- Lighthouse score > 90
- FPS > 60 during scrolling
- Time to Interactive < 3s
- First Contentful Paint < 1.5s

### 3.2 Security Testing

**OWASP Top 10 Checks:**

✅ **SQL Injection**
- Test всех endpoints с SQL payloads
- Verify prepared statements используются

✅ **XSS (Cross-Site Scripting)**
- Test input fields с `<script>` tags
- Verify sanitization работает

✅ **Authentication Bypass**
- Attempt to access protected routes without token
- Test token expiration
- Test refresh token rotation

✅ **Authorization Flaws**
- Test client accessing master-only endpoints
- Test user accessing another user's data
- Test admin-only endpoints

✅ **Rate Limiting**
- Verify 100 req/min limit enforced
- Test DDoS protection

✅ **Sensitive Data Exposure**
- Verify passwords never returned in responses
- Check contact info hidden until booking confirmed
- Test HTTPS enforcement

**Security Test Cases:**

```bash
# Test SQL Injection
curl -X POST /api/v1/auth/login \
  -d '{"email": "admin@example.com'\'' OR 1=1--", "password": "any"}'
# Expected: 401 Unauthorized, not success

# Test XSS
curl -X PATCH /api/v1/users/me \
  -H "Authorization: Bearer $TOKEN" \
  -d '{"first_name": "<script>alert(1)</script>"}'
# Expected: Sanitized or rejected

# Test Authorization
curl -X GET /api/v1/admin/dashboard \
  -H "Authorization: Bearer $CLIENT_TOKEN"
# Expected: 403 Forbidden
```

### 3.3 Compatibility Testing

**Mobile:**
- iOS 13, 14, 15, 16 (devices: iPhone 8, X, 12, 13, 14)
- Android 8, 9, 10, 11, 12, 13 (devices: Samsung, Pixel, OnePlus)

**Web Browsers:**
- Chrome 100+
- Safari 14+
- Firefox 88+
- Edge 90+

**Screen Sizes:**
- Mobile: 320px - 428px
- Tablet: 768px - 1024px
- Desktop: 1280px - 1920px

### 3.4 Accessibility Testing

**WCAG 2.1 Level AA:**
- Keyboard navigation
- Screen reader support
- Color contrast ratios
- Text sizing
- Focus indicators

---

## 4. Test Execution Strategy

### 4.1 Continuous Testing (CI/CD)

**На каждый Pull Request:**
1. ✅ Lint checks (ESLint, Dart analyzer)
2. ✅ Unit tests (backend + frontend)
3. ✅ Integration tests
4. ✅ Test coverage report

**На каждый merge в main:**
1. ✅ Все тесты из PR
2. ✅ E2E tests (10 scenarios)
3. ✅ Security scans (Snyk, OWASP Dependency Check)
4. ✅ Performance regression tests

**Перед релизом (weekly):**
1. ✅ Full E2E suite
2. ✅ Load testing
3. ✅ Manual exploratory testing
4. ✅ Accessibility audit

### 4.2 Regression Testing

**После каждого спринта:**
- Повторный прогон всех critical path tests
- Verification новых фич не сломали старые

**Regression Suite:** 30+ automated tests covering core functionality

### 4.3 Exploratory Testing

**Еженедельно:** 2-4 часа ручного тестирования

**Focus Areas:**
- New features
- Edge cases
- UX issues
- Visual bugs

---

## 5. Test Environment

### 5.1 Environments

| Environment | Purpose | Data | Backend URL |
|-------------|---------|------|-------------|
| **Local** | Development | Мок данные | localhost:3000 |
| **Test** | Automated tests | Test DB (reset after tests) | test-api.service.local |
| **Staging** | Pre-production | Production-like data | staging-api.service.com |
| **Production** | Live | Real data | api.service.com |

### 5.2 Test Data Management

**Test Database:**
- Seed data для consistent tests
- Reset между test runs
- Factory pattern для создания test entities

```typescript
// factories/user.factory.ts
export const createTestUser = (overrides = {}) => ({
  id: uuid(),
  email: `test-${Date.now()}@example.com`,
  password_hash: await bcrypt.hash('password123', 10),
  first_name: 'Test',
  last_name: 'User',
  ...overrides
});

// In tests:
const user = await createTestUser({ email: 'specific@example.com' });
```

---

## 6. Bug Management

### 6.1 Bug Severity Levels

| Level | Definition | Example | Resolution Time |
|-------|------------|---------|-----------------|
| **Critical** | App crashes, data loss, security | Cannot login, DB corruption | < 24h |
| **High** | Feature не работает, нет workaround | Booking creation fails | < 48h |
| **Medium** | Feature работает с ограничениями | Search slow, некорректный UI | < 1 week |
| **Low** | Cosmetic, не влияет на функциональность | Typo, minor styling | Backlog |

### 6.2 Bug Tracking

**Tool:** GitHub Issues

**Bug Template:**
```markdown
## Description
[Clear description of the bug]

## Steps to Reproduce
1. Go to...
2. Click on...
3. See error

## Expected Behavior
[What should happen]

## Actual Behavior
[What actually happens]

## Environment
- Platform: iOS 15.4 / Android 12 / Web Chrome 100
- App Version: 1.0.0-beta.5

## Screenshots
[If applicable]

## Severity
Critical / High / Medium / Low
```

---

## 7. Acceptance Criteria (v2.0 Launch)

### 7.1 Functional Criteria

✅ **All Must-Have Features Working (v1.0 + v2.0):**
- [ ] 98/98 Must-have user stories completed
- [ ] All critical user flows tested and working
- [ ] No blockers for core functionality
- [ ] Feed algorithm working and personalized
- [ ] WebSocket real-time messaging stable
- [ ] Notifications delivered reliably

### 7.2 Quality Criteria

✅ **Test Coverage:**
- [ ] Backend coverage > 85%
- [ ] Frontend coverage > 75%
- [ ] 18+ E2E scenarios passing
- [ ] 130+ test cases executed

✅ **Bugs:**
- [ ] 0 critical bugs
- [ ] < 3 high severity bugs
- [ ] < 15 medium severity bugs
- [ ] Low bugs documented in backlog

✅ **Performance:**
- [ ] API p95 < 200ms
- [ ] Feed load < 200ms (p95)
- [ ] WebSocket latency < 100ms (p95)
- [ ] Message delivery rate > 99.9%
- [ ] Search < 100ms
- [ ] Frontend 60 FPS
- [ ] Feed scroll > 55 FPS
- [ ] Lighthouse score > 90

✅ **Security:**
- [ ] All OWASP Top 10 mitigated
- [ ] Security audit passed
- [ ] No HIGH vulnerabilities in dependencies
- [ ] WebSocket connections secured (JWT)
- [ ] Rate limiting on all endpoints

✅ **Compatibility:**
- [ ] Works on iOS 13+
- [ ] Works on Android 8+
- [ ] Works on Chrome, Safari, Firefox, Edge

✅ **Real-time (v2.0):**
- [ ] WebSocket uptime > 99.5%
- [ ] Message delivery < 1 sec
- [ ] Typing indicators working
- [ ] Online/offline status accurate
- [ ] Reconnection logic tested

---

## 8. Связанные документы

- [Requirements](../analysis/Requirements.md) - Требования v2.0
- [Technical Specification](../technical/TechSpec.md) - Техническая спецификация v2.0
- [API Specification](../technical/API.md) - API спецификация v2.0 (165 endpoints)
- [Database Schema](../technical/Database.md) - Схема БД v2.0 (29 таблиц)
- [User Stories](../business/UserStories.md) - User Stories v2.0 (148 историй)
- [Test Cases](./TestCases.md) - Детальные тест-кейсы v2.0
- [Roadmap](../analysis/Roadmap.md) - Дорожная карта v2.0

---

**Статус:** ✅ Утверждён (v2.0)
**Последнее обновление:** Декабрь 2025
**Следующий пересмотр:** Перед началом Phase 5 (Testing v2.0)
**Тест-кейсов:** 130 (50 v1.0 + 80 v2.0)
**E2E сценариев:** 18 (10 v1.0 + 8 v2.0)
