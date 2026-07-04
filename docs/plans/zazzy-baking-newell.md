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

---

# План: Поиск мастеров по услугам (вкладка «Поиск»)

## Context

Вкладка «Поиск» должна находить мастеров по их услугам/категориям, но не находит.
Проверка (БД + Meilisearch + код) показала: **данные и бизнес-логика корректны**,
проблема **только в индексации мастера в Meilisearch**.

Бизнес-логика (подтверждена, менять НЕ нужно): categories L0/L1 → `service_templates`
(каталог готовых услуг) → `services` (услуги мастера с опц. `service_template_id`).
Мастер при регистрации выбирает категории (Step1 валидирует L0/L1); услуги создаются из
шаблонов или кастомные. Данные согласованы: 27 услуг, `services.category_id` ⊆
`master_profile.category_ids` (0 расхождений), услуги привязаны к шаблонам.

**Дубль `parent_id`/`parentId` в categories** — известное исключение (CLAUDE.md «сохранять
как есть»); на поиск не влияет (проблему primaryKey Meilisearch уже решил коммит `ad5735f`).
Трогать не будем.

## Корень проблемы (факты)

Прямая проверка Meilisearch индекса `masters`:
- фильтр по `category_id` (UUID) → **находит** мастера ✅ (данные ок);
- текст «Гипнотерапия» (услуга мастера) / «Психология» (категория) → **0** ❌.

Причина в `search.service.ts::indexMaster()` (строка ~495):
```
category_names: [], // TODO: Загрузить из Category   ← НИКОГДА не заполняется
tags: [],           // TODO
```
`searchableAttributes` индекса включает `category_names`, но оно пустое; названий услуг
мастера в индексе нет вообще. Поэтому текстовый поиск искать не по чему.

## Проблемы и решения

### P1. `category_names` + названия услуг мастера в индекс (главное)

`indexMaster()` (`backend/src/modules/search/search.service.ts`):
- по `masterProfile.category_ids` подтянуть названия категорий — **переиспользовать
  паттерн из `reindexCategories()`** (там уже `categoryTranslationRepository.find` +
  `tr.name`, язык `ru`);
- добавить названия услуг мастера: `services` по `master_id` → их `name` (+ можно
  `service_template` названия через `serviceTemplateTranslationRepository`, как на
  строке ~569);
- расширить документ: `category_names: string[]`, добавить `service_names: string[]`
  в документ и в `searchableAttributes` индекса `masters` (в `onModuleInit`).

Репозитории `categoryTranslationRepository` (стр. 49) и `serviceTemplateTranslationRepository`
уже внедрены в `SearchService` — новых зависимостей не нужно.

### P2. Автоиндексация при создании/обновлении

`indexMaster`/`indexService` существуют, но **не вызываются**:
- `masters.service.ts` — вызвать `searchService.indexMaster(userId)` после завершения
  профиля/обновления категорий (Step1/Step5);
- `services.service.ts` — вызвать `searchService.indexService(id)` в `create()`/`update()`,
  а также `indexMaster` автора (услуги мастера изменились → переиндексировать мастера).
- Обернуть в try/catch (индексация не должна ронять основную операцию), по образцу
  существующих вызовов `indexUser`.

### P3. Параметр `radius_km`

`SearchMastersDto` (`search-masters.dto.ts:94`) принимает `radius`, фронт шлёт `radius_km`
→ 400 `forbidNonWhitelisted`. Переименовать поле DTO в `radius_km` (и использование в
`searchMasters()`), либо добавить алиас через `@Expose({name})`/`@Transform`. Простой путь —
переименовать в `radius_km` (фронт уже так шлёт).

### Геолокация — В БЭКЛОГ (по решению пользователя)

Гео сейчас только считает `distance_km`, не фильтрует по радиусу (Meilisearch geo не умеет,
нужен PostgreSQL `ST_DWithin`). Не трогаем в этой работе — отдельная задача.

## Порядок реализации

1. **P1**: заполнить `category_names` + `service_names` в `indexMaster` (переиспользовать
   `reindexCategories`/`serviceTemplateTranslationRepository`), обновить `searchableAttributes`.
2. **P3**: `radius_km` в DTO.
3. **P2**: автоиндексация в `masters.service`/`services.service`.
4. Переиндексировать: `POST /admin/search/reindex-all` (или пересоздать индекс `masters`,
   т.к. менялись settings — settings применяются к существующему индексу, но документы
   надо перезалить).

Ключевые файлы: `backend/src/modules/search/search.service.ts` (indexMaster, onModuleInit),
`backend/src/modules/search/dto/search-masters.dto.ts`, `backend/src/modules/masters/masters.service.ts`,
`backend/src/modules/services/services.service.ts`.

## Verification

- После reindex — прямой запрос Meilisearch (через Python UTF-8, curl на Windows ломает
  кириллицу): поиск по названию услуги/категории мастера возвращает мастеров.
- API: `GET /search/masters?query=<название услуги>` и `GET /search/all?q=...` возвращают
  мастеров; `category_names` в ответе непустые.
- Frontend в Chrome: вкладка «Поиск» → ввод названия услуги → таб «Мастера» непустой;
  цепочка категория → шаблон → мастера (`/search/template/:slug`) находит мастеров без 400.
- Создать новую услугу мастеру → она сразу находится поиском (проверка P2, без ручного reindex).

## Итог (ВЫПОЛНЕНО ✅)

Все P1/P2/P3 закрыты и проверены end-to-end.

**Backend:**
- **P1** — `indexMaster()`: `category_names` заполняется из `CategoryTranslation` (ru) по
  `master_profile.category_ids`, добавлено `service_names` из услуг мастера
  (`services WHERE master_id=user.id AND is_active`). `service_names` добавлено в
  `searchableAttributes` индекса `masters`.
- **Критичный побочный баг** — `addDocuments` в индексы `masters`/`services`/
  `service_templates` не указывал `{primaryKey:'id'}` → Meilisearch не мог вывести
  primaryKey (4 поля на `_id`), индекс `services` был ПУСТ (0 документов). Добавлен
  `{primaryKey:'id'}` во все три вызова → после reindex 27 услуг, 6 мастеров.
