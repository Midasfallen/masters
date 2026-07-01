# Анализ готовности проекта Service Platform

## Context

Пользователь запросил «полный анализ готовности проекта». Service Platform — монорепо
(Flutter frontend + NestJS backend + Docker инфраструктура). Цель — дать честную оценку
готовности к production по трём направлениям (backend / frontend / инфраструктура),
выявить блокеры и сформировать приоритизированный список доработок.

Это **аналитическая (read-only) задача**: результат — отчёт, а не изменения в коде.
Анализ уже выполнен через 3 параллельных Explore-агента + ручная верификация ключевых
фактов. Ниже — итоговые выводы. План фиксирует, что именно делать дальше (если пользователь
захочет закрывать блокеры).

> Цифры в отчётах агентов местами расходились — проверены вручную:
> миграций **11** (не 12), тестов backend **12 unit + 9 e2e** (не «73/73»),
> `backend/.env` **НЕ закоммичен** и корректно в `.gitignore` (ложная тревога агента снята).

---

## Итоговая оценка готовности

| Компонент | Готовность | Главное |
|-----------|-----------|---------|
| Backend (NestJS) | ~70% | Функционал полный, но критичные reliability/security TODO |
| Frontend (Flutter) | ~85% | Архитектура чистая, остались заглушки и debug-код |
| Инфраструктура / CI/CD | ~80% | Docker+CI готовы, нет prod-конфига и Nginx/SSL |

**Общий вердикт: «готов к демо», ~75–80% к production.** Запуск блокируют несколько
конкретных пунктов (см. ниже), большинство — небольшие по объёму.

---

## Backend (`backend/src`)

**Реализовано (21 модуль):** auth, users, masters, services, bookings, reviews,
categories, posts, social (likes/comments/reposts), friends, chats, notifications (FCM+WS),
search (Meilisearch + PG fallback), admin, favorites, upload (MinIO), service-templates,
websocket (Socket.io), scheduler, common. REST + WebSocket, Swagger на `/api/v2/docs`.

**Блокеры (P1):**
- Reset-токены хранятся в памяти — теряются при рестарте. `auth.service.ts:24`.
- Email-отправка не реализована (forgot-password — заглушка). `auth.service.ts:175`.
- TypeScript strict выключен (`strictNullChecks: false`, `noImplicitAny: false`). `backend/tsconfig.json`.
- Health-check для Redis/Meilisearch — заглушки. `admin.service.ts:244`.
- CORS: `main.ts` перетирает whitelist из `security.config.ts` (риск allow-all в prod).

**Значимое (P2):**
- Admin-роль не проверяется при create/update/delete категорий и удалении отзыва
  (`categories.controller.ts`, `reviews.service.ts:321`).
- В search-результатах пусто `category_names`; теги мастеров не хранятся в entity (`search.service.ts`).
- Невалидные FCM-токены не удаляются (`notifications.fcm.service.ts:148`).
- Уведомление о лайке содержит «User» вместо имени (`social.likes.service.ts:68`).

**Тесты:** 12 unit + 9 e2e (~40% модулей, контроллеры почти не покрыты).

## Frontend (`frontend/lib`)

**Реализовано:** ~46 экранов / 11 features — auth (вкл. reset), feed, search, chats (WS),
bookings (с проверкой незавершённых отзывов), profile, master (визард), notifications,
friends, subscriptions, premium, proposals, settings. Riverpod 2.6 + кодогенерация,
Dio с 5 интерсепторами, Socket.IO с reconnect, типизированный error-handling.

**Блокеры (P1):**
- `mock_data_provider` используется в проде — `subscriptions_screen.dart` и
  `main_navigation_screen.dart` (фейковые данные вместо API).
- Google OAuth — нерабочая кнопка-заглушка. `login_screen.dart:220`.

**Значимое (P2):**
- 15+ `debugPrint` в `post_detail_screen.dart` — обернуть в `kDebugMode` или удалить.
- `/user/:id` в роутере — Placeholder вместо реального экрана профиля.
- Hard-coded IP/логика `isDevelopment` в `app_config.dart`.

