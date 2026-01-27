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
import { CommentsService } from './comments.service';
import { CreateCommentDto } from './dto/create-comment.dto';
import { UpdateCommentDto } from './dto/update-comment.dto';
import { FilterCommentsDto } from './dto/filter-comments.dto';
import { CommentResponseDto } from './dto/comment-response.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';

@ApiTags('Comments')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('comments')
export class CommentsController {
  constructor(private readonly commentsService: CommentsService) {}

  @Post()
  @ApiOperation({ summary: 'Создать комментарий' })
  create(@CurrentUser('id') userId: string, @Body() createCommentDto: CreateCommentDto): Promise<CommentResponseDto> {
    return this.commentsService.create(userId, createCommentDto);
  }

  @Get()
  @ApiOperation({ summary: 'Получить комментарии к посту' })
  findAll(@Query() filterDto: FilterCommentsDto) {
    return this.commentsService.findAll(filterDto);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Получить комментарий по ID' })
  findOne(@Param('id') id: string): Promise<CommentResponseDto> {
    return this.commentsService.findOne(id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Обновить комментарий' })
  update(
    @Param('id') id: string,
    @CurrentUser('id') userId: string,
    @Body() updateCommentDto: UpdateCommentDto,
  ): Promise<CommentResponseDto> {
    return this.commentsService.update(id, userId, updateCommentDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Удалить комментарий' })
  remove(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.commentsService.remove(id, userId);
  }
}
