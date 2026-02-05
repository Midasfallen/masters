import {
  Controller,
  Get,
  Param,
  Query,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiParam,
  ApiQuery,
  ApiOkResponse,
  ApiBadRequestResponse,
  ApiNotFoundResponse,
} from '@nestjs/swagger';
import { Public } from '../auth/decorators/public.decorator';
import { ServiceTemplatesService } from './service-templates.service';
import {
  ServiceTemplateResponseDto,
  ServiceTemplateListResponseDto,
} from './dto/service-template-response.dto';

@ApiTags('service-templates')
@Controller()
export class ServiceTemplatesController {
  constructor(
    private readonly serviceTemplatesService: ServiceTemplatesService,
  ) {}

  @Get('categories/:categoryId/templates')
  @Public()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить шаблоны услуг для категории',
    description: 'Возвращает список шаблонов услуг для категории level 1',
  })
  @ApiParam({
    name: 'categoryId',
    description: 'ID категории level 1',
    type: String,
  })
  @ApiQuery({
    name: 'language',
    description: 'Язык для переводов',
    required: false,
    type: String,
    example: 'ru',
  })
  @ApiOkResponse({
    description: 'Список шаблонов услуг',
    type: ServiceTemplateListResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Категория не найдена' })
  @ApiBadRequestResponse({
    description: 'Категория не является level 1',
  })
  async getByCategoryId(
    @Param('categoryId') categoryId: string,
    @Query('language') language: string = 'ru',
  ): Promise<ServiceTemplateListResponseDto> {
    return this.serviceTemplatesService.getByCategoryId(categoryId, language);
  }

  @Get('service-templates/:slug')
  @Public()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить шаблон услуги по slug',
    description: 'Возвращает шаблон услуги по его SEO-friendly slug',
  })
  @ApiParam({
    name: 'slug',
    description: 'Slug шаблона услуги',
    type: String,
    example: 'krasota-i-uhod-parikmaherskie-uslugi-muzhskaya-strizhka',
  })
  @ApiQuery({
    name: 'language',
    description: 'Язык для переводов',
    required: false,
    type: String,
    example: 'ru',
  })
  @ApiOkResponse({
    description: 'Шаблон услуги',
    type: ServiceTemplateResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Шаблон не найден' })
  async getBySlug(
    @Param('slug') slug: string,
    @Query('language') language: string = 'ru',
  ): Promise<ServiceTemplateResponseDto> {
    return this.serviceTemplatesService.getBySlug(slug, language);
  }

  @Get('service-templates/id/:id')
  @Public()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить шаблон услуги по ID',
    description: 'Возвращает шаблон услуги по его ID',
  })
  @ApiParam({
    name: 'id',
    description: 'ID шаблона услуги',
    type: String,
  })
  @ApiQuery({
    name: 'language',
    description: 'Язык для переводов',
    required: false,
    type: String,
    example: 'ru',
  })
  @ApiOkResponse({
    description: 'Шаблон услуги',
    type: ServiceTemplateResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Шаблон не найден' })
  async getById(
    @Param('id') id: string,
    @Query('language') language: string = 'ru',
  ): Promise<ServiceTemplateResponseDto> {
    return this.serviceTemplatesService.getById(id, language);
  }
}
