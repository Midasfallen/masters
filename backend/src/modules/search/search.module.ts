import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SearchService } from './search.service';
import { SearchController } from './search.controller';
import { User } from '../users/entities/user.entity';
import { MasterProfile } from '../masters/entities/master-profile.entity';
import { Service } from '../services/entities/service.entity';

@Module({
  imports: [TypeOrmModule.forFeature([User, MasterProfile, Service])],
  controllers: [SearchController],
  providers: [SearchService],
  exports: [SearchService],
})
export class SearchModule {}
