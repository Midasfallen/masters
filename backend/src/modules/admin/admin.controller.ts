import {
  Controller,
  Get,
  Post,
  Delete,
  Param,
  Body,
  Query,
  UseGuards,
  ParseIntPipe,
  HttpCode,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { AdminGuard } from './guards/admin.guard';
import { AdminService } from './admin.service';
import {
  AdminStatsDto,
  UserManagementDto,
  BookingStatsDto,
  UpdateUserStatusDto,
  SystemHealthDto,
} from './dto/admin-stats.dto';

@ApiTags('Admin')
@Controller('admin')
@UseGuards(JwtAuthGuard, AdminGuard)
export class AdminController {
  constructor(private readonly adminService: AdminService) {}

  @Get('stats')
  @ApiOperation({ summary: 'Get platform statistics' })
  @ApiResponse({ status: 200, type: AdminStatsDto })
  async getStats(): Promise<AdminStatsDto> {
    return this.adminService.getStats();
  }

  @Get('users')
  @ApiOperation({ summary: 'Get all users for management' })
  async getUsers(
    @Query('page', ParseIntPipe) page: number = 1,
    @Query('limit', ParseIntPipe) limit: number = 50,
  ): Promise<{ users: UserManagementDto[]; total: number }> {
    return this.adminService.getUsers(page, limit);
  }

  @Get('bookings/recent')
  @ApiOperation({ summary: 'Get recent bookings' })
  async getRecentBookings(
    @Query('limit', ParseIntPipe) limit: number = 50,
  ): Promise<BookingStatsDto[]> {
    return this.adminService.getRecentBookings(limit);
  }

  @Post('users/:id/status')
  @HttpCode(200) // Return 200 OK instead of 201 Created
  @ApiOperation({ summary: 'Update user status' })
  async updateUserStatus(
    @Param('id') userId: string,
    @Body() dto: UpdateUserStatusDto,
  ) {
    return this.adminService.updateUserStatus(userId, dto);
  }

  @Delete('users/:id')
  @ApiOperation({ summary: 'Delete user' })
  async deleteUser(@Param('id') userId: string): Promise<void> {
    return this.adminService.deleteUser(userId);
  }

  @Get('health')
  @ApiOperation({ summary: 'Get system health' })
  async getSystemHealth(): Promise<SystemHealthDto> {
    return this.adminService.getSystemHealth();
  }

  @Get('analytics')
  @ApiOperation({ summary: 'Get platform analytics' })
  async getAnalytics(
    @Query('days', ParseIntPipe) days: number = 30,
  ): Promise<any> {
    return this.adminService.getAnalytics(days);
  }
}
