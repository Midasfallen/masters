import {
  Injectable,
  NotFoundException,
  ForbiddenException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Notification, NotificationType } from './entities/notification.entity';
import { NotificationResponseDto } from './dto/notification-response.dto';
import { FilterNotificationsDto } from './dto/filter-notifications.dto';
import { MarkAsReadDto } from './dto/mark-as-read.dto';

@Injectable()
export class NotificationsService {
  constructor(
    @InjectRepository(Notification)
    private readonly notificationRepository: Repository<Notification>,
  ) {}

  /**
   * Создание уведомления (вызывается из других модулей)
   */
  async create(
    userId: string,
    type: NotificationType,
    title: string,
    message: string,
    options?: {
      related_id?: string;
      related_type?: string;
      metadata?: Record<string, any>;
      action_url?: string;
    },
  ): Promise<Notification> {
    const notification = this.notificationRepository.create({
      user_id: userId,
      type,
      title,
      message,
      is_read: false,
      related_id: options?.related_id,
      related_type: options?.related_type,
      metadata: options?.metadata,
      action_url: options?.action_url,
    });

    return this.notificationRepository.save(notification);
  }

  /**
   * Получение уведомлений пользователя с фильтрами
   */
  async findAll(
    userId: string,
    filterDto: FilterNotificationsDto,
  ): Promise<{
    data: NotificationResponseDto[];
    total: number;
    unread_count: number;
    page: number;
    limit: number;
  }> {
    const { page = 1, limit = 20 } = filterDto;

    const queryBuilder = this.notificationRepository
      .createQueryBuilder('notification')
      .where('notification.user_id = :userId', { userId });

    // Фильтр по типу
    if (filterDto.type) {
      queryBuilder.andWhere('notification.type = :type', {
        type: filterDto.type,
      });
    }

    // Фильтр по прочитанности
    if (filterDto.is_read === 'true') {
      queryBuilder.andWhere('notification.is_read = :isRead', { isRead: true });
    } else if (filterDto.is_read === 'false') {
      queryBuilder.andWhere('notification.is_read = :isRead', { isRead: false });
    }

    // Сортировка по дате (новые сначала)
    queryBuilder.orderBy('notification.created_at', 'DESC');

    // Пагинация
    const skip = (page - 1) * limit;
    queryBuilder.skip(skip).take(limit);

    const [notifications, total] = await queryBuilder.getManyAndCount();

    // Подсчет непрочитанных
    const unreadCount = await this.notificationRepository.count({
      where: { user_id: userId, is_read: false },
    });

    return {
      data: notifications.map((n) => this.mapToResponseDto(n)),
      total,
      unread_count: unreadCount,
      page,
      limit,
    };
  }

  /**
   * Получение одного уведомления
   */
  async findOne(
    userId: string,
    notificationId: string,
  ): Promise<NotificationResponseDto> {
    const notification = await this.notificationRepository.findOne({
      where: { id: notificationId },
    });

    if (!notification) {
      throw new NotFoundException('Уведомление не найдено');
    }

    if (notification.user_id !== userId) {
      throw new ForbiddenException('Нет доступа к этому уведомлению');
    }

    return this.mapToResponseDto(notification);
  }

  /**
   * Отметить уведомление как прочитанное
   */
  async markAsRead(
    userId: string,
    notificationId: string,
  ): Promise<NotificationResponseDto> {
    const notification = await this.notificationRepository.findOne({
      where: { id: notificationId },
    });

    if (!notification) {
      throw new NotFoundException('Уведомление не найдено');
    }

    if (notification.user_id !== userId) {
      throw new ForbiddenException('Нет доступа к этому уведомлению');
    }

    notification.is_read = true;
    const updated = await this.notificationRepository.save(notification);

    return this.mapToResponseDto(updated);
  }

