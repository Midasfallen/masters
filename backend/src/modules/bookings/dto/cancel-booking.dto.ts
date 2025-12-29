import { ApiProperty } from '@nestjs/swagger';
import { IsString, MaxLength, MinLength } from 'class-validator';

export class CancelBookingDto {
  @ApiProperty({
    description: 'Причина отмены бронирования',
    minLength: 5,
    maxLength: 500,
    example: 'Изменились планы',
  })
  @IsString()
  @MinLength(5, { message: 'Причина отмены должна содержать минимум 5 символов' })
  @MaxLength(500)
  cancellation_reason: string;
}