- `indexService()`: мастер резолвился через `userRepository` (было ошибочно через
  `masterProfileRepository.findOne({id: master_id})` → всегда null), добавлен
  `category_name`. Добавлен `removeService(id)`.
- **P2** — автоиндексация: `services.service.ts` (create/update → `reindexServiceAndMaster`,
  remove → `removeService` + `indexMaster`, попутно исправлен owner-check
  `master_id !== userId`); `masters.service.ts` (Step1/Step5 → `reindexMaster`).
  Модули получили `SearchModule` в imports. Обёрнуто в try/catch.
- **P3** — `SearchMastersDto.radius` → `radius_km` (фронт уже слал `radius_km`).

**Frontend:** DECIMAL-цена и рейтинг приходят из PG как строки ("4091.00") →
`StringToDoubleConverter` применён к `ServiceSearchResultModel.price`,
`MasterPreviewInSearch.averageRating`, `MasterSearchResultModel.averageRating`
(+ `NullableStringToDoubleConverter` на `distance_km`). Кодоген + `flutter build web`.

**Проверено вживую в Chrome (no-cache сервер):**
- «Гипнотерапия» → таб «Мастера»: Тарас Фомина (★3.7, 129); таб «Услуги»:
  Гипнотерапия, **4091 ₽**, 45 мин — без TypeError, консоль чиста.
- «Массаж» → 2 мастера (★5.0, ★4.5) + таб «Категории».
- API `/search/all` отдаёт непустые `category_names`, `price` строкой — фронт парсит.

**В бэклоге (не трогали):** геолокация (фильтр по радиусу через PostGIS `ST_DWithin`).

---

# Фикс: список мастеров по шаблону услуги (экран template_masters) + «радиус 10 км»

## Симптом (со слов пользователя)
Строка поиска работает, но «если искать в списках, стоит радиус 10 км» → списки мастеров
по шаблону услуги ведут себя некорректно.

## Диагноз (проверено на данных)
Проблема НЕ в радиусе. `searchMasters` на бэке вообще **не фильтрует по радиусу** (гео в
бэклоге): мастер из Краснодара с `distance_km=45.5` возвращался даже при `lat/lng` Москвы
и `radius_km=10`. Радиус лишь считает `distance_km` для показа.

Настоящая причина — `template_masters_screen.dart` искал мастеров по шаблону через
**текстовый** `query: templateName` + `categoryIds`. Это давало:
- **пропуски** (услуга мастера названа не как шаблон → не найдёт);
- **ложные срабатывания** из-за typo-tolerance Meilisearch. На реальных данных категории
  «Психология и коучинг» (мастер Тарас оказывает только «Гипнотерапия» и «Детский психолог»):
  «Коучинг» и раньше ложно возвращал 1 мастера, «Арт-терапия»/«Семейная терапия» → 0.
Плюс UI писал «Радиус поиска: 10 км» и «В радиусе 10 км нет мастеров» — дезориентировало.

## Решение (ВЫПОЛНЕНО ✅)

**Backend:** точная выборка по `service_template_id` вместо текста.
- Новый метод `SearchService.searchMastersByTemplate(templateId, lat?, lng?)`: услуги
  индекса `services` с фильтром `service_template_id = <id> AND is_active` → уникальные
  `master_id` → обогащение из индекса `masters` (category_names, рейтинг, координаты для
  distance_km). Есть PG-fallback `fallbackSearchMastersByTemplate`.
- Эндпоинт `GET /search/templates/:templateId/masters?lat&lng` (`@Public`).
- В `filterableAttributes` индекса `masters` добавлен `id` (нужен для фильтра `id = ...`);
  применено через `/admin/search/reindex-all`.
- `npx tsc --noEmit` → 0 ошибок.

**Frontend:**
- `api_endpoints.dart`: `searchMastersByTemplate(templateId)`.
- `search_repository.dart`: метод `searchMastersByTemplate`.
- `search_provider.dart`: провайдер `templateMastersProvider(templateId, lat?, lng?)`.
- `template_masters_screen.dart`: переключён на `templateMastersProvider` (по `templateId`,
  без текстового query). Убраны надпись «Радиус поиска: N км», текст «В радиусе N км нет
  мастеров» (→ «Пока нет мастеров, которые предоставляют услугу …»), поле `_defaultRadius`,
  `_locationError` и мёртвый дублирующий пустой-блок. lat/lng шлются только для distance_km.
- Кодоген + `flutter build web` — analyze чист.

**Проверено вживую в Chrome (Поиск → Здоровье и массаж → Психология и коучинг):**
- «Коучинг» → «Мастера не найдены» (раньше ложно показывал мастера). Заголовок «Коучинг»,
  без упоминаний радиуса.
- «Гипнотерапия» → Тарас Фомина (★3.7, 129) — мастер реально оказывает эту услугу.
- Консоль без ошибок. API-проверка: эндпоинт возвращает точные множества
  (Гипнотерапия/Детский психолог → мастер есть; Коучинг/Арт-терапия → 0).

---

# Фикс: ложный мастер в главной строке поиска («массаж» → Харлампий без услуги массаж)

## Симптом
По запросу «массаж» в главной строке показывался Харлампий Казакова, у которого нет
услуги массаж (его услуги: Хип-хоп, Уборка, HR/Бизнес-консалтинг).

## Диагноз
`category_names` входил в `searchableAttributes` индекса `masters`. У Харлампия в профиле
выбрана категория L0 **«Здоровье и массаж»** — её название содержит «массаж», поэтому
текстовый поиск ложно матчил мастера по названию категории, а не по услуге. Аналогично
ложно попадал «Тест Мастер» (та же категория).

## Решение (ВЫПОЛНЕНО ✅)
Убран `category_names` из `searchableAttributes` индекса `masters` (в `onModuleInit`).
Мастер ищется по `service_names` (названия его услуг), имени/фамилии, описанию, тегам.
`category_names` остаётся в **документе** мастера (для отображения в карточке) и в
`filterableAttributes` (фильтр по категории в списках работает). Категории как отдельная
сущность по-прежнему ищутся в индексе `categories` → вкладка «Категории».

