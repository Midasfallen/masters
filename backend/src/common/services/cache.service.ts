import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import Redis from 'ioredis';

/**
 * Redis-based caching service for performance optimization
 *
 * Usage:
 * - User profiles caching
 * - Master profiles caching
 * - Feed posts caching
 * - Search results caching
 * - Session data caching
 */
@Injectable()
export class CacheService {
  private readonly logger = new Logger(CacheService.name);
  private readonly redis: Redis;
  private readonly defaultTTL = 300; // 5 minutes

  constructor(private readonly configService: ConfigService) {
    this.redis = new Redis({
      host: this.configService.get<string>('REDIS_HOST', 'localhost'),
      port: this.configService.get<number>('REDIS_PORT', 6379),
      password: this.configService.get<string>('REDIS_PASSWORD'),
      retryStrategy: (times) => {
        const delay = Math.min(times * 50, 2000);
        return delay;
      },
    });

    this.redis.on('connect', () => {
      this.logger.log('Redis connected successfully');
    });

    this.redis.on('error', (error) => {
      this.logger.error('Redis connection error:', error);
    });
  }

  /**
   * Get value from cache
   * @param key Cache key
   * @returns Parsed value or null if not found
   */
  async get<T>(key: string): Promise<T | null> {
    try {
      const value = await this.redis.get(key);
      if (!value) {
        return null;
      }
      return JSON.parse(value) as T;
    } catch (error) {
      this.logger.error(`Cache get error for key ${key}:`, error);
      return null;
    }
  }

  /**
   * Set value in cache with TTL
   * @param key Cache key
   * @param value Value to cache (will be JSON stringified)
   * @param ttl Time to live in seconds (default: 5 minutes)
   */
  async set<T>(key: string, value: T, ttl: number = this.defaultTTL): Promise<void> {
    try {
      const serialized = JSON.stringify(value);
      await this.redis.set(key, serialized, 'EX', ttl);
    } catch (error) {
      this.logger.error(`Cache set error for key ${key}:`, error);
    }
  }

  /**
   * Delete value from cache
   * @param key Cache key
   */
  async del(key: string): Promise<void> {
    try {
      await this.redis.del(key);
    } catch (error) {
      this.logger.error(`Cache delete error for key ${key}:`, error);
    }
  }

  /**
   * Delete multiple keys by pattern
   * @param pattern Key pattern (e.g., 'user:*')
   */
  async delByPattern(pattern: string): Promise<void> {
    try {
      const keys = await this.redis.keys(pattern);
      if (keys.length > 0) {
        await this.redis.del(...keys);
        this.logger.log(`Deleted ${keys.length} keys matching pattern: ${pattern}`);
      }
    } catch (error) {
      this.logger.error(`Cache delete by pattern error for ${pattern}:`, error);
    }
  }

  /**
   * Check if key exists in cache
   * @param key Cache key
   */
  async exists(key: string): Promise<boolean> {
    try {
      const result = await this.redis.exists(key);
      return result === 1;
    } catch (error) {
      this.logger.error(`Cache exists check error for key ${key}:`, error);
      return false;
    }
  }

  /**
   * Get or set pattern: fetch from cache or execute function and cache result
   * @param key Cache key
   * @param fetcher Function to execute if cache miss
   * @param ttl Time to live in seconds
   */
  async getOrSet<T>(
    key: string,
    fetcher: () => Promise<T>,
    ttl: number = this.defaultTTL,
  ): Promise<T> {
    const cached = await this.get<T>(key);
    if (cached !== null) {
      this.logger.debug(`Cache hit for key: ${key}`);
      return cached;
    }

    this.logger.debug(`Cache miss for key: ${key}`);
    const value = await fetcher();
    await this.set(key, value, ttl);
    return value;
  }

  /**
   * Increment value in cache
   * @param key Cache key
   * @param increment Increment by (default: 1)
   */
  async incr(key: string, increment: number = 1): Promise<number> {
    try {
      return await this.redis.incrby(key, increment);
    } catch (error) {
      this.logger.error(`Cache incr error for key ${key}:`, error);
      return 0;
    }
  }

  /**
   * Set expiration time for existing key
   * @param key Cache key
   * @param ttl Time to live in seconds
   */
  async expire(key: string, ttl: number): Promise<void> {
    try {
      await this.redis.expire(key, ttl);
    } catch (error) {
      this.logger.error(`Cache expire error for key ${key}:`, error);
    }
  }

  /**
   * Get remaining TTL for key
   * @param key Cache key
   * @returns TTL in seconds or -1 if key doesn't exist, -2 if no TTL
   */
  async ttl(key: string): Promise<number> {
    try {
      return await this.redis.ttl(key);
    } catch (error) {
      this.logger.error(`Cache TTL error for key ${key}:`, error);
      return -1;
    }
  }

