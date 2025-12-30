import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsUUID, IsOptional, IsBoolean } from 'class-validator';
import { PaginationDto } from '../../../common/dto/pagination.dto';

export class FilterServicesDto extends PaginationDto {
  @ApiPropertyOptional({
    description: 'Фильтр по категории',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @IsOptional()
  @IsUUID('4')
  category_id?: string;

  @ApiPropertyOptional({
    description: 'Фильтр по подкатегории',
    example: '660e8400-e29b-41d4-a716-446655440001',
  })
  @IsOptional()
  @IsUUID('4')
  subcategory_id?: string;

  @ApiPropertyOptional({
    description: 'Только активные услуги',
    default: true,
  })
  @IsOptional()
  @IsBoolean()
  is_active?: boolean;

  @ApiPropertyOptional({
    description: 'Выезд к клиенту',
  })
  @IsOptional()
  @IsBoolean()
  is_mobile?: boolean;

  @ApiPropertyOptional({
    description: 'В салоне',
  })
  @IsOptional()
  @IsBoolean()
  is_in_salon?: boolean;
}
