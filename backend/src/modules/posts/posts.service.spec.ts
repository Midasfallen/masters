import { Test, TestingModule } from '@nestjs/testing';
import { PostsService } from './posts.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Post, PostType, PostPrivacy } from './entities/post.entity';
import { PostMedia } from './entities/post-media.entity';
import { Friendship } from '../friends/entities/friendship.entity';
import { Subscription } from '../friends/entities/subscription.entity';
import { PostService as PostServiceEntity } from './entities/post-service.entity';
import { Service } from '../services/entities/service.entity';
import { Category } from '../categories/entities/category.entity';
import { Repository, DataSource } from 'typeorm';
import { NotFoundException, ForbiddenException } from '@nestjs/common';

describe('PostsService', () => {
  let service: PostsService;
  let postRepository: Repository<Post>;
  let postMediaRepository: Repository<PostMedia>;
  let friendshipRepository: Repository<Friendship>;
  let subscriptionRepository: Repository<Subscription>;

  // Mock entities use snake_case
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
    media: [],
    repost_of: null,
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
        {
          provide: getRepositoryToken(PostServiceEntity),
          useValue: { find: jest.fn(), create: jest.fn(), save: jest.fn(), delete: jest.fn() },
        },
        {
          provide: getRepositoryToken(Service),
          useValue: { findOne: jest.fn(), find: jest.fn() },
        },
        {
          provide: getRepositoryToken(Category),
          useValue: { findOne: jest.fn(), find: jest.fn() },
        },
        {
          provide: DataSource,
          useValue: {
            createQueryRunner: jest.fn(),
            query: jest.fn().mockResolvedValue([]),
            transaction: jest.fn().mockImplementation(async (cb) => {
              const mockManager = {
                create: jest.fn().mockReturnValue(mockPost),
                save: jest.fn().mockResolvedValue(mockPost),
                findOne: jest.fn().mockResolvedValue(mockPost),
                find: jest.fn().mockResolvedValue([]),
                update: jest.fn().mockResolvedValue(undefined),
                increment: jest.fn().mockResolvedValue(undefined),
                query: jest.fn().mockResolvedValue([]),
                getRepository: jest.fn().mockReturnValue({
                  find: jest.fn().mockResolvedValue([]),
                  findOne: jest.fn(),
                }),
              };
              return cb(mockManager);
            }),
          },
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
    it('should create new post via transaction', async () => {
      const createPostDto = {
        type: PostType.PHOTO,
        privacy: PostPrivacy.PUBLIC,
        content: 'New post!',
      };

      // create uses dataSource.transaction with manager
      const result = await service.create(mockUser.id, createPostDto as any);

      // Result is Response DTO (camelCase) — returned from manager.findOne mock
      expect(result).toBeDefined();
      expect(result.id).toEqual(mockPost.id);
    });

    it('should create post with media via transaction', async () => {
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

      // create uses dataSource.transaction — media saved via manager
      const result = await service.create(mockUser.id, createPostDto as any);

      expect(result).toBeDefined();
      expect(result.id).toEqual(mockPost.id);
    });

    it('should throw NotFoundException if repost original not found', async () => {
      const createPostDto = {
        type: PostType.PHOTO,
        privacy: PostPrivacy.PUBLIC,
        content: 'Repost',
        repost_of_id: 'non-existent-post',
      };

      // Pre-transaction validation: check original post exists
      mockPostRepository.findOne.mockResolvedValue(null);

      await expect(service.create(mockUser.id, createPostDto as any)).rejects.toThrow(
        NotFoundException,
      );
    });

    it('should handle repost creation', async () => {
      const originalPost = { ...mockPost, id: 'original-post-id' };
      const createPostDto = {
        type: PostType.PHOTO,
        privacy: PostPrivacy.PUBLIC,
        content: 'Repost',
        repost_of_id: originalPost.id,
      };

      // Pre-transaction validation passes
      mockPostRepository.findOne.mockResolvedValue(originalPost);

      // manager.increment is called inside transaction (mocked in DataSource mock)
      const result = await service.create(mockUser.id, createPostDto as any);

      expect(result).toBeDefined();
      expect(result.id).toEqual(mockPost.id);
    });
  });

  describe('findOne', () => {
    it('should return post by id', async () => {
      mockPostRepository.findOne.mockResolvedValue(mockPost);

      const result = await service.findOne(mockPost.id, mockUser.id);

      // Result is Response DTO (camelCase)
      expect(result.id).toEqual(mockPost.id);
      expect(result.authorId).toEqual(mockUser.id);
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
        leftJoin: jest.fn().mockReturnThis(),
        where: jest.fn().mockReturnThis(),
        andWhere: jest.fn().mockReturnThis(),
        orWhere: jest.fn().mockReturnThis(),
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
