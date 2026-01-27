import { ApiProperty } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { ReviewerType } from '../entities/review.entity';

/**
 * Базовый DTO для информации о пользователе в отзыве
 */
export class ReviewUserDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ example: 'Иван' })
  firstName: string;

  @Expose()
  @ApiProperty({ example: 'Петров' })
  lastName: string;

  @Expose()
  @ApiProperty({ example: 'https://storage.example.com/avatar.jpg', nullable: true })
  avatarUrl: string | null;
}

/**
 * Базовый DTO для информации о бронировании в отзыве
 */
export class ReviewBookingDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  serviceId: string;

  @Expose()
  @ApiProperty({ example: '2025-01-06T14:00:00Z' })
  startTime: Date;
}

/**
 * Response DTO для отзыва с camelCase полями
 */
export class ReviewResponseDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'ID записи (бронирования)' })
  bookingId: string;

  @Expose()
  @ApiProperty({ description: 'Кто оставил отзыв (user_id)' })
  reviewerId: string;

  @Expose()
  @ApiProperty({ description: 'Кому оставлен отзыв (user_id)' })
  reviewedUserId: string;

  @Expose()
  @ApiProperty({ enum: ReviewerType, description: 'Тип автора отзыва' })
  reviewerType: ReviewerType;

  @Expose()
  @ApiProperty({ description: 'Оценка (1-5)', example: 5, minimum: 1, maximum: 5 })
  rating: number;

  @Expose()
  @ApiProperty({ description: 'Текст отзыва', nullable: true })
  comment: string | null;

  @Expose()
  @ApiProperty({ description: 'Фото к отзыву', type: [String] })
  photoUrls: string[];

  @Expose()
  @ApiProperty({ description: 'Ответ на отзыв', nullable: true })
  response: string | null;

  @Expose()
  @ApiProperty({ description: 'Дата ответа', nullable: true })
  responseAt: Date | null;

  @Expose()
  @ApiProperty({ description: 'Отзыв видимый (не удален)', default: true })
  isVisible: boolean;

  @Expose()
  @ApiProperty({ description: 'Жалобы на отзыв', example: 0 })
  reportsCount: number;

  @Expose()
  @ApiProperty({ description: 'Модерация пройдена', default: true })
  isApproved: boolean;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z' })
  createdAt: Date;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z' })
  updatedAt: Date;

  // Опциональные связанные данные
  @Expose()
  @Type(() => ReviewUserDto)
  @ApiProperty({ type: ReviewUserDto, required: false, description: 'Информация об авторе отзыва' })
  reviewer?: ReviewUserDto;

  @Expose()
  @Type(() => ReviewUserDto)
  @ApiProperty({ type: ReviewUserDto, required: false, description: 'Информация о пользователе, которому оставлен отзыв' })
  reviewedUser?: ReviewUserDto;

  @Expose()
  @Type(() => ReviewBookingDto)
  @ApiProperty({ type: ReviewBookingDto, required: false, description: 'Информация о бронировании' })
  booking?: ReviewBookingDto;
}

/**
 * DTO для статистики отзывов с camelCase полями
 */
export class ReviewStatsDto {
  @Expose()
  @ApiProperty({ description: 'Общее количество отзывов' })
  totalReviews: number;

  @Expose()
  @ApiProperty({ description: 'Средняя оценка', example: 4.8 })
  averageRating: number;

  @Expose()
  @ApiProperty({
    description: 'Распределение оценок',
    example: { '1': 2, '2': 3, '3': 10, '4': 25, '5': 60 },
  })
  ratingDistribution: Record<number, number>;

  @Expose()
  @ApiProperty({ description: 'Количество отзывов с комментариями' })
  reviewsWithComments: number;

  @Expose()
  @ApiProperty({ description: 'Количество отзывов с фото' })
  reviewsWithPhotos: number;
}
