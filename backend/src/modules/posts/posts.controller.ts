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
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
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
  @ApiOperation({ summary: 'Создать новый пост' })
  async create(@CurrentUser('id') userId: string, @Body() createPostDto: CreatePostDto) {
    const result = await this.postsService.create(userId, createPostDto);
    await this.cacheService.delByPattern(`feed:${userId}:*`);
    return result;
  }

  @Get('feed')
  @ApiOperation({ summary: 'Получить ленту постов (алгоритмический feed)' })
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
  @ApiOperation({ summary: 'Получить пост по ID' })
  async findOne(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.cacheService.getOrSet(
      `post:${id}:user=${userId}`,
      () => this.postsService.findOne(id, userId),
      FEED_CACHE_TTL,
    );
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Обновить пост' })
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
  @ApiOperation({ summary: 'Удалить пост' })
  async remove(@Param('id') id: string, @CurrentUser('id') userId: string) {
    const result = await this.postsService.remove(id, userId);
    await this.cacheService.delByPattern(`feed:${userId}:*`);
    return result;
  }

  @Post(':id/pin')
  @ApiOperation({ summary: 'Закрепить пост' })
  pin(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.postsService.pin(id, userId);
  }

  @Post(':id/unpin')
  @ApiOperation({ summary: 'Открепить пост' })
  unpin(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.postsService.unpin(id, userId);
  }

  @Post(':id/view')
  @ApiOperation({ summary: 'Зарегистрировать просмотр поста' })
  incrementViews(@Param('id') id: string) {
    return this.postsService.incrementViews(id);
  }

  // Social endpoints (delegating to SocialModule services)

  @Post(':id/like')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Поставить лайк посту' })
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
  async unlikePost(@Param('id') id: string, @CurrentUser('id') userId: string) {
    await this.likesService.remove(userId, LikableType.POST, id);
    // Чистим кэш и возвращаем обновленный пост (с корректным isLiked)
    await this.cacheService.delByPattern(`post:${id}:*`);
    await this.cacheService.delByPattern(`feed:${userId}:*`);
    return this.postsService.findOne(id, userId);
  }

  @Post(':id/comments')
  @ApiOperation({ summary: 'Создать комментарий к посту' })
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
  @ApiOperation({ summary: 'Получить комментарии к посту' })
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
  deleteComment(
    @Param('commentId') commentId: string,
    @CurrentUser('id') userId: string,
  ) {
    return this.commentsService.remove(commentId, userId);
  }

  @Post(':id/repost')
  @ApiOperation({ summary: 'Сделать репост' })
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
