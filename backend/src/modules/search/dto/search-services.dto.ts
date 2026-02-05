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
import { Type, Transform } from 'class-transformer';

export class SearchServicesDto {
  @ApiProperty({
    description: 'Поисковый запрос (название услуги, описание)',
    required: false,
    example: 'стрижка',
  })
  @IsOptional()
  @Transform(({ obj }) => obj.q || obj.query || '')
  @IsString()
  query?: string;

  @ApiProperty({
    description: 'ID категории (одиночный)',
    required: false,
  })
  @IsOptional()
  @IsUUID('4')
  category_id?: string;

  @ApiProperty({
    description: 'ID категорий для фильтрации (массив)',
    required: false,
    type: [String],
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
  @IsArray()
  @IsUUID('4', { each: true })
  category_ids?: string[];

  @ApiProperty({
    description: 'Минимальная цена',
    required: false,
  })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  min_price?: number;

  @ApiProperty({
    description: 'Максимальная цена',
    required: false,
  })
  @IsOptional()
  @Type(() => Number)
  @IsNumber()
  @Min(0)
  max_price?: number;

  @ApiProperty({
    description: 'Минимальная длительность (минуты)',
    required: false,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(5)
  min_duration?: number;

  @ApiProperty({
    description: 'Максимальная длительность (минуты)',
    required: false,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Max(1440)
  max_duration?: number;

  @ApiProperty({
    description: 'Теги услуги',
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
    enum: ['relevance', 'price_asc', 'price_desc', 'duration_asc', 'duration_desc', 'rating'],
    default: 'relevance',
  })
  @IsOptional()
  @IsString()
  sort?: string = 'relevance';
}
