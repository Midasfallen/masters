import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsOptional,
  IsEnum,
  IsArray,
  ValidateNested,
  IsNumber,
  IsUUID,
  MinLength,
  MaxLength,
  IsBoolean,
} from 'class-validator';
import { Type } from 'class-transformer';
import { PostType, PostPrivacy } from '../entities/post.entity';
import { MediaType } from '../entities/post-media.entity';

class CreatePostMediaDto {
  @ApiProperty({ enum: MediaType })
  @IsEnum(MediaType)
  type: MediaType;

  @ApiProperty({ example: 'https://storage.example.com/posts/photo.jpg' })
  @IsString()
  url: string;

  @ApiPropertyOptional({ example: 'https://storage.example.com/posts/photo_thumb.jpg' })
  @IsOptional()
  @IsString()
  thumbnail_url?: string;

  @ApiPropertyOptional({ example: 0 })
  @IsOptional()
  @IsNumber()
  order?: number;

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
}

export class CreatePostDto {
  @ApiProperty({ enum: PostType, example: PostType.TEXT })
  @IsEnum(PostType)
  type: PostType;

  @ApiPropertyOptional({ example: 'Привет, мир! Это мой первый пост.' })
  @IsOptional()
  @IsString()
  @MinLength(1, { message: 'Content cannot be empty string' })
  @MaxLength(5000)
  content?: string;

  @ApiPropertyOptional({ enum: PostPrivacy, default: PostPrivacy.PUBLIC })
  @IsOptional()
  @IsEnum(PostPrivacy)
  privacy?: PostPrivacy;

  @ApiPropertyOptional({ description: 'Медиа файлы (фото/видео)' })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CreatePostMediaDto)
  media?: CreatePostMediaDto[];

  @ApiPropertyOptional({ description: 'ID поста для репоста' })
  @IsOptional()
  @IsUUID()
  repost_of_id?: string;

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

  @ApiPropertyOptional({ default: false })
  @IsOptional()
  @IsBoolean()
  comments_disabled?: boolean;
}
