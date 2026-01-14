import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum, IsUUID, IsNumber, IsDateString } from 'class-validator';
import { Type } from 'class-transformer';
import { PostType } from '../entities/post.entity';
import { PaginationDto } from '../../../common/dto/pagination.dto';

export class FilterPostsDto extends PaginationDto {
  @ApiPropertyOptional({ description: 'ID автора для фильтрации постов' })
  @IsOptional()
  @IsUUID()
  author_id?: string;

  @ApiPropertyOptional({ enum: PostType, description: 'Тип поста' })
  @IsOptional()
  @IsEnum(PostType)
  type?: PostType;

  @ApiPropertyOptional({ description: 'Широта для поиска постов рядом' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  lat?: number;

  @ApiPropertyOptional({ description: 'Долгота для поиска постов рядом' })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  lng?: number;

  @ApiPropertyOptional({ description: 'Радиус поиска в км', default: 10 })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  radius?: number;

  @ApiPropertyOptional({
    description: 'Курсор для пагинации (ISO timestamp последнего поста)',
    example: '2025-01-09T12:00:00.000Z'
  })
  @IsOptional()
  @IsDateString()
  cursor?: string;
}
