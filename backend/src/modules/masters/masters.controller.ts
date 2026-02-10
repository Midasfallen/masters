import {
  Controller,
  Get,
  Post,
  Patch,
  Body,
  Param,
  ParseIntPipe,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiParam,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiBadRequestResponse,
  ApiUnauthorizedResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { MastersService } from './masters.service';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { User } from '../users/entities/user.entity';
import { Step1CategoriesDto } from './dto/step1-categories.dto';
import { Step2ProfileInfoDto } from './dto/step2-profile-info.dto';
import { Step3PortfolioDto } from './dto/step3-portfolio.dto';
import { Step4LocationDto } from './dto/step4-location.dto';
import { Step5ScheduleDto } from './dto/step5-schedule.dto';
import { MasterProfileResponseDto } from './dto/master-profile-response.dto';

@ApiTags('masters')
@ApiBearerAuth()
@Controller('masters')
export class MastersController {
  constructor(private readonly mastersService: MastersService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Начать создание профиля мастера',
    description:
      'Инициализирует пустой профиль мастера (setup_step = 0). После этого нужно пройти все 5 шагов.',
  })
  @ApiCreatedResponse({
    description: 'Профиль мастера создан',
    type: MasterProfileResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',

        bio: null,
        categoryIds: [],
        subcategoryIds: [],
        rating: 0,
        reviewsCount: 0,
        completedBookings: 0,
        cancellationsCount: 0,
        viewsCount: 0,
        favoritesCount: 0,
        subscribersCount: 0,
        locationLat: null,
        locationLng: null,
        locationAddress: null,
        locationName: null,
        serviceRadiusKm: null,
        isMobile: false,
        hasLocation: false,
        isOnlineOnly: false,
        portfolioUrls: [],
        videoUrls: [],
        certificates: [],
        setupStep: 0,
        isActive: false,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T10:30:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Профиль мастера уже создан',
    schema: {
      example: {
        statusCode: 400,
        message: 'Master profile already exists',
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
  async initializeProfile(@CurrentUser() user: User): Promise<MasterProfileResponseDto> {
    return this.mastersService.initializeProfile(user.id);
  }

  @Patch('me/step/1')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'ШАГ 1: Выбор категорий услуг',
    description: 'Мастер выбирает категории и подкатегории, в которых он работает',
  })
  @ApiOkResponse({
    description: 'Шаг 1 завершен',
    type: MasterProfileResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',

        bio: null,
        categoryIds: ['550e8400-e29b-41d4-a716-446655440000', '660e8400-e29b-41d4-a716-446655440001'],
        subcategoryIds: ['770e8400-e29b-41d4-a716-446655440002'],
        rating: 0,
        reviewsCount: 0,
        completedBookings: 0,
        cancellationsCount: 0,
        viewsCount: 0,
        favoritesCount: 0,
        subscribersCount: 0,
        locationLat: null,
        locationLng: null,
        locationAddress: null,
        locationName: null,
        serviceRadiusKm: null,
        isMobile: false,
        hasLocation: false,
        isOnlineOnly: false,
        portfolioUrls: [],
        videoUrls: [],
        certificates: [],
        setupStep: 1,
        isActive: false,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T10:35:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные или шаг уже завершен',
    schema: {
      examples: {
        invalidUUID: {
          value: {
            statusCode: 400,
            message: ['category_ids must be an array', 'category_ids must contain valid UUIDs'],
            error: 'Bad Request',
          },
        },
        stepAlreadyCompleted: {
          value: {
            statusCode: 400,
            message: 'Step 1 already completed. Current step: 2',
            error: 'Bad Request',
          },
        },
        profileNotFound: {
          value: {
            statusCode: 400,
            message: 'Master profile not found. Please initialize profile first',
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
  async updateStep1(
    @CurrentUser() user: User,
    @Body() step1Dto: Step1CategoriesDto,
  ): Promise<MasterProfileResponseDto> {
    return this.mastersService.updateStep1(user.id, step1Dto);
  }

  @Patch('me/step/2')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'ШАГ 2: Базовая информация профиля',
    description:
      'Название бизнеса, описание, опыт работы, языки, типы обслуживания',
  })
  @ApiOkResponse({
    description: 'Шаг 2 завершен',
    type: MasterProfileResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',

        bio: 'Опытный парикмахер с 10-летним стажем работы. Специализируюсь на стрижках и окрашивании волос.',
        categoryIds: ['550e8400-e29b-41d4-a716-446655440000'],
        subcategoryIds: ['770e8400-e29b-41d4-a716-446655440002'],
        rating: 0,
        reviewsCount: 0,
        completedBookings: 0,
        cancellationsCount: 0,
        viewsCount: 0,
        favoritesCount: 0,
        subscribersCount: 0,
        locationLat: null,
        locationLng: null,
        locationAddress: null,
        locationName: null,
        serviceRadiusKm: null,
        isMobile: true,
        hasLocation: true,
        isOnlineOnly: false,
        portfolioUrls: [],
        videoUrls: [],
        certificates: [],
        setupStep: 2,
        isActive: false,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T10:40:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Сначала завершите шаг 1 или некорректные данные',
    schema: {
      examples: {
        stepNotCompleted: {
          value: {
            statusCode: 400,
            message: 'Please complete step 1 first. Current step: 0',
            error: 'Bad Request',
          },
        },
        invalidBio: {
          value: {
            statusCode: 400,
            message: ['bio must be longer than or equal to 20 characters'],
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
  async updateStep2(
    @CurrentUser() user: User,
    @Body() step2Dto: Step2ProfileInfoDto,
  ): Promise<MasterProfileResponseDto> {
    return this.mastersService.updateStep2(user.id, step2Dto);
  }

  @Patch('me/step/3')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'ШАГ 3: Портфолио',
    description:
      'Загрузка фотографий работ (макс 20), видео (макс 5), сертификатов',
  })
  @ApiOkResponse({
    description: 'Шаг 3 завершен',
    type: MasterProfileResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',

        bio: 'Опытный парикмахер с 10-летним стажем работы',
        categoryIds: ['550e8400-e29b-41d4-a716-446655440000'],
        subcategoryIds: ['770e8400-e29b-41d4-a716-446655440002'],
        rating: 0,
        reviewsCount: 0,
        completedBookings: 0,
        cancellationsCount: 0,
        viewsCount: 0,
        favoritesCount: 0,
        subscribersCount: 0,
        locationLat: null,
        locationLng: null,
        locationAddress: null,
        locationName: null,
        serviceRadiusKm: null,
        isMobile: true,
        hasLocation: true,
        isOnlineOnly: false,
        portfolioUrls: [
          'https://storage.example.com/portfolio/photo1.jpg',
          'https://storage.example.com/portfolio/photo2.jpg',
        ],
        videoUrls: ['https://storage.example.com/videos/video1.mp4'],
        certificates: ['https://storage.example.com/certificates/cert1.jpg'],
        setupStep: 3,
        isActive: false,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T10:45:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Сначала завершите шаг 2 или некорректные данные',
    schema: {
      examples: {
        stepNotCompleted: {
          value: {
            statusCode: 400,
            message: 'Please complete step 2 first. Current step: 1',
            error: 'Bad Request',
          },
        },
        tooManyPhotos: {
          value: {
            statusCode: 400,
            message: ['portfolio_urls must contain no more than 20 elements'],
            error: 'Bad Request',
          },
        },
        tooManyVideos: {
          value: {
            statusCode: 400,
            message: ['video_urls must contain no more than 5 elements'],
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
  async updateStep3(
    @CurrentUser() user: User,
    @Body() step3Dto: Step3PortfolioDto,
  ): Promise<MasterProfileResponseDto> {
    return this.mastersService.updateStep3(user.id, step3Dto);
  }

  @Patch('me/step/4')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'ШАГ 4: География работы',
    description: 'Локация салона, адрес, радиус обслуживания для выездов',
  })
  @ApiOkResponse({
    description: 'Шаг 4 завершен',
    type: MasterProfileResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',

        bio: 'Опытный парикмахер с 10-летним стажем работы',
        categoryIds: ['550e8400-e29b-41d4-a716-446655440000'],
        subcategoryIds: ['770e8400-e29b-41d4-a716-446655440002'],
        rating: 0,
        reviewsCount: 0,
        completedBookings: 0,
        cancellationsCount: 0,
        viewsCount: 0,
        favoritesCount: 0,
        subscribersCount: 0,
        locationLat: 55.7558,
        locationLng: 37.6173,
        locationAddress: 'Москва, ул. Тверская, д. 1',
        locationName: 'Центр Москвы',
        serviceRadiusKm: 10,
        isMobile: true,
        hasLocation: true,
        isOnlineOnly: false,
        portfolioUrls: ['https://storage.example.com/portfolio/photo1.jpg'],
        videoUrls: ['https://storage.example.com/videos/video1.mp4'],
        certificates: [],
        setupStep: 4,
        isActive: false,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T10:50:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Сначала завершите шаг 3 или некорректные данные',
    schema: {
      examples: {
        stepNotCompleted: {
          value: {
            statusCode: 400,
            message: 'Please complete step 3 first. Current step: 2',
            error: 'Bad Request',
          },
        },
        invalidCoordinates: {
          value: {
            statusCode: 400,
            message: ['location_lat must be a number conforming to the specified constraints'],
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
  async updateStep4(
    @CurrentUser() user: User,
    @Body() step4Dto: Step4LocationDto,
  ): Promise<MasterProfileResponseDto> {
    return this.mastersService.updateStep4(user.id, step4Dto);
  }

  @Patch('me/step/5')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'ШАГ 5: Расписание и финализация (ФИНАЛЬНЫЙ ШАГ)',
    description:
      'График работы, настройки записей. После завершения: is_master=true, профиль активирован.',
  })
  @ApiOkResponse({
    description:
      'Профиль мастера создан! Пользователь теперь мастер (is_master=true)',
    type: MasterProfileResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',

        bio: 'Опытный парикмахер с 10-летним стажем работы',
        categoryIds: ['550e8400-e29b-41d4-a716-446655440000'],
        subcategoryIds: ['770e8400-e29b-41d4-a716-446655440002'],
        rating: 0,
        reviewsCount: 0,
        completedBookings: 0,
        cancellationsCount: 0,
        viewsCount: 0,
        favoritesCount: 0,
        subscribersCount: 0,
        locationLat: 55.7558,
        locationLng: 37.6173,
        locationAddress: 'Москва, ул. Тверская, д. 1',
        locationName: 'Центр Москвы',
        serviceRadiusKm: 10,
        isMobile: true,
        hasLocation: true,
        isOnlineOnly: false,
        portfolioUrls: ['https://storage.example.com/portfolio/photo1.jpg'],
        videoUrls: ['https://storage.example.com/videos/video1.mp4'],
        certificates: [],
        setupStep: 5,
        isActive: true,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T11:00:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Сначала завершите шаг 4 или некорректные данные',
    schema: {
      examples: {
        stepNotCompleted: {
          value: {
            statusCode: 400,
            message: 'Please complete step 4 first. Current step: 3',
            error: 'Bad Request',
          },
        },
        invalidSchedule: {
          value: {
            statusCode: 400,
            message: ['working_hours must be an object'],
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
  async updateStep5(
    @CurrentUser() user: User,
    @Body() step5Dto: Step5ScheduleDto,
  ): Promise<MasterProfileResponseDto> {
    return this.mastersService.updateStep5(user.id, step5Dto);
  }

  @Get('me')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить свой профиль мастера',
    description: 'Возвращает профиль мастера текущего пользователя',
  })
  @ApiOkResponse({
    description: 'Профиль мастера',
    type: MasterProfileResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',

        bio: 'Опытный парикмахер с 10-летним стажем работы',
        categoryIds: ['550e8400-e29b-41d4-a716-446655440000'],
        subcategoryIds: ['770e8400-e29b-41d4-a716-446655440002'],
        rating: 4.85,
        reviewsCount: 127,
        completedBookings: 245,
        cancellationsCount: 5,
        viewsCount: 750,
        favoritesCount: 42,
        subscribersCount: 128,
        locationLat: 55.7558,
        locationLng: 37.6173,
        locationAddress: 'Москва, ул. Тверская, д. 1',
        locationName: 'Центр Москвы',
        serviceRadiusKm: 10,
        isMobile: true,
        hasLocation: true,
        isOnlineOnly: false,
        portfolioUrls: ['https://storage.example.com/portfolio/photo1.jpg'],
        videoUrls: ['https://storage.example.com/videos/video1.mp4'],
        certificates: [],
        setupStep: 5,
        isActive: true,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T11:00:00Z',
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
  async getMyProfile(@CurrentUser() user: User): Promise<MasterProfileResponseDto> {
    return this.mastersService.getMyProfile(user.id);
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить профиль мастера по ID',
    description:
      'Публичный просмотр профиля мастера. Принимает как ID профиля мастера, так и ID пользователя (user_id). Сначала ищет по ID профиля, если не находит - ищет по user_id.',
  })
  @ApiParam({
    name: 'id',
    description:
      'UUID профиля мастера или UUID пользователя (user_id). Система автоматически определит тип ID.',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Профиль мастера',
    type: MasterProfileResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',

        bio: 'Опытный парикмахер с 10-летним стажем работы',
        categoryIds: ['550e8400-e29b-41d4-a716-446655440000'],
        subcategoryIds: ['770e8400-e29b-41d4-a716-446655440002'],
        rating: 4.85,
        reviewsCount: 127,
        completedBookings: 245,
        cancellationsCount: 5,
        viewsCount: 750,
        favoritesCount: 42,
        subscribersCount: 128,
        locationLat: 55.7558,
        locationLng: 37.6173,
        locationAddress: 'Москва, ул. Тверская, д. 1',
        locationName: 'Центр Москвы',
        serviceRadiusKm: 10,
        isMobile: true,
        hasLocation: true,
        isOnlineOnly: false,
        portfolioUrls: ['https://storage.example.com/portfolio/photo1.jpg'],
        videoUrls: ['https://storage.example.com/videos/video1.mp4'],
        certificates: [],
        setupStep: 5,
        isActive: true,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T11:00:00Z',
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
    description: 'Профиль не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Master profile not found',
        error: 'Not Found',
      },
    },
  })
  async getProfileById(@Param('id') id: string): Promise<MasterProfileResponseDto> {
    return this.mastersService.getProfileById(id);
  }
}
