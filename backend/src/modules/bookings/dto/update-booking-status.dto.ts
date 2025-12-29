import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsOptional, IsString, MaxLength } from 'class-validator';
import { BookingStatus } from '../entities/booking.entity';

export class UpdateBookingStatusDto {
  @ApiProperty({
    description: 'Новый статус бронирования',
    enum: BookingStatus,
  })
  @IsEnum(BookingStatus)
  status: BookingStatus;

  @ApiProperty({
    description: 'Причина изменения статуса (для отмены)',
    required: false,
    maxLength: 500,
  })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  reason?: string;
}
