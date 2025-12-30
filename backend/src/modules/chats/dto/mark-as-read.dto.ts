import { ApiProperty } from '@nestjs/swagger';
import { IsUUID } from 'class-validator';

export class MarkAsReadDto {
  @ApiProperty({ description: 'ID последнего прочитанного сообщения' })
  @IsUUID()
  message_id: string;
}
