import { ApiProperty } from '@nestjs/swagger';
import { IsUUID } from 'class-validator';

export class CreateFriendshipDto {
  @ApiProperty({ description: 'ID пользователя, которому отправляется запрос' })
  @IsUUID()
  addressee_id: string;
}
