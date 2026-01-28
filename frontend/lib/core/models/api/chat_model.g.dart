// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatModelImpl _$$ChatModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatModelImpl(
      id: json['id'] as String,
      user1Id: json['user1Id'] as String,
      user2Id: json['user2Id'] as String,
      user1: json['user1'] == null
          ? null
          : UserModel.fromJson(json['user1'] as Map<String, dynamic>),
      user2: json['user2'] == null
          ? null
          : UserModel.fromJson(json['user2'] as Map<String, dynamic>),
      lastMessage: json['lastMessage'] == null
          ? null
          : MessageModel.fromJson(json['lastMessage'] as Map<String, dynamic>),
      unreadCount: (json['unreadCount'] as num).toInt(),
      myParticipant: json['myParticipant'] == null
          ? null
          : ChatParticipantModel.fromJson(
              json['myParticipant'] as Map<String, dynamic>),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$ChatModelImplToJson(_$ChatModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user1Id': instance.user1Id,
      'user2Id': instance.user2Id,
      'user1': instance.user1,
      'user2': instance.user2,
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
      'myParticipant': instance.myParticipant,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

_$ChatParticipantModelImpl _$$ChatParticipantModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatParticipantModelImpl(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      userId: json['userId'] as String,
      isPinned: json['isPinned'] as bool,
      isArchived: json['isArchived'] as bool,
      unreadCount: (json['unreadCount'] as num).toInt(),
      lastReadMessageId: json['lastReadMessageId'] as String?,
    );

Map<String, dynamic> _$$ChatParticipantModelImplToJson(
        _$ChatParticipantModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatId': instance.chatId,
      'userId': instance.userId,
      'isPinned': instance.isPinned,
      'isArchived': instance.isArchived,
      'unreadCount': instance.unreadCount,
      'lastReadMessageId': instance.lastReadMessageId,
    };

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      receiverId: json['receiverId'] as String,
      sender: json['sender'] == null
          ? null
          : UserModel.fromJson(json['sender'] as Map<String, dynamic>),
      content: json['content'] as String,
      type: $enumDecode(_$MessageTypeEnumMap, json['type']),
      mediaUrl: json['mediaUrl'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
      isRead: json['isRead'] as bool,
      readAt: json['readAt'] == null
          ? null
          : DateTime.parse(json['readAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatId': instance.chatId,
      'senderId': instance.senderId,
      'receiverId': instance.receiverId,
      'sender': instance.sender,
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'mediaUrl': instance.mediaUrl,
      'metadata': instance.metadata,
      'isRead': instance.isRead,
      'readAt': instance.readAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
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
