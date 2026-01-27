import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

/**
 * Response DTO для профиля мастера с camelCase полями
 */
export class MasterProfileResponseDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'ID пользователя' })
  userId: string;

  @Expose()
  @ApiProperty({ description: 'Название бизнеса/салона', nullable: true })
  businessName: string | null;

  @Expose()
  @ApiProperty({ description: 'Биография мастера', nullable: true })
  bio: string | null;

  @Expose()
  @ApiProperty({ description: 'ID категорий услуг', type: [String] })
  categoryIds: string[];

  @Expose()
  @ApiProperty({ description: 'ID подкатегорий', type: [String] })
  subcategoryIds: string[];

  @Expose()
  @ApiProperty({ description: 'Средний рейтинг', example: 4.85 })
  rating: number;

  @Expose()
  @ApiProperty({ description: 'Количество отзывов', example: 127 })
  reviewsCount: number;

  @Expose()
  @ApiProperty({ description: 'Завершенные бронирования', example: 245 })
  completedBookings: number;

  @Expose()
  @ApiProperty({ description: 'Количество отмен', example: 5 })
  cancellationsCount: number;

  @Expose()
  @ApiProperty({ description: 'Просмотры профиля', example: 750 })
  viewsCount: number;

  @Expose()
  @ApiProperty({ description: 'В избранном у клиентов', example: 42 })
  favoritesCount: number;

  @Expose()
  @ApiProperty({ description: 'Подписчики', example: 128 })
  subscribersCount: number;

  @Expose()
  @ApiProperty({ description: 'Широта локации', nullable: true, example: 55.7558 })
  locationLat: number | null;

  @Expose()
  @ApiProperty({ description: 'Долгота локации', nullable: true, example: 37.6173 })
  locationLng: number | null;

  @Expose()
  @ApiProperty({ description: 'Адрес', nullable: true })
  locationAddress: string | null;

  @Expose()
  @ApiProperty({ description: 'Название локации', nullable: true })
  locationName: string | null;

  @Expose()
  @ApiProperty({ description: 'Радиус обслуживания (км)', nullable: true, example: 10 })
  serviceRadiusKm: number | null;

  @Expose()
  @ApiProperty({ description: 'Выездное обслуживание', default: false })
  isMobile: boolean;

  @Expose()
  @ApiProperty({ description: 'Есть салон/студия', default: false })
  hasLocation: boolean;

  @Expose()
  @ApiProperty({ description: 'Только онлайн', default: false })
  isOnlineOnly: boolean;

  @Expose()
  @ApiProperty({ description: 'Фото портфолио', type: [String] })
  portfolioUrls: string[];

  @Expose()
  @ApiProperty({ description: 'Видео (15 сек)', type: [String] })
  videoUrls: string[];

  @Expose()
  @ApiProperty({ description: 'Ссылки на соцсети', type: 'object' })
  socialLinks: Record<string, string> | null;

  @Expose()
  @ApiProperty({ description: 'Время работы', type: 'object' })
  workingHours: Record<string, any> | null;

  @Expose()
  @ApiProperty({ description: 'Минимальное время записи (часов)', example: 2 })
  minBookingHours: number;

  @Expose()
  @ApiProperty({ description: 'Максимум записей в день', nullable: true, example: 10 })
  maxBookingsPerDay: number | null;

  @Expose()
  @ApiProperty({ description: 'Автоподтверждение записей', default: false })
  autoConfirm: boolean;

  @Expose()
  @ApiProperty({ description: 'Опыт работы (лет)', nullable: true, example: 10 })
  yearsOfExperience: number | null;

  @Expose()
  @ApiProperty({ description: 'Сертификаты/образование', type: [String] })
  certificates: string[];

  @Expose()
  @ApiProperty({ description: 'Языки', type: [String], example: ['ru', 'en'] })
  languages: string[];

  @Expose()
  @ApiProperty({ description: 'Профиль активен', default: true })
  isActive: boolean;

  @Expose()
  @ApiProperty({ description: 'Профиль одобрен администрацией', default: false })
  isApproved: boolean;

  @Expose()
  @ApiProperty({ description: 'Текущий шаг создания профиля (0-5)', example: 5 })
  setupStep: number;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z' })
  createdAt: Date;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z' })
  updatedAt: Date;
}
