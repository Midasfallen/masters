import { Controller, Post, Get, HttpCode, HttpStatus } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { SearchService } from '../search/search.service';
import { ReindexResponseDto, SearchStatsDto } from './dto/reindex-response.dto';
import { Public } from '../auth/decorators/public.decorator';

@ApiTags('admin')
@Controller('admin/search')
@Public() // Публичный доступ для dev окружения
export class AdminController {
  constructor(private readonly searchService: SearchService) {}

  @Post('reindex-all')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Переиндексировать все данные в Meilisearch',
    description:
      'Переиндексирует мастеров, услуги, шаблоны услуг и категории в Meilisearch. Используется после seed или при проблемах с поиском.',
  })
  @ApiResponse({
    status: 200,
    description: 'Переиндексация успешно выполнена',
    type: ReindexResponseDto,
  })
  async reindexAll(): Promise<ReindexResponseDto> {
    const startTime = Date.now();

    await this.searchService.reindexAll();

    const processingTime = Date.now() - startTime;

    return {
      success: true,
      message: 'Все данные успешно переиндексированы',
      processingTime,
    };
  }

  @Post('reindex-categories')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Переиндексировать категории',
    description: 'Переиндексирует только категории (L0 и L1) в Meilisearch.',
  })
  @ApiResponse({
    status: 200,
    description: 'Категории успешно переиндексированы',
    type: ReindexResponseDto,
  })
  async reindexCategories(): Promise<ReindexResponseDto> {
    const startTime = Date.now();

    await this.searchService.reindexCategories();

    const processingTime = Date.now() - startTime;

    // Получаем статистику для подсчета документов
    const stats = await this.searchService.getIndexStats();

    return {
      success: true,
      message: 'Категории успешно переиндексированы',
      documentsCount: stats.categories.numberOfDocuments,
      processingTime,
    };
  }

  @Get('stats')
  @ApiOperation({
    summary: 'Получить статистику индексов Meilisearch',
    description:
      'Возвращает статистику по всем индексам: количество документов, статус индексации и др.',
  })
  @ApiResponse({
    status: 200,
    description: 'Статистика индексов',
    type: SearchStatsDto,
  })
  async getStats(): Promise<SearchStatsDto> {
    return await this.searchService.getIndexStats();
  }
}
