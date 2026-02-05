import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Query,
  UseGuards,
  Request,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiParam,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiBadRequestResponse,
  ApiUnauthorizedResponse,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiQuery,
} from '@nestjs/swagger';
import { BookingsService } from './bookings.service';
import { CreateBookingDto } from './dto/create-booking.dto';
import { CancelBookingDto } from './dto/cancel-booking.dto';
import { BookingResponseDto } from './dto/booking-response.dto';
import { FilterBookingsDto } from './dto/filter-bookings.dto';
import { BookingStatus } from './entities/booking.entity';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { PendingReviewsGuard } from '../../common/guards/pending-reviews.guard';

@ApiTags('Bookings')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('bookings')
export class BookingsController {
  constructor(private readonly bookingsService: BookingsService) {}

  @Post()
  @UseGuards(PendingReviewsGuard)
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Создать новое бронирование',
    description: 'Создает новое бронирование услуги. Требует, чтобы все предыдущие завершенные бронирования имели отзывы.',
  })
  @ApiCreatedResponse({
    description: 'Бронирование создано',
    type: BookingResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        clientId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        serviceId: '550e8400-e29b-41d4-a716-446655440000',
        startTime: '2025-01-20T14:00:00Z',
        endTime: '2025-01-20T15:30:00Z',
        durationMinutes: 90,
        price: 1500,
        status: 'pending',
        comment: 'Нужна стрижка под машинку',
        cancellationReason: null,
        cancelledBy: null,
        locationType: 'salon',
        locationAddress: null,
        locationLat: null,
        locationLng: null,
        metadata: {},
        client: {
          id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: 'https://storage.example.com/avatar.jpg',
          phone: '+79001234567',
        },
        master: {
          id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          firstName: 'Анна',
          lastName: 'Иванова',
          avatarUrl: 'https://storage.example.com/avatar2.jpg',
          phone: '+79001234568',
        },
        service: {
          id: '550e8400-e29b-41d4-a716-446655440000',
          name: 'Мужская стрижка',
          price: 1500,
          durationMinutes: 90,
        },
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T10:30:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Невалидные данные',
    schema: {
      examples: {
        invalidData: {
          value: {
            statusCode: 400,
            message: [
              'service_id must be a UUID',
              'start_time must be a valid ISO 8601 date string',
              'comment must be shorter than or equal to 500 characters',
            ],
            error: 'Bad Request',
          },
        },
        pastDate: {
          value: {
            statusCode: 400,
            message: 'Start time cannot be in the past',
            error: 'Bad Request',
          },
        },
        unavailableSlot: {
          value: {
            statusCode: 400,
            message: 'Time slot is not available',
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
    description: 'Необходимо оставить отзыв о предыдущей записи',
    schema: {
      example: {
        statusCode: 403,
        message: 'You have completed bookings without reviews. Please leave a review first.',
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
  async create(
    @Request() req,
    @Body() createBookingDto: CreateBookingDto,
  ): Promise<BookingResponseDto> {
    return this.bookingsService.create(req.user.id, createBookingDto);
  }

  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить список бронирований с фильтрами',
    description: 'Возвращает список всех бронирований пользователя с возможностью фильтрации по статусу, дате, услуге и т.д.',
  })
  @ApiQuery({
    name: 'status',
    required: false,
    enum: BookingStatus,
    description: 'Фильтр по статусу бронирования',
    example: BookingStatus.CONFIRMED,
  })
  @ApiQuery({
    name: 'service_id',
    required: false,
    type: String,
    description: 'Фильтр по ID услуги',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiQuery({
    name: 'start_date',
    required: false,
    type: String,
    description: 'Дата начала периода (ISO 8601)',
    example: '2025-01-01T00:00:00Z',
  })
  @ApiQuery({
    name: 'end_date',
    required: false,
    type: String,
    description: 'Дата окончания периода (ISO 8601)',
    example: '2025-12-31T23:59:59Z',
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
    description: 'Список бронирований',
    schema: {
      example: {
        data: [
          {
            id: '550e8400-e29b-41d4-a716-446655440000',
            clientId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
            masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
            serviceId: '550e8400-e29b-41d4-a716-446655440000',
            startTime: '2025-01-20T14:00:00Z',
            endTime: '2025-01-20T15:30:00Z',
            durationMinutes: 90,
            price: 1500,
            status: 'confirmed',
            comment: 'Нужна стрижка под машинку',
            cancellationReason: null,
            cancelledBy: null,
            locationType: 'salon',
            locationAddress: null,
            locationLat: null,
            locationLng: null,
            metadata: {},
            client: {
              id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
              firstName: 'Иван',
              lastName: 'Петров',
              avatarUrl: 'https://storage.example.com/avatar.jpg',
              phone: '+79001234567',
            },
            master: {
              id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
              firstName: 'Анна',
              lastName: 'Иванова',
              avatarUrl: 'https://storage.example.com/avatar2.jpg',
              phone: '+79001234568',
            },
            service: {
              id: '550e8400-e29b-41d4-a716-446655440000',
              name: 'Мужская стрижка',
              price: 1500,
              durationMinutes: 90,
            },
            createdAt: '2025-01-13T10:30:00Z',
            updatedAt: '2025-01-13T10:30:00Z',
          },
        ],
        total: 15,
        page: 1,
        limit: 20,
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
  async findAll(
    @Request() req,
    @Query() filterDto: FilterBookingsDto,
  ): Promise<{ data: BookingResponseDto[]; total: number; page: number; limit: number }> {
    return this.bookingsService.findAll(req.user.id, filterDto);
  }

  @Get('needs-review')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить бронирования, требующие отзыва',
    description:
      'Возвращает завершенные бронирования, по которым клиент еще не оставил отзыв',
  })
  @ApiOkResponse({
    description: 'Список бронирований для отзыва',
    type: [BookingResponseDto],
    schema: {
      example: [
        {
          id: '550e8400-e29b-41d4-a716-446655440000',
          clientId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          serviceId: '550e8400-e29b-41d4-a716-446655440000',
          startTime: '2025-01-10T14:00:00Z',
          endTime: '2025-01-10T15:30:00Z',
          durationMinutes: 90,
          price: 1500,
          status: 'completed',
          comment: null,
          cancellationReason: null,
          cancelledBy: null,
          locationType: 'salon',
          locationAddress: null,
          locationLat: null,
          locationLng: null,
          metadata: {},
          client: {
            id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
            firstName: 'Иван',
            lastName: 'Петров',
            avatarUrl: 'https://storage.example.com/avatar.jpg',
            phone: '+79001234567',
          },
          master: {
            id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
            firstName: 'Анна',
            lastName: 'Иванова',
            avatarUrl: 'https://storage.example.com/avatar2.jpg',
            phone: '+79001234568',
          },
          service: {
            id: '550e8400-e29b-41d4-a716-446655440000',
            name: 'Мужская стрижка',
            price: 1500,
            durationMinutes: 90,
          },
          createdAt: '2025-01-05T10:30:00Z',
          updatedAt: '2025-01-10T15:30:00Z',
        },
      ],
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
  async getBookingsNeedingReview(
    @Request() req,
  ): Promise<BookingResponseDto[]> {
    return this.bookingsService.getBookingsNeedingReview(req.user.id);
  }

  @Get('my')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить мои бронирования',
    description: 'Получить бронирования пользователя в роли клиента или мастера',
  })
  @ApiQuery({
    name: 'role',
    required: false,
    enum: ['client', 'master'],
    description: 'Роль пользователя (client или master)',
    example: 'client',
  })
  @ApiQuery({
    name: 'status',
    required: false,
    enum: BookingStatus,
    description: 'Фильтр по статусу',
    example: BookingStatus.CONFIRMED,
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
    description: 'Список бронирований',
    schema: {
      example: {
        data: [
          {
            id: '550e8400-e29b-41d4-a716-446655440000',
            clientId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
            masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
            serviceId: '550e8400-e29b-41d4-a716-446655440000',
            startTime: '2025-01-20T14:00:00Z',
            endTime: '2025-01-20T15:30:00Z',
            durationMinutes: 90,
            price: 1500,
            status: 'confirmed',
            comment: null,
            cancellationReason: null,
            cancelledBy: null,
            locationType: 'salon',
            locationAddress: null,
            locationLat: null,
            locationLng: null,
            metadata: {},
            client: {
              id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
              firstName: 'Иван',
              lastName: 'Петров',
              avatarUrl: 'https://storage.example.com/avatar.jpg',
              phone: '+79001234567',
            },
            master: {
              id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
              firstName: 'Анна',
              lastName: 'Иванова',
              avatarUrl: 'https://storage.example.com/avatar2.jpg',
              phone: '+79001234568',
            },
            service: {
              id: '550e8400-e29b-41d4-a716-446655440000',
              name: 'Мужская стрижка',
              price: 1500,
              durationMinutes: 90,
            },
            createdAt: '2025-01-13T10:30:00Z',
            updatedAt: '2025-01-13T10:30:00Z',
          },
        ],
        total: 8,
        page: 1,
        limit: 20,
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
  async getMyBookings(
    @Request() req,
    @Query('role') role: 'client' | 'master',
    @Query() filterDto: FilterBookingsDto,
  ): Promise<{ data: BookingResponseDto[]; total: number; page: number; limit: number }> {
    if (role === 'client') {
      return this.bookingsService.findAll(req.user.id, { ...filterDto, client_id: req.user.id });
    } else if (role === 'master') {
      return this.bookingsService.findAll(req.user.id, { ...filterDto, master_id: req.user.id });
    }
    // Default to client role
    return this.bookingsService.findAll(req.user.id, { ...filterDto, client_id: req.user.id });
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить бронирование по ID',
    description: 'Возвращает детальную информацию о бронировании. Доступ только для клиента или мастера, связанных с этим бронированием.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID бронирования',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Данные бронирования',
    type: BookingResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        clientId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        serviceId: '550e8400-e29b-41d4-a716-446655440000',
        startTime: '2025-01-20T14:00:00Z',
        endTime: '2025-01-20T15:30:00Z',
        durationMinutes: 90,
        price: 1500,
        status: 'confirmed',
        comment: 'Нужна стрижка под машинку',
        cancellationReason: null,
        cancelledBy: null,
        locationType: 'salon',
        locationAddress: null,
        locationLat: null,
        locationLng: null,
        metadata: {},
        client: {
          id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: 'https://storage.example.com/avatar.jpg',
          phone: '+79001234567',
        },
        master: {
          id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          firstName: 'Анна',
          lastName: 'Иванова',
          avatarUrl: 'https://storage.example.com/avatar2.jpg',
          phone: '+79001234568',
        },
        service: {
          id: '550e8400-e29b-41d4-a716-446655440000',
          name: 'Мужская стрижка',
          price: 1500,
          durationMinutes: 90,
        },
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
    description: 'Нет доступа к этому бронированию',
    schema: {
      example: {
        statusCode: 403,
        message: 'You do not have access to this booking',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Бронирование не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Booking not found',
        error: 'Not Found',
      },
    },
  })
  async findOne(
    @Request() req,
    @Param('id') id: string,
  ): Promise<BookingResponseDto> {
    return this.bookingsService.findOne(req.user.id, id);
  }

  @Post(':id/confirm')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Подтвердить бронирование (мастер)',
    description: 'Мастер подтверждает запрос на бронирование от клиента. Статус меняется с pending на confirmed.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID бронирования',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Бронирование подтверждено',
    type: BookingResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        clientId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        serviceId: '550e8400-e29b-41d4-a716-446655440000',
        startTime: '2025-01-20T14:00:00Z',
        endTime: '2025-01-20T15:30:00Z',
        durationMinutes: 90,
        price: 1500,
        status: 'confirmed',
        comment: 'Нужна стрижка под машинку',
        cancellationReason: null,
        cancelledBy: null,
        locationType: 'salon',
        locationAddress: null,
        locationLat: null,
        locationLng: null,
        metadata: {},
        client: {
          id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: 'https://storage.example.com/avatar.jpg',
          phone: '+79001234567',
        },
        master: {
          id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          firstName: 'Анна',
          lastName: 'Иванова',
          avatarUrl: 'https://storage.example.com/avatar2.jpg',
          phone: '+79001234568',
        },
        service: {
          id: '550e8400-e29b-41d4-a716-446655440000',
          name: 'Мужская стрижка',
          price: 1500,
          durationMinutes: 90,
        },
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T11:00:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Невозможно подтвердить (неверный статус)',
    schema: {
      example: {
        statusCode: 400,
        message: 'Cannot confirm booking. Current status: confirmed',
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
    description: 'Только мастер может подтвердить',
    schema: {
      example: {
        statusCode: 403,
        message: 'Only master can confirm booking',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Бронирование не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Booking not found',
        error: 'Not Found',
      },
    },
  })
  async confirm(
    @Request() req,
    @Param('id') id: string,
  ): Promise<BookingResponseDto> {
    return this.bookingsService.confirmBooking(req.user.id, id);
  }

  @Patch(':id/reject')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Отклонить бронирование (мастер)',
    description: 'Мастер отклоняет запрос на бронирование с указанием причины. Статус меняется на rejected.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID бронирования',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Бронирование отклонено',
    type: BookingResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        clientId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        serviceId: '550e8400-e29b-41d4-a716-446655440000',
        startTime: '2025-01-20T14:00:00Z',
        endTime: '2025-01-20T15:30:00Z',
        durationMinutes: 90,
        price: 1500,
        status: 'rejected',
        comment: 'Нужна стрижка под машинку',
        cancellationReason: 'Нет свободного времени в этот день',
        cancelledBy: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        locationType: 'salon',
        locationAddress: null,
        locationLat: null,
        locationLng: null,
        metadata: {},
        client: {
          id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: 'https://storage.example.com/avatar.jpg',
          phone: '+79001234567',
        },
        master: {
          id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          firstName: 'Анна',
          lastName: 'Иванова',
          avatarUrl: 'https://storage.example.com/avatar2.jpg',
          phone: '+79001234568',
        },
        service: {
          id: '550e8400-e29b-41d4-a716-446655440000',
          name: 'Мужская стрижка',
          price: 1500,
          durationMinutes: 90,
        },
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T11:05:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Невозможно отклонить (неверный статус) или отсутствует причина',
    schema: {
      examples: {
        invalidStatus: {
          value: {
            statusCode: 400,
            message: 'Cannot reject booking. Current status: completed',
            error: 'Bad Request',
          },
        },
        missingReason: {
          value: {
            statusCode: 400,
            message: ['reason should not be empty'],
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
    description: 'Только мастер может отклонить',
    schema: {
      example: {
        statusCode: 403,
        message: 'Only master can reject booking',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Бронирование не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Booking not found',
        error: 'Not Found',
      },
    },
  })
  async reject(
    @Request() req,
    @Param('id') id: string,
    @Body() body: { reason: string },
  ): Promise<BookingResponseDto> {
    return this.bookingsService.rejectBooking(req.user.id, id, body.reason);
  }

  @Post(':id/cancel')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Отменить бронирование',
    description:
      'Клиент или мастер может отменить бронирование с указанием причины. Клиент не может отменить менее чем за 1 час до начала.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID бронирования',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Бронирование отменено',
    type: BookingResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        clientId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        serviceId: '550e8400-e29b-41d4-a716-446655440000',
        startTime: '2025-01-20T14:00:00Z',
        endTime: '2025-01-20T15:30:00Z',
        durationMinutes: 90,
        price: 1500,
        status: 'cancelled',
        comment: 'Нужна стрижка под машинку',
        cancellationReason: 'Изменились планы',
        cancelledBy: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        locationType: 'salon',
        locationAddress: null,
        locationLat: null,
        locationLng: null,
        metadata: {},
        client: {
          id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: 'https://storage.example.com/avatar.jpg',
          phone: '+79001234567',
        },
        master: {
          id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          firstName: 'Анна',
          lastName: 'Иванова',
          avatarUrl: 'https://storage.example.com/avatar2.jpg',
          phone: '+79001234568',
        },
        service: {
          id: '550e8400-e29b-41d4-a716-446655440000',
          name: 'Мужская стрижка',
          price: 1500,
          durationMinutes: 90,
        },
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T11:10:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Невозможно отменить (неверный статус, слишком поздно или некорректные данные)',
    schema: {
      examples: {
        invalidStatus: {
          value: {
            statusCode: 400,
            message: 'Cannot cancel booking. Current status: completed',
            error: 'Bad Request',
          },
        },
        tooLate: {
          value: {
            statusCode: 400,
            message: 'Cannot cancel booking less than 1 hour before start time',
            error: 'Bad Request',
          },
        },
        invalidReason: {
          value: {
            statusCode: 400,
            message: ['cancellation_reason must be longer than or equal to 5 characters'],
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
    description: 'Нет прав для отмены этого бронирования',
    schema: {
      example: {
        statusCode: 403,
        message: 'You do not have permission to cancel this booking',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Бронирование не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Booking not found',
        error: 'Not Found',
      },
    },
  })
  async cancel(
    @Request() req,
    @Param('id') id: string,
    @Body() cancelDto: CancelBookingDto,
  ): Promise<BookingResponseDto> {
    return this.bookingsService.cancelBooking(req.user.id, id, cancelDto);
  }

  @Patch(':id/start')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Начать работу (мастер)',
    description:
      'Мастер отмечает, что клиент пришел и работа началась. Статус меняется с confirmed на in_progress.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID бронирования',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Работа началась',
    type: BookingResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        clientId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        serviceId: '550e8400-e29b-41d4-a716-446655440000',
        startTime: '2025-01-20T14:00:00Z',
        endTime: '2025-01-20T15:30:00Z',
        durationMinutes: 90,
        price: 1500,
        status: 'in_progress',
        comment: 'Нужна стрижка под машинку',
        cancellationReason: null,
        cancelledBy: null,
        locationType: 'salon',
        locationAddress: null,
        locationLat: null,
        locationLng: null,
        metadata: {},
        client: {
          id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: 'https://storage.example.com/avatar.jpg',
          phone: '+79001234567',
        },
        master: {
          id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          firstName: 'Анна',
          lastName: 'Иванова',
          avatarUrl: 'https://storage.example.com/avatar2.jpg',
          phone: '+79001234568',
        },
        service: {
          id: '550e8400-e29b-41d4-a716-446655440000',
          name: 'Мужская стрижка',
          price: 1500,
          durationMinutes: 90,
        },
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-20T14:00:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Невозможно начать (неверный статус)',
    schema: {
      example: {
        statusCode: 400,
        message: 'Cannot start booking. Current status: pending',
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
    description: 'Только мастер может начать работу',
    schema: {
      example: {
        statusCode: 403,
        message: 'Only master can start booking',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Бронирование не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Booking not found',
        error: 'Not Found',
      },
    },
  })
  async start(
    @Request() req,
    @Param('id') id: string,
  ): Promise<BookingResponseDto> {
    return this.bookingsService.startBooking(req.user.id, id);
  }

  @Post(':id/complete')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Завершить работу (мастер)',
    description:
      'Мастер завершает работу по бронированию. Статус меняется на completed. После этого клиент может оставить отзыв.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID бронирования',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Работа завершена',
    type: BookingResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        clientId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        serviceId: '550e8400-e29b-41d4-a716-446655440000',
        startTime: '2025-01-20T14:00:00Z',
        endTime: '2025-01-20T15:30:00Z',
        durationMinutes: 90,
        price: 1500,
        status: 'completed',
        comment: 'Нужна стрижка под машинку',
        cancellationReason: null,
        cancelledBy: null,
        locationType: 'salon',
        locationAddress: null,
        locationLat: null,
        locationLng: null,
        metadata: {},
        client: {
          id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: 'https://storage.example.com/avatar.jpg',
          phone: '+79001234567',
        },
        master: {
          id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          firstName: 'Анна',
          lastName: 'Иванова',
          avatarUrl: 'https://storage.example.com/avatar2.jpg',
          phone: '+79001234568',
        },
        service: {
          id: '550e8400-e29b-41d4-a716-446655440000',
          name: 'Мужская стрижка',
          price: 1500,
          durationMinutes: 90,
        },
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-20T15:30:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Невозможно завершить (неверный статус)',
    schema: {
      example: {
        statusCode: 400,
        message: 'Cannot complete booking. Current status: pending',
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
    description: 'Только мастер может завершить работу',
    schema: {
      example: {
        statusCode: 403,
        message: 'Only master can complete booking',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Бронирование не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Booking not found',
        error: 'Not Found',
      },
    },
  })
  async complete(
    @Request() req,
    @Param('id') id: string,
  ): Promise<BookingResponseDto> {
    return this.bookingsService.completeBooking(req.user.id, id);
  }
}
