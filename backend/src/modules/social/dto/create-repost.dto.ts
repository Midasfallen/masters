import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsUUID, IsOptional, MaxLength } from 'class-validator';

export class CreateRepostDto {
  @ApiProperty({ description: 'ID оригинального поста' })
  @IsUUID()
  post_id: string;

  @ApiPropertyOptional({ example: 'Отличная идея!' })
  @IsOptional()
  @IsString()
  @MaxLength(500)
  comment?: string;
}
