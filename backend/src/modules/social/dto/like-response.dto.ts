import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';
import { LikableType } from '../entities/like.entity';

/**
 * Response DTO для лайка с camelCase полями
 */
export class LikeResponseDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'ID пользователя, который поставил лайк' })
  userId: string;

  @Expose()
  @ApiProperty({ enum: LikableType, example: LikableType.POST })
  likableType: LikableType;

  @Expose()
  @ApiProperty({ description: 'ID объекта (поста или комментария)' })
  likableId: string;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z' })
  createdAt: Date;
}
