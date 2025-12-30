import { ApiProperty } from '@nestjs/swagger';
import { IsEnum, IsUUID } from 'class-validator';
import { LikableType } from '../entities/like.entity';

export class CreateLikeDto {
  @ApiProperty({ enum: LikableType, example: LikableType.POST })
  @IsEnum(LikableType)
  likable_type: LikableType;

  @ApiProperty({ description: 'ID объекта (поста или комментария)' })
  @IsUUID()
  likable_id: string;
}
