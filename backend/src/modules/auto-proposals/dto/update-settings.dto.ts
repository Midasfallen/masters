import { ApiProperty } from '@nestjs/swagger';
import {
  IsBoolean,
  IsEnum,
  IsOptional,
  IsArray,
  IsNumber,
  Min,
  Max,
  IsObject,
  ValidateNested,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ProposalInterval } from '../entities/auto-proposal.entity';

class TimeSlotDto {
  @ApiProperty({ description: 'День недели (0 = Воскресенье, 6 = Суббота)', example: 1 })
  @IsNumber()
  @Min(0)
  @Max(6)
  day_of_week: number;

  @ApiProperty({ description: 'Начало временного слота (часы)', example: 9 })
  @IsNumber()
  @Min(0)
  @Max(23)
  start_hour: number;

  @ApiProperty({ description: 'Конец временного слота (часы)', example: 18 })
  @IsNumber()
  @Min(0)
  @Max(23)
  end_hour: number;
}

export class UpdateAutoProposalSettingsDto {
  @ApiProperty({
    description: 'Включены ли автоматические предложения',
    example: true,
    required: false,
  })
  @IsOptional()
  @IsBoolean()
  is_enabled?: boolean;

  @ApiProperty({
    description: 'Интервал предложений в днях',
    enum: ProposalInterval,
    example: ProposalInterval.WEEKLY,
    required: false,
  })
  @IsOptional()
  @IsEnum(ProposalInterval)
  interval_days?: ProposalInterval;

  @ApiProperty({
    description: 'Предпочитаемые категории услуг (UUIDs)',
    type: [String],
    example: ['uuid-1', 'uuid-2'],
    required: false,
  })
  @IsOptional()
  @IsArray()
  preferred_categories?: string[];

  @ApiProperty({
    description: 'Максимальная цена услуги',
    example: 5000,
    required: false,
  })
  @IsOptional()
  @IsNumber()
  @Min(0)
  max_price?: number;

  @ApiProperty({
    description: 'Максимальное расстояние в км',
    example: 10,
    required: false,
  })
  @IsOptional()
  @IsNumber()
  @Min(1)
  @Max(100)
  max_distance_km?: number;

  @ApiProperty({
    description: 'Минимальный рейтинг мастера (0-5)',
    example: 4.0,
    required: false,
  })
  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(5)
  min_rating?: number;

  @ApiProperty({
    description: 'Предпочитаемые временные слоты',
    type: [TimeSlotDto],
    required: false,
  })
  @IsOptional()
  @IsArray()
  @ValidateNested({ each: true })
  @Type(() => TimeSlotDto)
  preferred_time_slots?: TimeSlotDto[];
}
