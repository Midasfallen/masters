import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Post, PostType } from './entities/post.entity';
import { PostMedia } from './entities/post-media.entity';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { FilterPostsDto } from './dto/filter-posts.dto';

@Injectable()
export class PostsService {
  constructor(
    @InjectRepository(Post)
    private readonly postRepository: Repository<Post>,
    @InjectRepository(PostMedia)
    private readonly postMediaRepository: Repository<PostMedia>,
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
    const { page = 1, limit = 20, lat, lng, radius = 10 } = filterDto;

    const queryBuilder = this.postRepository
      .createQueryBuilder('post')
      .leftJoinAndSelect('post.author', 'author')
      .leftJoinAndSelect('post.media', 'media')
      .leftJoinAndSelect('post.repost_of', 'repost_of')
      .leftJoinAndSelect('repost_of.author', 'repost_author')
      .orderBy('post.created_at', 'DESC');

    // TODO: Реализовать алгоритмический feed на основе:
    // - Друзей пользователя
    // - Подписок
    // - Взаимодействий (лайки, комментарии)
    // - Времени публикации (свежесть)
    // - Популярности (engagement rate)

    // Временно показываем все публичные посты
    queryBuilder.andWhere('post.privacy = :privacy', { privacy: 'public' });

    // Фильтрация по геолокации
    if (lat && lng) {
      queryBuilder.andWhere(
        `(6371 * acos(cos(radians(:lat)) * cos(radians(post.location_lat)) * cos(radians(post.location_lng) - radians(:lng)) + sin(radians(:lat)) * sin(radians(post.location_lat)))) <= :radius`,
        { lat, lng, radius },
      );
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

    // TODO: Проверка приватности поста
    // if (post.privacy === 'private' && post.author_id !== userId) {
    //   throw new ForbiddenException('Access denied');
    // }

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
