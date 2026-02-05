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
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiBadRequestResponse,
  ApiUnauthorizedResponse,
  ApiNotFoundResponse,
  ApiConflictResponse,
  ApiForbiddenResponse,
  ApiParam,
  ApiQuery,
} from '@nestjs/swagger';
import { FriendshipsService } from './friendships.service';
import { CreateFriendshipDto } from './dto/create-friendship.dto';
import { UpdateFriendshipDto } from './dto/update-friendship.dto';
import { FilterFriendshipsDto } from './dto/filter-friendships.dto';
import { FriendshipStatus } from './entities/friendship.entity';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';

@ApiTags('Friendships')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('friendships')
export class FriendshipsController {
  constructor(private readonly friendshipsService: FriendshipsService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Отправить запрос в друзья',
    description: 'Создает запрос на дружбу. Статус по умолчанию: pending',
  })
  @ApiCreatedResponse({
    description: 'Запрос в друзья успешно отправлен',
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        requester_id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        addressee_id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        status: 'pending',
        created_at: '2025-01-13T10:30:00Z',
        updated_at: '2025-01-13T10:30:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      example: {
        statusCode: 400,
        message: ['addressee_id must be a UUID'],
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
    description: 'Пользователь не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'User not found',
        error: 'Not Found',
      },
    },
  })
  @ApiConflictResponse({
    description: 'Запрос уже существует или пользователь заблокирован',
    schema: {
      examples: {
        alreadyExists: {
          value: {
            statusCode: 409,
            message: 'Friendship request already exists',
            error: 'Conflict',
          },
        },
        blocked: {
          value: {
            statusCode: 409,
            message: 'Cannot send request: user is blocked',
            error: 'Conflict',
          },
        },
      },
    },
  })
  create(@CurrentUser('id') userId: string, @Body() createFriendshipDto: CreateFriendshipDto) {
    return this.friendshipsService.create(userId, createFriendshipDto);
  }

  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить список друзей / запросов',
    description: 'Возвращает список всех дружеских связей с фильтрацией по статусу',
  })
  @ApiQuery({
    name: 'status',
    required: false,
    enum: FriendshipStatus,
    description: 'Фильтр по статусу дружбы',
    example: FriendshipStatus.ACCEPTED,
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
    description: 'Список дружеских связей',
    schema: {
      example: {
        data: [
          {
            id: '550e8400-e29b-41d4-a716-446655440000',
            requester_id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
            addressee_id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
            status: 'accepted',
            created_at: '2025-01-13T10:30:00Z',
            updated_at: '2025-01-13T10:35:00Z',
          },
        ],
        total: 28,
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
  findAll(@CurrentUser('id') userId: string, @Query() filterDto: FilterFriendshipsDto) {
    return this.friendshipsService.findAll(userId, filterDto);
  }

  @Get('incoming')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить входящие запросы в друзья',
    description: 'Возвращает список запросов в друзья, полученных текущим пользователем',
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
    description: 'Список входящих запросов',
    schema: {
      example: {
        data: [
          {
            id: '550e8400-e29b-41d4-a716-446655440000',
            requester_id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
            addressee_id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
            status: 'pending',
            created_at: '2025-01-13T10:30:00Z',
            updated_at: '2025-01-13T10:30:00Z',
          },
        ],
        total: 5,
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
  getIncoming(@CurrentUser('id') userId: string, @Query() filterDto: FilterFriendshipsDto) {
    return this.friendshipsService.getIncoming(userId, filterDto);
  }

  @Get('outgoing')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить исходящие запросы в друзья',
    description: 'Возвращает список запросов в друзья, отправленных текущим пользователем',
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
    description: 'Список исходящих запросов',
    schema: {
      example: {
        data: [
          {
            id: '550e8400-e29b-41d4-a716-446655440000',
            requester_id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
            addressee_id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
            status: 'pending',
            created_at: '2025-01-13T10:30:00Z',
            updated_at: '2025-01-13T10:30:00Z',
          },
        ],
        total: 3,
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
  getOutgoing(@CurrentUser('id') userId: string, @Query() filterDto: FilterFriendshipsDto) {
    return this.friendshipsService.getOutgoing(userId, filterDto);
  }

  @Patch(':id/accept')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Принять запрос в друзья',
    description: 'Принимает входящий запрос в друзья. Статус меняется на accepted',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID запроса в друзья',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Запрос в друзья принят',
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        requester_id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        addressee_id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        status: 'accepted',
        created_at: '2025-01-13T10:30:00Z',
        updated_at: '2025-01-13T10:35:00Z',
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
    description: 'Нет прав для принятия этого запроса',
    schema: {
      example: {
        statusCode: 403,
        message: 'You can only accept incoming friendship requests',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Запрос в друзья не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Friendship request not found',
        error: 'Not Found',
      },
    },
  })
  accept(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.friendshipsService.accept(id, userId);
  }

  @Patch(':id/decline')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Отклонить запрос в друзья',
    description: 'Отклоняет входящий запрос в друзья. Статус меняется на declined',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID запроса в друзья',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Запрос в друзья отклонен',
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        requester_id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        addressee_id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        status: 'declined',
        created_at: '2025-01-13T10:30:00Z',
        updated_at: '2025-01-13T10:35:00Z',
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
    description: 'Нет прав для отклонения этого запроса',
    schema: {
      example: {
        statusCode: 403,
        message: 'You can only decline incoming friendship requests',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Запрос в друзья не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Friendship request not found',
        error: 'Not Found',
      },
    },
  })
  decline(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.friendshipsService.decline(id, userId);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Удалить из друзей / отменить запрос',
    description: 'Удаляет дружескую связь или отменяет запрос в друзья',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID запроса в друзья',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Дружеская связь удалена',
    schema: {
      example: {
        message: 'Friendship removed successfully',
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
    description: 'Нет прав для удаления этой связи',
    schema: {
      example: {
        statusCode: 403,
        message: 'You can only remove your own friendships',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Дружеская связь не найдена',
    schema: {
      example: {
        statusCode: 404,
        message: 'Friendship not found',
        error: 'Not Found',
      },
    },
  })
  remove(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.friendshipsService.remove(id, userId);
  }

  @Post(':id/block')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Заблокировать пользователя',
    description: 'Блокирует пользователя. Статус меняется на blocked. Блокировка взаимная.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID пользователя для блокировки (ID дружеской связи или ID пользователя)',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Пользователь заблокирован',
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        requester_id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        addressee_id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        status: 'blocked',
        created_at: '2025-01-13T10:30:00Z',
        updated_at: '2025-01-13T10:40:00Z',
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
    description: 'Пользователь или дружеская связь не найдена',
    schema: {
      example: {
        statusCode: 404,
        message: 'User or friendship not found',
        error: 'Not Found',
      },
    },
  })
  block(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.friendshipsService.block(id, userId);
  }
}
