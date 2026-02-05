import {
  Body,
  Controller,
  Delete,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  ParseIntPipe,
  Post,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiForbiddenResponse,
  ApiNoContentResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiParam,
  ApiQuery,
  ApiTags,
  ApiUnauthorizedResponse
} from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AdminService } from './admin.service';
import {
  AdminStatsDto,
  BookingStatsDto,
  SystemHealthDto,
  UpdateUserStatusDto,
  UserManagementDto,
} from './dto/admin-stats.dto';
import { AdminGuard } from './guards/admin.guard';

@ApiTags('Admin')
@ApiBearerAuth()
@Controller('admin')
@UseGuards(JwtAuthGuard, AdminGuard)
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Get('stats')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить статистику платформы',
    description: 'Возвращает общую статистику платформы: количество пользователей, мастеров, бронирований и т.д.',
  })
  @ApiOkResponse({
    description: 'Статистика платформы',
    type: AdminStatsDto,
    schema: {
      example: {
        totalUsers: 1250,
        totalMasters: 350,
        totalBookings: 5420,
        activeBookings: 125,
        completedBookings: 4800,
        totalServices: 1250,
        totalPosts: 3420,
        totalReviews: 2100,
        averageRating: 4.75,
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
    description: 'Требуются права администратора',
    schema: {
      example: {
        statusCode: 403,
        message: 'Admin access required',
        error: 'Forbidden',
      },
    },
  })
  async getStats(): Promise<AdminStatsDto> {
    return this.adminService.getStats();
  }

  @Get('users')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить всех пользователей для управления',
    description: 'Возвращает список всех пользователей с пагинацией для административного управления',
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
    example: 50,
  })
  @ApiOkResponse({
    description: 'Список пользователей',
    schema: {
      example: {
        users: [
          {
            id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
            email: 'user@example.com',
            firstName: 'Иван',
            lastName: 'Петров',
            isMaster: false,
            isActive: true,
            isVerified: false,
            createdAt: '2025-01-10T10:00:00Z',
          },
        ],
        total: 1250,
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
    description: 'Требуются права администратора',
    schema: {
      example: {
        statusCode: 403,
        message: 'Admin access required',
        error: 'Forbidden',
      },
    },
  })
  async getUsers(
    @Query('page', ParseIntPipe) page: number = 1,
    @Query('limit', ParseIntPipe) limit: number = 50,
  ): Promise<{ users: UserManagementDto[]; total: number }> {
    return this.adminService.getUsers(page, limit);
  }

  @Get('bookings/recent')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить недавние бронирования',
    description: 'Возвращает список недавних бронирований для административного просмотра',
  })
  @ApiQuery({
    name: 'limit',
    required: false,
    type: Number,
    description: 'Количество бронирований',
    example: 50,
  })
  @ApiOkResponse({
    description: 'Список недавних бронирований',
    type: [BookingStatsDto],
    schema: {
      example: [
        {
          id: '550e8400-e29b-41d4-a716-446655440000',
          clientId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          masterId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          status: 'confirmed',
          startTime: '2025-01-20T14:00:00Z',
          createdAt: '2025-01-13T10:00:00Z',
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
  @ApiForbiddenResponse({
    description: 'Требуются права администратора',
    schema: {
      example: {
        statusCode: 403,
        message: 'Admin access required',
        error: 'Forbidden',
      },
    },
  })
  async getRecentBookings(
    @Query('limit', ParseIntPipe) limit: number = 50,
  ): Promise<BookingStatsDto[]> {
    return this.adminService.getRecentBookings(limit);
  }

  @Post('users/:id/status')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Обновить статус пользователя',
    description: 'Изменяет статус пользователя (активен/неактивен, верифицирован и т.д.)',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID пользователя',
    example: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
  })
  @ApiOkResponse({
    description: 'Статус пользователя обновлен',
    schema: {
      example: {
        id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        isActive: false,
        isVerified: true,
        updatedAt: '2025-01-13T11:00:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные или UUID',
    schema: {
      example: {
        statusCode: 400,
        message: ['isActive must be a boolean'],
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
    description: 'Требуются права администратора',
    schema: {
      example: {
        statusCode: 403,
        message: 'Admin access required',
        error: 'Forbidden',
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
  async updateUserStatus(
    @Param('id') userId: string,
    @Body() dto: UpdateUserStatusDto,
  ) {
    return this.adminService.updateUserStatus(userId, dto);
  }

  @Delete('users/:id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Удалить пользователя',
    description: 'Полное удаление пользователя из системы. Требует прав администратора.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID пользователя',
    example: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
  })
  @ApiNoContentResponse({
    description: 'Пользователь удален',
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
    description: 'Требуются права администратора',
    schema: {
      example: {
        statusCode: 403,
        message: 'Admin access required',
        error: 'Forbidden',
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
  async deleteUser(@Param('id') userId: string): Promise<void> {
    return this.adminService.deleteUser(userId);
  }

  @Get('health')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить состояние системы',
    description: 'Возвращает информацию о состоянии системы: статус БД, Redis, MinIO и т.д.',
  })
  @ApiOkResponse({
    description: 'Состояние системы',
    type: SystemHealthDto,
    schema: {
      example: {
        status: 'healthy',
        database: {
          status: 'connected',
          responseTime: 15,
        },
        redis: {
          status: 'connected',
          responseTime: 2,
        },
        minio: {
          status: 'connected',
          responseTime: 5,
        },
        timestamp: '2025-01-13T10:30:00Z',
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
    description: 'Требуются права администратора',
    schema: {
      example: {
        statusCode: 403,
        message: 'Admin access required',
        error: 'Forbidden',
      },
    },
  })
  async getSystemHealth(): Promise<SystemHealthDto> {
    return this.adminService.getSystemHealth();
  }

  @Get('analytics')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить аналитику платформы',
    description: 'Возвращает аналитику платформы за указанный период: регистрации, активность, бронирования и т.д.',
  })
  @ApiQuery({
    name: 'days',
    required: false,
    type: Number,
    description: 'Количество дней для анализа',
    example: 30,
  })
  @ApiOkResponse({
    description: 'Аналитика платформы',
    schema: {
      example: {
        period: 30,
        newUsers: 125,
        newMasters: 35,
        newBookings: 420,
        completedBookings: 380,
        revenue: 1250000,
        averageBookingValue: 3289,
        topCategories: [
          {
            categoryId: '550e8400-e29b-41d4-a716-446655440000',
            categoryName: 'Красота',
            bookingsCount: 150,
          },
        ],
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректное количество дней',
    schema: {
      example: {
        statusCode: 400,
        message: 'days must be between 1 and 365',
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
    description: 'Требуются права администратора',
    schema: {
      example: {
        statusCode: 403,
        message: 'Admin access required',
        error: 'Forbidden',
      },
    },
  })
  async getAnalytics(
    @Query('days', ParseIntPipe) days: number = 30,
  ): Promise<any> {
    return this.adminService.getAnalytics(days);
  }
}
