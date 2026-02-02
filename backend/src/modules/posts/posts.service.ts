import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Post, PostType, PostPrivacy } from './entities/post.entity';
import { PostMedia } from './entities/post-media.entity';
import { PostService } from './entities/post-service.entity';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { FilterPostsDto } from './dto/filter-posts.dto';
import { PostResponseDto } from './dto/post-response.dto';
import { Friendship, FriendshipStatus } from '../friends/entities/friendship.entity';
import { Subscription } from '../friends/entities/subscription.entity';
import { PostsMapper } from './posts.mapper';
import { Service } from '../services/entities/service.entity';

@Injectable()
export class PostsService {
  constructor(
    @InjectRepository(Post)
    private readonly postRepository: Repository<Post>,
    @InjectRepository(PostMedia)
    private readonly postMediaRepository: Repository<PostMedia>,
    @InjectRepository(PostService)
    private readonly postServiceRepository: Repository<PostService>,
    @InjectRepository(Service)
    private readonly serviceRepository: Repository<Service>,
    @InjectRepository(Friendship)
    private readonly friendshipRepository: Repository<Friendship>,
    @InjectRepository(Subscription)
    private readonly subscriptionRepository: Repository<Subscription>,
  ) {}

  async create(userId: string, createPostDto: CreatePostDto) {
    // Валидация: repost должен существовать
    if (createPostDto.repost_of_id) {
      const originalPost = await this.postRepository.findOne({
        where: { id: createPostDto.repost_of_id },
      });
      if (!originalPost) {
        throw new NotFoundException('Original post not found');
      }
    }

    const post = this.postRepository.create({
      ...createPostDto,
      author_id: userId,
    });

    const savedPost = await this.postRepository.save(post);

    // Заполнить location_geography из координат, если они указаны (через raw SQL)
    if (createPostDto.location_lat && createPostDto.location_lng) {
      await this.postRepository.query(
        `UPDATE posts 
         SET location_geography = ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography 
         WHERE id = $3`,
        [createPostDto.location_lng, createPostDto.location_lat, savedPost.id],
      );
    }

    // Сохранение медиа файлов
    if (createPostDto.media && createPostDto.media.length > 0) {
      const mediaEntities = createPostDto.media.map((media) =>
        this.postMediaRepository.create({
          ...media,
          post_id: savedPost.id,
        }),
      );
      await this.postMediaRepository.save(mediaEntities);
    }

    // Определяем category_ids для поста
    let categoryIds: string[] = [];
    
    // Если category_ids переданы напрямую, используем их
    if (createPostDto.category_ids && createPostDto.category_ids.length > 0) {
      categoryIds = createPostDto.category_ids;
    }
    // Иначе получаем category_ids из service_ids
    else if (createPostDto.service_ids && createPostDto.service_ids.length > 0) {
      const services = await this.serviceRepository.find({
        where: { id: In(createPostDto.service_ids) },
        select: ['category_id'],
      });
      categoryIds = Array.from(new Set(services.map(s => s.category_id).filter(Boolean)));
    }
    // Если ничего не передано, пытаемся получить из master_profile
    else {
      const masterProfile = await this.postRepository.query(
        `SELECT category_ids FROM master_profiles WHERE user_id = $1`,
        [userId],
      );
      if (masterProfile && masterProfile[0] && masterProfile[0].category_ids) {
        categoryIds = masterProfile[0].category_ids;
      }
    }

    // Сохраняем category_ids в пост
    if (categoryIds.length > 0) {
      await this.postRepository.update(savedPost.id, { category_ids: categoryIds });
    }

    // Сохранение связей с услугами
    if (createPostDto.service_ids && createPostDto.service_ids.length > 0) {
      const postServices = createPostDto.service_ids.map((serviceId) =>
        this.postServiceRepository.create({
          post_id: savedPost.id,
          service_id: serviceId,
        }),
      );
      await this.postServiceRepository.save(postServices);
    }

    // Обновление счетчика репостов для оригинального поста
    if (createPostDto.repost_of_id) {
      await this.postRepository.increment(
        { id: createPostDto.repost_of_id },
        'reposts_count',
        1,
      );
    }

    return this.findOne(savedPost.id, userId);
  }

