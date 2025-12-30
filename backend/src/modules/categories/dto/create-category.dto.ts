import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  IsOptional,
  IsUUID,
  IsUrl,
  IsHexColor,
  IsInt,
  Min,
  IsBoolean,
  ValidateNested,
  IsArray,
  MaxLength,
  MinLength,
  Matches,
} from 'class-validator';
import { Type } from 'class-transformer';

export class CategoryTranslationDto {
  @ApiProperty({
    description: 'Код языка',
    example: 'ru',
    pattern: '^[a-z]{2}(-[A-Z]{2})?$',
  })
  @IsString()
  @Matches(/^[a-z]{2}(-[A-Z]{2})?$/, {
    message: 'Язык должен быть в формате ISO 639-1 (например, ru, en, en-US)',
  })
  language: string;

  @ApiProperty({
    description: 'Название категории',
    example: 'Красота',
    minLength: 2,
    maxLength: 255,
  })
  @IsString()
  @MinLength(2)
  @MaxLength(255)
  name: string;

  @ApiProperty({
    description: 'Описание категории',
    required: false,
  })
  @IsOptional()
  @IsString()
  @MaxLength(1000)
  description?: string;

  @ApiProperty({
    description: 'Ключевые слова для SEO',
    required: false,
    type: [String],
    example: ['красота', 'косметология', 'макияж'],
  })
  @IsOptional()
  @IsArray()
  @IsString({ each: true })
  keywords?: string[];
}

export class CreateCategoryDto {
  @ApiProperty({
    description: 'ID родительской категории (NULL для корневой)',
    required: false,
  })
  @IsOptional()
  @IsUUID('4')
  parent_id?: string;

  @ApiProperty({
    description: 'Уникальный slug категории',
    example: 'beauty',
    pattern: '^[a-z0-9-]+$',
  })
  @IsString()
  @Matches(/^[a-z0-9-]+$/, {
    message: 'Slug может содержать только строчные буквы, цифры и дефисы',
  })
  @MinLength(2)
  @MaxLength(100)
  slug: string;

  @ApiProperty({
    description: 'URL иконки категории',
    required: false,
  })
  @IsOptional()
  @IsUrl()
  icon_url?: string;

  @ApiProperty({
    description: 'URL изображения категории',
    required: false,
  })
  @IsOptional()
  @IsUrl()
  image_url?: string;

  @ApiProperty({
    description: 'Цвет категории в формате HEX',
    example: '#FF5722',
    required: false,
  })
  @IsOptional()
  @IsHexColor()
  color?: string;

  @ApiProperty({
    description: 'Порядок отображения',
    required: false,
    default: 0,
  })
  @IsOptional()
  @IsInt()
  @Min(0)
  display_order?: number;

  @ApiProperty({
    description: 'Категория активна',
    required: false,
    default: true,
  })
  @IsOptional()
  @IsBoolean()
  is_active?: boolean;

  @ApiProperty({
    description: 'Популярная категория',
    required: false,
    default: false,
  })
  @IsOptional()
  @IsBoolean()
  is_popular?: boolean;

  @ApiProperty({
    description: 'Переводы названий и описаний',
    type: [CategoryTranslationDto],
  })
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => CategoryTranslationDto)
  translations: CategoryTranslationDto[];

  @ApiProperty({
    description: 'Метаданные (SEO и прочее)',
    required: false,
  })
  @IsOptional()
  metadata?: Record<string, any>;
}
