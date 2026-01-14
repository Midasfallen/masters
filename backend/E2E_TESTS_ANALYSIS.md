# E2E Tests Analysis - Проблемы и решения

**Дата:** 13 января 2026
**Статус:** ✅ Timeout проблемы решены | ❌ 62/73 теста падают из-за логических ошибок

---

## ✅ РЕШЕННАЯ ПРОБЛЕМА: Timeout

**Проблема:** Все 73 E2E теста падали с `Cannot read properties of undefined (reading 'getHttpServer')`

**Причина:** AppModule компиляция занимала > 5000ms (default timeout)

**Решение:** Добавлены timeout параметры во все `beforeAll()` и `afterAll()` hooks:
- `beforeAll(async () => { ... }, 30000)` - 30 секунд для инициализации
- `afterAll(async () => { if (app) await app.close(); }, 10000)` - 10 секунд + null-check

**Исправленные файлы:**
- ✅ `test/auth.e2e-spec.ts`
- ✅ `test/admin.e2e-spec.ts`
- ✅ `test/bookings.e2e-spec.ts`
- ✅ `test/posts.e2e-spec.ts`

**Результат:** App теперь инициализируется успешно, тесты выполняются.

---

## ❌ ТЕКУЩИЕ ПРОБЛЕМЫ: Логические ошибки в тестах/API

**Статистика:**
- ❌ **62 теста падают** (логические ошибки)
- ✅ **11 тестов проходят**
- **Итого:** 73 теста

---

## 1. AUTH TESTS (auth.e2e-spec.ts)

### Проблема 1.1: Duplicate email (409 Conflict)
**Ошибка:**
```
expected 201 "Created", got 409 "Conflict"
```

**Причина:** Email `test${Date.now()}@example.com` уже существует в БД (от предыдущих запусков).

**Решения:**
1. **Вариант A (быстрый):** Очищать БД перед каждым тестом
   ```typescript
   beforeEach(async () => {
     await userRepository.clear();
   });
   ```

2. **Вариант B (правильный):** Использовать уникальные email с UUID
   ```typescript
   import { v4 as uuidv4 } from 'uuid';

   email: `test-${uuidv4()}@example.com`
   ```

3. **Вариант C (тестовый):** Использовать отдельную test database, которая очищается перед запуском

---

### Проблема 1.2: password_hash exposed
**Ошибка:**
```
expect(received).not.toHaveProperty(path)
Expected path: not "password_hash"
Received value: "$2b$10$hIa4IRfUwJZNhhL9fIGW..pirLeEAe6oIDtsEdpfQHFqKlZRKH2TK"
```

**Причина:** GET `/users/me` возвращает `password_hash` в response, что является **CRITICAL SECURITY ISSUE**.

**Решение:** Исправить User entity или DTO:

**Вариант A - Entity ClassSerializerInterceptor:**
```typescript
// user.entity.ts
import { Exclude } from 'class-transformer';

@Entity('users')
export class User {
  @Column({ name: 'password_hash', select: false })
  @Exclude() // Исключить из serialization
  passwordHash: string;
}

// users.controller.ts
@UseInterceptors(ClassSerializerInterceptor)
@Get('me')
async getMe(@CurrentUser() user: User) {
  return user; // password_hash будет автоматически исключен
}
```

**Вариант B - Response DTO:**
```typescript
// dto/user-response.dto.ts
export class UserResponseDto {
  id: string;
  email: string;
  first_name: string;
  last_name: string;
  // password_hash НЕ включен

  constructor(partial: Partial<User>) {
    Object.assign(this, partial);
    delete this['password_hash']; // Явно удалить
  }
}

// users.controller.ts
@Get('me')
async getMe(@CurrentUser() user: User): Promise<UserResponseDto> {
  return new UserResponseDto(user);
}
```

---

### Проблема 1.3: Refresh token не меняется
**Ошибка:**
```
expect(received).not.toBe(expected)
Expected: not "eyJhbGc..."
```

**Причина:** POST `/auth/refresh` возвращает тот же самый refresh_token вместо нового.

**Решение:** Исправить `AuthService.refreshTokens()`:
```typescript
// auth.service.ts
async refreshTokens(refreshToken: string) {
  const payload = this.jwtService.verify(refreshToken);
  const user = await this.usersService.findById(payload.sub);

  // Генерировать НОВЫЙ refresh token
  const newAccessToken = this.generateAccessToken(user);
  const newRefreshToken = this.generateRefreshToken(user); // ВАЖНО - новый!

  return {
    access_token: newAccessToken,
    refresh_token: newRefreshToken, // Должен отличаться от старого
  };
}
```

---

## 2. ADMIN TESTS (admin.e2e-spec.ts)

### Проблема 2.1: user.id is undefined
**Ошибка:**
```
TypeError: Cannot read properties of undefined (reading 'id')
regularUserId = userResponse.body.user.id;
```

**Причина:** POST `/auth/register` не возвращает `user` объект в response body.

**Решение:** Исправить `AuthController.register()`:
```typescript
// auth.controller.ts
@Post('register')
async register(@Body() dto: RegisterDto) {
  const user = await this.authService.register(dto);
  const { access_token, refresh_token } = await this.authService.login(user);

  return {
    access_token,
    refresh_token,
    user: {
      id: user.id,
      email: user.email,
      first_name: user.first_name,
      last_name: user.last_name,
      is_master: user.is_master,
      // НЕ включать password_hash!
    },
  };
}
```

---

## 3. BOOKINGS TESTS (bookings.e2e-spec.ts)