  async getFeed(userId: string, filterDto: FilterPostsDto) {
    const {
      page = 1,
      limit = 20,
      lat,
      lng,
      radius = 10,
      cursor,
      category_ids,
    } = filterDto;

    // Получаем ID друзей пользователя
    const friendships = await this.friendshipRepository.find({
      where: [
        { requester_id: userId, status: FriendshipStatus.ACCEPTED },
        { addressee_id: userId, status: FriendshipStatus.ACCEPTED },
      ],
    });

    const friendIds = friendships.map((f) =>
      f.requester_id === userId ? f.addressee_id : f.requester_id,
    );

    // Получаем ID подписок пользователя
    const subscriptions = await this.subscriptionRepository.find({
      where: { subscriber_id: userId },
    });

    const subscriptionIds = subscriptions.map((s) => s.target_id);

    // Объединяем ID друзей и подписок
    const relevantUserIds = Array.from(
      new Set([...friendIds, ...subscriptionIds, userId]),
    );

    const queryBuilder = this.postRepository
      .createQueryBuilder('post')
      .leftJoinAndSelect('post.author', 'author')
      .leftJoinAndSelect('post.media', 'media')
      .leftJoinAndSelect('post.repost_of', 'repost_of')
      .leftJoinAndSelect('repost_of.author', 'repost_author')
      .leftJoin('post.post_services', 'post_service'); // Добавляем join для фильтрации по категориям

    // Фильтрация по приватности:
    // 1. Публичные посты от всех
    // 2. Посты "для друзей" только от друзей
    // 3. Приватные посты только свои
    queryBuilder.andWhere(
      `(
        (post.privacy = :publicPrivacy) OR
        (post.privacy = :friendsPrivacy AND post.author_id IN (:...friendIds)) OR
        (post.privacy = :privatePrivacy AND post.author_id = :userId)
      )`,
      {
        publicPrivacy: PostPrivacy.PUBLIC,
        friendsPrivacy: PostPrivacy.FRIENDS,
        privatePrivacy: PostPrivacy.PRIVATE,
        friendIds: friendIds.length > 0 ? friendIds : ['00000000-0000-0000-0000-000000000000'],
        userId,
      },
    );

    // Приоритет постов от друзей и подписок
    // Если у пользователя есть друзья/подписки - показываем только их посты
    // Если нет - показываем все публичные посты (фильтр по privacy выше)
    if (subscriptionIds.length > 0 || friendIds.length > 0) {
      queryBuilder.andWhere('post.author_id IN (:...relevantUserIds)', {
        relevantUserIds,
      });
    }

    // Фильтрация по категориям (любого уровня: корневые, подкатегории, услуги)
    // Используем closure table для поиска всех потомков выбранных категорий
    if (category_ids && category_ids.length > 0) {
      // Получаем все ID категорий, включая выбранные и всех их потомков
      // Используем подзапрос с closure table
      // Сначала получаем все потомки выбранных категорий через raw query
      // ВАЖНО: колонки в categories_closure называются id_ancestor и id_descendant
      const descendantIdsResult = await this.postRepository.query(
        `SELECT DISTINCT id_descendant 
         FROM categories_closure 
         WHERE id_ancestor = ANY($1::uuid[])`,
        [category_ids],
      );
      
      const descendantIds = descendantIdsResult.map(
        (row: { id_descendant: string }) => row.id_descendant,
      );
      
      // Объединяем выбранные категории с их потомками
      const allCategoryIds = [...category_ids, ...descendantIds];
      
      // Убираем дубликаты
      const uniqueCategoryIds = Array.from(new Set(allCategoryIds));
      
      if (uniqueCategoryIds.length > 0) {
        // Используем оператор && для проверки пересечения массивов
        // TypeORM автоматически обрабатывает массивы в параметрах
        // Но для UUID массивов нужен явный CAST через raw SQL
        // Используем безопасный подход с параметризацией через setParameter
        queryBuilder.andWhere(
          `(post.category_ids IS NOT NULL 
           AND array_length(post.category_ids, 1) > 0
           AND post.category_ids && CAST(:uniqueCategoryIds AS uuid[]))`,
        );
        queryBuilder.setParameter('uniqueCategoryIds', uniqueCategoryIds);
      } else {
        // Если нет категорий для фильтрации, возвращаем пустой результат
        queryBuilder.andWhere('1 = 0');
      }
      // Если category_ids не переданы, показываем все посты (без фильтрации по категориям)
    }

    // Фильтрация по геолокации через PostGIS
    if (lat && lng) {
      const radiusMeters = radius * 1000; // конвертируем км в метры
      queryBuilder
        .andWhere(
          `post.location_geography IS NOT NULL AND ST_DWithin(
            post.location_geography,
            ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)::geography,
            :radiusMeters
          )`,
          { lng, lat, radiusMeters },
        )
        .addSelect(
          `ST_Distance(
            post.location_geography,
            ST_SetSRID(ST_MakePoint(:lng, :lat), 4326)::geography
          ) / 1000`,
          'distance_km',
        );
    }

    // Cursor-based pagination (если указан cursor)
    if (cursor) {
      queryBuilder.andWhere('post.created_at < :cursor', { cursor: new Date(cursor) });
    }

    // Сортировка:
    // 1. Закрепленные посты вверху
    // 2. Свежие посты (по дате)
    // 3. Популярные посты (по engagement: лайки + комментарии + репосты)
    queryBuilder
      .orderBy('post.is_pinned', 'DESC')
      .addOrderBy('post.created_at', 'DESC');

    // Если используется курсор - не используем offset, только limit
    if (cursor) {
      queryBuilder.take(limit);
    } else {
      queryBuilder.skip((page - 1) * limit).take(limit);
    }

    const [posts, total] = await queryBuilder.getManyAndCount();

    // Вычисляем следующий курсор (created_at последнего поста)
    const nextCursor = posts.length > 0
      ? posts[posts.length - 1].created_at.toISOString()
      : null;

    return {
      data: PostsMapper.toDtoArray(posts),
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
        nextCursor,
        hasMore: posts.length === limit,
      },
    };
  }

  async getUserPosts(userId: string, filterDto: FilterPostsDto) {
    const { page = 1, limit = 20, type } = filterDto;

    const queryBuilder = this.postRepository
      .createQueryBuilder('post')
      .leftJoinAndSelect('post.author', 'author')
      .leftJoinAndSelect('post.media', 'media')
      .leftJoinAndSelect('post.repost_of', 'repost_of')
      .where('post.author_id = :userId', { userId })
      .orderBy('post.is_pinned', 'DESC')
      .addOrderBy('post.created_at', 'DESC');

    if (type) {
      queryBuilder.andWhere('post.type = :type', { type });
    }

    const [posts, total] = await queryBuilder
      .skip((page - 1) * limit)
      .take(limit)
      .getManyAndCount();

    return {
      data: PostsMapper.toDtoArray(posts),
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findOne(id: string, userId?: string): Promise<PostResponseDto> {
    const post = await this.postRepository.findOne({
      where: { id },
      relations: ['author', 'media', 'repost_of', 'repost_of.author'],
    });

    if (!post) {
      throw new NotFoundException('Post not found');
    }

    // Проверка приватности поста
    if (post.privacy === PostPrivacy.PRIVATE && post.author_id !== userId) {
      throw new ForbiddenException('Access denied');
    }

    // Проверка доступа к постам "для друзей"
    if (post.privacy === PostPrivacy.FRIENDS && post.author_id !== userId) {
      // Проверяем, является ли пользователь другом автора поста
      const friendship = await this.friendshipRepository.findOne({
        where: [
          {
            requester_id: userId,
            addressee_id: post.author_id,
            status: FriendshipStatus.ACCEPTED,
          },
          {
            requester_id: post.author_id,
            addressee_id: userId,
            status: FriendshipStatus.ACCEPTED,
          },
        ],
      });

      if (!friendship) {
        throw new ForbiddenException('This post is only visible to friends');
      }
    }

    return PostsMapper.toDto(post);
  }

  async update(id: string, userId: string, updatePostDto: UpdatePostDto) {
    const post = await this.postRepository.findOne({ where: { id } });

    if (!post) {
      throw new NotFoundException('Post not found');
    }

    if (post.author_id !== userId) {
      throw new ForbiddenException('You can only update your own posts');
    }

    await this.postRepository.update(id, updatePostDto);

    // Обновить location_geography, если координаты были в updatePostDto
    // (проверяем через any, т.к. UpdatePostDto может не содержать эти поля)
    const updateData = updatePostDto as any;
    if (
      updateData.location_lat !== undefined &&
      updateData.location_lng !== undefined
    ) {
      if (updateData.location_lat && updateData.location_lng) {
        await this.postRepository.query(
          `UPDATE posts 
           SET location_geography = ST_SetSRID(ST_MakePoint($1, $2), 4326)::geography 
           WHERE id = $3`,
          [updateData.location_lng, updateData.location_lat, id],
        );
      } else {
        // Если координаты null, очищаем geography
        await this.postRepository.query(
          `UPDATE posts SET location_geography = NULL WHERE id = $1`,
          [id],
        );
      }
    }

    return this.findOne(id, userId);
  }

  async remove(id: string, userId: string) {
    const post = await this.postRepository.findOne({ where: { id } });

    if (!post) {
      throw new NotFoundException('Post not found');
    }

    if (post.author_id !== userId) {
      throw new ForbiddenException('You can only delete your own posts');
    }

    // Если это репост - уменьшаем счетчик репостов у оригинального поста
    if (post.repost_of_id) {
      await this.postRepository.decrement(
        { id: post.repost_of_id },
        'reposts_count',
        1,
      );
    }

    await this.postRepository.remove(post);

    return { message: 'Post deleted successfully' };
  }

  async pin(id: string, userId: string) {
    const post = await this.postRepository.findOne({ where: { id } });

    if (!post) {
      throw new NotFoundException('Post not found');
    }

    if (post.author_id !== userId) {
      throw new ForbiddenException('You can only pin your own posts');
    }

    // Открепляем все другие посты пользователя
    await this.postRepository.update(
      { author_id: userId, is_pinned: true },
      { is_pinned: false },
    );

    await this.postRepository.update(id, { is_pinned: true });

    return this.findOne(id, userId);
  }

  async unpin(id: string, userId: string) {
    const post = await this.postRepository.findOne({ where: { id } });

    if (!post) {
      throw new NotFoundException('Post not found');
    }

    if (post.author_id !== userId) {
      throw new ForbiddenException('You can only unpin your own posts');
    }

    await this.postRepository.update(id, { is_pinned: false });

    return this.findOne(id, userId);
  }

  async incrementViews(id: string) {
    await this.postRepository.increment({ id }, 'views_count', 1);
    return { message: 'View registered' };
  }
}
