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
  ) {}

  @Post()
  @ApiOperation({ summary: 'Создать новый пост' })
  create(@CurrentUser('id') userId: string, @Body() createPostDto: CreatePostDto) {
    return this.postsService.create(userId, createPostDto);
  }

  @Get('feed')
  @ApiOperation({ summary: 'Получить ленту постов (алгоритмический feed)' })
  getFeed(@CurrentUser('id') userId: string, @Query() filterDto: FilterPostsDto) {
    return this.postsService.getFeed(userId, filterDto);
  }

  @Get('user/:userId')
  @ApiOperation({ summary: 'Получить посты пользователя' })
  getUserPosts(@Param('userId') userId: string, @Query() filterDto: FilterPostsDto) {
    return this.postsService.getUserPosts(userId, filterDto);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Получить пост по ID' })
  findOne(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.postsService.findOne(id, userId);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Обновить пост' })
  update(
    @Param('id') id: string,
    @CurrentUser('id') userId: string,
    @Body() updatePostDto: UpdatePostDto,
  ) {
    return this.postsService.update(id, userId, updatePostDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Удалить пост' })
  remove(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.postsService.remove(id, userId);
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
    // Return updated post with likes_count
    return this.postsService.findOne(id);
  }

  @Delete(':id/unlike')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Убрать лайк с поста' })
  async unlikePost(@Param('id') id: string, @CurrentUser('id') userId: string) {
    await this.likesService.remove(userId, LikableType.POST, id);
    // Return updated post with likes_count
    return this.postsService.findOne(id);
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
