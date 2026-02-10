import { Test, TestingModule } from '@nestjs/testing';
import { SubscriptionsService } from './subscriptions.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Subscription } from './entities/subscription.entity';
import { User } from '../users/entities/user.entity';
import { Repository } from 'typeorm';
import {
  NotFoundException,
  BadRequestException,
  ConflictException,
} from '@nestjs/common';

describe('SubscriptionsService', () => {
  let service: SubscriptionsService;
  let subscriptionRepository: Repository<Subscription>;
  let userRepository: Repository<User>;

  const mockUser1 = {
    id: 'user-1',
    email: 'user1@example.com',
    phone: '+79001111111',
    first_name: 'John',
    last_name: 'Doe',
    avatar_url: null,
    is_master: false,
    master_profile_completed: false,
    is_verified: false,
    is_premium: false,
    premium_until: null,
    is_active: true,
    last_login_at: null,
    rating: 0,
    reviews_count: 0,
    cancellations_count: 0,
    no_shows_count: 0,
    blacklists_count: 0,
    posts_count: 0,
    friends_count: 0,
    followers_count: 0,
    following_count: 0,
    language: 'en',
    timezone: 'UTC',
    last_location_lat: null,
    last_location_lng: null,
    created_at: new Date(),
    updated_at: new Date(),
  };

  const mockUser2 = {
    id: 'user-2',
    email: 'user2@example.com',
    phone: '+79002222222',
    first_name: 'Jane',
    last_name: 'Smith',
    avatar_url: null,
    is_master: false,
    master_profile_completed: false,
    is_verified: false,
    is_premium: false,
    premium_until: null,
    is_active: true,
    last_login_at: null,
    rating: 0,
    reviews_count: 0,
    cancellations_count: 0,
    no_shows_count: 0,
    blacklists_count: 0,
    posts_count: 0,
    friends_count: 0,
    followers_count: 0,
    following_count: 0,
    language: 'en',
    timezone: 'UTC',
    last_location_lat: null,
    last_location_lng: null,
    created_at: new Date(),
    updated_at: new Date(),
  };

  const mockSubscription = {
    id: 'subscription-1',
    subscriber_id: 'user-1',
    target_id: 'user-2',
    notifications_enabled: true,
    created_at: new Date(),
  };

  const mockSubscriptionRepository = {
    findOne: jest.fn(),
    create: jest.fn(),
    save: jest.fn(),
    update: jest.fn(),
    remove: jest.fn(),
    createQueryBuilder: jest.fn(() => ({
      where: jest.fn().mockReturnThis(),
      leftJoinAndSelect: jest.fn().mockReturnThis(),
      orderBy: jest.fn().mockReturnThis(),
      skip: jest.fn().mockReturnThis(),
      take: jest.fn().mockReturnThis(),
      getManyAndCount: jest.fn().mockResolvedValue([[], 0]),
    })),
  };

  const mockUserRepository = {
    findOne: jest.fn(),
    increment: jest.fn(),
    decrement: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        SubscriptionsService,
        {
          provide: getRepositoryToken(Subscription),
          useValue: mockSubscriptionRepository,
        },
        {
          provide: getRepositoryToken(User),
          useValue: mockUserRepository,
        },
      ],
    }).compile();

    service = module.get<SubscriptionsService>(SubscriptionsService);
    subscriptionRepository = module.get<Repository<Subscription>>(
      getRepositoryToken(Subscription),
    );
    userRepository = module.get<Repository<User>>(getRepositoryToken(User));
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('create', () => {
    it('should create new subscription and increment counters', async () => {
      const createDto = {
        target_id: 'user-2',
        notifications_enabled: true,
      };

      mockUserRepository.findOne.mockResolvedValue(mockUser2);
      mockSubscriptionRepository.findOne.mockResolvedValue(null);
      mockSubscriptionRepository.create.mockReturnValue(mockSubscription);
      mockSubscriptionRepository.save.mockResolvedValue(mockSubscription);
      mockUserRepository.increment.mockResolvedValue(undefined);

      const result = await service.create('user-1', createDto);

      expect(result.id).toEqual('subscription-1');
      expect(result.subscriberId).toEqual('user-1');
      expect(result.targetId).toEqual('user-2');
      expect(result.notificationsEnabled).toBe(true);
      expect(mockSubscriptionRepository.create).toHaveBeenCalledWith({
        subscriber_id: 'user-1',
        target_id: 'user-2',
        notifications_enabled: true,
      });
      expect(mockSubscriptionRepository.save).toHaveBeenCalled();
      expect(mockUserRepository.increment).toHaveBeenCalledTimes(2);
      expect(mockUserRepository.increment).toHaveBeenCalledWith(
        { id: 'user-1' },
        'following_count',
        1,
      );
      expect(mockUserRepository.increment).toHaveBeenCalledWith(
        { id: 'user-2' },
        'followers_count',
        1,
      );
    });

    it('should throw BadRequestException if subscribing to yourself', async () => {
      const createDto = {
        target_id: 'user-1',
      };

      await expect(service.create('user-1', createDto)).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should throw NotFoundException if target user not found', async () => {
      const createDto = {
        target_id: 'non-existent',
      };

      mockUserRepository.findOne.mockResolvedValue(null);

      await expect(service.create('user-1', createDto)).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw ConflictException if already subscribed', async () => {
      const createDto = {
        target_id: 'user-2',
      };

      mockUserRepository.findOne.mockResolvedValue(mockUser2);
      mockSubscriptionRepository.findOne.mockResolvedValue(mockSubscription);

      await expect(service.create('user-1', createDto)).rejects.toThrow(
        ConflictException,
      );
    });

    it('should use default notifications_enabled=true if not provided', async () => {
      const createDto = {
        target_id: 'user-2',
      };

      mockUserRepository.findOne.mockResolvedValue(mockUser2);
      mockSubscriptionRepository.findOne.mockResolvedValue(null);
      mockSubscriptionRepository.create.mockReturnValue(mockSubscription);
      mockSubscriptionRepository.save.mockResolvedValue(mockSubscription);
      mockUserRepository.increment.mockResolvedValue(undefined);

      await service.create('user-1', createDto);

      expect(mockSubscriptionRepository.create).toHaveBeenCalledWith({
        subscriber_id: 'user-1',
        target_id: 'user-2',
        notifications_enabled: true,
      });
    });
  });

  describe('getFollowing', () => {
    it('should return paginated following list', async () => {
      const mockSubscriptionWithTarget = {
        ...mockSubscription,
        target: mockUser2,
      };

      mockSubscriptionRepository.createQueryBuilder.mockReturnValueOnce({
        where: jest.fn().mockReturnThis(),
        leftJoinAndSelect: jest.fn().mockReturnThis(),
        orderBy: jest.fn().mockReturnThis(),
        skip: jest.fn().mockReturnThis(),
        take: jest.fn().mockReturnThis(),
        getManyAndCount: jest.fn().mockResolvedValue([[mockSubscriptionWithTarget], 1]),
      });

      const result = await service.getFollowing('user-1', {} as any);

      expect(result).toHaveProperty('data');
      expect(result).toHaveProperty('meta');
      expect(result.data).toHaveLength(1);
      expect(result.meta.total).toBe(1);
    });
  });

  describe('getFollowers', () => {
    it('should return paginated followers list', async () => {
      const mockSubscriptionWithSubscriber = {
        ...mockSubscription,
        subscriber: mockUser1,
      };

      mockSubscriptionRepository.createQueryBuilder.mockReturnValueOnce({
        where: jest.fn().mockReturnThis(),
        leftJoinAndSelect: jest.fn().mockReturnThis(),
        orderBy: jest.fn().mockReturnThis(),
        skip: jest.fn().mockReturnThis(),
        take: jest.fn().mockReturnThis(),
        getManyAndCount: jest.fn().mockResolvedValue([[mockSubscriptionWithSubscriber], 1]),
      });

      const result = await service.getFollowers('user-2', {} as any);

      expect(result).toHaveProperty('data');
      expect(result).toHaveProperty('meta');
      expect(result.data).toHaveLength(1);
      expect(result.meta.total).toBe(1);
    });
  });

  describe('update', () => {
    it('should update subscription settings', async () => {
      const updateDto = {
        notifications_enabled: false,
      };

      const updatedSubscription = {
        ...mockSubscription,
        notifications_enabled: false,
      };

      mockSubscriptionRepository.findOne
        .mockResolvedValueOnce(mockSubscription) // First call to check existence
        .mockResolvedValueOnce(updatedSubscription); // Second call to return updated
      mockSubscriptionRepository.update.mockResolvedValue(undefined);

      const result = await service.update('user-1', 'user-2', updateDto);

      expect(result.notificationsEnabled).toBe(false);
      expect(mockSubscriptionRepository.update).toHaveBeenCalledWith(
        mockSubscription.id,
        updateDto,
      );
    });

    it('should throw NotFoundException if subscription not found', async () => {
      mockSubscriptionRepository.findOne.mockResolvedValue(null);

      await expect(
        service.update('user-1', 'user-2', { notifications_enabled: false }),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('remove', () => {
    it('should remove subscription and decrement counters', async () => {
      mockSubscriptionRepository.findOne.mockResolvedValue(mockSubscription);
      mockSubscriptionRepository.remove.mockResolvedValue(mockSubscription);
      mockUserRepository.decrement.mockResolvedValue(undefined);

      const result = await service.remove('user-1', 'user-2');

      expect(result).toEqual({ message: 'Unsubscribed successfully' });
      expect(mockSubscriptionRepository.remove).toHaveBeenCalledWith(
        mockSubscription,
      );
      expect(mockUserRepository.decrement).toHaveBeenCalledTimes(2);
      expect(mockUserRepository.decrement).toHaveBeenCalledWith(
        { id: 'user-1' },
        'following_count',
        1,
      );
      expect(mockUserRepository.decrement).toHaveBeenCalledWith(
        { id: 'user-2' },
        'followers_count',
        1,
      );
    });

    it('should throw NotFoundException if subscription not found', async () => {
      mockSubscriptionRepository.findOne.mockResolvedValue(null);

      await expect(service.remove('user-1', 'user-2')).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});
