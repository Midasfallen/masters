import { ApiProperty } from '@nestjs/swagger';
import { ReviewerType } from '../entities/review.entity';

export class ReviewResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  booking_id: string;

  @ApiProperty()
  reviewer_id: string;

  @ApiProperty()
  reviewed_user_id: string;

  @ApiProperty({ enum: ReviewerType })
  reviewer_type: ReviewerType;

  @ApiProperty({ minimum: 1, maximum: 5 })
  rating: number;

  @ApiProperty({ required: false })
  comment?: string;

  @ApiProperty({ type: [String], required: false })
  photo_urls?: string[];

  @ApiProperty({ required: false })
  response?: string;

  @ApiProperty({ required: false })
  response_at?: Date;

  @ApiProperty()
  is_visible: boolean;

  @ApiProperty()
  reports_count: number;

  @ApiProperty()
  is_approved: boolean;

  @ApiProperty()
  created_at: Date;

  @ApiProperty()
  updated_at: Date;

  // Опциональные связанные данные
  @ApiProperty({ required: false, description: 'Информация об авторе отзыва' })
  reviewer?: {
    id: string;
    first_name: string;
    last_name: string;
    avatar_url?: string;
  };

  @ApiProperty({
    required: false,
    description: 'Информация о пользователе, которому оставлен отзыв',
  })
  reviewed_user?: {
    id: string;
    first_name: string;
    last_name: string;
    avatar_url?: string;
  };

  @ApiProperty({ required: false, description: 'Информация о бронировании' })
  booking?: {
    id: string;
    service_id: string;
    start_time: Date;
  };
}

export class ReviewStatsDto {
  @ApiProperty({ description: 'Общее количество отзывов' })
  total_reviews: number;

  @ApiProperty({ description: 'Средняя оценка', example: 4.8 })
  average_rating: number;

  @ApiProperty({
    description: 'Распределение оценок',
    example: { '1': 2, '2': 3, '3': 10, '4': 25, '5': 60 },
  })
  rating_distribution: Record<number, number>;

  @ApiProperty({ description: 'Количество отзывов с комментариями' })
  reviews_with_comments: number;

  @ApiProperty({ description: 'Количество отзывов с фото' })
  reviews_with_photos: number;
}
