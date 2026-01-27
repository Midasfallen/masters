import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { NotificationType } from '../entities/notification.entity';

/**
 * Response DTO для уведомления с camelCase полями
 */
export class NotificationResponseDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'ID пользователя-получателя' })
  userId: string;

  @Expose()
  @ApiProperty({ enum: NotificationType, example: NotificationType.BOOKING_CONFIRMED })
  type: NotificationType;

  @Expose()
  @ApiProperty({ example: 'Бронирование подтверждено' })
  title: string;

  @Expose()
  @ApiProperty({ example: 'Ваша запись на 25 января подтверждена' })
  message: string;

  @Expose()
  @ApiProperty({ example: false, description: 'Прочитано ли уведомление' })
  isRead: boolean;

  @Expose()
  @ApiProperty({ required: false, nullable: true, description: 'ID связанной сущности' })
  relatedId?: string | null;

  @Expose()
  @ApiProperty({ required: false, nullable: true, description: 'Тип связанной сущности' })
  relatedType?: string | null;

  @Expose()
  @ApiProperty({ required: false, nullable: true, description: 'Дополнительные метаданные' })
  metadata?: Record<string, any> | null;

  @Expose()
  @ApiProperty({ required: false, nullable: true, description: 'URL для действия' })
  actionUrl?: string | null;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z', description: 'Дата создания' })
  createdAt: Date;
}
