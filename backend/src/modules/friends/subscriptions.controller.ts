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
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { SubscriptionsService } from './subscriptions.service';
import { CreateSubscriptionDto } from './dto/create-subscription.dto';
import { UpdateSubscriptionDto } from './dto/update-subscription.dto';
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
  @ApiOperation({ summary: 'Подписаться на пользователя' })
  create(@CurrentUser('id') userId: string, @Body() createSubscriptionDto: CreateSubscriptionDto) {
    return this.subscriptionsService.create(userId, createSubscriptionDto);
  }

  @Get('following')
  @ApiOperation({ summary: 'Получить список подписок (кого я читаю)' })
  getFollowing(@CurrentUser('id') userId: string, @Query() paginationDto: PaginationDto) {
    return this.subscriptionsService.getFollowing(userId, paginationDto);
  }

  @Get('followers')
  @ApiOperation({ summary: 'Получить список подписчиков (кто читает меня)' })
  getFollowers(@CurrentUser('id') userId: string, @Query() paginationDto: PaginationDto) {
    return this.subscriptionsService.getFollowers(userId, paginationDto);
  }

  @Get('check/:targetId')
  @ApiOperation({ summary: 'Проверить, подписан ли текущий пользователь на targetId' })
  checkSubscription(
    @CurrentUser('id') userId: string,
    @Param('targetId') targetId: string,
  ): Promise<{ is_following: boolean }> {
    return this.subscriptionsService.checkSubscription(userId, targetId);
  }

  @Patch(':targetId')
  @ApiOperation({ summary: 'Обновить настройки подписки' })
  update(
    @CurrentUser('id') userId: string,
    @Param('targetId') targetId: string,
    @Body() updateSubscriptionDto: UpdateSubscriptionDto,
  ) {
    return this.subscriptionsService.update(userId, targetId, updateSubscriptionDto);
  }

  @Delete(':targetId')
  @ApiOperation({ summary: 'Отписаться от пользователя' })
  remove(@CurrentUser('id') userId: string, @Param('targetId') targetId: string) {
    return this.subscriptionsService.remove(userId, targetId);
  }
}
