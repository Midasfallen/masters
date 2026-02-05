# План: Поиск по мастерам, категориям и услугам с табами

**Дата:** 5 февраля 2026  
**Статус:** Реализовано (февраль 2026)  
**Связано:** [CATEGORIES_MIGRATION_PLAN.md](CATEGORIES_MIGRATION_PLAN.md), Meilisearch (service_meilisearch)

---

## 1. Цель

- Поиск должен выполняться по **трём типам сущностей**: мастера, категории, услуги.
- Результаты отображать в **табах**: «Мастера», «Услуги», «Категории».
- Показывать **только те табы, в которых есть результаты** (например, по запросу «Кра» — таб «Мастера» с Красновой, «Категории» с Красотой, «Услуги» с Окрашиванием).
- **Ограничить объём результатов**, чтобы не перегружать запросы и UI (не тысячи записей).

---

## 2. Текущее состояние (после реализации)

| Компонент | Сейчас |
|-----------|--------|
| **Backend** | `GET /search/all?q=...&limit=10` (агрегат), `GET /search/masters`, `GET /search/services`, `GET /search/templates`. Meilisearch: индексы `masters`, `services`, `service_templates`, **`categories`** (L0/L1 с переводами). Поиск по категориям через `searchCategories()`, переиндексация при изменении категорий/переводов. |
| **Frontend** | Один запрос к `/search/all`, экран с **табами** «Мастера» \| «Услуги» \| «Категории» (только непустые). Виджет `SearchResultsTabs`, провайдер `searchAllProvider`. |
| **Лимиты** | В агрегате: `limit` по умолчанию 10 на каждый тип (1–50). Отдельные эндпоинты masters/services: до 100. |

---

## 3. Ограничения и риски

- **Большой объём результатов**: без лимитов запрос может вернуть тысячи записей и нагрузить Meilisearch/сеть. Нужны разумные лимиты по умолчанию (например, 10–20 на тип для экрана с табами).
- **Meilisearch**: используется контейнер `service_meilisearch` (например, id `3641fffec19d`). При добавлении индекса категорий нужно обеспечить переиндексацию при изменении категорий/переводов.
- **MCP / субагенты**: при необходимости проверки здоровья Meilisearch, просмотра индексов или отладки можно использовать MCP-инструменты и субагентов с доступом к сервису (например, к контейнеру service_meilisearch).

---

## 4. Архитектурный совет: Агрегированный эндпоинт vs 3 запроса

**Рекомендация: реализовать агрегированный эндпоинт `GET /search/all?q=...`.**

| Критерий | Агрегированный эндпоинт | Три параллельных запроса |
|----------|-------------------------|---------------------------|
| **Атомарность UI** | Фронт получает один объект и сразу знает, какие табы рисовать. Нет «дёрганья», когда один запрос пришёл быстро, а другой задерживается. | Разная скорость ответов → табы появляются по очереди. |
| **Ресурсы** | Один HTTP-запрос вместо трёх: меньше нагрузка на мобильную сеть и меньше задержка (RTT). | Три RTT, три соединения. |
| **Логика на фронте** | Один ответ — один раз обработать. Не нужны `Future.wait` и обработка частичных ошибок (мастера нашлись, а категории «упали»). | Нужна координация и fallback при частичном сбое. |

Итог: в плане закладываем **один эндпоинт** `GET /search/all?q=...&limit=10` (или `limit_per_type`), возвращающий объект с тремя массивами.

---

## 5. План реализации

### 5.1 Backend

- [x] **SearchAggregationDto**
  - DTO: `masters`, `services`, `categories`, `query`, `processing_time_ms`. Файл: `backend/src/modules/search/dto/search-response.dto.ts`. Также `SearchAllDto` в `search-all.dto.ts`, `CategorySearchResultDto` в `search-response.dto.ts`.
- [x] **Агрегированный эндпоинт**
  - `GET /search/all?q=...&limit=10&language=ru`. В `SearchService.searchAll()` — **Promise.all** по трём индексам, ответ одним объектом. Контроллер: `SearchController.searchAll()`.
- [x] **Поиск по категориям**
  - Метод `SearchService.searchCategories()` по индексу `categories` (L0/L1). Отдельный эндпоинт `GET /search/categories` не добавлен — для табов достаточно агрегата.
- [x] **Лимиты**
  - В агрегате: параметр `limit` (1–50), по умолчанию 10 на каждый тип.

### 5.2 Meilisearch: индекс `categories`

- [x] **Searchable Attributes (порядок = приоритет)**
  1. `name` — название.
  2. `keywords_text` — из переводов (массив keywords в строку).
  3. `slug`.
- [x] **Filterable Attributes**
  - `level`, `language`.
- [x] **Структура документа**
  - Документ на пару (категория + язык): `id` = `categoryId_language`, `category_id`, `name`, `slug`, `level`, `parent_id`, `language`, `keywords_text`, `display_order`. Настройка в `SearchService.onModuleInit()`.

### 5.3 Синхронизация категорий с Meilisearch

