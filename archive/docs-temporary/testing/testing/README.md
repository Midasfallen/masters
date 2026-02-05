# Testing Documentation - Тестовая документация

**Версия:** 2.0
**Дата:** Декабрь 2025

---

## 📋 Содержание папки

Тестовая документация **Service Platform v2.0** — comprehensive план тестирования и детальные тест-кейсы.

### Документы

| Файл | Описание | Версия | Содержание |
|------|----------|--------|------------|
| **[TestPlan.md](./TestPlan.md)** | Test Plan - План тестирования | v2.0 | Стратегия, уровни, acceptance criteria |
| **[TestCases.md](./TestCases.md)** | Test Cases - Детальные тест-кейсы | v2.0 | 130 тест-кейсов |

---

## 📄 Краткое описание документов

### 1. TestPlan.md - Test Plan

**Что внутри:**
- Цели тестирования
- Целевые метрики качества (v2.0)
- Уровни тестирования (Unit, Integration, E2E)
- Нефункциональное тестирование (Performance, Security)
- Test execution strategy
- Acceptance criteria для v2.0 launch

**Целевые метрики v2.0:**

| Метрика | Цель | Метод измерения |
|---------|------|-----------------|
| Backend Coverage | > 85% | Jest coverage |
| Frontend Coverage | > 75% | Flutter test coverage |
| E2E Scenarios | 18+ passing | Automated E2E suite |
| Critical Bugs | 0 | Bug tracking |
| Major Bugs | < 3 | Bug tracking |
| API Response (p95) | < 200ms | Load testing |
| Feed Load (p95) | < 200ms | Performance monitoring |
| WebSocket Latency (p95) | < 100ms | Real-time monitoring |
| Message Delivery Rate | > 99.9% | Message tracking |

**Уровни тестирования:**

**1. Unit Testing:**
- **Backend (Jest):** 15+ модулей
  - v1.0: Auth, Users, Masters, Bookings, Search, Reviews
  - v2.0: Posts/Feed, Likes, Comments, Friends, Subscriptions, Chats (WebSocket), Notifications, Auto-proposals, Favorites

- **Frontend (Flutter Test):** Providers, Models, Services

**2. Integration Testing:**
- Backend integration tests (модули + БД)
- Frontend integration tests (screens + API)

**3. E2E Testing:**
- **18 сценариев** (10 v1.0 + 8 v2.0)
  - v1.0: Registration, Search & Book, Master Setup, Booking Lifecycle, Chat, Premium, Admin, Cancellation, No-Show, Multi-language
  - v2.0: Feed Scrolling & Liking, Friends Request, Real-time Chat, Mandatory Review Blocking, Auto Proposals, Feed → Booking, Notifications, Post Creation

**4. Performance Testing:**
- Load testing (Artillery, k6)
- WebSocket load (1k → 20k connections)
- Feed performance (< 200ms)

**5. Security Testing:**
- OWASP Top 10 checks
- Authentication bypass attempts
- SQL injection tests
- XSS tests
- Rate limiting verification

**Когда читать:**
- Перед началом Phase 5 (Testing)
- При разработке новых фич (для понимания test requirements)
- Для planning test automation

### 2. TestCases.md - Test Cases

**Что внутри:**
- **130 детальных тест-кейсов** (50 v1.0 + 80 v2.0)
- Формат: ID, Название, Приоритет, Тип, Шаги, Ожидаемый результат
- Категории: Flutter UI, Backend API, Integration, E2E

**Категории тест-кейсов v1.0 (50):**
- Flutter UI - Авторизация (TC-001 — TC-010)
- Flutter UI - Основные экраны (TC-011 — TC-020)
- Backend API - Auth (TC-021 — TC-030)
- Backend API - Users (TC-031 — TC-040)
- Backend API - Masters (TC-041 — TC-050)
- Backend API - Bookings (TC-051 — TC-060)
- Backend API - Search (TC-061 — TC-070)
- Integration Tests (TC-071 — TC-085)
- E2E Tests (TC-086 — TC-100)

