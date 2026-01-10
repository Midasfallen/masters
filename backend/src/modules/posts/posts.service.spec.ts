import { Test, TestingModule } from '@nestjs/testing';
import { PostsService } from './posts.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Post, PostType, PostPrivacy } from './entities/post.entity';
import { PostMedia } from './entities/post-media.entity';
import { Friendship } from '../friends/entities/friendship.entity';
import { Subscription } from '../friends/entities/subscription.entity';
import { Repository } from 'typeorm';
import { NotFoundException, ForbiddenException } from '@nestjs/common';

describe('PostsService', () => {
  let service: PostsService;
  let postRepository: Repository<Post>;
  let postMediaRepository: Repository<PostMedia>;
  let friendshipRepository: Repository<Friendship>;
  let subscriptionRepository: Repository<Subscription>;

  const mockUser = {
    id: '550e8400-e29b-41d4-a716-446655440000',
    email: 'test@example.com',
    first_name: 'Test',
    last_name: 'User',
  };

  const mockPost = {
    id: '660e8400-e29b-41d4-a716-446655440001',
    author_id: mockUser.id,
    type: PostType.PHOTO,
    privacy: PostPrivacy.PUBLIC,
    content: 'Great work!',
    likes_count: 5,
    comments_count: 2,
    reposts_count: 1,
    views_count: 100,
    comments_disabled: false,
    created_at: new Date(),
    updated_at: new Date(),
    author: mockUser,
  };

  const mockPostRepository = {
    findOne: jest.fn(),
    find: jest.fn(),
    create: jest.fn(),
    save: jest.fn(),
    update: jest.fn(),
    remove: jest.fn(),
    increment: jest.fn(),
    createQueryBuilder: jest.fn(),
  };

  const mockPostMediaRepository = {
    create: jest.fn(),
    save: jest.fn(),
  };

  const mockFriendshipRepository = {
    find: jest.fn(),
  };

  const mockSubscriptionRepository = {
    find: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        PostsService,
        {
          provide: getRepositoryToken(Post),
          useValue: mockPostRepository,
        },
        {
          provide: getRepositoryToken(PostMedia),
          useValue: mockPostMediaRepository,
        },
        {
          provide: getRepositoryToken(Friendship),
          useValue: mockFriendshipRepository,
        },
        {
          provide: getRepositoryToken(Subscription),
          useValue: mockSubscriptionRepository,
        },
      ],
    }).compile();

    service = module.get<PostsService>(PostsService);
    postRepository = module.get<Repository<Post>>(getRepositoryToken(Post));
    postMediaRepository = module.get<Repository<PostMedia>>(
      getRepositoryToken(PostMedia),
    );
    friendshipRepository = module.get<Repository<Friendship>>(
      getRepositoryToken(Friendship),
    );
    subscriptionRepository = module.get<Repository<Subscription>>(
      getRepositoryToken(Subscription),
    );
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('create', () => {
    it('should create new post', async () => {
      const createPostDto = {
        type: PostType.PHOTO,
        privacy: PostPrivacy.PUBLIC,
        content: 'New post!',
      };

      mockPostRepository.create.mockReturnValue(mockPost);
      mockPostRepository.save.mockResolvedValue(mockPost);
      mockPostRepository.findOne.mockResolvedValue(mockPost);

      const result = await service.create(mockUser.id, createPostDto as any);

      expect(result).toEqual(mockPost);
      expect(mockPostRepository.create).toHaveBeenCalledWith({
        ...createPostDto,
        author_id: mockUser.id,
      });
      expect(mockPostRepository.save).toHaveBeenCalled();
    });

    it('should create post with media', async () => {
      const createPostDto = {
        type: PostType.PHOTO,
        privacy: PostPrivacy.PUBLIC,
        content: 'Post with media',
        media: [
          {
            type: 'photo',
            url: 'https://example.com/photo.jpg',
            order: 0,
          },
        ],
      };

      const mockMedia = { id: 'media-id', ...createPostDto.media[0] };

      mockPostRepository.create.mockReturnValue(mockPost);
      mockPostRepository.save.mockResolvedValue(mockPost);
      mockPostMediaRepository.create.mockReturnValue(mockMedia);
      mockPostMediaRepository.save.mockResolvedValue([mockMedia]);
      mockPostRepository.findOne.mockResolvedValue(mockPost);

      const result = await service.create(mockUser.id, createPostDto as any);

      expect(mockPostMediaRepository.create).toHaveBeenCalled();
      expect(mockPostMediaRepository.save).toHaveBeenCalled();
    });

    it('should throw NotFoundException if repost original not found', async () => {
      const createPostDto = {
        type: PostType.PHOTO,
        privacy: PostPrivacy.PUBLIC,
        content: 'Repost',
        repost_of_id: 'non-existent-post',
      };

      mockPostRepository.findOne.mockResolvedValue(null);

      await expect(service.create(mockUser.id, createPostDto as any)).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should increment reposts_count for original post', async () => {
      const originalPost = { ...mockPost, id: 'original-post-id' };
      const createPostDto = {
        type: PostType.PHOTO,
        privacy: PostPrivacy.PUBLIC,
        content: 'Repost',
        repost_of_id: originalPost.id,
      };

      mockPostRepository.findOne
        .mockResolvedValueOnce(originalPost) // Check original exists
        .mockResolvedValueOnce(mockPost); // Final findOne
      mockPostRepository.create.mockReturnValue(mockPost);
      mockPostRepository.save.mockResolvedValue(mockPost);
      mockPostRepository.increment.mockResolvedValue(undefined);

      await service.create(mockUser.id, createPostDto as any);

      expect(mockPostRepository.increment).toHaveBeenCalledWith(
        { id: originalPost.id },
        'reposts_count',
        1,
      );
    });
  });

  describe('findOne', () => {
    it('should return post by id', async () => {
      mockPostRepository.findOne.mockResolvedValue(mockPost);

      const result = await service.findOne(mockPost.id, mockUser.id);

      expect(result).toEqual(mockPost);
      expect(mockPostRepository.findOne).toHaveBeenCalledWith({
        where: { id: mockPost.id },
        relations: expect.arrayContaining(['author', 'media']),
      });
    });

    it('should throw NotFoundException if post not found', async () => {
      mockPostRepository.findOne.mockResolvedValue(null);

      await expect(service.findOne('non-existent-id', mockUser.id)).rejects.toThrow(
        NotFoundException,
      );
    });
  });

  describe('update', () => {
    it('should update post', async () => {
      const updatePostDto = {
        content: 'Updated content',
      };

      mockPostRepository.findOne
        .mockResolvedValueOnce(mockPost) // Check ownership
        .mockResolvedValueOnce({ ...mockPost, ...updatePostDto }); // Final findOne
      mockPostRepository.update.mockResolvedValue(undefined);

      const result = await service.update(mockPost.id, mockUser.id, updatePostDto);

      expect(result.content).toBe(updatePostDto.content);
      expect(mockPostRepository.update).toHaveBeenCalledWith(mockPost.id, updatePostDto);
    });

    it('should throw NotFoundException if post not found', async () => {
      mockPostRepository.findOne.mockResolvedValue(null);

      await expect(
        service.update('non-existent-id', mockUser.id, { content: 'Update' }),
      ).rejects.toThrow(NotFoundException);
    });

    it('should throw ForbiddenException if user is not the author', async () => {
      const otherUserPost = { ...mockPost, author_id: 'other-user-id' };
      mockPostRepository.findOne.mockResolvedValue(otherUserPost);

      await expect(
        service.update(mockPost.id, mockUser.id, { content: 'Update' }),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('remove', () => {
    it('should remove post', async () => {
      mockPostRepository.findOne.mockResolvedValue(mockPost);
      mockPostRepository.remove.mockResolvedValue(mockPost);

      const result = await service.remove(mockPost.id, mockUser.id);

      expect(result).toEqual({ message: 'Post deleted successfully' });
      expect(mockPostRepository.remove).toHaveBeenCalledWith(mockPost);
    });

    it('should throw NotFoundException if post not found', async () => {
      mockPostRepository.findOne.mockResolvedValue(null);

      await expect(service.remove('non-existent-id', mockUser.id)).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should throw ForbiddenException if user is not the author', async () => {
      const otherUserPost = { ...mockPost, author_id: 'other-user-id' };
      mockPostRepository.findOne.mockResolvedValue(otherUserPost);

      await expect(service.remove(mockPost.id, mockUser.id)).rejects.toThrow(
        ForbiddenException,
      );
    });
  });

  describe('getFeed', () => {
    it('should return feed posts', async () => {
      const filterDto = {
        page: 1,
        limit: 20,
        skip: 0,
        take: 20,
      };

      mockFriendshipRepository.find.mockResolvedValue([]);
      mockSubscriptionRepository.find.mockResolvedValue([]);

      // Mock query builder chain
      const mockQueryBuilder = {
        leftJoinAndSelect: jest.fn().mockReturnThis(),
        where: jest.fn().mockReturnThis(),
        andWhere: jest.fn().mockReturnThis(),
        orderBy: jest.fn().mockReturnThis(),
        addOrderBy: jest.fn().mockReturnThis(),
        skip: jest.fn().mockReturnThis(),
        take: jest.fn().mockReturnThis(),
        getManyAndCount: jest.fn().mockResolvedValue([[mockPost], 1]),
      };

      mockPostRepository.createQueryBuilder.mockReturnValue(mockQueryBuilder);

      const result = await service.getFeed(mockUser.id, filterDto as any);

      expect(result).toHaveProperty('data');
      expect(result).toHaveProperty('meta');
      expect(mockPostRepository.createQueryBuilder).toHaveBeenCalled();
    });
  });
});
