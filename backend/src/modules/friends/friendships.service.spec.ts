import { Test, TestingModule } from '@nestjs/testing';
import { FriendshipsService } from './friendships.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Friendship, FriendshipStatus } from './entities/friendship.entity';
import { User } from '../users/entities/user.entity';
import { Repository } from 'typeorm';
import {
  NotFoundException,
  BadRequestException,
  ConflictException,
  ForbiddenException,
} from '@nestjs/common';

describe('FriendshipsService', () => {
  let service: FriendshipsService;
  let friendshipRepository: Repository<Friendship>;
  let userRepository: Repository<User>;

  const mockUser1 = {
    id: 'user-1',
    email: 'user1@example.com',
    first_name: 'John',
    last_name: 'Doe',
    friends_count: 0,
  };

  const mockUser2 = {
    id: 'user-2',
    email: 'user2@example.com',
    first_name: 'Jane',
    last_name: 'Smith',
    friends_count: 0,
  };

  const mockFriendship = {
    id: 'friendship-1',
    requester_id: 'user-1',
    addressee_id: 'user-2',
    status: FriendshipStatus.PENDING,
    created_at: new Date(),
    updated_at: new Date(),
  };

  const mockFriendshipRepository = {
    findOne: jest.fn(),
    find: jest.fn(),
    create: jest.fn(),
    save: jest.fn(),
    remove: jest.fn(),
    createQueryBuilder: jest.fn(() => ({
      where: jest.fn().mockReturnThis(),
      andWhere: jest.fn().mockReturnThis(),
      orderBy: jest.fn().mockReturnThis(),
      leftJoinAndSelect: jest.fn().mockReturnThis(),
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
        FriendshipsService,
        {
          provide: getRepositoryToken(Friendship),
          useValue: mockFriendshipRepository,
        },
        {
          provide: getRepositoryToken(User),
          useValue: mockUserRepository,
        },
      ],
    }).compile();

    service = module.get<FriendshipsService>(FriendshipsService);
    friendshipRepository = module.get<Repository<Friendship>>(
      getRepositoryToken(Friendship),
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
    it('should create new friendship request', async () => {
      const createDto = { addressee_id: 'user-2' };

      mockUserRepository.findOne.mockResolvedValue(mockUser2);
      mockFriendshipRepository.findOne.mockResolvedValue(null);
      mockFriendshipRepository.create.mockReturnValue(mockFriendship);
      mockFriendshipRepository.save.mockResolvedValue(mockFriendship);

      const result = await service.create('user-1', createDto);

      expect(result).toEqual(mockFriendship);
      expect(mockFriendshipRepository.create).toHaveBeenCalledWith({
        requester_id: 'user-1',
        addressee_id: 'user-2',
        status: FriendshipStatus.PENDING,
      });
      expect(mockFriendshipRepository.save).toHaveBeenCalled();
    });

    it('should throw BadRequestException if sending request to yourself', async () => {
      const createDto = { addressee_id: 'user-1' };

      await expect(service.create('user-1', createDto)).rejects.toThrow(
        BadRequestException,
      );
    });

    it('should throw NotFoundException if addressee not found', async () => {
      const createDto = { addressee_id: 'non-existent' };

      mockUserRepository.findOne.mockResolvedValue(null);

      await expect(service.create('user-1', createDto)).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw ConflictException if friendship already exists', async () => {
      const createDto = { addressee_id: 'user-2' };

      mockUserRepository.findOne.mockResolvedValue(mockUser2);
      mockFriendshipRepository.findOne.mockResolvedValue(mockFriendship);

      await expect(service.create('user-1', createDto)).rejects.toThrow(
        ConflictException,
      );
    });

    it('should throw ForbiddenException if user is blocked', async () => {
      const createDto = { addressee_id: 'user-2' };

      mockUserRepository.findOne.mockResolvedValue(mockUser2);
      mockFriendshipRepository.findOne.mockResolvedValue({
        ...mockFriendship,
        status: FriendshipStatus.BLOCKED,
      });

      await expect(service.create('user-1', createDto)).rejects.toThrow(
        ForbiddenException,
      );
    });
  });

  describe('findAll', () => {
    it('should return paginated friendships', async () => {
      const mockFriendships = [mockFriendship];

      mockFriendshipRepository.createQueryBuilder.mockReturnValueOnce({
        where: jest.fn().mockReturnThis(),
        andWhere: jest.fn().mockReturnThis(),
        orderBy: jest.fn().mockReturnThis(),
        leftJoinAndSelect: jest.fn().mockReturnThis(),
        skip: jest.fn().mockReturnThis(),
        take: jest.fn().mockReturnThis(),
        getManyAndCount: jest.fn().mockResolvedValue([mockFriendships, 1]),
      });

      const result = await service.findAll('user-1', {} as any);

      expect(result).toHaveProperty('data');
      expect(result).toHaveProperty('meta');
      expect(result.data).toEqual(mockFriendships);
      expect(result.meta.total).toBe(1);
    });
  });

  describe('getIncoming', () => {
    it('should return incoming pending requests', async () => {
      const mockFriendships = [mockFriendship];

      mockFriendshipRepository.createQueryBuilder.mockReturnValueOnce({
        where: jest.fn().mockReturnThis(),
        andWhere: jest.fn().mockReturnThis(),
        orderBy: jest.fn().mockReturnThis(),
        leftJoinAndSelect: jest.fn().mockReturnThis(),
        skip: jest.fn().mockReturnThis(),
        take: jest.fn().mockReturnThis(),
        getManyAndCount: jest.fn().mockResolvedValue([mockFriendships, 1]),
      });

      const result = await service.getIncoming('user-2', {} as any);

      expect(result).toHaveProperty('data');
      expect(result).toHaveProperty('meta');
      expect(result.data).toEqual(mockFriendships);
    });
  });

  describe('getOutgoing', () => {
    it('should return outgoing pending requests', async () => {
      const mockFriendships = [mockFriendship];

      mockFriendshipRepository.createQueryBuilder.mockReturnValueOnce({
        where: jest.fn().mockReturnThis(),
        andWhere: jest.fn().mockReturnThis(),
        orderBy: jest.fn().mockReturnThis(),
        leftJoinAndSelect: jest.fn().mockReturnThis(),
        skip: jest.fn().mockReturnThis(),
        take: jest.fn().mockReturnThis(),
        getManyAndCount: jest.fn().mockResolvedValue([mockFriendships, 1]),
      });

      const result = await service.getOutgoing('user-1', {} as any);

      expect(result).toHaveProperty('data');
      expect(result).toHaveProperty('meta');
      expect(result.data).toEqual(mockFriendships);
    });
  });

  describe('accept', () => {
    it('should accept friendship request and increment counters', async () => {
      mockFriendshipRepository.findOne.mockResolvedValue(mockFriendship);
      mockFriendshipRepository.save.mockResolvedValue({
        ...mockFriendship,
        status: FriendshipStatus.ACCEPTED,
      });
      mockUserRepository.increment.mockResolvedValue(undefined);

      const result = await service.accept('friendship-1', 'user-2');

      expect(result.status).toBe(FriendshipStatus.ACCEPTED);
      expect(mockUserRepository.increment).toHaveBeenCalledTimes(2);
      expect(mockUserRepository.increment).toHaveBeenCalledWith(
        { id: 'user-1' },
        'friends_count',
        1,
      );
      expect(mockUserRepository.increment).toHaveBeenCalledWith(
        { id: 'user-2' },
        'friends_count',
        1,
      );
    });

    it('should throw NotFoundException if request not found', async () => {
      mockFriendshipRepository.findOne.mockResolvedValue(null);

      await expect(service.accept('non-existent', 'user-2')).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw ForbiddenException if not addressee', async () => {
      mockFriendshipRepository.findOne.mockResolvedValue(mockFriendship);

      await expect(service.accept('friendship-1', 'user-3')).rejects.toThrow(
        ForbiddenException,
      );
    });

    it('should throw BadRequestException if not pending', async () => {
      mockFriendshipRepository.findOne.mockResolvedValue({
        ...mockFriendship,
        status: FriendshipStatus.ACCEPTED,
      });

      await expect(service.accept('friendship-1', 'user-2')).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('decline', () => {
    it('should decline friendship request', async () => {
      const pendingFriendship = { ...mockFriendship, status: FriendshipStatus.PENDING };
      mockFriendshipRepository.findOne.mockResolvedValue(pendingFriendship);
      mockFriendshipRepository.save.mockResolvedValue({
        ...pendingFriendship,
        status: FriendshipStatus.DECLINED,
      });

      const result = await service.decline('friendship-1', 'user-2');

      expect(result.status).toBe(FriendshipStatus.DECLINED);
    });

    it('should throw NotFoundException if request not found', async () => {
      mockFriendshipRepository.findOne.mockResolvedValue(null);

      await expect(service.decline('non-existent', 'user-2')).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw ForbiddenException if not addressee', async () => {
      mockFriendshipRepository.findOne.mockResolvedValue(mockFriendship);

      await expect(service.decline('friendship-1', 'user-3')).rejects.toThrow(
        ForbiddenException,
      );
    });

    it('should throw BadRequestException if not pending', async () => {
      mockFriendshipRepository.findOne.mockResolvedValue({
        ...mockFriendship,
        status: FriendshipStatus.DECLINED,
      });

      await expect(service.decline('friendship-1', 'user-2')).rejects.toThrow(
        BadRequestException,
      );
    });
  });

  describe('remove', () => {
    it('should remove friendship and decrement counters if accepted', async () => {
      const acceptedFriendship = {
        ...mockFriendship,
        status: FriendshipStatus.ACCEPTED,
      };

      mockFriendshipRepository.findOne.mockResolvedValue(acceptedFriendship);
      mockFriendshipRepository.remove.mockResolvedValue(acceptedFriendship);
      mockUserRepository.decrement.mockResolvedValue(undefined);

      const result = await service.remove('friendship-1', 'user-1');

      expect(result).toEqual({ message: 'Friendship removed successfully' });
      expect(mockUserRepository.decrement).toHaveBeenCalledTimes(2);
      expect(mockFriendshipRepository.remove).toHaveBeenCalled();
    });

    it('should remove pending friendship without decrementing counters', async () => {
      const pendingFriendship = { ...mockFriendship, status: FriendshipStatus.PENDING };
      mockFriendshipRepository.findOne.mockResolvedValue(pendingFriendship);
      mockFriendshipRepository.remove.mockResolvedValue(pendingFriendship);

      const result = await service.remove('friendship-1', 'user-1');

      expect(result).toEqual({ message: 'Friendship removed successfully' });
      expect(mockUserRepository.decrement).not.toHaveBeenCalled();
    });

    it('should throw NotFoundException if friendship not found', async () => {
      mockFriendshipRepository.findOne.mockResolvedValue(null);

      await expect(service.remove('non-existent', 'user-1')).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw ForbiddenException if not participant', async () => {
      mockFriendshipRepository.findOne.mockResolvedValue(mockFriendship);

      await expect(service.remove('friendship-1', 'user-3')).rejects.toThrow(
        ForbiddenException,
      );
    });
  });

  describe('block', () => {
    it('should block existing accepted friendship and decrement counters', async () => {
      const acceptedFriendship = {
        ...mockFriendship,
        status: FriendshipStatus.ACCEPTED,
      };

      mockFriendshipRepository.findOne.mockResolvedValue(acceptedFriendship);
      mockFriendshipRepository.save.mockResolvedValue({
        ...acceptedFriendship,
        status: FriendshipStatus.BLOCKED,
        requester_id: 'user-1',
        addressee_id: 'user-2',
      });
      mockUserRepository.decrement.mockResolvedValue(undefined);

      const result = await service.block('user-2', 'user-1');

      expect(result.status).toBe(FriendshipStatus.BLOCKED);
      expect(result.requester_id).toBe('user-1'); // Blocker becomes requester
      expect(result.addressee_id).toBe('user-2'); // Blocked becomes addressee
      expect(mockUserRepository.decrement).toHaveBeenCalledTimes(2);
    });

    it('should create new block record if no existing friendship', async () => {
      mockFriendshipRepository.findOne.mockResolvedValue(null);
      mockFriendshipRepository.create.mockReturnValue({
        requester_id: 'user-1',
        addressee_id: 'user-2',
        status: FriendshipStatus.BLOCKED,
      });
      mockFriendshipRepository.save.mockResolvedValue({
        id: 'new-block-1',
        requester_id: 'user-1',
        addressee_id: 'user-2',
        status: FriendshipStatus.BLOCKED,
      });

      const result = await service.block('user-2', 'user-1');

      expect(result.status).toBe(FriendshipStatus.BLOCKED);
      expect(mockFriendshipRepository.create).toHaveBeenCalledWith({
        requester_id: 'user-1',
        addressee_id: 'user-2',
        status: FriendshipStatus.BLOCKED,
      });
    });

    it('should block pending friendship without decrementing counters', async () => {
      const pendingFriendship = { ...mockFriendship, status: FriendshipStatus.PENDING };
      mockFriendshipRepository.findOne.mockResolvedValue(pendingFriendship);
      mockFriendshipRepository.save.mockResolvedValue({
        ...pendingFriendship,
        status: FriendshipStatus.BLOCKED,
        requester_id: 'user-1',
        addressee_id: 'user-2',
      });

      const result = await service.block('user-2', 'user-1');

      expect(result.status).toBe(FriendshipStatus.BLOCKED);
      expect(mockUserRepository.decrement).not.toHaveBeenCalled();
    });
  });
});