**Категории тест-кейсов v2.0 (80):**
- Backend API - Posts/Feed (TC-101 — TC-115): 15 кейсов
- Backend API - Likes (TC-116 — TC-121): 6 кейсов
- Backend API - Comments (TC-122 — TC-129): 8 кейсов
- Backend API - Friends (TC-130 — TC-139): 10 кейсов
- Backend API - Subscriptions (TC-140 — TC-147): 8 кейсов
- Backend API - Chats (WebSocket) (TC-148 — TC-159): 12 кейсов
- Backend API - Notifications (TC-160 — TC-167): 8 кейсов
- Backend API - Favorites (TC-168 — TC-175): 8 кейсов
- Backend API - Auto Proposals (TC-176 — TC-181): 6 кейсов
- Flutter UI - Feed & Social (TC-182 — TC-195): 14 кейсов

**Формат тест-кейса:**

```markdown
### TC-101: Feed Load - Успешная загрузка

| Поле | Значение |
|------|----------|
| **ID** | TC-101 |
| **Название** | Проверка загрузки Feed |
| **Приоритет** | Critical |
| **Тип** | API |
| **Предусловия** | User authenticated |

**Шаги:**
1. GET /api/v1/posts/feed?page=1&limit=20
2. Verify response status 200
3. Check posts array

**Ожидаемый результат:**
- Status: 200
- Response contains 20 posts
- Each post has: id, master_name, media, likes_count
- Posts ordered by score DESC
```

**Когда читать:**
- При написании тестов
- Для manual testing
- Для понимания expected behavior

---

## 🧪 Testing Strategy

### Pyramid Testing Model

```
           ┌─────────────┐
          /  E2E Tests   \      18 scenarios
         /   (Slow)       \     (Playwright/Flutter Driver)
        /─────────────────\
       /  Integration Tests\   30+ scenarios
      /   (Medium speed)    \  (Supertest/Flutter Integration)
     /──────────────────────\
    /     Unit Tests         \ 500+ tests
   /    (Fast, Isolated)      \(Jest/Flutter Test)
  /────────────────────────────\
```

### Coverage Requirements

**Backend (NestJS/Jest):**
- ✅ **Overall Coverage:** > 85%
- ✅ **Controllers:** > 80%
- ✅ **Services:** > 90%
- ✅ **Critical Paths:** 100%

**Frontend (Flutter):**
- ✅ **Overall Coverage:** > 75%
- ✅ **Providers:** > 85%
- ✅ **Models:** > 90%
- ✅ **Widgets:** > 70%

### CI/CD Integration

**On Pull Request:**
```yaml
jobs:
  test:
    - Lint (ESLint, Dart analyzer)
    - Unit tests (Backend + Frontend)
    - Integration tests
    - Coverage report
```

**On Merge to Main:**
```yaml
jobs:
  test:
    - All PR tests
    - E2E tests (18 scenarios)
    - Security scans (Snyk, OWASP)
    - Performance regression tests
```

**Before Release:**
```yaml
jobs:
  test:
    - Full test suite
    - Load testing
    - Manual exploratory testing
    - Accessibility audit
```

---

## 🎯 Test Priorities

### Critical (Must Pass)

- ✅ Authentication & Authorization
- ✅ Booking creation & lifecycle
- ✅ Payment processing
- ✅ Feed loading & rendering
- ✅ WebSocket message delivery
- ✅ Mandatory review enforcement

### High Priority

- ✅ Search & filters
- ✅ Master profile setup
- ✅ Social interactions (likes, comments)
- ✅ Friends & subscriptions
- ✅ Notifications delivery
- ✅ Premium features

### Medium Priority

- ✅ Profile editing
- ✅ Settings management
- ✅ Auto-proposals
- ✅ Favorites
- ✅ Localization

### Low Priority

- ✅ UI cosmetics
- ✅ Non-critical animations
- ✅ Edge cases

---

## 📊 Test Execution Status (Template)

### v2.0 Test Summary

| Category | Total | Passed | Failed | Not Tested | Coverage |
|----------|-------|--------|--------|------------|----------|
| **Unit Tests** | 500+ | TBD | TBD | TBD | > 85% |
| **Integration** | 30+ | TBD | TBD | TBD | 100% |
| **E2E** | 18 | TBD | TBD | TBD | 100% |
| **Performance** | 10 | TBD | TBD | TBD | - |
| **Security** | 15 | TBD | TBD | TBD | - |
| **Total** | 573+ | - | - | - | - |

### Bug Summary

| Severity | Count | Resolved | Open |
|----------|-------|----------|------|
| **Critical** | 0 | 0 | 0 |
| **High** | TBD | TBD | TBD |
| **Medium** | TBD | TBD | TBD |
| **Low** | TBD | TBD | TBD |
| **Total** | - | - | - |

---

## 🔧 Test Tools & Frameworks

