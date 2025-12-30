import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { Exclude } from 'class-transformer';

export class UserResponseDto {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @ApiProperty({ example: 'user@example.com' })
  email: string;

  @ApiPropertyOptional({ example: '+79001234567' })
  phone: string;

  @ApiProperty({ example: 'Иван' })
  first_name: string;

  @ApiProperty({ example: 'Петров' })
  last_name: string;

  @ApiProperty({ example: 'Иван Петров' })
  full_name: string;

  @ApiPropertyOptional({ example: 'https://storage.example.com/avatars/user.jpg' })
  avatar_url: string;

  @ApiProperty({ description: 'Является ли пользователь мастером' })
  is_master: boolean;

  @ApiProperty({ description: 'Завершена ли настройка профиля мастера' })
  master_profile_completed: boolean;

  @ApiProperty({ description: 'KYC верификация пройдена' })
  is_verified: boolean;

  @ApiProperty({ description: 'Премиум подписка активна' })
  is_premium: boolean;

  @ApiPropertyOptional({ example: '2025-12-31T23:59:59Z' })
  premium_until: Date;

  @ApiProperty({ example: 4.75 })
  rating: number;

  @ApiProperty({ example: 42 })
  reviews_count: number;

  @ApiProperty({ example: 15 })
  posts_count: number;

  @ApiProperty({ example: 28 })
  friends_count: number;

  @ApiProperty({ example: 150 })
  followers_count: number;

  @ApiProperty({ example: 85 })
  following_count: number;

  @ApiProperty({ example: 'ru' })
  language: string;

  @ApiProperty({ example: 'Europe/Moscow' })
  timezone: string;

  @ApiProperty()
  created_at: Date;

  @ApiProperty()
  updated_at: Date;

  @Exclude()
  password_hash: string;

  @Exclude()
  cancellations_count: number;

  @Exclude()
  no_shows_count: number;

  @Exclude()
  blacklists_count: number;
}
