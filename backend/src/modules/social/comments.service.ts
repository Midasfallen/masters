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
import { Post } from '../posts/entities/post.entity';

@Injectable()
export class CommentsService {
  constructor(
    @InjectRepository(Comment)
    private readonly commentRepository: Repository<Comment>,
    @InjectRepository(Post)
    private readonly postRepository: Repository<Post>,
  ) {}

  async create(userId: string, createCommentDto: CreateCommentDto) {
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

    return this.findOne(savedComment.id);
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
      data: comments,
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findOne(id: string) {
    const comment = await this.commentRepository.findOne({
      where: { id },
      relations: ['author'],
    });

    if (!comment) {
      throw new NotFoundException('Comment not found');
    }

    return comment;
  }

  async update(id: string, userId: string, updateCommentDto: UpdateCommentDto) {
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

    await this.commentRepository.remove(comment);

    return { message: 'Comment deleted successfully' };
  }
}
