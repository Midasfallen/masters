import { ApiProperty } from '@nestjs/swagger';
import {
  IsUUID,
  IsDateString,
  IsOptional,
  IsString,
  MaxLength,
  IsIn,
  IsNumber,
  Min,
  Max,
} from 'class-validator';

export class CreateBookingDto {
  @ApiProperty({ description: 'ID услуги' })
  @IsUUID('4')
  service_id: string;

  @ApiProperty({
    description: 'Дата и время начала',
    example: '2025-01-06T14:00:00Z',
  })
  @IsDateString()
  start_time: string;

  @ApiProperty({
    description: 'Комментарий к бронированию',
    required: false,
    maxLength: 500,
  })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  comment?: string;

  @ApiProperty({
    description: 'Тип локации',
    enum: ['salon', 'client_location', 'online'],
    default: 'salon',
  })
  @IsOptional()
  @IsIn(['salon', 'client_location', 'online'])
  location_type?: string;

  @ApiProperty({
    description: 'Адрес (если выезд к клиенту)',
    required: false,
  })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  location_address?: string;

  @ApiProperty({
    description: 'Широта локации',
    required: false,
    example: 55.755826,
  })
  @IsOptional()
  @IsNumber()
  @Min(-90)
  @Max(90)
  location_lat?: number;

  @ApiProperty({
    description: 'Долгота локации',
    required: false,
    example: 37.617299,
  })
  @IsOptional()
  @IsNumber()
  @Min(-180)
  @Max(180)
  location_lng?: number;

  @ApiProperty({
    description: 'Дополнительная информация (JSON)',
    required: false,
  })
  @IsOptional()
  metadata?: Record<string, any>;
}
