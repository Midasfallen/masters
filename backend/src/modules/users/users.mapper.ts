import { User } from './entities/user.entity';
import { UserResponseDto } from './dto/user-response.dto';

/**
 * Mapper для преобразования User Entity → UserResponseDto
 */
export class UsersMapper {
  /**
   * Преобразует User entity в UserResponseDto
   */
  static toDto(user: User): UserResponseDto {
    return {
      id: user.id,
      email: user.email,
      phone: user.phone,
      firstName: user.first_name,
      lastName: user.last_name,
      fullName: `${user.first_name} ${user.last_name}`,
      avatarUrl: user.avatar_url,
      isMaster: user.is_master,
      masterProfileCompleted: user.master_profile_completed,
      isVerified: user.is_verified,
      isPremium: user.is_premium,
      premiumUntil: user.premium_until,
      isActive: user.is_active,
      lastLoginAt: user.last_login_at,
      rating: user.rating,
      reviewsCount: user.reviews_count,
      cancellationsCount: user.cancellations_count,
      noShowsCount: user.no_shows_count,
      blacklistsCount: user.blacklists_count,
      postsCount: user.posts_count,
      friendsCount: user.friends_count,
      followersCount: user.followers_count,
      followingCount: user.following_count,
      language: user.language,
      timezone: user.timezone,
      lastLocationLat: user.last_location_lat,
      lastLocationLng: user.last_location_lng,
      createdAt: user.created_at,
      updatedAt: user.updated_at,
    };
  }

  /**
   * Преобразует массив User entities в массив UserResponseDto
   */
  static toDtoArray(users: User[]): UserResponseDto[] {
    return users.map(user => this.toDto(user));
  }
}
