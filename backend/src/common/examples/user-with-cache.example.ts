import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../../modules/users/entities/user.entity';
import { CacheService } from '../services/cache.service';

/**
 * Example of using CacheService in UserService
 * This is a reference implementation showing caching best practices
 */
@Injectable()
export class UserServiceWithCache {
  private readonly USER_CACHE_TTL = 600; // 10 minutes
  private readonly USER_LIST_CACHE_TTL = 300; // 5 minutes

  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly cacheService: CacheService,
  ) {}

  /**
   * Get user by ID with caching
   */
  async findById(id: string): Promise<User> {
    const cacheKey = `user:${id}`;

    // Try to get from cache
    const cached = await this.cacheService.get<User>(cacheKey);
    if (cached) {
      return cached;
    }

    // Cache miss - fetch from database
    const user = await this.userRepository.findOne({ where: { id } });
    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    // Store in cache
    await this.cacheService.set(cacheKey, user, this.USER_CACHE_TTL);

    return user;
  }

  /**
   * Get user by ID using getOrSet pattern (recommended)
   */
  async findByIdOptimized(id: string): Promise<User> {
    const cacheKey = `user:${id}`;

    return this.cacheService.getOrSet(
      cacheKey,
      async () => {
        const user = await this.userRepository.findOne({ where: { id } });
        if (!user) {
          throw new NotFoundException(`User with ID ${id} not found`);
        }
        return user;
      },
      this.USER_CACHE_TTL,
    );
  }

  /**
   * Get user by email with caching
   */
  async findByEmail(email: string): Promise<User | null> {
    const cacheKey = `user:email:${email}`;

    return this.cacheService.getOrSet(
      cacheKey,
      async () => {
        return await this.userRepository.findOne({ where: { email } });
      },
      this.USER_CACHE_TTL,
    );
  }

  /**
   * Update user and invalidate cache
   */
  async update(id: string, updateData: Partial<User>): Promise<User> {
    const user = await this.userRepository.findOne({ where: { id } });
    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    // Update in database
    Object.assign(user, updateData);
    const updated = await this.userRepository.save(user);

    // Invalidate cache
    await this.cacheService.del(`user:${id}`);
    if (user.email) {
      await this.cacheService.del(`user:email:${user.email}`);
    }

    return updated;
  }

  /**
   * Delete user and invalidate cache
   */
  async delete(id: string): Promise<void> {
    const user = await this.userRepository.findOne({ where: { id } });
    if (!user) {
      throw new NotFoundException(`User with ID ${id} not found`);
    }

    await this.userRepository.remove(user);

    // Invalidate cache
    await this.cacheService.del(`user:${id}`);
    if (user.email) {
      await this.cacheService.del(`user:email:${user.email}`);
    }
  }

  /**
   * Get all masters with caching
   */
  async getAllMasters(page: number = 1, limit: number = 20): Promise<User[]> {
    const cacheKey = `masters:page:${page}:limit:${limit}`;

    return this.cacheService.getOrSet(
      cacheKey,
      async () => {
        return await this.userRepository.find({
          where: { is_master: true },
          skip: (page - 1) * limit,
          take: limit,
          order: { created_at: 'DESC' },
        });
      },
      this.USER_LIST_CACHE_TTL,
    );
  }

  /**
   * Get user statistics with caching (expensive query)
   */
  async getUserStats(userId: string): Promise<{
    totalBookings: number;
    totalReviews: number;
    averageRating: number;
  }> {
    const cacheKey = `user:${userId}:stats`;

    return this.cacheService.getOrSet(
      cacheKey,
      async () => {
        // Expensive database queries
        const totalBookings = await this.userRepository
          .createQueryBuilder('user')
          .leftJoin('bookings', 'b', 'b.client_id = user.id OR b.master_id = user.id')
          .where('user.id = :userId', { userId })
          .getCount();

        const reviewsResult = await this.userRepository
          .createQueryBuilder('user')
          .leftJoin('reviews', 'r', 'r.reviewed_user_id = user.id')
          .select('COUNT(r.id)', 'totalReviews')
          .addSelect('AVG(r.rating)', 'averageRating')
          .where('user.id = :userId', { userId })
          .getRawOne();

        return {
          totalBookings,
          totalReviews: parseInt(reviewsResult?.totalReviews || '0'),
          averageRating: parseFloat(reviewsResult?.averageRating || '0'),
        };
      },
      this.USER_CACHE_TTL * 2, // Cache for 20 minutes (expensive query)
    );
  }

  /**
   * Invalidate all user-related caches
   * Use this when user data changes significantly
   */
  async invalidateUserCache(userId: string): Promise<void> {
    await this.cacheService.delByPattern(`user:${userId}*`);
  }

  /**
   * Invalidate all masters list caches
   * Use this when new master is added or master status changes
   */
  async invalidateMastersListCache(): Promise<void> {
    await this.cacheService.delByPattern('masters:page:*');
  }
}
