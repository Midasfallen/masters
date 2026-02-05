import { Module } from '@nestjs/common';
import { AdminController } from './admin.controller';
import { SearchModule } from '../search/search.module';

@Module({
  imports: [SearchModule],
  controllers: [AdminController],
  providers: [],
})
export class AdminModule {}
