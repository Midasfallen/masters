import { ApiProperty } from '@nestjs/swagger';
import { IsString, MinLength, MaxLength } from 'class-validator';

export class ResponseReviewDto {
  @ApiProperty({
    description: 'Ответ на отзыв',
    minLength: 10,
    maxLength: 500,
  })
  @IsString()
  @MinLength(10, { message: 'Минимальная длина ответа - 10 символов' })
  @MaxLength(500, { message: 'Максимальная длина ответа - 500 символов' })
  response: string;
}