- [x] **Синхронизация переводов**
  - При create/update/move категории вызывается `SearchService.reindexCategory(id)`. При удалении — `deleteCategoryFromIndex(id)`. `CategoriesModule` импортирует `SearchModule`, в `CategoriesService` инжектирован `SearchService`.

### 5.4 Highlighting (подсветка совпадений)

- [x] **Meilisearch `_formatted`**
  - В `searchCategories()` запрос с `attributesToHighlight`, `highlightPreTag`/`highlightPostTag`. В DTO категории поле `name_highlighted` (из `_formatted.name`). На фронте модель поддерживает `nameHighlighted` (пока в карточке категории выводится обычное `name`).

### 5.5 Кэширование (опционально)

- [ ] **Redis для популярных запросов**
  - Не реализовано. При необходимости можно кэшировать ответы `GET /search/all` для коротких запросов с TTL 1–5 мин (Redis уже в проекте).

### 5.6 Frontend (Flutter)

- [x] **Один запрос на агрегированный эндпоинт**
  - Провайдер `searchAllProvider(query: query)` в `frontend/lib/core/providers/api/search_provider.dart`. Репозиторий: `SearchRepository.searchAll()`.
- [x] **Динамические табы**
  - `SearchResultsTabs` с **TabController**: список табов строится только из непустых списков (Мастера / Услуги / Категории).
- [x] **Виджет SearchResultsTabs**
  - `frontend/lib/features/search/widgets/search_results_tabs.dart` — принимает `SearchAggregationModel`, рендерит только непустые табы.
- [x] **Отображение**
  - Мастера: карточка (аватар, имя, рейтинг, описание, адрес), переход на `/master/:id`. Услуги: название, цена, длительность, мастер, переход на профиль мастера. Категории: название, slug, переход на `/search/category/:id` с `extra: categoryName`.
- [x] **Пустое состояние**
  - Если все три массива пусты — «Ничего не найдено» с предложением изменить запрос (`SearchScreen._buildEmptyState`).

### 5.7 Тестирование и MCP (Meilisearch)

- [ ] **Проверка индекса через MCP**
  - При отладке: *«Используй MCP, чтобы проверить индекс categories в Meilisearch и searchableAttributes»*. Контейнер: `service_meilisearch`.
- [ ] **Тестовый поиск через API**
  - *«Выполни тестовый поиск через Meilisearch API для запроса "Кра"»*.
- [ ] **Ручные сценарии**
  - Запрос «Кра» → табы с результатами, только непустые; лимит на тип соблюдается.

---

## 6. Рекомендуемые лимиты по умолчанию (экран с табами)

| Тип       | Рекомендуемый limit |
|----------|----------------------|
| Мастера  | 10–20                |
| Услуги   | 10–20                |
| Категории| 10–20                |

При необходимости в каждом табе можно добавить кнопку «Показать ещё» или переход на полный список с пагинацией (отдельный экран или увеличенный `limit`).

---

## 7. Зависимости

- Текущая архитектура поиска (Meilisearch, fallback на БД) — без изменений концепции.
- Категории: структура L0/L1 и переводы в `categories` + `category_translations` (уже есть в проекте).
- MCP: при отладке — доступ к `service_meilisearch` (контейнер 3641fffec19d) для проверки индексов и логов.

---

## 8. Чеклист перед стартом

- [x] Убедиться, что Meilisearch (service_meilisearch) поднят и доступен.
- [x] Индекс категорий: только L0/L1 (шаблоны остаются в `service_templates`).
- [x] Согласовать лимиты по умолчанию с продуктом: **принято** 10 на тип, макс. 50.

---

## 9. Чеклист для Cursor (Dev-tips)

- [x] **SearchAggregationDto** — в `backend/src/modules/search/dto/search-response.dto.ts`.
- [x] **Promise.all** в `SearchService.searchAll()` — запросы к masters, services, categories.
- [x] **Синхронизация** — `reindexCategory()` / `deleteCategoryFromIndex()` вызываются из `CategoriesService` при create/update/move/remove.
- [x] **Frontend** — провайдер `searchAllProvider`, виджет `SearchResultsTabs`, экран `SearchScreen` переведён на один запрос к `GET /search/all`.

---

## 10. Реализованные файлы (справочно)

| Назначение | Путь |
|------------|------|
| DTO агрегата и категории | `backend/src/modules/search/dto/search-response.dto.ts`, `search-all.dto.ts` |
| Контроллер поиска | `backend/src/modules/search/search.controller.ts` (GET `all`) |
| Сервис поиска | `backend/src/modules/search/search.service.ts` (categories index, reindexCategories, searchCategories, searchAll) |
| Синхронизация категорий | `backend/src/modules/categories/categories.service.ts`, `categories.module.ts` |
| Модели и API фронта | `frontend/lib/core/models/api/search_aggregation_model.dart`, `api_endpoints.dart` |
| Репозиторий и провайдер | `frontend/lib/core/repositories/search_repository.dart`, `search_provider.dart` |
| Табы и экран | `frontend/lib/features/search/widgets/search_results_tabs.dart`, `screens/search_screen.dart` |

