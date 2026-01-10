import { ApiProperty } from '@nestjs/swagger';
import { IsDateString, IsOptional, IsString } from 'class-validator';

export class AcceptProposalDto {
  @ApiProperty({
    description: 'Предпочитаемая дата и время бронирования',
    example: '2026-01-20T10:00:00Z',
    required: false,
  })
  @IsOptional()
  @IsDateString()
  preferred_datetime?: string;

  @ApiProperty({
    description: 'Дополнительные комментарии',
    example: 'Хочу записаться на завтра',
    required: false,
  })
  @IsOptional()
  @IsString()
  comment?: string;
}
