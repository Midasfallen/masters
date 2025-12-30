import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsEnum,
  IsString,
  IsOptional,
  IsUUID,
  IsNumber,
  ValidateNested,
  MaxLength,
} from 'class-validator';
import { Type } from 'class-transformer';
import { MessageType } from '../entities/message.entity';

class MediaMetadataDto {
  @ApiPropertyOptional({ example: 1920 })
  @IsOptional()
  @IsNumber()
  width?: number;

  @ApiPropertyOptional({ example: 1080 })
  @IsOptional()
  @IsNumber()
  height?: number;

  @ApiPropertyOptional({ example: 60 })
  @IsOptional()
  @IsNumber()
  duration?: number;

  @ApiPropertyOptional({ example: 1024000 })
  @IsOptional()
  @IsNumber()
  size?: number;

  @ApiPropertyOptional({ example: 'document.pdf' })
  @IsOptional()
  @IsString()
  filename?: string;

  @ApiPropertyOptional({ example: 'application/pdf' })
  @IsOptional()
  @IsString()
  mime_type?: string;
}

export class CreateMessageDto {
  @ApiProperty({ description: 'ID чата' })
  @IsUUID()
  chat_id: string;

  @ApiProperty({ enum: MessageType, example: MessageType.TEXT })
  @IsEnum(MessageType)
  type: MessageType;

  @ApiPropertyOptional({ example: 'Привет! Как дела?' })
  @IsOptional()
  @IsString()
  @MaxLength(5000)
  content?: string;

  @ApiPropertyOptional({ example: 'https://storage.example.com/messages/photo.jpg' })
  @IsOptional()
  @IsString()
  media_url?: string;

  @ApiPropertyOptional({ example: 'https://storage.example.com/messages/photo_thumb.jpg' })
  @IsOptional()
  @IsString()
  thumbnail_url?: string;

  @ApiPropertyOptional()
  @IsOptional()
  @ValidateNested()
  @Type(() => MediaMetadataDto)
  media_metadata?: MediaMetadataDto;

  @ApiPropertyOptional({ example: 55.7558 })
  @IsOptional()
  @IsNumber()
  location_lat?: number;

  @ApiPropertyOptional({ example: 37.6173 })
  @IsOptional()
  @IsNumber()
  location_lng?: number;

  @ApiPropertyOptional({ example: 'Москва, Красная площадь' })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  location_name?: string;

  @ApiPropertyOptional({ description: 'ID сообщения, на которое отвечаем' })
  @IsOptional()
  @IsUUID()
  reply_to_id?: string;
}
