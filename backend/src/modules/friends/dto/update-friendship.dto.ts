import { ApiProperty } from '@nestjs/swagger';
import { IsEnum } from 'class-validator';
import { FriendshipStatus } from '../entities/friendship.entity';

export class UpdateFriendshipDto {
  @ApiProperty({ enum: FriendshipStatus, example: FriendshipStatus.ACCEPTED })
  @IsEnum(FriendshipStatus)
  status: FriendshipStatus;
}
