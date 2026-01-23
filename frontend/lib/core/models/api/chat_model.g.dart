// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatModelImpl _$$ChatModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatModelImpl(
      id: json['id'] as String,
      user1Id: json['user1_id'] as String,
      user2Id: json['user2_id'] as String,
      user1: json['user1'] == null
          ? null
          : UserModel.fromJson(json['user1'] as Map<String, dynamic>),
      user2: json['user2'] == null
          ? null
          : UserModel.fromJson(json['user2'] as Map<String, dynamic>),
      lastMessage: json['last_message'] == null
          ? null
          : MessageModel.fromJson(json['last_message'] as Map<String, dynamic>),
      unreadCount: (json['unread_count'] as num).toInt(),
      myParticipant: json['my_participant'] == null
          ? null
          : ChatParticipantModel.fromJson(
              json['my_participant'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$ChatModelImplToJson(_$ChatModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user1_id': instance.user1Id,
      'user2_id': instance.user2Id,
      'user1': instance.user1,
      'user2': instance.user2,
      'last_message': instance.lastMessage,
      'unread_count': instance.unreadCount,
      'my_participant': instance.myParticipant,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

_$ChatParticipantModelImpl _$$ChatParticipantModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatParticipantModelImpl(
      id: json['id'] as String,
      chatId: json['chat_id'] as String,
      userId: json['user_id'] as String,
      isPinned: json['is_pinned'] as bool,
      isArchived: json['is_archived'] as bool,
      unreadCount: (json['unread_count'] as num).toInt(),
      lastReadMessageId: json['last_read_message_id'] as String?,
    );

Map<String, dynamic> _$$ChatParticipantModelImplToJson(
        _$ChatParticipantModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chat_id': instance.chatId,
      'user_id': instance.userId,
      'is_pinned': instance.isPinned,
      'is_archived': instance.isArchived,
      'unread_count': instance.unreadCount,
      'last_read_message_id': instance.lastReadMessageId,
    };

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      id: json['id'] as String,
      chatId: json['chat_id'] as String,
      senderId: json['sender_id'] as String,
      receiverId: json['receiver_id'] as String,
      sender: json['sender'] == null
          ? null
          : UserModel.fromJson(json['sender'] as Map<String, dynamic>),
      content: json['content'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      mediaUrl: json['media_url'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isRead: json['is_read'] as bool,
      readAt: json['read_at'] == null
          ? null
          : DateTime.parse(json['read_at'] as String),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chat_id': instance.chatId,
      'sender_id': instance.senderId,
      'receiver_id': instance.receiverId,
      'sender': instance.sender,
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'media_url': instance.mediaUrl,
      'metadata': instance.metadata,
      'is_read': instance.isRead,
      'read_at': instance.readAt?.toIso8601String(),
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.image: 'image',
  MessageType.file: 'file',
  MessageType.booking: 'booking',
  MessageType.system: 'system',
};

_$CreateChatRequestImpl _$$CreateChatRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateChatRequestImpl(
      userId: json['user_id'] as String,
    );

Map<String, dynamic> _$$CreateChatRequestImplToJson(
        _$CreateChatRequestImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
    };

_$SendMessageRequestImpl _$$SendMessageRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SendMessageRequestImpl(
      content: json['content'] as String,
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']),
      mediaUrl: json['media_url'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$SendMessageRequestImplToJson(
        _$SendMessageRequestImpl instance) =>
    <String, dynamic>{
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type],
      'media_url': instance.mediaUrl,
      'metadata': instance.metadata,
    };
