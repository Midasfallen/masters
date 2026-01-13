import { Injectable, CanActivate, ExecutionContext, HttpException, HttpStatus } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { CacheService } from '../services/cache.service';

/**
 * Rate limiting configuration
 */
export interface RateLimitConfig {
  /**
   * Maximum number of requests allowed
   */
  limit: number;

  /**
   * Time window in seconds
   */
  window: number;

  /**
   * Custom error message
   */
  message?: string;
}

/**
 * Decorator to set rate limit for specific endpoint
 *
 * @example
 * @RateLimit({ limit: 10, window: 60 }) // 10 requests per minute
 * @Post('login')
 * async login() { }
 */
export const RateLimit = (config: RateLimitConfig) =>
  Reflect.metadata('rateLimit', config);

/**
 * Rate Limiting Guard using Redis
 *
 * Prevents abuse by limiting the number of requests per IP address
 * Uses sliding window algorithm for accurate rate limiting
 */
@Injectable()
export class RateLimitGuard implements CanActivate {
  constructor(
    private readonly reflector: Reflector,
    private readonly cacheService: CacheService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const config = this.reflector.get<RateLimitConfig>(
      'rateLimit',
      context.getHandler(),
    );

    // If no rate limit configuration, allow request
    if (!config) {
      return true;
    }

    const request = context.switchToHttp().getRequest();
    const ip = this.getClientIp(request);
    const endpoint = `${request.method}:${request.route.path}`;
    const key = `rate_limit:${ip}:${endpoint}`;

    // Get current request count
    const currentCount = await this.cacheService.get<number>(key);

    if (currentCount === null) {
      // First request in the window
      await this.cacheService.set(key, 1, config.window);
      this.setRateLimitHeaders(request.res, config, 1);
      return true;
    }

    if (currentCount >= config.limit) {
      // Rate limit exceeded
      const ttl = await this.cacheService.ttl(key);
      throw new HttpException(
        {
          statusCode: HttpStatus.TOO_MANY_REQUESTS,
          message: config.message || 'Too many requests. Please try again later.',
          retryAfter: ttl > 0 ? ttl : config.window,
        },
        HttpStatus.TOO_MANY_REQUESTS,
      );
    }

    // Increment request count
    const newCount = await this.cacheService.incr(key);
    this.setRateLimitHeaders(request.res, config, newCount);

    return true;
  }

  /**
   * Get client IP address from request
   */
  private getClientIp(request: any): string {
    return (
      request.headers['x-forwarded-for']?.split(',')[0] ||
      request.headers['x-real-ip'] ||
      request.connection?.remoteAddress ||
      request.socket?.remoteAddress ||
      'unknown'
    );
  }

  /**
   * Set rate limit headers in response
   */
  private setRateLimitHeaders(
    response: any,
    config: RateLimitConfig,
    currentCount: number,
  ): void {
    response.setHeader('X-RateLimit-Limit', config.limit);
    response.setHeader('X-RateLimit-Remaining', Math.max(0, config.limit - currentCount));
    response.setHeader('X-RateLimit-Reset', Date.now() + config.window * 1000);
  }
}
