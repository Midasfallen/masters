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
  ApiParam,
  ApiQuery,
  ApiNoContentResponse,
} from '@nestjs/swagger';
import { SubscriptionsService } from './subscriptions.service';
import { CreateSubscriptionDto } from './dto/create-subscription.dto';
import { UpdateSubscriptionDto } from './dto/update-subscription.dto';
import { SubscriptionResponseDto } from './dto/subscription-response.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { PaginationDto } from '../../common/dto/pagination.dto';

@ApiTags('Subscriptions')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('subscriptions')
export class SubscriptionsController {
  constructor(private readonly subscriptionsService: SubscriptionsService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Подписаться на пользователя',
    description: 'Создает подписку на другого пользователя. Можно подписаться только один раз.',
  })
  @ApiCreatedResponse({
    description: 'Подписка успешно создана',
    type: SubscriptionResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        subscriberId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        targetId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        notificationsEnabled: true,
        createdAt: '2025-01-13T10:30:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      example: {
        statusCode: 400,
        message: ['target_id must be a UUID'],
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
        message: 'Target user not found',
        error: 'Not Found',
      },
    },
  })
  @ApiConflictResponse({
    description: 'Уже подписан на этого пользователя',
    schema: {
      example: {
        statusCode: 409,
        message: 'Already subscribed to this user',
        error: 'Conflict',
      },
    },
  })
  create(
    @CurrentUser('id') userId: string,
    @Body() createSubscriptionDto: CreateSubscriptionDto,
  ): Promise<SubscriptionResponseDto> {
    return this.subscriptionsService.create(userId, createSubscriptionDto);
  }

  @Get('following')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить список подписок (кого я читаю)',
    description: 'Возвращает список пользователей, на которых подписан текущий пользователь',
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
    description: 'Список подписок',
    schema: {
      example: {
        data: [
          {
            id: '550e8400-e29b-41d4-a716-446655440000',
            subscriberId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
            targetId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
            notificationsEnabled: true,
            createdAt: '2025-01-13T10:30:00Z',
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
  getFollowing(@CurrentUser('id') userId: string, @Query() paginationDto: PaginationDto) {
    return this.subscriptionsService.getFollowing(userId, paginationDto);
  }

  @Get('followers')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить список подписчиков (кто читает меня)',
    description: 'Возвращает список пользователей, которые подписаны на текущего пользователя',
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
    description: 'Список подписчиков',
    schema: {
      example: {
        data: [
          {
            id: '550e8400-e29b-41d4-a716-446655440000',
            subscriberId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
            targetId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
            notificationsEnabled: true,
            createdAt: '2025-01-13T10:30:00Z',
          },
        ],
        total: 42,
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
  getFollowers(@CurrentUser('id') userId: string, @Query() paginationDto: PaginationDto) {
    return this.subscriptionsService.getFollowers(userId, paginationDto);
  }

  @Get('check/:targetId')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Проверить, подписан ли текущий пользователь на targetId',
    description: 'Возвращает статус подписки текущего пользователя на указанного пользователя',
  })
  @ApiParam({
    name: 'targetId',
    description: 'UUID пользователя, на которого проверяется подписка',
    example: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
  })
  @ApiOkResponse({
    description: 'Статус подписки',
    schema: {
      example: {
        is_following: true,
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
  checkSubscription(
    @CurrentUser('id') userId: string,
    @Param('targetId') targetId: string,
  ): Promise<{ is_following: boolean }> {
    return this.subscriptionsService.checkSubscription(userId, targetId);
  }

  @Patch(':targetId')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Обновить настройки подписки',
    description: 'Обновляет настройки уведомлений для существующей подписки',
  })
  @ApiParam({
    name: 'targetId',
    description: 'UUID пользователя, на которого подписан',
    example: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
  })
  @ApiOkResponse({
    description: 'Настройки подписки обновлены',
    type: SubscriptionResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        subscriberId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        targetId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        notificationsEnabled: false,
        createdAt: '2025-01-13T10:30:00Z',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      example: {
        statusCode: 400,
        message: ['notifications_enabled must be a boolean value'],
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
    description: 'Подписка не найдена',
    schema: {
      example: {
        statusCode: 404,
        message: 'Subscription not found',
        error: 'Not Found',
      },
    },
  })
  update(
    @CurrentUser('id') userId: string,
    @Param('targetId') targetId: string,
    @Body() updateSubscriptionDto: UpdateSubscriptionDto,
  ): Promise<SubscriptionResponseDto> {
    return this.subscriptionsService.update(userId, targetId, updateSubscriptionDto);
  }

  @Delete(':targetId')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Отписаться от пользователя',
    description: 'Удаляет подписку на указанного пользователя',
  })
  @ApiParam({
    name: 'targetId',
    description: 'UUID пользователя, от которого нужно отписаться',
    example: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
  })
  @ApiOkResponse({
    description: 'Подписка успешно удалена',
    schema: {
      example: {
        message: 'Unsubscribed successfully',
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
    description: 'Подписка не найдена',
    schema: {
      example: {
        statusCode: 404,
        message: 'Subscription not found',
        error: 'Not Found',
      },
    },
  })
  remove(@CurrentUser('id') userId: string, @Param('targetId') targetId: string) {
    return this.subscriptionsService.remove(userId, targetId);
  }
}
