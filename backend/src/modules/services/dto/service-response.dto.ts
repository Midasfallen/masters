import { ApiProperty } from '@nestjs/swagger';

export class ServiceResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  master_id: string;

  @ApiProperty()
  category_id: string;

  @ApiProperty({ required: false })
  subcategory_id: string;

  @ApiProperty({ example: 'Мужская стрижка' })
  name: string;

  @ApiProperty({ required: false })
  description: string;

  @ApiProperty({ example: 1500 })
  price: number;

  @ApiProperty({ example: 'RUB', default: 'RUB' })
  currency: string;

  @ApiProperty({ required: false })
  price_from: number;

  @ApiProperty({ required: false })
  price_to: number;

  @ApiProperty({ example: 60 })
  duration_minutes: number;

  @ApiProperty({ default: true })
  is_bookable_online: boolean;

  @ApiProperty({ default: false })
  is_mobile: boolean;

  @ApiProperty({ default: true })
  is_in_salon: boolean;

  @ApiProperty({ type: [String] })
  tags: string[];

  @ApiProperty({ type: [String] })
  photo_urls: string[];

  @ApiProperty({ example: 42 })
  bookings_count: number;

  @ApiProperty({ example: 4.75 })
  average_rating: number;

  @ApiProperty({ default: true })
  is_active: boolean;

  @ApiProperty({ example: 1 })
  display_order: number;

  @ApiProperty()
  created_at: Date;

  @ApiProperty()
  updated_at: Date;
}