**Тесты:** 34 unit/provider + 5 integration + 1 Playwright e2e.

## Инфраструктура и процессы

**Готово:** `docker-compose.yml` (PostGIS, Redis, Meilisearch, MinIO+bucket-init, MailHog,
Adminer) с healthcheck'ами; backend `Dockerfile` (multi-stage, non-root, entrypoint с
авто-миграциями); CI/CD — `.github/workflows/backend-ci.yml` + `frontend-ci.yml`
(lint/test/build/deploy); 11 миграций; полные сиды; `.env.example` документирован.

**Блокеры для prod (P1):**
- Нет `docker-compose.prod.yml` и Nginx (reverse proxy / SSL termination).
- В CI зашиты плейсхолдеры: `yourdomain.com`, `/opt/service-platform` — нужна привязка
  к реальной инфраструктуре + secrets management.
- Реальный SMTP-провайдер вместо MailHog.

**Значимое (P2):**
- MinIO в compose на теге `latest` — зафиксировать версию.
- Нет стратегии бэкапов БД и мониторинга (Sentry/метрики).

---

## Рекомендуемый порядок устранения (если двигаемся к запуску)

1. **Backend P1:** reset-токены → Redis; реальный SMTP; включить/осознанно оставить strict;
   честные health-checks; зафиксировать CORS для prod.
2. **Frontend P1:** убрать `mock_data_provider` из 2 экранов; скрыть/реализовать Google OAuth.
3. **Инфра P1:** `docker-compose.prod.yml` + Nginx + SSL; secrets в CI; реальный домен.
4. **P2-хвост:** admin-guards, category_names/tags в search, debug-код, FCM cleanup, бэкапы.

## Roadmap закрытия P1-блокеров

Порядок — от самого рискованного для prod. Каждый пункт самодостаточен.

### Backend P1

**B1. Reset-токены → Redis** (`auth.service.ts:24`)
- Сейчас токены сброса в `Map` в памяти — теряются при рестарте, не шарятся между инстансами.
- В проекте уже есть `CacheService` (Redis, `common/`). Заменить in-memory Map на запись
  `reset:<token> → userId` с TTL (например 1ч) через `CacheService`.
- При reset-password — читать из Redis и удалять после использования (one-time).

**B2. Реальный SMTP вместо заглушки** (`auth.service.ts:175`) — ⏸️ В БЭКЛОГ (отложено)

**B3. Честные health-checks** — ✅ УЖЕ РЕАЛИЗОВАНО в боевом `/health`
- Выяснилось при реализации: `common/controllers/health.controller.ts` уже делает реальные
  проверки БД (`SELECT 1`), Redis, Meilisearch, MinIO, SMTP, memory + k8s-пробы
  (`/health/liveness`, `/health/readiness`). Анализ агента указал не туда.
- Заглушки `redis/meilisearch: 'connected'` (`admin.service.ts:244`) — в **мёртвом коде**:
  `AdminService` нигде не зарегистрирован, реальный `AdminController` обслуживает только
  `/admin/search/*`. Решение пользователя: код не трогать, см. бэклог ниже.

> **B2 уже технически готов:** `common/services/email.service.ts` (nodemailer) полностью
> рабочий и используется в `/health` SMTP-проверке. Остаётся лишь подключить его в
> `auth.service.forgotPassword` — отложено в бэклог по решению пользователя.

### Бэклог (выявлено по ходу, вне текущего скоупа)
- **Рассинхрон admin-модуля:** `admin.e2e-spec.ts` тестирует `/admin/stats`, `/admin/users`,
  `/admin/bookings/recent`, `/admin/users/:id/status`, которых нет в `AdminController`
  (есть только `/admin/search/*`). Либо реализовать эндпоинты на базе готового
  `AdminService`, либо удалить мёртвый `AdminService` + устаревший e2e.
- **B2:** подключить `EmailService` в forgot-password.
- **F2:** Google OAuth.

