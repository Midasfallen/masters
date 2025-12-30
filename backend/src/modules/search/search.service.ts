import { Injectable, OnModuleInit } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { MeiliSearch } from 'meilisearch';
import { User } from '../users/entities/user.entity';
import { MasterProfile } from '../masters/entities/master-profile.entity';
import { Service } from '../services/entities/service.entity';
import { SearchMastersDto } from './dto/search-masters.dto';
import { SearchServicesDto } from './dto/search-services.dto';
import {
  MasterSearchResultDto,
  ServiceSearchResultDto,
  SearchResponseDto,
} from './dto/search-response.dto';

@Injectable()
export class SearchService implements OnModuleInit {
  private meiliClient: MeiliSearch;
  private mastersIndex;
  private servicesIndex;

  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(MasterProfile)
    private readonly masterProfileRepository: Repository<MasterProfile>,
    @InjectRepository(Service)
    private readonly serviceRepository: Repository<Service>,
  ) {
    // Инициализация Meilisearch клиента
    this.meiliClient = new MeiliSearch({
      host: process.env.MEILISEARCH_HOST || 'http://localhost:7700',
      apiKey: process.env.MEILISEARCH_API_KEY || 'masterKey',
    });
  }

  async onModuleInit() {
    // Создание индексов при старте приложения
    try {
      this.mastersIndex = this.meiliClient.index('masters');
      this.servicesIndex = this.meiliClient.index('services');

      // Настройка searchable и filterable атрибутов
      await this.mastersIndex.updateSettings({
        searchableAttributes: [
          'first_name',
          'last_name',
          'description',
          'tags',
          'category_names',
        ],
        filterableAttributes: [
          'category_ids',
          'average_rating',
          'is_active',
          'location_lat',
          'location_lng',
        ],
        sortableAttributes: ['average_rating', 'reviews_count'],
      });

      await this.servicesIndex.updateSettings({
        searchableAttributes: ['name', 'description', 'tags', 'category_name'],
        filterableAttributes: [
          'category_id',
          'price',
          'duration_minutes',
          'is_active',
          'master_id',
        ],
        sortableAttributes: ['price', 'duration_minutes', 'bookings_count'],
      });
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

    if (searchDto.category_id) {
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

    if (searchDto.category_id) {
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
   * Индексация мастера (вызывается при создании/обновлении)
   */
  async indexMaster(userId: string): Promise<void> {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    const masterProfile = await this.masterProfileRepository.findOne({
      where: { user_id: userId },
    });

    if (!user || !masterProfile) return;

    const document = {
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      avatar_url: user.avatar_url,
      average_rating: Number(user.rating),
      reviews_count: user.reviews_count,
      description: masterProfile.bio,
      category_ids: masterProfile.category_ids,
      category_names: [], // TODO: Загрузить из Category
      tags: [], // TODO: Add tags field to MasterProfile entity
      location_address: masterProfile.location_address,
      location_lat: masterProfile.location_lat,
      location_lng: masterProfile.location_lng,
      is_active: masterProfile.is_active,
    };

    try {
      await this.mastersIndex.addDocuments([document]);
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

    const masterProfile = await this.masterProfileRepository.findOne({
      where: { id: service.master_id },
    });

    const master = masterProfile
      ? await this.userRepository.findOne({
          where: { id: masterProfile.user_id },
        })
      : null;

    const document = {
      id: service.id,
      name: service.name,
      description: service.description,
      price: service.price,
      duration_minutes: service.duration_minutes,
      category_id: service.category_id,
      category_name: '', // TODO: Загрузить из Category
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
      await this.servicesIndex.addDocuments([document]);
    } catch (error) {
      console.error('Error indexing service:', error);
    }
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
              OR to_tsvector('russian', COALESCE(profile.business_name, '')) @@ plainto_tsquery('russian', :query)
            )`,
            { query: cleanQuery },
          );
        }
      }

      // Category filter
      if (searchDto.category_id) {
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
              to_tsvector('russian', COALESCE(user.first_name, '') || ' ' || COALESCE(user.last_name, '') || ' ' || COALESCE(profile.bio, '') || ' ' || COALESCE(profile.business_name, '')),
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

      // Category filter
      if (searchDto.category_id) {
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
}
