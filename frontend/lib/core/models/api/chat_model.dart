import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:service_platform/core/models/api/user_model.dart';

part 'chat_model.freezed.dart';
part 'chat_model.g.dart';

@freezed
class ChatModel with _$ChatModel {
  const factory ChatModel({
    required String id,
    @JsonKey(name: 'user1_id') required String user1Id,
    @JsonKey(name: 'user2_id') required String user2Id,
    UserModel? user1,
    UserModel? user2,
    @JsonKey(name: 'last_message') MessageModel? lastMessage,
    @JsonKey(name: 'unread_count') required int unreadCount,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _ChatModel;

  factory ChatModel.fromJson(Map<String, dynamic> json) =>
      _$ChatModelFromJson(json);
}

/// Message Model
@freezed
class MessageModel with _$MessageModel {
  const factory MessageModel({
    required String id,
    @JsonKey(name: 'chat_id') required String chatId,
    @JsonKey(name: 'sender_id') required String senderId,
    @JsonKey(name: 'receiver_id') required String receiverId,
    UserModel? sender,
    required String content,
    required MessageType type,
    @JsonKey(name: 'media_url') String? mediaUrl,
    Map<String, dynamic>? metadata,
    @JsonKey(name: 'is_read') required bool isRead,
    @JsonKey(name: 'read_at') DateTime? readAt,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
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
