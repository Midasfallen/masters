import { Notification } from './entities/notification.entity';
import { NotificationResponseDto } from './dto/notification-response.dto';

/**
 * Mapper для преобразования Notification entity → NotificationResponseDto
 */
export class NotificationsMapper {
  /**
   * Преобразует Notification entity в NotificationResponseDto
   */
  static toDto(notification: Notification): NotificationResponseDto {
    return {
      id: notification.id,
      userId: notification.user_id,
      type: notification.type,
      title: notification.title,
      message: notification.message,
      isRead: notification.is_read,
      relatedId: notification.related_id,
      relatedType: notification.related_type,
      metadata: notification.metadata,
      actionUrl: notification.action_url,
      createdAt: notification.created_at,
    };
  }

  /**
   * Преобразует массив Notification entities в массив NotificationResponseDto
   */
  static toDtoArray(notifications: Notification[]): NotificationResponseDto[] {
    return notifications.map((notification) => this.toDto(notification));
  }
}
