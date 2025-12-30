import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';
import { IsArray, IsOptional, IsUrl, ArrayMaxSize } from 'class-validator';

/**
 * ШАГ 3: Портфолио (фото и видео работ)
 * Загрузка фото и коротких видео (15 сек)
 */
export class Step3PortfolioDto {
  @ApiPropertyOptional({
    description: 'URL фотографий портфолио (максимум 20)',
    type: [String],
    example: [
      'https://storage.example.com/portfolio/photo1.jpg',
      'https://storage.example.com/portfolio/photo2.jpg',
    ],
  })
  @IsOptional()
  @IsArray()
  @IsUrl({}, { each: true })
  @ArrayMaxSize(20, { message: 'Максимум 20 фотографий' })
  portfolio_urls?: string[];

  @ApiPropertyOptional({
    description: 'URL видео (15 сек, максимум 5)',
    type: [String],
    example: ['https://storage.example.com/videos/video1.mp4'],
  })
  @IsOptional()
  @IsArray()
  @IsUrl({}, { each: true })
  @ArrayMaxSize(5, { message: 'Максимум 5 видео' })
  video_urls?: string[];

  @ApiPropertyOptional({
    description: 'URL сертификатов и дипломов',
    type: [String],
    example: ['https://storage.example.com/certificates/cert1.jpg'],
  })
  @IsOptional()
  @IsArray()
  @IsUrl({}, { each: true })
  certificates?: string[];
}