**B4. CORS для prod** (`main.ts` vs `security.config.ts`)
- `main.ts` перетирает whitelist. Убрать дублирующую настройку, оставить единый источник
  из `security.config.ts`, который в prod берёт origins из `CORS_ORIGIN`, а не allow-all.

**B5. TypeScript strict** (`backend/tsconfig.json`) — ⏸️ ОТЛОЖЕНО, объём оценён
- Замерено через `npx tsc --noEmit` с флагами: `strictNullChecks` → **86 ошибок**,
  `noImplicitAny` → **105 ошибок**, полный `--strict` → 28. Это не быстрый фикс, а
  отдельная работа на ~100+ правок с риском регрессий.
- Решение: оставить выключенным сейчас (осознанный риск зафиксирован), вынести в
  отдельную задачу поэтапного включения (флаг за флагом, модуль за модулем). См. бэклог.

### Frontend P1

**F1. Убрать `mock_data_provider` из прода** — ✅ СДЕЛАНО
- `main_navigation_screen.dart`: счётчик `unreadNotificationsCountProvider` (mock) →
  реальный `notificationsUnreadCountProvider` (`.valueOrNull ?? 0`).
- `subscriptions_screen.dart`: переписан на `mySubscriptionsListProvider` /
  `mySubscribersListProvider` (`UserModel`, async `.when`), реальные subscribe/unsubscribe
  через `subscriptionNotifierProvider`, переход на `/user/:id`.
- Удалён неиспользуемый `core/providers/mock_data_provider.dart` и `faker` из pubspec.
- `flutter analyze` по изменённым файлам — чисто.
- Примечание: `data/mock/` НЕ удалён — он ещё используется `home_screen.dart` и
  `category_browser_screen.dart` (вне скоупа F1, см. бэклог).

**F2. Google OAuth** (`login_screen.dart:220`) — ⏸️ В БЭКЛОГ (отложено)

### Инфраструктура P1

**I1. `docker-compose.prod.yml` + Nginx** — ✅ СДЕЛАНО
- Создан `docker-compose.prod.yml`: postgres/redis/meilisearch/minio + buckets + backend
  (build из Dockerfile) + nginx. Без Adminer/MailHog. Порты БД/Redis/Meili/MinIO наружу
  НЕ публикуются. Все секреты через `${...}` из `.env.prod` (нет хардкода). `restart: always`,
  `depends_on` с healthcheck-условиями. Meilisearch в `MEILI_ENV=production`.
- Создан `docker/nginx/nginx.conf`: HTTP→HTTPS redirect + ACME-challenge, HTTPS reverse
  proxy на `backend:3000`, WebSocket upgrade (Socket.IO), security-заголовки,
  `client_max_body_size 100M`.
- Создан `.env.prod.example` (шаблон prod-переменных с плейсхолдерами CHANGE_ME).
- `.gitignore`: добавлены `.env.prod`, `.env.production`, `docker/nginx/ssl/`
  (+ исключение `!.env.prod.example`).
- Валидация: `docker compose -f docker-compose.prod.yml config` — синтаксически валиден.

**I2. Привязать CI к реальной инфраструктуре** — ⏸️ В БЭКЛОГ
- В `backend-ci.yml`/`frontend-ci.yml` заменить плейсхолдеры `yourdomain.com` и
  `/opt/service-platform` на реальные значения; перевести креды на GitHub Secrets.
  Требует доступа к реальному серверу/домену — вне локального скоупа.

**I3. Зафиксировать версию MinIO** — ✅ СДЕЛАНО
- В `docker-compose.yml`: `minio/minio:latest` → `RELEASE.2025-04-22T22-12-26Z`,
  `minio/mc:latest` → `RELEASE.2025-04-16T18-13-26Z`.

---

## Verification (выполнено)

- Backend `npx tsc --noEmit` → **0 ошибок** (после правок B1/B4).
- `auth.service.spec.ts` → **12/12 passed** (с моком CacheService).
- Frontend `flutter analyze` по изменённым экранам → **No issues found**.
- `flutter pub get` после удаления `faker` → OK (зависимость убрана).
- `docker compose -f docker-compose.prod.yml config` → синтаксически валиден.
- `git check-ignore .env.prod` → игнорируется; `.env.prod.example` остаётся видимым.

