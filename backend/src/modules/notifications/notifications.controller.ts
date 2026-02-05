import {
  Controller,
  Get,
  Post,
  Patch,
  Delete,
  Param,
  Query,
  Body,
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
  ApiOkResponse,
  ApiBadRequestResponse,
  ApiUnauthorizedResponse,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiQuery,
  ApiNoContentResponse,
  ApiConflictResponse,
} from '@nestjs/swagger';
import { NotificationsService } from './notifications.service';
import { NotificationResponseDto } from './dto/notification-response.dto';
import { FilterNotificationsDto } from './dto/filter-notifications.dto';
import { MarkAsReadDto } from './dto/mark-as-read.dto';
import { RegisterDeviceDto } from './dto/register-device.dto';
import { NotificationType } from './entities/notification.entity';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('Notifications')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('notifications')
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}

  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить список уведомлений',
    description: 'Получение уведомлений текущего пользователя с фильтрами и пагинацией',
  })
  @ApiQuery({
    name: 'type',
    required: false,
    enum: NotificationType,
    description: 'Фильтр по типу уведомления',
    example: NotificationType.BOOKING_CONFIRMED,
  })
  @ApiQuery({
    name: 'is_read',
    required: false,
    type: Boolean,
    description: 'Фильтр по статусу прочтения',
    example: false,
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
    description: 'Список уведомлений с количеством непрочитанных',
    schema: {
      example: {
        data: [
          {
            id: '550e8400-e29b-41d4-a716-446655440000',
            userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
            type: 'booking_confirmed',
            title: 'Бронирование подтверждено',
            message: 'Ваша запись на 25 января подтверждена',
            isRead: false,
            relatedId: '550e8400-e29b-41d4-a716-446655440001',
            relatedType: 'booking',
            metadata: {
              bookingId: '550e8400-e29b-41d4-a716-446655440001',
              masterName: 'Анна Иванова',
            },
            actionUrl: '/bookings/550e8400-e29b-41d4-a716-446655440001',
            createdAt: '2025-01-13T10:30:00Z',
          },
        ],
        total: 45,
        unread_count: 12,
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
    @Query() filterDto: FilterNotificationsDto,
  ): Promise<{
    data: NotificationResponseDto[];
    total: number;
    unread_count: number;
    page: number;
    limit: number;
  }> {
    return this.notificationsService.findAll(req.user.sub, filterDto);
  }

  @Get('unread-count')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить количество непрочитанных уведомлений',
    description: 'Возвращает только число непрочитанных уведомлений',
  })
  @ApiOkResponse({
    description: 'Количество непрочитанных',
    schema: {
      example: {
        count: 12,
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
  async getUnreadCount(@Request() req): Promise<{ count: number }> {
    const count = await this.notificationsService.getUnreadCount(req.user.sub);
    return { count };
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить уведомление по ID',
    description: 'Получение конкретного уведомления. Доступ только к своим уведомлениям.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID уведомления',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Данные уведомления',
    type: NotificationResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        type: 'booking_confirmed',
        title: 'Бронирование подтверждено',
        message: 'Ваша запись на 25 января подтверждена',
        isRead: false,
        relatedId: '550e8400-e29b-41d4-a716-446655440001',
        relatedType: 'booking',
        metadata: {
          bookingId: '550e8400-e29b-41d4-a716-446655440001',
          masterName: 'Анна Иванова',
        },
        actionUrl: '/bookings/550e8400-e29b-41d4-a716-446655440001',
        createdAt: '2025-01-13T10:30:00Z',
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
    description: 'Нет доступа к уведомлению',
    schema: {
      example: {
        statusCode: 403,
        message: 'You do not have access to this notification',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Уведомление не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Notification not found',
        error: 'Not Found',
      },
    },
  })
  async findOne(
    @Request() req,
    @Param('id') id: string,
  ): Promise<NotificationResponseDto> {
    return this.notificationsService.findOne(req.user.sub, id);
  }

  @Patch(':id/read')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Отметить уведомление как прочитанное',
    description: 'Изменяет статус is_read на true',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID уведомления',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Уведомление отмечено',
    type: NotificationResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        type: 'booking_confirmed',
        title: 'Бронирование подтверждено',
        message: 'Ваша запись на 25 января подтверждена',
        isRead: true,
        relatedId: '550e8400-e29b-41d4-a716-446655440001',
        relatedType: 'booking',
        metadata: {
          bookingId: '550e8400-e29b-41d4-a716-446655440001',
          masterName: 'Анна Иванова',
        },
        actionUrl: '/bookings/550e8400-e29b-41d4-a716-446655440001',
        createdAt: '2025-01-13T10:30:00Z',
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
    description: 'Нет доступа к уведомлению',
    schema: {
      example: {
        statusCode: 403,
        message: 'You do not have access to this notification',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Уведомление не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Notification not found',
        error: 'Not Found',
      },
    },
  })
  async markAsRead(
    @Request() req,
    @Param('id') id: string,
  ): Promise<NotificationResponseDto> {
    return this.notificationsService.markAsRead(req.user.sub, id);
  }

  @Patch('read-multiple')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Отметить несколько уведомлений как прочитанные',
    description: 'Массовая пометка уведомлений по списку ID',
  })
  @ApiOkResponse({
    description: 'Уведомления отмечены',
    schema: {
      example: {
        message: 'Notifications marked as read',
        count: 5,
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      example: {
        statusCode: 400,
        message: [
          'notification_ids must be an array',
          'each value in notification_ids must be a UUID',
        ],
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
    description: 'Некоторые уведомления не принадлежат пользователю',
    schema: {
      example: {
        statusCode: 403,
        message: 'Some notifications do not belong to you',
        error: 'Forbidden',
      },
    },
  })
  async markMultipleAsRead(
    @Request() req,
    @Body() markAsReadDto: MarkAsReadDto,
  ): Promise<void> {
    return this.notificationsService.markMultipleAsRead(
      req.user.sub,
      markAsReadDto,
    );
  }

  @Patch('read-all')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Отметить все уведомления как прочитанные',
    description: 'Помечает все непрочитанные уведомления пользователя',
  })
  @ApiOkResponse({
    description: 'Все уведомления отмечены',
    schema: {
      example: {
        message: 'All notifications marked as read',
        count: 12,
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
  async markAllAsRead(@Request() req): Promise<void> {
    return this.notificationsService.markAllAsRead(req.user.sub);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Удалить уведомление',
    description: 'Полное удаление уведомления',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID уведомления',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiNoContentResponse({
    description: 'Уведомление удалено',
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
    description: 'Нет доступа к уведомлению',
    schema: {
      example: {
        statusCode: 403,
        message: 'You do not have access to this notification',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Уведомление не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Notification not found',
        error: 'Not Found',
      },
    },
  })
  async remove(@Request() req, @Param('id') id: string): Promise<void> {
    return this.notificationsService.remove(req.user.sub, id);
  }

  @Delete('clear-read')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Удалить все прочитанные уведомления',
    description: 'Очистка прочитанных уведомлений пользователя',
  })
  @ApiOkResponse({
    description: 'Прочитанные уведомления удалены',
    schema: {
      example: {
        message: 'Read notifications cleared',
        count: 33,
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
  async removeAllRead(@Request() req): Promise<void> {
    return this.notificationsService.removeAllRead(req.user.sub);
  }

  // ============ DEVICE TOKEN ENDPOINTS ============

  @Post('devices/register')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Регистрация device token для push-уведомлений',
    description: 'Регистрирует FCM/APNs токен устройства для отправки push-уведомлений',
  })
  @ApiOkResponse({
    description: 'Device token успешно зарегистрирован',
    schema: {
      example: {
        message: 'Device token registered successfully',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      example: {
        statusCode: 400,
        message: [
          'device_token must be a string',
          'platform must be one of the following values: android, ios, web',
        ],
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
  @ApiConflictResponse({
    description: 'Ошибка регистрации токена',
    schema: {
      example: {
        statusCode: 409,
        message: 'Device token already registered',
        error: 'Conflict',
      },
    },
  })
  async registerDevice(
    @Request() req,
    @Body() registerDto: RegisterDeviceDto,
  ): Promise<{ message: string }> {
    await this.notificationsService.registerDeviceToken(req.user.sub, registerDto);
    return { message: 'Device token registered successfully' };
  }

  @Delete('devices/:token')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Удаление device token',
    description: 'Удаляет токен устройства (при выходе из аккаунта)',
  })
  @ApiParam({
    name: 'token',
    description: 'FCM/APNs токен устройства',
    example: 'fcm_token_example_123456789',
  })
  @ApiOkResponse({
    description: 'Device token успешно удален',
    schema: {
      example: {
        message: 'Device token unregistered successfully',
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
    description: 'Device token не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Device token not found',
        error: 'Not Found',
      },
    },
  })
  async unregisterDevice(
    @Request() req,
    @Param('token') token: string,
  ): Promise<{ message: string }> {
    await this.notificationsService.unregisterDeviceToken(req.user.sub, token);
    return { message: 'Device token unregistered successfully' };
  }
}
