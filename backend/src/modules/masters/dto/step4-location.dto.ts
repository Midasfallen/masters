import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsOptional,
  IsNumber,
  Min,
  Max,
  IsBoolean,
} from 'class-validator';

/**
 * ШАГ 4: География работы
 * Локация, адрес, радиус обслуживания
 */
export class Step4LocationDto {
  @ApiPropertyOptional({
    description: 'Широта локации',
    example: 55.7558,
  })
  @IsOptional()
  @IsNumber()
  @Min(-90)
  @Max(90)
  location_lat?: number;

  @ApiPropertyOptional({
    description: 'Долгота локации',
    example: 37.6173,
  })
  @IsOptional()
  @IsNumber()
  @Min(-180)
  @Max(180)
  location_lng?: number;

  @ApiPropertyOptional({
    description: 'Адрес салона/студии',
    example: 'Москва, ул. Тверская, д. 1',
  })
  @IsOptional()
  @IsString()
  location_address?: string;

  @ApiPropertyOptional({
    description: 'Название локации',
    example: 'Центр Москвы',
  })
  @IsOptional()
  @IsString()
  location_name?: string;

  @ApiPropertyOptional({
    description: 'Радиус обслуживания в км (для выездов)',
    example: 10,
  })
  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(100)
  service_radius_km?: number;

  @ApiPropertyOptional({
    description: 'Выезд к клиенту',
    default: false,
  })
  @IsOptional()
  @IsBoolean()
  is_mobile?: boolean;

  @ApiPropertyOptional({
    description: 'Есть салон/студия',
    default: false,
  })
  @IsOptional()
  @IsBoolean()
  has_location?: boolean;
}
