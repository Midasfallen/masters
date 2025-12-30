import { ApiProperty } from '@nestjs/swagger';
import { NotificationType } from '../entities/notification.entity';

export class NotificationResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  user_id: string;

  @ApiProperty({ enum: NotificationType })
  type: NotificationType;

  @ApiProperty()
  title: string;

  @ApiProperty()
  message: string;

  @ApiProperty()
  is_read: boolean;

  @ApiProperty({ required: false })
  related_id?: string;

  @ApiProperty({ required: false })
  related_type?: string;

  @ApiProperty({ required: false })
  metadata?: Record<string, any>;

  @ApiProperty({ required: false })
  action_url?: string;

  @ApiProperty()
  created_at: Date;
}
