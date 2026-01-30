import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

/**
 * Упрощенный Response DTO для пользователя в контексте чата
 */
export class ChatUserResponseDto {
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
  @ApiProperty({ example: 'Иван Петров' })
  fullName: string;

  @Expose()
  @ApiProperty({
    example: 'https://storage.example.com/avatars/user.jpg',
    nullable: true,
  })
  avatarUrl: string | null;

  @Expose()
  @ApiProperty({ description: 'Является ли пользователь мастером' })
  isMaster: boolean;

  @Expose()
  @ApiProperty({ description: 'KYC верификация пройдена' })
  isVerified: boolean;
}
