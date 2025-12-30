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
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { PostsService } from './posts.service';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { FilterPostsDto } from './dto/filter-posts.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';

@ApiTags('Posts')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('posts')
export class PostsController {
  constructor(private readonly postsService: PostsService) {}

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
}