### Проблема 3.1: Все booking endpoints возвращают 404
**Ошибка:**
```
expected 200 "OK", got 404 "Not Found"

Endpoints с проблемами:
- POST /bookings/:id/confirm → 404
- POST /bookings/:id/complete → 404
- POST /bookings/:id/cancel → 404
```

**Причина:** Вероятные причины (нужна диагностика):
1. Booking не был создан (bookingId = undefined)
2. Routes не зарегистрированы
3. Booking удаляется слишком рано

**Диагностика:**
```typescript
it('should create a new booking', () => {
  return request(app.getHttpServer())
    .post('/bookings')
    .set('Authorization', `Bearer ${clientToken}`)
    .send({ /* ... */ })
    .expect(201)
    .expect((res) => {
      console.log('Created booking:', res.body); // DEBUG
      bookingId = res.body.id;
      expect(bookingId).toBeDefined(); // Проверить что ID существует
    });
});
```

**Решение A - Проверить routes:**
```typescript
// bookings.controller.ts
@Post(':id/confirm')
async confirm(@Param('id') id: string, @CurrentUser() user: User) {
  return this.bookingsService.confirm(id, user.id);
}

@Post(':id/complete')
async complete(@Param('id') id: string, @CurrentUser() user: User) {
  return this.bookingsService.complete(id, user.id);
}

@Post(':id/cancel')
async cancel(@Param('id') id: string, @Body() dto: CancelBookingDto) {
  return this.bookingsService.cancel(id, dto);
}
```

**Решение B - Проверить что booking создан:**
```typescript
beforeAll(async () => {
  // ...создание сервиса...

  // Создать тестовый booking
  const bookingRes = await request(app.getHttpServer())
    .post('/bookings')
    .set('Authorization', `Bearer ${clientToken}`)
    .send({
      master_profile_id: masterId,
      service_id: serviceId,
      scheduled_for: new Date(Date.now() + 86400000).toISOString(),
    });

  bookingId = bookingRes.body.id;
  console.log('Test booking created:', bookingId); // DEBUG
}, 30000);
```

---

## 4. POSTS TESTS (posts.e2e-spec.ts)

### Проблема 4.1: Repost endpoint 404
**Ошибка:**
```
expected 201 "Created", got 404 "Not Found"
POST /posts/:id/repost
```

**Причина:** Route не зарегистрирован или URL неправильный.

**Решение:** Проверить PostsController:
```typescript
// posts.controller.ts
@Post(':id/repost')
@UseGuards(JwtAuthGuard)
async repost(
  @Param('id') id: string,
  @Body() dto: CreateRepostDto,
  @CurrentUser() user: User,
) {
  return this.postsService.repost(id, user.id, dto.content);
}
```

Проверить API prefix:
```
URL должен быть: POST /api/v2/posts/:id/repost
```

---

## ОБЩИЕ РЕКОМЕНДАЦИИ

### 1. Использовать Test Database
Создать отдельную test database, которая очищается перед каждым запуском:

```typescript
// test/jest-e2e.json
{
  "globalSetup": "./test/setup.ts",
  "globalTeardown": "./test/teardown.ts"
}

// test/setup.ts
export default async function globalSetup() {
  // Создать test database
  const connection = await createConnection({
    type: 'postgres',
    host: 'localhost',
    port: 5433,
    username: 'service_user',
    password: 'service_password',
    database: 'service_platform_test', // Отдельная test БД
  });

  // Очистить все таблицы
  await connection.synchronize(true); // Drop и recreate
  await connection.close();
}
```

### 2. Добавить DEBUG логирование
```typescript
// В тестах
.expect((res) => {
  console.log('Response:', JSON.stringify(res.body, null, 2));
  expect(res.body).toHaveProperty('id');
})
```

### 3. Использовать UUID для уникальности
```typescript
import { v4 as uuidv4 } from 'uuid';

const email = `test-${uuidv4()}@example.com`;
```

### 4. Добавить --detectOpenHandles
```json
// test/jest-e2e.json
{
  "detectOpenHandles": true,
  "forceExit": true
}
```

### 5. Проверить API routes через Swagger
Открыть http://localhost:3000/api/v2/docs и проверить:
- Все ли endpoints доступны
- Какие параметры ожидаются
- Какой response возвращается

---

## ПРИОРИТЕТ ИСПРАВЛЕНИЯ

### 🔴 CRITICAL (исправить немедленно):
1. **password_hash exposed** - Security vulnerability
2. **user.id undefined в register response** - блокирует все admin tests

### 🟠 HIGH (исправить перед production):
3. **Booking endpoints 404** - блокирует весь booking flow
4. **Refresh token не меняется** - security issue
5. **Duplicate email 409** - тесты не идемпотентные

### 🟡 MEDIUM (можно отложить):
6. **Repost endpoint 404** - feature может быть не реализован
7. **Test database isolation** - improvement

---

## СЛЕДУЮЩИЕ ШАГИ

1. ✅ **Сначала исправить CRITICAL issues:**
   - Убрать password_hash из response (security)
   - Добавить user объект в register response

2. ⏳ **Затем исправить HIGH issues:**
   - Диагностировать booking endpoints 404
   - Исправить refresh token rotation
   - Решить проблему duplicate emails

3. ⏳ **Запустить тесты снова:**
   ```bash
   npm run test:e2e
   ```

4. ⏳ **Когда все тесты пройдут:**
   - Commit изменения
   - Перейти к ПРИОРИТЕТ 3: Manual Testing

---

**Автор:** Claude (AI Assistant)
**Дата:** 13 января 2026
