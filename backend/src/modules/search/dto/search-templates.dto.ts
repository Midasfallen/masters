import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsOptional, IsUUID, IsInt, Min, Max } from 'class-validator';
import { Type, Transform } from 'class-transformer';

export class SearchTemplatesDto {
  @ApiProperty({
    description: 'Поисковый запрос (название шаблона, ключевые слова)',
    required: false,
    example: 'стрижка',
  })
  @IsOptional()
  @Transform(({ obj }) => obj.q || obj.query || '')
  @IsString()
  query?: string;

  @ApiProperty({
    description: 'ID категории (уровень 1) для фильтрации',
    required: false,
  })
  @IsOptional()
  @IsUUID('4')
  category_id?: string;

  @ApiProperty({
    description: 'Страница',
    required: false,
    default: 1,
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
    maximum: 100,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number = 20;
}
