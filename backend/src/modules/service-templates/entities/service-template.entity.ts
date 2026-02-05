import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  ManyToOne,
  JoinColumn,
  OneToMany,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { Category } from '../../categories/entities/category.entity';
import { ServiceTemplateTranslation } from './service-template-translation.entity';

@Entity('service_templates')
@Index(['category_id'])
@Index(['is_active'])
@Index(['slug'], { unique: true })
export class ServiceTemplate {
  @ApiProperty()
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID категории level 1' })
  @Column({ type: 'uuid' })
  category_id: string;

  @ApiProperty({ description: 'SEO-friendly slug', example: 'krasota-i-uhod-parikmaherskie-uslugi-muzhskaya-strizhka' })
  @Column({ type: 'varchar', length: 255, unique: true })
  slug: string;

  @ApiProperty({ example: 'Мужская стрижка' })
  @Column({ type: 'varchar', length: 255 })
  name: string;

  @ApiProperty({ description: 'Описание шаблона услуги', required: false })
  @Column({ type: 'text', nullable: true })
  description: string;

  @ApiProperty({ description: 'URL иконки шаблона', required: false })
  @Column({ type: 'text', nullable: true })
  icon_url: string;

  @ApiProperty({ description: 'Длительность по умолчанию (минуты)', required: false })
  @Column({ type: 'integer', nullable: true })
  default_duration_minutes: number;

  @ApiProperty({ description: 'Минимальная цена по умолчанию', required: false })
  @Column({ type: 'decimal', precision: 10, scale: 2, nullable: true })
  default_price_range_min: number;

  @ApiProperty({ description: 'Максимальная цена по умолчанию', required: false })
  @Column({ type: 'decimal', precision: 10, scale: 2, nullable: true })
  default_price_range_max: number;

  @ApiProperty({ description: 'Шаблон активен', default: true })
  @Column({ type: 'boolean', default: true })
  is_active: boolean;

  @ApiProperty({ description: 'Порядок отображения', example: 1 })
  @Column({ type: 'integer', default: 0 })
  display_order: number;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  @ApiProperty()
  @UpdateDateColumn()
  updated_at: Date;

  // Relations
  @ManyToOne(() => Category, { onDelete: 'CASCADE' })
  @JoinColumn({ name: 'category_id' })
  category: Category;

  @OneToMany(() => ServiceTemplateTranslation, (translation) => translation.service_template, {
    cascade: true,
  })
  translations: ServiceTemplateTranslation[];
}
