import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsUUID, IsOptional } from 'class-validator';
import { PaginationDto } from '../../../common/dto/pagination.dto';

export class FilterCommentsDto extends PaginationDto {
  @ApiProperty({ description: 'ID поста для фильтрации комментариев' })
  @IsUUID()
  post_id: string;

  @ApiPropertyOptional({ description: 'ID родительского комментария (для ответов)' })
  @IsOptional()
  @IsUUID()
  parent_comment_id?: string;
}
