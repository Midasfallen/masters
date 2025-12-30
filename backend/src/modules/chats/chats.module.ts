import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ChatsController } from './chats.controller';
import { ChatsService } from './chats.service';
import { MessagesController } from './messages.controller';
import { MessagesService } from './messages.service';
import { Chat } from './entities/chat.entity';
import { Message } from './entities/message.entity';
import { ChatParticipant } from './entities/chat-participant.entity';
import { User } from '../users/entities/user.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Chat, Message, ChatParticipant, User])],
  controllers: [ChatsController, MessagesController],
  providers: [ChatsService, MessagesService],
  exports: [ChatsService, MessagesService],
})
export class ChatsModule {}