  /**
   * Store multiple values in a hash
   * @param key Hash key
   * @param data Object to store
   * @param ttl Time to live in seconds
   */
  async hset(key: string, data: Record<string, any>, ttl?: number): Promise<void> {
    try {
      const serialized: Record<string, string> = {};
      for (const [field, value] of Object.entries(data)) {
        serialized[field] = JSON.stringify(value);
      }
      await this.redis.hset(key, serialized);
      if (ttl) {
        await this.redis.expire(key, ttl);
      }
    } catch (error) {
      this.logger.error(`Cache hset error for key ${key}:`, error);
    }
  }

  /**
   * Get value from hash
   * @param key Hash key
   * @param field Field name
   */
  async hget<T>(key: string, field: string): Promise<T | null> {
    try {
      const value = await this.redis.hget(key, field);
      if (!value) {
        return null;
      }
      return JSON.parse(value) as T;
    } catch (error) {
      this.logger.error(`Cache hget error for key ${key}, field ${field}:`, error);
      return null;
    }
  }

  /**
   * Get all values from hash
   * @param key Hash key
   */
  async hgetall<T extends Record<string, any>>(key: string): Promise<T | null> {
    try {
      const data = await this.redis.hgetall(key);
      if (!data || Object.keys(data).length === 0) {
        return null;
      }
      const parsed: any = {};
      for (const [field, value] of Object.entries(data)) {
        parsed[field] = JSON.parse(value);
      }
      return parsed as T;
    } catch (error) {
      this.logger.error(`Cache hgetall error for key ${key}:`, error);
      return null;
    }
  }

  /**
   * Add item to list (right push)
   * @param key List key
   * @param value Value to add
   */
  async rpush<T>(key: string, value: T): Promise<void> {
    try {
      await this.redis.rpush(key, JSON.stringify(value));
    } catch (error) {
      this.logger.error(`Cache rpush error for key ${key}:`, error);
    }
  }

  /**
   * Get list items
   * @param key List key
   * @param start Start index
   * @param end End index (-1 for all)
   */
  async lrange<T>(key: string, start: number = 0, end: number = -1): Promise<T[]> {
    try {
      const values = await this.redis.lrange(key, start, end);
      return values.map((v) => JSON.parse(v) as T);
    } catch (error) {
      this.logger.error(`Cache lrange error for key ${key}:`, error);
      return [];
    }
  }

  /**
   * Trim list to specified range
   * @param key List key
   * @param start Start index
   * @param end End index
   */
  async ltrim(key: string, start: number, end: number): Promise<void> {
    try {
      await this.redis.ltrim(key, start, end);
    } catch (error) {
      this.logger.error(`Cache ltrim error for key ${key}:`, error);
    }
  }

  /**
   * Clear all cache (use with caution!)
   */
  async flushall(): Promise<void> {
    try {
      await this.redis.flushall();
      this.logger.warn('Cache flushed - all keys deleted');
    } catch (error) {
      this.logger.error('Cache flush error:', error);
    }
  }

  /**
   * Get cache statistics
   */
  async getStats(): Promise<{
    keys: number;
    memory: string;
    hits: number;
    misses: number;
    hitRate: string;
  }> {
    try {
      const info = await this.redis.info('stats');
      const memory = await this.redis.info('memory');
      const dbsize = await this.redis.dbsize();

      const hits = this.parseInfoValue(info, 'keyspace_hits');
      const misses = this.parseInfoValue(info, 'keyspace_misses');
      const total = hits + misses;
      const hitRate = total > 0 ? ((hits / total) * 100).toFixed(2) : '0.00';

      const usedMemory = this.parseInfoValue(memory, 'used_memory_human');

      return {
        keys: dbsize,
        memory: usedMemory || 'N/A',
        hits,
        misses,
        hitRate: `${hitRate}%`,
      };
    } catch (error) {
      this.logger.error('Cache stats error:', error);
      return {
        keys: 0,
        memory: 'N/A',
        hits: 0,
        misses: 0,
        hitRate: '0.00%',
      };
    }
  }

  private parseInfoValue(info: string, key: string): any {
    const match = info.match(new RegExp(`${key}:(.+)`));
    if (match && match[1]) {
      const value = match[1].trim();
      return isNaN(Number(value)) ? value : Number(value);
    }
    return 0;
  }

  /**
   * Close Redis connection
   */
  async onModuleDestroy() {
    await this.redis.quit();
    this.logger.log('Redis connection closed');
  }
}
