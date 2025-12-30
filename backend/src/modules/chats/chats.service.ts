import {
  Injectable,
  NotFoundException,
  ForbiddenException,
  BadRequestException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Chat, ChatType } from './entities/chat.entity';
import { ChatParticipant, ParticipantRole } from './entities/chat-participant.entity';
import { CreateChatDto } from './dto/create-chat.dto';
import { UpdateChatDto } from './dto/update-chat.dto';
import { MarkAsReadDto } from './dto/mark-as-read.dto';
import { PaginationDto } from '../../common/dto/pagination.dto';
import { User } from '../users/entities/user.entity';

@Injectable()
export class ChatsService {
  constructor(
    @InjectRepository(Chat)
    private readonly chatRepository: Repository<Chat>,
    @InjectRepository(ChatParticipant)
    private readonly participantRepository: Repository<ChatParticipant>,
    @InjectRepository(User)
    private readonly userRepository: Repository<User>,
  ) {}

  async create(userId: string, createChatDto: CreateChatDto) {
    const { type, name, avatar_url, participant_ids } = createChatDto;

    // Валидация: direct чат должен иметь ровно 1 другого участника
    if (type === ChatType.DIRECT && participant_ids.length !== 1) {
      throw new BadRequestException('Direct chat must have exactly one other participant');
    }

    // Проверка существования всех участников
    const participants = await this.userRepository.find({
      where: { id: In([userId, ...participant_ids]) },
    });

    if (participants.length !== participant_ids.length + 1) {
      throw new NotFoundException('Some participants not found');
    }

    // Для direct чата проверяем, не существует ли уже чат между этими пользователями
    if (type === ChatType.DIRECT) {
      const existingChat = await this.findExistingDirectChat(userId, participant_ids[0]);
      if (existingChat) {
        return existingChat;
      }
    }

    // Создание чата
    const chat = this.chatRepository.create({
      type,
      name,
      avatar_url,
      creator_id: userId,
    });

    const savedChat = await this.chatRepository.save(chat);

    // Добавление участников
    const chatParticipants = [
      // Создатель
      this.participantRepository.create({
        chat_id: savedChat.id,
        user_id: userId,
        role: type === ChatType.GROUP ? ParticipantRole.OWNER : ParticipantRole.MEMBER,
      }),
      // Остальные участники
      ...participant_ids.map((id) =>
        this.participantRepository.create({
          chat_id: savedChat.id,
          user_id: id,
          role: ParticipantRole.MEMBER,
        }),
      ),
    ];

    await this.participantRepository.save(chatParticipants);

    return this.findOne(savedChat.id, userId);
  }

  async findAll(userId: string, paginationDto: PaginationDto) {
    const { page = 1, limit = 20 } = paginationDto;

    const queryBuilder = this.participantRepository
      .createQueryBuilder('participant')
      .leftJoinAndSelect('participant.chat', 'chat')
      .leftJoinAndSelect('chat.participants', 'all_participants')
      .leftJoinAndSelect('all_participants.user', 'user')
      .where('participant.user_id = :userId', { userId })
      .andWhere('participant.is_removed = :isRemoved', { isRemoved: false })
      .orderBy('chat.last_message_at', 'DESC', 'NULLS LAST')
      .addOrderBy('chat.created_at', 'DESC');

    const [participants, total] = await queryBuilder
      .skip((page - 1) * limit)
      .take(limit)
      .getManyAndCount();

    const chats = participants.map((p) => ({
      ...p.chat,
      my_participant: p,
    }));

    return {
      data: chats,
      meta: {
        page,
        limit,
        total,
        totalPages: Math.ceil(total / limit),
      },
    };
  }

  async findOne(id: string, userId: string) {
    const chat = await this.chatRepository.findOne({
      where: { id },
      relations: ['participants', 'participants.user'],
    });

    if (!chat) {
      throw new NotFoundException('Chat not found');
    }

    // Проверка участия
    const myParticipant = chat.participants.find((p) => p.user_id === userId);
    if (!myParticipant || myParticipant.is_removed) {
      throw new ForbiddenException('Access denied');
    }

    return {
      ...chat,
      my_participant: myParticipant,
    };
  }

  async update(id: string, userId: string, updateChatDto: UpdateChatDto) {
    const chat = await this.chatRepository.findOne({
      where: { id },
      relations: ['participants'],
    });

    if (!chat) {
      throw new NotFoundException('Chat not found');
    }

    if (chat.type !== ChatType.GROUP) {
      throw new BadRequestException('Can only update group chats');
    }

    // Проверка прав (только владелец или админ)
    const participant = chat.participants.find((p) => p.user_id === userId);
    if (
      !participant ||
      participant.is_removed ||
      (participant.role !== ParticipantRole.OWNER &&
        participant.role !== ParticipantRole.ADMIN)
    ) {
      throw new ForbiddenException('Only owner or admin can update chat');
    }

    await this.chatRepository.update(id, updateChatDto);

    return this.findOne(id, userId);
  }

