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
  @ApiResponse({
    status: 200,
    description: 'Профиль пользователя',
    type: UserResponseDto,
  })
  @ApiResponse({
    status: 401,
    description: 'Не авторизован',
  })
  async getMe(@CurrentUser() user: User): Promise<User> {
    return this.usersService.findById(user.id);
  }

  @Patch('me')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Обновить профиль текущего пользователя',
    description:
      'Позволяет обновить информацию о пользователе (имя, телефон, аватар, локация и т.д.)',
  })
  @ApiResponse({
    status: 200,
    description: 'Профиль успешно обновлен',
    type: UserResponseDto,
  })
  @ApiResponse({
    status: 400,
    description: 'Некорректные данные',
  })
  @ApiResponse({
    status: 409,
    description: 'Номер телефона уже используется',
  })
  async updateMe(
    @CurrentUser() user: User,
    @Body() updateUserDto: UpdateUserDto,
  ): Promise<User> {
    return this.usersService.update(user.id, updateUserDto);
  }

  @Get('me/stats')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить статистику текущего пользователя',
    description:
      'Возвращает счетчики постов, друзей, подписчиков, отзывов и рейтинг',
  })
  @ApiResponse({
    status: 200,
    description: 'Статистика пользователя',
    schema: {
      example: {
        posts_count: 15,
        friends_count: 28,
        followers_count: 150,
        following_count: 85,
        reviews_count: 42,
        rating: 4.75,
        is_master: false,
        is_verified: false,
        is_premium: false,
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
  @ApiResponse({
    status: 200,
    description: 'Профиль пользователя',
    type: UserResponseDto,
  })
  @ApiResponse({
    status: 404,
    description: 'Пользователь не найден',
  })
  async getUserById(@Param('id') id: string): Promise<User> {
    return this.usersService.findById(id);
  }
}
