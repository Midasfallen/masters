import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsUUID, IsOptional, MaxLength, MinLength } from 'class-validator';

export class CreateCommentDto {
  @ApiProperty({ description: 'ID поста' })
  @IsUUID()
  post_id: string;

  @ApiProperty({ example: 'Отличный пост!' })
  @IsString()
  @MinLength(1)
  @MaxLength(2000)
  content: string;

  @ApiPropertyOptional({ description: 'ID родительского комментария (для ответов)' })
  @IsOptional()
  @IsUUID()
  parent_comment_id?: string;
}
