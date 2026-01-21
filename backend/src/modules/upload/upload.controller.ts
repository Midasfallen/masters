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
import { ApiTags, ApiOperation, ApiResponse, ApiBearerAuth, ApiConsumes, ApiBody } from '@nestjs/swagger';
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
  @ApiOperation({ summary: 'Upload user avatar' })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: {
          type: 'string',
          format: 'binary',
        },
      },
    },
  })
  @ApiResponse({
    status: 200,
    description: 'Avatar uploaded successfully',
    schema: {
      type: 'object',
      properties: {
        url: { type: 'string', example: 'http://localhost:9000/avatars/avatar-uuid.jpg' },
      },
    },
  })
  @ApiResponse({ status: 400, description: 'Bad request - invalid file' })
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
  @ApiOperation({ summary: 'Upload post media (photo/video)' })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: {
          type: 'string',
          format: 'binary',
        },
      },
    },
  })
  @ApiResponse({
    status: 200,
    description: 'Post media uploaded successfully',
    schema: {
      type: 'object',
      properties: {
        url: { type: 'string', example: 'http://localhost:9000/posts/post-uuid.jpg' },
      },
    },
  })
  @ApiResponse({ status: 400, description: 'Bad request - invalid file' })
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
  @ApiOperation({ summary: 'Upload portfolio image' })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: {
          type: 'string',
          format: 'binary',
        },
      },
    },
  })
  @ApiResponse({
    status: 200,
    description: 'Portfolio image uploaded successfully',
    schema: {
      type: 'object',
      properties: {
        url: { type: 'string', example: 'http://localhost:9000/portfolios/portfolio-uuid.jpg' },
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
