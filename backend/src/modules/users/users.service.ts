import {
  Injectable,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { UpdateUserDto } from './dto/update-user.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  /**
   * Получить текущего пользователя по ID
   */
  async findById(id: string): Promise<User> {
    const user = await this.userRepository.findOne({
      where: { id },
    });

    if (!user) {
      throw new NotFoundException('Пользователь не найден');
    }

    return user;
  }

  /**
   * Получить пользователя по email
   */
  async findByEmail(email: string): Promise<User | null> {
    return this.userRepository.findOne({
      where: { email },
    });
  }

  /**
   * Обновить профиль пользователя
   */
  async update(id: string, updateUserDto: UpdateUserDto): Promise<User> {
    const user = await this.findById(id);

    // Проверка уникальности телефона (если меняется)
    if (updateUserDto.phone && updateUserDto.phone !== user.phone) {
      const existingUser = await this.userRepository.findOne({
        where: { phone: updateUserDto.phone },
      });

      if (existingUser && existingUser.id !== id) {
        throw new ConflictException(
          'Пользователь с таким номером телефона уже существует',
        );
      }
    }

    // Обновление полей
    Object.assign(user, updateUserDto);

    return this.userRepository.save(user);
  }

  /**
   * Обновить аватар пользователя
   */
  async updateAvatar(id: string, avatarUrl: string): Promise<User> {
    const user = await this.findById(id);
    user.avatar_url = avatarUrl;
    return this.userRepository.save(user);
  }

  /**
   * Удалить пользователя (мягкое удаление, если нужно)
   */
  async remove(id: string): Promise<void> {
    const user = await this.findById(id);
    await this.userRepository.remove(user);
  }

  /**
   * Получить статистику пользователя
   */
  async getUserStats(id: string) {
    const user = await this.findById(id);

    return {
      posts_count: user.posts_count,
      friends_count: user.friends_count,
      followers_count: user.followers_count,
      following_count: user.following_count,
      reviews_count: user.reviews_count,
      rating: user.rating,
      is_master: user.is_master,
      is_verified: user.is_verified,
      is_premium: user.is_premium,
    };
  }
}
