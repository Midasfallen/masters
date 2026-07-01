import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { MeiliSearch } from 'meilisearch';
import { User } from '../users/entities/user.entity';
import { MasterProfile } from '../masters/entities/master-profile.entity';
import { Service } from '../services/entities/service.entity';
import { ServiceTemplate } from '../service-templates/entities/service-template.entity';
import { ServiceTemplateTranslation } from '../service-templates/entities/service-template-translation.entity';
import { Category } from '../categories/entities/category.entity';
import { CategoryTranslation } from '../categories/entities/category-translation.entity';
import { SearchMastersDto } from './dto/search-masters.dto';
import { SearchServicesDto } from './dto/search-services.dto';
import { SearchTemplatesDto } from './dto/search-templates.dto';
import { SearchAllDto } from './dto/search-all.dto';
import { SearchUsersDto } from './dto/search-users.dto';
import {
  MasterSearchResultDto,
  ServiceSearchResultDto,
  ServiceTemplateSearchResultDto,
  CategorySearchResultDto,
  UserSearchResultDto,
  SearchAggregationDto,
  SearchResponseDto,
} from './dto/search-response.dto';

@Injectable()
export class SearchService implements OnModuleInit {
  private meiliClient: MeiliSearch;
  private mastersIndex;
  private servicesIndex;
  private serviceTemplatesIndex;
  private categoriesIndex;
  private usersIndex;

  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(MasterProfile)
    private readonly masterProfileRepository: Repository<MasterProfile>,
    @InjectRepository(Service)
    private readonly serviceRepository: Repository<Service>,
    @InjectRepository(ServiceTemplate)
    private readonly serviceTemplateRepository: Repository<ServiceTemplate>,
    @InjectRepository(ServiceTemplateTranslation)
    private readonly serviceTemplateTranslationRepository: Repository<ServiceTemplateTranslation>,
    @InjectRepository(Category)
    private readonly categoryRepository: Repository<Category>,
    @InjectRepository(CategoryTranslation)
    private readonly categoryTranslationRepository: Repository<CategoryTranslation>,
  ) {
    // Инициализация Meilisearch клиента
    this.meiliClient = new MeiliSearch({
      host: process.env.MEILISEARCH_HOST || 'http://localhost:7700',
      apiKey: process.env.MEILISEARCH_API_KEY || 'masterKey',
    });
  }

  async onModuleInit() {
    // ⚠️ ВАЖНО: Очистка индексов при первом деплое нового кода
    // Это исключит появление старых данных категорий level 2 в результатах поиска
    try {
      // Удаляем ВСЕ старые индексы, чтобы при re-seed не оставалось устаревших данных
      try {
        await this.meiliClient.deleteIndex('masters');
        await this.meiliClient.deleteIndex('services');
        await this.meiliClient.deleteIndex('service_templates');
        await this.meiliClient.deleteIndex('categories');
        await this.meiliClient.deleteIndex('users');
        console.log('✅ Old Meilisearch indices deleted');
      } catch (deleteError) {
        // Индексы могут не существовать при первом запуске - это нормально
        console.log('ℹ️  Indices do not exist yet (first run)');
      }

      // Создаем новые индексы
      this.mastersIndex = this.meiliClient.index('masters');
      this.servicesIndex = this.meiliClient.index('services');
      this.serviceTemplatesIndex = this.meiliClient.index('service_templates');

      // Настройка searchable и filterable атрибутов для мастеров
      await this.mastersIndex.updateSettings({
        // ВАЖНО: category_names НЕ входит в searchableAttributes намеренно.
        // Категория профиля («Здоровье и массаж») — широкая область мастера, а не его
        // услуга. Матч по названию категории давал ложные результаты (мастер без услуги
        // «массаж» находился по слову «массаж» из категории). Мастера ищем по названиям
        // его услуг (service_names), имени/фамилии и описанию. Категории как отдельная
        // сущность ищутся в индексе `categories` (вкладка «Категории»).
        searchableAttributes: [
          'first_name',
          'last_name',
          'description',
          'tags',
          'service_names',
        ],
        filterableAttributes: [
          'id',
          'category_ids',
          'average_rating',
          'is_active',
          'location_lat',
          'location_lng',
        ],
        sortableAttributes: ['average_rating', 'reviews_count'],
      });

      // Настройка для услуг
      await this.servicesIndex.updateSettings({
        searchableAttributes: ['name', 'description', 'tags', 'category_name'],
        filterableAttributes: [
          'category_id',
          'service_template_id',
          'price',
          'duration_minutes',
          'is_active',
          'master_id',
        ],
        sortableAttributes: ['price', 'duration_minutes', 'bookings_count'],
      });

      // Настройка для шаблонов услуг
      await this.serviceTemplatesIndex.updateSettings({
        searchableAttributes: [
          'name',
          'description',
          'keywords_text',
          'keywords',
        ],
        filterableAttributes: [
          'category_id',
          'is_active',
          'default_duration_minutes',
          'default_price_range_min',
          'default_price_range_max',
        ],
        sortableAttributes: ['display_order', 'name'],
      });

      // Индекс категорий (L0/L1): name, keywords, slug; filterable level
      this.categoriesIndex = this.meiliClient.index('categories');
      await this.categoriesIndex.updateSettings({
        searchableAttributes: ['name', 'keywords_text', 'slug'],
        filterableAttributes: ['level', 'language'],
        sortableAttributes: ['level', 'display_order', 'name'],
      });

      // Индекс пользователей (для поиска при создании чата)
      this.usersIndex = this.meiliClient.index('users');
      await this.usersIndex.updateSettings({
        searchableAttributes: ['first_name', 'last_name', 'email'],
        filterableAttributes: ['is_master', 'is_verified', 'is_active'],
        sortableAttributes: ['first_name', 'last_name'],
      });

      // Переиндексируем данные (если они есть)
      await this.reindexAll();
    } catch (error) {
      console.warn('Meilisearch initialization warning:', error.message);
      // В production это должно быть критической ошибкой
    }
  }

  /**
   * Поиск мастеров
   */
  async searchMasters(
    searchDto: SearchMastersDto,
  ): Promise<SearchResponseDto<MasterSearchResultDto>> {
    const { query = '', page = 1, limit = 20, sort = 'relevance' } = searchDto;

    // Формируем фильтры
    const filters: string[] = ['is_active = true'];

    // Поддержка как одиночного category_id, так и массива category_ids
    if (searchDto.category_ids && searchDto.category_ids.length > 0) {
      // Если передан массив, используем его
      const categoryFilter = searchDto.category_ids
        .map((id) => `category_ids = ${id}`)
        .join(' OR ');
      filters.push(`(${categoryFilter})`);
    } else if (searchDto.category_id) {
      // Если передан одиночный ID, используем его
      filters.push(`category_ids = ${searchDto.category_id}`);
    }

    if (searchDto.min_rating) {
      filters.push(`average_rating >= ${searchDto.min_rating}`);
    }

    if (searchDto.tags && searchDto.tags.length > 0) {
      const tagsFilter = searchDto.tags.map((tag) => `tags = ${tag}`).join(' OR ');
      filters.push(`(${tagsFilter})`);
    }

    // Формируем сортировку
    let sortArray: string[] = [];
    if (sort === 'rating') {
      sortArray = ['average_rating:desc'];
    } else if (sort === 'reviews_count') {
      sortArray = ['reviews_count:desc'];
    }

    const startTime = Date.now();

    try {
      const searchResults = await this.mastersIndex.search(query, {
        filter: filters.join(' AND '),
        sort: sortArray,
        limit,
        offset: (page - 1) * limit,
      });

      const processingTimeMs = Date.now() - startTime;

      // Преобразуем результаты
      const data: MasterSearchResultDto[] = searchResults.hits.map((hit: any) => ({
        id: hit.id,
        first_name: hit.first_name,
        last_name: hit.last_name,
        avatar_url: hit.avatar_url,
        average_rating: hit.average_rating,
        reviews_count: hit.reviews_count,
        category_names: hit.category_names || [],
        description: hit.description,
        tags: hit.tags || [],
        location_address: hit.location_address,
        distance_km: this.calculateDistance(
          searchDto.lat,
          searchDto.lng,
          hit.location_lat,
          hit.location_lng,
        ),
      }));

      return {
        data,
        total: searchResults.estimatedTotalHits || 0,
        page,
        limit,
        processing_time_ms: processingTimeMs,
        query,
      };
    } catch (error) {
      console.error('Meilisearch error:', error);
      // Fallback to database search
      return this.fallbackSearchMasters(searchDto);
    }
  }

  /**
   * Поиск услуг
   */
  async searchServices(
    searchDto: SearchServicesDto,
  ): Promise<SearchResponseDto<ServiceSearchResultDto>> {
    const { query = '', page = 1, limit = 20, sort = 'relevance' } = searchDto;

    // Формируем фильтры
    const filters: string[] = ['is_active = true'];

    // Поддержка как одиночного category_id, так и массива category_ids
    if (searchDto.category_ids && searchDto.category_ids.length > 0) {
      // Если передан массив, используем его
      const categoryFilter = searchDto.category_ids
        .map((id) => `category_id = ${id}`)
        .join(' OR ');
      filters.push(`(${categoryFilter})`);
    } else if (searchDto.category_id) {
      // Если передан одиночный ID, используем его
      filters.push(`category_id = ${searchDto.category_id}`);
    }

    if (searchDto.min_price !== undefined) {
      filters.push(`price >= ${searchDto.min_price}`);
    }

    if (searchDto.max_price !== undefined) {
      filters.push(`price <= ${searchDto.max_price}`);
    }

    if (searchDto.min_duration !== undefined) {
      filters.push(`duration_minutes >= ${searchDto.min_duration}`);
    }

    if (searchDto.max_duration !== undefined) {
      filters.push(`duration_minutes <= ${searchDto.max_duration}`);
    }

    if (searchDto.tags && searchDto.tags.length > 0) {
      const tagsFilter = searchDto.tags.map((tag) => `tags = ${tag}`).join(' OR ');
      filters.push(`(${tagsFilter})`);
    }

    // Формируем сортировку
    let sortArray: string[] = [];
    if (sort === 'price_asc') {
      sortArray = ['price:asc'];
    } else if (sort === 'price_desc') {
      sortArray = ['price:desc'];
    } else if (sort === 'duration_asc') {
      sortArray = ['duration_minutes:asc'];
    } else if (sort === 'duration_desc') {
      sortArray = ['duration_minutes:desc'];
    }

    const startTime = Date.now();

    try {
      const searchResults = await this.servicesIndex.search(query, {
        filter: filters.join(' AND '),
        sort: sortArray,
        limit,
        offset: (page - 1) * limit,
      });

      const processingTimeMs = Date.now() - startTime;

      // Преобразуем результаты
      const data: ServiceSearchResultDto[] = searchResults.hits.map((hit: any) => ({
        id: hit.id,
        name: hit.name,
        description: hit.description,
        price: hit.price,
        duration_minutes: hit.duration_minutes,
        category_name: hit.category_name,
        tags: hit.tags || [],
        photo_urls: hit.photo_urls || [],
        master: {
          id: hit.master_id,
          first_name: hit.master_first_name,
          last_name: hit.master_last_name,
          avatar_url: hit.master_avatar_url,
          average_rating: hit.master_average_rating,
        },
      }));

      return {
        data,
        total: searchResults.estimatedTotalHits || 0,
        page,
        limit,
        processing_time_ms: processingTimeMs,
        query,
      };
    } catch (error) {
      console.error('Meilisearch error:', error);
      // Fallback to database search
      return this.fallbackSearchServices(searchDto);
    }
  }

  /**
   * Поиск мастеров по шаблону услуги (service_template_id).
   *
   * Точная выборка (без полнотекстового query по названию шаблона, который давал
   * и пропуски, и ложные срабатывания из-за typo-tolerance): находим услуги с
   * данным service_template_id → собираем уникальных мастеров → обогащаем данными
   * из индекса masters (category_names, рейтинг, координаты для distance_km).
   */
  async searchMastersByTemplate(
    templateId: string,
    lat?: number,
    lng?: number,
  ): Promise<SearchResponseDto<MasterSearchResultDto>> {
    const startTime = Date.now();

    try {
      // 1. Все услуги этого шаблона
      const serviceResults = await this.servicesIndex.search('', {
        filter: `service_template_id = ${templateId} AND is_active = true`,
        limit: 1000,
      });

      // 2. Уникальные master_id (порядок сохраняем)
      const masterIds: string[] = [];
      const seen = new Set<string>();
      for (const hit of serviceResults.hits as any[]) {
        if (hit.master_id && !seen.has(hit.master_id)) {
          seen.add(hit.master_id);
          masterIds.push(hit.master_id);
        }
      }

      if (masterIds.length === 0) {
        return {
          data: [],
          total: 0,
          page: 1,
          limit: masterIds.length,
          processing_time_ms: Date.now() - startTime,
          query: '',
        };
      }

      // 3. Документы мастеров из индекса masters (одним запросом по фильтру id)
      const idFilter = masterIds.map((id) => `id = ${id}`).join(' OR ');
      const masterResults = await this.mastersIndex.search('', {
        filter: `(${idFilter}) AND is_active = true`,
        limit: masterIds.length,
      });

      const masterById = new Map<string, any>();
      for (const hit of masterResults.hits as any[]) {
        masterById.set(hit.id, hit);
      }

      // 4. Собираем результат в порядке появления мастеров (по релевантности услуг)
      const data: MasterSearchResultDto[] = masterIds
        .map((id) => masterById.get(id))
        .filter(Boolean)
        .map((hit: any) => ({
          id: hit.id,
          first_name: hit.first_name,
          last_name: hit.last_name,
          avatar_url: hit.avatar_url,
          average_rating: hit.average_rating,
          reviews_count: hit.reviews_count,
          category_names: hit.category_names || [],
          description: hit.description,
          tags: hit.tags || [],
          location_address: hit.location_address,
          distance_km: this.calculateDistance(
            lat,
            lng,
            hit.location_lat,
            hit.location_lng,
          ),
        }));

      return {
        data,
        total: data.length,
        page: 1,
        limit: data.length,
        processing_time_ms: Date.now() - startTime,
        query: '',
      };
    } catch (error) {
      console.error('Meilisearch error (masters by template):', error);
      return this.fallbackSearchMastersByTemplate(templateId, lat, lng);
    }
  }

  /**
   * Fallback (PostgreSQL) для поиска мастеров по шаблону услуги.
   */
  private async fallbackSearchMastersByTemplate(
    templateId: string,
    lat?: number,
    lng?: number,
  ): Promise<SearchResponseDto<MasterSearchResultDto>> {
    const startTime = Date.now();

    // Услуги с этим шаблоном → master_id (users.id, см. CLAUDE.md)
    const services = await this.serviceRepository.find({
      where: { service_template_id: templateId, is_active: true },
      select: ['master_id'],
    });
    const masterIds = Array.from(
      new Set(services.map((s) => s.master_id).filter(Boolean)),
    );

    if (masterIds.length === 0) {
      return {
        data: [],
        total: 0,
        page: 1,
        limit: 0,
        processing_time_ms: Date.now() - startTime,
        query: '',
      };
    }

    const data: MasterSearchResultDto[] = [];
    for (const masterUserId of masterIds) {
      const user = await this.userRepository.findOne({
        where: { id: masterUserId },
      });
      const profile = await this.masterProfileRepository.findOne({
        where: { user_id: masterUserId },
      });
      if (!user || !profile || !profile.is_active) continue;

      const categoryIds = profile.category_ids || [];
      let categoryNames: string[] = [];
      if (categoryIds.length > 0) {
        const catTranslations = await this.categoryTranslationRepository.find({
          where: { category_id: In(categoryIds), language: 'ru' },
        });
        categoryNames = catTranslations.map((t) => t.name).filter(Boolean);
      }

      data.push({
        id: user.id,
        first_name: user.first_name,
        last_name: user.last_name,
        avatar_url: user.avatar_url,
        average_rating: Number(user.rating),
        reviews_count: user.reviews_count,
        category_names: categoryNames,
        description: profile.bio,
        tags: [],
        location_address: profile.location_address,
        distance_km: this.calculateDistance(
          lat,
          lng,
          profile.location_lat,
          profile.location_lng,
        ),
      });
    }

    return {
      data,
      total: data.length,
      page: 1,
      limit: data.length,
      processing_time_ms: Date.now() - startTime,
      query: '',
    };
  }

  /**
   * Поиск шаблонов услуг (для приоритета в глобальной строке поиска)
   */
  async searchServiceTemplates(
    searchDto: SearchTemplatesDto,
  ): Promise<SearchResponseDto<ServiceTemplateSearchResultDto>> {
    const { query = '', page = 1, limit = 20 } = searchDto;

    const filters: string[] = ['is_active = true'];
    if (searchDto.category_id) {
      filters.push(`category_id = ${searchDto.category_id}`);
    }

    const startTime = Date.now();

    try {
      const searchResults = await this.serviceTemplatesIndex.search(query, {
        filter: filters.join(' AND '),
        sort: ['display_order:asc', 'name:asc'],
        limit,
        offset: (page - 1) * limit,
      });

      const processingTimeMs = Date.now() - startTime;

      const data: ServiceTemplateSearchResultDto[] = searchResults.hits.map(
        (hit: any) => ({
          id: hit.id,
          slug: hit.slug,
          name: hit.name,
          description: hit.description,
          category_id: hit.category_id,
          default_duration_minutes: hit.default_duration_minutes,
          default_price_range_min: hit.default_price_range_min,
          default_price_range_max: hit.default_price_range_max,
        }),
      );

      return {
        data,
        total: searchResults.estimatedTotalHits || 0,
        page,
        limit,
        processing_time_ms: processingTimeMs,
        query,
      };
    } catch (error) {
      console.error('Meilisearch error (templates):', error);
      return this.fallbackSearchTemplates(searchDto);
    }
  }

  /**
   * Поиск пользователей (для создания чата)
   */
  async searchUsers(
    searchDto: SearchUsersDto,
    currentUserId?: string,
  ): Promise<SearchResponseDto<UserSearchResultDto>> {
    const { query = '', page = 1, limit = 20 } = searchDto;
    const startTime = Date.now();

    if (!query.trim()) {
      return { data: [], total: 0, page, limit, processing_time_ms: 0, query };
    }

    try {
      const filters: string[] = ['is_active = true'];

      const searchResults = await this.usersIndex.search(query, {
        filter: filters.join(' AND '),
        limit: limit + 1, // +1 чтобы исключить текущего пользователя
        offset: (page - 1) * limit,
      });

      const processingTimeMs = Date.now() - startTime;

      const data: UserSearchResultDto[] = searchResults.hits
        .filter((hit: any) => hit.id !== currentUserId)
        .slice(0, limit)
        .map((hit: any) => ({
          id: hit.id,
          firstName: hit.first_name,
          lastName: hit.last_name,
          fullName: `${hit.first_name} ${hit.last_name}`.trim(),
          avatarUrl: hit.avatar_url || null,
          email: hit.email,
          isMaster: hit.is_master || false,
          isVerified: hit.is_verified || false,
        }));

      return {
        data,
        total: searchResults.estimatedTotalHits || 0,
        page,
        limit,
        processing_time_ms: processingTimeMs,
        query,
      };
    } catch (error) {
      console.error('Meilisearch users search error:', error);
      return this.fallbackSearchUsers(searchDto, currentUserId);
    }
  }

  /**
   * Индексация пользователя (вызывается при регистрации/обновлении)
   */
  async indexUser(userId: string): Promise<void> {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) return;

    const document = {
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      avatar_url: user.avatar_url,
      is_master: user.is_master,
      is_verified: user.is_verified,
      is_active: user.is_active,
    };

    try {
      await this.usersIndex.addDocuments([document], { primaryKey: 'id' });
    } catch (error) {
      console.error('Error indexing user:', error);
    }
  }

  /**
   * Индексация мастера (вызывается при создании/обновлении)
   */
  async indexMaster(userId: string): Promise<void> {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    const masterProfile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!user || !masterProfile) return;

    // Названия категорий мастера (ru) — чтобы поиск находил по названию категории
    const categoryIds = masterProfile.category_ids || [];
    let categoryNames: string[] = [];
    if (categoryIds.length > 0) {
      const catTranslations = await this.categoryTranslationRepository.find({
        where: { category_id: In(categoryIds), language: 'ru' },
      });
      categoryNames = catTranslations.map((t) => t.name).filter(Boolean);
    }

    // Названия услуг мастера — чтобы поиск находил мастера по его услугам.
    // services.master_id ссылается на users.id (см. CLAUDE.md).
    const services = await this.serviceRepository.find({
      where: { master_id: user.id, is_active: true },
      select: ['name'],
    });
    const serviceNames = Array.from(
      new Set(services.map((s) => s.name).filter(Boolean)),
    );

    const document = {
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      avatar_url: user.avatar_url,
      average_rating: Number(user.rating),
      reviews_count: user.reviews_count,
      description: masterProfile.bio,
      category_ids: categoryIds,
      category_names: categoryNames,
      service_names: serviceNames,
      tags: [], // TODO: Add tags field to MasterProfile entity
      location_address: masterProfile.location_address,
      location_lat: masterProfile.location_lat,
      location_lng: masterProfile.location_lng,
      is_active: masterProfile.is_active,
    };

    try {
      await this.mastersIndex.addDocuments([document], { primaryKey: 'id' });
    } catch (error) {
      console.error('Error indexing master:', error);
    }
  }

  /**
   * Индексация услуги (вызывается при создании/обновлении)
   */
  async indexService(serviceId: string): Promise<void> {
    const service = await this.serviceRepository.findOne({
      where: { id: serviceId },
    });

    if (!service) return;

    // Название категории услуги (ru) — для поиска и отображения
    const catTranslation = service.category_id
      ? await this.categoryTranslationRepository.findOne({
          where: { category_id: service.category_id, language: 'ru' },
        })
      : null;

    const master = await this.userRepository.findOne({
      where: { id: service.master_id },
    });

    const document = {
      id: service.id,
      name: service.name,
      description: service.description,
      price: service.price,
      duration_minutes: service.duration_minutes,
      category_id: service.category_id,
      service_template_id: service.service_template_id || null,
      category_name: catTranslation?.name || '',
      tags: service.tags,
      photo_urls: service.photo_urls,
      is_active: service.is_active,
      bookings_count: service.bookings_count,
      average_rating: service.average_rating,
      master_id: master?.id,
      master_first_name: master?.first_name,
      master_last_name: master?.last_name,
      master_avatar_url: master?.avatar_url,
      master_average_rating: master ? Number(master.rating) : 0,
    };

    try {
      await this.servicesIndex.addDocuments([document], { primaryKey: 'id' });
    } catch (error) {
      console.error('Error indexing service:', error);
    }
  }

  /**
   * Удаление услуги из индекса (при удалении услуги мастером)
   */
  async removeService(serviceId: string): Promise<void> {
    try {
      await this.servicesIndex.deleteDocument(serviceId);
    } catch (error) {
      console.error('Error removing service from index:', error);
    }
  }

  /**
   * Индексация шаблона услуги (вызывается при создании/обновлении)
   */
  async indexServiceTemplate(templateId: string): Promise<void> {
    const template = await this.serviceTemplateRepository.findOne({
      where: { id: templateId },
    });

    if (!template) return;

    // Загружаем переводы для получения keywords
    const translations = await this.serviceTemplateTranslationRepository.find({
      where: { service_template_id: templateId },
    });

    const ruTranslation = translations.find((t) => t.language === 'ru');

    // Преобразуем массив keywords в строку для лучшего ранжирования
    const keywordsText =
      ruTranslation?.keywords?.join(' ') || '';

    const document = {
      id: template.id,
      category_id: template.category_id,
      slug: template.slug,
      name: ruTranslation?.name || template.name,
      description: ruTranslation?.description || template.description,
      keywords_text: keywordsText, // Строка для поиска
      keywords: ruTranslation?.keywords || [], // Массив для фильтрации
      default_duration_minutes: template.default_duration_minutes,
      default_price_range_min: template.default_price_range_min
        ? Number(template.default_price_range_min)
        : null,
      default_price_range_max: template.default_price_range_max
        ? Number(template.default_price_range_max)
        : null,
      is_active: template.is_active,
      display_order: template.display_order,
    };

    try {
      await this.serviceTemplatesIndex.addDocuments([document], { primaryKey: 'id' });
    } catch (error) {
      console.error('Error indexing service template:', error);
    }
  }

  /**
   * Переиндексация всех данных
   */
  async reindexAll(): Promise<void> {
    try {
      console.log('🔄 Reindexing all data...');

      // Переиндексируем мастеров
      const masters = await this.masterProfileRepository.find({
        where: { is_active: true },
      });
      for (const master of masters) {
        await this.indexMaster(master.user_id);
      }

      // Переиндексируем услуги
      const services = await this.serviceRepository.find({
        where: { is_active: true },
      });
      for (const service of services) {
        await this.indexService(service.id);
      }

      // Переиндексируем шаблоны услуг
      const templates = await this.serviceTemplateRepository.find({
        where: { is_active: true },
      });
      for (const template of templates) {
        await this.indexServiceTemplate(template.id);
      }

      // Переиндексируем категории (L0/L1)
      await this.reindexCategories();

      // Переиндексируем пользователей
      const users = await this.userRepository.find({
        where: { is_active: true },
      });
      for (const user of users) {
        await this.indexUser(user.id);
      }

      console.log('✅ Reindexing completed');
    } catch (error) {
      console.error('Error during reindexing:', error);
    }
  }

  /**
   * Переиндексация всех категорий (L0/L1) с переводами
   */
  async reindexCategories(): Promise<void> {
    try {
      console.log('🔄 Начало переиндексации категорий...');
      const categories = await this.categoryRepository.find({
        where: { is_active: true },
        order: { level: 'ASC', display_order: 'ASC' },
      });
      console.log(`📊 Найдено категорий: ${categories.length}`);
      if (categories.length === 0) return;

      const categoryIds = categories.map((c) => c.id);
      const translations = await this.categoryTranslationRepository.find({
        where: { category_id: In(categoryIds) },
      });
      console.log(`🌐 Найдено переводов: ${translations.length}`);

      const documents = [];
      for (const cat of categories) {
        const catTranslations = translations.filter((t) => t.category_id === cat.id);
        for (const tr of catTranslations) {
          documents.push({
            id: `${cat.id}_${tr.language}`,
            category_id: cat.id,
            name: tr.name,
            slug: cat.slug,
            level: cat.level,
            parent_id: cat.parent_id || null,
            language: tr.language,
            keywords_text: Array.isArray(tr.keywords) ? tr.keywords.join(' ') : '',
            display_order: cat.display_order,
          });
        }
      }
      console.log(`📝 Подготовлено документов для индексации: ${documents.length}`);
      if (documents.length > 0) {
        await this.categoriesIndex.addDocuments(documents, { primaryKey: 'id' });
        console.log(`✅ Категории проиндексированы: ${documents.length} документов`);
      }
    } catch (error) {
      console.error('❌ Error reindexing categories:', error);
    }
  }

  /**
   * Обновить документ категории в Meilisearch (после изменения категории или перевода)
   */
  async reindexCategory(categoryId: string): Promise<void> {
    if (!this.categoriesIndex) return;
    try {
      const category = await this.categoryRepository.findOne({
        where: { id: categoryId },
      });
      if (!category) return;

      const translations = await this.categoryTranslationRepository.find({
        where: { category_id: categoryId },
      });
      const documents = translations.map((tr) => ({
        id: `${category.id}_${tr.language}`,
        category_id: category.id,
        name: tr.name,
        slug: category.slug,
        level: category.level,
        parent_id: category.parent_id || null,
        language: tr.language,
        keywords_text: Array.isArray(tr.keywords) ? tr.keywords.join(' ') : '',
        display_order: category.display_order,
      }));
      if (documents.length > 0) {
        await this.categoriesIndex.addDocuments(documents, { primaryKey: 'id' });
      }
    } catch (error) {
      console.error('Error reindexing category:', error);
    }
  }

  /**
   * Удалить категорию из индекса (после удаления в БД)
   */
  async deleteCategoryFromIndex(categoryId: string): Promise<void> {
    if (!this.categoriesIndex) return;
    try {
      await this.categoriesIndex.deleteDocuments({
        filter: `category_id = "${categoryId}"`,
      });
    } catch (error) {
      console.error('Error deleting category from index:', error);
    }
  }

  /**
   * Поиск по категориям (L0/L1)
   */
  async searchCategories(
    query: string,
    language: string = 'ru',
    limit: number = 10,
    offset: number = 0,
    attributesToHighlight?: string[],
  ): Promise<{ data: CategorySearchResultDto[]; total: number }> {
    if (!this.categoriesIndex) {
      return { data: [], total: 0 };
    }
    try {
      const searchResults = await this.categoriesIndex.search(query, {
        filter: `language = "${language}"`,
        limit,
        offset,
        attributesToHighlight: attributesToHighlight ?? ['name', 'slug'],
        highlightPreTag: '<em>',
        highlightPostTag: '</em>',
      });

      const data: CategorySearchResultDto[] = (searchResults.hits as any[]).map(
        (hit: any) => ({
          id: hit.category_id,
          name: hit.name,
          slug: hit.slug,
          level: hit.level,
          parent_id: hit.parent_id ?? undefined,
          language: hit.language,
          name_highlighted: hit._formatted?.name ?? hit.name,
        }),
      );
      return {
        data,
        total: searchResults.estimatedTotalHits || 0,
      };
    } catch (error) {
      console.error('Meilisearch categories search error:', error);
      return { data: [], total: 0 };
    }
  }

  /**
   * Агрегированный поиск: мастера + услуги + категории одним запросом (Promise.all)
   */
  async searchAll(dto: SearchAllDto): Promise<SearchAggregationDto> {
    const startTime = Date.now();
    const query = (dto.q ?? '').trim();
    const limitPerType = dto.limit ?? 10;
    const language = dto.language ?? 'ru';

    if (!query) {
      return {
        masters: [],
        services: [],
        categories: [],
        query: '',
        processing_time_ms: 0,
      };
    }

    const [mastersRes, servicesRes, categoriesRes] = await Promise.all([
      this.searchMasters({
        query,
        page: 1,
        limit: limitPerType,
      }),
      this.searchServices({
        query,
        page: 1,
        limit: limitPerType,
      }),
      this.searchCategories(query, language, limitPerType, 0),
    ]);

    const processingTimeMs = Date.now() - startTime;

    return {
      masters: mastersRes.data,
      services: servicesRes.data,
      categories: categoriesRes.data,
      query,
      processing_time_ms: processingTimeMs,
    };
  }

  /**
   * Fallback поиск по БД (если Meilisearch недоступен)
   * Использует PostgreSQL full-text search с to_tsvector для оптимальной производительности
   */
  private async fallbackSearchMasters(
    searchDto: SearchMastersDto,
  ): Promise<SearchResponseDto<MasterSearchResultDto>> {
    const { query = '', page = 1, limit = 20, sort = 'relevance' } = searchDto;
    const startTime = Date.now();

    console.warn('⚠️  Using fallback PostgreSQL search (Meilisearch unavailable)');

    try {
      // Build query
      const qb = this.userRepository
        .createQueryBuilder('user')
        .leftJoinAndSelect(MasterProfile, 'profile', 'profile.user_id = user.id')
        .where('user.is_master = :isMaster', { isMaster: true })
        .andWhere('profile.is_active = :isActive', { isActive: true });

      // Text search using PostgreSQL full-text search (to_tsvector)
      if (query) {
        // Clean query for tsquery (remove special characters that could break query)
        const cleanQuery = query.replace(/[&|!():]/g, ' ').trim();

        if (cleanQuery) {
          qb.andWhere(
            `(
              to_tsvector('russian', COALESCE(user.first_name, '') || ' ' || COALESCE(user.last_name, '')) @@ plainto_tsquery('russian', :query)
              OR to_tsvector('russian', COALESCE(profile.bio, '')) @@ plainto_tsquery('russian', :query)
            )`,
            { query: cleanQuery },
          );
        }
      }

      // Category filter - поддержка как одиночного category_id, так и массива category_ids
      if (searchDto.category_ids && searchDto.category_ids.length > 0) {
        // Если передан массив, проверяем что хотя бы одна категория есть в профиле мастера
        qb.andWhere(
          `(${searchDto.category_ids.map((_, i) => `:categoryId${i} = ANY(profile.category_ids)`).join(' OR ')})`,
          searchDto.category_ids.reduce((acc, id, i) => {
            acc[`categoryId${i}`] = id;
            return acc;
          }, {} as Record<string, string>),
        );
      } else if (searchDto.category_id) {
        qb.andWhere(':categoryId = ANY(profile.category_ids)', {
          categoryId: searchDto.category_id,
        });
      }

      // Rating filter
      if (searchDto.min_rating) {
        qb.andWhere('user.rating >= :minRating', {
          minRating: searchDto.min_rating,
        });
      }

      // Tags filter - DISABLED: MasterProfile doesn't have tags field yet
      // TODO: Add tags field to MasterProfile entity
      // if (searchDto.tags && searchDto.tags.length > 0) {
      //   qb.andWhere('profile.tags && :tags', { tags: searchDto.tags });
      // }

      // Sorting
      if (sort === 'rating') {
        qb.orderBy('user.rating', 'DESC');
      } else if (sort === 'reviews_count') {
        qb.orderBy('user.reviews_count', 'DESC');
      } else if (query) {
        // Sort by text search relevance when query exists
        const cleanQuery = query.replace(/[&|!():]/g, ' ').trim();
        if (cleanQuery) {
          qb.orderBy(
            `ts_rank(
              to_tsvector('russian', COALESCE(user.first_name, '') || ' ' || COALESCE(user.last_name, '') || ' ' || COALESCE(profile.bio, '')),
              plainto_tsquery('russian', :query)
            )`,
            'DESC',
          );
        }
      } else {
        // Default sorting by created_at
        qb.orderBy('user.created_at', 'DESC');
      }

      // Pagination
      const offset = (page - 1) * limit;
      qb.skip(offset).take(limit);

      // Execute query
      const [users, total] = await qb.getManyAndCount();

      // Transform to response format
      const data: MasterSearchResultDto[] = await Promise.all(
        users.map(async (user) => {
          const profile = await this.masterProfileRepository.findOne({
            where: { user_id: user.id },
          });

          return {
            id: user.id,
            first_name: user.first_name,
            last_name: user.last_name,
            avatar_url: user.avatar_url,
            average_rating: Number(user.rating),
            reviews_count: user.reviews_count,
            category_names: [], // TODO: Load from Category
            description: profile?.bio || '',
            tags: [], // TODO: Add tags field to MasterProfile entity
            location_address: profile?.location_address || '',
            distance_km: this.calculateDistance(
              searchDto.lat,
              searchDto.lng,
              profile?.location_lat,
              profile?.location_lng,
            ),
          };
        }),
      );

      const processingTimeMs = Date.now() - startTime;

      console.log(
        `✅ Fallback search completed: ${total} results in ${processingTimeMs}ms`,
      );

      return {
        data,
        total,
        page,
        limit,
        processing_time_ms: processingTimeMs,
        query,
      };
    } catch (error) {
      console.error('❌ Fallback search error:', error);
      return {
        data: [],
        total: 0,
        page,
        limit,
        processing_time_ms: Date.now() - startTime,
        query,
      };
    }
  }

  /**
   * Fallback поиск услуг по БД
   * Использует PostgreSQL full-text search с to_tsvector для оптимальной производительности
   */
  private async fallbackSearchServices(
    searchDto: SearchServicesDto,
  ): Promise<SearchResponseDto<ServiceSearchResultDto>> {
    const { query = '', page = 1, limit = 20, sort = 'relevance' } = searchDto;
    const startTime = Date.now();

    console.warn('⚠️  Using fallback PostgreSQL search (Meilisearch unavailable)');

    try {
      // Build query
      const qb = this.serviceRepository
        .createQueryBuilder('service')
        .where('service.is_active = :isActive', { isActive: true });

      // Text search using PostgreSQL full-text search (to_tsvector)
      if (query) {
        // Clean query for tsquery (remove special characters that could break query)
        const cleanQuery = query.replace(/[&|!():]/g, ' ').trim();

        if (cleanQuery) {
          qb.andWhere(
            `(
              to_tsvector('russian', COALESCE(service.name, '')) @@ plainto_tsquery('russian', :query)
              OR to_tsvector('russian', COALESCE(service.description, '')) @@ plainto_tsquery('russian', :query)
            )`,
            { query: cleanQuery },
          );
        }
      }

      // Category filter - поддержка как одиночного category_id, так и массива category_ids
      if (searchDto.category_ids && searchDto.category_ids.length > 0) {
        qb.andWhere('service.category_id IN (:...categoryIds)', {
          categoryIds: searchDto.category_ids,
        });
      } else if (searchDto.category_id) {
        qb.andWhere('service.category_id = :categoryId', {
          categoryId: searchDto.category_id,
        });
      }

      // Price filters
      if (searchDto.min_price !== undefined) {
        qb.andWhere('service.price >= :minPrice', {
          minPrice: searchDto.min_price,
        });
      }

      if (searchDto.max_price !== undefined) {
        qb.andWhere('service.price <= :maxPrice', {
          maxPrice: searchDto.max_price,
        });
      }

      // Duration filters
      if (searchDto.min_duration !== undefined) {
        qb.andWhere('service.duration_minutes >= :minDuration', {
          minDuration: searchDto.min_duration,
        });
      }

      if (searchDto.max_duration !== undefined) {
        qb.andWhere('service.duration_minutes <= :maxDuration', {
          maxDuration: searchDto.max_duration,
        });
      }

      // Tags filter (array overlap operator)
      if (searchDto.tags && searchDto.tags.length > 0) {
        qb.andWhere('service.tags && :tags', { tags: searchDto.tags });
      }

      // Sorting
      if (sort === 'price_asc') {
        qb.orderBy('service.price', 'ASC');
      } else if (sort === 'price_desc') {
        qb.orderBy('service.price', 'DESC');
      } else if (sort === 'duration_asc') {
        qb.orderBy('service.duration_minutes', 'ASC');
      } else if (sort === 'duration_desc') {
        qb.orderBy('service.duration_minutes', 'DESC');
      } else if (query) {
        // Sort by text search relevance when query exists
        const cleanQuery = query.replace(/[&|!():]/g, ' ').trim();
        if (cleanQuery) {
          qb.orderBy(
            `ts_rank(
              to_tsvector('russian', COALESCE(service.name, '') || ' ' || COALESCE(service.description, '')),
              plainto_tsquery('russian', :query)
            )`,
            'DESC',
          );
        }
      } else {
        // Default sorting by popularity
        qb.orderBy('service.bookings_count', 'DESC');
      }

      // Pagination
      const offset = (page - 1) * limit;
      qb.skip(offset).take(limit);

      // Execute query
      const [services, total] = await qb.getManyAndCount();

      // Transform to response format
      const data: ServiceSearchResultDto[] = await Promise.all(
        services.map(async (service) => {
          // Get master profile by master_id (Service.master_id references MasterProfile.id)
          const masterProfile = await this.masterProfileRepository.findOne({
            where: { id: service.master_id },
          });

          // Get master user
          const master = masterProfile
            ? await this.userRepository.findOne({
                where: { id: masterProfile.user_id },
              })
            : null;

          return {
            id: service.id,
            name: service.name,
            description: service.description,
            price: Number(service.price),
            duration_minutes: service.duration_minutes,
            category_name: '', // TODO: Load from Category
            tags: service.tags,
            photo_urls: service.photo_urls,
            master: master
              ? {
                  id: master.id,
                  first_name: master.first_name,
                  last_name: master.last_name,
                  avatar_url: master.avatar_url,
                  average_rating: Number(master.rating),
                }
              : {
                  id: '',
                  first_name: '',
                  last_name: '',
                  avatar_url: '',
                  average_rating: 0,
                },
          };
        }),
      );

      const processingTimeMs = Date.now() - startTime;

      console.log(
        `✅ Fallback search completed: ${total} results in ${processingTimeMs}ms`,
      );

      return {
        data,
        total,
        page,
        limit,
        processing_time_ms: processingTimeMs,
        query,
      };
    } catch (error) {
      console.error('❌ Fallback search error:', error);
      return {
        data: [],
        total: 0,
        page,
        limit,
        processing_time_ms: Date.now() - startTime,
        query,
      };
    }
  }

  /**
   * Fallback поиск шаблонов по БД (если Meilisearch недоступен)
   */
  private async fallbackSearchTemplates(
    searchDto: SearchTemplatesDto,
  ): Promise<SearchResponseDto<ServiceTemplateSearchResultDto>> {
    const { query = '', page = 1, limit = 20 } = searchDto;
    const startTime = Date.now();

    console.warn(
      '⚠️  Using fallback PostgreSQL search for templates (Meilisearch unavailable)',
    );

    try {
      const qb = this.serviceTemplateRepository
        .createQueryBuilder('t')
        .leftJoin(
          ServiceTemplateTranslation,
          'tr',
          "tr.service_template_id = t.id AND tr.language = 'ru'",
        )
        .where('t.is_active = :isActive', { isActive: true });

      if (searchDto.category_id) {
        qb.andWhere('t.category_id = :categoryId', {
          categoryId: searchDto.category_id,
        });
      }

      if (query) {
        const cleanQuery = query.replace(/[&|!():]/g, ' ').trim();
        if (cleanQuery) {
          qb.andWhere(
            `(
              to_tsvector('russian', COALESCE(tr.name, t.name, '')) @@ plainto_tsquery('russian', :query)
              OR to_tsvector('russian', COALESCE(tr.description, t.description, '')) @@ plainto_tsquery('russian', :query)
            )`,
            { query: cleanQuery },
          );
        }
      }

      qb.orderBy('t.display_order', 'ASC').addOrderBy('t.name', 'ASC');

      const offset = (page - 1) * limit;
      qb.skip(offset).take(limit);

      const [templates, total] = await qb.getManyAndCount();

      const data: ServiceTemplateSearchResultDto[] = await Promise.all(
        templates.map(async (t) => {
          const tr = await this.serviceTemplateTranslationRepository.findOne({
            where: { service_template_id: t.id, language: 'ru' },
          });
          return {
            id: t.id,
            slug: t.slug,
            name: tr?.name ?? t.name,
            description: tr?.description ?? t.description,
            category_id: t.category_id,
            default_duration_minutes: t.default_duration_minutes ?? undefined,
            default_price_range_min: t.default_price_range_min
              ? Number(t.default_price_range_min)
              : undefined,
            default_price_range_max: t.default_price_range_max
              ? Number(t.default_price_range_max)
              : undefined,
          };
        }),
      );

      const processingTimeMs = Date.now() - startTime;

      return {
        data,
        total,
        page,
        limit,
        processing_time_ms: processingTimeMs,
        query,
      };
    } catch (error) {
      console.error('❌ Fallback templates search error:', error);
      return {
        data: [],
        total: 0,
        page,
        limit,
        processing_time_ms: Date.now() - startTime,
        query: searchDto.query,
      };
    }
  }

  /**
   * Fallback поиск пользователей по БД (если Meilisearch недоступен)
   */
  private async fallbackSearchUsers(
    searchDto: SearchUsersDto,
    currentUserId?: string,
  ): Promise<SearchResponseDto<UserSearchResultDto>> {
    const { query = '', page = 1, limit = 20 } = searchDto;
    const startTime = Date.now();

    console.warn('⚠️  Using fallback PostgreSQL search for users (Meilisearch unavailable)');

    try {
      const qb = this.userRepository
        .createQueryBuilder('user')
        .where('user.is_active = :isActive', { isActive: true });

      if (currentUserId) {
        qb.andWhere('user.id != :currentUserId', { currentUserId });
      }

      if (query.trim()) {
        qb.andWhere(
          `(user.first_name ILIKE :query OR user.last_name ILIKE :query OR CONCAT(user.first_name, ' ', user.last_name) ILIKE :query)`,
          { query: `%${query.trim()}%` },
        );
      }

      qb.orderBy('user.first_name', 'ASC').addOrderBy('user.last_name', 'ASC');

      const offset = (page - 1) * limit;
      qb.skip(offset).take(limit);

      const [users, total] = await qb.getManyAndCount();

      const data: UserSearchResultDto[] = users.map((user) => ({
        id: user.id,
        firstName: user.first_name,
        lastName: user.last_name,
        fullName: `${user.first_name} ${user.last_name}`.trim(),
        avatarUrl: user.avatar_url || null,
        email: user.email,
        isMaster: user.is_master,
        isVerified: user.is_verified,
      }));

      const processingTimeMs = Date.now() - startTime;

      return { data, total, page, limit, processing_time_ms: processingTimeMs, query };
    } catch (error) {
      console.error('❌ Fallback users search error:', error);
      return { data: [], total: 0, page, limit, processing_time_ms: Date.now() - startTime, query };
    }
  }

  /**
   * Расчет расстояния между двумя точками (Haversine formula)
   */
  private calculateDistance(
    lat1?: number,
    lon1?: number,
    lat2?: number,
    lon2?: number,
  ): number | undefined {
    if (!lat1 || !lon1 || !lat2 || !lon2) return undefined;

    const R = 6371; // Радиус Земли в км
    const dLat = this.deg2rad(lat2 - lat1);
    const dLon = this.deg2rad(lon2 - lon1);
    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos(this.deg2rad(lat1)) *
        Math.cos(this.deg2rad(lat2)) *
        Math.sin(dLon / 2) *
        Math.sin(dLon / 2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    const distance = R * c;
    return Math.round(distance * 10) / 10;
  }

  private deg2rad(deg: number): number {
    return deg * (Math.PI / 180);
  }

  /**
   * Получить статистику индексов Meilisearch
   */
  async getIndexStats() {
    try {
      const [mastersStats, servicesStats, templatesStats, categoriesStats, usersStats] =
        await Promise.all([
          this.mastersIndex.getStats(),
          this.servicesIndex.getStats(),
          this.serviceTemplatesIndex.getStats(),
          this.categoriesIndex.getStats(),
          this.usersIndex.getStats(),
        ]);

      return {
        masters: mastersStats,
        services: servicesStats,
        service_templates: templatesStats,
        categories: categoriesStats,
        users: usersStats,
      };
    } catch (error) {
      console.error('❌ Error getting index stats:', error);
      return {
        masters: { numberOfDocuments: 0, isIndexing: false },
        services: { numberOfDocuments: 0, isIndexing: false },
        service_templates: { numberOfDocuments: 0, isIndexing: false },
        categories: { numberOfDocuments: 0, isIndexing: false },
        users: { numberOfDocuments: 0, isIndexing: false },
      };
    }
  }
}
