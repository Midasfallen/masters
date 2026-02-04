import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Comment } from './entities/comment.entity';
import { CreateCommentDto } from './dto/create-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';
import { FilterCommentsDto } from './dto/filter-comments.dto';
import { CommentResponseDto } from './dto/comment-response.dto';
import { SocialMapper } from './social.mapper';
import { Post } from '../posts/entities/post.entity';
import { AppWebSocketGateway } from '../websocket/websocket.gateway';
import { CacheService } from '../../common/services/cache.service';

@Injectable()
export class CommentsService {
  constructor(
    @InjectRepository(Comment)
    private readonly commentRepository: Repository<Comment>,
    @InjectRepository(Post)
    private readonly postRepository: Repository<Post>,
    private readonly websocketGateway: AppWebSocketGateway,
    private readonly cacheService: CacheService,
  ) {}

  async create(userId: string, createCommentDto: CreateCommentDto): Promise<CommentResponseDto> {
    // Проверка существования поста
    const post = await this.postRepository.findOne({
      where: { id: createCommentDto.post_id },
    });

    if (!post) {
      throw new NotFoundException('Post not found');
    }

    if (post.comments_disabled) {
      throw new BadRequestException('Comments are disabled for this post');
    }

    // Проверка родительского комментария, если указан
    if (createCommentDto.parent_comment_id) {
      const parentComment = await this.commentRepository.findOne({
        where: { id: createCommentDto.parent_comment_id },
      });

      if (!parentComment) {
        throw new NotFoundException('Parent comment not found');
      }

      if (parentComment.post_id !== createCommentDto.post_id) {
        throw new BadRequestException('Parent comment belongs to different post');
      }
    }

    const comment = this.commentRepository.create({
      ...createCommentDto,
      author_id: userId,
    });

    const savedComment = await this.commentRepository.save(comment);

    // Увеличиваем счетчики
    await this.postRepository.increment(
      { id: createCommentDto.post_id },
      'comments_count',
      1,
    );

    if (createCommentDto.parent_comment_id) {
      await this.commentRepository.increment(
        { id: createCommentDto.parent_comment_id },
        'replies_count',
        1,
      );
    }

    // Получаем полный комментарий с автором для WebSocket
    const fullComment = await this.commentRepository.findOne({
      where: { id: savedComment.id },
      relations: ['author'],
    });

    // Отправляем WebSocket событие
    const updatedPost = await this.postRepository.findOne({
      where: { id: createCommentDto.post_id },
      relations: ['author'],
    });

    if (updatedPost && fullComment) {
      this.websocketGateway.broadcastPostCommented(createCommentDto.post_id, {
        comment_id: fullComment.id,
        user_id: userId,
        user_name: fullComment.author
          ? `${fullComment.author.first_name} ${fullComment.author.last_name}`
          : 'Unknown User',
        user_avatar: fullComment.author?.avatar_url || null,
        content: fullComment.content,
        comments_count: updatedPost.comments_count,
        is_reply: !!createCommentDto.parent_comment_id,
        parent_comment_id: createCommentDto.parent_comment_id || null,
        timestamp: new Date().toISOString(),
      });
    }

    // Инвалидируем кэш поста и фида, чтобы счётчики комментариев обновились везде
    await this.cacheService.delByPattern(`post:${createCommentDto.post_id}:*`);
    await this.cacheService.delByPattern('feed:*');

    return SocialMapper.toCommentDto(fullComment);
  }

  async findAll(filterDto: FilterCommentsDto) {
    const { post_id, parent_comment_id, page = 1, limit = 20 } = filterDto;

    const queryBuilder = this.commentRepository
      .createQueryBuilder('comment')
      .leftJoinAndSelect('comment.author', 'author')
      .where('comment.post_id = :post_id', { post_id })
      .orderBy('comment.created_at', 'ASC');

    // Фильтрация по родительскому комментарию
    if (parent_comment_id) {
      queryBuilder.andWhere('comment.parent_comment_id = :parent_comment_id', {
        parent_comment_id,
      });
    } else {
      // Показываем только комментарии верхнего уровня
      queryBuilder.andWhere('comment.parent_comment_id IS NULL');
    }

    const [comments, total] = await queryBuilder
      .skip((page - 1) * limit)
      .take(limit)
      .getManyAndCount();

    return {
      data: SocialMapper.toCommentDtoArray(comments),
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findOne(id: string): Promise<CommentResponseDto> {
    const comment = await this.commentRepository.findOne({
      where: { id },
      relations: ['author'],
    });

    if (!comment) {
      throw new NotFoundException('Comment not found');
    }

    return SocialMapper.toCommentDto(comment);
  }

  async update(id: string, userId: string, updateCommentDto: UpdateCommentDto): Promise<CommentResponseDto> {
    const comment = await this.commentRepository.findOne({ where: { id } });

    if (!comment) {
      throw new NotFoundException('Comment not found');
    }

    if (comment.author_id !== userId) {
      throw new ForbiddenException('You can only update your own comments');
    }

    await this.commentRepository.update(id, {
      ...updateCommentDto,
      is_edited: true,
    });

    return this.findOne(id);
  }

  async remove(id: string, userId: string) {
    const comment = await this.commentRepository.findOne({ where: { id } });

    if (!comment) {
      throw new NotFoundException('Comment not found');
    }

    if (comment.author_id !== userId) {
      throw new ForbiddenException('You can only delete your own comments');
    }

    // Уменьшаем счетчики
    await this.postRepository.decrement(
      { id: comment.post_id },
      'comments_count',
      1,
    );

    if (comment.parent_comment_id) {
      await this.commentRepository.decrement(
        { id: comment.parent_comment_id },
        'replies_count',
        1,
      );
    }

    // If comment has replies, delete them first (cascade)
    if (comment.replies_count > 0) {
      await this.commentRepository.delete({ parent_comment_id: comment.id });
    }

    await this.commentRepository.remove(comment);

    // Инвалидируем кэш поста и фида, чтобы счётчики комментариев обновились везде
    await this.cacheService.delByPattern(`post:${comment.post_id}:*`);
    await this.cacheService.delByPattern('feed:*');

    return { message: 'Comment deleted successfully' };
  }
}
