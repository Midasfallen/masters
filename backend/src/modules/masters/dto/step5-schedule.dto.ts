import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsObject, IsOptional, IsNumber, Min, Max, IsBoolean } from 'class-validator';

/**
 * ШАГ 5: Расписание и настройки записей (ФИНАЛЬНЫЙ ШАГ)
 * После завершения этого шага:
 * - user.is_master = true
 * - user.master_profile_completed = true
 * - master_profile.setup_step = 5
 */
export class Step5ScheduleDto {
  @ApiPropertyOptional({
    description: 'График работы (JSON)',
    type: 'object',
    example: {
      monday: { start: '09:00', end: '18:00', enabled: true },
      tuesday: { start: '09:00', end: '18:00', enabled: true },
      wednesday: { start: '09:00', end: '18:00', enabled: true },
      thursday: { start: '09:00', end: '18:00', enabled: true },
      friday: { start: '09:00', end: '18:00', enabled: true },
      saturday: { start: '10:00', end: '16:00', enabled: true },
      sunday: { enabled: false },
    },
  })
  @IsOptional()
  @IsObject()
  working_hours?: Record<string, any>;

  @ApiPropertyOptional({
    description: 'Минимальное время для записи (часов заранее)',
    example: 2,
    default: 2,
  })
  @IsOptional()
  @IsNumber()
  @Min(0)
  @Max(168)
  min_booking_hours?: number;

  @ApiPropertyOptional({
    description: 'Максимум записей в день',
    example: 10,
  })
  @IsOptional()
  @IsNumber()
  @Min(1)
  @Max(50)
  max_bookings_per_day?: number;

  @ApiPropertyOptional({
    description: 'Автоподтверждение записей',
    default: false,
  })
  @IsOptional()
  @IsBoolean()
  auto_confirm?: boolean;

  @ApiPropertyOptional({
    description: 'Соцсети (JSON)',
    type: 'object',
    example: {
      instagram: '@username',
      telegram: '@username',
      whatsapp: '+79001234567',
    },
  })
  @IsOptional()
  @IsObject()
  social_links?: Record<string, string>;
}
