import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Body,
  Param,
  Query,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiParam,
  ApiQuery,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiBadRequestResponse,
  ApiUnauthorizedResponse,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiNoContentResponse,
} from '@nestjs/swagger';
import { Public } from '../auth/decorators/public.decorator';
import { ServicesService } from './services.service';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { User } from '../users/entities/user.entity';
import { CreateServiceDto } from './dto/create-service.dto';
import { UpdateServiceDto } from './dto/update-service.dto';
import { FilterServicesDto } from './dto/filter-services.dto';
import { ServiceResponseDto } from './dto/service-response.dto';
import { PaginatedResponseDto } from '../../common/dto/pagination.dto';

@ApiTags('services')
@ApiBearerAuth()
@Controller('services')
export class ServicesController {
  constructor(private readonly servicesService: ServicesService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Создать новую услугу',
    description:
      'Только для мастеров с завершенным профилем. Категория услуги должна быть в профиле мастера.',
  })
  @ApiCreatedResponse({
    description: 'Услуга создана',
    type: ServiceResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        masterId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        categoryId: '550e8400-e29b-41d4-a716-446655440000',
        subcategoryId: '660e8400-e29b-41d4-a716-446655440001',
        name: 'Мужская стрижка',
        description: 'Классическая мужская стрижка с укладкой',
        price: 1500,
        currency: 'RUB',
        priceFrom: null,
        priceTo: null,
        durationMinutes: 60,
        isBookableOnline: true,
        isMobile: false,
        isInSalon: true,
        tags: ['стрижка', 'мужская', 'классика'],
        photoUrls: ['https://storage.example.com/services/photo1.jpg'],
        bookingsCount: 0,
        averageRating: 0,
        isActive: true,
        displayOrder: 0,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T10:30:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные или категория не в профиле мастера',
    schema: {
      examples: {
        invalidData: {
          value: {
            statusCode: 400,
            message: [
              'name must be longer than or equal to 3 characters',
              'price must be a positive number',
              'duration_minutes must not be less than 5',
            ],
            error: 'Bad Request',
          },
        },
        categoryNotInProfile: {
          value: {
            statusCode: 400,
            message: 'Category is not in master profile',
            error: 'Bad Request',
          },
        },
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiForbiddenResponse({
    description: 'Только мастера могут создавать услуги',
    schema: {
      example: {
        statusCode: 403,
        message: 'Only masters can create services',
        error: 'Forbidden',
      },
    },
  })
  async create(
    @CurrentUser() user: User,
    @Body() createServiceDto: CreateServiceDto,
  ): Promise<ServiceResponseDto> {
    return this.servicesService.create(user.id, createServiceDto);
  }

  @Public()
  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить услуги по категориям',
    description: 'Публичный endpoint для получения услуг, отфильтрованных по категориям',
  })
  @ApiQuery({
    name: 'category_ids',
    required: false,
    type: [String],
    description: 'Список UUID категорий для фильтрации',
    example: ['550e8400-e29b-41d4-a716-446655440000', '660e8400-e29b-41d4-a716-446655440001'],
  })
  @ApiOkResponse({
    description: 'Список услуг',
    type: ServiceResponseDto,
    isArray: true,
    schema: {
      example: [
        {
          id: '550e8400-e29b-41d4-a716-446655440000',
          masterId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          categoryId: '550e8400-e29b-41d4-a716-446655440000',
          subcategoryId: '660e8400-e29b-41d4-a716-446655440001',
          name: 'Мужская стрижка',
          description: 'Классическая мужская стрижка с укладкой',
          price: 1500,
          currency: 'RUB',
          priceFrom: null,
          priceTo: null,
          durationMinutes: 60,
          isBookableOnline: true,
          isMobile: false,
          isInSalon: true,
          tags: ['стрижка', 'мужская'],
          photoUrls: ['https://storage.example.com/services/photo1.jpg'],
          bookingsCount: 45,
          averageRating: 4.8,
          isActive: true,
          displayOrder: 0,
          createdAt: '2025-01-13T10:30:00Z',
          updatedAt: '2025-01-13T10:30:00Z',
        },
      ],
    },
  })
  async findByCategories(
    @Query('category_ids') categoryIds?: string[],
  ): Promise<ServiceResponseDto[]> {
    // Преобразуем строку или массив строк в массив
    const ids = Array.isArray(categoryIds)
      ? categoryIds
      : categoryIds
        ? [categoryIds]
        : undefined;
    return this.servicesService.findByCategoryIds(ids);
  }

  @Get('my')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить мои услуги',
    description: 'Список всех услуг текущего мастера с фильтрацией и пагинацией',
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
    description: 'Количество элементов на странице',
    example: 20,
  })
  @ApiOkResponse({
    description: 'Список услуг мастера',
    schema: {
      example: {
        data: [
          {
            id: '550e8400-e29b-41d4-a716-446655440000',
            masterId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
            categoryId: '550e8400-e29b-41d4-a716-446655440000',
            subcategoryId: null,
            name: 'Мужская стрижка',
            description: 'Классическая мужская стрижка',
            price: 1500,
            currency: 'RUB',
            priceFrom: null,
            priceTo: null,
            durationMinutes: 60,
            isBookableOnline: true,
            isMobile: false,
            isInSalon: true,
            tags: ['стрижка'],
            photoUrls: [],
            bookingsCount: 45,
            averageRating: 4.8,
            isActive: true,
            displayOrder: 0,
            createdAt: '2025-01-13T10:30:00Z',
            updatedAt: '2025-01-13T10:30:00Z',
          },
        ],
        meta: {
          page: 1,
          limit: 20,
          total: 8,
          totalPages: 1,
        },
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Профиль мастера не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Master profile not found',
        error: 'Not Found',
      },
    },
  })
  async getMyServices(
    @CurrentUser() user: User,
    @Query() filterDto: FilterServicesDto,
  ): Promise<PaginatedResponseDto<ServiceResponseDto>> {
    return this.servicesService.getMyServices(user.id, filterDto);
  }

  @Public()
  @Get('master/:masterId')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить услуги мастера',
    description: 'Публичный просмотр услуг конкретного мастера',
  })
  @ApiParam({
    name: 'masterId',
    description: 'UUID профиля мастера',
    example: '550e8400-e29b-41d4-a716-446655440000',
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
    description: 'Количество элементов на странице',
    example: 20,
  })
  @ApiOkResponse({
    description: 'Список услуг мастера',
    schema: {
      example: {
        data: [
          {
            id: '550e8400-e29b-41d4-a716-446655440000',
            masterId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
            categoryId: '550e8400-e29b-41d4-a716-446655440000',
            subcategoryId: null,
            name: 'Мужская стрижка',
            description: 'Классическая мужская стрижка',
            price: 1500,
            currency: 'RUB',
            priceFrom: null,
            priceTo: null,
            durationMinutes: 60,
            isBookableOnline: true,
            isMobile: false,
            isInSalon: true,
            tags: ['стрижка'],
            photoUrls: [],
            bookingsCount: 45,
            averageRating: 4.8,
            isActive: true,
            displayOrder: 0,
            createdAt: '2025-01-13T10:30:00Z',
            updatedAt: '2025-01-13T10:30:00Z',
          },
        ],
        meta: {
          page: 1,
          limit: 20,
          total: 4,
          totalPages: 1,
        },
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный UUID',
    schema: {
      example: {
        statusCode: 400,
        message: 'Validation failed (uuid is expected)',
        error: 'Bad Request',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Профиль мастера не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Master profile not found',
        error: 'Not Found',
      },
    },
  })
  async getServicesByMaster(
    @Param('masterId') masterId: string,
    @Query() filterDto: FilterServicesDto,
  ): Promise<PaginatedResponseDto<ServiceResponseDto>> {
    return this.servicesService.getServicesByMaster(masterId, filterDto);
  }

  @Public()
  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить услугу по ID',
    description: 'Детальная информация об услуге',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID услуги',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Информация об услуге',
    type: ServiceResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        masterId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        categoryId: '550e8400-e29b-41d4-a716-446655440000',
        subcategoryId: '660e8400-e29b-41d4-a716-446655440001',
        name: 'Мужская стрижка',
        description: 'Классическая мужская стрижка с укладкой',
        price: 1500,
        currency: 'RUB',
        priceFrom: null,
        priceTo: null,
        durationMinutes: 60,
        isBookableOnline: true,
        isMobile: false,
        isInSalon: true,
        tags: ['стрижка', 'мужская', 'классика'],
        photoUrls: ['https://storage.example.com/services/photo1.jpg'],
        bookingsCount: 45,
        averageRating: 4.8,
        isActive: true,
        displayOrder: 0,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T10:30:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный UUID',
    schema: {
      example: {
        statusCode: 400,
        message: 'Validation failed (uuid is expected)',
        error: 'Bad Request',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Услуга не найдена',
    schema: {
      example: {
        statusCode: 404,
        message: 'Service not found',
        error: 'Not Found',
      },
    },
  })
  async findById(@Param('id') id: string): Promise<ServiceResponseDto> {
    return this.servicesService.findById(id);
  }

  @Patch(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Обновить услугу',
    description: 'Только владелец может обновлять свои услуги',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID услуги',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Услуга обновлена',
    type: ServiceResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        masterId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        categoryId: '550e8400-e29b-41d4-a716-446655440000',
        subcategoryId: null,
        name: 'Мужская стрижка премиум',
        description: 'Классическая мужская стрижка с укладкой и бритьем',
        price: 2000,
        currency: 'RUB',
        priceFrom: null,
        priceTo: null,
        durationMinutes: 90,
        isBookableOnline: true,
        isMobile: false,
        isInSalon: true,
        tags: ['стрижка', 'мужская', 'премиум'],
        photoUrls: ['https://storage.example.com/services/photo1.jpg'],
        bookingsCount: 45,
        averageRating: 4.8,
        isActive: true,
        displayOrder: 0,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T11:00:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      example: {
        statusCode: 400,
        message: ['name must be longer than or equal to 3 characters'],
        error: 'Bad Request',
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiForbiddenResponse({
    description: 'Можно редактировать только свои услуги',
    schema: {
      example: {
        statusCode: 403,
        message: 'You can only edit your own services',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Услуга не найдена',
    schema: {
      example: {
        statusCode: 404,
        message: 'Service not found',
        error: 'Not Found',
      },
    },
  })
  async update(
    @CurrentUser() user: User,
    @Param('id') id: string,
    @Body() updateServiceDto: UpdateServiceDto,
  ): Promise<ServiceResponseDto> {
    return this.servicesService.update(user.id, id, updateServiceDto);
  }

  @Patch(':id/deactivate')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Деактивировать услугу',
    description: 'Мягкое удаление - услуга становится неактивной (is_active=false)',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID услуги',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Услуга деактивирована',
    type: ServiceResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        masterId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        categoryId: '550e8400-e29b-41d4-a716-446655440000',
        subcategoryId: null,
        name: 'Мужская стрижка',
        description: 'Классическая мужская стрижка',
        price: 1500,
        currency: 'RUB',
        priceFrom: null,
        priceTo: null,
        durationMinutes: 60,
        isBookableOnline: true,
        isMobile: false,
        isInSalon: true,
        tags: ['стрижка'],
        photoUrls: [],
        bookingsCount: 45,
        averageRating: 4.8,
        isActive: false,
        displayOrder: 0,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T11:05:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный UUID',
    schema: {
      example: {
        statusCode: 400,
        message: 'Validation failed (uuid is expected)',
        error: 'Bad Request',
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiForbiddenResponse({
    description: 'Можно деактивировать только свои услуги',
    schema: {
      example: {
        statusCode: 403,
        message: 'You can only deactivate your own services',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Услуга не найдена',
    schema: {
      example: {
        statusCode: 404,
        message: 'Service not found',
        error: 'Not Found',
      },
    },
  })
  async deactivate(@CurrentUser() user: User, @Param('id') id: string): Promise<ServiceResponseDto> {
    return this.servicesService.deactivate(user.id, id);
  }

  @Patch(':id/activate')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Активировать услугу',
    description: 'Активирует ранее деактивированную услугу (is_active=true)',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID услуги',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Услуга активирована',
    type: ServiceResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        masterId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        categoryId: '550e8400-e29b-41d4-a716-446655440000',
        subcategoryId: null,
        name: 'Мужская стрижка',
        description: 'Классическая мужская стрижка',
        price: 1500,
        currency: 'RUB',
        priceFrom: null,
        priceTo: null,
        durationMinutes: 60,
        isBookableOnline: true,
        isMobile: false,
        isInSalon: true,
        tags: ['стрижка'],
        photoUrls: [],
        bookingsCount: 45,
        averageRating: 4.8,
        isActive: true,
        displayOrder: 0,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T11:10:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный UUID',
    schema: {
      example: {
        statusCode: 400,
        message: 'Validation failed (uuid is expected)',
        error: 'Bad Request',
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiForbiddenResponse({
    description: 'Можно активировать только свои услуги',
    schema: {
      example: {
        statusCode: 403,
        message: 'You can only activate your own services',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Услуга не найдена',
    schema: {
      example: {
        statusCode: 404,
        message: 'Service not found',
        error: 'Not Found',
      },
    },
  })
  async activate(@CurrentUser() user: User, @Param('id') id: string): Promise<ServiceResponseDto> {
    return this.servicesService.activate(user.id, id);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Удалить услугу',
    description: 'Полное удаление услуги. Только владелец может удалять свои услуги.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID услуги',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiNoContentResponse({
    description: 'Услуга удалена',
  })
  @ApiBadRequestResponse({
    description: 'Некорректный UUID',
    schema: {
      example: {
        statusCode: 400,
        message: 'Validation failed (uuid is expected)',
        error: 'Bad Request',
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiForbiddenResponse({
    description: 'Можно удалять только свои услуги',
    schema: {
      example: {
        statusCode: 403,
        message: 'You can only delete your own services',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Услуга не найдена',
    schema: {
      example: {
        statusCode: 404,
        message: 'Service not found',
        error: 'Not Found',
      },
    },
  })
  async remove(@CurrentUser() user: User, @Param('id') id: string): Promise<void> {
    return this.servicesService.remove(user.id, id);
  }
}
