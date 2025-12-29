// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatImpl _$$ChatImplFromJson(Map<String, dynamic> json) => _$ChatImpl(
      id: json['id'] as String,
      participantId: json['participantId'] as String,
      participantName: json['participantName'] as String,
      participantAvatar: json['participantAvatar'] as String,
      lastMessage: json['lastMessage'] == null
          ? null
          : Message.fromJson(json['lastMessage'] as Map<String, dynamic>),
      unreadCount: (json['unreadCount'] as num).toInt(),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isOnline: json['isOnline'] as bool?,
      isPinned: json['isPinned'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatImplToJson(_$ChatImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'participantId': instance.participantId,
      'participantName': instance.participantName,
      'participantAvatar': instance.participantAvatar,
      'lastMessage': instance.lastMessage,
      'unreadCount': instance.unreadCount,
      'updatedAt': instance.updatedAt.toIso8601String(),
      'isOnline': instance.isOnline,
      'isPinned': instance.isPinned,
    };
