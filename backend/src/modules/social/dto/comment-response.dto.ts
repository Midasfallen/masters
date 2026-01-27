import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

/**
 * Response DTO для комментария с camelCase полями
 */
export class CommentResponseDto {
  @Expose()
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  id: string;

  @Expose()
  @ApiProperty({ description: 'ID поста' })
  postId: string;

  @Expose()
  @ApiProperty({ description: 'ID автора комментария' })
  authorId: string;

  @Expose()
  @ApiProperty({ example: 'Отличный пост!' })
  content: string;

  @Expose()
  @ApiProperty({ description: 'ID родительского комментария (для ответов)', nullable: true })
  parentCommentId: string | null;

  @Expose()
  @ApiProperty({ description: 'Количество лайков', default: 0 })
  likesCount: number;

  @Expose()
  @ApiProperty({ description: 'Количество ответов', default: 0 })
  repliesCount: number;

  @Expose()
  @ApiProperty({ description: 'Комментарий отредактирован', default: false })
  isEdited: boolean;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z' })
  createdAt: Date;

  @Expose()
  @ApiProperty({ example: '2025-01-06T10:00:00Z' })
  updatedAt: Date;
}
