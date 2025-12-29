import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
  OneToOne,
  OneToMany,
} from 'typeorm';
import { Exclude } from 'class-transformer';
import { ApiProperty, ApiHideProperty } from '@nestjs/swagger';

@Entity('users')
@Index(['email'], { unique: true })
@Index(['phone'], { unique: true })
@Index(['is_master'])
export class User {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ example: 'user@example.com' })
  @Column({ type: 'varchar', length: 255, unique: true })
  @Index()
  email: string;

  @ApiProperty({ example: '+79001234567' })
  @Column({ type: 'varchar', length: 20, unique: true, nullable: true })
  @Index()
  phone: string;

  @ApiHideProperty()
  @Column({ type: 'varchar', length: 255 })
  @Exclude()
  password_hash: string;

  @ApiProperty({ example: 'Иван' })
  @Column({ type: 'varchar', length: 100 })
  first_name: string;

  @ApiProperty({ example: 'Петров' })
  @Column({ type: 'varchar', length: 100 })
  last_name: string;

  @ApiProperty({ example: 'https://storage.example.com/avatars/user.jpg', required: false })
  @Column({ type: 'text', nullable: true })
  avatar_url: string;

  @ApiProperty({ description: 'Является ли пользователь мастером', default: false })
  @Column({ type: 'boolean', default: false })
  is_master: boolean;

  @ApiProperty({ description: 'Завершена ли настройка профиля мастера', default: false })
  @Column({ type: 'boolean', default: false })
  master_profile_completed: boolean;

  @ApiProperty({ description: 'KYC верификация пройдена', default: false })
  @Column({ type: 'boolean', default: false })
  is_verified: boolean;

  @ApiProperty({ description: 'Премиум подписка активна', default: false })
  @Column({ type: 'boolean', default: false })
  is_premium: boolean;

  @ApiProperty({ example: '2025-12-31T23:59:59Z', required: false })
  @Column({ type: 'timestamp', nullable: true })
  premium_until: Date;

  @ApiProperty({ example: 4.75 })
  @Column({ type: 'decimal', precision: 3, scale: 2, default: 0 })
  rating: number;

  @ApiProperty({ example: 42 })
  @Column({ type: 'integer', default: 0 })
  reviews_count: number;

  @ApiProperty({ example: 2 })
  @Column({ type: 'integer', default: 0 })
  cancellations_count: number;

  @ApiProperty({ example: 0 })
  @Column({ type: 'integer', default: 0 })
  no_shows_count: number;

  @ApiProperty({ example: 0 })
  @Column({ type: 'integer', default: 0 })
  blacklists_count: number;

  @ApiProperty({ example: 'ru' })
  @Column({ type: 'varchar', length: 5, default: 'en' })
  language: string;

  @ApiProperty({ example: 'Europe/Moscow' })
  @Column({ type: 'varchar', length: 50, default: 'UTC' })
  timezone: string;

  @ApiProperty({ example: 55.7558 })
  @Column({ type: 'decimal', precision: 10, scale: 8, nullable: true })
  last_location_lat: number;

  @ApiProperty({ example: 37.6173 })
  @Column({ type: 'decimal', precision: 11, scale: 8, nullable: true })
  last_location_lng: number;

  @ApiProperty({ description: 'Количество постов', default: 0 })
  @Column({ type: 'integer', default: 0 })
  posts_count: number;

  @ApiProperty({ description: 'Количество друзей', default: 0 })
  @Column({ type: 'integer', default: 0 })
  friends_count: number;

  @ApiProperty({ description: 'Количество подписчиков', default: 0 })
  @Column({ type: 'integer', default: 0 })
  followers_count: number;

  @ApiProperty({ description: 'Количество подписок', default: 0 })
  @Column({ type: 'integer', default: 0 })
  following_count: number;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  @ApiProperty()
  @UpdateDateColumn()
  updated_at: Date;

  // Computed property
  @ApiProperty({ example: 'Иван Петров' })
  get full_name(): string {
    return `${this.first_name} ${this.last_name}`;
  }

  // Relations will be added later:
  // @OneToOne(() => MasterProfile, profile => profile.user)
  // masterProfile: MasterProfile;
  //
  // @OneToMany(() => Booking, booking => booking.client)
  // clientBookings: Booking[];
  //
  // @OneToMany(() => Booking, booking => booking.master)
  // masterBookings: Booking[];
}
