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

/** Результат поиска по шаблонам услуг (для приоритета в глобальном поиске) */
export class ServiceTemplateSearchResultDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  slug: string;

  @ApiProperty()
  name: string;

  @ApiProperty({ required: false })
  description?: string;

  @ApiProperty()
  category_id: string;

  @ApiProperty({ required: false })
  default_duration_minutes?: number;

  @ApiProperty({ required: false })
  default_price_range_min?: number;

  @ApiProperty({ required: false })
  default_price_range_max?: number;
}

/** Результат поиска пользователей (для создания чата) */
export class UserSearchResultDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @ApiProperty({ example: 'Анна' })
  firstName: string;

  @ApiProperty({ example: 'Иванова' })
  lastName: string;

  @ApiProperty({ example: 'Анна Иванова' })
  fullName: string;

  @ApiProperty({ example: 'https://storage.example.com/avatars/user.jpg', nullable: true })
  avatarUrl: string | null;

  @ApiProperty({ example: 'anna@test.com' })
  email: string;

  @ApiProperty({ description: 'Является ли пользователь мастером' })
  isMaster: boolean;

  @ApiProperty({ description: 'KYC верификация пройдена' })
  isVerified: boolean;
}

/** Результат поиска по категориям (L0/L1) */
export class CategorySearchResultDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  name: string;

  @ApiProperty()
  slug: string;

  @ApiProperty({ description: 'Уровень: 0 = L0 (группа), 1 = L1 (подкатегория)' })
  level: number;

  @ApiProperty({ required: false })
  parent_id?: string;

  @ApiProperty()
  language: string;

  @ApiProperty({ required: false, description: 'Название с тегами <em> для подсветки совпадений' })
  name_highlighted?: string;
}

/** Агрегированный ответ поиска: мастера, услуги, категории в одном запросе */
export class SearchAggregationDto {
  @ApiProperty({ type: [MasterSearchResultDto] })
  masters: MasterSearchResultDto[];

  @ApiProperty({ type: [ServiceSearchResultDto] })
  services: ServiceSearchResultDto[];

  @ApiProperty({ type: [CategorySearchResultDto] })
  categories: CategorySearchResultDto[];

  @ApiProperty({ description: 'Поисковый запрос' })
  query: string;

  @ApiProperty({ description: 'Время выполнения в мс' })
  processing_time_ms: number;
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
