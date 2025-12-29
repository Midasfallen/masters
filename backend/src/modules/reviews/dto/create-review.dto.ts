import { ApiProperty } from '@nestjs/swagger';
import {
  IsUUID,
  IsInt,
  Min,
  Max,
  IsString,
  IsOptional,
  IsArray,
  IsUrl,
  MaxLength,
  MinLength,
} from 'class-validator';

export class CreateReviewDto {
  @ApiProperty({
    description: 'ID бронирования',
  })
  @IsUUID('4')
  booking_id: string;

  @ApiProperty({
    description: 'Оценка от 1 до 5',
    minimum: 1,
    maximum: 5,
    example: 5,
  })
  @IsInt()
  @Min(1, { message: 'Минимальная оценка - 1' })
  @Max(5, { message: 'Максимальная оценка - 5' })
  rating: number;

  @ApiProperty({
    description: 'Текст отзыва (опционально)',
    required: false,
    minLength: 10,
    maxLength: 1000,
  })
  @IsOptional()
  @IsString()
  @MinLength(10, { message: 'Минимальная длина отзыва - 10 символов' })
  @MaxLength(1000, { message: 'Максимальная длина отзыва - 1000 символов' })
  comment?: string;

  @ApiProperty({
    description: 'Ссылки на фотографии (максимум 5)',
    required: false,
    type: [String],
    maxItems: 5,
  })
  @IsOptional()
  @IsArray()
  @IsUrl({}, { each: true })
  photo_urls?: string[];
}