Настройки применяются при старте (`onModuleInit` → `updateSettings` + `reindexAll`);
для текущей сессии применены через рестарт (hot-reload) + `/admin/search/reindex-all`.

**Проверено (API + Chrome):**
- «массаж» → мастеров/услуг нет (в БД нет услуги с названием «массаж»); показаны только
  категории (Массаж, Здоровье и массаж, …) на вкладке «Категории». Харлампий и Тест Мастер
  больше НЕ показываются ложно.
- «Гипнотерапия» → Тарас Фомина + услуга «Гипнотерапия».
- «Хип-хоп» → Харлампий Казакова + услуга «Хип-хоп» (находится по реальной услуге).
- Консоль без ошибок.

---

# Фича: кнопка «Новая запись» → выбор мастера из истории

## Запрошено
Кнопка «Новая запись» (таб «Записи») должна показывать список мастеров, к которым
пользователь уже записывался или с которыми переписывался; тап открывает профиль мастера.
(Ранее кнопка вела «в никуда» — пушила несуществующий роут `/search`, затем была временно
переключена на таб «Поиск».)

## Реализация (ВЫПОЛНЕНО ✅)

**Backend:** `GET /bookings/my-masters` (JWT).
- `BookingsService.getMyMasters(userId)`: объединяет master_id из bookings (где юзер —
  клиент) + собеседников из личных чатов (`chat_participants`), фильтрует по `is_master=true`
  (собеседник-клиент отсекается), дедуплицирует, возвращает `BookingUserDto[]`
  (id, firstName, lastName, avatarUrl, phone).
- В `BookingsModule` добавлен `ChatParticipant` в `forFeature`; в сервис — репозиторий
  `ChatParticipant`. Эндпоинт объявлен ДО `@Get(':id')` (иначе `:id` перехватил бы путь).
- `npx tsc --noEmit` → 0 ошибок.

**Frontend:**
- `api_endpoints.dart`: `bookingsMyMasters = '/bookings/my-masters'`.
- `booking_repository.dart`: `getMyMasters()` → `List<ChatUserModel>` (переиспользована
  модель, поля совпадают).
- `bookings_provider.dart`: провайдер `myMastersProvider`.
- Новый экран `select_master_screen.dart`: список мастеров (аватар/имя), тап →
  `/master/:id`; пустое состояние с кнопкой «Найти мастера» → таб «Поиск» (`mainNavIndexProvider`).
- Роут `select-master` в `app_router.dart`; FAB «Новая запись» → `context.push('/select-master')`.
- Кодоген + `flutter build web` — analyze чист.

**Проверено (API + Chrome, юзер ravinski123):**
- `GET /bookings/my-masters` → 200; список из 3 мастеров (Валерьян Русакова, Тест Мастер,
  Павел Макаров) с аватарами. Дедупликация проверена на `client@test.com`: Тарас есть и в
  bookings, и в чате → в ответе 1 раз.
- Кнопка «Новая запись» → экран «Выберите мастера» → тап по «Тест Мастер» → его профиль
  (★4.5, кнопки «Написать»/«Записаться»). Консоль без ошибок.

---

# Фикс: ошибка при загрузке аватара на экране профиля

## Диагноз (три причины)
1. **Web-несовместимость:** `dio_client.uploadFile` использует `MultipartFile.fromFile(path)`,
   что не работает во Flutter web — image_picker отдаёт blob-URL, а не файловый путь.
2. **Неверный эндпоинт:** фронт слал на `/users/me/avatar` (`ApiEndpoints.userAvatar`),
   но такого роута нет. Реальный эндпоинт — `POST /upload/avatar` (upload-модуль).
3. **Неверный разбор ответа:** фронт ждал `UserModel`, а `/upload/avatar` возвращает
   `{ url }` и НЕ сохраняет ссылку в профиль (это отдельный шаг).

## Решение (ВЫПОЛНЕНО ✅)
`user_repository.uploadAvatar(bytes, filename)` теперь делает два шага (как на бэке):
1. `POST /upload/avatar` через `uploadBytes` (`MultipartFile.fromBytes` — web-совместимо,
   поле `file`) → получает `{ url }`;
2. `PATCH /users/me` с `avatar_url` → сохраняет ссылку, возвращает `UserModel`.

- Сигнатуры `uploadAvatar` в repository и `user_provider` переведены на `(bytes, filename)`.
- Оба экрана (`profile_screen`, `edit_profile_screen`) читают `image.readAsBytes()` +
  `image.name` вместо `image.path`.
- В `UpdateUserRequest` добавлено поле `avatarUrl` (JSON `avatar_url`); бэковый
  `UpdateUserDto` его уже принимал, `users.service.update` сохраняет через `Object.assign`.
- Кодоген + `flutter build web` — analyze чист.

**Проверено:**
- API end-to-end (мастер valerukyan_rusakova): `POST /upload/avatar` → 200 `{url:
  http://localhost:9000/avatars/...}`; `PATCH /users/me` {avatar_url} → 200, `avatarUrl`
  сохранён. MinIO отдаёт публичный `localhost:9000` URL (по CLAUDE.md).
- Chrome: экран профиля открывается, клик по иконке камеры вызывает file picker без
  ошибок в консоли (сам выбор файла в headless-браузере не автоматизируется — ограничение
  image_picker, как и при тестах отметок в постах).

Примечание: `ApiEndpoints.userAvatar = '/users/me/avatar'` больше не используется (был
ошибочным) — оставлен, чистка вне скоупа.

## Доп. ошибка: «Unsupported operation: MultipartFile is only supported where dart:io is available»
После фикса пользователь всё ещё видел эту ошибку. Разбор:
- Ошибку бросают ТОЛЬКО `MultipartFile.fromFile`/`fromFileSync` (см.
  `dio_web_adapter/multipart_file_impl.dart` → `multipartFileFromPath*` → throw). `fromBytes`
  её НЕ бросает. Значит выполнялся СТАРЫЙ код (`uploadFile`→`fromFile`).
