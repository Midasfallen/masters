import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Post, PostType, PostPrivacy } from './entities/post.entity';
import { PostMedia } from './entities/post-media.entity';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { FilterPostsDto } from './dto/filter-posts.dto';
import { Friendship, FriendshipStatus } from '../friends/entities/friendship.entity';
import { Subscription } from '../friends/entities/subscription.entity';

@Injectable()
export class PostsService {
  constructor(
    @InjectRepository(Post)
    private readonly postRepository: Repository<Post>,
    @InjectRepository(PostMedia)
    private readonly postMediaRepository: Repository<PostMedia>,
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
    const { page = 1, limit = 20, lat, lng, radius = 10, cursor, category_ids } = filterDto;

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
      .leftJoinAndSelect('repost_of.author', 'repost_author');

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

    // Фильтрация по категориям мастеров
    if (category_ids && category_ids.length > 0) {
      queryBuilder
        .leftJoin('author.master_profile', 'master_profile')
        .leftJoin('master_profile.categories', 'category')
        .andWhere('category.id IN (:...category_ids)', { category_ids });
    }

    // Фильтрация по геолокации
    if (lat && lng) {
      queryBuilder.andWhere(
        `(6371 * acos(cos(radians(:lat)) * cos(radians(post.location_lat)) * cos(radians(post.location_lng) - radians(:lng)) + sin(radians(:lat)) * sin(radians(post.location_lat)))) <= :radius`,
        { lat, lng, radius },
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
      data: posts,
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
      data: posts,
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findOne(id: string, userId?: string) {
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

    return post;
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