### Рекомендуется прогнать перед мержем
- `cd backend && npm run test:e2e` (полный e2e — здесь не запускался; учесть известный
  рассинхрон `admin.e2e-spec.ts`, см. бэклог).
- E2E готовности вручную: infra в Docker + `npm run start:dev` + Chrome, флоу
  регистрация → визард мастера → пост → чат → бронирование → отзыв.
- Проверить, что после подключения Helmet (B4) WebSocket/медиа из MinIO работают в dev.

## Локальный запуск (обнаруженные блокеры разворота с нуля)

При запуске на чистой БД выявлены реальные проблемы развёртывания:

1. **Базовая схема не создавалась ничем.** `users`, `categories`, `services`,
   `master_profiles`, `bookings`, `reviews` и др. не создаются ни миграциями, ни
   `init.sql` — исторически схема рождалась из `synchronize: true`. На чистом volume
   проект не разворачивался. → Сгенерирована полная `InitBaseSchema` миграция из entities.
2. **Несогласованный timestamp миграции.** `20260202021329-AddCategoryIdsToPosts`
   (datetime-формат) ломал порядок относительно остальных (unix-ms). → Переименована в
   `1770800000000-AddCategoryIdsToPosts`.
3. **Двойной маппинг таблицы `post_services`** в `Post` entity: одновременно
   `@OneToMany(PostService)` и `@ManyToMany(Service)+@JoinTable('post_services')`. Из-за
   этого `synchronize`/`migration:generate` генерируют невалидный каскад
   `DROP/ADD PRIMARY KEY` → падение. → В `InitBaseSchema` удалён мусорный блок; в entity
   дубль НЕ трогал (нужно решение — см. бэклог).

Добавлены dev-утилиты: `src/database/seeds/sync-schema.ts`, `init-dev-db.ts`.
БД развёрнута, seed отработал (12 юзеров, категории, услуги, посты), изображения
загружены в MinIO. Backend `start:dev` → `/health` показывает db/redis/meilisearch/minio
**up** (B3 подтверждён вживую), логин возвращает JWT.

## Баг сериализации пагинации (найден при тесте «у мастеров нет услуг»)

**Симптом:** на экране мастера вкладка «Услуги» пуста, хотя в БД услуги есть.

**Причина:** глобальный `SerializeInterceptor` применяет
`classToPlain(data, { excludeExtraneousValues: true })` — в ответ попадают только
поля с `@Expose()`. Но `PaginatedResponseDto` в `common/dto/pagination.dto.ts` (его
используют services, chats, friends/subscriptions, posts, social) **не имел `@Expose()`**
на `data`/`meta` → все пагинированные эндпоинты возвращали `{}`. Frontend
`parseListResponse` извлекал `data` → отсутствует → `?? []` → пустой список.

**Фикс:** добавлены `@Expose()` к `data` и `meta` в `pagination.dto.ts`. Проверено:
`GET /services/master/:id` теперь отдаёт `{data:[4 услуги], meta:{total:4}}`; на экране
мастера в Chrome услуги отображаются с ценами. Чинит сразу все пагинированные списки.

**Смежное (НЕ фикшено, в бэклог):** поиск мастеров `/search/masters?query=<шаблон>`
возвращает пусто — Meilisearch индексирует мастеров по имени/описанию, но не по
названиям их услуг, поэтому экран «мастера по услуге» (template_masters) не находит
никого по слову вроде «Свадьба».

## Баг «Записаться» (POST /bookings → 400)

Два независимых дефекта:
1. **Лишнее поле `master_id`.** Фронт слал `master_id` в `CreateBookingRequest`, но
   backend `CreateBookingDto` его не содержит, а `ValidationPipe` с `forbidNonWhitelisted`
   → `property master_id should not exist`. **Фикс:** убрал `master_id` из
   `CreateBookingRequest` (`booking_model.dart`) и из вызова (`master_profile_screen.dart`);
   backend определяет мастера по `service_id`. Регенерирован freezed-код.
