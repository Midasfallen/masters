import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import {
  IsString,
  IsOptional,
  MinLength,
  MaxLength,
  IsBoolean,
} from 'class-validator';

/**
 * ШАГ 2: Базовая информация профиля
 * Название бизнеса, описание, опыт
 */
export class Step2ProfileInfoDto {
  @ApiPropertyOptional({
    description: 'Название бизнеса/салона (опционально)',
    example: 'Салон красоты "Элита"',
  })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  business_name?: string;

  @ApiProperty({
    description: 'Описание профиля мастера',
    example: 'Опытный парикмахер с 10-летним стажем работы',
  })
  @IsString()
  @MinLength(20, { message: 'Описание должно быть не менее 20 символов' })
  @MaxLength(2000)
  bio: string;

  @ApiPropertyOptional({
    description: 'Год начала карьеры',
    example: 2015,
  })
  @IsOptional()
  years_of_experience?: number;

  @ApiPropertyOptional({
    description: 'Языки общения',
    type: [String],
    example: ['ru', 'en'],
  })
  @IsOptional()
  @IsString({ each: true })
  languages?: string[];

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

  @ApiPropertyOptional({
    description: 'Только онлайн услуги',
    default: false,
  })
  @IsOptional()
  @IsBoolean()
  is_online_only?: boolean;
}
