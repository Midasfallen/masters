import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

/**
 * Response DTO для репоста с camelCase полями
 */
export class RepostResponseDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'ID пользователя, который сделал репост' })
  userId: string;

  @Expose()
  @ApiProperty({ description: 'ID оригинального поста' })
  postId: string;

  @Expose()
  @ApiProperty({ description: 'Комментарий к репосту', nullable: true })
  comment: string | null;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z' })
  createdAt: Date;
}
