import { ApiProperty } from '@nestjs/swagger';

/**
 * Ответ с информацией о профиле мастера
 */
export class MasterProfileResponseDto {
  @ApiProperty()
  id: string;

  @ApiProperty()
  user_id: string;

  @ApiProperty({ required: false })
  business_name: string;

  @ApiProperty()
  bio: string;

  @ApiProperty({ type: [String] })
  category_ids: string[];

  @ApiProperty({ type: [String] })
  subcategory_ids: string[];

  @ApiProperty({ example: 4.85 })
  rating: number;

  @ApiProperty()
  reviews_count: number;

  @ApiProperty()
  completed_bookings: number;

  @ApiProperty()
  views_count: number;

  @ApiProperty()
  favorites_count: number;

  @ApiProperty()
  subscribers_count: number;

  @ApiProperty({ required: false })
  location_lat: number;

  @ApiProperty({ required: false })
  location_lng: number;

  @ApiProperty({ required: false })
  location_address: string;

  @ApiProperty({ required: false })
  location_name: string;

  @ApiProperty({ required: false })
  service_radius_km: number;

  @ApiProperty()
  is_mobile: boolean;

  @ApiProperty()
  has_location: boolean;

  @ApiProperty()
  is_online_only: boolean;

  @ApiProperty({ type: [String] })
  portfolio_urls: string[];

  @ApiProperty({ type: [String] })
  video_urls: string[];

  @ApiProperty({ type: 'object' })
  social_links: Record<string, string>;

  @ApiProperty({ type: 'object' })
  working_hours: Record<string, any>;

  @ApiProperty()
  min_booking_hours: number;

  @ApiProperty({ required: false })
  max_bookings_per_day: number;

  @ApiProperty()
  auto_confirm: boolean;

  @ApiProperty({ required: false })
  years_of_experience: number;

  @ApiProperty({ type: [String] })
  certificates: string[];

  @ApiProperty({ type: [String] })
  languages: string[];

  @ApiProperty()
  is_active: boolean;

  @ApiProperty()
  is_approved: boolean;

  @ApiProperty({
    description: 'Текущий шаг создания профиля (0-5)',
    example: 5,
  })
  setup_step: number;

  @ApiProperty()
  created_at: Date;

  @ApiProperty()
  updated_at: Date;
}
