import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  Index,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';

@Entity('category_translations')
@Index(['category_id'])
@Index(['language'])
@Index(['category_id', 'language'], { unique: true })
export class CategoryTranslation {
  @ApiProperty()
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID категории' })
  @Column({ type: 'uuid' })
  @Index()
  category_id: string;

  @ApiProperty({ description: 'Код языка', example: 'ru' })
  @Column({ type: 'varchar', length: 5 })
  @Index()
  language: string;

  @ApiProperty({ description: 'Название категории', example: 'Красота' })
  @Column({ type: 'varchar', length: 255 })
  name: string;

  @ApiProperty({ description: 'Описание категории' })
  @Column({ type: 'text', nullable: true })
  description: string;

  @ApiProperty({ description: 'Ключевые слова (SEO)', type: [String] })
  @Column({ type: 'text', array: true, default: '{}' })
  keywords: string[];

  // Relations will be added later:
  // @ManyToOne(() => Category, category => category.translations)
  // @JoinColumn({ name: 'category_id' })
  // category: Category;
}
