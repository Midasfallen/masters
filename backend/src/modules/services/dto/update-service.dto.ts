import { ApiPropertyOptional, PartialType } from '@nestjs/swagger';
import { CreateServiceDto } from './create-service.dto';
import { IsBoolean, IsOptional } from 'class-validator';

export class UpdateServiceDto extends PartialType(CreateServiceDto) {
  @ApiPropertyOptional({
    description: 'Активна ли услуга',
    default: true,
  })
  @IsOptional()
  @IsBoolean()
  is_active?: boolean;
}
