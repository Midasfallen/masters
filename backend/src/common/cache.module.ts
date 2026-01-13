import { Module, Global } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { CacheService } from './services/cache.service';

/**
 * Global cache module using Redis
 * Import this module in AppModule to make CacheService available everywhere
 */
@Global()
@Module({
  imports: [ConfigModule],
  providers: [CacheService],
  exports: [CacheService],
})
export class CacheModule {}
