import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsUUID } from 'class-validator';
import { FavoriteEntityType } from '../entities/favorite.entity';

export class AddFavoriteDto {
  @ApiProperty({
    description: 'Тип сущности',
    enum: FavoriteEntityType,
    example: FavoriteEntityType.MASTER,
  })
  @IsEnum(FavoriteEntityType)
  entity_type: FavoriteEntityType;

  @ApiProperty({
    description: 'ID сущности (мастер или пост)',
    example: '123e4567-e89b-12d3-a456-426614174000',
  })
  @IsUUID()
  entity_id: string;
}
