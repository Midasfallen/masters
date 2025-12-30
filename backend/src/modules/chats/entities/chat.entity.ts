import {
  Entity,
  Column,
  PrimaryGeneratedColumn,
  CreateDateColumn,
  UpdateDateColumn,
  OneToMany,
  Index,
} from 'typeorm';
import { ApiProperty } from '@nestjs/swagger';
import { ChatParticipant } from './chat-participant.entity';
import { Message } from './message.entity';

export enum ChatType {
  DIRECT = 'direct',
  GROUP = 'group',
}

@Entity('chats')
@Index(['type'])
@Index(['created_at'])
export class Chat {
  @ApiProperty({ example: '550e8400-e29b-41d4-a716-446655440000' })
  @PrimaryGeneratedColumn('uuid')
  id: string;

  @ApiProperty({ enum: ChatType, example: ChatType.DIRECT })
  @Column({
    type: 'enum',
    enum: ChatType,
    default: ChatType.DIRECT,
  })
  type: ChatType;

  @ApiProperty({ example: 'Команда разработки', nullable: true })
  @Column({ type: 'varchar', length: 255, nullable: true })
  name: string;

  @ApiProperty({ example: 'https://storage.example.com/chats/avatar.jpg', nullable: true })
  @Column({ type: 'text', nullable: true })
  avatar_url: string;

  @ApiProperty({ description: 'ID создателя группового чата', nullable: true })
  @Column({ type: 'uuid', nullable: true })
  creator_id: string;

  @ApiProperty({ description: 'ID последнего сообщения', nullable: true })
  @Column({ type: 'uuid', nullable: true })
  last_message_id: string;

  @ApiProperty({ description: 'Время последнего сообщения', nullable: true })
  @Column({ type: 'timestamp', nullable: true })
  last_message_at: Date;

  @ApiProperty()
  @CreateDateColumn()
  created_at: Date;

  @ApiProperty()
  @UpdateDateColumn()
  updated_at: Date;

  // Relations
  @OneToMany(() => ChatParticipant, (participant) => participant.chat)
  participants: ChatParticipant[];

  @OneToMany(() => Message, (message) => message.chat)
  messages: Message[];
}
