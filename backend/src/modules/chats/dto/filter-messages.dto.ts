import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsUUID, IsOptional, IsEnum } from 'class-validator';
import { PaginationDto } from '../../../common/dto/pagination.dto';
import { MessageType } from '../entities/message.entity';

export class FilterMessagesDto extends PaginationDto {
  @ApiProperty({ description: 'ID чата' })
  @IsUUID()
  chat_id: string;

  @ApiPropertyOptional({ enum: MessageType })
  @IsOptional()
  @IsEnum(MessageType)
  type?: MessageType;
}
