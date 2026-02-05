import {
  Controller,
  Get,
  Post,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  Request,
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
  ApiNotFoundResponse,
  ApiConflictResponse,
  ApiNoContentResponse,
} from '@nestjs/swagger';
import { FavoritesService } from './favorites.service';
import { AddFavoriteDto } from './dto/add-favorite.dto';
import { FavoriteResponseDto } from './dto/favorite-response.dto';
import { FavoriteEntityType } from './entities/favorite.entity';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('Favorites')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('favorites')
export class FavoritesController {
  constructor(private readonly favoritesService: FavoritesService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Добавить в избранное',
    description: 'Добавление мастера или поста в избранное',
  })
  @ApiCreatedResponse({
    description: 'Успешно добавлено в избранное',
    type: FavoriteResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        user_id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        entity_type: 'master',
        entity_id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        created_at: '2025-01-13T10:30:00Z',
        entity: null,
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      example: {
        statusCode: 400,
        message: [
          'entity_type must be one of the following values: master, post',
          'entity_id must be a UUID',
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
  @ApiNotFoundResponse({
    description: 'Сущность не найдена',
    schema: {
      example: {
        statusCode: 404,
        message: 'Entity not found',
        error: 'Not Found',
      },
    },
  })
  @ApiConflictResponse({
    description: 'Уже добавлено в избранное',
    schema: {
      example: {
        statusCode: 409,
        message: 'Already in favorites',
        error: 'Conflict',
      },
    },
  })
  async addFavorite(
    @Request() req,
    @Body() addFavoriteDto: AddFavoriteDto,
  ): Promise<FavoriteResponseDto> {
    // JwtStrategy.validate возвращает сущность User, у которой есть поле id
    // Ранее использовался payload.sub, но здесь уже лежит сам пользователь
    return this.favoritesService.addFavorite(req.user.id, addFavoriteDto);
  }

  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить избранное',
    description: 'Получение списка избранных мастеров и/или постов',
  })
  @ApiQuery({
    name: 'entity_type',
    enum: FavoriteEntityType,
    required: false,
    description: 'Фильтр по типу сущности (master, post)',
    example: FavoriteEntityType.MASTER,
  })
  @ApiOkResponse({
    description: 'Список избранного',
    type: [FavoriteResponseDto],
    schema: {
      example: [
        {
          id: '550e8400-e29b-41d4-a716-446655440000',
          user_id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          entity_type: 'master',
          entity_id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          created_at: '2025-01-13T10:30:00Z',
          entity: null,
        },
        {
          id: '660e8400-e29b-41d4-a716-446655440001',
          user_id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          entity_type: 'post',
          entity_id: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
          created_at: '2025-01-13T09:00:00Z',
          entity: null,
        },
      ],
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
  async getFavorites(
    @Request() req,
    @Query('entity_type') entityType?: FavoriteEntityType,
  ): Promise<FavoriteResponseDto[]> {
    return this.favoritesService.getFavorites(req.user.id, entityType);
  }

  @Get('count')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить количество избранного',
    description: 'Получение количества избранных элементов',
  })
  @ApiQuery({
    name: 'entity_type',
    enum: FavoriteEntityType,
    required: false,
    description: 'Фильтр по типу сущности (master, post)',
    example: FavoriteEntityType.MASTER,
  })
  @ApiOkResponse({
    description: 'Количество избранного',
    schema: {
      example: {
        count: 15,
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
  async getFavoritesCount(
    @Request() req,
    @Query('entity_type') entityType?: FavoriteEntityType,
  ): Promise<{ count: number }> {
    const count = await this.favoritesService.getFavoritesCount(
      req.user.id,
      entityType,
    );
    return { count };
  }

  @Get('check/:entityType/:entityId')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Проверить избранное',
    description: 'Проверка, добавлена ли сущность в избранное',
  })
  @ApiParam({
    name: 'entityType',
    enum: FavoriteEntityType,
    description: 'Тип сущности (master, post)',
    example: FavoriteEntityType.MASTER,
  })
  @ApiParam({
    name: 'entityId',
    type: 'string',
    description: 'UUID сущности',
    example: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
  })
  @ApiOkResponse({
    description: 'Статус избранного',
    schema: {
      example: {
        is_favorite: true,
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный тип сущности или UUID',
    schema: {
      example: {
        statusCode: 400,
        message: [
          'entityType must be one of the following values: master, post',
          'entityId must be a UUID',
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
  async checkFavorite(
    @Request() req,
    @Param('entityType') entityType: FavoriteEntityType,
    @Param('entityId') entityId: string,
  ): Promise<{ is_favorite: boolean }> {
    const isFavorite = await this.favoritesService.isFavorite(
      req.user.id,
      entityType,
      entityId,
    );
    return { is_favorite: isFavorite };
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Удалить из избранного по ID',
    description: 'Удаление элемента из избранного',
  })
  @ApiParam({
    name: 'id',
    type: 'string',
    description: 'UUID избранного',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiNoContentResponse({
    description: 'Успешно удалено',
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
  @ApiNotFoundResponse({
    description: 'Избранное не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Favorite not found',
        error: 'Not Found',
      },
    },
  })
  async removeFavorite(
    @Request() req,
    @Param('id') favoriteId: string,
  ): Promise<void> {
    return this.favoritesService.removeFavorite(req.user.id, favoriteId);
  }

  @Delete(':entityType/:entityId')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Удалить из избранного по сущности',
    description: 'Удаление элемента из избранного по типу и ID сущности',
  })
  @ApiParam({
    name: 'entityType',
    enum: FavoriteEntityType,
    description: 'Тип сущности (master, post)',
    example: FavoriteEntityType.MASTER,
  })
  @ApiParam({
    name: 'entityId',
    type: 'string',
    description: 'UUID сущности',
    example: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
  })
  @ApiNoContentResponse({
    description: 'Успешно удалено',
  })
  @ApiBadRequestResponse({
    description: 'Некорректный тип сущности или UUID',
    schema: {
      example: {
        statusCode: 400,
        message: [
          'entityType must be one of the following values: master, post',
          'entityId must be a UUID',
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
  @ApiNotFoundResponse({
    description: 'Избранное не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Favorite not found',
        error: 'Not Found',
      },
    },
  })
  async removeFavoriteByEntity(
    @Request() req,
    @Param('entityType') entityType: FavoriteEntityType,
    @Param('entityId') entityId: string,
  ): Promise<void> {
    return this.favoritesService.removeFavoriteByEntity(
      req.user.id,
      entityType,
      entityId,
    );
  }
}
