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
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiBearerAuth,
  ApiOperation,
  ApiResponse,
  ApiParam,
  ApiQuery,
  ApiCreatedResponse,
  ApiOkResponse,
  ApiBadRequestResponse,
  ApiUnauthorizedResponse,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiConflictResponse,
  ApiNoContentResponse,
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
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить дерево категорий',
    description: 'Возвращает иерархическую структуру всех категорий с вложенными дочерними категориями',
  })
  @ApiQuery({
    name: 'language',
    required: false,
    description: 'Код языка (ru, en и т.д.)',
    example: 'ru',
  })
  @ApiOkResponse({
    description: 'Дерево категорий',
    type: [CategoryTreeResponseDto],
    schema: {
      example: [
        {
          id: '550e8400-e29b-41d4-a716-446655440000',
          slug: 'beauty',
          name: 'Красота',
          description: 'Услуги красоты',
          icon: 'sparkles',
          level: 0,
          parentId: null,
          isPopular: true,
          displayOrder: 1,
          children: [
            {
              id: '660e8400-e29b-41d4-a716-446655440001',
              slug: 'hair',
              name: 'Парикмахерские услуги',
              description: 'Стрижки, окрашивание, укладки',
              icon: 'scissors',
              level: 1,
              parentId: '550e8400-e29b-41d4-a716-446655440000',
              isPopular: true,
              displayOrder: 1,
              children: [],
            },
          ],
        },
      ],
    },
  })
  async getTree(
    @Query('language') language?: string,
  ): Promise<CategoryTreeResponseDto[]> {
    return this.categoriesService.getTree(language || 'ru');
  }

  @Public()
  @Get('roots')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить корневые категории',
    description: 'Возвращает категории первого уровня без дочерних',
  })
  @ApiQuery({
    name: 'language',
    required: false,
    description: 'Код языка (ru, en и т.д.)',
    example: 'ru',
  })
  @ApiOkResponse({
    description: 'Корневые категории',
    type: [CategoryTreeResponseDto],
    schema: {
      example: [
        {
          id: '550e8400-e29b-41d4-a716-446655440000',
          slug: 'beauty',
          name: 'Красота',
          description: 'Услуги красоты',
          icon: 'sparkles',
          level: 0,
          parentId: null,
          isPopular: true,
          displayOrder: 1,
          children: [],
        },
      ],
    },
  })
  async getRoots(
    @Query('language') language?: string,
  ): Promise<CategoryTreeResponseDto[]> {
    return this.categoriesService.getRoots(language || 'ru');
  }

  @Public()
  @Get('popular')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить популярные категории',
    description: 'Возвращает категории, помеченные как популярные',
  })
  @ApiQuery({
    name: 'language',
    required: false,
    description: 'Код языка (ru, en и т.д.)',
    example: 'ru',
  })
  @ApiOkResponse({
    description: 'Популярные категории',
    type: [CategoryTreeResponseDto],
    schema: {
      example: [
        {
          id: '550e8400-e29b-41d4-a716-446655440000',
          slug: 'beauty',
          name: 'Красота',
          description: 'Услуги красоты',
          icon: 'sparkles',
          level: 0,
          parentId: null,
          isPopular: true,
          displayOrder: 1,
          children: [],
        },
      ],
    },
  })
  async getPopular(
    @Query('language') language?: string,
  ): Promise<CategoryTreeResponseDto[]> {
    return this.categoriesService.getPopular(language || 'ru');
  }

  @Public()
  @Get('slug/:slug')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить категорию по slug',
    description: 'Возвращает информацию о категории по её slug',
  })
  @ApiParam({
    name: 'slug',
    description: 'Slug категории',
    example: 'beauty',
  })
  @ApiQuery({
    name: 'language',
    required: false,
    description: 'Код языка (ru, en и т.д.)',
    example: 'ru',
  })
  @ApiOkResponse({
    description: 'Данные категории',
    type: CategoryResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        slug: 'beauty',
        name: 'Красота',
        description: 'Услуги красоты',
        icon: 'sparkles',
        level: 0,
        parentId: null,
        isPopular: true,
        displayOrder: 1,
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Категория не найдена',
    schema: {
      example: {
        statusCode: 404,
        message: 'Category not found',
        error: 'Not Found',
      },
    },
  })
  async findBySlug(
    @Param('slug') slug: string,
    @Query('language') language?: string,
  ): Promise<CategoryResponseDto> {
    return this.categoriesService.findBySlug(slug, language || 'ru');
  }

  @Public()
  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить категорию по ID',
    description: 'Возвращает полную информацию о категории',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID категории',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiQuery({
    name: 'language',
    required: false,
    description: 'Код языка (ru, en и т.д.)',
    example: 'ru',
  })
  @ApiOkResponse({
    description: 'Данные категории',
    type: CategoryResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        slug: 'beauty',
        name: 'Красота',
        description: 'Услуги красоты',
        icon: 'sparkles',
        level: 0,
        parentId: null,
        isPopular: true,
        displayOrder: 1,
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный UUID',
    schema: {
      example: {
        statusCode: 400,
        message: 'Validation failed (uuid is expected)',
        error: 'Bad Request',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Категория не найдена',
    schema: {
      example: {
        statusCode: 404,
        message: 'Category not found',
        error: 'Not Found',
      },
    },
  })
  async findOne(
    @Param('id') id: string,
    @Query('language') language?: string,
  ): Promise<CategoryResponseDto> {
    return this.categoriesService.findOne(id, language || 'ru');
  }

  @Public()
  @Get(':id/children')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить дочерние категории',
    description: 'Возвращает все дочерние категории для указанной категории',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID родительской категории',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiQuery({
    name: 'language',
    required: false,
    description: 'Код языка (ru, en и т.д.)',
    example: 'ru',
  })
  @ApiOkResponse({
    description: 'Дочерние категории',
    type: [CategoryTreeResponseDto],
    schema: {
      example: [
        {
          id: '660e8400-e29b-41d4-a716-446655440001',
          slug: 'hair',
          name: 'Парикмахерские услуги',
          description: 'Стрижки, окрашивание, укладки',
          icon: 'scissors',
          level: 1,
          parentId: '550e8400-e29b-41d4-a716-446655440000',
          isPopular: true,
          displayOrder: 1,
          children: [],
        },
      ],
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный UUID',
    schema: {
      example: {
        statusCode: 400,
        message: 'Validation failed (uuid is expected)',
        error: 'Bad Request',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Категория не найдена',
    schema: {
      example: {
        statusCode: 404,
        message: 'Category not found',
        error: 'Not Found',
      },
    },
  })
  async getChildren(
    @Param('id') id: string,
    @Query('language') language?: string,
  ): Promise<CategoryTreeResponseDto[]> {
    return this.categoriesService.getChildren(id, language || 'ru');
  }

  @Public()
  @Get(':id/ancestors')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить путь от корня до категории',
    description: 'Возвращает все родительские категории (хлебные крошки)',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID категории',
    example: '660e8400-e29b-41d4-a716-446655440001',
  })
  @ApiQuery({
    name: 'language',
    required: false,
    description: 'Код языка (ru, en и т.д.)',
    example: 'ru',
  })
  @ApiOkResponse({
    description: 'Путь к категории',
    type: [CategoryTreeResponseDto],
    schema: {
      example: [
        {
          id: '550e8400-e29b-41d4-a716-446655440000',
          slug: 'beauty',
          name: 'Красота',
          description: 'Услуги красоты',
          icon: 'sparkles',
          level: 0,
          parentId: null,
          isPopular: true,
          displayOrder: 1,
          children: [],
        },
        {
          id: '660e8400-e29b-41d4-a716-446655440001',
          slug: 'hair',
          name: 'Парикмахерские услуги',
          description: 'Стрижки, окрашивание, укладки',
          icon: 'scissors',
          level: 1,
          parentId: '550e8400-e29b-41d4-a716-446655440000',
          isPopular: true,
          displayOrder: 1,
          children: [],
        },
      ],
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный UUID',
    schema: {
      example: {
        statusCode: 400,
        message: 'Validation failed (uuid is expected)',
        error: 'Bad Request',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Категория не найдена',
    schema: {
      example: {
        statusCode: 404,
        message: 'Category not found',
        error: 'Not Found',
      },
    },
  })
  async getAncestors(
    @Param('id') id: string,
    @Query('language') language?: string,
  ): Promise<CategoryTreeResponseDto[]> {
    return this.categoriesService.getAncestors(id, language || 'ru');
  }

  @Public()
  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить все категории плоским списком',
    description: 'Возвращает все категории без иерархии',
  })
  @ApiQuery({
    name: 'language',
    required: false,
    description: 'Код языка (ru, en и т.д.)',
    example: 'ru',
  })
  @ApiOkResponse({
    description: 'Список категорий',
    type: [CategoryResponseDto],
    schema: {
      example: [
        {
          id: '550e8400-e29b-41d4-a716-446655440000',
          slug: 'beauty',
          name: 'Красота',
          description: 'Услуги красоты',
          icon: 'sparkles',
          level: 0,
          parentId: null,
          isPopular: true,
          displayOrder: 1,
        },
        {
          id: '660e8400-e29b-41d4-a716-446655440001',
          slug: 'hair',
          name: 'Парикмахерские услуги',
          description: 'Стрижки, окрашивание, укладки',
          icon: 'scissors',
          level: 1,
          parentId: '550e8400-e29b-41d4-a716-446655440000',
          isPopular: true,
          displayOrder: 1,
        },
      ],
    },
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
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Создать новую категорию (Admin)',
    description: 'Создание категории с переводами. Требует авторизации и прав администратора.',
  })
  @ApiCreatedResponse({
    description: 'Категория создана',
    type: CategoryResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        slug: 'beauty',
        name: 'Красота',
        description: 'Услуги красоты',
        icon: 'sparkles',
        level: 0,
        parentId: null,
        isPopular: true,
        displayOrder: 1,
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Невалидные данные',
    schema: {
      example: {
        statusCode: 400,
        message: [
          'slug must be a string',
          'name must be longer than or equal to 2 characters',
        ],
        error: 'Bad Request',
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiForbiddenResponse({
    description: 'Требуются права администратора',
    schema: {
      example: {
        statusCode: 403,
        message: 'Admin access required',
        error: 'Forbidden',
      },
    },
  })
  @ApiConflictResponse({
    description: 'Категория с таким slug уже существует',
    schema: {
      example: {
        statusCode: 409,
        message: 'Category with this slug already exists',
        error: 'Conflict',
      },
    },
  })
  async create(
    @Body() createCategoryDto: CreateCategoryDto,
  ): Promise<CategoryResponseDto> {
    // TODO: Добавить проверку роли admin
    return this.categoriesService.create(createCategoryDto);
  }

  @Patch(':id')
  @ApiBearerAuth()
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Обновить категорию (Admin)',
    description: 'Обновление данных категории. Требует авторизации и прав администратора.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID категории',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Категория обновлена',
    type: CategoryResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        slug: 'beauty-updated',
        name: 'Красота (обновлено)',
        description: 'Услуги красоты и здоровья',
        icon: 'sparkles',
        level: 0,
        parentId: null,
        isPopular: true,
        displayOrder: 1,
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные или UUID',
    schema: {
      example: {
        statusCode: 400,
        message: ['name must be longer than or equal to 2 characters'],
        error: 'Bad Request',
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiForbiddenResponse({
    description: 'Требуются права администратора',
    schema: {
      example: {
        statusCode: 403,
        message: 'Admin access required',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Категория не найдена',
    schema: {
      example: {
        statusCode: 404,
        message: 'Category not found',
        error: 'Not Found',
      },
    },
  })
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
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Переместить категорию (Admin)',
    description: 'Изменение родительской категории. Требует авторизации и прав администратора.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID категории',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Категория перемещена',
    type: CategoryResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        slug: 'beauty',
        name: 'Красота',
        description: 'Услуги красоты',
        icon: 'sparkles',
        level: 1,
        parentId: '770e8400-e29b-41d4-a716-446655440002',
        isPopular: true,
        displayOrder: 1,
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Нельзя переместить в потомков или некорректные данные',
    schema: {
      examples: {
        circularReference: {
          value: {
            statusCode: 400,
            message: 'Cannot move category into its own descendants',
            error: 'Bad Request',
          },
        },
        invalidUUID: {
          value: {
            statusCode: 400,
            message: ['parent_id must be a UUID'],
            error: 'Bad Request',
          },
        },
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiForbiddenResponse({
    description: 'Требуются права администратора',
    schema: {
      example: {
        statusCode: 403,
        message: 'Admin access required',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Категория не найдена',
    schema: {
      example: {
        statusCode: 404,
        message: 'Category not found',
        error: 'Not Found',
      },
    },
  })
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
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Удалить категорию (Admin)',
    description:
      'Удаление категории. Нельзя удалить, если есть дочерние или связанные мастера/услуги. Требует авторизации и прав администратора.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID категории',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiNoContentResponse({
    description: 'Категория удалена',
  })
  @ApiBadRequestResponse({
    description: 'Нельзя удалить категорию с дочерними или связями',
    schema: {
      examples: {
        hasChildren: {
          value: {
            statusCode: 400,
            message: 'Cannot delete category with children',
            error: 'Bad Request',
          },
        },
        hasMasters: {
          value: {
            statusCode: 400,
            message: 'Cannot delete category with associated masters',
            error: 'Bad Request',
          },
        },
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiForbiddenResponse({
    description: 'Требуются права администратора',
    schema: {
      example: {
        statusCode: 403,
        message: 'Admin access required',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Категория не найдена',
    schema: {
      example: {
        statusCode: 404,
        message: 'Category not found',
        error: 'Not Found',
      },
    },
  })
  async remove(@Param('id') id: string): Promise<void> {
    // TODO: Добавить проверку роли admin
    return this.categoriesService.remove(id);
  }
}
