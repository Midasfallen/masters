import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum, IsUUID, IsNumber, IsDateString, IsString } from 'class-validator';
import { Type, Transform } from 'class-transformer';
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
    description: 'Фильтр по категориям (любого уровня: корневые, подкатегории, услуги)',
    type: [String],
    example: ['uuid-1', 'uuid-2']
  })
  @IsOptional()
  @Transform(({ value }) => {
    // Обработка случая, когда параметр передается как строка или массив
    if (Array.isArray(value)) {
      return value;
    }
    if (typeof value === 'string') {
      return [value];
    }
    return [];
  })
  @IsUUID('4', { each: true })
  category_ids?: string[];

  @ApiPropertyOptional({
    description: 'Курсор для пагинации (ISO timestamp последнего поста)',
    example: '2025-01-09T12:00:00.000Z'
  })
  @IsOptional()
  @IsDateString()
  cursor?: string;
}
