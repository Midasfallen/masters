import { ApiProperty } from '@nestjs/swagger';
import {
  IsEmail,
  IsString,
  MinLength,
  MaxLength,
  Matches,
  IsOptional,
} from 'class-validator';

export class RegisterDto {
  @ApiProperty({
    example: 'user@example.com',
    description: 'Email пользователя',
  })
  @IsEmail({}, { message: 'Некорректный email адрес' })
  email: string;

  @ApiProperty({
    example: '+79001234567',
    description: 'Номер телефона',
    required: false,
  })
  @IsOptional()
  @IsString()
  @Matches(/^\+?[1-9]\d{1,14}$/, {
    message: 'Некорректный формат телефона',
  })
  phone?: string;

  @ApiProperty({
    example: 'SecurePass123',
    description: 'Пароль (минимум 8 символов, должен содержать буквы и цифры)',
    minLength: 8,
  })
  @IsString()
  @MinLength(8, { message: 'Пароль должен быть не менее 8 символов' })
  @Matches(/^(?=.*[A-Za-z])(?=.*\d)/, {
    message: 'Пароль должен содержать буквы и цифры',
  })
  password: string;

  @ApiProperty({
    example: 'Иван',
    description: 'Имя',
  })
  @IsString()
  @MinLength(2, { message: 'Имя должно быть не менее 2 символов' })
  @MaxLength(100, { message: 'Имя не должно превышать 100 символов' })
  first_name: string;

  @ApiProperty({
    example: 'Петров',
    description: 'Фамилия',
  })
  @IsString()
  @MinLength(2, { message: 'Фамилия должна быть не менее 2 символов' })
  @MaxLength(100, { message: 'Фамилия не должна превышать 100 символов' })
  last_name: string;

  @ApiProperty({
    example: 'ru',
    description: 'Язык интерфейса',
    default: 'en',
    required: false,
  })
  @IsOptional()
  @IsString()
  language?: string;
}