- Причина — **service worker кэш** старой сборки (известная проблема проекта,
  [[flutter-web-sw-cache]]). Свежая сборка использует `fromBytes`.
- Проверено: HTTP-раздача 8088 отдаёт свежий `main.dart.js` (есть `upload/avatar`, нет
  `users/me/avatar`). Полный флоу воспроизведён из браузерного JS-контекста:
  `POST /upload/avatar` → 200, `PATCH /users/me` → 200, avatarUrl сохранён (CORS+multipart
  из web работают). SW разрегистрирован + кэши (`flutter-app-manifest`, `flutter-app-cache`)
  очищены, страница перезагружена на свежую сборку.
- Действие для пользователя: hard-reload / очистка кэша (или перезапуск браузера).

Отдельно (вне скоупа, в бэклог): `post_repository.uploadPostMedia(path)` через `uploadFile`
(`fromFile`) сломается на web так же — но там уже есть web-путь
`uploadPostMediaFromXFile` (fromBytes); legacy-метод оставлен для мобилок.

## Финальная причина 500 (по логам пользователя)
После фикса fromBytes загрузка в MinIO шла (`POST /upload/avatar` → 200), но следующий шаг
`PATCH /users/me` падал с **500**. По логам видно, что фронт слал
`{first_name: null, last_name: null, phone: null, ..., avatar_url: "..."}`.

Корень: `users.service.update` делал `Object.assign(user, dto)` — null-поля затирали
NOT NULL колонки (`first_name`/`last_name`) → `save()` падал 500. Изолировано тестом:
только `avatar_url` → 200; `{first_name:null,last_name:null}` → 500.

**Фикс (два уровня):**
- **Backend** (`users.service.update`): перед `Object.assign` отбрасываем null/undefined —
  корректная семантика PATCH (обновляем только переданные поля). Защищает всех клиентов.
- **Frontend** (`UpdateUserRequest`): `@JsonSerializable(includeIfNull: false)` — null-поля
  не сериализуются, для аватара уходит только `{avatar_url}`.

**Проверено:** PATCH с полным null-набором + avatar_url → 200, `first_name`/`last_name` НЕ
затёрты (остались «Валерьян»/«Русакова»), avatarUrl сохранён. Из браузера (свежая сборка,
SW-кэш сброшен): PATCH только avatar_url → 200. MinIO во всех проверках исправен
(upload 200, GET картинки 200 image/png, CORS ok, Image() loaded).

---

# План: Реализация флоу «Стать мастером» + скрытие кнопки для мастера

## Context

Пользователь прошёл флоу «стать мастером» на экране профиля, но кнопка осталась, и он не
стал мастером. Причина найдена: **фронтовый визард — заглушка**. `_completeProfileCreation()`
в `create_master_profile_screen.dart` только показывает диалог «Профиль создан!» и уходит
на `/` — НИКУДА не отправляет собранные данные. Поэтому `users.is_master` остался `false`,
записи `master_profiles` нет (проверено в БД: `is_master=f`, профиля нет). Кнопка уже
условная (`if (!user.isMaster)`) — она не исчезла лишь потому, что данные не сохранились.

Задача: реально подключить визард к backend, переработав бизнес-флоу под выбор
**категория (L0) → подкатегория (L1) → услуги**, с возможностью добавить вторую (и более)
категорию. После финализации мастер создаётся, услуги сохраняются, кнопка «Стать мастером»
исчезает.

Решения пользователя: (1) иерархия L0→L1→услуги; (2) минимальный объём — 4 UI-шага, но
реально слать step1-5 на бэк; (3) услуги создаются ПОСЛЕ финализации профиля.

## Что уже есть (переиспользуем)

**Backend — трогать НЕ нужно, всё готово:**
- `POST /masters` (init, setup_step=0) → `PATCH /masters/me/step/{1..5}` (последовательно,
  step5 ставит `is_master=true`, `master_profile_completed=true`, `is_active=true`).
- Step1 DTO: `category_ids: string[]` (L0/L1, обязательно), `subcategory_ids?: string[]`.
- `POST /services` (CreateServiceDto: `category_id`, `service_template_id?`, `name`, `price`,
  `duration_minutes`, ...) — требует `master_profile_completed=true` и `category_id ∈ profile.category_ids`.
  master_id берётся из токена.
- Категории: `GET /categories/tree?language=ru` (L0 с `children`=L1), шаблоны:
  `GET /categories/:id/templates`.

**Frontend — есть, но не подключено:**
- `MasterRepository` (`master_repository.dart`) на `DioClient` — добавить step-методы.
- `Step2Categories` уже собирает категории (FilterChip) + услуги (шаблоны/кастом) в
  `{category_ids, services[{category_id, service_template_id, name, price, duration}]}`.
- Провайдеры `categoriesTreeProvider`, `serviceTemplatesByCategoryIdProvider`,
  `authNotifierProvider` (профиль с `isMaster`). Модель `CreateServiceRequest` готова.

## Реализация

### 1. Backend: НЕТ изменений
Всё нужное уже реализовано. (Кнопка исчезнет сама после реального step5 + инвалидации
`authNotifierProvider` на фронте — `/users/me` возвращает актуальный `isMaster`.)

### 2. Frontend: репозиторий шагов мастера (`master_repository.dart`)
Добавить методы под каждый бэк-эндпоинт (все возвращают `MasterProfileModel`):
- `initMasterProfile()` → `POST /masters`
- `updateStep1({categoryIds, subcategoryIds})` → `PATCH /masters/me/step/1`
- `updateStep2({bio, ...})` → `PATCH /masters/me/step/2`
- `updateStep4Location({...})`, `updateStep5Schedule({...})` → step/4, step/5
  (step3 портфолио — слать пустым/скипать, но бэк требует последовательность setup_step,
   поэтому вызвать step3 с `{}` для перехода 2→3→4).
Добавить эндпоинты в `api_endpoints.dart`: `masterStep(n) => '/masters/me/step/$n'`.

