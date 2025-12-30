import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
  Unique,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { Chat } from './chat.entity';
import { User } from '../../users/entities/user.entity';

export enum ParticipantRole {
  OWNER = 'owner',
  ADMIN = 'admin',
  MEMBER = 'member',
}

@Entity('chat_participants')
@Unique(['chat_id', 'user_id'])
@Index(['chat_id'])
@Index(['user_id'])
export class ChatParticipant {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID чата' })
  @Column({ type: 'uuid' })
  chat_id: string;

  @ApiProperty({ description: 'ID участника' })
  @Column({ type: 'uuid' })
  user_id: string;

  @ApiProperty({ enum: ParticipantRole, example: ParticipantRole.MEMBER })
  @Column({
    type: 'enum',
    enum: ParticipantRole,
    default: ParticipantRole.MEMBER,
  })
  role: ParticipantRole;

  @ApiProperty({ description: 'ID последнего прочитанного сообщения', nullable: true })
  @Column({ type: 'uuid', nullable: true })
  last_read_message_id: string;

  @ApiProperty({ description: 'Время последнего прочтения', nullable: true })
  @Column({ type: 'timestamp', nullable: true })
  last_read_at: Date;

  @ApiProperty({ description: 'Количество непрочитанных сообщений', default: 0 })
  @Column({ type: 'integer', default: 0 })
  unread_count: number;

  @ApiProperty({ description: 'Уведомления включены', default: true })
  @Column({ type: 'boolean', default: true })
  notifications_enabled: boolean;

  @ApiProperty({ description: 'Чат в архиве', default: false })
  @Column({ type: 'boolean', default: false })
  is_archived: boolean;

  @ApiProperty({ description: 'Участник удален из чата', default: false })
  @Column({ type: 'boolean', default: false })
  is_removed: boolean;

  @ApiProperty()
  @CreateDateColumn()
  joined_at: Date;

  @ApiProperty()
  @UpdateDateColumn()
  updated_at: Date;

  // Relations
  @ManyToOne(() => Chat, (chat) => chat.participants, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'chat_id' })
  chat: Chat;

  @ManyToOne(() => User, { eager: false })
  @JoinColumn({ name: 'user_id' })
  user: User;
}
