import { Module } from '@nestjs/common';
import { CacheService } from './services/cache.service';
import { EmailService } from './services/email.service';
import { HealthController } from './controllers/health.controller';
import { SearchModule } from '../modules/search/search.module';

@Module({
  imports: [SearchModule],
  controllers: [HealthController],
  providers: [CacheService, EmailService],
  exports: [CacheService, EmailService],
})
export class CommonModule {}
