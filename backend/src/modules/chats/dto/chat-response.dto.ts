import { ApiProperty } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { ChatType } from '../entities/chat.entity';
import { ChatParticipantResponseDto } from './chat-participant-response.dto';
import { ChatUserResponseDto } from './chat-user-response.dto';
import { MessageResponseDto } from './message-response.dto';

/**
 * Response DTO для чата с camelCase полями
 */
export class ChatResponseDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ enum: ChatType, example: ChatType.DIRECT })
  type: ChatType;

  @Expose()
  @ApiProperty({ description: 'Название группового чата', nullable: true })
  name: string | null;

  @Expose()
  @ApiProperty({ description: 'Аватар чата', nullable: true })
  avatarUrl: string | null;

  @Expose()
  @ApiProperty({ description: 'ID создателя чата', nullable: true })
  creatorId: string | null;

  @Expose()
  @ApiProperty({ description: 'ID последнего сообщения', nullable: true })
  lastMessageId: string | null;

  @Expose()
  @ApiProperty({ description: 'Время последнего сообщения', nullable: true })
  lastMessageAt: Date | null;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z' })
  createdAt: Date;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z' })
  updatedAt: Date;

  @Expose()
  @ApiProperty({ description: 'Информация об участии текущего пользователя в чате', type: ChatParticipantResponseDto, nullable: true })
  @Type(() => ChatParticipantResponseDto)
  myParticipant?: ChatParticipantResponseDto;

  @Expose()
  @ApiProperty({ description: 'Другой участник (для direct чатов)', type: ChatUserResponseDto, nullable: true })
  @Type(() => ChatUserResponseDto)
  otherUser?: ChatUserResponseDto;

  @Expose()
  @ApiProperty({ description: 'Список участников (для групповых чатов)', type: [ChatParticipantResponseDto], nullable: true })
  @Type(() => ChatParticipantResponseDto)
  participants?: ChatParticipantResponseDto[];

  @Expose()
  @ApiProperty({ description: 'Последнее сообщение в чате', type: MessageResponseDto, nullable: true })
  @Type(() => MessageResponseDto)
  lastMessage?: MessageResponseDto;
}
