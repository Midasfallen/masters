import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { CacheService } from '../services/cache.service';

export interface HealthCheckResponse {
  status: 'healthy' | 'degraded' | 'unhealthy';
  timestamp: string;
  uptime: number;
  version: string;
  services: {
    database: ServiceStatus;
    redis: ServiceStatus;
    memory: MemoryStatus;
  };
}

interface ServiceStatus {
  status: 'up' | 'down';
  responseTime?: number;
  error?: string;
}

interface MemoryStatus {
  status: 'ok' | 'warning' | 'critical';
  usage: {
    heapUsed: number;
    heapTotal: number;
    rss: number;
    external: number;
  };
  percentage: number;
}

@ApiTags('Health')
@Controller('health')
export class HealthController {
  constructor(
    @InjectDataSource()
    private readonly dataSource: DataSource,
    private readonly cacheService: CacheService,
  ) {}

  @Get()
  @ApiOperation({ summary: 'Health check endpoint' })
  @ApiResponse({
    status: 200,
    description: 'Service is healthy',
    schema: {
      example: {
        status: 'healthy',
        timestamp: '2026-01-13T12:00:00.000Z',
        uptime: 3600,
        version: '1.0.0',
        services: {
          database: { status: 'up', responseTime: 5 },
          redis: { status: 'up', responseTime: 2 },
          memory: {
            status: 'ok',
            usage: {
              heapUsed: 50,
              heapTotal: 100,
              rss: 150,
              external: 10,
            },
            percentage: 50,
          },
        },
      },
    },
  })
  async check(): Promise<HealthCheckResponse> {
    const [databaseStatus, redisStatus, memoryStatus] = await Promise.all([
      this.checkDatabase(),
      this.checkRedis(),
      this.checkMemory(),
    ]);

    // Determine overall status
    const allServicesUp =
      databaseStatus.status === 'up' && redisStatus.status === 'up';
    const memoryOk = memoryStatus.status !== 'critical';

    let overallStatus: 'healthy' | 'degraded' | 'unhealthy';
    if (allServicesUp && memoryOk) {
      overallStatus = 'healthy';
    } else if (databaseStatus.status === 'up' && redisStatus.status === 'down') {
      overallStatus = 'degraded'; // Can work without Redis
    } else {
      overallStatus = 'unhealthy'; // Cannot work without database
    }

    return {
      status: overallStatus,
      timestamp: new Date().toISOString(),
      uptime: Math.floor(process.uptime()),
      version: process.env.npm_package_version || '1.0.0',
      services: {
        database: databaseStatus,
        redis: redisStatus,
        memory: memoryStatus,
      },
    };
  }

  @Get('liveness')
  @ApiOperation({ summary: 'Kubernetes liveness probe' })
  @ApiResponse({ status: 200, description: 'Service is alive' })
  async liveness(): Promise<{ status: string }> {
    // Simple check - is the process running?
    return { status: 'alive' };
  }

  @Get('readiness')
  @ApiOperation({ summary: 'Kubernetes readiness probe' })
  @ApiResponse({ status: 200, description: 'Service is ready to accept traffic' })
  @ApiResponse({ status: 503, description: 'Service is not ready' })
  async readiness(): Promise<{ status: string; ready: boolean }> {
    const databaseStatus = await this.checkDatabase();

    const ready = databaseStatus.status === 'up';

    if (!ready) {
      throw new Error('Service not ready');
    }

    return {
      status: 'ready',
      ready: true,
    };
  }

  private async checkDatabase(): Promise<ServiceStatus> {
    const startTime = Date.now();
    try {
      await this.dataSource.query('SELECT 1');
      const responseTime = Date.now() - startTime;
      return { status: 'up', responseTime };
    } catch (error) {
      return {
        status: 'down',
        error: error.message,
      };
    }
  }

  private async checkRedis(): Promise<ServiceStatus> {
    const startTime = Date.now();
    try {
      await this.cacheService.set('health_check', Date.now(), 10);
      const responseTime = Date.now() - startTime;
      return { status: 'up', responseTime };
    } catch (error) {
      return {
        status: 'down',
        error: error.message,
      };
    }
  }

  private async checkMemory(): Promise<MemoryStatus> {
    const memoryUsage = process.memoryUsage();
    const heapUsedMB = Math.round(memoryUsage.heapUsed / 1024 / 1024);
    const heapTotalMB = Math.round(memoryUsage.heapTotal / 1024 / 1024);
    const rssMB = Math.round(memoryUsage.rss / 1024 / 1024);
    const externalMB = Math.round(memoryUsage.external / 1024 / 1024);

    const percentage = Math.round((memoryUsage.heapUsed / memoryUsage.heapTotal) * 100);

    let status: 'ok' | 'warning' | 'critical';
    if (percentage < 70) {
      status = 'ok';
    } else if (percentage < 90) {
      status = 'warning';
    } else {
      status = 'critical';
    }

    return {
      status,
      usage: {
        heapUsed: heapUsedMB,
        heapTotal: heapTotalMB,
        rss: rssMB,
        external: externalMB,
      },
      percentage,
    };
  }
}
