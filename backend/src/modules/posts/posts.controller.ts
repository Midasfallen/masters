import {
  Controller,
  Get,
  Post,
  Body,
  Patch,
  Param,
  Delete,
  Query,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiBearerAuth,
  ApiOkResponse,
  ApiCreatedResponse,
  ApiBadRequestResponse,
  ApiUnauthorizedResponse,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiConflictResponse,
  ApiQuery,
  ApiParam,
  ApiNoContentResponse,
} from '@nestjs/swagger';
import { PostsService } from './posts.service';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { FilterPostsDto } from './dto/filter-posts.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { LikesService } from '../social/likes.service';
import { CommentsService } from '../social/comments.service';
import { RepostsService } from '../social/reposts.service';
import { CreateCommentDto } from '../social/dto/create-comment.dto';
import { FilterCommentsDto } from '../social/dto/filter-comments.dto';
import { CreateRepostDto } from '../social/dto/create-repost.dto';
import { LikableType } from '../social/entities/like.entity';
import { CreateCommentBodyDto } from './dto/create-comment-body.dto';
import { CacheService } from '../../common/services/cache.service';
import { PostResponseDto } from './dto/post-response.dto';
import { CommentResponseDto } from '../social/dto/comment-response.dto';
import { PaginatedResponseDto } from '../../common/dto/pagination.dto';

const FEED_CACHE_TTL = 120; // 2 минуты

@ApiTags('Posts')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('posts')
export class PostsController {
  constructor(
    private readonly postsService: PostsService,
    private readonly likesService: LikesService,
    private readonly commentsService: CommentsService,
    private readonly repostsService: RepostsService,
    private readonly cacheService: CacheService,
  ) {}

