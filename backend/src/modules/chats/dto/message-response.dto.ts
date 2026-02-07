import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { MessageType } from '../entities/message.entity';
import { ChatUserResponseDto } from './chat-user-response.dto';

/**
 * Response DTO для медиа метаданных
 */
export class MediaMetadataDto {
  @Expose()
  @ApiProperty({ description: 'Ширина', nullable: true })
  width?: number;

  @Expose()
  @ApiProperty({ description: 'Высота', nullable: true })
  height?: number;

  @Expose()
  @ApiProperty({ description: 'Длительность (сек)', nullable: true })
  duration?: number;

  @Expose()
  @ApiProperty({ description: 'Размер файла (байты)', nullable: true })
  size?: number;

  @Expose()
  @ApiProperty({ description: 'Имя файла', nullable: true })
  filename?: string;

  @Expose()
  @ApiProperty({ description: 'MIME тип', nullable: true })
  mimeType?: string;
}

/**
 * Response DTO для сообщения с camelCase полями
 */
export class MessageResponseDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'ID чата' })
  chatId: string;

  @Expose()
  @ApiProperty({ description: 'ID отправителя' })
  senderId: string;

  @Expose()
  @ApiProperty({ description: 'Информация об отправителе', type: ChatUserResponseDto, nullable: true })
  sender?: ChatUserResponseDto;

  @Expose()
  @ApiProperty({ enum: MessageType, example: MessageType.TEXT })
  type: MessageType;

  @Expose()
  @ApiProperty({ description: 'Текст сообщения', nullable: true })
  content: string | null;

  @Expose()
  @ApiProperty({ description: 'URL медиа файла', nullable: true })
  mediaUrl: string | null;

  @Expose()
  @ApiProperty({ description: 'URL миниатюры', nullable: true })
  thumbnailUrl: string | null;

  @Expose()
  @ApiProperty({ description: 'Метаданные медиа', type: MediaMetadataDto, nullable: true })
  mediaMetadata: MediaMetadataDto | null;

  @Expose()
  @ApiProperty({ description: 'Широта локации', nullable: true })
  locationLat: number | null;

  @Expose()
  @ApiProperty({ description: 'Долгота локации', nullable: true })
  locationLng: number | null;

  @Expose()
  @ApiProperty({ description: 'Название места', nullable: true })
  locationName: string | null;

  @Expose()
  @ApiProperty({ description: 'ID расшаренного профиля', nullable: true })
  sharedProfileId: string | null;

  @Expose()
  @ApiProperty({ description: 'ID расшаренного поста', nullable: true })
  sharedPostId: string | null;

  @Expose()
  @ApiProperty({ description: 'ID предложения бронирования', nullable: true })
  bookingProposalId: string | null;

  @Expose()
  @ApiProperty({ description: 'ID сообщения на которое отвечают', nullable: true })
  replyToId: string | null;

  @Expose()
  @ApiProperty({ description: 'Количество прочитавших', example: 0 })
  readCount: number;

  @Expose()
  @ApiProperty({ description: 'Сообщение отредактировано', default: false })
  isEdited: boolean;

  @Expose()
  @ApiProperty({ description: 'Сообщение удалено', default: false })
  isDeleted: boolean;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z' })
  createdAt: Date;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z' })
  updatedAt: Date;
}