2. **Неверная семантика `services.master_id` в seed.** Seed писал `master_id = profile.id`,
   а backend `createBooking` ищет мастера как `master_profiles WHERE user_id = service.master_id`
   (т.е. ждёт `users.id`, см. CLAUDE.md) → «Мастер недоступен». **Фикс:** в `seed.ts`
   `master_id: profile.user_id`; поправлены зависимые места (поиск мастера для bookings,
   фильтр услуг для post_services). Данные пересозданы — все 27 услуг теперь на `users.id`.

Проверено: `POST /bookings` (без master_id) создаёт booking `pending`, мастер определён
по service_id.

> Смежный баг (в бэклог): поиск `/search/masters` падает 400 `property radius_km should
> not exist` — фронт шлёт `radius_km`, которого нет в search-DTO.

## Баг «services.master_id рассинхрон» + навигация после записи

После пере-seed (master_id = users.id) всплыло, что `getServicesByMaster` искал строго
по переданному id, а фронт/`getMyServices` передавали profile.id → вкладка «Услуги» и
диалог записи пусты для мастеров, открытых по user_id, и наоборот. **Фикс:** в
`services.service.ts` `getServicesByMaster` резолвит profile.id → user_id (устойчив к
обоим, как требует CLAUDE.md). Проверено: `/services/master/:id` отдаёт услуги и по
profile.id, и по user_id.

**Навигация после записи:** `master_profile_screen.dart` делал `context.go('/bookings')`
и `/bookings?tab=history` — таких роутов нет («Записи» это таб в `MainNavigationScreen`,
а не GoRoute) → «Page not found». **Фикс:** убрал переход после успешной записи
(остаёмся на профиле + snackbar), а для отзывов → `context.go('/')`.

**Проверено вживую (после очистки SW-кэша):** запись создаётся (`POST /bookings → 201`,
snackbar «Запись создана на 30.06.2026 в 15:00»), приложение остаётся на профиле мастера
без «Page not found». Занятый слот отклоняется понятным сообщением «Это время уже занято»
(бизнес-правило, не баг). Кнопка «Записаться» полностью работает end-to-end.

> Мёртвый код (в бэклог): `shared/widgets/main_navigation.dart` (URL-based навигатор с
> `/bookings`) нигде не используется — активен `main_navigation_screen.dart`.

## Ручное тестирование функций (вживую в Chrome)

| Функция | Статус | Детали |
|---|---|---|
| Onboarding → регистрация → логин | ✅ | JWT, secure storage, авто-восстановление сессии |
| Лента (Feed) | ✅ | реальные посты + фото из MinIO |
| Лайк поста | ✅ | `POST /posts/:id/like 200`, счётчик 84→85 |
| Комментарий | ✅ | `POST /comments 201`, появился, счётчик 36→37 |
| Поиск (категории) | ✅ | 10 категорий + подкатегории с `masters_count` |
| Профиль мастера + услуги | ✅ | услуги с ценами (после фиксов) |
| Запись к мастеру | ✅ | `POST /bookings 201`, занятый слот отклоняется |
| Новый чат + поиск юзеров | ✅ | поиск по имени (Meilisearch), кириллица работает |
| Отправка сообщения | ✅ | `POST /messages 201`, доставка с галочкой |
| Профиль пользователя | ✅ | `/users/me`, аватар, счётчики, бейдж «Мастер» |

Примечание: «Никого не найдено»/«нет услуг» при первом тесте оказались следствием
устаревших имён в моих запросах и SW-кэша старой сборки, а не багами. CORS (preflight
OPTIONS 204) работает на всех мутациях — подтверждает B4.

## Баг `req.user.sub` → ложный счётчик уведомлений

**Симптом:** бейдж уведомлений показывал «4-5» при пустом списке; `unread-count` возвращал
5 (=всего в БД) для любого юзера.

