import { Controller, Get, Query, HttpCode, HttpStatus } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiOkResponse,
  ApiBadRequestResponse,
  ApiQuery,
} from '@nestjs/swagger';
import { SearchService } from './search.service';
import { SearchMastersDto } from './dto/search-masters.dto';
import { SearchServicesDto } from './dto/search-services.dto';
import { SearchTemplatesDto } from './dto/search-templates.dto';
import {
  MasterSearchResultDto,
  ServiceSearchResultDto,
  ServiceTemplateSearchResultDto,
  SearchResponseDto,
} from './dto/search-response.dto';
import { Public } from '../auth/decorators/public.decorator';

@ApiTags('Search')
@Controller('search')
export class SearchController {
  constructor(private readonly searchService: SearchService) {}

  @Public()
  @Get('masters')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Поиск мастеров',
    description:
      'Полнотекстовый поиск мастеров с фильтрацией по категории, рейтингу, геолокации и тегам. Использует Meilisearch для быстрого поиска.',
  })
  @ApiQuery({
    name: 'q',
    required: false,
    type: String,
    description: 'Поисковый запрос',
    example: 'парикмахер',
  })
  @ApiQuery({
    name: 'category_ids',
    required: false,
    type: [String],
    description: 'Фильтр по категориям',
    example: ['550e8400-e29b-41d4-a716-446655440000'],
  })
  @ApiQuery({
    name: 'min_rating',
    required: false,
    type: Number,
    description: 'Минимальный рейтинг',
    example: 4.0,
  })
  @ApiQuery({
    name: 'lat',
    required: false,
    type: Number,
    description: 'Широта для поиска по геолокации',
    example: 55.7558,
  })
  @ApiQuery({
    name: 'lng',
    required: false,
    type: Number,
    description: 'Долгота для поиска по геолокации',
    example: 37.6173,
  })
  @ApiQuery({
    name: 'radius_km',
    required: false,
    type: Number,
    description: 'Радиус поиска в км',
    example: 10,
  })
  @ApiQuery({
    name: 'page',
    required: false,
    type: Number,
    description: 'Номер страницы',
    example: 1,
  })
  @ApiQuery({
    name: 'limit',
    required: false,
    type: Number,
    description: 'Количество результатов на странице',
    example: 20,
  })
  @ApiOkResponse({
    description: 'Результаты поиска мастеров',
    schema: {
      example: {
        data: [
          {
            id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
            userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
            businessName: 'Салон красоты "Элита"',
            bio: 'Опытный парикмахер с 10-летним стажем',
            rating: 4.85,
            reviewsCount: 127,
            locationLat: 55.7558,
            locationLng: 37.6173,
            distance: 2.5,
          },
        ],
        total: 45,
        page: 1,
        limit: 20,
        totalPages: 3,
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные параметры поиска',
    schema: {
      example: {
        statusCode: 400,
        message: ['min_rating must be a number', 'radius_km must be a positive number'],
        error: 'Bad Request',
      },
    },
  })
  async searchMasters(
    @Query() searchDto: SearchMastersDto,
  ): Promise<SearchResponseDto<MasterSearchResultDto>> {
    return this.searchService.searchMasters(searchDto);
  }

  @Public()
  @Get('services')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Поиск услуг',
    description:
      'Полнотекстовый поиск услуг с фильтрацией по категории, цене, длительности и тегам. Использует Meilisearch для быстрого поиска.',
  })
  @ApiQuery({
    name: 'q',
    required: false,
    type: String,
    description: 'Поисковый запрос',
    example: 'стрижка',
  })
  @ApiQuery({
    name: 'category_ids',
    required: false,
    type: [String],
    description: 'Фильтр по категориям',
    example: ['550e8400-e29b-41d4-a716-446655440000'],
  })
  @ApiQuery({
    name: 'min_price',
    required: false,
    type: Number,
    description: 'Минимальная цена',
    example: 1000,
  })
  @ApiQuery({
    name: 'max_price',
    required: false,
    type: Number,
    description: 'Максимальная цена',
    example: 5000,
  })
  @ApiQuery({
    name: 'max_duration',
    required: false,
    type: Number,
    description: 'Максимальная длительность в минутах',
    example: 120,
  })
  @ApiQuery({
    name: 'page',
    required: false,
    type: Number,
    description: 'Номер страницы',
    example: 1,
  })
  @ApiQuery({
    name: 'limit',
    required: false,
    type: Number,
    description: 'Количество результатов на странице',
    example: 20,
  })
  @ApiOkResponse({
    description: 'Результаты поиска услуг',
    schema: {
      example: {
        data: [
          {
            id: '550e8400-e29b-41d4-a716-446655440000',
            masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
            name: 'Мужская стрижка',
            description: 'Классическая мужская стрижка с укладкой',
            price: 1500,
            durationMinutes: 60,
            categoryId: '550e8400-e29b-41d4-a716-446655440000',
          },
        ],
        total: 128,
        page: 1,
        limit: 20,
        totalPages: 7,
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные параметры поиска',
    schema: {
      example: {
        statusCode: 400,
        message: ['min_price must be a number', 'max_price must be greater than min_price'],
        error: 'Bad Request',
      },
    },
  })
  async searchServices(
    @Query() searchDto: SearchServicesDto,
  ): Promise<SearchResponseDto<ServiceSearchResultDto>> {
    return this.searchService.searchServices(searchDto);
  }

  @Public()
  @Get('templates')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Поиск шаблонов услуг',
    description:
      'Полнотекстовый поиск шаблонов услуг по названию и ключевым словам. Используется для приоритета в глобальной строке поиска. Фильтр по категории (уровень 1) опционален.',
  })
  @ApiQuery({
    name: 'q',
    required: false,
    type: String,
    description: 'Поисковый запрос',
    example: 'стрижка',
  })
  @ApiQuery({
    name: 'category_id',
    required: false,
    type: String,
    description: 'ID категории (уровень 1) для фильтрации',
  })
  @ApiQuery({
    name: 'page',
    required: false,
    type: Number,
    description: 'Номер страницы',
    example: 1,
  })
  @ApiQuery({
    name: 'limit',
    required: false,
    type: Number,
    description: 'Количество результатов на странице',
    example: 20,
  })
  @ApiOkResponse({
    description: 'Результаты поиска шаблонов услуг',
    schema: {
      example: {
        data: [
          {
            id: '550e8400-e29b-41d4-a716-446655440000',
            slug: 'muzhskaya-strizhka',
            name: 'Мужская стрижка',
            description: 'Классическая мужская стрижка',
            category_id: '550e8400-e29b-41d4-a716-446655440001',
            default_duration_minutes: 60,
            default_price_range_min: 500,
            default_price_range_max: 2000,
          },
        ],
        total: 1,
        page: 1,
        limit: 20,
        processing_time_ms: 5,
        query: 'стрижка',
      },
    },
  })
  async searchTemplates(
    @Query() searchDto: SearchTemplatesDto,
  ): Promise<SearchResponseDto<ServiceTemplateSearchResultDto>> {
    return this.searchService.searchServiceTemplates(searchDto);
  }
}
