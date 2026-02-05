import {
  Controller,
  Post,
  UploadedFile,
  UseInterceptors,
  BadRequestException,
  HttpCode,
  HttpStatus,
  UseGuards,
  Req,
} from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiConsumes,
  ApiBody,
  ApiOkResponse,
  ApiBadRequestResponse,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { UploadService } from './upload.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@ApiTags('upload')
@Controller('upload')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth()
export class UploadController {
  constructor(private readonly uploadService: UploadService) {}

  @Post('avatar')
  @HttpCode(HttpStatus.OK)
  @UseInterceptors(FileInterceptor('file'))
  @ApiOperation({
    summary: 'Загрузить аватар пользователя',
    description: 'Загружает изображение аватара пользователя. Поддерживает JPEG, PNG, WEBP. Максимальный размер: 5MB.',
  })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      required: ['file'],
      properties: {
        file: {
          type: 'string',
          format: 'binary',
          description: 'Изображение аватара (JPEG, PNG, WEBP)',
        },
      },
    },
  })
  @ApiOkResponse({
    description: 'Аватар успешно загружен',
    schema: {
      example: {
        url: 'http://localhost:9000/avatars/avatar-uuid.jpg',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный файл',
    schema: {
      examples: {
        noFile: {
          value: {
            statusCode: 400,
            message: 'No file uploaded',
            error: 'Bad Request',
          },
        },
        invalidType: {
          value: {
            statusCode: 400,
            message: 'Invalid file type. Only JPEG, PNG, WEBP allowed',
            error: 'Bad Request',
          },
        },
        tooLarge: {
          value: {
            statusCode: 400,
            message: 'File too large. Max size is 5MB',
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
  async uploadAvatar(
    @UploadedFile() file: Express.Multer.File,
    @Req() req,
  ): Promise<{ url: string }> {
    if (!file) {
      throw new BadRequestException('No file uploaded');
    }

    // Validate file type
    const allowedMimes = ['image/jpeg', 'image/png', 'image/webp'];
    if (!allowedMimes.includes(file.mimetype)) {
      throw new BadRequestException('Invalid file type. Only JPEG, PNG, WEBP allowed');
    }

    // Validate file size (max 5MB)
    const maxSize = 5 * 1024 * 1024; // 5MB
    if (file.size > maxSize) {
      throw new BadRequestException('File too large. Max size is 5MB');
    }

    const userId = req.user.id;
    const url = await this.uploadService.uploadAvatar(file, userId);

    return { url };
  }

  @Post('post')
  @HttpCode(HttpStatus.OK)
  @UseInterceptors(FileInterceptor('file'))
  @ApiOperation({
    summary: 'Загрузить медиа для поста',
    description: 'Загружает фото или видео для поста. Поддерживает JPEG, PNG, WEBP (до 10MB) и MP4 (до 100MB).',
  })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      required: ['file'],
      properties: {
        file: {
          type: 'string',
          format: 'binary',
          description: 'Медиа файл (JPEG, PNG, WEBP до 10MB или MP4 до 100MB)',
        },
        postId: {
          type: 'string',
          description: 'UUID поста (опционально, если не указан - используется temp)',
          example: '550e8400-e29b-41d4-a716-446655440000',
        },
      },
    },
  })
  @ApiOkResponse({
    description: 'Медиа успешно загружено',
    schema: {
      example: {
        url: 'http://localhost:9000/posts/post-uuid.jpg',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный файл',
    schema: {
      examples: {
        noFile: {
          value: {
            statusCode: 400,
            message: 'No file uploaded',
            error: 'Bad Request',
          },
        },
        invalidType: {
          value: {
            statusCode: 400,
            message: 'Invalid file type. Only JPEG, PNG, WEBP, MP4 allowed',
            error: 'Bad Request',
          },
        },
        tooLarge: {
          value: {
            statusCode: 400,
            message: 'File too large. Max size is 10MB',
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
  async uploadPostMedia(
    @UploadedFile() file: Express.Multer.File,
    @Req() req,
  ): Promise<{ url: string }> {
    if (!file) {
      throw new BadRequestException('No file uploaded');
    }

    // Validate file type
    const allowedMimes = ['image/jpeg', 'image/png', 'image/webp', 'video/mp4'];
    if (!allowedMimes.includes(file.mimetype)) {
      throw new BadRequestException('Invalid file type. Only JPEG, PNG, WEBP, MP4 allowed');
    }

    // Validate file size (max 100MB for videos, 10MB for images)
    const isVideo = file.mimetype.startsWith('video/');
    const maxSize = isVideo ? 100 * 1024 * 1024 : 10 * 1024 * 1024;
    if (file.size > maxSize) {
      throw new BadRequestException(
        `File too large. Max size is ${isVideo ? '100MB' : '10MB'}`,
      );
    }

    const postId = req.body.postId || 'temp'; // postId can be provided or generated
    const url = await this.uploadService.uploadPostMedia(file, postId);

    return { url };
  }

  @Post('portfolio')
  @HttpCode(HttpStatus.OK)
  @UseInterceptors(FileInterceptor('file'))
  @ApiOperation({
    summary: 'Загрузить изображение портфолио',
    description: 'Загружает изображение для портфолио мастера. Поддерживает JPEG, PNG, WEBP. Максимальный размер: 10MB.',
  })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      required: ['file'],
      properties: {
        file: {
          type: 'string',
          format: 'binary',
          description: 'Изображение портфолио (JPEG, PNG, WEBP)',
        },
      },
    },
  })
  @ApiOkResponse({
    description: 'Изображение портфолио успешно загружено',
    schema: {
      example: {
        url: 'http://localhost:9000/portfolios/portfolio-uuid.jpg',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный файл',
    schema: {
      examples: {
        noFile: {
          value: {
            statusCode: 400,
            message: 'No file uploaded',
            error: 'Bad Request',
          },
        },
        invalidType: {
          value: {
            statusCode: 400,
            message: 'Invalid file type. Only JPEG, PNG, WEBP allowed',
            error: 'Bad Request',
          },
        },
        tooLarge: {
          value: {
            statusCode: 400,
            message: 'File too large. Max size is 10MB',
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
  async uploadPortfolio(
    @UploadedFile() file: Express.Multer.File,
    @Req() req,
  ): Promise<{ url: string }> {
    if (!file) {
      throw new BadRequestException('No file uploaded');
    }

    const allowedMimes = ['image/jpeg', 'image/png', 'image/webp'];
    if (!allowedMimes.includes(file.mimetype)) {
      throw new BadRequestException('Invalid file type. Only JPEG, PNG, WEBP allowed');
    }

    const maxSize = 10 * 1024 * 1024; // 10MB
    if (file.size > maxSize) {
      throw new BadRequestException('File too large. Max size is 10MB');
    }

    const userId = req.user.id;
    const url = await this.uploadService.uploadPortfolio(file, userId);

    return { url };
  }
}
