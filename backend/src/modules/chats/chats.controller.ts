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
import { ChatsService } from './chats.service';
import { CreateChatDto } from './dto/create-chat.dto';
import { UpdateChatDto } from './dto/update-chat.dto';
import { MarkAsReadDto } from './dto/mark-as-read.dto';
import { ChatResponseDto } from './dto/chat-response.dto';
import { ChatType } from './entities/chat.entity';
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
  @HttpCode(HttpStatus.CREATED)
  @ApiOperation({
    summary: 'Создать новый чат',
    description: 'Создает новый direct или групповой чат. Для direct чата нужен один участник, для группового - минимум 2.',
  })
  @ApiCreatedResponse({
    description: 'Чат создан',
    type: ChatResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        type: 'direct',
        name: null,
        avatarUrl: null,
        creatorId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        lastMessageId: null,
        lastMessageAt: null,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T10:30:00Z',
        myParticipant: {
          id: '550e8400-e29b-41d4-a716-446655440001',
          chatId: '550e8400-e29b-41d4-a716-446655440000',
          userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          isPinned: false,
          lastReadAt: null,
          joinedAt: '2025-01-13T10:30:00Z',
        },
        otherUser: {
          id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          firstName: 'Анна',
          lastName: 'Иванова',
          avatarUrl: 'https://storage.example.com/avatar2.jpg',
        },
        participants: null,
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
              'type must be one of the following values: direct, group',
              'participant_ids must be an array',
            ],
            error: 'Bad Request',
          },
        },
        invalidParticipants: {
          value: {
            statusCode: 400,
            message: 'Direct chat requires exactly 1 participant, group chat requires at least 2',
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
    description: 'Участник не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Participant not found',
        error: 'Not Found',
      },
    },
  })
  create(@CurrentUser('id') userId: string, @Body() createChatDto: CreateChatDto): Promise<ChatResponseDto> {
    return this.chatsService.create(userId, createChatDto);
  }

  @Get()
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить список чатов пользователя',
    description: 'Возвращает список всех чатов пользователя с пагинацией',
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
    example: 20,
  })
  @ApiOkResponse({
    description: 'Список чатов',
    schema: {
      example: {
        data: [
          {
            id: '550e8400-e29b-41d4-a716-446655440000',
            type: 'direct',
            name: null,
            avatarUrl: null,
            creatorId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
            lastMessageId: '550e8400-e29b-41d4-a716-446655440002',
            lastMessageAt: '2025-01-13T11:00:00Z',
            createdAt: '2025-01-13T10:30:00Z',
            updatedAt: '2025-01-13T11:00:00Z',
            myParticipant: {
              id: '550e8400-e29b-41d4-a716-446655440001',
              chatId: '550e8400-e29b-41d4-a716-446655440000',
              userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
              isPinned: false,
              lastReadAt: '2025-01-13T11:00:00Z',
              joinedAt: '2025-01-13T10:30:00Z',
            },
            otherUser: {
              id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
              firstName: 'Анна',
              lastName: 'Иванова',
              avatarUrl: 'https://storage.example.com/avatar2.jpg',
            },
            participants: null,
          },
        ],
        meta: {
          page: 1,
          limit: 20,
          total: 15,
          totalPages: 1,
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
  findAll(@CurrentUser('id') userId: string, @Query() paginationDto: PaginationDto) {
    return this.chatsService.findAll(userId, paginationDto);
  }

  @Get(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Получить чат по ID',
    description: 'Возвращает детальную информацию о чате. Доступ только для участников чата.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID чата',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Данные чата',
    type: ChatResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        type: 'direct',
        name: null,
        avatarUrl: null,
        creatorId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        lastMessageId: '550e8400-e29b-41d4-a716-446655440002',
        lastMessageAt: '2025-01-13T11:00:00Z',
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T11:00:00Z',
        myParticipant: {
          id: '550e8400-e29b-41d4-a716-446655440001',
          chatId: '550e8400-e29b-41d4-a716-446655440000',
          userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          isPinned: false,
          lastReadAt: '2025-01-13T11:00:00Z',
          joinedAt: '2025-01-13T10:30:00Z',
        },
        otherUser: {
          id: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
          firstName: 'Анна',
          lastName: 'Иванова',
          avatarUrl: 'https://storage.example.com/avatar2.jpg',
        },
        participants: null,
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
  findOne(@Param('id') id: string, @CurrentUser('id') userId: string): Promise<ChatResponseDto> {
    return this.chatsService.findOne(id, userId);
  }

  @Patch(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Обновить чат (только групповые чаты)',
    description: 'Обновляет название и аватар группового чата. Только создатель может обновлять.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID чата',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Чат обновлен',
    type: ChatResponseDto,
    schema: {
      example: {
        id: '550e8400-e29b-41d4-a716-446655440000',
        type: 'group',
        name: 'Команда разработки (обновлено)',
        avatarUrl: 'https://storage.example.com/chats/avatar.jpg',
        creatorId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
        lastMessageId: null,
        lastMessageAt: null,
        createdAt: '2025-01-13T10:30:00Z',
        updatedAt: '2025-01-13T11:05:00Z',
        myParticipant: {
          id: '550e8400-e29b-41d4-a716-446655440001',
          chatId: '550e8400-e29b-41d4-a716-446655440000',
          userId: '0517ac4e-e4a6-465b-a41f-c86e95d13476',
          isPinned: false,
          lastReadAt: null,
          joinedAt: '2025-01-13T10:30:00Z',
        },
        otherUser: null,
        participants: [],
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректные данные или попытка обновить direct чат',
    schema: {
      examples: {
        invalidData: {
          value: {
            statusCode: 400,
            message: ['name must be shorter than or equal to 255 characters'],
            error: 'Bad Request',
          },
        },
        directChat: {
          value: {
            statusCode: 400,
            message: 'Cannot update direct chat',
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
    description: 'Только создатель может обновлять чат',
    schema: {
      example: {
        statusCode: 403,
        message: 'Only creator can update chat',
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
  update(
    @Param('id') id: string,
    @CurrentUser('id') userId: string,
    @Body() updateChatDto: UpdateChatDto,
  ): Promise<ChatResponseDto> {
    return this.chatsService.update(id, userId, updateChatDto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Покинуть чат / удалить чат',
    description: 'Для direct чата - удаляет чат полностью. Для группового - удаляет участника из чата.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID чата',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Чат удален или участник покинул чат',
    schema: {
      example: {
        message: 'Chat deleted successfully',
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
  remove(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.chatsService.remove(id, userId);
  }

  @Post(':id/read')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Отметить сообщения как прочитанные',
    description: 'Отмечает все сообщения в чате до указанного сообщения как прочитанные',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID чата',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Сообщения отмечены как прочитанные',
    schema: {
      example: {
        message: 'Messages marked as read',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный UUID или данные',
    schema: {
      example: {
        statusCode: 400,
        message: ['last_message_id must be a UUID'],
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
  markAsRead(
    @Param('id') id: string,
    @CurrentUser('id') userId: string,
    @Body() markAsReadDto: MarkAsReadDto,
  ) {
    return this.chatsService.markAsRead(id, userId, markAsReadDto);
  }

  @Post(':id/pin')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Закрепить чат',
    description: 'Закрепляет чат в списке чатов пользователя',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID чата',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Чат закреплен',
    schema: {
      example: {
        message: 'Chat pinned successfully',
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
  pinChat(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.chatsService.pinChat(id, userId);
  }

  @Post(':id/unpin')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Открепить чат',
    description: 'Открепляет чат из списка закрепленных чатов',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID чата',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiOkResponse({
    description: 'Чат откреплен',
    schema: {
      example: {
        message: 'Chat unpinned successfully',
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
  unpinChat(@Param('id') id: string, @CurrentUser('id') userId: string) {
    return this.chatsService.unpinChat(id, userId);
  }

  @Post(':id/participants/:participantId')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Добавить участника в групповой чат',
    description: 'Добавляет нового участника в групповой чат. Только для групповых чатов.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID чата',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiParam({
    name: 'participantId',
    description: 'UUID участника для добавления',
    example: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
  })
  @ApiOkResponse({
    description: 'Участник добавлен',
    schema: {
      example: {
        message: 'Participant added successfully',
      },
    },
  })
  @ApiBadRequestResponse({
    description: 'Некорректный UUID или попытка добавить в direct чат',
    schema: {
      examples: {
        invalidUUID: {
          value: {
            statusCode: 400,
            message: 'Validation failed (uuid is expected)',
            error: 'Bad Request',
          },
        },
        directChat: {
          value: {
            statusCode: 400,
            message: 'Cannot add participants to direct chat',
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
    description: 'Нет прав для добавления участников',
    schema: {
      example: {
        statusCode: 403,
        message: 'You do not have permission to add participants',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Чат или пользователь не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Chat or user not found',
        error: 'Not Found',
      },
    },
  })
  addParticipant(
    @Param('id') id: string,
    @Param('participantId') participantId: string,
    @CurrentUser('id') userId: string,
  ) {
    return this.chatsService.addParticipant(id, participantId, userId);
  }

  @Delete(':id/participants/:participantId')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({
    summary: 'Удалить участника из группового чата',
    description: 'Удаляет участника из группового чата. Только создатель может удалять участников.',
  })
  @ApiParam({
    name: 'id',
    description: 'UUID чата',
    example: '550e8400-e29b-41d4-a716-446655440000',
  })
  @ApiParam({
    name: 'participantId',
    description: 'UUID участника для удаления',
    example: 'bebd027c-e57a-4adc-bdd5-9cd4b1e544fe',
  })
  @ApiOkResponse({
    description: 'Участник удален',
    schema: {
      example: {
        message: 'Participant removed successfully',
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
    description: 'Только создатель может удалять участников',
    schema: {
      example: {
        statusCode: 403,
        message: 'Only creator can remove participants',
        error: 'Forbidden',
      },
    },
  })
  @ApiNotFoundResponse({
    description: 'Чат или участник не найден',
    schema: {
      example: {
        statusCode: 404,
        message: 'Chat or participant not found',
        error: 'Not Found',
      },
    },
  })
  removeParticipant(
    @Param('id') id: string,
    @Param('participantId') participantId: string,
    @CurrentUser('id') userId: string,
  ) {
    return this.chatsService.removeParticipant(id, participantId, userId);
  }
}
