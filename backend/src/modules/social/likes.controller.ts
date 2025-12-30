import {
  Controller,
  Post,
  Delete,
  Body,
  Param,
  UseGuards,
} from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { LikesService } from './likes.service';
import { CreateLikeDto } from './dto/create-like.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';

@ApiTags('Likes')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('likes')
export class LikesController {
  constructor(private readonly likesService: LikesService) {}

  @Post()
  @ApiOperation({ summary: 'Поставить лайк' })
  create(@CurrentUser('id') userId: string, @Body() createLikeDto: CreateLikeDto) {
    return this.likesService.create(userId, createLikeDto);
  }

  @Delete(':likableType/:likableId')
  @ApiOperation({ summary: 'Убрать лайк' })
  remove(
    @CurrentUser('id') userId: string,
    @Param('likableType') likableType: string,
    @Param('likableId') likableId: string,
  ) {
    return this.likesService.remove(userId, likableType, likableId);
  }
}
