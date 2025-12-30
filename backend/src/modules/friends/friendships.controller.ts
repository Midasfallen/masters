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
import { FriendshipsService } from './friendships.service';
import { CreateFriendshipDto } from './dto/create-friendship.dto';
import { UpdateFriendshipDto } from './dto/update-friendship.dto';
import { FilterFriendshipsDto } from './dto/filter-friendships.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';

@ApiTags('Friendships')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('friendships')
export class FriendshipsController {
  constructor(private readonly friendshipsService: FriendshipsService) {}

  @Post()
  @ApiOperation({ summary: 'Отправить запрос в друзья' })
  create(@CurrentUser('id') userId: string, @Body() createFriendshipDto: CreateFriendshipDto) {
    return this.friendshipsService.create(userId, createFriendshipDto);
  }

  @Get()
  @ApiOperation({ summary: 'Получить список друзей / запросов' })
  findAll(@CurrentUser('id') userId: string, @Query() filterDto: FilterFriendshipsDto) {
    return this.friendshipsService.findAll(userId, filterDto);
  }

  @Get('incoming')
  @ApiOperation({ summary: 'Получить входящие запросы в друзья' })
  getIncoming(@CurrentUser('id') userId: string, @Query() filterDto: FilterFriendshipsDto) {
    return this.friendshipsService.getIncoming(userId, filterDto);
  }

  @Get('outgoing')
  @ApiOperation({ summary: 'Получить исходящие запросы в друзья' })
  getOutgoing(@CurrentUser('id') userId: string, @Query() filterDto: FilterFriendshipsDto) {
    return this.friendshipsService.getOutgoing(userId, filterDto);
  }

  @Patch(':id/accept')
  @ApiOperation({ summary: 'Принять запрос в друзья' })
  accept(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.friendshipsService.accept(id, userId);
  }

  @Patch(':id/decline')
  @ApiOperation({ summary: 'Отклонить запрос в друзья' })
  decline(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.friendshipsService.decline(id, userId);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Удалить из друзей / отменить запрос' })
  remove(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.friendshipsService.remove(id, userId);
  }

  @Post(':id/block')
  @ApiOperation({ summary: 'Заблокировать пользователя' })
  block(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.friendshipsService.block(id, userId);
  }
}
