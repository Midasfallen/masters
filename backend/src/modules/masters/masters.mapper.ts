import { MasterProfile } from './entities/master-profile.entity';
import { MasterProfileResponseDto } from './dto/master-profile-response.dto';

/**
 * Mapper для преобразования MasterProfile Entity → MasterProfileResponseDto
 */
export class MastersMapper {
  /**
   * Преобразует MasterProfile entity в MasterProfileResponseDto
   */
  static toDto(masterProfile: MasterProfile): MasterProfileResponseDto {
    return {
      id: masterProfile.id,
      userId: masterProfile.user_id,
      businessName: masterProfile.business_name,
      bio: masterProfile.bio,
      categoryIds: masterProfile.category_ids || [],
      subcategoryIds: masterProfile.subcategory_ids || [],
      rating: Number(masterProfile.rating),
      reviewsCount: masterProfile.reviews_count,
      completedBookings: masterProfile.completed_bookings,
      cancellationsCount: masterProfile.cancellations_count,
      viewsCount: masterProfile.views_count,
      favoritesCount: masterProfile.favorites_count,
      subscribersCount: masterProfile.subscribers_count,
      locationLat: masterProfile.location_lat ? Number(masterProfile.location_lat) : null,
      locationLng: masterProfile.location_lng ? Number(masterProfile.location_lng) : null,
      locationAddress: masterProfile.location_address,
      locationName: masterProfile.location_name,
      serviceRadiusKm: masterProfile.service_radius_km,
      isMobile: masterProfile.is_mobile,
      hasLocation: masterProfile.has_location,
      isOnlineOnly: masterProfile.is_online_only,
      portfolioUrls: masterProfile.portfolio_urls || [],
      videoUrls: masterProfile.video_urls || [],
      socialLinks: masterProfile.social_links,
      workingHours: masterProfile.working_hours,
      minBookingHours: masterProfile.min_booking_hours,
      maxBookingsPerDay: masterProfile.max_bookings_per_day,
      autoConfirm: masterProfile.auto_confirm,
      yearsOfExperience: masterProfile.years_of_experience,
      certificates: masterProfile.certificates || [],
      languages: masterProfile.languages || [],
      isActive: masterProfile.is_active,
      isApproved: masterProfile.is_approved,
      setupStep: masterProfile.setup_step,
      createdAt: masterProfile.created_at,
      updatedAt: masterProfile.updated_at,
    };
  }

  /**
   * Преобразует массив MasterProfile entities в массив MasterProfileResponseDto
   */
  static toDtoArray(masterProfiles: MasterProfile[]): MasterProfileResponseDto[] {
    return masterProfiles.map((profile) => this.toDto(profile));
  }
}
