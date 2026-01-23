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
import { ChatsService } from './chats.service';
import { CreateChatDto } from './dto/create-chat.dto';
import { UpdateChatDto } from './dto/update-chat.dto';
import { MarkAsReadDto } from './dto/mark-as-read.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';
import { PaginationDto } from '../../common/dto/pagination.dto';

@ApiTags('Chats')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('chats')
export class ChatsController {
  constructor(private readonly chatsService: ChatsService) {}

  @Post()
  @ApiOperation({ summary: 'Создать новый чат' })
  create(@CurrentUser('id') userId: string, @Body() createChatDto: CreateChatDto) {
    return this.chatsService.create(userId, createChatDto);
  }

  @Get()
  @ApiOperation({ summary: 'Получить список чатов пользователя' })
  findAll(@CurrentUser('id') userId: string, @Query() paginationDto: PaginationDto) {
    return this.chatsService.findAll(userId, paginationDto);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Получить чат по ID' })
  findOne(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.chatsService.findOne(id, userId);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Обновить чат (только групповые чаты)' })
  update(
    @Param('id') id: string,
    @CurrentUser('id') userId: string,
    @Body() updateChatDto: UpdateChatDto,
  ) {
    return this.chatsService.update(id, userId, updateChatDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Покинуть чат / удалить чат' })
  remove(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.chatsService.remove(id, userId);
  }

  @Post(':id/read')
  @ApiOperation({ summary: 'Отметить сообщения как прочитанные' })
  markAsRead(
    @Param('id') id: string,
    @CurrentUser('id') userId: string,
    @Body() markAsReadDto: MarkAsReadDto,
  ) {
    return this.chatsService.markAsRead(id, userId, markAsReadDto);
  }

  @Post(':id/pin')
  @ApiOperation({ summary: 'Закрепить чат' })
  pinChat(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.chatsService.pinChat(id, userId);
  }

  @Post(':id/unpin')
  @ApiOperation({ summary: 'Открепить чат' })
  unpinChat(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.chatsService.unpinChat(id, userId);
  }

  @Post(':id/participants/:participantId')
  @ApiOperation({ summary: 'Добавить участника в групповой чат' })
  addParticipant(
    @Param('id') id: string,
    @Param('participantId') participantId: string,
    @CurrentUser('id') userId: string,
  ) {
    return this.chatsService.addParticipant(id, participantId, userId);
  }

  @Delete(':id/participants/:participantId')
  @ApiOperation({ summary: 'Удалить участника из группового чата' })
  removeParticipant(
    @Param('id') id: string,
    @Param('participantId') participantId: string,
    @CurrentUser('id') userId: string,
  ) {
    return this.chatsService.removeParticipant(id, participantId, userId);
  }
}
