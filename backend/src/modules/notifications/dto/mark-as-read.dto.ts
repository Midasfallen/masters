import { ApiProperty } from '@nestjs/swagger';
import { IsArray, IsUUID } from 'class-validator';

export class MarkAsReadDto {
  @ApiProperty({
    description: 'Массив ID уведомлений для пометки как прочитанных',
    type: [String],
  })
  @IsArray()
  @IsUUID('4', { each: true })
  notification_ids: string[];
}
