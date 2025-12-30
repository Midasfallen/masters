import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  Logger,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Notification, NotificationType } from './entities/notification.entity';
import { DeviceToken } from './entities/device-token.entity';
import { NotificationResponseDto } from './dto/notification-response.dto';
import { FilterNotificationsDto } from './dto/filter-notifications.dto';
import { MarkAsReadDto } from './dto/mark-as-read.dto';
import { RegisterDeviceDto } from './dto/register-device.dto';
import { FCMService } from './fcm.service';

@Injectable()
export class NotificationsService {
  private readonly logger = new Logger(NotificationsService.name);

  constructor(
    @InjectRepository(Notification)
    private readonly notificationRepository: Repository<Notification>,
    @InjectRepository(DeviceToken)
    private readonly deviceTokenRepository: Repository<DeviceToken>,
    private readonly fcmService: FCMService,
  ) {}

  /**
   * Создание уведомления (вызывается из других модулей)
   * Автоматически отправляет push-уведомление на все зарегистрированные устройства пользователя
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
      send_push?: boolean; // Default: true
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

    const saved = await this.notificationRepository.save(notification);

    // Send push notification (enabled by default)
    const sendPush = options?.send_push !== false;
    if (sendPush) {
      // Fire and forget - don't wait for push delivery
      this.sendPushNotification(userId, title, message, options?.metadata).catch((error) => {
        this.logger.error(`Failed to send push notification to user ${userId}:`, error);
      });
    }

    return saved;
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

  // ============ DEVICE TOKEN MANAGEMENT ============

  /**
   * Регистрация нового device token
   */
  async registerDeviceToken(
    userId: string,
    registerDto: RegisterDeviceDto,
  ): Promise<DeviceToken> {
    try {
      // Check if token already exists
      let existingToken = await this.deviceTokenRepository.findOne({
        where: { token: registerDto.token },
      });

      if (existingToken) {
        // Update existing token
        existingToken.user_id = userId;
        existingToken.platform = registerDto.platform;
        existingToken.device_model = registerDto.device_model;
        existingToken.os_version = registerDto.os_version;
        existingToken.app_version = registerDto.app_version;
        existingToken.is_active = true;
        existingToken.last_used_at = new Date();

        return this.deviceTokenRepository.save(existingToken);
      }

      // Create new token
      const deviceToken = this.deviceTokenRepository.create({
        user_id: userId,
        token: registerDto.token,
        platform: registerDto.platform,
        device_model: registerDto.device_model,
        os_version: registerDto.os_version,
        app_version: registerDto.app_version,
        is_active: true,
        last_used_at: new Date(),
      });

      return this.deviceTokenRepository.save(deviceToken);
    } catch (error) {
      this.logger.error('Failed to register device token:', error);
      throw new ConflictException('Failed to register device token');
    }
  }

  /**
   * Удаление device token (при выходе из аккаунта)
   */
  async unregisterDeviceToken(userId: string, token: string): Promise<void> {
    const deviceToken = await this.deviceTokenRepository.findOne({
      where: { token, user_id: userId },
    });

    if (deviceToken) {
      await this.deviceTokenRepository.remove(deviceToken);
      this.logger.log(`Device token unregistered for user ${userId}`);
    }
  }

  /**
   * Получение всех активных device tokens пользователя
   */
  async getUserDeviceTokens(userId: string): Promise<string[]> {
    const tokens = await this.deviceTokenRepository.find({
      where: { user_id: userId, is_active: true },
    });

    return tokens.map((t) => t.token);
  }

  /**
   * Отправка push-уведомления пользователю
   */
  private async sendPushNotification(
    userId: string,
    title: string,
    body: string,
    data?: Record<string, any>,
  ): Promise<void> {
    // Get all active device tokens for user
    const tokens = await this.getUserDeviceTokens(userId);

    if (tokens.length === 0) {
      this.logger.debug(`No device tokens found for user ${userId}`);
      return;
    }

    // Convert metadata to string format for FCM
    const dataPayload = data
      ? Object.entries(data).reduce((acc, [key, value]) => {
          acc[key] = typeof value === 'string' ? value : JSON.stringify(value);
          return acc;
        }, {} as Record<string, string>)
      : undefined;

    // Send push to all devices
    const successCount = await this.fcmService.sendToMultipleDevices(tokens, {
      title,
      body,
      data: dataPayload,
    });

    this.logger.log(
      `Push notification sent to ${successCount}/${tokens.length} devices for user ${userId}`,
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
