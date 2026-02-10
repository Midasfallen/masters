import { Test, TestingModule } from '@nestjs/testing';
import { UsersService } from './users.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { User } from './entities/user.entity';
import { Repository } from 'typeorm';
import { NotFoundException, ConflictException } from '@nestjs/common';
import { SearchService } from '../search/search.service';

describe('UsersService', () => {
  let service: UsersService;
  let repository: Repository<User>;

  // Mock entity uses snake_case
  const mockUser = {
    id: '550e8400-e29b-41d4-a716-446655440000',
    email: 'test@example.com',
    first_name: 'Test',
    last_name: 'User',
    phone: '+1234567890',
    language: 'en',
    is_master: false,
    master_profile_completed: false,
    avatar_url: 'https://example.com/avatar.jpg',
    posts_count: 10,
    friends_count: 5,
    followers_count: 20,
    following_count: 15,
    reviews_count: 3,
    rating: 4.5,
    is_verified: false,
    is_premium: false,
    created_at: new Date(),
    updated_at: new Date(),
  };

  const mockRepository = {
    findOne: jest.fn(),
    save: jest.fn(),
    create: jest.fn(),
    remove: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        UsersService,
        {
          provide: getRepositoryToken(User),
          useValue: mockRepository,
        },
        {
          provide: SearchService,
          useValue: { indexUser: jest.fn(), removeUser: jest.fn() },
        },
      ],
    }).compile();

    service = module.get<UsersService>(UsersService);
    repository = module.get<Repository<User>>(getRepositoryToken(User));
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('findById', () => {
    it('should return user when found', async () => {
      mockRepository.findOne.mockResolvedValue(mockUser);

      const result = await service.findById(mockUser.id);

      // Result is Response DTO (camelCase)
      expect(result.id).toEqual(mockUser.id);
      expect(result.firstName).toEqual('Test');
      expect(result.lastName).toEqual('User');
      expect(mockRepository.findOne).toHaveBeenCalledWith({
        where: { id: mockUser.id },
      });
    });

    it('should throw NotFoundException when user not found', async () => {
      mockRepository.findOne.mockResolvedValue(null);

      await expect(service.findById('nonexistent-id')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('update', () => {
    it('should update user profile', async () => {
      const updateDto = {
        first_name: 'Updated',
        last_name: 'Name',
      };

      const updatedUser = { ...mockUser, ...updateDto };
      mockRepository.findOne.mockResolvedValue(mockUser);
      mockRepository.save.mockResolvedValue(updatedUser);

      const result = await service.update(mockUser.id, updateDto);

      expect(result.firstName).toBe('Updated');
      expect(result.lastName).toBe('Name');
      expect(mockRepository.save).toHaveBeenCalled();
    });

    it('should throw ConflictException when phone already exists', async () => {
      const updateDto = {
        phone: '+9876543210',
      };

      const existingUser = {
        ...mockUser,
        id: 'different-id',
        phone: '+9876543210',
      };

      mockRepository.findOne
        .mockResolvedValueOnce(mockUser) // First call for findById
        .mockResolvedValueOnce(existingUser); // Second call for phone check

      await expect(service.update(mockUser.id, updateDto)).rejects.toThrow(
        ConflictException,
      );
    });

    it('should allow updating own phone', async () => {
      const updateDto = {
        phone: '+1234567890', // Same phone as mockUser
      };

      const updatedUser = { ...mockUser, ...updateDto };
      mockRepository.findOne.mockResolvedValue(mockUser);
      mockRepository.save.mockResolvedValue(updatedUser);

      const result = await service.update(mockUser.id, updateDto);

      expect(result.phone).toBe('+1234567890');
      expect(mockRepository.save).toHaveBeenCalled();
    });

    it('should throw NotFoundException when user not found', async () => {
      mockRepository.findOne.mockResolvedValue(null);

      await expect(
        service.update('nonexistent-id', { first_name: 'Test' }),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('findByEmail', () => {
    it('should return user when found by email', async () => {
      mockRepository.findOne.mockResolvedValue(mockUser);

      const result = await service.findByEmail('test@example.com');

      // Result is Response DTO (camelCase)
      expect(result.id).toEqual(mockUser.id);
      expect(result.email).toEqual('test@example.com');
      expect(mockRepository.findOne).toHaveBeenCalledWith({
        where: { email: 'test@example.com' },
      });
    });

    it('should return null when user not found', async () => {
      mockRepository.findOne.mockResolvedValue(null);

      const result = await service.findByEmail('nonexistent@example.com');

      expect(result).toBeNull();
    });
  });

  describe('updateAvatar', () => {
    it('should update user avatar', async () => {
      const newAvatarUrl = 'https://example.com/new-avatar.jpg';
      const updatedUser = { ...mockUser, avatar_url: newAvatarUrl };

      mockRepository.findOne.mockResolvedValue(mockUser);
      mockRepository.save.mockResolvedValue(updatedUser);

      const result = await service.updateAvatar(mockUser.id, newAvatarUrl);

      // Result is Response DTO (camelCase)
      expect(result.avatarUrl).toBe(newAvatarUrl);
      expect(mockRepository.save).toHaveBeenCalled();
    });

    it('should throw NotFoundException when user not found', async () => {
      mockRepository.findOne.mockResolvedValue(null);

      await expect(
        service.updateAvatar('nonexistent-id', 'https://example.com/avatar.jpg'),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('remove', () => {
    it('should remove user', async () => {
      mockRepository.findOne.mockResolvedValue(mockUser);
      mockRepository.remove.mockResolvedValue(mockUser);

      await service.remove(mockUser.id);

      expect(mockRepository.remove).toHaveBeenCalledWith(mockUser);
    });

    it('should throw NotFoundException when user not found', async () => {
      mockRepository.findOne.mockResolvedValue(null);

      await expect(service.remove('nonexistent-id')).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('getUserStats', () => {
    it('should return user statistics', async () => {
      mockRepository.findOne.mockResolvedValue(mockUser);

      const result = await service.getUserStats(mockUser.id);

      expect(result).toEqual({
        postsCount: 10,
        friendsCount: 5,
        followersCount: 20,
        followingCount: 15,
        reviewsCount: 3,
        rating: 4.5,
        isMaster: false,
        isVerified: false,
        isPremium: false,
      });
    });

    it('should throw NotFoundException when user not found', async () => {
      mockRepository.findOne.mockResolvedValue(null);

      await expect(service.getUserStats('nonexistent-id')).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});
