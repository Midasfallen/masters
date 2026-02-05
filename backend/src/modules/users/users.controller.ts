import {
  Controller,
  Get,
  Patch,
  Body,
  Param,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiParam,
  ApiOkResponse,
  ApiBadRequestResponse,
  ApiUnauthorizedResponse,
  ApiNotFoundResponse,
  ApiConflictResponse,
} from '@nestjs/swagger';
import { UsersService } from './users.service';
import { UpdateUserDto } from './dto/update-user.dto';
import { UserResponseDto } from './dto/user-response.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { User } from './entities/user.entity';

@ApiTags('users')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('me')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить текущего пользователя',
    description: 'Возвращает профиль авторизованного пользователя',
  })
  @ApiOkResponse({
    description: 'Профиль пользователя',
    type: UserResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        email: 'user@example.com',
        phone: '+79001234567',
        firstName: 'Иван',
        lastName: 'Петров',
        fullName: 'Иван Петров',
        avatarUrl: 'https://storage.example.com/avatars/user.jpg',
        isMaster: true,
        masterProfileCompleted: true,
        isVerified: true,
        isPremium: false,
        premiumUntil: null,
        isActive: true,
        lastLoginAt: '2025-01-13T10:30:00Z',
        rating: 4.75,
        reviewsCount: 42,
        cancellationsCount: 2,
        noShowsCount: 0,
        blacklistsCount: 0,
        postsCount: 15,
        friendsCount: 28,
        followersCount: 150,
        followingCount: 85,
        language: 'ru',
        timezone: 'Europe/Moscow',
        lastLocationLat: 55.7558,
        lastLocationLng: 37.6173,
        createdAt: '2025-01-01T00:00:00Z',
        updatedAt: '2025-01-13T10:30:00Z',
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
  async getMe(@CurrentUser() user: User): Promise<UserResponseDto> {
    return this.usersService.findById(user.id);
  }

  @Patch('me')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Обновить профиль текущего пользователя',
    description:
      'Позволяет обновить информацию о пользователе (имя, телефон, аватар, локация и т.д.)',
  })
  @ApiOkResponse({
    description: 'Профиль успешно обновлен',
    type: UserResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        email: 'user@example.com',
        phone: '+79001234568',
        firstName: 'Иван',
        lastName: 'Иванов',
        fullName: 'Иван Иванов',
        avatarUrl: 'https://storage.example.com/avatars/new-avatar.jpg',
        isMaster: true,
        masterProfileCompleted: true,
        isVerified: true,
        isPremium: false,
        premiumUntil: null,
        isActive: true,
        lastLoginAt: '2025-01-13T10:30:00Z',
        rating: 4.75,
        reviewsCount: 42,
        cancellationsCount: 2,
        noShowsCount: 0,
        blacklistsCount: 0,
        postsCount: 15,
        friendsCount: 28,
        followersCount: 150,
        followingCount: 85,
        language: 'ru',
        timezone: 'Europe/Moscow',
        lastLocationLat: 55.7558,
        lastLocationLng: 37.6173,
        createdAt: '2025-01-01T00:00:00Z',
        updatedAt: '2025-01-13T11:00:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      example: {
        statusCode: 400,
        message: [
          'first_name must be longer than or equal to 2 characters',
          'phone must match /^\\+?[1-9]\\d{1,14}$/ regular expression',
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
    description: 'Номер телефона уже используется',
    schema: {
      example: {
        statusCode: 409,
        message: 'Phone number already in use',
        error: 'Conflict',
      },
    },
  })
  async updateMe(
    @CurrentUser() user: User,
    @Body() updateUserDto: UpdateUserDto,
  ): Promise<UserResponseDto> {
    return this.usersService.update(user.id, updateUserDto);
  }

  @Get('me/stats')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить статистику текущего пользователя',
    description:
      'Возвращает счетчики постов, друзей, подписчиков, отзывов и рейтинг',
  })
  @ApiOkResponse({
    description: 'Статистика пользователя',
    schema: {
      example: {
        posts_count: 15,
        friends_count: 28,
        followers_count: 150,
        following_count: 85,
        reviews_count: 42,
        rating: 4.75,
        is_master: true,
        is_verified: true,
        is_premium: false,
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
  async getMyStats(@CurrentUser() user: User) {
    return this.usersService.getUserStats(user.id);
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить пользователя по ID',
    description: 'Возвращает публичный профиль пользователя',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID пользователя',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Профиль пользователя',
    type: UserResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        email: 'user@example.com',
        phone: '+79001234567',
        firstName: 'Иван',
        lastName: 'Петров',
        fullName: 'Иван Петров',
        avatarUrl: 'https://storage.example.com/avatars/user.jpg',
        isMaster: false,
        masterProfileCompleted: false,
        isVerified: false,
        isPremium: false,
        premiumUntil: null,
        isActive: true,
        lastLoginAt: '2025-01-13T10:30:00Z',
        rating: 0,
        reviewsCount: 0,
        cancellationsCount: 0,
        noShowsCount: 0,
        blacklistsCount: 0,
        postsCount: 5,
        friendsCount: 10,
        followersCount: 25,
        followingCount: 15,
        language: 'ru',
        timezone: 'Europe/Moscow',
        lastLocationLat: 55.7558,
        lastLocationLng: 37.6173,
        createdAt: '2025-01-01T00:00:00Z',
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
    description: 'Пользователь не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'User not found',
        error: 'Not Found',
      },
    },
  })
  async getUserById(@Param('id') id: string): Promise<UserResponseDto> {
    return this.usersService.findById(id);
  }
}
