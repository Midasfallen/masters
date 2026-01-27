import { Chat } from './entities/chat.entity';
import { Message } from './entities/message.entity';
import { ChatParticipant } from './entities/chat-participant.entity';
import { ChatResponseDto } from './dto/chat-response.dto';
import { MessageResponseDto, MediaMetadataDto } from './dto/message-response.dto';
import { ChatParticipantResponseDto } from './dto/chat-participant-response.dto';

/**
 * Mapper для преобразования Chat/Message/ChatParticipant → Response DTOs
 */
export class ChatsMapper {
  /**
   * Преобразует Chat entity в ChatResponseDto
   */
  static toChatDto(chat: Chat): ChatResponseDto {
    return {
      id: chat.id,
      type: chat.type,
      name: chat.name,
      avatarUrl: chat.avatar_url,
      creatorId: chat.creator_id,
      lastMessageId: chat.last_message_id,
      lastMessageAt: chat.last_message_at,
      createdAt: chat.created_at,
      updatedAt: chat.updated_at,
    };
  }

  /**
   * Преобразует массив Chat entities в массив ChatResponseDto
   */
  static toChatDtoArray(chats: Chat[]): ChatResponseDto[] {
    return chats.map((chat) => this.toChatDto(chat));
  }

  /**
   * Преобразует метаданные медиа
   */
  static toMediaMetadataDto(
    metadata: Record<string, any> | null,
  ): MediaMetadataDto | null {
    if (!metadata) return null;

    return {
      width: metadata.width,
      height: metadata.height,
      duration: metadata.duration,
      size: metadata.size,
      filename: metadata.filename,
      mimeType: metadata.mime_type,
    };
  }

  /**
   * Преобразует Message entity в MessageResponseDto
   */
  static toMessageDto(message: Message): MessageResponseDto {
    return {
      id: message.id,
      chatId: message.chat_id,
      senderId: message.sender_id,
      type: message.type,
      content: message.content,
      mediaUrl: message.media_url,
      thumbnailUrl: message.thumbnail_url,
      mediaMetadata: this.toMediaMetadataDto(message.media_metadata),
      locationLat: message.location_lat ? Number(message.location_lat) : null,
      locationLng: message.location_lng ? Number(message.location_lng) : null,
      locationName: message.location_name,
      sharedProfileId: message.shared_profile_id,
      sharedPostId: message.shared_post_id,
      bookingProposalId: message.booking_proposal_id,
      replyToId: message.reply_to_id,
      readCount: message.read_count,
      isEdited: message.is_edited,
      isDeleted: message.is_deleted,
      createdAt: message.created_at,
      updatedAt: message.updated_at,
    };
  }

  /**
   * Преобразует массив Message entities в массив MessageResponseDto
   */
  static toMessageDtoArray(messages: Message[]): MessageResponseDto[] {
    return messages.map((message) => this.toMessageDto(message));
  }

  /**
   * Преобразует ChatParticipant entity в ChatParticipantResponseDto
   */
  static toParticipantDto(participant: ChatParticipant): ChatParticipantResponseDto {
    return {
      id: participant.id,
      chatId: participant.chat_id,
      userId: participant.user_id,
      role: participant.role,
      lastReadMessageId: participant.last_read_message_id,
      lastReadAt: participant.last_read_at,
      unreadCount: participant.unread_count,
      notificationsEnabled: participant.notifications_enabled,
      isArchived: participant.is_archived,
      isPinned: participant.is_pinned,
      isRemoved: participant.is_removed,
      joinedAt: participant.joined_at,
      updatedAt: participant.updated_at,
    };
  }

  /**
   * Преобразует массив ChatParticipant entities в массив ChatParticipantResponseDto
   */
  static toParticipantDtoArray(participants: ChatParticipant[]): ChatParticipantResponseDto[] {
    return participants.map((participant) => this.toParticipantDto(participant));
  }
}
