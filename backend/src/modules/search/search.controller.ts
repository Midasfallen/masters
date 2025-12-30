import { Controller, Get, Query } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiResponse } from '@nestjs/swagger';
import { SearchService } from './search.service';
import { SearchMastersDto } from './dto/search-masters.dto';
import { SearchServicesDto } from './dto/search-services.dto';
import {
  MasterSearchResultDto,
  ServiceSearchResultDto,
  SearchResponseDto,
} from './dto/search-response.dto';
import { Public } from '../auth/decorators/public.decorator';

@ApiTags('Search')
@Controller('search')
export class SearchController {
  constructor(private readonly searchService: SearchService) {}

  @Public()
  @Get('masters')
  @ApiOperation({
    summary: 'Поиск мастеров',
    description:
      'Полнотекстовый поиск мастеров с фильтрацией по категории, рейтингу, геолокации и тегам. Использует Meilisearch для быстрого поиска.',
  })
  @ApiResponse({
    status: 200,
    description: 'Результаты поиска мастеров',
    type: SearchResponseDto<MasterSearchResultDto>,
  })
  async searchMasters(
    @Query() searchDto: SearchMastersDto,
  ): Promise<SearchResponseDto<MasterSearchResultDto>> {
    return this.searchService.searchMasters(searchDto);
  }

  @Public()
  @Get('services')
  @ApiOperation({
    summary: 'Поиск услуг',
    description:
      'Полнотекстовый поиск услуг с фильтрацией по категории, цене, длительности и тегам. Использует Meilisearch для быстрого поиска.',
  })
  @ApiResponse({
    status: 200,
    description: 'Результаты поиска услуг',
    type: SearchResponseDto<ServiceSearchResultDto>,
  })
  async searchServices(
    @Query() searchDto: SearchServicesDto,
  ): Promise<SearchResponseDto<ServiceSearchResultDto>> {
    return this.searchService.searchServices(searchDto);
  }
}