---

## 11. Полный отчёт о выполнении

### 11.1 Цели и результат

| Цель | Статус |
|------|--------|
| Поиск по трём типам сущностей: мастера, категории, услуги | Выполнено |
| Результаты в табах «Мастера», «Услуги», «Категории» | Выполнено |
| Показывать только табы с непустыми результатами | Выполнено |
| Ограничение объёма результатов (лимит на тип) | Выполнено: 10 по умолчанию, макс. 50 |

### 11.2 Реализованный функционал

**Backend (NestJS)**  
- Агрегированный эндпоинт **GET /api/v2/search/all**: параметры `q`, `limit` (1–50), `language`. Ответ: `{ masters, services, categories, query, processing_time_ms }`. Внутри — три запроса к Meilisearch через **Promise.all**.  
- Индекс Meilisearch **categories**: документы по парам (категория + язык), searchable: `name`, `keywords_text`, `slug`; filterable: `level`, `language`. Переиндексация при старте и при изменении/удалении категории в БД.  
- Поиск по категориям с подсветкой совпадений (`name_highlighted` из `_formatted`).  
- Синхронизация: при create/update/move категории вызывается `reindexCategory(id)`, при remove — `deleteCategoryFromIndex(id)`.

**Frontend (Flutter)**  
- Один запрос к **/api/v2/search/all** при вводе запроса; провайдер **searchAllProvider**, репозиторий **SearchRepository.searchAll()**.  
- Виджет **SearchResultsTabs**: динамические табы (только непустые списки), TabController, карточки мастеров/услуг/категорий с переходами на профиль мастера и экран категории.  
- Пустое состояние: «Ничего не найдено» при пустых всех трёх массивах.

### 11.3 API и контракты

- **Эндпоинт:** `GET /api/v2/search/all?q=<запрос>&limit=10&language=ru`  
- **Ответ:** JSON с полями `masters` (массив MasterSearchResultDto), `services` (ServiceSearchResultDto[]), `categories` (CategorySearchResultDto[]), `query` (string), `processing_time_ms` (number).  
- **Лимиты:** согласовано с продуктом: 10 на тип по умолчанию, максимум 50 на тип.

### 11.4 Тестирование

**E2E (backend)**  
- Файл: `backend/test/search.e2e-spec.ts`.  
- Добавлен блок **GET /search/all**:  
  - тест «should return aggregated masters, services, categories» — проверка структуры ответа и соблюдения лимита (не более `limit` элементов в каждом массиве);  
  - тест «should return empty arrays for empty query» — при пустом `q` возвращаются пустые массивы и `query: ''`.  
- Все 7 тестов SearchController (e2e) проходят: templates (3), masters (1), services (1), **search/all (2)**.  
- Исправлен существующий тест шаблонов: запрос с параметром `query=` вместо `q=` (из-за `forbidNonWhitelisted`).

**Ручная проверка**  
- При запущенном бэкенде запрос `GET http://localhost:3000/api/v2/search/all?q=Кра&limit=10` возвращает 200 и корректный агрегат (masters, services, categories).  
- Ручная проверка UI (ввод запроса в поиске, появление табов и переходы) рекомендуется выполнить локально (`flutter run -d chrome` при поднятом API).

### 11.5 Изменённые и добавленные файлы

| Компонент | Файлы |
|-----------|--------|
| Backend DTO | `search-response.dto.ts` (CategorySearchResultDto, SearchAggregationDto), `search-all.dto.ts` |
| Backend controller | `search.controller.ts` — метод GET `all` |
| Backend service | `search.service.ts` — индекс categories, reindexCategories, reindexCategory, deleteCategoryFromIndex, searchCategories, searchAll |
| Backend module | `search.module.ts` — CategoryTranslation; `categories.module.ts` — импорт SearchModule; `categories.service.ts` — вызовы SearchService |
| Frontend модели | `search_aggregation_model.dart` (freezed + .g.dart) |
| Frontend API | `api_endpoints.dart` — searchAll; `search_repository.dart` — searchAll() |
| Frontend провайдер | `search_provider.dart` — searchAllProvider |
| Frontend UI | `search_results_tabs.dart`, `search_screen.dart` |
| Тесты | `search.e2e-spec.ts` — два теста для GET /search/all, правка теста templates |

### 11.6 Что не реализовано (по плану опционально)

- Кэширование ответов поиска в Redis для популярных запросов.  
- Отдельный эндпоинт GET /search/categories с пагинацией (для табов достаточно агрегата).  
- Вывод подсвеченного названия категории (`name_highlighted`) в карточке на фронте (поле в модели есть, в UI пока выводится обычное `name`).

### 11.7 Итог

Поиск на странице поиска выполняется по мастерам, категориям и услугам с отображением результатов в табах (только непустые) и лимитом на тип. Лимиты согласованы (10 на тип, макс. 50). E2E-тесты для агрегированного эндпоинта добавлены и проходят.

**План выполнен.** Все обязательные пункты реализованы; опциональное кэширование в Redis и доработка отображения подсветки на фронте остаются на усмотрение команды.
