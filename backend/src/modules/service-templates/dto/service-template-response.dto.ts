import { ApiProperty } from '@nestjs/swagger';

export class ServiceTemplateResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @ApiProperty({ description: 'ID категории level 1', example: '660e8400-e29b-41d4-a716-446655440001' })
  categoryId: string;

  @ApiProperty({ description: 'SEO-friendly slug', example: 'krasota-i-uhod-parikmaherskie-uslugi-muzhskaya-strizhka' })
  slug: string;

  @ApiProperty({ example: 'Мужская стрижка' })
  name: string;

  @ApiProperty({ description: 'Описание шаблона', required: false })
  description?: string;

  @ApiProperty({ description: 'URL иконки', required: false })
  iconUrl?: string;

  @ApiProperty({ description: 'Длительность по умолчанию (минуты)', required: false })
  defaultDurationMinutes?: number;

  @ApiProperty({ description: 'Минимальная цена по умолчанию', required: false })
  defaultPriceRangeMin?: number;

  @ApiProperty({ description: 'Максимальная цена по умолчанию', required: false })
  defaultPriceRangeMax?: number;

  @ApiProperty({ description: 'Шаблон активен', default: true })
  isActive: boolean;

  @ApiProperty({ description: 'Порядок отображения', example: 1 })
  displayOrder: number;

  @ApiProperty()
  createdAt: Date;

  @ApiProperty()
  updatedAt: Date;
}

export class ServiceTemplateListResponseDto {
  @ApiProperty({ type: [ServiceTemplateResponseDto] })
  data: ServiceTemplateResponseDto[];

  @ApiProperty({ description: 'Общее количество шаблонов' })
  total: number;
}
