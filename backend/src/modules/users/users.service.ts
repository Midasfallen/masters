import {
  Injectable,
  NotFoundException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from './entities/user.entity';
import { UpdateUserDto } from './dto/update-user.dto';
import { UserResponseDto } from './dto/user-response.dto';
import { UsersMapper } from './users.mapper';
import { SearchService } from '../search/search.service';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
    private readonly searchService: SearchService,
  ) {}

  /**
   * Получить текущего пользователя по ID
   */
  async findById(id: string): Promise<UserResponseDto> {
    const user = await this.userRepository.findOne({
      where: { id },
    });

    if (!user) {
      throw new NotFoundException('Пользователь не найден');
    }

    return UsersMapper.toDto(user);
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
  async update(id: string, updateUserDto: UpdateUserDto): Promise<UserResponseDto> {
    const user = await this.userRepository.findOne({ where: { id } });

    if (!user) {
      throw new NotFoundException('Пользователь не найден');
    }

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
    const updated = await this.userRepository.save(user);

    // Обновление в Meilisearch
    await this.searchService.indexUser(updated.id);

    return UsersMapper.toDto(updated);
  }

  /**
   * Обновить аватар пользователя
   */
  async updateAvatar(id: string, avatarUrl: string): Promise<UserResponseDto> {
    const user = await this.userRepository.findOne({ where: { id } });

    if (!user) {
      throw new NotFoundException('Пользователь не найден');
    }

    user.avatar_url = avatarUrl;
    const updated = await this.userRepository.save(user);

    // Обновление в Meilisearch
    await this.searchService.indexUser(updated.id);

    return UsersMapper.toDto(updated);
  }

  /**
   * Удалить пользователя (мягкое удаление, если нужно)
   */
  async remove(id: string): Promise<void> {
    const user = await this.userRepository.findOne({ where: { id } });

    if (!user) {
      throw new NotFoundException('Пользователь не найден');
    }

    await this.userRepository.remove(user);
  }

  /**
   * Получить статистику пользователя
   */
  async getUserStats(id: string) {
    const user = await this.userRepository.findOne({ where: { id } });

    if (!user) {
      throw new NotFoundException('Пользователь не найден');
    }

    return {
      postsCount: user.posts_count,
      friendsCount: user.friends_count,
      followersCount: user.followers_count,
      followingCount: user.following_count,
      reviewsCount: user.reviews_count,
      rating: user.rating,
      isMaster: user.is_master,
      isVerified: user.is_verified,
      isPremium: user.is_premium,
    };
  }
}
