import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  Index,
  ManyToOne,
  JoinColumn,
  Unique,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { ServiceTemplate } from './service-template.entity';

@Entity('service_template_translations')
@Unique(['service_template_id', 'language'])
@Index(['service_template_id'])
@Index(['language'])
export class ServiceTemplateTranslation {
  @ApiProperty()
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID шаблона услуги' })
  @Column({ type: 'uuid' })
  service_template_id: string;

  @ApiProperty({ description: 'Язык перевода', example: 'ru' })
  @Column({ type: 'varchar', length: 10 })
  language: string;

  @ApiProperty({ example: 'Мужская стрижка' })
  @Column({ type: 'varchar', length: 255 })
  name: string;

  @ApiProperty({ description: 'Описание на языке перевода', required: false })
  @Column({ type: 'text', nullable: true })
  description: string;

  @ApiProperty({ description: 'Ключевые слова для поиска', type: [String], required: false })
  @Column({ type: 'varchar', length: 50, array: true, default: '{}' })
  keywords: string[];

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  // Relations
  @ManyToOne(() => ServiceTemplate, (template) => template.translations, {
    onDelete: 'CASCADE',
  })
  @JoinColumn({ name: 'service_template_id' })
  service_template: ServiceTemplate;
}