**Корень:** `JwtStrategy.validate` возвращает объект `User` (поле `id`), а не JWT payload
(поле `sub`). Контроллеры **notifications** и **reviews** брали `req.user.sub` (→ `undefined`).
Из-за этого:
- список `findAll(undefined)` → QueryBuilder `user_id = NULL` → пусто (0);
- `getUnreadCount(undefined)` → TypeORM `count({where:{user_id: undefined}})` **отбрасывает**
  условие → считает все непрочитанные в системе.

Рабочие контроллеры (likes/comments/bookings) используют `@CurrentUser('id')` / `req.user.id`.

**Фикс:** заменил все `req.user.sub` → `req.user.id` в `notifications.controller.ts` (10)
и `reviews.controller.ts` (5). Проверено: `unread-count` для клиента → 0; бейдж в нижней
навигации исчез. Это также чинит все reviews-эндпоинты (создание/правка/удаление отзывов
работали от undefined-юзера).

## Фича: отметки (теги) пользователей в посте

Запрошено: при создании поста отмечать пользователей приложения (мастеров и клиентов),
как теги в Instagram. Полная реализация backend + frontend.

**Хранение:** колонка-массив `tagged_user_ids uuid[]` в `posts` (как `category_ids`) +
GIN-индекс. Без junction-таблицы — проще и без риска повторить баг двойного маппинга
`post_services`. Миграция `1782700000000-AddTaggedUserIdsToPosts`.

**Backend:**
- `post.entity.ts` — поле `tagged_user_ids`.
- `create-post.dto.ts` — `tagged_user_ids?: string[]` (`@IsUUID('4', {each:true})`).
- `posts.service.ts` — нормализация (оставляем только существующих юзеров) при создании;
  helper `attachTaggedUsers()` (один запрос на набор постов, без N+1) подгружает
  `taggedUsers` в create/getFeed/getUserPosts/findOne.
- `post-response.dto.ts` + `posts.mapper.ts` — поле `taggedUsers: AuthUserDto[]`.
- `posts.module.ts` — добавлен `User` в `forFeature`.
- Проверено API: создание поста с `tagged_user_ids` → ответ содержит `taggedUsers`
  с полными полями; GET поста тоже возвращает отметки.

**Frontend:**
- `post_model.dart` — `taggedUserIds` в `CreatePostRequest`, `taggedUsers` в `PostModel`.
- `create_post_screen.dart` — секция «Отметить людей» + bottom-sheet `_TagUsersSheet`
  (мультивыбор с поиском, переиспользует `searchUsersForChatProvider` / Meilisearch),
  чипы выбранных, передача `taggedUserIds` при submit.
- `post_detail_screen.dart` — отмеченные пользователи под контентом, кликабельны →
  переход на профиль.
- `flutter analyze` чисто, кодоген выполнен (`taggedUsers` парсится из JSON).

**Проверено вживую в Chrome:**
- Отображение: пост «Тестовый пост с отметками» показывает отмеченного «Тарас Фомина»
  голубым кликабельным текстом под контентом — работает.
- Backend end-to-end: создание поста с `tagged_user_ids` → `taggedUsers` в ответе и при
  GET поста.
- UI-секцию выбора (bottom-sheet) кликом протестировать не удалось: шаг «медиа» требует
  фото, а web file picker (image_picker) не управляется Chrome-плагином в headless-режиме.
  Секция реализована по проверенному паттерну `new_chat_dialog` (тот же
  `searchUsersForChatProvider`), analyze чист — требует ручной проверки с загрузкой фото.

## Итог сессии

**Закрыто:** B1 (reset-токены в Redis), B3 (боевой /health уже корректен — подтверждено),
B4 (Helmet + CORS whitelist из `CORS_ORIGIN` подключены в `main.ts`), F1 (mock_data_provider
убран, faker удалён), I1 (prod-compose + Nginx + `.env.prod.example` + gitignore), I3 (версия MinIO).

**В бэклоге (chips заведены):** B2 (SMTP в forgot-password — EmailService уже готов),
B5 (TypeScript strict: ~86 strictNullChecks / ~105 noImplicitAny), F2 (Google OAuth),
I2 (CI → реальный домен/secrets), рассинхрон admin-модуля, mock-данные в home/category-browser.