### 3. Frontend: сервис-репозиторий создания услуг
Создать `service_repository.dart` (или добавить в существующий) метод
`createService(CreateServiceRequest)` → `POST /services`. Модель `CreateServiceRequest` уже
есть. Добавить `ApiEndpoints.serviceCreate` (уже есть).

### 4. Frontend: переработать Step2 под иерархию L0 → L1 → услуги
`step2_categories.dart`:
- Вместо плоского списка L1-FilterChip — блочный выбор: пользователь добавляет «блок
  категории»: выбирает L0 (dropdown/список корней `tree`), затем L1 (children выбранного L0),
  затем услуги этой L1 (шаблоны через `serviceTemplatesByCategoryIdProvider` + кастомные).
- Кнопка «Добавить ещё категорию» повторяет блок (несколько L0→L1→услуги).
- На выходе собирать: `category_ids` = уникальные L0, `subcategory_ids` = уникальные L1,
  `services[]` с `category_id` = L1 (важно: услуга привязана к L1, и L1 попадает в
  `subcategory_ids` — но бэк `POST /services` требует `category_id ∈ profile.category_ids`,
  а не subcategory_ids → **ВАЖНО:** в step1 слать в `category_ids` И L0, И L1 вместе, т.к.
  бэк валидирует их одинаково (level 0 или 1) и хранит в profile.category_ids; тогда
  `category_id` услуги (=L1) будет ∈ profile.category_ids). subcategory_ids дублируем L1.

### 5. Frontend: подключить финализацию (`create_master_profile_screen.dart`)
Заменить заглушку `_completeProfileCreation()` на реальную отправку (async, с лоадером и
обработкой ошибок через существующий `ApiExceptionHandler`):
1. `initMasterProfile()` (если профиля ещё нет; при «уже создан» — игнорировать/продолжить).
2. `updateStep1({category_ids: [...L0, ...L1], subcategory_ids: [...L1]})` из Step2-данных.
3. `updateStep2({bio})` из Step1(bio).
4. `updateStep3({})` — пустой, для последовательности setup_step.
5. `updateStep4Location({location_address, service_radius_km, is_mobile, ...})` из Step5-локации.
6. `updateStep5Schedule({working_hours, ...})` из Step4-расписания (сконвертировать
   `workingDays`(рус. дни→bool) + start/end в `working_hours` JSON вида
   `{monday: {start, end, enabled}, ...}`).
7. После step5 (профиль = мастер): для каждой услуги из `services[]` — `createService(...)`
   (сконвертировать `price`/`duration` из String в num). Ошибки отдельных услуг собирать,
   не прерывать весь флоу.
8. `ref.invalidate(authNotifierProvider)` + `ref.invalidate(currentUserProfileProvider)` →
   кнопка «Стать мастером» исчезнет. Показать успех, уйти на профиль/`/`.

### 6. Frontend: кнопка «Стать мастером» — проверка статуса
Уже `if (!user.isMaster)` в `profile_screen.dart`. Дополнительно: при возврате из визарда
экран профиля читает `authNotifierProvider` — после инвалидации (шаг 5.8) `isMaster=true`
скроет кнопку. Убедиться, что `authNotifierProvider` реально перечитывает `/users/me`.

## Verification

- **БД:** после прохождения визарда — `SELECT is_master, master_profile_completed,
  setup_step FROM users u JOIN master_profiles mp ... WHERE email=...` → `t, t, 5`; услуги
  в `services` с master_id=users.id, category_id ∈ profile.category_ids.
- **API (Python/JS из браузера):** прогнать init→step1..5→createService под тестовым
  не-мастером → 200 на каждом; GET /users/me → isMaster=true.
- **Chrome:** пройти визард (категория→подкатегория→услуги, + вторая категория), завершить →
  вернуться в профиль → кнопка «Стать мастером» исчезла, появился бейдж мастера; на вкладке
  «Услуги» профиля — созданные услуги; поиск находит мастера по услугам.
- `flutter analyze` + `npx tsc --noEmit` (бэк не меняется, но проверить) чисто; кодоген
  freezed для новых моделей запросов шагов.

## Риски
- Последовательность setup_step строгая: каждый следующий step проверяет предыдущий →
  вызывать строго по порядку, не параллельно.
- `POST /services` требует L1 category_id ∈ profile.category_ids → критично слать L1 в
  step1.category_ids (см. п.4).
- Повторный вход в визард уже созданного профиля: `POST /masters` вернёт «уже создан» —
  обработать (перейти к обновлению/пропустить init).

## Итог (ВЫПОЛНЕНО ✅)

Backend не менялся (всё было готово). Frontend:
- `api_endpoints.dart`: `masterStep(n)`.
- `master_repository.dart`: `initMasterProfile()`, `updateMasterStep(step, body)`.
- Новый `service_repository.dart`: `createService(CreateServiceRequest)` + провайдер.
  `CreateServiceRequest` получил `@JsonSerializable(includeIfNull: false)`.
- `step2_categories.dart` полностью переписан: блочный иерархический выбор
  L0 (dropdown корней) → L1 (dropdown children) → услуги L1 (шаблоны + кастом),
  кнопка «Добавить ещё категорию». TextFormField с initialValue (не пересоздаём
  контроллеры — чинит потерю курсора). На выходе: category_ids=(L0∪L1), subcategory_ids=L1,
  services[] с category_id=L1.
- `create_master_profile_screen.dart`: заглушка `_completeProfileCreation()` заменена на
  реальную отправку (ConsumerStatefulWidget): init → step1(категории) → step2(bio) →
  step3({}) → step4(локация) → step5(расписание, финализация) → создание услуг.
  Конвертация workingDays(рус)→working_hours JSON. Оверлей-лоадер, обработка ошибок,
  инвалидация authNotifierProvider+currentUserProfileProvider.

**Проверено end-to-end:**
- API (тестовый не-мастер sinklitikiya): init→step1..5→createService — все 200/201,
  isMaster→true, услуга с category_id=L1 ∈ category_ids.
