import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Message, MessageType } from './entities/message.entity';
import { Chat } from './entities/chat.entity';
import { ChatParticipant } from './entities/chat-participant.entity';
import { CreateMessageDto } from './dto/create-message.dto';
import { UpdateMessageDto } from './dto/update-message.dto';
import { FilterMessagesDto } from './dto/filter-messages.dto';

@Injectable()
export class MessagesService {
  constructor(
    @InjectRepository(Message)
    private readonly messageRepository: Repository<Message>,
    @InjectRepository(Chat)
    private readonly chatRepository: Repository<Chat>,
    @InjectRepository(ChatParticipant)
    private readonly participantRepository: Repository<ChatParticipant>,
  ) {}

  async create(userId: string, createMessageDto: CreateMessageDto) {
    const { chat_id, type, reply_to_id } = createMessageDto;

    // Проверка участия в чате
    const participant = await this.participantRepository.findOne({
      where: { chat_id, user_id: userId },
    });

    if (!participant || participant.is_removed) {
      throw new ForbiddenException('Access denied');
    }

    // Проверка родительского сообщения
    if (reply_to_id) {
      const replyTo = await this.messageRepository.findOne({
        where: { id: reply_to_id, chat_id },
      });

      if (!replyTo) {
        throw new NotFoundException('Reply message not found');
      }
    }

    // Валидация контента в зависимости от типа
    this.validateMessageContent(createMessageDto);

    const message = this.messageRepository.create({
      ...createMessageDto,
      sender_id: userId,
    });

    const savedMessage = await this.messageRepository.save(message);

    // Обновление последнего сообщения в чате
    await this.chatRepository.update(chat_id, {
      last_message_id: savedMessage.id,
      last_message_at: savedMessage.created_at,
    });

    // Увеличение счетчика непрочитанных для всех участников кроме отправителя
    await this.participantRepository
      .createQueryBuilder()
      .update(ChatParticipant)
      .set({ unread_count: () => 'unread_count + 1' })
      .where('chat_id = :chat_id', { chat_id })
      .andWhere('user_id != :userId', { userId })
      .andWhere('is_removed = :isRemoved', { isRemoved: false })
      .execute();

    return this.findOne(savedMessage.id, userId);
  }

