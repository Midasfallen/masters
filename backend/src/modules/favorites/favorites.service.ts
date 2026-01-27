import {
  Injectable,
  NotFoundException,
  ConflictException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Favorite, FavoriteEntityType } from './entities/favorite.entity';
import { AddFavoriteDto } from './dto/add-favorite.dto';
import { FavoriteResponseDto } from './dto/favorite-response.dto';
import { User } from '../users/entities/user.entity';
import { Post } from '../posts/entities/post.entity';

@Injectable()
export class FavoritesService {
  constructor(
    @InjectRepository(Favorite)
    private readonly favoriteRepository: Repository<Favorite>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    @InjectRepository(Post)
    private readonly postRepository: Repository<Post>,
  ) {}

  /**
   * Добавить в избранное
   */
  async addFavorite(
    userId: string,
    addFavoriteDto: AddFavoriteDto,
  ): Promise<FavoriteResponseDto> {
    const { entity_type, entity_id } = addFavoriteDto;

    // Проверяем существование сущности
    await this.validateEntity(entity_type, entity_id);

    // Проверяем, не добавлено ли уже в избранное
    const existing = await this.favoriteRepository.findOne({
      where: {
        user_id: userId,
        entity_type,
        entity_id,
      },
    });

    if (existing) {
      throw new ConflictException('Уже добавлено в избранное');
    }

    // Создаем избранное
    const favorite = this.favoriteRepository.create({
      user_id: userId,
      entity_type,
      entity_id,
    });

    const saved = await this.favoriteRepository.save(favorite);

    return this.mapToResponseDto(saved);
  }

  /**
   * Удалить из избранного
   */
  async removeFavorite(userId: string, favoriteId: string): Promise<void> {
    const favorite = await this.favoriteRepository.findOne({
      where: { id: favoriteId },
    });

    if (!favorite) {
      throw new NotFoundException('Избранное не найдено');
    }

    if (favorite.user_id !== userId) {
      throw new BadRequestException('Нет доступа к этому избранному');
    }

    await this.favoriteRepository.remove(favorite);
  }

  /**
   * Удалить из избранного по entity
   */
  async removeFavoriteByEntity(
    userId: string,
    entityType: FavoriteEntityType,
    entityId: string,
  ): Promise<void> {
    const favorite = await this.favoriteRepository.findOne({
      where: {
        user_id: userId,
        entity_type: entityType,
        entity_id: entityId,
      },
    });

    if (!favorite) {
      throw new NotFoundException('Избранное не найдено');
    }

    await this.favoriteRepository.remove(favorite);
  }

  /**
   * Получить все избранное пользователя
   */
  async getFavorites(
    userId: string,
    entityType?: FavoriteEntityType,
  ): Promise<FavoriteResponseDto[]> {
    const queryBuilder = this.favoriteRepository
      .createQueryBuilder('favorite')
      .where('favorite.user_id = :userId', { userId })
      .orderBy('favorite.created_at', 'DESC');

    if (entityType) {
      queryBuilder.andWhere('favorite.entity_type = :entityType', {
        entityType,
      });
    }

    const favorites = await queryBuilder.getMany();

    // Загружаем данные сущностей
    const result: FavoriteResponseDto[] = [];

    for (const favorite of favorites) {
      const dto = await this.mapToResponseDtoWithEntity(favorite);
      result.push(dto);
    }

    return result;
  }

  /**
   * Проверить, добавлено ли в избранное
   */
  async isFavorite(
    userId: string,
    entityType: FavoriteEntityType,
    entityId: string,
  ): Promise<boolean> {
    const favorite = await this.favoriteRepository.findOne({
      where: {
        user_id: userId,
        entity_type: entityType,
        entity_id: entityId,
      },
    });

    return !!favorite;
  }

  /**
   * Получить количество избранного по типу
   */
  async getFavoritesCount(
    userId: string,
    entityType?: FavoriteEntityType,
  ): Promise<number> {
    const queryBuilder = this.favoriteRepository
      .createQueryBuilder('favorite')
      .where('favorite.user_id = :userId', { userId });

    if (entityType) {
      queryBuilder.andWhere('favorite.entity_type = :entityType', {
        entityType,
      });
    }

    return queryBuilder.getCount();
  }

  /**
   * Валидация существования сущности
   */
  private async validateEntity(
    entityType: FavoriteEntityType,
    entityId: string,
  ): Promise<void> {
    switch (entityType) {
      case FavoriteEntityType.MASTER:
        const user = await this.userRepository.findOne({
          where: { id: entityId, is_master: true },
        });
        if (!user) {
          throw new NotFoundException('Мастер не найден');
        }
        break;

      case FavoriteEntityType.POST:
        const post = await this.postRepository.findOne({
          where: { id: entityId },
        });
        if (!post) {
          throw new NotFoundException('Пост не найден');
        }
        break;

      default:
        throw new BadRequestException('Неверный тип сущности');
    }
  }

  /**
   * Маппинг в DTO
   */
  private mapToResponseDto(favorite: Favorite): FavoriteResponseDto {
    return {
      id: favorite.id,
      user_id: favorite.user_id,
      entity_type: favorite.entity_type,
      entity_id: favorite.entity_id,
      created_at: favorite.created_at,
    };
  }

  /**
   * Маппинг в DTO с загрузкой данных сущности
   */
  private async mapToResponseDtoWithEntity(
    favorite: Favorite,
  ): Promise<FavoriteResponseDto> {
    const dto = this.mapToResponseDto(favorite);

    try {
      switch (favorite.entity_type) {
        case FavoriteEntityType.MASTER:
          const user = await this.userRepository.findOne({
            where: { id: favorite.entity_id },
            select: [
              'id',
              'first_name',
              'last_name',
              'avatar_url',
              'rating',
              'is_master',
            ],
          });
          dto.entity = user;
          break;

        case FavoriteEntityType.POST:
          const post = await this.postRepository.findOne({
            where: { id: favorite.entity_id },
            relations: ['author', 'service'],
          });
          dto.entity = post;
          break;
      }
    } catch (error) {
      // Entity might be deleted, return without entity data
      dto.entity = null;
    }

    return dto;
  }
}
