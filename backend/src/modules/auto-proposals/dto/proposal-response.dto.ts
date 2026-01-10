import { ApiProperty } from '@nestjs/swagger';
import { ProposalStatus } from '../entities/auto-proposal.entity';

export class ProposalResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  user_id: string;

  @ApiProperty()
  master_id: string;

  @ApiProperty()
  service_id: string;

  @ApiProperty()
  category_id: string;

  @ApiProperty({ enum: ProposalStatus })
  status: ProposalStatus;

  @ApiProperty()
  match_score: number;

  @ApiProperty({ type: 'object' })
  match_reasons: {
    location_score?: number;
    rating_score?: number;
    price_score?: number;
    availability_score?: number;
    history_score?: number;
    reasons: string[];
  };

  @ApiProperty({ required: false })
  proposed_datetime?: Date;

  @ApiProperty()
  expires_at: Date;

  @ApiProperty({ required: false })
  booking_id?: string;

  @ApiProperty()
  created_at: Date;

  // Дополнительная информация о мастере и услуге
  @ApiProperty({ type: 'object' })
  master?: {
    id: string;
    first_name: string;
    last_name: string;
    avatar_url?: string;
    rating?: number;
  };

  @ApiProperty({ type: 'object' })
  service?: {
    id: string;
    title: string;
    price: number;
    duration_minutes: number;
  };
}
