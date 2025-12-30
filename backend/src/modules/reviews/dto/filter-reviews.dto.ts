import { ApiProperty } from '@nestjs/swagger';
import {
  IsOptional,
  IsUUID,
  IsInt,
  Min,
  Max,
  IsIn,
} from 'class-validator';
import { Type } from 'class-transformer';
import { ReviewerType } from '../entities/review.entity';

export class FilterReviewsDto {
  @ApiProperty({
    description: 'ID пользователя, которому оставлены отзывы',
    required: false,
  })
  @IsOptional()
  @IsUUID('4')
  reviewed_user_id?: string;

  @ApiProperty({
    description: 'ID автора отзывов',
    required: false,
  })
  @IsOptional()
  @IsUUID('4')
  reviewer_id?: string;

  @ApiProperty({
    description: 'Тип автора',
    enum: ReviewerType,
    required: false,
  })
  @IsOptional()
  @IsIn(Object.values(ReviewerType))
  reviewer_type?: ReviewerType;

  @ApiProperty({
    description: 'Минимальная оценка',
    minimum: 1,
    maximum: 5,
    required: false,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(5)
  min_rating?: number;

  @ApiProperty({
    description: 'Максимальная оценка',
    minimum: 1,
    maximum: 5,
    required: false,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(5)
  max_rating?: number;

  @ApiProperty({
    description: 'Только с комментариями',
    required: false,
  })
  @IsOptional()
  @IsIn(['true', 'false'])
  with_comments?: string;

  @ApiProperty({
    description: 'Только с фотографиями',
    required: false,
  })
  @IsOptional()
  @IsIn(['true', 'false'])
  with_photos?: string;

  @ApiProperty({
    description: 'Страница',
    required: false,
    default: 1,
    minimum: 1,
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
    minimum: 1,
    maximum: 50,
  })
  @IsOptional()
  @Type(() => Number)
  @IsInt()
  @Min(1)
  @Max(50)
  limit?: number = 20;

  @ApiProperty({
    description: 'Сортировка',
    required: false,
    enum: ['created_at_desc', 'created_at_asc', 'rating_desc', 'rating_asc'],
    default: 'created_at_desc',
  })
  @IsOptional()
  @IsIn(['created_at_desc', 'created_at_asc', 'rating_desc', 'rating_asc'])
  sort?: string = 'created_at_desc';
}
