import { Controller, Get } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { InjectDataSource } from '@nestjs/typeorm';
import { DataSource } from 'typeorm';
import { ConfigService } from '@nestjs/config';
import { CacheService } from '../services/cache.service';
import { EmailService } from '../services/email.service';
import { SearchService } from '../../modules/search/search.service';
import { Public } from '../../modules/auth/decorators/public.decorator';

export interface HealthCheckResponse {
  status: 'healthy' | 'degraded' | 'unhealthy';
  timestamp: string;
  uptime: number;
  version: string;
  services: {
    database: ServiceStatus;
    redis: ServiceStatus;
    meilisearch: ServiceStatus;
    minio: ServiceStatus;
    smtp: ServiceStatus;
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
    private readonly emailService: EmailService,
    private readonly searchService: SearchService,
    private readonly configService: ConfigService,
  ) {}

  @Public()
  @Get()
  @ApiOperation({ summary: 'Health check endpoint' })
  @ApiResponse({
    status: 200,
    description: 'Service health status',
    schema: {
      example: {
        status: 'healthy',
        timestamp: '2026-01-21T12:00:00.000Z',
        uptime: 3600,
        version: '2.0.0',
        services: {
          database: { status: 'up', responseTime: 5 },
          redis: { status: 'up', responseTime: 2 },
          meilisearch: { status: 'up', responseTime: 10 },
          minio: { status: 'up', responseTime: 15 },
          smtp: { status: 'up', responseTime: 8 },
          memory: {
            status: 'ok',
            usage: {
              heapUsed: 120,
              heapTotal: 256,
              rss: 300,
              external: 20,
            },
            percentage: 46,
          },
        },
      },
    },
  })
  async check(): Promise<HealthCheckResponse> {
    const [
      databaseStatus,
      redisStatus,
      meilisearchStatus,
      minioStatus,
      smtpStatus,
      memoryStatus,
    ] = await Promise.all([
      this.checkDatabase(),
      this.checkRedis(),
      this.checkMeilisearch(),
      this.checkMinIO(),
      this.checkSMTP(),
      this.checkMemory(),
    ]);

    // Determine overall status
    // Critical: database must be up
    // Degraded: database up but other services down
    // Healthy: all services up
    let overallStatus: 'healthy' | 'degraded' | 'unhealthy';

    if (databaseStatus.status === 'down') {
      overallStatus = 'unhealthy';
    } else if (
      redisStatus.status === 'down' ||
      meilisearchStatus.status === 'down' ||
      minioStatus.status === 'down' ||
      smtpStatus.status === 'down' ||
      memoryStatus.status === 'critical'
    ) {
      overallStatus = 'degraded';
    } else {
      overallStatus = 'healthy';
    }

    return {
      status: overallStatus,
      timestamp: new Date().toISOString(),
      uptime: Math.floor(process.uptime()),
      version: process.env.npm_package_version || '2.0.0',
      services: {
        database: databaseStatus,
        redis: redisStatus,
        meilisearch: meilisearchStatus,
        minio: minioStatus,
        smtp: smtpStatus,
        memory: memoryStatus,
      },
    };
  }

  @Public()
  @Get('liveness')
  @ApiOperation({ summary: 'Kubernetes liveness probe' })
  @ApiResponse({ status: 200, description: 'Service is alive' })
  async liveness(): Promise<{ status: string }> {
    // Simple check - is the process running?
    return { status: 'alive' };
  }

  @Public()
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

  private async checkMeilisearch(): Promise<ServiceStatus> {
    const startTime = Date.now();
    try {
      // Access the private meiliClient through type assertion
      const meiliClient = (this.searchService as any).meiliClient;
      if (!meiliClient) {
        return {
          status: 'down',
          error: 'Meilisearch client not initialized',
        };
      }
      await meiliClient.health();
      const responseTime = Date.now() - startTime;
      return { status: 'up', responseTime };
    } catch (error) {
      return {
        status: 'down',
        error: 'Meilisearch unavailable (fallback to PostgreSQL search)',
      };
    }
  }

  private async checkMinIO(): Promise<ServiceStatus> {
    const startTime = Date.now();
    try {
      const minioEndpoint = this.configService.get<string>('MINIO_ENDPOINT');
      const minioPort = this.configService.get<number>('MINIO_PORT');
      const minioUseSSL = this.configService.get<boolean>('MINIO_USE_SSL');

      const protocol = minioUseSSL ? 'https' : 'http';
      const url = `${protocol}://${minioEndpoint}:${minioPort}/minio/health/live`;

      const response = await fetch(url, { method: 'GET' });

      const responseTime = Date.now() - startTime;

      if (response.ok) {
        return { status: 'up', responseTime };
      } else {
        return {
          status: 'down',
          error: `MinIO health check failed: ${response.status}`,
        };
      }
    } catch (error) {
      return {
        status: 'down',
        error: error.message,
      };
    }
  }

  private async checkSMTP(): Promise<ServiceStatus> {
    const startTime = Date.now();
    try {
      const isConnected = await this.emailService.verifyConnection();
      const responseTime = Date.now() - startTime;

      if (isConnected) {
        return { status: 'up', responseTime };
      } else {
        return {
          status: 'down',
          error: 'SMTP connection verification failed',
        };
      }
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