  async findAll(userId: string, filterDto: FilterMessagesDto) {
    const { chat_id, type, page = 1, limit = 50 } = filterDto;

    // Проверка участия в чате
    const participant = await this.participantRepository.findOne({
      where: { chat_id, user_id: userId },
    });

    if (!participant || participant.is_removed) {
      throw new ForbiddenException('Access denied');
    }

    const queryBuilder = this.messageRepository
      .createQueryBuilder('message')
      .leftJoinAndSelect('message.sender', 'sender')
      .leftJoinAndSelect('message.reply_to', 'reply_to')
      .leftJoinAndSelect('reply_to.sender', 'reply_to_sender')
      .where('message.chat_id = :chat_id', { chat_id })
      .andWhere('message.is_deleted = :isDeleted', { isDeleted: false })
      .orderBy('message.created_at', 'DESC');

    if (type) {
      queryBuilder.andWhere('message.type = :type', { type });
    }

    const [messages, total] = await queryBuilder
      .skip((page - 1) * limit)
      .take(limit)
      .getManyAndCount();

    return {
      data: messages.reverse(), // Реверсируем для хронологического порядка
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findOne(id: string, userId: string) {
    const message = await this.messageRepository.findOne({
      where: { id },
      relations: ['sender', 'reply_to', 'reply_to.sender', 'chat'],
    });

    if (!message) {
      throw new NotFoundException('Message not found');
    }

    // Проверка участия в чате
    const participant = await this.participantRepository.findOne({
      where: { chat_id: message.chat_id, user_id: userId },
    });

    if (!participant || participant.is_removed) {
      throw new ForbiddenException('Access denied');
    }

    return message;
  }

  async update(id: string, userId: string, updateMessageDto: UpdateMessageDto) {
    const message = await this.messageRepository.findOne({
      where: { id },
    });

    if (!message) {
      throw new NotFoundException('Message not found');
    }

    if (message.sender_id !== userId) {
      throw new ForbiddenException('You can only edit your own messages');
    }

    if (message.type !== MessageType.TEXT) {
      throw new BadRequestException('Can only edit text messages');
    }

    if (message.is_deleted) {
      throw new BadRequestException('Cannot edit deleted message');
    }

    await this.messageRepository.update(id, {
      content: updateMessageDto.content,
      is_edited: true,
    });

    return this.findOne(id, userId);
  }

  async remove(id: string, userId: string) {
    const message = await this.messageRepository.findOne({
      where: { id },
    });

    if (!message) {
      throw new NotFoundException('Message not found');
    }

    if (message.sender_id !== userId) {
      throw new ForbiddenException('You can only delete your own messages');
    }

    // Мягкое удаление
    await this.messageRepository.update(id, {
      is_deleted: true,
      content: null,
      media_url: null,
      thumbnail_url: null,
    });

    return { message: 'Message deleted successfully' };
  }

  async markAsRead(messageId: string, userId: string) {
    const message = await this.messageRepository.findOne({
      where: { id: messageId },
    });

    if (!message) {
      throw new NotFoundException('Message not found');
    }

    // Проверка участия в чате
    const participant = await this.participantRepository.findOne({
      where: { chat_id: message.chat_id, user_id: userId },
    });

    if (!participant || participant.is_removed) {
      throw new ForbiddenException('Access denied');
    }

    // Не нужно отмечать свои сообщения как прочитанные
    if (message.sender_id === userId) {
      return { message: 'Cannot mark own message as read' };
    }

    // Увеличить счетчик прочитавших
    await this.messageRepository.update(messageId, {
      read_count: () => 'read_count + 1',
    });

    // Уменьшить счетчик непрочитанных для участника
    if (participant.unread_count > 0) {
      await this.participantRepository.update(participant.id, {
        unread_count: () => 'unread_count - 1',
      });
    }

    return { message: 'Message marked as read' };
  }

  async markChatAsRead(chatId: string, userId: string) {
    // Проверка участия в чате
    const participant = await this.participantRepository.findOne({
      where: { chat_id: chatId, user_id: userId },
    });

    if (!participant || participant.is_removed) {
      throw new ForbiddenException('Access denied');
    }

    // Сбросить счетчик непрочитанных
    await this.participantRepository.update(participant.id, {
      unread_count: 0,
    });

    return { message: 'Chat marked as read' };
  }

  private validateMessageContent(dto: CreateMessageDto) {
    const {
      type,
      content,
      media_url,
      location_lat,
      location_lng,
      shared_profile_id,
      shared_post_id,
      booking_proposal_id,
    } = dto;

    switch (type) {
      case MessageType.TEXT:
        if (!content || content.trim().length === 0) {
          throw new BadRequestException('Text message must have content');
        }
        break;

      case MessageType.PHOTO:
      case MessageType.VIDEO:
        if (!media_url) {
          throw new BadRequestException(`${type} message must have media_url`);
        }
        break;

      case MessageType.VOICE:
        if (!media_url) {
          throw new BadRequestException('Voice message must have media_url');
        }
        break;

      case MessageType.LOCATION:
        if (location_lat === undefined || location_lng === undefined) {
          throw new BadRequestException('Location message must have coordinates');
        }
        break;

      case MessageType.PROFILE_SHARE:
        if (!shared_profile_id) {
          throw new BadRequestException('Profile share must have shared_profile_id');
        }
        break;

      case MessageType.POST_SHARE:
        if (!shared_post_id) {
          throw new BadRequestException('Post share must have shared_post_id');
        }
        break;

      case MessageType.BOOKING_PROPOSAL:
        if (!booking_proposal_id) {
          throw new BadRequestException(
            'Booking proposal must have booking_proposal_id',
          );
        }
        break;

      default:
        throw new BadRequestException('Invalid message type');
    }
  }
}
