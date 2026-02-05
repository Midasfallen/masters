import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  ManyToOne,
  JoinColumn,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';

@Entity('services')
@Index(['master_id'])
@Index(['category_id'])
@Index(['is_active'])
@Index(['price'])
@Index(['service_template_id'])
export class Service {
  @ApiProperty()
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID мастера' })
  @Column({ type: 'uuid' })
  master_id: string;

  @ApiProperty({ description: 'ID категории' })
  @Column({ type: 'uuid' })
  category_id: string;

  @ApiProperty({ description: 'ID подкатегории', required: false })
  @Column({ type: 'uuid', nullable: true })
  subcategory_id: string;

  @ApiProperty({ description: 'ID шаблона услуги', required: false })
  @Column({ type: 'uuid', nullable: true })
  service_template_id: string;

  @ApiProperty({ example: 'Мужская стрижка' })
  @Column({ type: 'varchar', length: 255 })
  name: string;

  @ApiProperty({ example: 'Классическая мужская стрижка с укладкой' })
  @Column({ type: 'text', nullable: true })
  description: string;

  @ApiProperty({ example: 1500 })
  @Column({ type: 'decimal', precision: 10, scale: 2 })
  price: number;

  @ApiProperty({ description: 'Валюта', example: 'RUB', default: 'RUB' })
  @Column({ type: 'varchar', length: 3, default: 'RUB' })
  currency: string;

  @ApiProperty({ description: 'Диапазон цен (от)', example: 1200, required: false })
  @Column({ type: 'decimal', precision: 10, scale: 2, nullable: true })
  price_from: number;

  @ApiProperty({ description: 'Диапазон цен (до)', example: 2000, required: false })
  @Column({ type: 'decimal', precision: 10, scale: 2, nullable: true })
  price_to: number;

  @ApiProperty({ description: 'Длительность в минутах', example: 60 })
  @Column({ type: 'integer' })
  duration_minutes: number;

  @ApiProperty({ description: 'Можно забронировать онлайн', default: true })
  @Column({ type: 'boolean', default: true })
  is_bookable_online: boolean;

  @ApiProperty({ description: 'Выезд к клиенту', default: false })
  @Column({ type: 'boolean', default: false })
  is_mobile: boolean;

  @ApiProperty({ description: 'В салоне', default: true })
  @Column({ type: 'boolean', default: true })
  is_in_salon: boolean;

  @ApiProperty({ description: 'Теги/ключевые слова', type: [String], example: ['стрижка', 'мужская'] })
  @Column({ type: 'varchar', length: 50, array: true, default: '{}' })
  tags: string[];

  @ApiProperty({ description: 'URL фото результата работы', type: [String] })
  @Column({ type: 'text', array: true, default: '{}' })
  photo_urls: string[];

  @ApiProperty({ description: 'Количество записей по этой услуге', example: 42 })
  @Column({ type: 'integer', default: 0 })
  bookings_count: number;

  @ApiProperty({ description: 'Средний рейтинг услуги', example: 4.75 })
  @Column({ type: 'decimal', precision: 3, scale: 2, default: 0 })
  average_rating: number;

  @ApiProperty({ description: 'Услуга активна', default: true })
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

  // Relations will be added later:
  // @ManyToOne(() => MasterProfile, master => master.services)
  // @JoinColumn({ name: 'master_id' })
  // master: MasterProfile;
  //
  // @ManyToOne(() => Category)
  // @JoinColumn({ name: 'category_id' })
  // category: Category;
}
