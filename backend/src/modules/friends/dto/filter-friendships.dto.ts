import { ApiPropertyOptional } from '@nestjs/swagger';
import { IsOptional, IsEnum } from 'class-validator';
import { FriendshipStatus } from '../entities/friendship.entity';
import { PaginationDto } from '../../../common/dto/pagination.dto';

export class FilterFriendshipsDto extends PaginationDto {
  @ApiPropertyOptional({ enum: FriendshipStatus })
  @IsOptional()
  @IsEnum(FriendshipStatus)
  status?: FriendshipStatus;
}
