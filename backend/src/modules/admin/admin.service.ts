import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../users/entities/user.entity';
import { Booking } from '../bookings/entities/booking.entity';
import { Review } from '../reviews/entities/review.entity';
import { Post } from '../posts/entities/post.entity';
import { Service } from '../services/entities/service.entity';
import {
  AdminStatsDto,
  UserManagementDto,
  BookingStatsDto,
  UpdateUserStatusDto,
  SystemHealthDto,
} from './dto/admin-stats.dto';

@Injectable()
export class AdminService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(Booking)
    private readonly bookingRepository: Repository<Booking>,
    @InjectRepository(Review)
    private readonly reviewRepository: Repository<Review>,
    @InjectRepository(Post)
    private readonly postRepository: Repository<Post>,
    @InjectRepository(Service)
    private readonly serviceRepository: Repository<Service>,
  ) {}

  /**
   * Get platform statistics
   */
  async getStats(): Promise<AdminStatsDto> {
    const now = new Date();
    const todayStart = new Date(now.setHours(0, 0, 0, 0));
    const weekStart = new Date(now.setDate(now.getDate() - 7));
    const monthStart = new Date(now.setMonth(now.getMonth() - 1));

    const [
      totalUsers,
      totalMasters,
      totalBookings,
      totalReviews,
      totalPosts,
      totalServices,
      newUsersThisWeek,
      newUsersThisMonth,
      bookingsToday,
      bookingsThisWeek,
      bookingsThisMonth,
    ] = await Promise.all([
      this.userRepository.count(),
      this.userRepository.count({ where: { is_master: true } }),
      this.bookingRepository.count(),
      this.reviewRepository.count(),
      this.postRepository.count(),
      this.serviceRepository.count(),
      this.userRepository.count({
        where: { created_at: Repository.moreThanOrEqual(weekStart) as any },
      }),
      this.userRepository.count({
        where: { created_at: Repository.moreThanOrEqual(monthStart) as any },
      }),
      this.bookingRepository.count({
        where: { created_at: Repository.moreThanOrEqual(todayStart) as any },
      }),
      this.bookingRepository.count({
        where: { created_at: Repository.moreThanOrEqual(weekStart) as any },
      }),
      this.bookingRepository.count({
        where: { created_at: Repository.moreThanOrEqual(monthStart) as any },
      }),
    ]);

    // Calculate average rating
    const ratingResult = await this.userRepository
      .createQueryBuilder('user')
      .select('AVG(user.rating)', 'avgRating')
      .where('user.is_master = :isMaster', { isMaster: true })
      .getRawOne();

    // Calculate total revenue (completed bookings)
    const revenueResult = await this.bookingRepository
      .createQueryBuilder('booking')
      .select('SUM(booking.total_price)', 'totalRevenue')
      .where('booking.status = :status', { status: 'completed' })
      .getRawOne();

    // Active users today (have activity in last 24h)
    const activeUsersToday = await this.userRepository
      .createQueryBuilder('user')
      .where('user.last_login_at >= :todayStart', { todayStart })
      .getCount();

    return {
      totalUsers,
      totalMasters,
      totalBookings,
      totalRevenue: parseFloat(revenueResult?.totalRevenue || '0'),
      activeUsersToday,
      newUsersThisWeek,
      newUsersThisMonth,
      bookingsToday,
      bookingsThisWeek,
      bookingsThisMonth,
      averageRating: parseFloat(ratingResult?.avgRating || '0'),
      totalReviews,
      totalPosts,
      totalServices,
    };
  }

  /**
   * Get all users for management
   */
  async getUsers(
    page: number = 1,
    limit: number = 50,
  ): Promise<{ users: UserManagementDto[]; total: number }> {
    const [users, total] = await this.userRepository.findAndCount({
      skip: (page - 1) * limit,
      take: limit,
      order: { created_at: 'DESC' },
    });

    const userDtos = users.map((user) => ({
      id: user.id,
      email: user.email,
      firstName: user.first_name,
      lastName: user.last_name,
      isMaster: user.is_master,
      isAdmin: user.is_admin || false,
      isActive: user.is_active !== undefined ? user.is_active : true,
      rating: parseFloat(user.rating?.toString() || '0'),
      reviewsCount: user.reviews_count || 0,
      createdAt: user.created_at,
      lastLoginAt: user.last_login_at,
    }));

    return { users: userDtos, total };
  }

  /**
   * Get recent bookings
   */
  async getRecentBookings(limit: number = 50): Promise<BookingStatsDto[]> {
    const bookings = await this.bookingRepository
      .createQueryBuilder('booking')
      .leftJoinAndSelect('booking.client', 'client')
      .leftJoinAndSelect('booking.master_profile', 'master_profile')
      .leftJoinAndSelect('master_profile.user', 'master')
      .leftJoinAndSelect('booking.service', 'service')
      .orderBy('booking.created_at', 'DESC')
      .take(limit)
      .getMany();

    return bookings.map((booking) => ({
      id: booking.id,
      clientName: `${booking.client?.first_name} ${booking.client?.last_name}`,
      masterName: booking.master_profile?.user
        ? `${booking.master_profile.user.first_name} ${booking.master_profile.user.last_name}`
        : 'Unknown',
      serviceName: booking.service?.name || 'Unknown',
      status: booking.status,
      amount: parseFloat(booking.total_price?.toString() || '0'),
      scheduledFor: booking.scheduled_for,
      createdAt: booking.created_at,
    }));
  }

  /**
   * Update user status (activate/deactivate/make admin)
   */
  async updateUserStatus(
    userId: string,
    dto: UpdateUserStatusDto,
  ): Promise<User> {
    const user = await this.userRepository.findOne({ where: { id: userId } });

    if (!user) {
      throw new Error('User not found');
    }

    if (dto.isActive !== undefined) {
      user.is_active = dto.isActive;
    }

    if (dto.isAdmin !== undefined) {
      user.is_admin = dto.isAdmin;
    }

    return await this.userRepository.save(user);
  }

  /**
   * Get system health
   */
  async getSystemHealth(): Promise<SystemHealthDto> {
    const memoryUsage = process.memoryUsage();
    const uptime = process.uptime();

    // Check database connection
    let dbStatus: 'connected' | 'disconnected' = 'disconnected';
    try {
      await this.userRepository.query('SELECT 1');
      dbStatus = 'connected';
    } catch (error) {
      dbStatus = 'disconnected';
    }

    // Simplified health check
    const status: 'healthy' | 'degraded' | 'down' =
      dbStatus === 'connected' ? 'healthy' : 'down';

    return {
      status,
      database: dbStatus,
      redis: 'connected', // TODO: Implement actual Redis check
      meilisearch: 'connected', // TODO: Implement actual Meilisearch check
      uptime: Math.floor(uptime),
      memoryUsage: {
        heapUsed: Math.floor(memoryUsage.heapUsed / 1024 / 1024), // MB
        heapTotal: Math.floor(memoryUsage.heapTotal / 1024 / 1024), // MB
        external: Math.floor(memoryUsage.external / 1024 / 1024), // MB
      },
      cpuUsage: process.cpuUsage().user / 1000000, // Convert to seconds
    };
  }

  /**
   * Delete user (admin action)
   */
  async deleteUser(userId: string): Promise<void> {
    await this.userRepository.delete(userId);
  }

  /**
   * Get platform analytics
   */
  async getAnalytics(days: number = 30): Promise<any> {
    const startDate = new Date();
    startDate.setDate(startDate.getDate() - days);

    // Daily new users
    const dailyUsers = await this.userRepository
      .createQueryBuilder('user')
      .select('DATE(user.created_at)', 'date')
      .addSelect('COUNT(*)', 'count')
      .where('user.created_at >= :startDate', { startDate })
      .groupBy('DATE(user.created_at)')
      .orderBy('date', 'ASC')
      .getRawMany();

    // Daily bookings
    const dailyBookings = await this.bookingRepository
      .createQueryBuilder('booking')
      .select('DATE(booking.created_at)', 'date')
      .addSelect('COUNT(*)', 'count')
      .addSelect('SUM(booking.total_price)', 'revenue')
      .where('booking.created_at >= :startDate', { startDate })
      .groupBy('DATE(booking.created_at)')
      .orderBy('date', 'ASC')
      .getRawMany();

    return {
      dailyUsers,
      dailyBookings,
      period: `${days} days`,
    };
  }
}
