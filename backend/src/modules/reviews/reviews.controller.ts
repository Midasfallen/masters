import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
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
  ApiConflictResponse,
  ApiQuery,
} from '@nestjs/swagger';
import { ReviewsService } from './reviews.service';
import { CreateReviewDto } from './dto/create-review.dto';
import { ResponseReviewDto } from './dto/response-review.dto';
import { ReviewResponseDto, ReviewStatsDto } from './dto/review-response.dto';
import { FilterReviewsDto } from './dto/filter-reviews.dto';
import { ReviewerType } from './entities/review.entity';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { Public } from '../auth/decorators/public.decorator';

@ApiTags('Reviews')
@Controller('reviews')
export class ReviewsController {
  constructor(private readonly reviewsService: ReviewsService) {}

  @Post()
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Создать отзыв',
    description:
      'Создание отзыва после завершения бронирования. Клиент оставляет отзыв мастеру, мастер - клиенту.',
  })
  @ApiCreatedResponse({
    description: 'Отзыв создан',
    type: ReviewResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        bookingId: '550e8400-e29b-41d4-a716-446655440000',
        reviewerId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        reviewedUserId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        reviewerType: 'client',
        rating: 5,
        comment: 'Отличная работа! Очень доволен результатом.',
        photoUrls: ['https://storage.example.com/reviews/photo1.jpg'],
        response: null,
        responseAt: null,
        isVisible: true,
        reportsCount: 0,
        isApproved: true,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T10:30:00Z',
        reviewer: {
          id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: 'https://storage.example.com/avatar.jpg',
        },
        reviewedUser: {
          id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          firstName: 'Анна',
          lastName: 'Иванова',
          avatarUrl: 'https://storage.example.com/avatar2.jpg',
        },
        booking: {
          id: '550e8400-e29b-41d4-a716-446655440000',
          serviceId: '550e8400-e29b-41d4-a716-446655440000',
          startTime: '2025-01-10T14:00:00Z',
        },
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Бронирование не завершено или невалидные данные',
    schema: {
      examples: {
        bookingNotCompleted: {
          value: {
            statusCode: 400,
            message: 'Booking is not completed yet',
            error: 'Bad Request',
          },
        },
        invalidRating: {
          value: {
            statusCode: 400,
            message: ['rating must not be less than 1', 'rating must not be greater than 5'],
            error: 'Bad Request',
          },
        },
        invalidComment: {
          value: {
            statusCode: 400,
            message: ['comment must be longer than or equal to 10 characters'],
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
  @ApiConflictResponse({
    description: 'Отзыв уже оставлен',
    schema: {
      example: {
        statusCode: 409,
        message: 'Review already exists for this booking',
        error: 'Conflict',
      },
    },
  })
  async create(
    @Request() req,
    @Body() createReviewDto: CreateReviewDto,
  ): Promise<ReviewResponseDto> {
    return this.reviewsService.create(req.user.sub, createReviewDto);
  }

  @Patch(':id/respond')
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Ответить на отзыв',
    description:
      'Пользователь, которому оставлен отзыв, может оставить ответ на него',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID отзыва',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Ответ добавлен',
    type: ReviewResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        bookingId: '550e8400-e29b-41d4-a716-446655440000',
        reviewerId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        reviewedUserId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        reviewerType: 'client',
        rating: 5,
        comment: 'Отличная работа! Очень доволен результатом.',
        photoUrls: ['https://storage.example.com/reviews/photo1.jpg'],
        response: 'Спасибо за отзыв! Рад, что вам понравилось.',
        responseAt: '2025-01-13T11:00:00Z',
        isVisible: true,
        reportsCount: 0,
        isApproved: true,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T11:00:00Z',
        reviewer: {
          id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: 'https://storage.example.com/avatar.jpg',
        },
        reviewedUser: {
          id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          firstName: 'Анна',
          lastName: 'Иванова',
          avatarUrl: 'https://storage.example.com/avatar2.jpg',
        },
        booking: {
          id: '550e8400-e29b-41d4-a716-446655440000',
          serviceId: '550e8400-e29b-41d4-a716-446655440000',
          startTime: '2025-01-10T14:00:00Z',
        },
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      example: {
        statusCode: 400,
        message: ['response must be longer than or equal to 10 characters'],
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
    description: 'Можно отвечать только на отзывы о себе',
    schema: {
      example: {
        statusCode: 403,
        message: 'You can only respond to reviews about you',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Отзыв не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Review not found',
        error: 'Not Found',
      },
    },
  })
  @ApiConflictResponse({
    description: 'Ответ уже оставлен',
    schema: {
      example: {
        statusCode: 409,
        message: 'Response already exists for this review',
        error: 'Conflict',
      },
    },
  })
  async respond(
    @Request() req,
    @Param('id') id: string,
    @Body() responseDto: ResponseReviewDto,
  ): Promise<ReviewResponseDto> {
    return this.reviewsService.respondToReview(req.user.sub, id, responseDto);
  }

  @Post(':id/report')
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Пожаловаться на отзыв',
    description:
      'Отправка жалобы на отзыв. При 5+ жалобах отзыв автоматически скрывается',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID отзыва',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Жалоба принята',
    schema: {
      example: {
        message: 'Report submitted successfully',
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
  @ApiNotFoundResponse({
    description: 'Отзыв не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Review not found',
        error: 'Not Found',
      },
    },
  })
  async report(@Param('id') id: string): Promise<void> {
    return this.reviewsService.reportReview(id);
  }

  @Public()
  @Get('user/:userId/stats')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить статистику отзывов пользователя',
    description:
      'Возвращает общую статистику: средний рейтинг, распределение оценок, количество отзывов',
  })
  @ApiParam({
    name: 'userId',
    description: 'UUID пользователя',
    example: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
  })
  @ApiOkResponse({
    description: 'Статистика отзывов',
    type: ReviewStatsDto,
    schema: {
      example: {
        averageRating: 4.75,
        totalReviews: 127,
        ratingDistribution: {
          5: 85,
          4: 30,
          3: 8,
          2: 3,
          1: 1,
        },
        reviewsWithComments: 95,
        reviewsWithPhotos: 42,
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
    description: 'Пользователь не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'User not found',
        error: 'Not Found',
      },
    },
  })
  async getUserStats(@Param('userId') userId: string): Promise<ReviewStatsDto> {
    return this.reviewsService.getUserStats(userId);
  }

  @Public()
  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить список отзывов с фильтрами',
    description:
      'Публичный endpoint для получения отзывов с фильтрацией по пользователю, рейтингу и т.д.',
  })
  @ApiQuery({
    name: 'reviewed_user_id',
    required: false,
    type: String,
    description: 'ID пользователя, которому оставлены отзывы',
    example: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
  })
  @ApiQuery({
    name: 'reviewer_id',
    required: false,
    type: String,
    description: 'ID автора отзывов',
    example: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
  })
  @ApiQuery({
    name: 'min_rating',
    required: false,
    type: Number,
    description: 'Минимальная оценка (1-5)',
    example: 4,
  })
  @ApiQuery({
    name: 'max_rating',
    required: false,
    type: Number,
    description: 'Максимальная оценка (1-5)',
    example: 5,
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
    description: 'Список отзывов',
    schema: {
      example: {
        data: [
          {
            id: '550e8400-e29b-41d4-a716-446655440000',
            bookingId: '550e8400-e29b-41d4-a716-446655440000',
            reviewerId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
            reviewedUserId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
            reviewerType: 'client',
            rating: 5,
            comment: 'Отличная работа! Очень доволен результатом.',
            photoUrls: ['https://storage.example.com/reviews/photo1.jpg'],
            response: null,
            responseAt: null,
            isVisible: true,
            reportsCount: 0,
            isApproved: true,
            createdAt: '2025-01-13T10:30:00Z',
            updatedAt: '2025-01-13T10:30:00Z',
            reviewer: {
              id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
              firstName: 'Иван',
              lastName: 'Петров',
              avatarUrl: 'https://storage.example.com/avatar.jpg',
            },
            reviewedUser: {
              id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
              firstName: 'Анна',
              lastName: 'Иванова',
              avatarUrl: 'https://storage.example.com/avatar2.jpg',
            },
            booking: {
              id: '550e8400-e29b-41d4-a716-446655440000',
              serviceId: '550e8400-e29b-41d4-a716-446655440000',
              startTime: '2025-01-10T14:00:00Z',
            },
          },
        ],
        total: 127,
        page: 1,
        limit: 20,
      },
    },
  })
  async findAll(
    @Query() filterDto: FilterReviewsDto,
  ): Promise<{ data: ReviewResponseDto[]; total: number; page: number; limit: number }> {
    return this.reviewsService.findAll(filterDto);
  }

  @Public()
  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить отзыв по ID',
    description: 'Публичный просмотр отдельного отзыва',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID отзыва',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Данные отзыва',
    type: ReviewResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        bookingId: '550e8400-e29b-41d4-a716-446655440000',
        reviewerId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        reviewedUserId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        reviewerType: 'client',
        rating: 5,
        comment: 'Отличная работа! Очень доволен результатом.',
        photoUrls: ['https://storage.example.com/reviews/photo1.jpg'],
        response: 'Спасибо за отзыв!',
        responseAt: '2025-01-13T11:00:00Z',
        isVisible: true,
        reportsCount: 0,
        isApproved: true,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T11:00:00Z',
        reviewer: {
          id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: 'https://storage.example.com/avatar.jpg',
        },
        reviewedUser: {
          id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          firstName: 'Анна',
          lastName: 'Иванова',
          avatarUrl: 'https://storage.example.com/avatar2.jpg',
        },
        booking: {
          id: '550e8400-e29b-41d4-a716-446655440000',
          serviceId: '550e8400-e29b-41d4-a716-446655440000',
          startTime: '2025-01-10T14:00:00Z',
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
    description: 'Отзыв не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Review not found',
        error: 'Not Found',
      },
    },
  })
  async findOne(@Param('id') id: string): Promise<ReviewResponseDto> {
    return this.reviewsService.findOne(id);
  }

  @Delete(':id')
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Удалить свой отзыв',
    description:
      'Пользователь может удалить только свой отзыв (soft delete - скрытие)',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID отзыва',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Отзыв удален',
    schema: {
      example: {
        message: 'Review deleted successfully',
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
    description: 'Можно удалять только свои отзывы',
    schema: {
      example: {
        statusCode: 403,
        message: 'You can only delete your own reviews',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Отзыв не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Review not found',
        error: 'Not Found',
      },
    },
  })
  async remove(@Request() req, @Param('id') id: string): Promise<void> {
    return this.reviewsService.remove(req.user.sub, id);
  }

  @Get('unreviewed/bookings')
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить неотзывленные бронирования',
    description:
      'Возвращает список завершенных бронирований, на которые пользователь еще не оставил отзыв',
  })
  @ApiOkResponse({
    description: 'Список неотзывленных бронирований',
    schema: {
      example: [
        {
          id: '550e8400-e29b-41d4-a716-446655440000',
          serviceId: '550e8400-e29b-41d4-a716-446655440000',
          startTime: '2025-01-10T14:00:00Z',
          masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          masterName: 'Анна Иванова',
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
  async getUnreviewedBookings(@Request() req) {
    return this.reviewsService.getUnreviewedBookings(req.user.sub);
  }

  @Post('skip/:bookingId')
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Пропустить отзыв',
    description:
      'Обрабатывает пропуск напоминания об отзыве. Поддерживает grace period skip (один раз без последствий)',
  })
  @ApiParam({
    name: 'bookingId',
    description: 'UUID бронирования',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Пропуск обработан',
    schema: {
      example: {
        message: 'Review skip processed',
        gracePeriodUsed: false,
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Grace period уже использован или отзыв уже оставлен',
    schema: {
      examples: {
        gracePeriodUsed: {
          value: {
            statusCode: 400,
            message: 'Grace period already used',
            error: 'Bad Request',
          },
        },
        reviewExists: {
          value: {
            statusCode: 400,
            message: 'Review already exists for this booking',
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
  async skipReview(
    @Request() req,
    @Param('bookingId') bookingId: string,
    @Body() body: { isGracePeriod: boolean },
  ) {
    return this.reviewsService.handleSkipReview(
      req.user.sub,
      bookingId,
      body.isGracePeriod || false,
    );
  }
}
