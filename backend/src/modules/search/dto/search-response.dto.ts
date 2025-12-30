import { ApiProperty } from '@nestjs/swagger';

export class MasterSearchResultDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  first_name: string;

  @ApiProperty()
  last_name: string;

  @ApiProperty({ required: false })
  avatar_url?: string;

  @ApiProperty()
  average_rating: number;

  @ApiProperty()
  reviews_count: number;

  @ApiProperty({ type: [String] })
  category_names: string[];

  @ApiProperty({ required: false })
  description?: string;

  @ApiProperty({ type: [String] })
  tags: string[];

  @ApiProperty({ required: false })
  location_address?: string;

  @ApiProperty({ required: false })
  distance_km?: number;
}

export class ServiceSearchResultDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  name: string;

  @ApiProperty({ required: false })
  description?: string;

  @ApiProperty()
  price: number;

  @ApiProperty()
  duration_minutes: number;

  @ApiProperty()
  category_name: string;

  @ApiProperty({ type: [String] })
  tags: string[];

  @ApiProperty({ required: false })
  photo_urls?: string[];

  @ApiProperty({ description: 'Информация о мастере' })
  master: {
    id: string;
    first_name: string;
    last_name: string;
    avatar_url?: string;
    average_rating: number;
  };
}

export class SearchResponseDto<T> {
  @ApiProperty()
  data: T[];

  @ApiProperty()
  total: number;

  @ApiProperty()
  page: number;

  @ApiProperty()
  limit: number;

  @ApiProperty({ description: 'Время поиска в мс' })
  processing_time_ms: number;

  @ApiProperty({ description: 'Поисковый запрос' })
  query?: string;
}
