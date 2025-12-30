import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  Index,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';

export enum DevicePlatform {
  ANDROID = 'android',
  IOS = 'ios',
}

@Entity('device_tokens')
@Index(['user_id'])
@Index(['token'], { unique: true })
export class DeviceToken {
  @ApiProperty()
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ description: 'ID пользователя' })
  @Column({ type: 'uuid' })
  @Index()
  user_id: string;

  @ApiProperty({ description: 'FCM/APNs токен устройства' })
  @Column({ type: 'text', unique: true })
  token: string;

  @ApiProperty({ description: 'Платформа устройства', enum: DevicePlatform })
  @Column({
    type: 'enum',
    enum: DevicePlatform,
  })
  platform: DevicePlatform;

  @ApiProperty({ description: 'Модель устройства', required: false })
  @Column({ type: 'varchar', length: 100, nullable: true })
  device_model: string;

  @ApiProperty({ description: 'Версия ОС', required: false })
  @Column({ type: 'varchar', length: 50, nullable: true })
  os_version: string;

  @ApiProperty({ description: 'Версия приложения', required: false })
  @Column({ type: 'varchar', length: 50, nullable: true })
  app_version: string;

  @ApiProperty({ description: 'Токен активен', default: true })
  @Column({ type: 'boolean', default: true })
  is_active: boolean;

  @ApiProperty({ description: 'Последняя активность' })
  @Column({ type: 'timestamp', default: () => 'CURRENT_TIMESTAMP' })
  last_used_at: Date;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  @ApiProperty()
  @UpdateDateColumn()
  updated_at: Date;
}
