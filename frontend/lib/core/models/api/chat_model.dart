import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

/// Chat type enum
enum ChatType {
  @JsonValue('direct')
  direct,
  @JsonValue('group')
  group,
}

/// Participant role enum
enum ParticipantRole {
  @JsonValue('admin')
  admin,
  @JsonValue('member')
  member,
  @JsonValue('owner')
  owner,
}

/// Chat User Model - упрощённая модель пользователя в контексте чата
/// Соответствует backend ChatUserResponseDto
@freezed
class ChatUserModel with _$ChatUserModel {
  const factory ChatUserModel({
    required String id,
    required String firstName,
    required String lastName,
    String? fullName,
    String? avatarUrl,
    @Default(false) bool isMaster,
    @Default(false) bool isVerified,
  }) = _ChatUserModel;

  factory ChatUserModel.fromJson(Map<String, dynamic> json) =>
      _$ChatUserModelFromJson(json);
}

/// Chat Model - соответствует backend ChatResponseDto
@freezed
class ChatModel with _$ChatModel {
  const factory ChatModel({
    required String id,
    required ChatType type,
    String? name,
    String? avatarUrl,
    String? creatorId,
    String? lastMessageId,
    DateTime? lastMessageAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    ChatParticipantModel? myParticipant,
    // Дополнительные поля для UI
    List<ChatParticipantModel>? participants,
    MessageModel? lastMessage,
    ChatUserModel? otherUser,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
}

/// Chat Participant Model - соответствует backend ChatParticipantResponseDto
@freezed
class ChatParticipantModel with _$ChatParticipantModel {
  const factory ChatParticipantModel({
    required String id,
    required String chatId,
    required String userId,
    @Default(ParticipantRole.member) ParticipantRole role,
    String? lastReadMessageId,
    DateTime? lastReadAt,
    @Default(0) int unreadCount,
    @Default(true) bool notificationsEnabled,
    @Default(false) bool isArchived,
    @Default(false) bool isPinned,
    @Default(false) bool isRemoved,
    required DateTime joinedAt,
    required DateTime updatedAt,
    // User info для UI
    ChatUserModel? user,
  }) = _ChatParticipantModel;

  factory ChatParticipantModel.fromJson(Map<String, dynamic> json) =>
      _$ChatParticipantModelFromJson(json);
}

/// Message Model
@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    required String chatId,
    required String senderId,
    ChatUserModel? sender,
    required String content,
    @Default(MessageType.text) MessageType type,
    String? mediaUrl,
    Map<String, dynamic>? metadata,
    @Default(false) bool isRead,
    DateTime? readAt,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _MessageModel;

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
}

enum MessageType {
  @JsonValue('text')
  text,
  @JsonValue('image')
  image,
  @JsonValue('file')
  file,
  @JsonValue('booking')
  booking,
  @JsonValue('system')
  system,
}

/// Create Chat Request - соответствует backend CreateChatDto
@freezed
class CreateChatRequest with _$CreateChatRequest {
  const factory CreateChatRequest({
    @Default(ChatType.direct) ChatType type,
    String? name,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'participant_ids') required List<String> participantIds,
  }) = _CreateChatRequest;

  factory CreateChatRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateChatRequestFromJson(json);
}

/// Send Message Request
@freezed
class SendMessageRequest with _$SendMessageRequest {
  const factory SendMessageRequest({
    required String content,
    @Default(MessageType.text) MessageType type,
    @JsonKey(name: 'media_url') String? mediaUrl,
    Map<String, dynamic>? metadata,
  }) = _SendMessageRequest;

  factory SendMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$SendMessageRequestFromJson(json);
}
