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
import { MessagesService } from './messages.service';
import { CreateMessageDto } from './dto/create-message.dto';
import { UpdateMessageDto } from './dto/update-message.dto';
import { FilterMessagesDto } from './dto/filter-messages.dto';
import { MessageResponseDto } from './dto/message-response.dto';
import { MessageType } from './entities/message.entity';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../common/decorators/current-user.decorator';

@ApiTags('Messages')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard)
@Controller('messages')
export class MessagesController {
  constructor(private readonly messagesService: MessagesService) {}

  @Post()
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Отправить сообщение',
    description: 'Создает новое сообщение в чате. Поддерживает текстовые сообщения, медиа (фото, видео, файлы) и локации.',
  })
  @ApiCreatedResponse({
    description: 'Сообщение отправлено',
    type: MessageResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        chatId: '550e8400-e29b-41d4-a716-446655440001',
        senderId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        type: 'text',
        content: 'Привет! Как дела?',
        mediaUrl: null,
        thumbnailUrl: null,
        mediaMetadata: null,
        locationLat: null,
        locationLng: null,
        locationName: null,
        isEdited: false,
        isDeleted: false,
        deletedAt: null,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T10:30:00Z',
        sender: {
          id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: 'https://storage.example.com/avatar.jpg',
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
            message: [
              'chat_id must be a UUID',
              'type must be one of the following values: text, image, video, file, location',
              'content must be a string',
            ],
            error: 'Bad Request',
          },
        },
        noContent: {
          value: {
            statusCode: 400,
            message: 'Message must have content, media, or location',
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
  @ApiForbiddenResponse({
    description: 'Нет доступа к этому чату',
    schema: {
      example: {
        statusCode: 403,
        message: 'You do not have access to this chat',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Чат не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Chat not found',
        error: 'Not Found',
      },
    },
  })
  create(@CurrentUser('id') userId: string, @Body() createMessageDto: CreateMessageDto): Promise<MessageResponseDto> {
    return this.messagesService.create(userId, createMessageDto);
  }

  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить сообщения чата',
    description: 'Возвращает список сообщений чата с пагинацией и фильтрацией',
  })
  @ApiQuery({
    name: 'chat_id',
    required: true,
    type: String,
    description: 'UUID чата',
    example: '550e8400-e29b-41d4-a716-446655440001',
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
    example: 50,
  })
  @ApiOkResponse({
    description: 'Список сообщений',
    schema: {
      example: {
        data: [
          {
            id: '550e8400-e29b-41d4-a716-446655440000',
            chatId: '550e8400-e29b-41d4-a716-446655440001',
            senderId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
            type: 'text',
            content: 'Привет! Как дела?',
            mediaUrl: null,
            thumbnailUrl: null,
            mediaMetadata: null,
            locationLat: null,
            locationLng: null,
            locationName: null,
            isEdited: false,
            isDeleted: false,
            deletedAt: null,
            createdAt: '2025-01-13T10:30:00Z',
            updatedAt: '2025-01-13T10:30:00Z',
            sender: {
              id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
              firstName: 'Иван',
              lastName: 'Петров',
              avatarUrl: 'https://storage.example.com/avatar.jpg',
            },
          },
        ],
        total: 150,
        page: 1,
        limit: 50,
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные',
    schema: {
      example: {
        statusCode: 400,
        message: ['chat_id must be a UUID'],
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
    description: 'Нет доступа к этому чату',
    schema: {
      example: {
        statusCode: 403,
        message: 'You do not have access to this chat',
        error: 'Forbidden',
      },
    },
  })
  findAll(@CurrentUser('id') userId: string, @Query() filterDto: FilterMessagesDto) {
    return this.messagesService.findAll(userId, filterDto);
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить сообщение по ID',
    description: 'Возвращает детальную информацию о сообщении. Доступ только для участников чата.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID сообщения',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Данные сообщения',
    type: MessageResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        chatId: '550e8400-e29b-41d4-a716-446655440001',
        senderId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        type: 'text',
        content: 'Привет! Как дела?',
        mediaUrl: null,
        thumbnailUrl: null,
        mediaMetadata: null,
        locationLat: null,
        locationLng: null,
        locationName: null,
        isEdited: false,
        isDeleted: false,
        deletedAt: null,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T10:30:00Z',
        sender: {
          id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: 'https://storage.example.com/avatar.jpg',
        },
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
    description: 'Нет доступа к этому сообщению',
    schema: {
      example: {
        statusCode: 403,
        message: 'You do not have access to this message',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Сообщение не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Message not found',
        error: 'Not Found',
      },
    },
  })
  findOne(@Param('id') id: string, @CurrentUser('id') userId: string): Promise<MessageResponseDto> {
    return this.messagesService.findOne(id, userId);
  }

  @Patch(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Редактировать сообщение',
    description: 'Редактирует текст сообщения. Можно редактировать только свои сообщения в течение 15 минут после отправки.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID сообщения',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Сообщение отредактировано',
    type: MessageResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        chatId: '550e8400-e29b-41d4-a716-446655440001',
        senderId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        type: 'text',
        content: 'Привет! Как дела? (отредактировано)',
        mediaUrl: null,
        thumbnailUrl: null,
        mediaMetadata: null,
        locationLat: null,
        locationLng: null,
        locationName: null,
        isEdited: true,
        isDeleted: false,
        deletedAt: null,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T10:35:00Z',
        sender: {
          id: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          firstName: 'Иван',
          lastName: 'Петров',
          avatarUrl: 'https://storage.example.com/avatar.jpg',
        },
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные или истекло время редактирования',
    schema: {
      examples: {
        invalidData: {
          value: {
            statusCode: 400,
            message: ['content must be a string'],
            error: 'Bad Request',
          },
        },
        editTimeout: {
          value: {
            statusCode: 400,
            message: 'Cannot edit message after 15 minutes',
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
  @ApiForbiddenResponse({
    description: 'Можно редактировать только свои сообщения',
    schema: {
      example: {
        statusCode: 403,
        message: 'You can only edit your own messages',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Сообщение не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Message not found',
        error: 'Not Found',
      },
    },
  })
  update(
    @Param('id') id: string,
    @CurrentUser('id') userId: string,
    @Body() updateMessageDto: UpdateMessageDto,
  ): Promise<MessageResponseDto> {
    return this.messagesService.update(id, userId, updateMessageDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  @ApiOperation({
    summary: 'Удалить сообщение',
    description: 'Удаляет сообщение (soft delete). Можно удалять только свои сообщения.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID сообщения',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiNoContentResponse({
    description: 'Сообщение удалено',
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
    description: 'Можно удалять только свои сообщения',
    schema: {
      example: {
        statusCode: 403,
        message: 'You can only delete your own messages',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Сообщение не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Message not found',
        error: 'Not Found',
      },
    },
  })
  remove(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.messagesService.remove(id, userId);
  }

  @Patch(':id/read')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Отметить сообщение как прочитанное',
    description: 'Отмечает конкретное сообщение как прочитанное',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID сообщения',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Сообщение отмечено как прочитанное',
    schema: {
      example: {
        message: 'Message marked as read',
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
    description: 'Сообщение не найдено',
    schema: {
      example: {
        statusCode: 404,
        message: 'Message not found',
        error: 'Not Found',
      },
    },
  })
  markAsRead(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.messagesService.markAsRead(id, userId);
  }

  @Patch('chats/:chatId/read')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Отметить все сообщения чата как прочитанные',
    description: 'Отмечает все непрочитанные сообщения в чате как прочитанные',
  })
  @ApiParam({
    name: 'chatId',
    description: 'UUID чата',
    example: '550e8400-e29b-41d4-a716-446655440001',
  })
  @ApiOkResponse({
    description: 'Все сообщения отмечены как прочитанные',
    schema: {
      example: {
        message: 'All messages in chat marked as read',
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
    description: 'Чат не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Chat not found',
        error: 'Not Found',
      },
    },
  })
  markChatAsRead(@Param('chatId') chatId: string, @CurrentUser('id') userId: string) {
    return this.messagesService.markChatAsRead(chatId, userId);
  }
}
