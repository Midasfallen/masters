import { ApiProperty } from '@nestjs/swagger';
import { Expose, Type } from 'class-transformer';
import { ProposalStatus } from '../entities/auto-proposal.entity';

export class MatchReasonsDto {
  @Expose()
  locationScore?: number;

  @Expose()
  ratingScore?: number;

  @Expose()
  priceScore?: number;

  @Expose()
  availabilityScore?: number;

  @Expose()
  historyScore?: number;

  @Expose()
  reasons: string[];
}

export class ProposalMasterDto {
  @Expose()
  id: string;

  @Expose()
  firstName: string;

  @Expose()
  lastName: string;

  @Expose()
  avatarUrl?: string;

  @Expose()
  rating?: number;
}

export class ProposalServiceDto {
  @Expose()
  id: string;

  @Expose()
  title: string;

  @Expose()
  price: number;

  @Expose()
  durationMinutes: number;
}

export class ProposalResponseDto {
  @Expose()
  @ApiProperty()
  id: string;

  @Expose()
  @ApiProperty()
  userId: string;

  @Expose()
  @ApiProperty()
  masterId: string;

  @Expose()
  @ApiProperty()
  serviceId: string;

  @Expose()
  @ApiProperty()
  categoryId: string;

  @Expose()
  @ApiProperty({ enum: ProposalStatus })
  status: ProposalStatus;

  @Expose()
  @ApiProperty()
  matchScore: number;

  @Expose()
  @ApiProperty({ type: 'object' })
  @Type(() => MatchReasonsDto)
  matchReasons: MatchReasonsDto;

  @Expose()
  @ApiProperty({ required: false })
  proposedDatetime?: Date;

  @Expose()
  @ApiProperty()
  expiresAt: Date;

  @Expose()
  @ApiProperty({ required: false })
  bookingId?: string;

  @Expose()
  @ApiProperty()
  createdAt: Date;

  @Expose()
  @ApiProperty({ type: 'object', required: false })
  @Type(() => ProposalMasterDto)
  master?: ProposalMasterDto;

  @Expose()
  @ApiProperty({ type: 'object', required: false })
  @Type(() => ProposalServiceDto)
  service?: ProposalServiceDto;
}
