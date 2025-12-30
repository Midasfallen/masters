import { ApiProperty } from '@nestjs/swagger';
import { IsBoolean } from 'class-validator';

export class UpdateSubscriptionDto {
  @ApiProperty({ default: true })
  @IsBoolean()
  notifications_enabled: boolean;
}