### Backend Testing

**Frameworks:**
- **Jest** - Unit & Integration testing
- **Supertest** - API endpoint testing
- **Artillery** - Load testing
- **k6** - Performance testing

**Example:**
```typescript
describe('FeedService', () => {
  it('should calculate score correctly', () => {
    const score = feedService.calculateScore({
      geo_score: 0.8,
      freshness_score: 0.9,
      popularity_score: 0.7,
      subscription_score: 1.0,
      category_score: 0.6
    });

    expect(score).toBeCloseTo(0.82, 2);
  });
});
```

### Frontend Testing

**Frameworks:**
- **Flutter Test** - Unit & Widget tests
- **Integration Test** - Integration tests
- **Flutter Driver** - E2E tests

**Example:**
```dart
testWidgets('Feed should display posts', (tester) async {
  await tester.pumpWidget(MyApp());

  await tester.tap(find.byIcon(Icons.home));
  await tester.pumpAndSettle();

  expect(find.byType(PostCard), findsWidgets);
  expect(find.byType(LikeButton), findsWidgets);
});
```

### E2E Testing

**Tools:**
- **Playwright** (Web)
- **Cypress** (Web alternative)
- **Flutter Driver** (Mobile)

---

## 🚀 Running Tests

### Backend

```bash
cd backend

# All tests
npm run test

# Watch mode
npm run test:watch

# Coverage
npm run test:cov

# E2E
npm run test:e2e

# Specific file
npm run test -- feed.service.spec.ts
```

### Frontend

```bash
cd frontend

# All tests
flutter test

# Coverage
flutter test --coverage

# Integration
flutter test integration_test/

# Specific file
flutter test test/features/feed/feed_test.dart
```

### Load Testing

```bash
cd backend/test/load

# Feed load test
k6 run feed-load-test.js

# WebSocket load test
k6 run websocket-load-test.js

# Full load test suite
npm run test:load
```

---

## 📋 Acceptance Criteria (v2.0 Launch)

### Functional Criteria

✅ **Features:**
- [ ] 98/98 Must-have user stories completed
- [ ] All critical flows tested
- [ ] Feed algorithm working & personalized
- [ ] WebSocket real-time messaging stable
- [ ] Notifications delivered reliably

### Quality Criteria

✅ **Test Coverage:**
- [ ] Backend coverage > 85%
- [ ] Frontend coverage > 75%
- [ ] 18+ E2E scenarios passing
- [ ] 130+ test cases executed

✅ **Bugs:**
- [ ] 0 critical bugs
- [ ] < 3 high severity bugs
- [ ] < 15 medium severity bugs

✅ **Performance:**
- [ ] API p95 < 200ms
- [ ] Feed load < 200ms (p95)
- [ ] WebSocket latency < 100ms (p95)
- [ ] Message delivery > 99.9%
- [ ] Frontend 60 FPS
- [ ] Lighthouse score > 90

✅ **Security:**
- [ ] OWASP Top 10 mitigated
- [ ] Security audit passed
- [ ] No HIGH vulnerabilities
- [ ] WebSocket secured (JWT)
- [ ] Rate limiting active

✅ **Real-time:**
- [ ] WebSocket uptime > 99.5%
- [ ] Message delivery < 1 sec
- [ ] Typing indicators working
- [ ] Reconnection logic tested

---

## 🔗 Связанные документы

**Business:**
- [BRD](../business/BRD.md) - Бизнес-требования
- [User Stories](../business/UserStories.md) - 148 user stories

**Technical:**
- [TechSpec](../technical/TechSpec.md) - Техническая спецификация
- [API Spec](../technical/API.md) - API endpoints (165)
- [Database](../technical/Database.md) - Схема БД (29 таблиц)

**Analysis:**
- [Requirements](../analysis/Requirements.md) - Системные требования
- [Risks](../analysis/Risks.md) - Анализ рисков
- [Roadmap](../analysis/Roadmap.md) - Дорожная карта

**Root:**
- [ARCHITECTURE](../../ARCHITECTURE.md) - Архитектура проекта
- [CONTRIBUTING](../../CONTRIBUTING.md) - Гайд для контрибьюторов

---

**Последнее обновление:** Декабрь 2025
**Статус:** ✅ Готов к Phase 5 (Testing)
**Тест-кейсов:** 130 (50 v1.0 + 80 v2.0)
**E2E сценариев:** 18 (10 v1.0 + 8 v2.0)
