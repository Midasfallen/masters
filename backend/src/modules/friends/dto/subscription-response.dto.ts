import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

/**
 * Response DTO для подписки с camelCase полями,
 * совместимыми с фронтом (SubscriptionModel).
 */
export class SubscriptionResponseDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'ID подписчика' })
  subscriberId: string;

  @Expose()
  @ApiProperty({ description: 'ID пользователя, на которого подписались' })
  targetId: string;

  @Expose()
  @ApiProperty({
    description: 'Включены уведомления о новых постах',
    default: true,
  })
  notificationsEnabled: boolean;

  @Expose()
  @ApiProperty({ description: 'Дата создания подписки' })
  createdAt: Date;
}

