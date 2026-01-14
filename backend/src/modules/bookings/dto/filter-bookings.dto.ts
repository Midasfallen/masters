import { ApiProperty } from '@nestjs/swagger';
import {
  IsOptional,
  IsEnum,
  IsUUID,
  IsDateString,
  IsInt,
  Min,
  Max,
  IsIn,
} from 'class-validator';
import { Type } from 'class-transformer';
import { BookingStatus } from '../entities/booking.entity';

export class FilterBookingsDto {
  @ApiProperty({
    description: 'Статус бронирования',
    enum: BookingStatus,
    required: false,
  })
  @IsOptional()
  @IsEnum(BookingStatus)
  status?: BookingStatus;

  @ApiProperty({
    description: 'ID услуги',
    required: false,
  })
  @IsOptional()
  @IsUUID('4')
  service_id?: string;

  @ApiProperty({
    description: 'ID клиента (для мастера)',
    required: false,
  })
  @IsOptional()
  @IsUUID('4')
  client_id?: string;

  @ApiProperty({
    description: 'ID мастера (для клиента)',
    required: false,
  })
  @IsOptional()
  @IsUUID('4')
  master_id?: string;

  @ApiProperty({
    description: 'Дата начала периода',
    required: false,
    example: '2025-01-01T00:00:00Z',
  })
  @IsOptional()
  @IsDateString()
  start_date?: string;

  @ApiProperty({
    description: 'Дата окончания периода',
    required: false,
    example: '2025-12-31T23:59:59Z',
  })
  @IsOptional()
  @IsDateString()
  end_date?: string;

  @ApiProperty({
    description: 'Необходимость оставить отзыв',
    required: false,
  })
  @IsOptional()
  @IsIn(['true', 'false'])
  needs_review?: string;

  @ApiProperty({
    description: 'Роль пользователя (для /bookings/my endpoint)',
    required: false,
    enum: ['client', 'master'],
  })
  @IsOptional()
  @IsIn(['client', 'master'])
  role?: 'client' | 'master';

  @ApiProperty({
    description: 'Страница',
    required: false,
    default: 1,
    minimum: 1,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number = 1;

  @ApiProperty({
    description: 'Количество на странице',
    required: false,
    default: 20,
    minimum: 1,
    maximum: 100,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number = 20;

  @ApiProperty({
    description: 'Сортировка',
    required: false,
    enum: ['start_time_asc', 'start_time_desc', 'created_at_desc'],
    default: 'start_time_desc',
  })
  @IsOptional()
  @IsIn(['start_time_asc', 'start_time_desc', 'created_at_desc'])
  sort?: string = 'start_time_desc';
}
