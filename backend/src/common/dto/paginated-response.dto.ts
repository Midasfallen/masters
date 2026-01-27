import { ApiProperty } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';

export class PaginationMetaDto {
  @Expose()
  @ApiProperty({ description: 'Текущая страница', example: 1 })
  page: number;

  @Expose()
  @ApiProperty({ description: 'Элементов на странице', example: 20 })
  limit: number;

  @Expose()
  @ApiProperty({ description: 'Всего элементов', example: 145 })
  total: number;

  @Expose()
  @ApiProperty({ description: 'Всего страниц', example: 8 })
  totalPages: number;

  @Expose()
  @ApiProperty({
    description: 'Курсор для следующей страницы (cursor-based pagination)',
    nullable: true
  })
  nextCursor: string | null;

  @Expose()
  @ApiProperty({ description: 'Есть ли еще страницы', example: true })
  hasMore: boolean;
}

/**
 * Generic paginated response DTO
 * @example
 * class PostsPaginatedResponse extends PaginatedResponseDto<PostResponseDto> {
 *   @Type(() => PostResponseDto)
 *   data: PostResponseDto[];
 * }
 */
export class PaginatedResponseDto<T> {
  @Expose()
  @ApiProperty({ description: 'Массив данных', isArray: true })
  data: T[];

  @Expose()
  @Type(() => PaginationMetaDto)
  @ApiProperty({ description: 'Метаданные пагинации', type: PaginationMetaDto })
  meta: PaginationMetaDto;
}
