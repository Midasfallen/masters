import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ServicesController } from './services.controller';
import { ServicesService } from './services.service';
import { Service } from './entities/service.entity';
import { User } from '../users/entities/user.entity';
import { MasterProfile } from '../masters/entities/master-profile.entity';
import { Category } from '../categories/entities/category.entity';
import { ServiceTemplate } from '../service-templates/entities/service-template.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      Service,
      User,
      MasterProfile,
      Category,
      ServiceTemplate,
    ]),
  ],
  controllers: [ServicesController],
  providers: [ServicesService],
  exports: [ServicesService],
})
export class ServicesModule {}
