import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsEnum, IsOptional } from 'class-validator';
import { DevicePlatform } from '../entities/device-token.entity';

export class RegisterDeviceDto {
  @ApiProperty({
    description: 'FCM/APNs токен устройства',
    example: 'dXkjF9j8Q...',
  })
  @IsString()
  token: string;

  @ApiProperty({
    description: 'Платформа устройства',
    enum: DevicePlatform,
    example: DevicePlatform.ANDROID,
  })
  @IsEnum(DevicePlatform)
  platform: DevicePlatform;

  @ApiProperty({
    description: 'Модель устройства',
    example: 'iPhone 14 Pro',
    required: false,
  })
  @IsOptional()
  @IsString()
  device_model?: string;

  @ApiProperty({
    description: 'Версия ОС',
    example: 'iOS 17.2',
    required: false,
  })
  @IsOptional()
  @IsString()
  os_version?: string;

  @ApiProperty({
    description: 'Версия приложения',
    example: '2.0.1',
    required: false,
  })
  @IsOptional()
  @IsString()
  app_version?: string;
}
