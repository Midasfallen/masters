import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  OneToOne,
  JoinColumn,
  OneToMany,
  Point,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { User } from '../../users/entities/user.entity';
import { Service } from '../../services/entities/service.entity';

@Entity('master_profiles')
@Index(['user_id'], { unique: true })
@Index(['is_active'])
@Index(['rating'])
@Index(['category_ids'], { spatial: false })
export class MasterProfile {
  @ApiProperty()
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'Ссылка на пользователя' })
  @Column({ type: 'uuid' })
  user_id: string;

  @ApiProperty({ example: 'Салон красоты "Элита"', required: false })
  @Column({ type: 'varchar', length: 255, nullable: true })
  business_name: string;

  @ApiProperty({ example: 'Опытный парикмахер с 10-летним стажем' })
  @Column({ type: 'text', nullable: true })
  bio: string;

  @ApiProperty({ description: 'UUID категорий', type: [String], example: ['uuid1', 'uuid2'] })
  @Column({ type: 'uuid', array: true, default: '{}' })
  category_ids: string[];

  @ApiProperty({ description: 'Подкатегории', type: [String], example: ['uuid3', 'uuid4'] })
  @Column({ type: 'uuid', array: true, default: '{}' })
  subcategory_ids: string[];

  @ApiProperty({ example: 4.85 })
  @Column({ type: 'decimal', precision: 3, scale: 2, default: 0 })
  rating: number;

  @ApiProperty({ example: 127 })
  @Column({ type: 'integer', default: 0 })
  reviews_count: number;

  @ApiProperty({ example: 245 })
  @Column({ type: 'integer', default: 0 })
  completed_bookings: number;

  @ApiProperty({ example: 5 })
  @Column({ type: 'integer', default: 0 })
  cancellations_count: number;

  @ApiProperty({ example: 750 })
  @Column({ type: 'integer', default: 0 })
  views_count: number;

  @ApiProperty({ description: 'Избранное у клиентов', example: 42 })
  @Column({ type: 'integer', default: 0 })
  favorites_count: number;

  @ApiProperty({ description: 'Подписчики на мастера', example: 128 })
  @Column({ type: 'integer', default: 0 })
  subscribers_count: number;

  @ApiProperty({ description: 'Широта', example: 55.7558 })
  @Column({ type: 'decimal', precision: 10, scale: 8, nullable: true })
  location_lat: number;

  @ApiProperty({ description: 'Долгота', example: 37.6173 })
  @Column({ type: 'decimal', precision: 11, scale: 8, nullable: true })
  location_lng: number;

  @ApiProperty({ description: 'Адрес', example: 'Москва, ул. Тверская, 1' })
  @Column({ type: 'varchar', length: 255, nullable: true })
  location_address: string;

  @ApiProperty({ description: 'Название локации', example: 'Центр Москвы' })
  @Column({ type: 'varchar', length: 100, nullable: true })
  location_name: string;

  @ApiProperty({ description: 'Радиус обслуживания (км)', example: 10 })
  @Column({ type: 'integer', nullable: true })
  service_radius_km: number;

  @ApiProperty({ description: 'Выезд к клиенту', default: false })
  @Column({ type: 'boolean', default: false })
  is_mobile: boolean;

  @ApiProperty({ description: 'Салон/студия', default: false })
  @Column({ type: 'boolean', default: false })
  has_location: boolean;

  @ApiProperty({ description: 'Только онлайн', default: false })
  @Column({ type: 'boolean', default: false })
  is_online_only: boolean;

  @ApiProperty({ description: 'URL портфолио', type: [String] })
  @Column({ type: 'text', array: true, default: '{}' })
  portfolio_urls: string[];

  @ApiProperty({ description: 'URL видео (15 сек)', type: [String] })
  @Column({ type: 'text', array: true, default: '{}' })
  video_urls: string[];

  @ApiProperty({ description: 'Соцсети', type: 'object', example: { instagram: '@username' } })
  @Column({ type: 'jsonb', nullable: true })
  social_links: Record<string, string>;

  @ApiProperty({ description: 'Время работы', type: 'object' })
  @Column({ type: 'jsonb', nullable: true })
  working_hours: Record<string, any>;

  @ApiProperty({ description: 'Минимальное время записи (часов)', example: 2 })
  @Column({ type: 'integer', default: 2 })
  min_booking_hours: number;

  @ApiProperty({ description: 'Максимум записей в день', example: 10 })
  @Column({ type: 'integer', nullable: true })
  max_bookings_per_day: number;

  @ApiProperty({ description: 'Автоподтверждение записей', default: false })
  @Column({ type: 'boolean', default: false })
  auto_confirm: boolean;

  @ApiProperty({ description: 'Год начала карьеры', example: 2015 })
  @Column({ type: 'integer', nullable: true })
  years_of_experience: number;

  @ApiProperty({ description: 'Сертификаты/образование', type: [String] })
  @Column({ type: 'text', array: true, default: '{}' })
  certificates: string[];

  @ApiProperty({ description: 'Языки', type: [String], example: ['ru', 'en'] })
  @Column({ type: 'varchar', length: 5, array: true, default: '{ru}' })
  languages: string[];

  @ApiProperty({ description: 'Профиль активен', default: true })
  @Column({ type: 'boolean', default: true })
  is_active: boolean;

  @ApiProperty({ description: 'Профиль подтвержден администрацией', default: false })
  @Column({ type: 'boolean', default: false })
  is_approved: boolean;

  @ApiProperty({ description: 'Шаг создания профиля (1-5)', example: 5 })
  @Column({ type: 'integer', default: 0 })
  setup_step: number;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  @ApiProperty()
  @UpdateDateColumn()
  updated_at: Date;

  // Relations
  @OneToOne(() => User)
  @JoinColumn({ name: 'user_id' })
  user: User;

  @OneToMany(() => Service, (service) => service.master_id)
  services: Service[];
}
