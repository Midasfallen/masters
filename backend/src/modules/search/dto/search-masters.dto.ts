import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  IsOptional,
  IsUUID,
  IsNumber,
  Min,
  Max,
  IsInt,
  IsArray,
} from 'class-validator';
import { Type } from 'class-transformer';

export class SearchMastersDto {
  @ApiProperty({
    description: 'Поисковый запрос (имя, описание, услуги)',
    required: false,
    example: 'парикмахер',
  })
  @IsOptional()
  @IsString()
  query?: string;

  @ApiProperty({
    description: 'ID категории для фильтрации',
    required: false,
  })
  @IsOptional()
  @IsUUID('4')
  category_id?: string;

  @ApiProperty({
    description: 'Минимальный рейтинг',
    required: false,
    minimum: 0,
    maximum: 5,
  })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  @Max(5)
  min_rating?: number;

  @ApiProperty({
    description: 'Широта для geo-поиска',
    required: false,
  })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  lat?: number;

  @ApiProperty({
    description: 'Долгота для geo-поиска',
    required: false,
  })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  lng?: number;

  @ApiProperty({
    description: 'Радиус поиска в км',
    required: false,
    default: 10,
  })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(1)
  @Max(100)
  radius?: number;

  @ApiProperty({
    description: 'Теги для фильтрации',
    required: false,
    type: [String],
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  tags?: string[];

  @ApiProperty({
    description: 'Страница',
    required: false,
    default: 1,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number = 1;

  @ApiProperty({
    description: 'Количество на странице',
    required: false,
    default: 20,
    maximum: 100,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number = 20;

  @ApiProperty({
    description: 'Сортировка',
    required: false,
    enum: ['relevance', 'rating', 'reviews_count', 'price_asc', 'price_desc'],
    default: 'relevance',
  })
  @IsOptional()
  @IsString()
  sort?: string = 'relevance';
}
