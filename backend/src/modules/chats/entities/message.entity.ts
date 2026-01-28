import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  ManyToOne,
  JoinColumn,
  Index,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { Chat } from './chat.entity';
import { User } from '../../users/entities/user.entity';

export enum MessageType {
  TEXT = 'text',
  PHOTO = 'photo',
  VIDEO = 'video',
  VOICE = 'voice',
  LOCATION = 'location',
  PROFILE_SHARE = 'profile_share',
  POST_SHARE = 'post_share',
  BOOKING_PROPOSAL = 'booking_proposal',
}

@Entity('messages')
@Index(['chat_id', 'created_at'])
@Index(['sender_id'])
export class Message {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID чата' })
  @Column({ type: 'uuid' })
  chat_id: string;

  @ApiProperty({ description: 'ID отправителя' })
  @Column({ type: 'uuid' })
  sender_id: string;

  @ApiProperty({ enum: MessageType, example: MessageType.TEXT })
  @Column({
    type: 'enum',
    enum: MessageType,
    default: MessageType.TEXT,
  })
  type: MessageType;

  @ApiProperty({ example: 'Привет! Как дела?', nullable: true })
  @Column({ type: 'text', nullable: true })
  content: string;

  @ApiProperty({ description: 'URL медиа файла', nullable: true })
  @Column({ type: 'text', nullable: true })
  media_url: string;

  @ApiProperty({ description: 'Миниатюра медиа файла', nullable: true })
  @Column({ type: 'text', nullable: true })
  thumbnail_url: string;

  @ApiProperty({ description: 'Метаданные медиа файла (JSON)', nullable: true, type: 'object', additionalProperties: true })
  @Column({ type: 'jsonb', nullable: true })
  media_metadata: {
    width?: number;
    height?: number;
    duration?: number;
    size?: number;
    filename?: string;
    mime_type?: string;
  };

  @ApiProperty({ description: 'Геолокация (для type=location)', nullable: true })
  @Column({ type: 'decimal', precision: 10, scale: 8, nullable: true })
  location_lat: number;

  @ApiProperty({ description: 'Геолокация (для type=location)', nullable: true })
  @Column({ type: 'decimal', precision: 11, scale: 8, nullable: true })
  location_lng: number;

  @ApiProperty({ description: 'Название места', nullable: true })
  @Column({ type: 'varchar', length: 255, nullable: true })
  location_name: string;

  @ApiProperty({ description: 'ID расшаренного профиля (для type=profile_share)', nullable: true })
  @Column({ type: 'uuid', nullable: true })
  shared_profile_id: string;

  @ApiProperty({ description: 'ID расшаренного поста (для type=post_share)', nullable: true })
  @Column({ type: 'uuid', nullable: true })
  shared_post_id: string;

  @ApiProperty({ description: 'ID предложения бронирования (для type=booking_proposal)', nullable: true })
  @Column({ type: 'uuid', nullable: true })
  booking_proposal_id: string;

  @ApiProperty({ description: 'ID ответа на сообщение', nullable: true })
  @Column({ type: 'uuid', nullable: true })
  reply_to_id: string;

  @ApiProperty({ description: 'Количество прочитавших', default: 0 })
  @Column({ type: 'integer', default: 0 })
  read_count: number;

  @ApiProperty({ description: 'Сообщение отредактировано', default: false })
  @Column({ type: 'boolean', default: false })
  is_edited: boolean;

  @ApiProperty({ description: 'Сообщение удалено', default: false })
  @Column({ type: 'boolean', default: false })
  is_deleted: boolean;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  @ApiProperty()
  @UpdateDateColumn()
  updated_at: Date;

  // Relations
  @ManyToOne(() => Chat, (chat) => chat.messages, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'chat_id' })
  chat: Chat;

  @ManyToOne(() => User, { eager: false })
  @JoinColumn({ name: 'sender_id' })
  sender: User;

  @ManyToOne(() => Message, { nullable: true })
  @JoinColumn({ name: 'reply_to_id' })
  reply_to: Message;
}
