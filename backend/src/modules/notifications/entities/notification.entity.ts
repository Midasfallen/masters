import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  Index,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';

export enum NotificationType {
  BOOKING_CREATED = 'booking_created',
  BOOKING_CONFIRMED = 'booking_confirmed',
  BOOKING_REJECTED = 'booking_rejected',
  BOOKING_CANCELLED = 'booking_cancelled',
  BOOKING_STARTED = 'booking_started',
  BOOKING_COMPLETED = 'booking_completed',
  BOOKING_REMINDER = 'booking_reminder',
  REVIEW_RECEIVED = 'review_received',
  REVIEW_RESPONSE = 'review_response',
  NEW_MESSAGE = 'new_message',
  SYSTEM = 'system',
}

@Entity('notifications')
@Index(['user_id'])
@Index(['is_read'])
@Index(['created_at'])
@Index(['user_id', 'is_read'])
export class Notification {
  @ApiProperty()
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID получателя уведомления' })
  @Column({ type: 'uuid' })
  user_id: string;

  @ApiProperty({ enum: NotificationType, description: 'Тип уведомления' })
  @Column({
    type: 'enum',
    enum: NotificationType,
  })
  type: NotificationType;

  @ApiProperty({ description: 'Заголовок уведомления' })
  @Column({ type: 'varchar', length: 255 })
  title: string;

  @ApiProperty({ description: 'Текст уведомления' })
  @Column({ type: 'text' })
  message: string;

  @ApiProperty({ description: 'Прочитано', default: false })
  @Column({ type: 'boolean', default: false })
  is_read: boolean;

  @ApiProperty({ description: 'ID связанной сущности (booking, review и т.д.)', required: false })
  @Column({ type: 'uuid', nullable: true })
  related_id: string;

  @ApiProperty({ description: 'Тип связанной сущности', required: false })
  @Column({ type: 'varchar', length: 50, nullable: true })
  related_type: string;

  @ApiProperty({ description: 'Дополнительные данные', type: 'object', required: false })
  @Column({ type: 'jsonb', nullable: true })
  metadata: Record<string, any>;

  @ApiProperty({ description: 'URL для перехода', required: false })
  @Column({ type: 'text', nullable: true })
  action_url: string;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;
}
