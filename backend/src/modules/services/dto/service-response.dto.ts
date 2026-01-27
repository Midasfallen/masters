import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

/**
 * Response DTO для услуги с camelCase полями
 */
export class ServiceResponseDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'ID мастера' })
  masterId: string;

  @Expose()
  @ApiProperty({ description: 'ID категории' })
  categoryId: string;

  @Expose()
  @ApiProperty({ description: 'ID подкатегории', nullable: true })
  subcategoryId: string | null;

  @Expose()
  @ApiProperty({ example: 'Мужская стрижка' })
  name: string;

  @Expose()
  @ApiProperty({ description: 'Описание услуги', nullable: true })
  description: string | null;

  @Expose()
  @ApiProperty({ description: 'Цена услуги', example: 1500 })
  price: number;

  @Expose()
  @ApiProperty({ description: 'Валюта', example: 'RUB', default: 'RUB' })
  currency: string;

  @Expose()
  @ApiProperty({ description: 'Цена от (для диапазона)', nullable: true })
  priceFrom: number | null;

  @Expose()
  @ApiProperty({ description: 'Цена до (для диапазона)', nullable: true })
  priceTo: number | null;

  @Expose()
  @ApiProperty({ description: 'Длительность в минутах', example: 60 })
  durationMinutes: number;

  @Expose()
  @ApiProperty({ description: 'Доступна для онлайн-бронирования', default: true })
  isBookableOnline: boolean;

  @Expose()
  @ApiProperty({ description: 'Выездная услуга', default: false })
  isMobile: boolean;

  @Expose()
  @ApiProperty({ description: 'Услуга в салоне', default: true })
  isInSalon: boolean;

  @Expose()
  @ApiProperty({ description: 'Теги услуги', type: [String] })
  tags: string[];

  @Expose()
  @ApiProperty({ description: 'Фотографии услуги', type: [String] })
  photoUrls: string[];

  @Expose()
  @ApiProperty({ description: 'Количество бронирований', example: 0 })
  bookingsCount: number;

  @Expose()
  @ApiProperty({ description: 'Средняя оценка', example: 0 })
  averageRating: number;

  @Expose()
  @ApiProperty({ description: 'Услуга активна', default: true })
  isActive: boolean;

  @Expose()
  @ApiProperty({ description: 'Порядок отображения', example: 0 })
  displayOrder: number;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z' })
  createdAt: Date;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z' })
  updatedAt: Date;
}
