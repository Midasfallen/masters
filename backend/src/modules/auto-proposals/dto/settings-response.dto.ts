import { ApiProperty } from '@nestjs/swagger';
import { Expose } from 'class-transformer';

export class SettingsResponseDto {
  @Expose()
  @ApiProperty()
  id: string;

  @Expose()
  @ApiProperty()
  userId: string;

  @Expose()
  @ApiProperty()
  isEnabled: boolean;

  @Expose()
  @ApiProperty()
  intervalDays: number;

  @Expose()
  @ApiProperty({ type: [String] })
  preferredCategories: string[];

  @Expose()
  @ApiProperty({ required: false })
  maxPrice: number | null;

  @Expose()
  @ApiProperty()
  maxDistanceKm: number;

  @Expose()
  @ApiProperty()
  minRating: number;

  @Expose()
  @ApiProperty({ type: 'array', required: false })
  preferredTimeSlots: Array<{
    dayOfWeek: number;
    startHour: number;
    endHour: number;
  }> | null;

  @Expose()
  @ApiProperty({ required: false })
  lastProposalAt: Date | null;

  @Expose()
  @ApiProperty({ required: false })
  nextProposalAt: Date | null;

  @Expose()
  @ApiProperty()
  createdAt: Date;

  @Expose()
  @ApiProperty()
  updatedAt: Date;
}
