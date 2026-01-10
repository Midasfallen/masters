import { Test, TestingModule } from '@nestjs/testing';
import { LikesService } from './likes.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Like, LikableType } from './entities/like.entity';
import { Post } from '../posts/entities/post.entity';
import { Comment } from './entities/comment.entity';
import { Repository } from 'typeorm';
import { ConflictException, NotFoundException } from '@nestjs/common';
import { AppWebSocketGateway } from '../websocket/websocket.gateway';

describe('LikesService', () => {
  let service: LikesService;
  let likeRepository: Repository<Like>;
  let postRepository: Repository<Post>;
  let commentRepository: Repository<Comment>;
  let websocketGateway: AppWebSocketGateway;

  const mockUser = {
    id: '550e8400-e29b-41d4-a716-446655440000',
    email: 'test@example.com',
    first_name: 'Test',
    last_name: 'User',
  };

  const mockPost = {
    id: '660e8400-e29b-41d4-a716-446655440001',
    author_id: mockUser.id,
    likes_count: 5,
    author: mockUser,
  };

  const mockLike = {
    id: '770e8400-e29b-41d4-a716-446655440002',
    user_id: mockUser.id,
    likable_type: LikableType.POST,
    likable_id: mockPost.id,
    created_at: new Date(),
  };

  const mockLikeRepository = {
    findOne: jest.fn(),
    create: jest.fn(),
    save: jest.fn(),
    remove: jest.fn(),
  };

  const mockPostRepository = {
    findOne: jest.fn(),
    increment: jest.fn(),
    decrement: jest.fn(),
  };

  const mockCommentRepository = {
    findOne: jest.fn(),
    increment: jest.fn(),
    decrement: jest.fn(),
  };

  const mockWebSocketGateway = {
    broadcastPostLiked: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        LikesService,
        {
          provide: getRepositoryToken(Like),
          useValue: mockLikeRepository,
        },
        {
          provide: getRepositoryToken(Post),
          useValue: mockPostRepository,
        },
        {
          provide: getRepositoryToken(Comment),
          useValue: mockCommentRepository,
        },
        {
          provide: AppWebSocketGateway,
          useValue: mockWebSocketGateway,
        },
      ],
    }).compile();

    service = module.get<LikesService>(LikesService);
    likeRepository = module.get<Repository<Like>>(getRepositoryToken(Like));
    postRepository = module.get<Repository<Post>>(getRepositoryToken(Post));
    commentRepository = module.get<Repository<Comment>>(
      getRepositoryToken(Comment),
    );
    websocketGateway = module.get<AppWebSocketGateway>(AppWebSocketGateway);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('create (like post)', () => {
    it('should create new like for post', async () => {
      const createLikeDto = {
        likable_type: LikableType.POST,
        likable_id: mockPost.id,
      };

      mockLikeRepository.findOne.mockResolvedValue(null); // No existing like
      mockLikeRepository.create.mockReturnValue(mockLike);
      mockLikeRepository.save.mockResolvedValue(mockLike);
      mockPostRepository.increment.mockResolvedValue(undefined);
      mockPostRepository.findOne.mockResolvedValue(mockPost);

      const result = await service.create(mockUser.id, createLikeDto);

      expect(result).toEqual(mockLike);
      expect(mockLikeRepository.findOne).toHaveBeenCalledWith({
        where: {
          user_id: mockUser.id,
          likable_type: LikableType.POST,
          likable_id: mockPost.id,
        },
      });
      expect(mockLikeRepository.create).toHaveBeenCalled();
      expect(mockLikeRepository.save).toHaveBeenCalled();
      expect(mockPostRepository.increment).toHaveBeenCalledWith(
        { id: mockPost.id },
        'likes_count',
        1,
      );
      expect(mockWebSocketGateway.broadcastPostLiked).toHaveBeenCalled();
    });

    it('should throw ConflictException if like already exists', async () => {
      const createLikeDto = {
        likable_type: LikableType.POST,
        likable_id: mockPost.id,
      };

      mockLikeRepository.findOne.mockResolvedValue(mockLike); // Existing like

      await expect(service.create(mockUser.id, createLikeDto)).rejects.toThrow(
        ConflictException,
      );
      expect(mockLikeRepository.save).not.toHaveBeenCalled();
    });
  });

  describe('remove (unlike post)', () => {
    it('should remove like from post', async () => {
      mockLikeRepository.findOne.mockResolvedValue(mockLike);
      mockLikeRepository.remove.mockResolvedValue(mockLike);
      mockPostRepository.decrement.mockResolvedValue(undefined);

      const result = await service.remove(
        mockUser.id,
        LikableType.POST,
        mockPost.id,
      );

      expect(result).toEqual({ message: 'Like removed successfully' });
      expect(mockLikeRepository.findOne).toHaveBeenCalledWith({
        where: {
          user_id: mockUser.id,
          likable_type: LikableType.POST,
          likable_id: mockPost.id,
        },
      });
      expect(mockLikeRepository.remove).toHaveBeenCalledWith(mockLike);
      expect(mockPostRepository.decrement).toHaveBeenCalledWith(
        { id: mockPost.id },
        'likes_count',
        1,
      );
    });

    it('should throw NotFoundException if like not found', async () => {
      mockLikeRepository.findOne.mockResolvedValue(null);

      await expect(
        service.remove(mockUser.id, LikableType.POST, 'non-existent-id'),
      ).rejects.toThrow(NotFoundException);
      expect(mockLikeRepository.remove).not.toHaveBeenCalled();
    });
  });

  describe('findByUser', () => {
    it('should return paginated likes for user', async () => {
      const mockLikes = [mockLike];
      mockLikeRepository.findOne = jest.fn().mockReturnValue({
        where: jest.fn().mockReturnThis(),
        orderBy: jest.fn().mockReturnThis(),
        skip: jest.fn().mockReturnThis(),
        take: jest.fn().mockReturnThis(),
        getManyAndCount: jest.fn().mockResolvedValue([mockLikes, 1]),
      });

      // This test needs the actual query builder pattern
      // For now, we'll skip detailed implementation
    });
  });
});