- Chrome (ravinski123): пройден весь визард (Здоровье и массаж → Массаж → шаблон
  «Массаж головы» 2500₽ → расписание → адрес). Сетевые: POST /masters 201,
  step/1..5 все 200, POST /services 201, GET /users/me 200. Диалог «Профиль мастера
  создан!» → на профиле появился бейдж «✓ Мастер», кнопка «Стать мастером» ИСЧЕЗЛА.
- БД: is_master=t, master_profile_completed=t, setup_step=5, category_ids={L0,L1},
  услуга «Массаж головы» 2500₽. Поиск «Массаж головы» находит Gleb Ravinsky + услугу
  (автоиндексация). Консоль без ошибок.

**В бэклоге:** UI-поля шагов 2 (опыт, языки), 3 (портфолио/сертификаты), 4-5 доп.настройки
(auto_confirm, соцсети) — сейчас шлются дефолты/пусто; расширить при необходимости.

---

# План: Редактирование услуг мастера («Настройки → Редактировать услуги»)

## Context
В настройках вторым пунктом (после «Редактировать профиль») добавить «Редактировать услуги»
— экран управления услугами мастера с полным CRUD. Пункт виден только мастеру.

Решения пользователя: (1) полный CRUD — список + добавить + редактировать + удалить;
(2) форма услуги в bottom sheet; (3) категория новой услуги — только из L1-подкатегорий,
уже выбранных в профиле мастера (бэк требует category_id ∈ profile.category_ids).

## Что уже есть (переиспользуем)
**Backend — готов полностью, НЕ меняем:**
- `GET /services/my` (пагинация), `POST /services`, `PATCH /services/:id`,
  `PATCH /services/:id/deactivate|activate`, `DELETE /services/:id`. Все проверяют
  владельца (`service.master_id === user.id`).
**Frontend:**
- `api_endpoints`: services, serviceById, serviceCreate, serviceUpdate(id), serviceDelete(id),
  masterServices(id). Добавить: serviceActivate/serviceDeactivate — НЕ нужно (полный CRUD
  без вкл/выкл по решению; см. вопрос — выбран «Полный CRUD», без активности).
- `service_repository.createService()` есть. Модели `CreateServiceRequest`,
  `UpdateServiceRequest`, `ServiceModel` — есть.
- `masterServicesProvider(userId)` — список услуг (переиспользуем, инвалидируем после мутаций).
- `MasterProfileModel.subcategoryIds` (L1) + `categoriesTreeProvider` — источник выбора
  категории для новой услуги. `getMyMasterProfile()` в master_repository.

## Реализация

### 1. Frontend: репозиторий — дополнить методы
`service_repository.dart`:
- `updateService(id, UpdateServiceRequest)` → `PATCH /services/:id`
- `deleteService(id)` → `DELETE /services/:id`
(createService уже есть.)

### 2. Frontend: провайдер «мои услуги» для управления
Переиспользовать `masterServicesProvider(userId)`. После create/update/delete —
`ref.invalidate(masterServicesProvider(userId))` (+ таб профиля обновится).

### 3. Frontend: экран `manage_services_screen.dart`
- `ConsumerStatefulWidget`. В initState грузит профиль (`getMyMasterProfile`) для доступа
  к subcategoryIds; список услуг — `masterServicesProvider(user.id)`.
- Список карточек услуг (название, цена, длительность) с действиями: тап/иконка «редактировать»
  → bottom sheet редактирования; иконка «удалить» → confirm-диалог → deleteService.
- FAB/кнопка «+ Добавить услугу» → bottom sheet создания.
- Пустое состояние: «Нет услуг» + подсказка.

### 4. Frontend: bottom sheet формы услуги `_ServiceFormSheet`
- Поля: название (обяз.), цена ₽ (обяз., число), длительность мин (обяз., число),
  описание (опц.). Для НОВОЙ услуги — dropdown выбора подкатегории (L1) из
  profile.subcategoryIds с названиями из дерева; для редактирования категорию не меняем.
- Валидация; кнопка «Сохранить». По submit:
  - создание → `createService(CreateServiceRequest(categoryId: L1, name, price, durationMinutes, description))`
  - редактирование → `updateService(id, UpdateServiceRequest(name, price, durationMinutes, description))`
- Использовать TextFormField с initialValue (не пересоздавать контроллеры).
- После успеха: закрыть sheet, инвалидировать `masterServicesProvider`, snackbar.

### 5. Frontend: роут + пункт настроек
- Роут `manage-services` в `app_router.dart` → `ManageServicesScreen`.
- В `settings_screen.dart` вторым пунктом (после «Редактировать профиль») — ListTile
  «Редактировать услуги» (иконка work_outline), видим только если
  `authState.user.isMaster`; onTap → `context.push('/manage-services')`.
- `api_endpoints`: методы уже есть (serviceUpdate/serviceDelete).

## Verification
- API: под мастером create→update→delete услуги → 201/200/200; список отражает изменения.
- Chrome (мастер ravinski123): Настройки → «Редактировать услуги» → список (Массаж головы);
  добавить услугу через sheet → появилась; отредактировать цену → обновилась; удалить →
  исчезла. Таб «Мои услуги» на профиле синхронно обновляется. Пункт «Редактировать услуги»
  НЕ виден у не-мастера.
- `flutter analyze` чисто; кодоген (если тронем модели — здесь не нужен).

## Риски
- `POST /services`: category_id обязан быть ∈ profile.category_ids (L1). Берём из
  subcategoryIds профиля → безопасно.
- includeIfNull:false у Create/UpdateServiceRequest — проверить, что UpdateServiceRequest
  тоже не шлёт null (иначе PATCH затрёт поля). Если нет — добавить.

## Итог (ВЫПОЛНЕНО ✅)

**Backend — найден и исправлен баг проверки владельца:** в `services.service.ts`
`update`/`deactivate`/`activate` сравнивали `service.master_id !== masterProfile.id`,
но `service.master_id` = **users.id** (см. CLAUDE.md, как в `create`/`remove`). Из-за
этого UPDATE любой своей услуги давал 403. Исправлено на `!== userId`. `tsc` → 0.

