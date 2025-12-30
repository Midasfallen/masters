import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsString, IsOptional, MaxLength } from 'class-validator';

export class UpdateChatDto {
  @ApiPropertyOptional({ example: 'Команда разработки (обновлено)' })
  @IsOptional()
  @IsString()
  @MaxLength(255)
  name?: string;

  @ApiPropertyOptional({ example: 'https://storage.example.com/chats/avatar.jpg' })
  @IsOptional()
  @IsString()
  avatar_url?: string;
}
