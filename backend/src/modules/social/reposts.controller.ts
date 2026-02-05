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
import { RepostsService } from './reposts.service';
import { CreateRepostDto } from './dto/create-repost.dto';
import { RepostResponseDto } from './dto/repost-response.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';

@ApiTags('Reposts')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('reposts')
export class RepostsController {
  constructor(private readonly repostsService: RepostsService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Сделать репост',
    description: 'Создает репост поста. Репост создает новый пост, который ссылается на оригинальный.',
  })
  @ApiCreatedResponse({
    description: 'Репост успешно создан',
    type: RepostResponseDto,
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
        invalidData: {
          value: {
            statusCode: 400,
            message: ['post_id must be a UUID'],
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
  create(@CurrentUser('id') userId: string, @Body() createRepostDto: CreateRepostDto): Promise<RepostResponseDto> {
    return this.repostsService.create(userId, createRepostDto);
  }

  @Delete(':postId')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Удалить репост',
    description: 'Удаляет репост поста. Можно удалять только свои репосты.',
  })
  @ApiParam({
    name: 'postId',
    description: 'UUID оригинального поста',
    example: '7f189272-60d7-4622-aa10-f6e11dfbf41b',
  })
  @ApiNoContentResponse({
    description: 'Репост удален',
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
  @ApiNotFoundResponse({
    description: 'Репост не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Repost not found',
        error: 'Not Found',
      },
    },
  })
  remove(@CurrentUser('id') userId: string, @Param('postId') postId: string) {
    return this.repostsService.remove(userId, postId);
  }
}
