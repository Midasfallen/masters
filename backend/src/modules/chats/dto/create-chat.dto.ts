import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsEnum,
  IsString,
  IsOptional,
  IsArray,
  IsUUID,
  MaxLength,
} from 'class-validator';
import { ChatType } from '../entities/chat.entity';

export class CreateChatDto {
  @ApiProperty({ enum: ChatType, example: ChatType.DIRECT })
  @IsEnum(ChatType)
  type: ChatType;

  @ApiPropertyOptional({ example: 'Команда разработки' })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  name?: string;

  @ApiPropertyOptional({ example: 'https://storage.example.com/chats/avatar.jpg' })
  @IsOptional()
  @IsString()
  avatar_url?: string;

  @ApiProperty({ description: 'ID участников чата', type: [String] })
  @IsArray()
  @IsUUID('4', { each: true })
  participant_ids: string[];
}
