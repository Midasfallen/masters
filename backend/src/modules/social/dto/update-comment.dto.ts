import { ApiProperty } from '@nestjs/swagger';
import { IsString, MaxLength, MinLength } from 'class-validator';

export class UpdateCommentDto {
  @ApiProperty({ example: 'Обновленный текст комментария' })
  @IsString()
  @MinLength(1)
  @MaxLength(2000)
  content: string;
}
