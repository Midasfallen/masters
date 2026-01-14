import { IsBoolean, IsOptional, IsString } from 'class-validator';
import { ApiPropertyOptional, ApiProperty } from '@nestjs/swagger';

export class AdminStatsDto {
  totalUsers: number;
  totalMasters: number;
  totalBookings: number;
  totalRevenue: number;
  activeUsersToday: number;
  newUsersThisWeek: number;
  newUsersThisMonth: number;
  bookingsToday: number;
  bookingsThisWeek: number;
  bookingsThisMonth: number;
  averageRating: number;
  totalReviews: number;
  totalPosts: number;
  totalServices: number;
}

export class UserManagementDto {
  id: string;
  email: string;
  firstName: string;
  lastName: string;
  isMaster: boolean;
  isAdmin: boolean;
  isActive: boolean;
  rating: number;
  reviewsCount: number;
  createdAt: Date;
  lastLoginAt?: Date;
}

export class BookingStatsDto {
  id: string;
  clientName: string;
  masterName: string;
  serviceName: string;
  status: string;
  amount: number;
  scheduledFor: Date;
  createdAt: Date;
}

export class UpdateUserStatusDto {
  @ApiPropertyOptional({ description: 'Active status', example: true })
  @IsOptional()
  @IsBoolean()
  isActive?: boolean;

  @ApiPropertyOptional({ description: 'Admin status', example: false })
  @IsOptional()
  @IsBoolean()
  isAdmin?: boolean;

  @ApiProperty({ description: 'Reason for status change', example: 'Suspicious activity detected' })
  @IsString()
  reason: string;
}

export class SystemHealthDto {
  status: 'healthy' | 'degraded' | 'down';
  database: 'connected' | 'disconnected';
  redis: 'connected' | 'disconnected';
  meilisearch: 'connected' | 'disconnected';
  uptime: number;
  memoryUsage: {
    heapUsed: number;
    heapTotal: number;
    external: number;
  };
  cpuUsage: number;
}
