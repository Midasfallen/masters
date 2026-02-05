import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsUUID,
  IsNumber,
  IsBoolean,
  IsArray,
  IsOptional,
  Min,
  Max,
  MinLength,
  MaxLength,
} from 'class-validator';

export class CreateServiceDto {
  @ApiProperty({
    description: 'UUID категории услуги (level 1)',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @IsUUID('4')
  category_id: string;

  @ApiPropertyOptional({
    description: 'UUID шаблона услуги (опционально)',
    example: '660e8400-e29b-41d4-a716-446655440001',
  })
  @IsOptional()
  @IsUUID('4')
  service_template_id?: string;

  @ApiPropertyOptional({
    description: 'UUID подкатегории (опционально, deprecated)',
    example: '660e8400-e29b-41d4-a716-446655440001',
    deprecated: true,
  })
  @IsOptional()
  @IsUUID('4')
  subcategory_id?: string;

  @ApiProperty({
    description: 'Название услуги',
    example: 'Мужская стрижка',
  })
  @IsString()
  @MinLength(3, { message: 'Название должно быть не менее 3 символов' })
  @MaxLength(255)
  name: string;

  @ApiPropertyOptional({
    description: 'Описание услуги',
    example: 'Классическая мужская стрижка с укладкой',
  })
  @IsOptional()
  @IsString()
  @MaxLength(2000)
  description?: string;

  @ApiProperty({
    description: 'Цена услуги',
    example: 1500,
  })
  @IsNumber()
  @Min(0, { message: 'Цена не может быть отрицательной' })
  price: number;

  @ApiPropertyOptional({
    description: 'Валюта (по умолчанию RUB)',
    example: 'RUB',
    default: 'RUB',
  })
  @IsOptional()
  @IsString()
  currency?: string;

  @ApiPropertyOptional({
    description: 'Минимальная цена (для диапазона)',
    example: 1200,
  })
  @IsOptional()
  @IsNumber()
  @Min(0)
  price_from?: number;

  @ApiPropertyOptional({
    description: 'Максимальная цена (для диапазона)',
    example: 2000,
  })
  @IsOptional()
  @IsNumber()
  @Min(0)
  price_to?: number;

  @ApiProperty({
    description: 'Длительность в минутах',
    example: 60,
  })
  @IsNumber()
  @Min(5, { message: 'Минимальная длительность 5 минут' })
  @Max(1440, { message: 'Максимальная длительность 24 часа' })
  duration_minutes: number;

  @ApiPropertyOptional({
    description: 'Можно забронировать онлайн',
    default: true,
  })
  @IsOptional()
  @IsBoolean()
  is_bookable_online?: boolean;

  @ApiPropertyOptional({
    description: 'Выезд к клиенту',
    default: false,
  })
  @IsOptional()
  @IsBoolean()
  is_mobile?: boolean;

  @ApiPropertyOptional({
    description: 'В салоне/студии',
    default: true,
  })
  @IsOptional()
  @IsBoolean()
  is_in_salon?: boolean;

  @ApiPropertyOptional({
    description: 'Теги/ключевые слова для поиска',
    type: [String],
    example: ['стрижка', 'мужская', 'классика'],
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  tags?: string[];

  @ApiPropertyOptional({
    description: 'URL фото результатов работы',
    type: [String],
    example: ['https://storage.example.com/services/photo1.jpg'],
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  photo_urls?: string[];

  @ApiPropertyOptional({
    description: 'Порядок отображения',
    example: 1,
    default: 0,
  })
  @IsOptional()
  @IsNumber()
  display_order?: number;
}
