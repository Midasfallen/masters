import { ApiProperty } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { BookingStatus } from '../entities/booking.entity';

/**
 * Базовый DTO для информации о пользователе (клиент/мастер) в бронировании
 */
export class BookingUserDto {
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

  @Expose()
  @ApiProperty({ example: '+79001234567', nullable: true })
  phone: string | null;
}

/**
 * Базовый DTO для информации об услуге в бронировании
 */
export class BookingServiceDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ example: 'Мужская стрижка' })
  name: string;

  @Expose()
  @ApiProperty({ example: 1500 })
  price: number;

  @Expose()
  @ApiProperty({ example: 60, description: 'Длительность в минутах' })
  durationMinutes: number;
}

/**
 * Response DTO для бронирования с camelCase полями
 */
export class BookingResponseDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'ID клиента' })
  clientId: string;

  @Expose()
  @ApiProperty({ description: 'ID мастера' })
  masterId: string;

  @Expose()
  @ApiProperty({ description: 'ID услуги' })
  serviceId: string;

  @Expose()
  @ApiProperty({ example: '2025-01-06T14:00:00Z', description: 'Время начала' })
  startTime: Date;

  @Expose()
  @ApiProperty({ example: '2025-01-06T15:30:00Z', description: 'Время окончания' })
  endTime: Date;

  @Expose()
  @ApiProperty({ example: 90, description: 'Длительность в минутах' })
  durationMinutes: number;

  @Expose()
  @ApiProperty({ example: 1500, description: 'Цена' })
  price: number;

  @Expose()
  @ApiProperty({ enum: BookingStatus, description: 'Статус бронирования' })
  status: BookingStatus;

  @Expose()
  @ApiProperty({ description: 'Комментарий клиента', nullable: true })
  comment: string | null;

  @Expose()
  @ApiProperty({ description: 'Причина отмены', nullable: true })
  cancellationReason: string | null;

  @Expose()
  @ApiProperty({ description: 'Кто отменил запись (ID пользователя)', nullable: true })
  cancelledBy: string | null;

  @Expose()
  @ApiProperty({ description: 'Клиент оставил отзыв', default: false })
  clientReviewLeft: boolean;

  @Expose()
  @ApiProperty({ description: 'Мастер оставил отзыв', default: false })
  masterReviewLeft: boolean;

  @Expose()
  @ApiProperty({ description: 'Дата завершения услуги', nullable: true })
  completedAt: Date | null;

  @Expose()
  @ApiProperty({ description: 'Адрес (если выезд)', nullable: true })
  locationAddress: string | null;

  @Expose()
  @ApiProperty({ description: 'Широта', nullable: true })
  locationLat: number | null;

  @Expose()
  @ApiProperty({ description: 'Долгота', nullable: true })
  locationLng: number | null;

  @Expose()
  @ApiProperty({ description: 'Тип локации: salon, client_location, online', example: 'salon' })
  locationType: string;

  @Expose()
  @ApiProperty({ description: 'Напоминание отправлено', default: false })
  reminderSent: boolean;

  @Expose()
  @ApiProperty({ description: 'Когда отправлено напоминание', nullable: true })
  reminderSentAt: Date | null;

  @Expose()
  @ApiProperty({ description: 'Метаданные (дополнительная информация)', nullable: true })
  metadata: Record<string, any> | null;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z' })
  createdAt: Date;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z' })
  updatedAt: Date;

  // Опциональные связанные данные для расширенных ответов
  @Expose()
  @Type(() => BookingUserDto)
  @ApiProperty({ type: BookingUserDto, required: false, description: 'Информация о клиенте' })
  client?: BookingUserDto;

  @Expose()
  @Type(() => BookingUserDto)
  @ApiProperty({ type: BookingUserDto, required: false, description: 'Информация о мастере' })
  master?: BookingUserDto;

  @Expose()
  @Type(() => BookingServiceDto)
  @ApiProperty({ type: BookingServiceDto, required: false, description: 'Информация об услуге' })
  service?: BookingServiceDto;
}