**Frontend:**
- `service_model.dart`: `UpdateServiceRequest` получил `@JsonSerializable(includeIfNull: false)`.
- `service_repository.dart`: добавлены `updateService(id, req)`, `deleteService(id)`.
- Новый экран `manage_services_screen.dart`: список услуг + FAB «Добавить услугу»;
  карточки с иконками редактировать/удалить; bottom sheet `_ServiceFormSheet` (создание/
  редактирование: название, цена, время, описание; для новой — dropdown подкатегории из
  profile.subcategoryIds ∩ дерево). Удаление через confirm-диалог. Инвалидация
  `masterServicesProvider` после мутаций → таб «Мои услуги» на профиле обновляется.
- Роут `manage-services`; пункт «Редактировать услуги» вторым в «Настройки → Аккаунт»,
  виден только мастеру.
- **Фикс видимости пункта:** `isMaster` берётся из `currentUserProfileProvider` (свежий
  /users/me), т.к. auth-state может отставать после становления мастером в сессии.

**Проверено end-to-end (API + Chrome, мастер ravinski123):**
- API: create→update→delete под мастером → 201/200/200 (после фикса владельца).
- Chrome: Настройки → «Редактировать услуги» → список; редактирование (2500→2800 ₽) →
  обновилось; добавление «Спортивный массаж» 3200 ₽ (подкатегория Массаж) → снекбар
  «Услуга добавлена», появилась; удаление → confirm → «Услуга удалена», исчезла.
  Консоль без ошибок.

---

# Фикс: клиент не может отменить неподтверждённую запись

## Симптом
В роли клиента отмена записи в статусе «Ожидание» (pending) не срабатывала.

## Диагноз (воспроизведено через API)
Несоответствие имени поля причины отмены:
- Фронт `CancelBookingRequest` слал `{reason: ...}`.
- Бэк `CancelBookingDto` ждёт `{cancellation_reason: ...}` (@IsString, MinLength 5).
Из-за `ValidationPipe` + `forbidNonWhitelisted` → 400: «property reason should not exist»,
«cancellation_reason must be a string». Проверено: с `{cancellation_reason}` → 200, cancelled.

## Решение (ВЫПОЛНЕНО ✅)
- `booking_model.dart`: `CancelBookingRequest.reason` → `@JsonKey(name: 'cancellation_reason')`.
- `bookings_screen.dart`: причина короче 5 символов (в т.ч. пустая) → дефолт «Отменено
  клиентом» (бэк требует мин. 5). Кодоген + сборка.

**Проверено (Chrome, клиент client@test.com):** отмена pending-записи →
`POST /bookings/:id/cancel` 200, снекбар «Запись отменена», запись исчезла из «Предстоящие».
Консоль без ошибок.

---

# Фикс: мастер не может завершить подтверждённую запись

## Диагноз (воспроизведено через API)
Разрыв в бизнес-флоу статусов. Бэк completeBooking требовал статус IN_PROGRESS, но перевести
туда нельзя: эндпоинт /bookings/:id/start НЕ зарегистрирован в контроллере (метод в сервисе
есть, HTTP-роута нет → 404), а на фронте у confirmed-записи только кнопка «Завершить».
Итог: complete на confirmed → 400 «Можно завершить только бронирование в процессе».

## Решение (ВЫПОЛНЕНО ✅) — «завершать confirmed напрямую»
bookings.service.completeBooking: проверка `!== IN_PROGRESS` заменена на «разрешено
CONFIRMED или IN_PROGRESS». Фронт не менялся. tsc → 0.

Проверено (API + Chrome, master@test.com): complete на confirmed → 200 completed; в UI
запись уходит из «Подтверждённые» в «Историю». Консоль без ошибок.

Бэклог: мёртвый startBooking + отсутствующий /start роут — удалить или дорегистрировать.

---

# План: Интерфейс отзывов (клиент обязателен, мастер добровольно)

## Context
Клиент должен оставить обязательный отзыв о завершённой услуге; мастер может (не обязан)
оставить отзыв о клиенте. Backend отзывов ПОЛНОСТЬЮ готов — менять НЕ нужно. На фронте
не хватает главного: экрана/формы создания отзыва. Кнопка «Оставить отзывы» сейчас ведёт
в никуда (context.go('/')).

Решения пользователя: (1) обязательность = блокировка новой записи (уже на бэке);
(2) отзыв мастера о клиенте — добровольный; (3) форма = звёзды 1-5 + комментарий.

## Что уже есть (переиспользуем, НЕ трогаем backend)
**Backend (готов):**
- `POST /reviews` (CreateReviewDto: booking_id, rating 1-5, comment 10-1000 опц., photo_urls опц.).
  Только на COMPLETED booking; определяет направление по client_id/master_id; ставит
  client_review_left/master_review_left; ConflictException если уже оставлен.
- `PendingReviewsGuard` на `POST /bookings` — блокирует новую запись КЛИЕНТА, если есть
  завершённые без его отзыва (403 PENDING_REVIEW_REQUIRED / 400 UNREVIEWED_BOOKINGS_EXIST).
  Мастера НЕ блокирует (его отзыв добровольный — уже так).
- `GET /reviews/unreviewed/bookings`, `POST /reviews/skip/:id` (grace period).
- `GET /reviews?reviewed_user_id=` — отзывы пользователя.

**Frontend (готов):** `ReviewModel`, `CreateReviewRequest`, `UnreviewedBooking`,
`ReviewRemindersRepository` (getUnreviewedBookings/skipReview), `MasterRepository.getMasterReviews`,
`masterReviewsProvider`, `ReviewCard`, вкладка «Отзывы» на профиле мастера,
`UnreviewedBookingsDialog`, `UnreviewedBookingsException` (ловится в master_profile_screen).

**Frontend (НЕ хватает):** метод createReview в репозитории; экран/шит формы отзыва;
навигация к нему; связка кнопок «Оставить отзыв» в bookings-истории и в диалоге напоминания.

## Реализация (только frontend)

### 1. Репозиторий: создание отзыва
Создать `review_repository.dart` (или добавить в существующий) метод
`createReview(CreateReviewRequest)` → `POST /reviews` (эндпоинт reviewCreate уже есть).
Провайдер `reviewRepositoryProvider`. `CreateReviewRequest` уже готов.

