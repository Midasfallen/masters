import { Review } from './entities/review.entity';
import { User } from '../users/entities/user.entity';
import { Booking } from '../bookings/entities/booking.entity';
import {
  ReviewResponseDto,
  ReviewUserDto,
  ReviewBookingDto,
  ReviewStatsDto,
} from './dto/review-response.dto';

/**
 * Mapper для преобразования Review Entity → ReviewResponseDto
 */
export class ReviewsMapper {
  /**
   * Преобразует User entity в ReviewUserDto
   */
  static toUserDto(user: User): ReviewUserDto {
    return {
      id: user.id,
      firstName: user.first_name,
      lastName: user.last_name,
      avatarUrl: user.avatar_url,
    };
  }

  /**
   * Преобразует Booking entity в ReviewBookingDto
   */
  static toBookingDto(booking: Booking): ReviewBookingDto {
    return {
      id: booking.id,
      serviceId: booking.service_id,
      startTime: booking.start_time,
    };
  }

  /**
   * Преобразует Review entity в ReviewResponseDto
   */
  static toDto(review: Review & { reviewer?: User; reviewedUser?: User; booking?: Booking }): ReviewResponseDto {
    return {
      id: review.id,
      bookingId: review.booking_id,
      reviewerId: review.reviewer_id,
      reviewedUserId: review.reviewed_user_id,
      reviewerType: review.reviewer_type,
      rating: review.rating,
      comment: review.comment,
      photoUrls: review.photo_urls || [],
      response: review.response,
      responseAt: review.response_at,
      isVisible: review.is_visible,
      reportsCount: review.reports_count,
      isApproved: review.is_approved,
      createdAt: review.created_at,
      updatedAt: review.updated_at,
      // Опциональные связи
      reviewer: review.reviewer ? this.toUserDto(review.reviewer) : undefined,
      reviewedUser: review.reviewedUser ? this.toUserDto(review.reviewedUser) : undefined,
      booking: review.booking ? this.toBookingDto(review.booking) : undefined,
    };
  }

  /**
   * Преобразует массив Review entities в массив ReviewResponseDto
   */
  static toDtoArray(reviews: Review[]): ReviewResponseDto[] {
    return reviews.map((review) => this.toDto(review));
  }

  /**
   * Преобразует статистику отзывов в ReviewStatsDto
   */
  static toStatsDto(stats: {
    total_reviews: number;
    average_rating: number;
    rating_distribution: Record<number, number>;
    reviews_with_comments: number;
    reviews_with_photos: number;
  }): ReviewStatsDto {
    return {
      totalReviews: stats.total_reviews,
      averageRating: stats.average_rating,
      ratingDistribution: stats.rating_distribution,
      reviewsWithComments: stats.reviews_with_comments,
      reviewsWithPhotos: stats.reviews_with_photos,
    };
  }
}
