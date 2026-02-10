import { Test, TestingModule } from '@nestjs/testing';
import { CommentsService } from './comments.service';
import { getRepositoryToken } from '@nestjs/typeorm';
import { Comment } from './entities/comment.entity';
import { Post } from '../posts/entities/post.entity';
import { Repository } from 'typeorm';
import {
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { AppWebSocketGateway } from '../websocket/websocket.gateway';
import { CacheService } from '../../common/services/cache.service';

describe('CommentsService', () => {
  let service: CommentsService;
  let commentRepository: Repository<Comment>;
  let postRepository: Repository<Post>;
  let websocketGateway: AppWebSocketGateway;

  // Mock User entity (snake_case как в БД)
  const mockUser = {
    id: '550e8400-e29b-41d4-a716-446655440000',
    email: 'test@example.com',
    first_name: 'Test',
    last_name: 'User',
    avatar_url: 'https://example.com/avatar.jpg',
  };

  // Mock Post entity (snake_case)
  const mockPost = {
    id: '660e8400-e29b-41d4-a716-446655440001',
    author_id: mockUser.id,
    comments_count: 3,
    comments_disabled: false,
    author: mockUser,
  };

  // Mock Comment entity (snake_case)
  const mockComment = {
    id: '770e8400-e29b-41d4-a716-446655440002',
    post_id: mockPost.id,
    author_id: mockUser.id,
    content: 'Great post!',
    parent_comment_id: null,
    likes_count: 0,
    replies_count: 0,
    is_edited: false,
    created_at: new Date(),
    updated_at: new Date(),
    author: mockUser,
  };

  // Expected Response DTO (camelCase - результат маппера)
  const expectedCommentResponse = {
    id: mockComment.id,
    postId: mockPost.id,
    authorId: mockUser.id,
    content: 'Great post!',
    parentCommentId: null,
    likesCount: 0,
    repliesCount: 0,
    isEdited: false,
    createdAt: mockComment.created_at,
    updatedAt: mockComment.updated_at,
  };

  const mockCommentRepository = {
    findOne: jest.fn(),
    create: jest.fn(),
    save: jest.fn(),
    remove: jest.fn(),
    update: jest.fn(),
    increment: jest.fn(),
    decrement: jest.fn(),
    createQueryBuilder: jest.fn(),
  };

  const mockPostRepository = {
    findOne: jest.fn(),
    increment: jest.fn(),
    decrement: jest.fn(),
  };

  const mockWebSocketGateway = {
    broadcastPostCommented: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        CommentsService,
        {
          provide: getRepositoryToken(Comment),
          useValue: mockCommentRepository,
        },
        {
          provide: getRepositoryToken(Post),
          useValue: mockPostRepository,
        },
        {
          provide: AppWebSocketGateway,
          useValue: mockWebSocketGateway,
        },
        {
          provide: CacheService,
          useValue: { get: jest.fn(), set: jest.fn(), del: jest.fn(), invalidatePattern: jest.fn(), delByPattern: jest.fn() },
        },
      ],
    }).compile();

    service = module.get<CommentsService>(CommentsService);
    commentRepository = module.get<Repository<Comment>>(
      getRepositoryToken(Comment),
    );
    postRepository = module.get<Repository<Post>>(getRepositoryToken(Post));
    websocketGateway = module.get<AppWebSocketGateway>(AppWebSocketGateway);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('create', () => {
    it('should create new comment on post', async () => {
      const createCommentDto = {
        post_id: mockPost.id,
        content: 'Great post!',
      };

      mockPostRepository.findOne.mockResolvedValue(mockPost);
      mockCommentRepository.create.mockReturnValue(mockComment);
      mockCommentRepository.save.mockResolvedValue(mockComment);
      mockPostRepository.increment.mockResolvedValue(undefined);
      mockCommentRepository.findOne.mockResolvedValue(mockComment);

      const result = await service.create(mockUser.id, createCommentDto);

      expect(result).toEqual(expectedCommentResponse);
      expect(mockPostRepository.findOne).toHaveBeenCalledWith({
        where: { id: mockPost.id },
      });
      expect(mockCommentRepository.create).toHaveBeenCalledWith({
        ...createCommentDto,
        author_id: mockUser.id,
      });
      expect(mockCommentRepository.save).toHaveBeenCalled();
      expect(mockPostRepository.increment).toHaveBeenCalledWith(
        { id: mockPost.id },
        'comments_count',
        1,
      );
      expect(mockWebSocketGateway.broadcastPostCommented).toHaveBeenCalled();
    });

    it('should throw NotFoundException if post not found', async () => {
      const createCommentDto = {
        post_id: 'non-existent-post',
        content: 'Comment',
      };

      mockPostRepository.findOne.mockResolvedValue(null);

      await expect(
        service.create(mockUser.id, createCommentDto),
      ).rejects.toThrow(NotFoundException);
      expect(mockCommentRepository.save).not.toHaveBeenCalled();
    });

    it('should throw BadRequestException if comments are disabled', async () => {
      const createCommentDto = {
        post_id: mockPost.id,
        content: 'Comment',
      };

      const postWithDisabledComments = { ...mockPost, comments_disabled: true };
      mockPostRepository.findOne.mockResolvedValue(postWithDisabledComments);

      await expect(
        service.create(mockUser.id, createCommentDto),
      ).rejects.toThrow(BadRequestException);
      expect(mockCommentRepository.save).not.toHaveBeenCalled();
    });

    it('should create reply to parent comment', async () => {
      const parentComment = { ...mockComment, id: 'parent-comment-id' };
      const createReplyDto = {
        post_id: mockPost.id,
        content: 'Reply to comment',
        parent_comment_id: parentComment.id,
      };

      mockPostRepository.findOne.mockResolvedValue(mockPost);
      mockCommentRepository.findOne
        .mockResolvedValueOnce(parentComment) // For parent comment check
        .mockResolvedValueOnce(mockComment); // For final findOne
      mockCommentRepository.create.mockReturnValue(mockComment);
      mockCommentRepository.save.mockResolvedValue(mockComment);
      mockPostRepository.increment.mockResolvedValue(undefined);
      mockCommentRepository.increment.mockResolvedValue(undefined);

      const result = await service.create(mockUser.id, createReplyDto);

      expect(result).toEqual(expectedCommentResponse);
      expect(mockCommentRepository.increment).toHaveBeenCalledWith(
        { id: parentComment.id },
        'replies_count',
        1,
      );
    });

    it('should throw NotFoundException if parent comment not found', async () => {
      const createReplyDto = {
        post_id: mockPost.id,
        content: 'Reply',
        parent_comment_id: 'non-existent-parent',
      };

      mockPostRepository.findOne.mockResolvedValue(mockPost);
      mockCommentRepository.findOne.mockResolvedValue(null);

      await expect(
        service.create(mockUser.id, createReplyDto),
      ).rejects.toThrow(NotFoundException);
    });
  });

  describe('update', () => {
    it('should update comment content', async () => {
      const updateCommentDto = {
        content: 'Updated content',
      };

      const updatedComment = { ...mockComment, content: 'Updated content', is_edited: true };
      mockCommentRepository.findOne
        .mockResolvedValueOnce(mockComment) // For ownership check
        .mockResolvedValueOnce(updatedComment); // For final findOne (via mapper)
      mockCommentRepository.update.mockResolvedValue(undefined);

      const result = await service.update(
        mockComment.id,
        mockUser.id,
        updateCommentDto,
      );

      expect(result.content).toBe(updateCommentDto.content);
      expect(mockCommentRepository.update).toHaveBeenCalledWith(mockComment.id, {
        ...updateCommentDto,
        is_edited: true,
      });
    });

    it('should throw NotFoundException if comment not found', async () => {
      mockCommentRepository.findOne.mockResolvedValue(null);

      await expect(
        service.update('non-existent-id', mockUser.id, { content: 'Update' }),
      ).rejects.toThrow(NotFoundException);
    });

    it('should throw ForbiddenException if user is not the author', async () => {
      const otherUserComment = { ...mockComment, author_id: 'other-user-id' };
      mockCommentRepository.findOne.mockResolvedValue(otherUserComment);

      await expect(
        service.update(mockComment.id, mockUser.id, { content: 'Update' }),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('remove', () => {
    it('should remove comment', async () => {
      mockCommentRepository.findOne.mockResolvedValue(mockComment);
      mockCommentRepository.remove.mockResolvedValue(mockComment);
      mockPostRepository.decrement.mockResolvedValue(undefined);

      const result = await service.remove(mockComment.id, mockUser.id);

      expect(result).toEqual({ message: 'Comment deleted successfully' });
      expect(mockCommentRepository.remove).toHaveBeenCalledWith(mockComment);
      expect(mockPostRepository.decrement).toHaveBeenCalledWith(
        { id: mockPost.id },
        'comments_count',
        1,
      );
    });

    it('should throw NotFoundException if comment not found', async () => {
      mockCommentRepository.findOne.mockResolvedValue(null);

      await expect(
        service.remove('non-existent-id', mockUser.id),
      ).rejects.toThrow(NotFoundException);
    });

    it('should throw ForbiddenException if user is not the author', async () => {
      const otherUserComment = { ...mockComment, author_id: 'other-user-id' };
      mockCommentRepository.findOne.mockResolvedValue(otherUserComment);

      await expect(
        service.remove(mockComment.id, mockUser.id),
      ).rejects.toThrow(ForbiddenException);
    });
  });

  describe('findOne', () => {
    it('should return comment by id', async () => {
      mockCommentRepository.findOne.mockResolvedValue(mockComment);

      const result = await service.findOne(mockComment.id);

      expect(result).toEqual(expectedCommentResponse);
      expect(mockCommentRepository.findOne).toHaveBeenCalledWith({
        where: { id: mockComment.id },
        relations: ['author'],
      });
    });

    it('should throw NotFoundException if comment not found', async () => {
      mockCommentRepository.findOne.mockResolvedValue(null);

      await expect(service.findOne('non-existent-id')).rejects.toThrow(
        NotFoundException,
      );
    });
  });
});
