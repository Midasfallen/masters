import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class UserResponseDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ example: 'user@example.com' })
  email: string;

  @Expose()
  @ApiProperty({ example: '+79001234567', nullable: true })
  phone: string | null;

  @Expose()
  @ApiProperty({ example: 'Иван' })
  firstName: string;

  @Expose()
  @ApiProperty({ example: 'Петров' })
  lastName: string;

  @Expose()
  @ApiProperty({ example: 'Иван Петров' })
  fullName: string;

  @Expose()
  @ApiProperty({
    example: 'https://storage.example.com/avatars/user.jpg',
    nullable: true
  })
  avatarUrl: string | null;

  @Expose()
  @ApiProperty({ description: 'Является ли пользователь мастером' })
  isMaster: boolean;

  @Expose()
  @ApiProperty({ description: 'Завершена ли настройка профиля мастера' })
  masterProfileCompleted: boolean;

  @Expose()
  @ApiProperty({ description: 'KYC верификация пройдена' })
  isVerified: boolean;

  @Expose()
  @ApiProperty({ description: 'Премиум подписка активна' })
  isPremium: boolean;

  @Expose()
  @ApiProperty({ example: '2025-12-31T23:59:59Z', nullable: true })
  premiumUntil: Date | null;

  @Expose()
  @ApiProperty({ description: 'Активен ли пользователь' })
  isActive: boolean;

  @Expose()
  @ApiProperty({ example: '2025-01-13T10:30:00Z', nullable: true })
  lastLoginAt: Date | null;

  @Expose()
  @ApiProperty({ example: 4.75 })
  rating: number;

  @Expose()
  @ApiProperty({ example: 42 })
  reviewsCount: number;

  @Expose()
  @ApiProperty({ example: 2 })
  cancellationsCount: number;

  @Expose()
  @ApiProperty({ example: 0 })
  noShowsCount: number;

  @Expose()
  @ApiProperty({ example: 0 })
  blacklistsCount: number;

  @Expose()
  @ApiProperty({ example: 15 })
  postsCount: number;

  @Expose()
  @ApiProperty({ example: 28 })
  friendsCount: number;

  @Expose()
  @ApiProperty({ example: 150 })
  followersCount: number;

  @Expose()
  @ApiProperty({ example: 85 })
  followingCount: number;

  @Expose()
  @ApiProperty({ example: 'ru' })
  language: string;

  @Expose()
  @ApiProperty({ example: 'Europe/Moscow' })
  timezone: string;

  @Expose()
  @ApiProperty({ example: 55.7558, nullable: true })
  lastLocationLat: number | null;

  @Expose()
  @ApiProperty({ example: 37.6173, nullable: true })
  lastLocationLng: number | null;

  @Expose()
  @ApiProperty()
  createdAt: Date;

  @Expose()
  @ApiProperty()
  updatedAt: Date;
}
