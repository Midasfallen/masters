import { ApiProperty } from '@nestjs/swagger';
import { IsString, MaxLength } from 'class-validator';

export class UpdateMessageDto {
  @ApiProperty({ example: 'Обновленный текст сообщения' })
  @IsString()
  @MaxLength(5000)
  content: string;
}
