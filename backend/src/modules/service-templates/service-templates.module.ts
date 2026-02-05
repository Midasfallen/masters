import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ServiceTemplatesController } from './service-templates.controller';
import { ServiceTemplatesService } from './service-templates.service';
import { ServiceTemplate } from './entities/service-template.entity';
import { ServiceTemplateTranslation } from './entities/service-template-translation.entity';
import { Category } from '../categories/entities/category.entity';

@Module({
  imports: [
    TypeOrmModule.forFeature([
      ServiceTemplate,
      ServiceTemplateTranslation,
      Category,
    ]),
  ],
  controllers: [ServiceTemplatesController],
  providers: [ServiceTemplatesService],
  exports: [ServiceTemplatesService],
})
export class ServiceTemplatesModule {}
