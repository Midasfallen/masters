import { ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsOptional,
  MinLength,
  MaxLength,
  Matches,
} from 'class-validator';

export class UpdateUserDto {
  @ApiPropertyOptional({
    example: 'Иван',
    description: 'Имя пользователя',
  })
  @IsOptional()
  @IsString()
  @MinLength(2)
  @MaxLength(100)
  first_name?: string;

  @ApiPropertyOptional({
    example: 'Петров',
    description: 'Фамилия пользователя',
  })
  @IsOptional()
  @IsString()
  @MinLength(2)
  @MaxLength(100)
  last_name?: string;

  @ApiPropertyOptional({
    example: '+79001234567',
    description: 'Номер телефона',
  })
  @IsOptional()
  @IsString()
  @Matches(/^\+?[1-9]\d{1,14}$/, {
    message: 'Некорректный формат телефона',
  })
  phone?: string;

  @ApiPropertyOptional({
    example: 'https://storage.example.com/avatars/user.jpg',
    description: 'URL аватара',
  })
  @IsOptional()
  @IsString()
  avatar_url?: string;

  @ApiPropertyOptional({
    example: 'ru',
    description: 'Язык интерфейса (en, ru, de, es, fr)',
  })
  @IsOptional()
  @IsString()
  language?: string;

  @ApiPropertyOptional({
    example: 'Europe/Moscow',
    description: 'Часовой пояс',
  })
  @IsOptional()
  @IsString()
  timezone?: string;

  @ApiPropertyOptional({
    example: 55.7558,
    description: 'Широта последней локации',
  })
  @IsOptional()
  last_location_lat?: number;

  @ApiPropertyOptional({
    example: 37.6173,
    description: 'Долгота последней локации',
  })
  @IsOptional()
  last_location_lng?: number;
}
