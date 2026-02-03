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
  @ApiOperation({
    summary: 'Добавить в избранное',
    description: 'Добавление мастера или поста в избранное',
  })
  @ApiResponse({
    status: 201,
    description: 'Успешно добавлено в избранное',
    type: FavoriteResponseDto,
  })
  @ApiResponse({ status: 404, description: 'Сущность не найдена' })
  @ApiResponse({ status: 409, description: 'Уже добавлено в избранное' })
  async addFavorite(
    @Request() req,
    @Body() addFavoriteDto: AddFavoriteDto,
  ): Promise<FavoriteResponseDto> {
    // JwtStrategy.validate возвращает сущность User, у которой есть поле id
    // Ранее использовался payload.sub, но здесь уже лежит сам пользователь
    return this.favoritesService.addFavorite(req.user.id, addFavoriteDto);
  }

  @Get()
  @ApiOperation({
    summary: 'Получить избранное',
    description: 'Получение списка избранных мастеров и/или постов',
  })
  @ApiQuery({
    name: 'entity_type',
    enum: FavoriteEntityType,
    required: false,
    description: 'Фильтр по типу сущности',
  })
  @ApiResponse({
    status: 200,
    description: 'Список избранного',
    type: [FavoriteResponseDto],
  })
  async getFavorites(
    @Request() req,
    @Query('entity_type') entityType?: FavoriteEntityType,
  ): Promise<FavoriteResponseDto[]> {
    return this.favoritesService.getFavorites(req.user.id, entityType);
  }

  @Get('count')
  @ApiOperation({
    summary: 'Получить количество избранного',
    description: 'Получение количества избранных элементов',
  })
  @ApiQuery({
    name: 'entity_type',
    enum: FavoriteEntityType,
    required: false,
  })
  @ApiResponse({
    status: 200,
    description: 'Количество избранного',
    schema: {
      type: 'object',
      properties: {
        count: { type: 'number' },
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
  @ApiOperation({
    summary: 'Проверить избранное',
    description: 'Проверка, добавлена ли сущность в избранное',
  })
  @ApiParam({ name: 'entityType', enum: FavoriteEntityType })
  @ApiParam({ name: 'entityId', type: 'string' })
  @ApiResponse({
    status: 200,
    description: 'Статус избранного',
    schema: {
      type: 'object',
      properties: {
        is_favorite: { type: 'boolean' },
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
  @ApiParam({ name: 'id', type: 'string', description: 'ID избранного' })
  @ApiResponse({ status: 204, description: 'Успешно удалено' })
  @ApiResponse({ status: 404, description: 'Избранное не найдено' })
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
  @ApiParam({ name: 'entityType', enum: FavoriteEntityType })
  @ApiParam({ name: 'entityId', type: 'string' })
  @ApiResponse({ status: 204, description: 'Успешно удалено' })
  @ApiResponse({ status: 404, description: 'Избранное не найдено' })
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