  async remove(id: string, userId: string) {
    const chat = await this.chatRepository.findOne({
      where: { id },
      relations: ['participants'],
    });

    if (!chat) {
      throw new NotFoundException('Chat not found');
    }

    const participant = chat.participants.find((p) => p.user_id === userId);
    if (!participant || participant.is_removed) {
      throw new ForbiddenException('Access denied');
    }

    // Если это direct чат или пользователь - владелец группы, удаляем чат полностью
    if (chat.type === ChatType.DIRECT || participant.role === ParticipantRole.OWNER) {
      await this.chatRepository.remove(chat);
      return { message: 'Chat deleted successfully' };
    } else {
      // Иначе помечаем участника как удаленного
      participant.is_removed = true;
      await this.participantRepository.save(participant);
      return { message: 'Left chat successfully' };
    }
  }

  async markAsRead(id: string, userId: string, markAsReadDto: MarkAsReadDto) {
    const participant = await this.participantRepository.findOne({
      where: { chat_id: id, user_id: userId },
    });

    if (!participant || participant.is_removed) {
      throw new ForbiddenException('Access denied');
    }

    participant.last_read_message_id = markAsReadDto.message_id;
    participant.last_read_at = new Date();
    participant.unread_count = 0;

    await this.participantRepository.save(participant);

    return { message: 'Messages marked as read' };
  }

  async addParticipant(chatId: string, participantId: string, userId: string) {
    const chat = await this.chatRepository.findOne({
      where: { id: chatId },
      relations: ['participants'],
    });

    if (!chat) {
      throw new NotFoundException('Chat not found');
    }

    if (chat.type !== ChatType.GROUP) {
      throw new BadRequestException('Can only add participants to group chats');
    }

    // Проверка прав
    const requester = chat.participants.find((p) => p.user_id === userId);
    if (
      !requester ||
      requester.is_removed ||
      (requester.role !== ParticipantRole.OWNER &&
        requester.role !== ParticipantRole.ADMIN)
    ) {
      throw new ForbiddenException('Only owner or admin can add participants');
    }

    // Проверка существования нового участника
    const newUser = await this.userRepository.findOne({
      where: { id: participantId },
    });

    if (!newUser) {
      throw new NotFoundException('User not found');
    }

    // Проверка, не является ли уже участником
    const existingParticipant = chat.participants.find(
      (p) => p.user_id === participantId && !p.is_removed,
    );

    if (existingParticipant) {
      throw new ConflictException('User is already a participant');
    }

    const participant = this.participantRepository.create({
      chat_id: chatId,
      user_id: participantId,
      role: ParticipantRole.MEMBER,
    });

    await this.participantRepository.save(participant);

    return { message: 'Participant added successfully' };
  }

  async removeParticipant(chatId: string, participantId: string, userId: string) {
    const chat = await this.chatRepository.findOne({
      where: { id: chatId },
      relations: ['participants'],
    });

    if (!chat) {
      throw new NotFoundException('Chat not found');
    }

    if (chat.type !== ChatType.GROUP) {
      throw new BadRequestException('Can only remove participants from group chats');
    }

    // Проверка прав
    const requester = chat.participants.find((p) => p.user_id === userId);
    if (
      !requester ||
      requester.is_removed ||
      (requester.role !== ParticipantRole.OWNER &&
        requester.role !== ParticipantRole.ADMIN)
    ) {
      throw new ForbiddenException('Only owner or admin can remove participants');
    }

    const participant = chat.participants.find((p) => p.user_id === participantId);
    if (!participant || participant.is_removed) {
      throw new NotFoundException('Participant not found');
    }

    // Нельзя удалить владельца
    if (participant.role === ParticipantRole.OWNER) {
      throw new ForbiddenException('Cannot remove chat owner');
    }

    participant.is_removed = true;
    await this.participantRepository.save(participant);

    return { message: 'Participant removed successfully' };
  }

  private async findExistingDirectChat(userId1: string, userId2: string): Promise<Chat | null> {
    const participant = await this.participantRepository
      .createQueryBuilder('p1')
      .innerJoin(
        ChatParticipant,
        'p2',
        'p1.chat_id = p2.chat_id AND p2.user_id = :userId2',
        { userId2 },
      )
      .leftJoinAndSelect('p1.chat', 'chat')
      .where('p1.user_id = :userId1', { userId1 })
      .andWhere('chat.type = :type', { type: ChatType.DIRECT })
      .andWhere('p1.is_removed = :isRemoved', { isRemoved: false })
      .andWhere('p2.is_removed = :isRemoved', { isRemoved: false })
      .getOne();

    return participant?.chat || null;
  }
}
