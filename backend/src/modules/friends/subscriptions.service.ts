import {
  BadRequestException,
  ConflictException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { PaginationDto } from '../../common/dto/pagination.dto';
import { User } from '../users/entities/user.entity';
import { CreateSubscriptionDto } from './dto/create-subscription.dto';
import { SubscriptionResponseDto } from './dto/subscription-response.dto';
import { UpdateSubscriptionDto } from './dto/update-subscription.dto';
import { Subscription } from './entities/subscription.entity';

@Injectable()
export class SubscriptionsService {
  constructor(
    @InjectRepository(Subscription)
    private readonly subscriptionRepository: Repository<Subscription>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async create(
    userId: string,
    createSubscriptionDto: CreateSubscriptionDto,
  ): Promise<SubscriptionResponseDto> {
    const { target_id, notifications_enabled = true } = createSubscriptionDto;

    if (userId === target_id) {
      throw new BadRequestException('Cannot subscribe to yourself');
    }

    // Проверка существования пользователя
    const target = await this.userRepository.findOne({
      where: { id: target_id },
    });

    if (!target) {
      throw new NotFoundException('User not found');
    }

    // Проверка на существующую подписку
    const existingSubscription = await this.subscriptionRepository.findOne({
      where: {
        subscriber_id: userId,
        target_id,
      },
    });

    if (existingSubscription) {
      throw new ConflictException('Already subscribed');
    }

    const subscription = this.subscriptionRepository.create({
      subscriber_id: userId,
      target_id,
      notifications_enabled,
    });

    const savedSubscription = await this.subscriptionRepository.save(subscription);

    // Обновляем счетчики
    await this.userRepository.increment({ id: userId }, 'following_count', 1);
    await this.userRepository.increment({ id: target_id }, 'followers_count', 1);

    return this.toResponseDto(savedSubscription);
  }

  async getFollowing(userId: string, paginationDto: PaginationDto) {
    const { page = 1, limit = 20 } = paginationDto;

    const queryBuilder = this.subscriptionRepository
      .createQueryBuilder('subscription')
      .leftJoinAndSelect('subscription.target', 'target')
      .where('subscription.subscriber_id = :userId', { userId })
      .orderBy('subscription.created_at', 'DESC');

    const [subscriptions, total] = await queryBuilder
      .skip((page - 1) * limit)
      .take(limit)
      .getManyAndCount();

    return {
      data: subscriptions,
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async getFollowers(userId: string, paginationDto: PaginationDto) {
    const { page = 1, limit = 20 } = paginationDto;

    const queryBuilder = this.subscriptionRepository
      .createQueryBuilder('subscription')
      .leftJoinAndSelect('subscription.subscriber', 'subscriber')
      .where('subscription.target_id = :userId', { userId })
      .orderBy('subscription.created_at', 'DESC');

    const [subscriptions, total] = await queryBuilder
      .skip((page - 1) * limit)
      .take(limit)
      .getManyAndCount();

    return {
      data: subscriptions,
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async checkSubscription(userId: string, targetId: string): Promise<{ is_following: boolean }> {
    const subscription = await this.subscriptionRepository.findOne({
      where: {
        subscriber_id: userId,
        target_id: targetId,
      },
    });

    return { is_following: subscription !== null };
  }

  async update(
    userId: string,
    targetId: string,
    updateSubscriptionDto: UpdateSubscriptionDto,
  ): Promise<SubscriptionResponseDto> {
    const subscription = await this.subscriptionRepository.findOne({
      where: {
        subscriber_id: userId,
        target_id: targetId,
      },
    });

    if (!subscription) {
      throw new NotFoundException('Subscription not found');
    }

    await this.subscriptionRepository.update(subscription.id, updateSubscriptionDto);

    const updatedSubscription = await this.subscriptionRepository.findOne({
      where: { id: subscription.id },
    });

    return this.toResponseDto(updatedSubscription);
  }

  async remove(userId: string, targetId: string) {
    const subscription = await this.subscriptionRepository.findOne({
      where: {
        subscriber_id: userId,
        target_id: targetId,
      },
    });

    if (!subscription) {
      throw new NotFoundException('Subscription not found');
    }

    await this.subscriptionRepository.remove(subscription);

    // Обновляем счетчики
    await this.userRepository.decrement({ id: userId }, 'following_count', 1);
    await this.userRepository.decrement({ id: targetId }, 'followers_count', 1);

    return { message: 'Unsubscribed successfully' };
  }

  private toResponseDto(subscription: Subscription): SubscriptionResponseDto {
    const dto = new SubscriptionResponseDto();
    dto.id = subscription.id;
    dto.subscriberId = subscription.subscriber_id;
    dto.targetId = subscription.target_id;
    dto.notificationsEnabled = subscription.notifications_enabled;
    dto.createdAt = subscription.created_at;
    return dto;
  }
}
