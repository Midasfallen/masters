import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:service_platform/core/models/api/user_model.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

@freezed
class ChatModel with _$ChatModel {
  const factory ChatModel({
    required String id,
    required String user1Id,
    required String user2Id,
    UserModel? user1,
    UserModel? user2,
    MessageModel? lastMessage,
    required int unreadCount,
    ChatParticipantModel? myParticipant,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
}

@freezed
class ChatParticipantModel with _$ChatParticipantModel {
  const factory ChatParticipantModel({
    required String id,
    required String chatId,
    required String userId,
    required bool isPinned,
    required bool isArchived,
    required int unreadCount,
    String? lastReadMessageId,
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
    required String receiverId,
    UserModel? sender,
    required String content,
    required MessageType type,
    String? mediaUrl,
    Map<String, dynamic>? metadata,
    required bool isRead,
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

/// Create Chat Request
@freezed
class CreateChatRequest with _$CreateChatRequest {
  const factory CreateChatRequest({
    @JsonKey(name: 'user_id') required String userId,
  }) = _CreateChatRequest;

  factory CreateChatRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateChatRequestFromJson(json);
}

/// Send Message Request
@freezed
class SendMessageRequest with _$SendMessageRequest {
  const factory SendMessageRequest({
    required String content,
    MessageType? type,
    @JsonKey(name: 'media_url') String? mediaUrl,
    Map<String, dynamic>? metadata,
  }) = _SendMessageRequest;

  factory SendMessageRequest.fromJson(Map<String, dynamic> json) =>
      _$SendMessageRequestFromJson(json);
}
