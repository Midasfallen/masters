// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatUserModelImpl _$$ChatUserModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatUserModelImpl(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      fullName: json['fullName'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      isMaster: json['isMaster'] as bool? ?? false,
      isVerified: json['isVerified'] as bool? ?? false,
    );

Map<String, dynamic> _$$ChatUserModelImplToJson(_$ChatUserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'fullName': instance.fullName,
      'avatarUrl': instance.avatarUrl,
      'isMaster': instance.isMaster,
      'isVerified': instance.isVerified,
    };

_$ChatModelImpl _$$ChatModelImplFromJson(Map<String, dynamic> json) =>
    _$ChatModelImpl(
      id: json['id'] as String,
      type: $enumDecode(_$ChatTypeEnumMap, json['type']),
      name: json['name'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      creatorId: json['creatorId'] as String?,
      lastMessageId: json['lastMessageId'] as String?,
      lastMessageAt: json['lastMessageAt'] == null
          ? null
          : DateTime.parse(json['lastMessageAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      myParticipant: json['myParticipant'] == null
          ? null
          : ChatParticipantModel.fromJson(
              json['myParticipant'] as Map<String, dynamic>),
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => ChatParticipantModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      lastMessage: json['lastMessage'] == null
          ? null
          : MessageModel.fromJson(json['lastMessage'] as Map<String, dynamic>),
      otherUser: json['otherUser'] == null
          ? null
          : ChatUserModel.fromJson(json['otherUser'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ChatModelImplToJson(_$ChatModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$ChatTypeEnumMap[instance.type]!,
      'name': instance.name,
      'avatarUrl': instance.avatarUrl,
      'creatorId': instance.creatorId,
      'lastMessageId': instance.lastMessageId,
      'lastMessageAt': instance.lastMessageAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'myParticipant': instance.myParticipant,
      'participants': instance.participants,
      'lastMessage': instance.lastMessage,
      'otherUser': instance.otherUser,
    };

const _$ChatTypeEnumMap = {
  ChatType.direct: 'direct',
  ChatType.group: 'group',
};

_$ChatParticipantModelImpl _$$ChatParticipantModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ChatParticipantModelImpl(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      userId: json['userId'] as String,
      role: $enumDecodeNullable(_$ParticipantRoleEnumMap, json['role']) ??
          ParticipantRole.member,
      lastReadMessageId: json['lastReadMessageId'] as String?,
      lastReadAt: json['lastReadAt'] == null
          ? null
          : DateTime.parse(json['lastReadAt'] as String),
      unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      isArchived: json['isArchived'] as bool? ?? false,
      isPinned: json['isPinned'] as bool? ?? false,
      isRemoved: json['isRemoved'] as bool? ?? false,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      user: json['user'] == null
          ? null
          : ChatUserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ChatParticipantModelImplToJson(
        _$ChatParticipantModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatId': instance.chatId,
      'userId': instance.userId,
      'role': _$ParticipantRoleEnumMap[instance.role]!,
      'lastReadMessageId': instance.lastReadMessageId,
      'lastReadAt': instance.lastReadAt?.toIso8601String(),
      'unreadCount': instance.unreadCount,
      'notificationsEnabled': instance.notificationsEnabled,
      'isArchived': instance.isArchived,
      'isPinned': instance.isPinned,
      'isRemoved': instance.isRemoved,
      'joinedAt': instance.joinedAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'user': instance.user,
    };

const _$ParticipantRoleEnumMap = {
  ParticipantRole.admin: 'admin',
  ParticipantRole.member: 'member',
  ParticipantRole.owner: 'owner',
};

_$MediaMetadataModelImpl _$$MediaMetadataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$MediaMetadataModelImpl(
      width: (json['width'] as num?)?.toInt(),
      height: (json['height'] as num?)?.toInt(),
      duration: (json['duration'] as num?)?.toDouble(),
      size: (json['size'] as num?)?.toInt(),
      filename: json['filename'] as String?,
      mimeType: json['mimeType'] as String?,
    );

Map<String, dynamic> _$$MediaMetadataModelImplToJson(
        _$MediaMetadataModelImpl instance) =>
    <String, dynamic>{
      'width': instance.width,
      'height': instance.height,
      'duration': instance.duration,
      'size': instance.size,
      'filename': instance.filename,
      'mimeType': instance.mimeType,
    };

_$MessageModelImpl _$$MessageModelImplFromJson(Map<String, dynamic> json) =>
    _$MessageModelImpl(
      id: json['id'] as String,
      chatId: json['chatId'] as String,
      senderId: json['senderId'] as String,
      sender: json['sender'] == null
          ? null
          : ChatUserModel.fromJson(json['sender'] as Map<String, dynamic>),
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
          MessageType.text,
      content: json['content'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      mediaMetadata: json['mediaMetadata'] == null
          ? null
          : MediaMetadataModel.fromJson(
              json['mediaMetadata'] as Map<String, dynamic>),
      locationLat: (json['locationLat'] as num?)?.toDouble(),
      locationLng: (json['locationLng'] as num?)?.toDouble(),
      locationName: json['locationName'] as String?,
      sharedProfileId: json['sharedProfileId'] as String?,
      sharedPostId: json['sharedPostId'] as String?,
      bookingProposalId: json['bookingProposalId'] as String?,
      replyToId: json['replyToId'] as String?,
      readCount: (json['readCount'] as num?)?.toInt() ?? 0,
      isEdited: json['isEdited'] as bool? ?? false,
      isDeleted: json['isDeleted'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$MessageModelImplToJson(_$MessageModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chatId': instance.chatId,
      'senderId': instance.senderId,
      'sender': instance.sender,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'content': instance.content,
      'mediaUrl': instance.mediaUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'mediaMetadata': instance.mediaMetadata,
      'locationLat': instance.locationLat,
      'locationLng': instance.locationLng,
      'locationName': instance.locationName,
      'sharedProfileId': instance.sharedProfileId,
      'sharedPostId': instance.sharedPostId,
      'bookingProposalId': instance.bookingProposalId,
      'replyToId': instance.replyToId,
      'readCount': instance.readCount,
      'isEdited': instance.isEdited,
      'isDeleted': instance.isDeleted,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$MessageTypeEnumMap = {
  MessageType.text: 'text',
  MessageType.photo: 'photo',
  MessageType.video: 'video',
  MessageType.voice: 'voice',
  MessageType.location: 'location',
  MessageType.profileShare: 'profile_share',
  MessageType.postShare: 'post_share',
  MessageType.bookingProposal: 'booking_proposal',
};

_$CreateChatRequestImpl _$$CreateChatRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreateChatRequestImpl(
      type: $enumDecodeNullable(_$ChatTypeEnumMap, json['type']) ??
          ChatType.direct,
      name: json['name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      participantIds: (json['participant_ids'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$$CreateChatRequestImplToJson(
        _$CreateChatRequestImpl instance) =>
    <String, dynamic>{
      'type': _$ChatTypeEnumMap[instance.type]!,
      'name': instance.name,
      'avatar_url': instance.avatarUrl,
      'participant_ids': instance.participantIds,
    };

_$SendMessageRequestImpl _$$SendMessageRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$SendMessageRequestImpl(
      chatId: json['chat_id'] as String,
      type: $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
          MessageType.text,
      content: json['content'] as String?,
      mediaUrl: json['media_url'] as String?,
      thumbnailUrl: json['thumbnail_url'] as String?,
      mediaMetadata: json['media_metadata'] as Map<String, dynamic>?,
      locationLat: (json['location_lat'] as num?)?.toDouble(),
      locationLng: (json['location_lng'] as num?)?.toDouble(),
      locationName: json['location_name'] as String?,
      sharedProfileId: json['shared_profile_id'] as String?,
      sharedPostId: json['shared_post_id'] as String?,
      bookingProposalId: json['booking_proposal_id'] as String?,
      replyToId: json['reply_to_id'] as String?,
    );

Map<String, dynamic> _$$SendMessageRequestImplToJson(
        _$SendMessageRequestImpl instance) =>
    <String, dynamic>{
      'chat_id': instance.chatId,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'content': instance.content,
      'media_url': instance.mediaUrl,
      'thumbnail_url': instance.thumbnailUrl,
      'media_metadata': instance.mediaMetadata,
      'location_lat': instance.locationLat,
      'location_lng': instance.locationLng,
      'location_name': instance.locationName,
      'shared_profile_id': instance.sharedProfileId,
      'shared_post_id': instance.sharedPostId,
      'booking_proposal_id': instance.bookingProposalId,
      'reply_to_id': instance.replyToId,
    };