  @Post()
  @ApiOperation({
    summary: 'Создать новый пост',
    description:
      'Создает новый пост (текстовый или с медиа). Для постов с фото/видео сначала загрузите медиа в MinIO, затем передайте URL в media[].',
  })
  @ApiCreatedResponse({
    description: 'Пост успешно создан',
    type: PostResponseDto,
    examples: {
      textPost: {
        summary: 'Текстовый пост',
        value: {
          id: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
          authorId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          type: 'text',
          content: 'Сегодня создала потрясающий образ для моей клиентки!',
          privacy: 'public',
          repostOfId: null,
          likesCount: 0,
          isLiked: false,
          commentsCount: 0,
          repostsCount: 0,
          viewsCount: 0,
          locationLat: null,
          locationLng: null,
          locationName: null,
          commentsDisabled: false,
          isPinned: false,
          createdAt: '2026-02-04T10:00:00.000Z',
          updatedAt: '2026-02-04T10:00:00.000Z',
          author: {
            id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
            email: 'anna.master@test.com',
            firstName: 'Анна',
            lastName: 'Иванова',
            avatarUrl: null,
            isMaster: true,
            isVerified: true,
            isPremium: false,
          },
          media: [],
          repostOf: null,
        },
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные поста (валидация или бизнес-ограничения)',
  })
  async create(@CurrentUser('id') userId: string, @Body() createPostDto: CreatePostDto) {
    const result = await this.postsService.create(userId, createPostDto);
    await this.cacheService.delByPattern(`feed:${userId}:*`);
    return result;
  }

  @Get('feed')
  @ApiOperation({
    summary: 'Получить ленту постов',
    description:
      'Возвращает список постов для ленты. По умолчанию показывает все публичные посты, с учетом privacy, пагинации и геофильтров.',
  })
  @ApiQuery({
    name: 'page',
    required: false,
    description: 'Номер страницы (начиная с 1)',
    example: 1,
  })
  @ApiQuery({
    name: 'limit',
    required: false,
    description: 'Количество элементов на странице',
    example: 20,
  })
  @ApiOkResponse({
    description: 'Лента постов',
    schema: {
      example: {
        data: [
          {
            id: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
            authorId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
            type: 'text',
            content: 'Сегодня создала потрясающий образ для моей клиентки!',
            privacy: 'public',
            repostOfId: null,
            likesCount: 28,
            isLiked: false,
            commentsCount: 2,
            repostsCount: 0,
            viewsCount: 77,
            locationLat: null,
            locationLng: null,
            locationName: null,
            commentsDisabled: false,
            isPinned: false,
            createdAt: '2026-01-30T18:49:06.121Z',
            updatedAt: '2026-01-30T18:49:06.122Z',
            author: {
              id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
              firstName: 'Анна',
              lastName: 'Иванова',
              email: 'anna.master@test.com',
            },
            media: [],
            repostOf: null,
          },
        ],
        meta: {
          page: 1,
          limit: 20,
          total: 36,
          totalPages: 2,
        },
      },
    },
  })
  async getFeed(@CurrentUser('id') userId: string, @Query() filterDto: FilterPostsDto) {
    const cacheKey = `feed:${userId}:page=${filterDto.page || 1}:limit=${filterDto.limit || 20}:cats=${filterDto.category_ids?.join(',') || ''}`;
    return this.cacheService.getOrSet(
      cacheKey,
      () => this.postsService.getFeed(userId, filterDto),
      FEED_CACHE_TTL,
    );
  }

  @Get('user/:userId')
  @ApiOperation({ summary: 'Получить посты пользователя' })
  getUserPosts(@Param('userId') userId: string, @Query() filterDto: FilterPostsDto) {
    return this.postsService.getUserPosts(userId, filterDto);
  }

  @Get(':id')
  @ApiOperation({
    summary: 'Получить пост по ID',
    description: 'Возвращает один пост с учетом privacy и лайка текущего пользователя.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID поста',
    example: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
  })
  @ApiOkResponse({
    description: 'Найденный пост',
    type: PostResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Пост не найден или недоступен по privacy' })
  async findOne(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.cacheService.getOrSet(
      `post:${id}:user=${userId}`,
      () => this.postsService.findOne(id, userId),
      FEED_CACHE_TTL,
    );
  }

  @Patch(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Обновить пост',
    description: 'Редактирует пост. Можно редактировать только свои посты.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID поста',
    example: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
  })
  @ApiOkResponse({
    description: 'Пост обновлен',
    type: PostResponseDto,
    schema: {
      example: {
        id: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
        authorId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        type: 'text',
        content: 'Сегодня создала потрясающий образ для моей клиентки! (обновлено)',
        privacy: 'public',
        repostOfId: null,
        likesCount: 28,
        isLiked: false,
        commentsCount: 2,
        repostsCount: 0,
        viewsCount: 77,
        locationLat: null,
        locationLng: null,
        locationName: null,
        commentsDisabled: false,
        isPinned: false,
        createdAt: '2026-02-04T10:00:00.000Z',
        updatedAt: '2026-02-04T11:00:00.000Z',
        author: {
          id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          email: 'anna.master@test.com',
          firstName: 'Анна',
          lastName: 'Иванова',
          avatarUrl: null,
          isMaster: true,
          isVerified: true,
          isPremium: false,
        },
        media: [],
        repostOf: null,
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      example: {
        statusCode: 400,
        message: ['content must be longer than or equal to 1 characters'],
        error: 'Bad Request',
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiForbiddenResponse({
    description: 'Можно редактировать только свои посты',
    schema: {
      example: {
        statusCode: 403,
        message: 'You can only edit your own posts',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Пост не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Post not found',
        error: 'Not Found',
      },
    },
  })
  async update(
    @Param('id') id: string,
    @CurrentUser('id') userId: string,
    @Body() updatePostDto: UpdatePostDto,
  ) {
    const result = await this.postsService.update(id, userId, updatePostDto);
    await this.cacheService.delByPattern(`post:${id}:*`);
    await this.cacheService.delByPattern(`feed:${userId}:*`);
    return result;
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Удалить пост',
    description: 'Удаляет пост. Можно удалять только свои посты.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID поста',
    example: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
  })
  @ApiNoContentResponse({
    description: 'Пост удален',
  })
  @ApiBadRequestResponse({
    description: 'Некорректный UUID',
    schema: {
      example: {
        statusCode: 400,
        message: 'Validation failed (uuid is expected)',
        error: 'Bad Request',
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiForbiddenResponse({
    description: 'Можно удалять только свои посты',
    schema: {
      example: {
        statusCode: 403,
        message: 'You can only delete your own posts',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Пост не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Post not found',
        error: 'Not Found',
      },
    },
  })
  async remove(@Param('id') id: string, @CurrentUser('id') userId: string) {
    const result = await this.postsService.remove(id, userId);
    await this.cacheService.delByPattern(`feed:${userId}:*`);
    return result;
  }

  @Post(':id/pin')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Закрепить пост',
    description: 'Закрепляет пост в профиле пользователя. Можно закрепить только свои посты.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID поста',
    example: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
  })
  @ApiOkResponse({
    description: 'Пост закреплен',
    type: PostResponseDto,
    schema: {
      example: {
        id: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
        authorId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        type: 'text',
        content: 'Сегодня создала потрясающий образ для моей клиентки!',
        privacy: 'public',
        repostOfId: null,
        likesCount: 28,
        isLiked: false,
        commentsCount: 2,
        repostsCount: 0,
        viewsCount: 77,
        locationLat: null,
        locationLng: null,
        locationName: null,
        commentsDisabled: false,
        isPinned: true,
        createdAt: '2026-02-04T10:00:00.000Z',
        updatedAt: '2026-02-04T11:00:00.000Z',
        author: {
          id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          email: 'anna.master@test.com',
          firstName: 'Анна',
          lastName: 'Иванова',
          avatarUrl: null,
          isMaster: true,
          isVerified: true,
          isPremium: false,
        },
        media: [],
        repostOf: null,
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный UUID',
    schema: {
      example: {
        statusCode: 400,
        message: 'Validation failed (uuid is expected)',
        error: 'Bad Request',
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiForbiddenResponse({
    description: 'Можно закреплять только свои посты',
    schema: {
      example: {
        statusCode: 403,
        message: 'You can only pin your own posts',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Пост не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Post not found',
        error: 'Not Found',
      },
    },
  })
  pin(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.postsService.pin(id, userId);
  }

  @Post(':id/unpin')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Открепить пост',
    description: 'Открепляет пост из профиля пользователя.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID поста',
    example: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
  })
  @ApiOkResponse({
    description: 'Пост откреплен',
    type: PostResponseDto,
    schema: {
      example: {
        id: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
        authorId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
        type: 'text',
        content: 'Сегодня создала потрясающий образ для моей клиентки!',
        privacy: 'public',
        repostOfId: null,
        likesCount: 28,
        isLiked: false,
        commentsCount: 2,
        repostsCount: 0,
        viewsCount: 77,
        locationLat: null,
        locationLng: null,
        locationName: null,
        commentsDisabled: false,
        isPinned: false,
        createdAt: '2026-02-04T10:00:00.000Z',
        updatedAt: '2026-02-04T11:00:00.000Z',
        author: {
          id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          email: 'anna.master@test.com',
          firstName: 'Анна',
          lastName: 'Иванова',
          avatarUrl: null,
          isMaster: true,
          isVerified: true,
          isPremium: false,
        },
        media: [],
        repostOf: null,
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный UUID',
    schema: {
      example: {
        statusCode: 400,
        message: 'Validation failed (uuid is expected)',
        error: 'Bad Request',
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiForbiddenResponse({
    description: 'Можно откреплять только свои посты',
    schema: {
      example: {
        statusCode: 403,
        message: 'You can only unpin your own posts',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Пост не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Post not found',
        error: 'Not Found',
      },
    },
  })
  unpin(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.postsService.unpin(id, userId);
  }

  @Post(':id/view')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Зарегистрировать просмотр поста',
    description: 'Увеличивает счетчик просмотров поста. Можно вызывать многократно.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID поста',
    example: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
  })
  @ApiOkResponse({
    description: 'Просмотр зарегистрирован',
    schema: {
      example: {
        message: 'View registered',
        viewsCount: 78,
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный UUID',
    schema: {
      example: {
        statusCode: 400,
        message: 'Validation failed (uuid is expected)',
        error: 'Bad Request',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Пост не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Post not found',
        error: 'Not Found',
      },
    },
  })
  incrementViews(@Param('id') id: string) {
    return this.postsService.incrementViews(id);
  }

  // Social endpoints (delegating to SocialModule services)

  @Post(':id/like')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Поставить лайк посту' })
  @ApiOkResponse({
    description: 'Обновленный пост с увеличенным количеством лайков',
    type: PostResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Пост не найден' })
  @ApiConflictResponse({ description: 'Лайк уже поставлен' })
  async likePost(@Param('id') id: string, @CurrentUser('id') userId: string) {
    await this.likesService.create(userId, {
      likable_type: LikableType.POST,
      likable_id: id,
    });
    // Чистим кэш и возвращаем обновленный пост (с корректным isLiked)
    await this.cacheService.delByPattern(`post:${id}:*`);
    await this.cacheService.delByPattern(`feed:${userId}:*`);
    return this.postsService.findOne(id, userId);
  }

  @Delete(':id/unlike')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Убрать лайк с поста' })
  @ApiOkResponse({
    description: 'Обновленный пост с уменьшенным количеством лайков',
    type: PostResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Пост не найден или лайк отсутствует' })
  async unlikePost(@Param('id') id: string, @CurrentUser('id') userId: string) {
    await this.likesService.remove(userId, LikableType.POST, id);
    // Чистим кэш и возвращаем обновленный пост (с корректным isLiked)
    await this.cacheService.delByPattern(`post:${id}:*`);
    await this.cacheService.delByPattern(`feed:${userId}:*`);
    return this.postsService.findOne(id, userId);
  }

  @Post(':id/comments')
  @ApiOperation({
    summary: 'Создать комментарий к посту',
    description: 'Создает комментарий к посту. Для ответа укажите parent_comment_id.',
  })
  @ApiCreatedResponse({
    description: 'Комментарий создан',
    type: CommentResponseDto,
  })
  @ApiNotFoundResponse({ description: 'Пост не найден' })
  createComment(
    @Param('id') postId: string,
    @CurrentUser('id') userId: string,
    @Body() body: CreateCommentBodyDto,
  ) {
    const createCommentDto: CreateCommentDto = {
      post_id: postId,
      content: body.content,
      parent_comment_id: body.parent_comment_id,
    };
    return this.commentsService.create(userId, createCommentDto);
  }

  @Get(':id/comments')
  @ApiOperation({
    summary: 'Получить комментарии к посту',
    description:
      'Возвращает список комментариев к посту. По умолчанию только верхний уровень (без ответов).',
  })
  @ApiQuery({
    name: 'page',
    required: false,
    description: 'Номер страницы (начиная с 1)',
    example: 1,
  })
  @ApiQuery({
    name: 'limit',
    required: false,
    description: 'Количество комментариев на странице',
    example: 20,
  })
  @ApiQuery({
    name: 'parent_comment_id',
    required: false,
    description: 'Если указан, вернутся только ответы на этот комментарий',
  })
  @ApiOkResponse({
    description: 'Список комментариев с пагинацией',
    schema: {
      example: {
        data: [
          {
            id: 'c1',
            post_id: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
            author_id: 'user-1',
            content: 'Отличная работа!',
            parent_comment_id: null,
            likes_count: 0,
            replies_count: 1,
            is_edited: false,
            created_at: '2026-02-04T10:10:00.000Z',
            updated_at: '2026-02-04T10:10:00.000Z',
          },
        ],
        meta: {
          page: 1,
          limit: 20,
          total: 2,
          totalPages: 1,
        },
      },
    },
  })
  getComments(@Param('id') postId: string, @Query() query: { page?: number; limit?: number; parent_comment_id?: string }) {
    const filterDto = {
      post_id: postId,
      page: query.page,
      limit: query.limit,
      parent_comment_id: query.parent_comment_id,
    } as FilterCommentsDto;
    return this.commentsService.findAll(filterDto);
  }

  @Delete(':postId/comments/:commentId')
  @ApiOperation({ summary: 'Удалить комментарий' })
  @ApiOkResponse({ description: 'Комментарий удален' })
  @ApiNotFoundResponse({ description: 'Комментарий не найден или не принадлежит пользователю' })
  deleteComment(
    @Param('commentId') commentId: string,
    @CurrentUser('id') userId: string,
  ) {
    return this.commentsService.remove(commentId, userId);
  }

  @Post(':id/repost')
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Сделать репост',
    description: 'Создает репост поста. Можно добавить комментарий к репосту.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID поста для репоста',
    example: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
  })
  @ApiCreatedResponse({
    description: 'Репост создан',
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        originalPostId: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
        createdAt: '2025-01-13T10:30:00Z',
        originalPost: {
          id: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
          authorId: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          type: 'text',
          content: 'Сегодня создала потрясающий образ для моей клиентки!',
          privacy: 'public',
          likesCount: 28,
          commentsCount: 2,
          repostsCount: 1,
        },
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      examples: {
        invalidUUID: {
          value: {
            statusCode: 400,
            message: 'Validation failed (uuid is expected)',
            error: 'Bad Request',
          },
        },
        selfRepost: {
          value: {
            statusCode: 400,
            message: 'Cannot repost your own post',
            error: 'Bad Request',
          },
        },
      },
    },
  })
  @ApiUnauthorizedResponse({
    description: 'Не авторизован',
    schema: {
      example: {
        statusCode: 401,
        message: 'Unauthorized',
        error: 'Unauthorized',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Пост не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Post not found',
        error: 'Not Found',
      },
    },
  })
  @ApiConflictResponse({
    description: 'Репост уже существует',
    schema: {
      example: {
        statusCode: 409,
        message: 'Repost already exists',
        error: 'Conflict',
      },
    },
  })
  repostPost(
    @Param('id') postId: string,
    @CurrentUser('id') userId: string,
    @Body() body: { comment?: string },
  ) {
    const createRepostDto: CreateRepostDto = {
      post_id: postId,
      comment: body.comment,
    };
    return this.repostsService.create(userId, createRepostDto);
  }
}
