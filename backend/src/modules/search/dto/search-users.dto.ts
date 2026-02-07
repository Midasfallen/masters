import { ApiProperty } from '@nestjs/swagger';
import { IsOptional, IsString, IsInt, Min } from 'class-validator';
import { Type } from 'class-transformer';

export class SearchUsersDto {
  @ApiProperty({ required: false, description: 'Поисковый запрос', example: 'Анна' })
  @IsOptional()
  @IsString()
  query?: string;

  @ApiProperty({ required: false, description: 'Номер страницы', example: 1 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  page?: number;

  @ApiProperty({ required: false, description: 'Количество результатов', example: 20 })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  limit?: number;
}
