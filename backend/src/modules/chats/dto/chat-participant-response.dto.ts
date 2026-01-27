import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { ParticipantRole } from '../entities/chat-participant.entity';

/**
 * Response DTO для участника чата с camelCase полями
 */
export class ChatParticipantResponseDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'ID чата' })
  chatId: string;

  @Expose()
  @ApiProperty({ description: 'ID пользователя' })
  userId: string;

  @Expose()
  @ApiProperty({ enum: ParticipantRole, example: ParticipantRole.MEMBER })
  role: ParticipantRole;

  @Expose()
  @ApiProperty({ description: 'ID последнего прочитанного сообщения', nullable: true })
  lastReadMessageId: string | null;

  @Expose()
  @ApiProperty({ description: 'Время последнего прочтения', nullable: true })
  lastReadAt: Date | null;

  @Expose()
  @ApiProperty({ description: 'Количество непрочитанных', example: 0 })
  unreadCount: number;

  @Expose()
  @ApiProperty({ description: 'Уведомления включены', default: true })
  notificationsEnabled: boolean;

  @Expose()
  @ApiProperty({ description: 'Чат в архиве', default: false })
  isArchived: boolean;

  @Expose()
  @ApiProperty({ description: 'Чат закреплен', default: false })
  isPinned: boolean;

  @Expose()
  @ApiProperty({ description: 'Участник удален', default: false })
  isRemoved: boolean;

  @Expose()
  @ApiProperty({ description: 'Дата присоединения' })
  joinedAt: Date;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z' })
  updatedAt: Date;
}