  /**
   * Отметить несколько уведомлений как прочитанные
   */
  async markMultipleAsRead(
    userId: string,
    markAsReadDto: MarkAsReadDto,
  ): Promise<void> {
    // Проверяем, что все уведомления принадлежат пользователю
    const notifications = await this.notificationRepository.find({
      where: {
        id: In(markAsReadDto.notification_ids),
        user_id: userId,
      },
    });

    if (notifications.length !== markAsReadDto.notification_ids.length) {
      throw new ForbiddenException(
        'Некоторые уведомления не найдены или не принадлежат вам',
      );
    }

    // Обновляем
    await this.notificationRepository.update(
      { id: In(markAsReadDto.notification_ids), user_id: userId },
      { is_read: true },
    );
  }

  /**
   * Отметить все уведомления пользователя как прочитанные
   */
  async markAllAsRead(userId: string): Promise<void> {
    await this.notificationRepository.update(
      { user_id: userId, is_read: false },
      { is_read: true },
    );
  }

  /**
   * Получение количества непрочитанных уведомлений
   */
  async getUnreadCount(userId: string): Promise<number> {
    return this.notificationRepository.count({
      where: { user_id: userId, is_read: false },
    });
  }

  /**
   * Удаление уведомления
   */
  async remove(userId: string, notificationId: string): Promise<void> {
    const notification = await this.notificationRepository.findOne({
      where: { id: notificationId },
    });

    if (!notification) {
      throw new NotFoundException('Уведомление не найдено');
    }

    if (notification.user_id !== userId) {
      throw new ForbiddenException('Нет доступа к этому уведомлению');
    }

    await this.notificationRepository.remove(notification);
  }

  /**
   * Удаление всех прочитанных уведомлений пользователя
   */
  async removeAllRead(userId: string): Promise<void> {
    await this.notificationRepository.delete({
      user_id: userId,
      is_read: true,
    });
  }

  // ============ ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ ДЛЯ ДРУГИХ МОДУЛЕЙ ============

  /**
   * Уведомление о новом бронировании (для мастера)
   */
  async notifyBookingCreated(
    masterId: string,
    bookingId: string,
    clientName: string,
    serviceName: string,
    startTime: Date,
  ): Promise<void> {
    await this.create(
      masterId,
      NotificationType.BOOKING_CREATED,
      'Новое бронирование',
      `${clientName} забронировал услугу "${serviceName}" на ${startTime.toLocaleString('ru')}`,
      {
        related_id: bookingId,
        related_type: 'booking',
        action_url: `/bookings/${bookingId}`,
      },
    );
  }

  /**
   * Уведомление о подтверждении бронирования (для клиента)
   */
  async notifyBookingConfirmed(
    clientId: string,
    bookingId: string,
    masterName: string,
    startTime: Date,
  ): Promise<void> {
    await this.create(
      clientId,
      NotificationType.BOOKING_CONFIRMED,
      'Бронирование подтверждено',
      `${masterName} подтвердил ваше бронирование на ${startTime.toLocaleString('ru')}`,
      {
        related_id: bookingId,
        related_type: 'booking',
        action_url: `/bookings/${bookingId}`,
      },
    );
  }

  /**
   * Уведомление о новом отзыве
   */
  async notifyReviewReceived(
    userId: string,
    reviewId: string,
    reviewerName: string,
    rating: number,
  ): Promise<void> {
    await this.create(
      userId,
      NotificationType.REVIEW_RECEIVED,
      'Новый отзыв',
      `${reviewerName} оставил вам отзыв с оценкой ${rating}/5`,
      {
        related_id: reviewId,
        related_type: 'review',
        action_url: `/reviews/${reviewId}`,
      },
    );
  }

  /**
   * Маппинг entity в DTO
   */
  private mapToResponseDto(notification: Notification): NotificationResponseDto {
    return {
      id: notification.id,
      user_id: notification.user_id,
      type: notification.type,
      title: notification.title,
      message: notification.message,
      is_read: notification.is_read,
      related_id: notification.related_id,
      related_type: notification.related_type,
      metadata: notification.metadata,
      action_url: notification.action_url,
      created_at: notification.created_at,
    };
  }
}
