import {
  Controller,
  Get,
  Patch,
  Delete,
  Param,
  Query,
  Body,
  UseGuards,
  Request,
} from '@nestjs/common';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiParam,
} from '@nestjs/swagger';
import { NotificationsService } from './notifications.service';
import { NotificationResponseDto } from './dto/notification-response.dto';
import { FilterNotificationsDto } from './dto/filter-notifications.dto';
import { MarkAsReadDto } from './dto/mark-as-read.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('Notifications')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('notifications')
export class NotificationsController {
  constructor(private readonly notificationsService: NotificationsService) {}

  @Get()
  @ApiOperation({
    summary: 'Получить список уведомлений',
    description: 'Получение уведомлений текущего пользователя с фильтрами',
  })
  @ApiResponse({
    status: 200,
    description: 'Список уведомлений с количеством непрочитанных',
    type: [NotificationResponseDto],
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
  @ApiOperation({
    summary: 'Получить количество непрочитанных уведомлений',
    description: 'Возвращает только число непрочитанных уведомлений',
  })
  @ApiResponse({
    status: 200,
    description: 'Количество непрочитанных',
    schema: {
      type: 'object',
      properties: {
        count: { type: 'number', example: 5 },
      },
    },
  })
  async getUnreadCount(@Request() req): Promise<{ count: number }> {
    const count = await this.notificationsService.getUnreadCount(req.user.sub);
    return { count };
  }

  @Get(':id')
  @ApiOperation({
    summary: 'Получить уведомление по ID',
    description: 'Получение конкретного уведомления',
  })
  @ApiParam({ name: 'id', description: 'ID уведомления' })
  @ApiResponse({
    status: 200,
    description: 'Данные уведомления',
    type: NotificationResponseDto,
  })
  @ApiResponse({ status: 403, description: 'Нет доступа к уведомлению' })
  @ApiResponse({ status: 404, description: 'Уведомление не найдено' })
  async findOne(
    @Request() req,
    @Param('id') id: string,
  ): Promise<NotificationResponseDto> {
    return this.notificationsService.findOne(req.user.sub, id);
  }

  @Patch(':id/read')
  @ApiOperation({
    summary: 'Отметить уведомление как прочитанное',
    description: 'Изменяет статус is_read на true',
  })
  @ApiParam({ name: 'id', description: 'ID уведомления' })
  @ApiResponse({
    status: 200,
    description: 'Уведомление отмечено',
    type: NotificationResponseDto,
  })
  @ApiResponse({ status: 403, description: 'Нет доступа к уведомлению' })
  @ApiResponse({ status: 404, description: 'Уведомление не найдено' })
  async markAsRead(
    @Request() req,
    @Param('id') id: string,
  ): Promise<NotificationResponseDto> {
    return this.notificationsService.markAsRead(req.user.sub, id);
  }

  @Patch('read-multiple')
  @ApiOperation({
    summary: 'Отметить несколько уведомлений как прочитанные',
    description: 'Массовая пометка уведомлений по списку ID',
  })
  @ApiResponse({
    status: 200,
    description: 'Уведомления отмечены',
  })
  @ApiResponse({ status: 403, description: 'Некоторые уведомления не принадлежат пользователю' })
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
  @ApiOperation({
    summary: 'Отметить все уведомления как прочитанные',
    description: 'Помечает все непрочитанные уведомления пользователя',
  })
  @ApiResponse({
    status: 200,
    description: 'Все уведомления отмечены',
  })
  async markAllAsRead(@Request() req): Promise<void> {
    return this.notificationsService.markAllAsRead(req.user.sub);
  }

  @Delete(':id')
  @ApiOperation({
    summary: 'Удалить уведомление',
    description: 'Полное удаление уведомления',
  })
  @ApiParam({ name: 'id', description: 'ID уведомления' })
  @ApiResponse({
    status: 200,
    description: 'Уведомление удалено',
  })
  @ApiResponse({ status: 403, description: 'Нет доступа к уведомлению' })
  @ApiResponse({ status: 404, description: 'Уведомление не найдено' })
  async remove(@Request() req, @Param('id') id: string): Promise<void> {
    return this.notificationsService.remove(req.user.sub, id);
  }

  @Delete('clear-read')
  @ApiOperation({
    summary: 'Удалить все прочитанные уведомления',
    description: 'Очистка прочитанных уведомлений пользователя',
  })
  @ApiResponse({
    status: 200,
    description: 'Прочитанные уведомления удалены',
  })
  async removeAllRead(@Request() req): Promise<void> {
    return this.notificationsService.removeAllRead(req.user.sub);
  }
}
