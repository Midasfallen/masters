import { ApiProperty } from '@nestjs/swagger';
import { FavoriteEntityType } from '../entities/favorite.entity';

export class FavoriteResponseDto {
  @ApiProperty({ description: 'ID избранного' })
  id: string;

  @ApiProperty({ description: 'ID пользователя' })
  user_id: string;

  @ApiProperty({ description: 'Тип сущности', enum: FavoriteEntityType })
  entity_type: FavoriteEntityType;

  @ApiProperty({ description: 'ID сущности' })
  entity_id: string;

  @ApiProperty({ description: 'Дата добавления' })
  created_at: Date;

  @ApiProperty({ description: 'Данные сущности (мастер или пост)', required: false })
  entity?: any;
}
