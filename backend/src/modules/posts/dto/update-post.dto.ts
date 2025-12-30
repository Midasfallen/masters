import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsOptional,
  IsEnum,
  MaxLength,
  IsBoolean,
} from 'class-validator';
import { PostPrivacy } from '../entities/post.entity';

export class UpdatePostDto {
  @ApiPropertyOptional({ example: 'Обновленный текст поста' })
  @IsOptional()
  @IsString()
  @MaxLength(5000)
  content?: string;

  @ApiPropertyOptional({ enum: PostPrivacy })
  @IsOptional()
  @IsEnum(PostPrivacy)
  privacy?: PostPrivacy;

  @ApiPropertyOptional({ default: false })
  @IsOptional()
  @IsBoolean()
  comments_disabled?: boolean;

  @ApiPropertyOptional({ default: false })
  @IsOptional()
  @IsBoolean()
  is_pinned?: boolean;
}
