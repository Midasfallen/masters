import {
  Injectable,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Like, LikableType } from './entities/like.entity';
import { CreateLikeDto } from './dto/create-like.dto';
import { Post } from '../posts/entities/post.entity';
import { Comment } from './entities/comment.entity';
import { AppWebSocketGateway } from '../websocket/websocket.gateway';

@Injectable()
export class LikesService {
  constructor(
    @InjectRepository(Like)
    private readonly likeRepository: Repository<Like>,
    @InjectRepository(Post)
    private readonly postRepository: Repository<Post>,
    @InjectRepository(Comment)
    private readonly commentRepository: Repository<Comment>,
    private readonly websocketGateway: AppWebSocketGateway,
  ) {}

  async create(userId: string, createLikeDto: CreateLikeDto) {
    const { likable_type, likable_id } = createLikeDto;

    // Проверка существования объекта
    await this.validateLikableExists(likable_type, likable_id);

    // Проверка на дубликат
    const existingLike = await this.likeRepository.findOne({
      where: {
        user_id: userId,
        likable_type,
        likable_id,
      },
    });

    if (existingLike) {
      throw new ConflictException('Already liked');
    }

    const like = this.likeRepository.create({
      user_id: userId,
      likable_type,
      likable_id,
    });

    const savedLike = await this.likeRepository.save(like);

    // Увеличиваем счетчик лайков
    await this.incrementLikesCount(likable_type, likable_id);

    // Отправляем WebSocket событие для постов
    if (likable_type === LikableType.POST) {
      const post = await this.postRepository.findOne({
        where: { id: likable_id },
        relations: ['author'],
      });

      if (post) {
        this.websocketGateway.broadcastPostLiked(likable_id, {
          user_id: userId,
          user_name: 'User', // TODO: получить имя из userId
          likes_count: post.likes_count + 1,
          timestamp: new Date().toISOString(),
        });
      }
    }

    return savedLike;
  }

  async remove(userId: string, likableType: string, likableId: string) {
    const like = await this.likeRepository.findOne({
      where: {
        user_id: userId,
        likable_type: likableType as LikableType,
        likable_id: likableId,
      },
    });

    if (!like) {
      throw new NotFoundException('Like not found');
    }

    await this.likeRepository.remove(like);

    // Уменьшаем счетчик лайков
    await this.decrementLikesCount(likableType as LikableType, likableId);

    return { message: 'Like removed successfully' };
  }

  private async validateLikableExists(type: LikableType, id: string) {
    if (type === LikableType.POST) {
      const post = await this.postRepository.findOne({ where: { id } });
      if (!post) {
        throw new NotFoundException('Post not found');
      }
    } else if (type === LikableType.COMMENT) {
      const comment = await this.commentRepository.findOne({ where: { id } });
      if (!comment) {
        throw new NotFoundException('Comment not found');
      }
    }
  }

  private async incrementLikesCount(type: LikableType, id: string) {
    if (type === LikableType.POST) {
      await this.postRepository.increment({ id }, 'likes_count', 1);
    } else if (type === LikableType.COMMENT) {
      await this.commentRepository.increment({ id }, 'likes_count', 1);
    }
  }

  private async decrementLikesCount(type: LikableType, id: string) {
    if (type === LikableType.POST) {
      await this.postRepository.decrement({ id }, 'likes_count', 1);
    } else if (type === LikableType.COMMENT) {
      await this.commentRepository.decrement({ id }, 'likes_count', 1);
    }
  }
}