### 2. Форма отзыва — bottom sheet `ReviewFormSheet`
Параметры: bookingId, имя того-кого-оцениваем, направление (для заголовка «Оцените мастера»/
«Оцените клиента»). Поля: интерактивные звёзды 1-5 (обязательно), TextField комментарий
(опц., но если введён — 10-1000 символов, как требует бэк; подсказать лимит). Кнопка
«Отправить». По submit → createReview → при успехе закрыть, снекбар, инвалидировать
myBookingsProvider (обновить clientReviewLeft) + masterReviewsProvider(reviewedUserId).
Обработка ConflictException (уже оставлен) — мягко закрыть.

### 3. Экран «Записи» (bookings_screen): кнопка «Оставить отзыв»
Во вкладке «История» (completed) для КЛИЕНТА: если `!booking.clientReviewLeft` и
status==completed → кнопка «Оставить отзыв» (акцентная) → открывает ReviewFormSheet
(направление: отзыв о мастере). Для МАСТЕРА (режим «Мастер», completed): если
`!booking.masterReviewLeft` → кнопка «Оценить клиента» (вторичная, т.к. добровольно).
После отзыва кнопка исчезает (флаг стал true).

Использовать существующие поля BookingModel.clientReviewLeft/masterReviewLeft (сейчас не
используются в UI — задействовать).

### 4. Диалог напоминания: связать «Оставить отзывы» с формой
`UnreviewedBookingsDialog` action `leaveReviews` сейчас → context.go('/'). Изменить:
после закрытия диалога открывать ReviewFormSheet по первому/каждому неотзывленному
booking (данные есть в UnreviewedBooking: id, reviewTarget, reviewTargetName, isClient).
Так клиент реально оставит отзыв и разблокирует создание записи. После всех отзывов —
можно повторить создание записи (флоу уже есть в master_profile_screen).

### 5. Баннер-напоминание на экране «Записи» (мягкое обязательное)
Опционально-желательно: на вкладке «История»/сверху, если есть неотзывленные (клиент) —
заметный баннер «У вас N записей без отзыва» с кнопкой, открывающей форму. Дополняет
жёсткую блокировку при создании записи (чтобы клиент видел до попытки записаться).

## Verification
- API: под клиентом с completed-записью POST /reviews {booking_id, rating, comment} → 201;
  повторно → 409. GET /reviews?reviewed_user_id=master → отзыв виден. После отзыва
  POST /bookings больше не блокируется.
- Chrome (клиент): «Записи»→«История»→«Оставить отзыв»→звёзды+коммент→отправка→кнопка исчезла;
  отзыв виден на профиле мастера (вкладка «Отзывы»); новая запись создаётся без блокировки.
- Chrome (мастер): completed-запись → «Оценить клиента» (добровольно) → отзыв создаётся;
  без отзыва мастер НЕ заблокирован в создании своих записей.
- flutter analyze + кодоген (review_repository.g.dart) чисто.

## Риски
- Комментарий: бэк требует 10-1000 символов ЕСЛИ передан. Пустой не слать (null), короткий —
  валидировать на фронте до отправки.
- Направление в форме: определять по роли/isClient, не по угадыванию.
- Rating обязателен (1-5) — не давать отправить с 0 звёзд.


## Итог (04.07.2026): Интерфейс отзывов — РЕАЛИЗОВАНО и проверено e2e

**Frontend:**
- `review_repository.dart` — POST /reviews; `review_form_sheet.dart` — форма (звёзды 1–5 обяз., комментарий ≥10 симв. опц., 409 закрывает форму по statusCode).
- `bookings_screen.dart` — кнопки «Оставить отзыв» (клиент) / «Оценить клиента» (мастер) на completed-записях + баннер «У вас N записей без отзыва» с открытием формы.
- `master_profile_screen.dart` — ветка leaveReviews диалога открывает ReviewFormSheet по каждой неотзывленной записи и авто-повторяет создание записи.
- `unreviewed_bookings_dialog.dart` — добавлен явный текст: создание записи недоступно до отзыва, кнопка открывает форму.
- **`dio_client.dart` — КЛЮЧЕВОЙ ФИКС:** validateStatus был `< 500`, из-за чего 4xx не становились исключениями: ошибки парсились как успех (ложные «Запись создана»/«Запись отменена»), не работали RefreshTokenInterceptor (401) и ErrorHandlerInterceptor. Теперь `< 400`.
- `api_exceptions.dart` — 403 `PENDING_REVIEW_REQUIRED` (PendingReviewsGuard) мапится в UnreviewedBookingsException (раньше только 400 UNREVIEWED_BOOKINGS_EXIST → диалог не показывался).
- `unreviewed_booking.dart` — total_price приходит строкой, парсинг сделан толерантным (падал fromJson → диалог не открывался).

**Backend (найденные и исправленные баги):**
- `config/entities.ts` — ReviewReminder не был зарегистрирован в DataSource → каждый POST /reviews падал 500 (EntityMetadataNotFoundError в clearReminder) уже ПОСЛЕ создания отзыва.
- `review.entity.ts` + миграция `1783500000000-ReviewUniquePerReviewerType` — UNIQUE(booking_id) → UNIQUE(booking_id, reviewer_type): раньше второй отзыв (мастера о клиенте) на ту же запись падал 500.
- `bookings.service.ts` — правило «нельзя отменить менее чем за 1 час» теперь только для CONFIRMED: pending-заявку клиент отменяет всегда (просроченные записи 29–30 июня были неотменяемыми навсегда).
- Восстановлена таблица `review_reminders` (миграция значилась применённой, таблицы не было — запись удалена из `migrations`, миграция перекатана).

**Проверено:** API (201/409/403-блокировка/разблокировка после отзыва, отзыв мастера 201, отмена просроченной pending 200) + Chrome e2e (баннер, кнопка в Истории, диалог блокировки с формой, авто-создание записи после отзыва, отзыв виден на профиле мастера). flutter analyze чисто; 5 падающих тестов auth/chat существовали на main до задачи.
