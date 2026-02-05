import { ApiProperty } from '@nestjs/swagger';

export class ReindexResponseDto {
  @ApiProperty({
    description: 'Успешность операции',
    example: true,
  })
  success: boolean;

  @ApiProperty({
    description: 'Сообщение о результате',
    example: 'Категории успешно переиндексированы',
  })
  message: string;

  @ApiProperty({
    description: 'Количество проиндексированных документов',
    example: 63,
    required: false,
  })
  documentsCount?: number;

  @ApiProperty({
    description: 'Время выполнения операции в миллисекундах',
    example: 1523,
    required: false,
  })
  processingTime?: number;
}

export class SearchStatsDto {
  @ApiProperty({
    description: 'Статистика индекса мастеров',
    example: {
      numberOfDocuments: 5,
      isIndexing: false,
      fieldDistribution: { name: 5, specialization: 5 },
    },
  })
  masters: any;

  @ApiProperty({
    description: 'Статистика индекса услуг',
    example: {
      numberOfDocuments: 20,
      isIndexing: false,
    },
  })
  services: any;

  @ApiProperty({
    description: 'Статистика индекса шаблонов услуг',
    example: {
      numberOfDocuments: 340,
      isIndexing: false,
    },
  })
  service_templates: any;

  @ApiProperty({
    description: 'Статистика индекса категорий',
    example: {
      numberOfDocuments: 63,
      isIndexing: false,
    },
  })
  categories: any;
}
