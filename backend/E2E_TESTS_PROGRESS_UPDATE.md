# E2E Tests Progress Update - Session 2

**Дата:** 13 января 2026, 23:06
**Текущий статус:** 30/73 тестов проходят (41%)

---

## 📊 Прогресс

| Метрика | Значение | Изменение |
|---------|----------|-----------|
| Тесты проходят | 30/73 | +2 с предыдущей сессии |
| Процент успеха | 41% | +3% |
| Auth Module | 11/12 (92%) | ✅ Стабильно |
| Admin Module | 5/16 (31%) | ⚠️ Требует фикса |
| Posts Module | ?/24 (?%) | 🔍 В процессе |
| Bookings Module | 1/15 (7%) | ❌ Критично |

---

## ✅ Завершенные задачи (Session 2)

### 1. Posts Routes - ИСПРАВЛЕНО ✅

**Проблема:** E2E тесты ожидали routes `/posts/:id/like`, `/posts/:id/comments` и т.д., но они отсутствовали в PostsController.

**Решение:** Добавлены 6 новых routes в PostsController с делегированием в SocialModule:

#### Добавленные routes:

```typescript
// 1. Like Post
@Post(':id/like')
@HttpCode(HttpStatus.OK)
likePost(@Param('id') id: string, @CurrentUser('id') userId: string) {
  return this.likesService.create(userId, {
    likable_type: LikableType.POST,
    likable_id: id,
  });
}

// 2. Unlike Post
@Delete(':id/unlike')
@HttpCode(HttpStatus.OK)
unlikePost(@Param('id') id: string, @CurrentUser('id') userId: string) {
  return this.likesService.remove(userId, LikableType.POST, id);
}

// 3. Create Comment
@Post(':id/comments')
createComment(
  @Param('id') postId: string,
  @CurrentUser('id') userId: string,
  @Body() body: { content: string; parent_comment_id?: string },
) {
  const createCommentDto: CreateCommentDto = {
    post_id: postId,
    content: body.content,
    parent_comment_id: body.parent_comment_id,
  };
  return this.commentsService.create(userId, createCommentDto);
}

// 4. Get Comments
@Get(':id/comments')
getComments(@Param('id') postId: string, @Query() query: { page?: number; limit?: number; parent_comment_id?: string }) {
  const filterDto = {
    post_id: postId,
    page: query.page,
    limit: query.limit,
    parent_comment_id: query.parent_comment_id,
  } as FilterCommentsDto;
  return this.commentsService.findAll(filterDto);
}

// 5. Delete Comment
@Delete(':postId/comments/:commentId')
deleteComment(
  @Param('commentId') commentId: string,
  @CurrentUser('id') userId: string,
) {
  return this.commentsService.remove(commentId, userId);
}

// 6. Repost
@Post(':id/repost')
repostPost(
  @Param('id') postId: string,
  @CurrentUser('id') userId: string,
  @Body() body: { comment?: string },
) {
  const createRepostDto: CreateRepostDto = {
    post_id: postId,
    comment: body.comment,
  };
  return this.repostsService.create(userId, createRepostDto);
}
```

#### Обновлен PostsModule:

```typescript
@Module({
  imports: [
    TypeOrmModule.forFeature([Post, PostMedia, Friendship, Subscription]),
    SocialModule, // ← Добавлен импорт
  ],
  controllers: [PostsController],
  providers: [PostsService],
  exports: [PostsService],
})
export class PostsModule {}
```

#### Обновлен PostsController constructor:

```typescript
constructor(
  private readonly postsService: PostsService,
  private readonly likesService: LikesService,        // ← Добавлено
  private readonly commentsService: CommentsService,  // ← Добавлено
  private readonly repostsService: RepostsService,    // ← Добавлено
) {}
```

**Файлы изменены:**
- `backend/src/modules/posts/posts.controller.ts` (+68 строк)
- `backend/src/modules/posts/posts.module.ts` (+2 строки)

**Результат:** Все Posts routes теперь доступны, TypeScript компилируется без ошибок.

---

## ⚠️ Текущие проблемы

### 1. Admin Module - DB Schema Issues (11 failed tests)

**Ошибка:**
```
QueryFailedError: column booking.total_price does not exist
```

