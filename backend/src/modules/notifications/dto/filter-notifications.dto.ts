import { ApiProperty } from '@nestjs/swagger';
import {
  IsOptional,
  IsIn,
  IsInt,
  Min,
  Max,
} from 'class-validator';
import { Type } from 'class-transformer';
import { NotificationType } from '../entities/notification.entity';

export class FilterNotificationsDto {
  @ApiProperty({
    description: 'Тип уведомления',
    enum: NotificationType,
    required: false,
  })
  @IsOptional()
  @IsIn(Object.values(NotificationType))
  type?: NotificationType;

  @ApiProperty({
    description: 'Статус прочтения',
    required: false,
  })
  @IsOptional()
  @IsIn(['true', 'false'])
  is_read?: string;

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
}
