import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { SearchService } from './search.service';
import { SearchController } from './search.controller';
import { User } from '../users/entities/user.entity';
import { MasterProfile } from '../masters/entities/master-profile.entity';
import { Service } from '../services/entities/service.entity';
import { ServiceTemplate } from '../service-templates/entities/service-template.entity';
import { ServiceTemplateTranslation } from '../service-templates/entities/service-template-translation.entity';
import { Category } from '../categories/entities/category.entity';
import { CategoryTranslation } from '../categories/entities/category-translation.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      User,
      MasterProfile,
      Service,
      ServiceTemplate,
      ServiceTemplateTranslation,
      Category,
      CategoryTranslation,
    ]),
  ],
  controllers: [SearchController],
  providers: [SearchService],
  exports: [SearchService],
})
export class SearchModule {}
