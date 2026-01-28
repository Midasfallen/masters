import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  TreeParent,
  TreeChildren,
  Tree,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';

@Entity('categories')
@Tree('closure-table')
@Index(['parent_id'])
@Index(['slug'], { unique: true })
@Index(['is_active'])
export class Category {
  @ApiProperty()
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'Родительская категория (NULL для корневых)', required: false })
  @Column({ type: 'uuid', nullable: true })
  parent_id: string;

  @ApiProperty({ example: 'beauty' })
  @Column({ type: 'varchar', length: 100, unique: true })
  slug: string;

  @ApiProperty({ description: 'Уровень вложенности (0 = корневая)', example: 0 })
  @Column({ type: 'integer', default: 0 })
  level: number;

  @ApiProperty({ description: 'URL иконки категории' })
  @Column({ type: 'text', nullable: true })
  icon_url: string;

  @ApiProperty({ description: 'URL изображения категории' })
  @Column({ type: 'text', nullable: true })
  image_url: string;

  @ApiProperty({ description: 'Цвет категории (hex)', example: '#FF5722' })
  @Column({ type: 'varchar', length: 7, nullable: true })
  color: string;

  @ApiProperty({ description: 'Порядок отображения', example: 1 })
  @Column({ type: 'integer', default: 0 })
  display_order: number;

  @ApiProperty({ description: 'Количество мастеров в категории', example: 125 })
  @Column({ type: 'integer', default: 0 })
  masters_count: number;

  @ApiProperty({ description: 'Количество услуг в категории', example: 380 })
  @Column({ type: 'integer', default: 0 })
  services_count: number;

  @ApiProperty({ description: 'Категория активна', default: true })
  @Column({ type: 'boolean', default: true })
  is_active: boolean;

  @ApiProperty({ description: 'Популярная категория', default: false })
  @Column({ type: 'boolean', default: false })
  is_popular: boolean;

  @ApiProperty({ description: 'Метаданные (SEO, описания)', type: 'object', additionalProperties: true })
  @Column({ type: 'jsonb', nullable: true })
  metadata: Record<string, any>;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  @ApiProperty()
  @UpdateDateColumn()
  updated_at: Date;

  // Tree relations
  @TreeParent()
  parent: Category;

  @TreeChildren()
  children: Category[];

  // Relations will be added later:
  // @OneToMany(() => CategoryTranslation, translation => translation.category)
  // translations: CategoryTranslation[];
}
