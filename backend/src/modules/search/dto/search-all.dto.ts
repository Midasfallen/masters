import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsOptional, IsInt, Min, Max } from 'class-validator';
import { Type, Transform } from 'class-transformer';

export class SearchAllDto {
  @ApiProperty({
    description: 'Поисковый запрос (мастера, услуги, категории)',
    required: true,
    example: 'Кра',
  })
  @Transform(({ obj }) => (obj.q ?? obj.query ?? '').trim())
  @IsString()
  q: string;

  @ApiProperty({
    description: 'Лимит результатов на каждый тип (мастера, услуги, категории)',
    required: false,
    default: 10,
    minimum: 1,
    maximum: 50,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(50)
  limit?: number = 10;

  @ApiProperty({
    description: 'Язык для поиска категорий',
    required: false,
    example: 'ru',
  })
  @IsOptional()
  @IsString()
  language?: string = 'ru';
}
