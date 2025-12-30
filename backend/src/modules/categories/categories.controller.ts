import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
  UseGuards,
} from '@nestjs/common';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiParam,
  ApiQuery,
} from '@nestjs/swagger';
import { CategoriesService } from './categories.service';
import { CreateCategoryDto } from './dto/create-category.dto';
import { UpdateCategoryDto } from './dto/update-category.dto';
import { MoveCategoryDto } from './dto/move-category.dto';
import {
  CategoryResponseDto,
  CategoryTreeResponseDto,
} from './dto/category-response.dto';
import { Public } from '../auth/decorators/public.decorator';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('Categories')
@Controller('categories')
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  // ============ ПУБЛИЧНЫЕ ENDPOINTS (для клиентов и гостей) ============

  @Public()
  @Get('tree')
  @ApiOperation({
    summary: 'Получить дерево категорий',
    description: 'Возвращает иерархическую структуру всех категорий',
  })
  @ApiQuery({
    name: 'language',
    required: false,
    description: 'Код языка (ru, en и т.д.)',
    example: 'ru',
  })
  @ApiResponse({
    status: 200,
    description: 'Дерево категорий',
    type: [CategoryTreeResponseDto],
  })
  async getTree(
    @Query('language') language?: string,
  ): Promise<CategoryTreeResponseDto[]> {
    return this.categoriesService.getTree(language || 'ru');
  }

  @Public()
  @Get('roots')
  @ApiOperation({
    summary: 'Получить корневые категории',
    description: 'Возвращает категории первого уровня без дочерних',
  })
  @ApiQuery({
    name: 'language',
    required: false,
    description: 'Код языка',
    example: 'ru',
  })
  @ApiResponse({
    status: 200,
    description: 'Корневые категории',
    type: [CategoryTreeResponseDto],
  })
  async getRoots(
    @Query('language') language?: string,
  ): Promise<CategoryTreeResponseDto[]> {
    return this.categoriesService.getRoots(language || 'ru');
  }

  @Public()
  @Get('popular')
  @ApiOperation({
    summary: 'Получить популярные категории',
    description: 'Возвращает категории, помеченные как популярные',
  })
  @ApiQuery({
    name: 'language',
    required: false,
    description: 'Код языка',
    example: 'ru',
  })
  @ApiResponse({
    status: 200,
    description: 'Популярные категории',
    type: [CategoryTreeResponseDto],
  })
  async getPopular(
    @Query('language') language?: string,
  ): Promise<CategoryTreeResponseDto[]> {
    return this.categoriesService.getPopular(language || 'ru');
  }

  @Public()
  @Get('slug/:slug')
  @ApiOperation({
    summary: 'Получить категорию по slug',
    description: 'Возвращает информацию о категории по её slug',
  })
  @ApiParam({ name: 'slug', description: 'Slug категории', example: 'beauty' })
  @ApiQuery({
    name: 'language',
    required: false,
    description: 'Код языка',
    example: 'ru',
  })
  @ApiResponse({
    status: 200,
    description: 'Данные категории',
    type: CategoryResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Категория не найдена' })
  async findBySlug(
    @Param('slug') slug: string,
    @Query('language') language?: string,
  ): Promise<CategoryResponseDto> {
    return this.categoriesService.findBySlug(slug, language || 'ru');
  }

  @Public()
  @Get(':id')
  @ApiOperation({
    summary: 'Получить категорию по ID',
    description: 'Возвращает полную информацию о категории',
  })
  @ApiParam({ name: 'id', description: 'ID категории' })
  @ApiQuery({
    name: 'language',
    required: false,
    description: 'Код языка',
    example: 'ru',
  })
  @ApiResponse({
    status: 200,
    description: 'Данные категории',
    type: CategoryResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Категория не найдена' })
  async findOne(
    @Param('id') id: string,
    @Query('language') language?: string,
  ): Promise<CategoryResponseDto> {
    return this.categoriesService.findOne(id, language || 'ru');
  }

  @Public()
  @Get(':id/children')
  @ApiOperation({
    summary: 'Получить дочерние категории',
    description: 'Возвращает все дочерние категории для указанной категории',
  })
  @ApiParam({ name: 'id', description: 'ID родительской категории' })
  @ApiQuery({
    name: 'language',
    required: false,
    description: 'Код языка',
    example: 'ru',
  })
  @ApiResponse({
    status: 200,
    description: 'Дочерние категории',
    type: [CategoryTreeResponseDto],
  })
  @ApiResponse({ status: 404, description: 'Категория не найдена' })
  async getChildren(
    @Param('id') id: string,
    @Query('language') language?: string,
  ): Promise<CategoryTreeResponseDto[]> {
    return this.categoriesService.getChildren(id, language || 'ru');
  }

  @Public()
  @Get(':id/ancestors')
  @ApiOperation({
    summary: 'Получить путь от корня до категории',
    description: 'Возвращает все родительские категории (хлебные крошки)',
  })
  @ApiParam({ name: 'id', description: 'ID категории' })
  @ApiQuery({
    name: 'language',
    required: false,
    description: 'Код языка',
    example: 'ru',
  })
  @ApiResponse({
    status: 200,
    description: 'Путь к категории',
    type: [CategoryTreeResponseDto],
  })
  @ApiResponse({ status: 404, description: 'Категория не найдена' })
  async getAncestors(
    @Param('id') id: string,
    @Query('language') language?: string,
  ): Promise<CategoryTreeResponseDto[]> {
    return this.categoriesService.getAncestors(id, language || 'ru');
  }

  @Public()
  @Get()
  @ApiOperation({
    summary: 'Получить все категории плоским списком',
    description: 'Возвращает все категории без иерархии',
  })
  @ApiQuery({
    name: 'language',
    required: false,
    description: 'Код языка',
    example: 'ru',
  })
  @ApiResponse({
    status: 200,
    description: 'Список категорий',
    type: [CategoryResponseDto],
  })
  async findAll(
    @Query('language') language?: string,
  ): Promise<CategoryResponseDto[]> {
    return this.categoriesService.findAll(language || 'ru');
  }

  // ============ ЗАЩИЩЕННЫЕ ENDPOINTS (для админов) ============

  @Post()
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: 'Создать новую категорию (Admin)',
    description: 'Создание категории с переводами. Требует авторизации.',
  })
  @ApiResponse({
    status: 201,
    description: 'Категория создана',
    type: CategoryResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Невалидные данные' })
  @ApiResponse({ status: 409, description: 'Категория с таким slug уже существует' })
  async create(
    @Body() createCategoryDto: CreateCategoryDto,
  ): Promise<CategoryResponseDto> {
    // TODO: Добавить проверку роли admin
    return this.categoriesService.create(createCategoryDto);
  }

  @Patch(':id')
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: 'Обновить категорию (Admin)',
    description: 'Обновление данных категории. Требует авторизации.',
  })
  @ApiParam({ name: 'id', description: 'ID категории' })
  @ApiResponse({
    status: 200,
    description: 'Категория обновлена',
    type: CategoryResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Категория не найдена' })
  async update(
    @Param('id') id: string,
    @Body() updateCategoryDto: UpdateCategoryDto,
  ): Promise<CategoryResponseDto> {
    // TODO: Добавить проверку роли admin
    return this.categoriesService.update(id, updateCategoryDto);
  }

  @Patch(':id/move')
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: 'Переместить категорию (Admin)',
    description: 'Изменение родительской категории. Требует авторизации.',
  })
  @ApiParam({ name: 'id', description: 'ID категории' })
  @ApiResponse({
    status: 200,
    description: 'Категория перемещена',
    type: CategoryResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Нельзя переместить в потомков' })
  @ApiResponse({ status: 404, description: 'Категория не найдена' })
  async move(
    @Param('id') id: string,
    @Body() moveCategoryDto: MoveCategoryDto,
  ): Promise<CategoryResponseDto> {
    // TODO: Добавить проверку роли admin
    return this.categoriesService.move(id, moveCategoryDto);
  }

  @Delete(':id')
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @ApiOperation({
    summary: 'Удалить категорию (Admin)',
    description:
      'Удаление категории. Нельзя удалить, если есть дочерние или связанные мастера/услуги. Требует авторизации.',
  })
  @ApiParam({ name: 'id', description: 'ID категории' })
  @ApiResponse({ status: 200, description: 'Категория удалена' })
  @ApiResponse({
    status: 400,
    description: 'Нельзя удалить категорию с дочерними или связями',
  })
  @ApiResponse({ status: 404, description: 'Категория не найдена' })
  async remove(@Param('id') id: string): Promise<void> {
    // TODO: Добавить проверку роли admin
    return this.categoriesService.remove(id);
  }
}
