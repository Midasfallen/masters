import {
  Injectable,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Repost } from './entities/repost.entity';
import { CreateRepostDto } from './dto/create-repost.dto';
import { Post } from '../posts/entities/post.entity';

@Injectable()
export class RepostsService {
  constructor(
    @InjectRepository(Repost)
    private readonly repostRepository: Repository<Repost>,
    @InjectRepository(Post)
    private readonly postRepository: Repository<Post>,
  ) {}

  async create(userId: string, createRepostDto: CreateRepostDto) {
    const { post_id, comment } = createRepostDto;

    // Проверка существования поста
    const post = await this.postRepository.findOne({ where: { id: post_id } });

    if (!post) {
      throw new NotFoundException('Post not found');
    }

    // Проверка на дубликат
    const existingRepost = await this.repostRepository.findOne({
      where: {
        user_id: userId,
        post_id,
      },
    });

    if (existingRepost) {
      throw new ConflictException('Already reposted');
    }

    const repost = this.repostRepository.create({
      user_id: userId,
      post_id,
      comment,
    });

    const savedRepost = await this.repostRepository.save(repost);

    // Увеличиваем счетчик репостов
    await this.postRepository.increment({ id: post_id }, 'reposts_count', 1);

    return savedRepost;
  }

  async remove(userId: string, postId: string) {
    const repost = await this.repostRepository.findOne({
      where: {
        user_id: userId,
        post_id: postId,
      },
    });

    if (!repost) {
      throw new NotFoundException('Repost not found');
    }

    await this.repostRepository.remove(repost);

    // Уменьшаем счетчик репостов
    await this.postRepository.decrement({ id: postId }, 'reposts_count', 1);

    return { message: 'Repost removed successfully' };
  }
}
