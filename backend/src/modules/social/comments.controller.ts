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
  ApiCreatedResponse,
  ApiOkResponse,
  ApiBadRequestResponse,
  ApiUnauthorizedResponse,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiParam,
  ApiQuery,
  ApiNoContentResponse,
} from '@nestjs/swagger';
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
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Создать комментарий',
    description: 'Создает новый комментарий к посту. Комментарии могут быть вложенными (ответы на комментарии).',
  })
  @ApiCreatedResponse({
    description: 'Комментарий успешно создан',
    type: CommentResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        postId: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
        authorId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        parentId: null,
        content: 'Отличная работа! Очень понравилось.',
        likesCount: 0,
        repliesCount: 0,
        isEdited: false,
        isDeleted: false,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T10:30:00Z',
        author: {
          id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: 'https://storage.example.com/avatar.jpg',
        },
        parent: null,
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      examples: {
        invalidData: {
          value: {
            statusCode: 400,
            message: [
              'post_id must be a UUID',
              'content must be longer than or equal to 1 characters',
            ],
            error: 'Bad Request',
          },
        },
        commentsDisabled: {
          value: {
            statusCode: 400,
            message: 'Comments are disabled for this post',
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
  create(@CurrentUser('id') userId: string, @Body() createCommentDto: CreateCommentDto): Promise<CommentResponseDto> {
    return this.commentsService.create(userId, createCommentDto);
  }

  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить комментарии к посту',
    description: 'Возвращает список комментариев к посту с пагинацией. Поддерживает фильтрацию по родительскому комментарию для получения ответов.',
  })
  @ApiQuery({
    name: 'post_id',
    required: true,
    type: String,
    description: 'UUID поста',
    example: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
  })
  @ApiQuery({
    name: 'parent_id',
    required: false,
    type: String,
    description: 'UUID родительского комментария (для получения ответов)',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiQuery({
    name: 'page',
    required: false,
    type: Number,
    description: 'Номер страницы',
    example: 1,
  })
  @ApiQuery({
    name: 'limit',
    required: false,
    type: Number,
    description: 'Количество элементов на странице',
    example: 20,
  })
  @ApiOkResponse({
    description: 'Список комментариев',
    schema: {
      example: {
        data: [
          {
            id: '550e8400-e29b-41d4-a716-446655440000',
            postId: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
            authorId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
            parentId: null,
            content: 'Отличная работа! Очень понравилось.',
            likesCount: 5,
            repliesCount: 2,
            isEdited: false,
            isDeleted: false,
            createdAt: '2025-01-13T10:30:00Z',
            updatedAt: '2025-01-13T10:30:00Z',
            author: {
              id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
              firstName: 'Иван',
              lastName: 'Петров',
              avatarUrl: 'https://storage.example.com/avatar.jpg',
            },
            parent: null,
          },
        ],
        total: 15,
        page: 1,
        limit: 20,
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      example: {
        statusCode: 400,
        message: ['post_id must be a UUID'],
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
  findAll(@Query() filterDto: FilterCommentsDto) {
    return this.commentsService.findAll(filterDto);
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить комментарий по ID',
    description: 'Возвращает детальную информацию о комментарии',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID комментария',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Данные комментария',
    type: CommentResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        postId: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
        authorId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        parentId: null,
        content: 'Отличная работа! Очень понравилось.',
        likesCount: 5,
        repliesCount: 2,
        isEdited: false,
        isDeleted: false,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T10:30:00Z',
        author: {
          id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: 'https://storage.example.com/avatar.jpg',
        },
        parent: null,
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
    description: 'Комментарий не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Comment not found',
        error: 'Not Found',
      },
    },
  })
  findOne(@Param('id') id: string): Promise<CommentResponseDto> {
    return this.commentsService.findOne(id);
  }

  @Patch(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Обновить комментарий',
    description: 'Редактирует текст комментария. Можно редактировать только свои комментарии.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID комментария',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Комментарий обновлен',
    type: CommentResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        postId: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
        authorId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        parentId: null,
        content: 'Отличная работа! Очень понравилось. (отредактировано)',
        likesCount: 5,
        repliesCount: 2,
        isEdited: true,
        isDeleted: false,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T10:35:00Z',
        author: {
          id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: 'https://storage.example.com/avatar.jpg',
        },
        parent: null,
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
    description: 'Можно редактировать только свои комментарии',
    schema: {
      example: {
        statusCode: 403,
        message: 'You can only edit your own comments',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Комментарий не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Comment not found',
        error: 'Not Found',
      },
    },
  })
  update(
    @Param('id') id: string,
    @CurrentUser('id') userId: string,
    @Body() updateCommentDto: UpdateCommentDto,
  ): Promise<CommentResponseDto> {
    return this.commentsService.update(id, userId, updateCommentDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Удалить комментарий',
    description: 'Удаляет комментарий (soft delete). Можно удалять только свои комментарии.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID комментария',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiNoContentResponse({
    description: 'Комментарий удален',
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
    description: 'Можно удалять только свои комментарии',
    schema: {
      example: {
        statusCode: 403,
        message: 'You can only delete your own comments',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Комментарий не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Comment not found',
        error: 'Not Found',
      },
    },
  })
  remove(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.commentsService.remove(id, userId);
  }
}
