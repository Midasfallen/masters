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
import { MessagesService } from './messages.service';
import { CreateMessageDto } from './dto/create-message.dto';
import { UpdateMessageDto } from './dto/update-message.dto';
import { FilterMessagesDto } from './dto/filter-messages.dto';
import { MessageResponseDto } from './dto/message-response.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';

@ApiTags('Messages')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('messages')
export class MessagesController {
  constructor(private readonly messagesService: MessagesService) {}

  @Post()
  @ApiOperation({ summary: 'Отправить сообщение' })
  create(@CurrentUser('id') userId: string, @Body() createMessageDto: CreateMessageDto): Promise<MessageResponseDto> {
    return this.messagesService.create(userId, createMessageDto);
  }

  @Get()
  @ApiOperation({ summary: 'Получить сообщения чата' })
  findAll(@CurrentUser('id') userId: string, @Query() filterDto: FilterMessagesDto) {
    return this.messagesService.findAll(userId, filterDto);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Получить сообщение по ID' })
  findOne(@Param('id') id: string, @CurrentUser('id') userId: string): Promise<MessageResponseDto> {
    return this.messagesService.findOne(id, userId);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Редактировать сообщение' })
  update(
    @Param('id') id: string,
    @CurrentUser('id') userId: string,
    @Body() updateMessageDto: UpdateMessageDto,
  ): Promise<MessageResponseDto> {
    return this.messagesService.update(id, userId, updateMessageDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Удалить сообщение' })
  remove(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.messagesService.remove(id, userId);
  }

  @Patch(':id/read')
  @ApiOperation({ summary: 'Отметить сообщение как прочитанное' })
  markAsRead(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.messagesService.markAsRead(id, userId);
  }

  @Patch('chats/:chatId/read')
  @ApiOperation({ summary: 'Отметить все сообщения чата как прочитанные' })
  markChatAsRead(@Param('chatId') chatId: string, @CurrentUser('id') userId: string) {
    return this.messagesService.markChatAsRead(chatId, userId);
  }
}
