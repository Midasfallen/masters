import {
  Controller,
  Post,
  Delete,
  Body,
  Param,
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
  ApiNotFoundResponse,
  ApiConflictResponse,
  ApiParam,
  ApiNoContentResponse,
} from '@nestjs/swagger';
import { LikesService } from './likes.service';
import { CreateLikeDto } from './dto/create-like.dto';
import { LikeResponseDto } from './dto/like-response.dto';
import { LikableType } from './entities/like.entity';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';

@ApiTags('Likes')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('likes')
export class LikesController {
  constructor(private readonly likesService: LikesService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Поставить лайк',
    description: 'Ставит лайк на пост или комментарий. Поддерживает типы: post, comment.',
  })
  @ApiCreatedResponse({
    description: 'Лайк успешно поставлен',
    type: LikeResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        likableType: 'post',
        likableId: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
        createdAt: '2025-01-13T10:30:00Z',
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
              'likable_type must be one of the following values: post, comment',
              'likable_id must be a UUID',
            ],
            error: 'Bad Request',
          },
        },
        selfLike: {
          value: {
            statusCode: 400,
            message: 'Cannot like your own content',
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
    description: 'Пост или комментарий не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Post or comment not found',
        error: 'Not Found',
      },
    },
  })
  @ApiConflictResponse({
    description: 'Лайк уже поставлен',
    schema: {
      example: {
        statusCode: 409,
        message: 'Like already exists',
        error: 'Conflict',
      },
    },
  })
  create(@CurrentUser('id') userId: string, @Body() createLikeDto: CreateLikeDto): Promise<LikeResponseDto> {
    return this.likesService.create(userId, createLikeDto);
  }

  @Delete(':likableType/:likableId')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Убрать лайк',
    description: 'Удаляет лайк с поста или комментария',
  })
  @ApiParam({
    name: 'likableType',
    enum: LikableType,
    description: 'Тип сущности (post, comment)',
    example: LikableType.POST,
  })
  @ApiParam({
    name: 'likableId',
    description: 'UUID поста или комментария',
    example: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
  })
  @ApiNoContentResponse({
    description: 'Лайк успешно убран',
  })
  @ApiBadRequestResponse({
    description: 'Некорректный тип или UUID',
    schema: {
      example: {
        statusCode: 400,
        message: [
          'likableType must be one of the following values: post, comment',
          'likableId must be a UUID',
        ],
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
  @ApiNotFoundResponse({
    description: 'Лайк не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Like not found',
        error: 'Not Found',
      },
    },
  })
  remove(
    @CurrentUser('id') userId: string,
    @Param('likableType') likableType: string,
    @Param('likableId') likableId: string,
  ) {
    return this.likesService.remove(userId, likableType, likableId);
  }
}
