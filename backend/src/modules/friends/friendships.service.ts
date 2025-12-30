import {
  Injectable,
  NotFoundException,
  ConflictException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Friendship, FriendshipStatus } from './entities/friendship.entity';
import { CreateFriendshipDto } from './dto/create-friendship.dto';
import { FilterFriendshipsDto } from './dto/filter-friendships.dto';
import { User } from '../users/entities/user.entity';

@Injectable()
export class FriendshipsService {
  constructor(
    @InjectRepository(Friendship)
    private readonly friendshipRepository: Repository<Friendship>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async create(userId: string, createFriendshipDto: CreateFriendshipDto) {
    const { addressee_id } = createFriendshipDto;

    if (userId === addressee_id) {
      throw new BadRequestException('Cannot send friend request to yourself');
    }

    // Проверка существования адресата
    const addressee = await this.userRepository.findOne({
      where: { id: addressee_id },
    });

    if (!addressee) {
      throw new NotFoundException('User not found');
    }

    // Проверка на существующий запрос
    const existingFriendship = await this.friendshipRepository.findOne({
      where: [
        { requester_id: userId, addressee_id },
        { requester_id: addressee_id, addressee_id: userId },
      ],
    });

    if (existingFriendship) {
      if (existingFriendship.status === FriendshipStatus.BLOCKED) {
        throw new ForbiddenException('Cannot send request to blocked user');
      }
      throw new ConflictException('Friendship request already exists');
    }

    const friendship = this.friendshipRepository.create({
      requester_id: userId,
      addressee_id,
      status: FriendshipStatus.PENDING,
    });

    return this.friendshipRepository.save(friendship);
  }

  async findAll(userId: string, filterDto: FilterFriendshipsDto) {
    const { status = FriendshipStatus.ACCEPTED, page = 1, limit = 20 } = filterDto;

    const queryBuilder = this.friendshipRepository
      .createQueryBuilder('friendship')
      .leftJoinAndSelect('friendship.requester', 'requester')
      .leftJoinAndSelect('friendship.addressee', 'addressee')
      .where('friendship.status = :status', { status })
      .andWhere(
        '(friendship.requester_id = :userId OR friendship.addressee_id = :userId)',
        { userId },
      )
      .orderBy('friendship.updated_at', 'DESC');

    const [friendships, total] = await queryBuilder
      .skip((page - 1) * limit)
      .take(limit)
      .getManyAndCount();

    return {
      data: friendships,
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async getIncoming(userId: string, filterDto: FilterFriendshipsDto) {
    const { page = 1, limit = 20 } = filterDto;

    const queryBuilder = this.friendshipRepository
      .createQueryBuilder('friendship')
      .leftJoinAndSelect('friendship.requester', 'requester')
      .where('friendship.addressee_id = :userId', { userId })
      .andWhere('friendship.status = :status', { status: FriendshipStatus.PENDING })
      .orderBy('friendship.created_at', 'DESC');

    const [friendships, total] = await queryBuilder
      .skip((page - 1) * limit)
      .take(limit)
      .getManyAndCount();

    return {
      data: friendships,
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async getOutgoing(userId: string, filterDto: FilterFriendshipsDto) {
    const { page = 1, limit = 20 } = filterDto;

    const queryBuilder = this.friendshipRepository
      .createQueryBuilder('friendship')
      .leftJoinAndSelect('friendship.addressee', 'addressee')
      .where('friendship.requester_id = :userId', { userId })
      .andWhere('friendship.status = :status', { status: FriendshipStatus.PENDING })
      .orderBy('friendship.created_at', 'DESC');

    const [friendships, total] = await queryBuilder
      .skip((page - 1) * limit)
      .take(limit)
      .getManyAndCount();

    return {
      data: friendships,
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async accept(id: string, userId: string) {
    const friendship = await this.friendshipRepository.findOne({
      where: { id },
    });

    if (!friendship) {
      throw new NotFoundException('Friendship request not found');
    }

    if (friendship.addressee_id !== userId) {
      throw new ForbiddenException('Only addressee can accept the request');
    }

    if (friendship.status !== FriendshipStatus.PENDING) {
      throw new BadRequestException('Request is not pending');
    }

    friendship.status = FriendshipStatus.ACCEPTED;
    await this.friendshipRepository.save(friendship);

    // Обновляем счетчики друзей
    await this.userRepository.increment({ id: friendship.requester_id }, 'friends_count', 1);
    await this.userRepository.increment({ id: friendship.addressee_id }, 'friends_count', 1);

    return friendship;
  }

  async decline(id: string, userId: string) {
    const friendship = await this.friendshipRepository.findOne({
      where: { id },
    });

    if (!friendship) {
      throw new NotFoundException('Friendship request not found');
    }

    if (friendship.addressee_id !== userId) {
      throw new ForbiddenException('Only addressee can decline the request');
    }

    if (friendship.status !== FriendshipStatus.PENDING) {
      throw new BadRequestException('Request is not pending');
    }

    friendship.status = FriendshipStatus.DECLINED;
    await this.friendshipRepository.save(friendship);

    return friendship;
  }

  async remove(id: string, userId: string) {
    const friendship = await this.friendshipRepository.findOne({
      where: { id },
    });

    if (!friendship) {
      throw new NotFoundException('Friendship not found');
    }

    if (friendship.requester_id !== userId && friendship.addressee_id !== userId) {
      throw new ForbiddenException('Access denied');
    }

    // Если дружба была принята, уменьшаем счетчики
    if (friendship.status === FriendshipStatus.ACCEPTED) {
      await this.userRepository.decrement({ id: friendship.requester_id }, 'friends_count', 1);
      await this.userRepository.decrement({ id: friendship.addressee_id }, 'friends_count', 1);
    }

    await this.friendshipRepository.remove(friendship);

    return { message: 'Friendship removed successfully' };
  }

  async block(id: string, userId: string) {
    // Можем заблокировать либо существующего друга, либо создать новую запись
    const existingFriendship = await this.friendshipRepository.findOne({
      where: [
        { requester_id: userId, addressee_id: id },
        { requester_id: id, addressee_id: userId },
      ],
    });

    if (existingFriendship) {
      // Если дружба была принята, уменьшаем счетчики
      if (existingFriendship.status === FriendshipStatus.ACCEPTED) {
        await this.userRepository.decrement({ id: existingFriendship.requester_id }, 'friends_count', 1);
        await this.userRepository.decrement({ id: existingFriendship.addressee_id }, 'friends_count', 1);
      }

      existingFriendship.status = FriendshipStatus.BLOCKED;
      existingFriendship.requester_id = userId; // Блокирующий становится requester
      existingFriendship.addressee_id = id; // Заблокированный - addressee

      return this.friendshipRepository.save(existingFriendship);
    } else {
      // Создаем новую запись о блокировке
      const friendship = this.friendshipRepository.create({
        requester_id: userId,
        addressee_id: id,
        status: FriendshipStatus.BLOCKED,
      });

      return this.friendshipRepository.save(friendship);
    }
  }
}
