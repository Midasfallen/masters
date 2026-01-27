import {
  Controller,
  Post,
  Delete,
  Body,
  Param,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
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
  @ApiOperation({ summary: 'Сделать репост' })
  create(@CurrentUser('id') userId: string, @Body() createRepostDto: CreateRepostDto): Promise<RepostResponseDto> {
    return this.repostsService.create(userId, createRepostDto);
  }

  @Delete(':postId')
  @ApiOperation({ summary: 'Удалить репост' })
  remove(@CurrentUser('id') userId: string, @Param('postId') postId: string) {
    return this.repostsService.remove(userId, postId);
  }
}