**Затронутые тесты:**
- `/admin/stats` (GET) - 500 Internal Server Error
- `/admin/analytics` (GET) - 500 Internal Server Error
- `/admin/bookings/recent` (GET) - 404 Not Found
- `/admin/users` (GET) - Response format mismatch (missing `page`, `limit`)
- `/admin/users/:id/status` (POST) - 400 Bad Request

**Причина:**
1. Booking entity использует поле `total_price`, но в БД оно отсутствует или называется по-другому
2. Admin endpoints возвращают формат не соответствующий тестам
3. Отсутствует route `/admin/bookings/recent`

**Приоритет:** ВЫСОКИЙ (блокирует 11 тестов)

---

### 2. Bookings Module - Missing Routes (14 failed tests)

**Ошибки:**
```
POST /bookings/:id/confirm - 404 Not Found (ожидается 200)
POST /bookings/:id/complete - 404 Not Found (ожидается 200)
POST /bookings/:id/cancel - 404 Not Found (ожидается 200)
GET /bookings/my - 500 Internal Server Error
GET /bookings/:id - 500 Internal Server Error
```

**Затронутые тесты:**
- `/bookings` (POST) - 400 Bad Request (validation errors)
- `/bookings/my` (GET) - 500 Internal Server Error (оба client и master режимы)
- `/bookings/:id` (GET) - 500 Internal Server Error
- `/bookings/:id/confirm` (POST) - 404 Not Found
- `/bookings/:id/complete` (POST) - 404 Not Found
- `/bookings/:id/cancel` (POST) - 404 Not Found

**Причина:**
1. Отсутствуют routes для confirm/complete/cancel в BookingsController
2. 500 errors указывают на проблемы в BookingsService (возможно DB schema)
3. Validation errors при создании booking (UUID issues)

**Приоритет:** ВЫСОКИЙ (блокирует 14 тестов)

---

### 3. Posts Module - Статус неизвестен (24 tests)

**Статус:** Routes добавлены, но результаты тестов пока не проверены детально.

**Необходимо:** Запустить отдельно Posts тесты для проверки.

---

## 🎯 План действий

### Приоритет 1: Исправить Bookings Module (14 тестов)

1. **Добавить недостающие routes в BookingsController:**
   - `POST /bookings/:id/confirm`
   - `POST /bookings/:id/complete`
   - `POST /bookings/:id/cancel`

2. **Исправить 500 errors:**
   - Проверить BookingsService методы
   - Проверить DB schema для Booking entity
   - Исправить validation issues

3. **Ожидаемый результат:** +13 тестов (итого: 43/73 = 59%)

---

### Приоритет 2: Исправить Admin Module (11 тестов)

1. **Исправить DB schema:**
   - Проверить Booking entity поле `total_price` vs DB column name
   - Добавить migration если нужно

2. **Исправить response format:**
   - AdminService.getUsers() должен возвращать `{ users: [], total, page, limit }`
   - AdminService.getStats() должен работать без `total_price`

3. **Добавить недостающий route:**
   - `GET /admin/bookings/recent`

4. **Ожидаемый результат:** +11 тестов (итого: 54/73 = 74%)

---

### Приоритет 3: Проверить Posts Module (24 теста)

1. Запустить `npm run test:e2e -- posts.e2e-spec.ts`
2. Проверить детальные результаты
3. Исправить оставшиеся проблемы если есть

---

## 📈 Прогноз

После исправления всех проблем:
- **Целевой показатель:** 65-70/73 тестов (89-96%)
- **Оставшиеся проблемы:** 3-8 тестов (edge cases, мелкие баги)

---

## 🔧 Технические детали

### TypeScript Fixes

**Проблема:** FilterCommentsDto type error
```typescript
// ❌ Ошибка: Type '{ post_id: string; ... }' is missing properties: skip, take
const filterDto: FilterCommentsDto = { ... };

// ✅ Решение: Type casting
const filterDto = { ... } as FilterCommentsDto;
```

**Причина:** PaginationDto имеет геттеры `skip` и `take`, которые TypeScript считает обязательными свойствами.

---

## 📝 Заметки

- Все критические security issues (password_hash, refresh tokens) исправлены в предыдущей сессии
- Timeout issues исправлены (30s для beforeAll)
- Unique email/phone generation работает корректно
- Sequential test execution (maxWorkers: 1) предотвращает race conditions

---

**Следующий шаг:** Исправить Bookings Module routes и DB schema issues.
