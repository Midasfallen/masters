import { ApiProperty } from '@nestjs/swagger';

export class CategoryTranslationResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  language: string;

  @ApiProperty()
  name: string;

  @ApiProperty({ required: false })
  description?: string;

  @ApiProperty({ type: [String], required: false })
  keywords?: string[];
}

export class CategoryResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty({ description: 'ID родительской категории', required: false })
  parent_id?: string;

  @ApiProperty()
  slug: string;

  @ApiProperty()
  level: number;

  @ApiProperty({ required: false })
  icon_url?: string;

  @ApiProperty({ required: false })
  image_url?: string;

  @ApiProperty({ required: false })
  color?: string;

  @ApiProperty()
  display_order: number;

  @ApiProperty()
  masters_count: number;

  @ApiProperty()
  services_count: number;

  @ApiProperty()
  is_active: boolean;

  @ApiProperty()
  is_popular: boolean;

  @ApiProperty({ required: false })
  metadata?: Record<string, any>;

  @ApiProperty()
  created_at: Date;

  @ApiProperty()
  updated_at: Date;

  @ApiProperty({
    description: 'Переводы категории',
    type: [CategoryTranslationResponseDto],
  })
  translations?: CategoryTranslationResponseDto[];

  @ApiProperty({
    description: 'Дочерние категории',
    type: [CategoryResponseDto],
    required: false,
  })
  children?: CategoryResponseDto[];

  @ApiProperty({
    description: 'Родительская категория',
    type: () => CategoryResponseDto,
    required: false,
  })
  parent?: CategoryResponseDto;
}

export class CategoryTreeResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  slug: string;

  @ApiProperty()
  level: number;

  @ApiProperty({ required: false })
  icon_url?: string;

  @ApiProperty({ required: false })
  color?: string;

  @ApiProperty()
  display_order: number;

  @ApiProperty()
  masters_count: number;

  @ApiProperty()
  is_popular: boolean;

  @ApiProperty({
    description: 'Название на текущем языке',
  })
  name: string;

  @ApiProperty({
    description: 'Описание на текущем языке',
    required: false,
  })
  description?: string;

  @ApiProperty({
    description: 'Дочерние категории',
    type: [CategoryTreeResponseDto],
    required: false,
  })
  children?: CategoryTreeResponseDto[];
}
