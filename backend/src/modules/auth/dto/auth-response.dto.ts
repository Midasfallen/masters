import { ApiProperty } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';

export class AuthUserDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ example: 'user@example.com' })
  email: string;

  @Expose()
  @ApiProperty({ example: 'John' })
  firstName: string;

  @Expose()
  @ApiProperty({ example: 'Doe' })
  lastName: string;

  @Expose()
  @ApiProperty({ example: 'https://example.com/avatar.jpg', nullable: true })
  avatarUrl: string | null;

  @Expose()
  @ApiProperty({ example: false })
  isMaster: boolean;

  @Expose()
  @ApiProperty({ example: false })
  isVerified: boolean;

  @Expose()
  @ApiProperty({ example: false })
  isPremium: boolean;
}

export class AuthResponseDto {
  @Expose()
  @ApiProperty({
    description: 'Access token для API запросов',
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  })
  accessToken: string;

  @Expose()
  @ApiProperty({
    description: 'Refresh token для обновления access token',
    example: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...',
  })
  refreshToken: string;

  @Expose()
  @ApiProperty({
    description: 'Тип токена',
    example: 'Bearer',
    default: 'Bearer',
  })
  tokenType: string;

  @Expose()
  @ApiProperty({
    description: 'Время жизни access token в секундах',
    example: 604800,
  })
  expiresIn: number;

  @Expose()
  @Type(() => AuthUserDto)
  @ApiProperty({
    description: 'Информация о пользователе',
    type: AuthUserDto,
  })
  user: AuthUserDto;
}
