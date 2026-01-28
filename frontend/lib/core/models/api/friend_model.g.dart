// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendshipModelImpl _$$FriendshipModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FriendshipModelImpl(
      id: json['id'] as String,
      requesterId: json['requesterId'] as String,
      addresseeId: json['addresseeId'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      requester: json['requester'] == null
          ? null
          : UserModel.fromJson(json['requester'] as Map<String, dynamic>),
      addressee: json['addressee'] == null
          ? null
          : UserModel.fromJson(json['addressee'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FriendshipModelImplToJson(
        _$FriendshipModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'requesterId': instance.requesterId,
      'addresseeId': instance.addresseeId,
      'status': instance.status,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
      'requester': instance.requester,
      'addressee': instance.addressee,
    };

_$FriendModelImpl _$$FriendModelImplFromJson(Map<String, dynamic> json) =>
    _$FriendModelImpl(
      id: json['id'] as String,
      friendshipId: json['friendshipId'] as String,
      userId: json['userId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      isMaster: json['isMaster'] as bool? ?? false,
      bio: json['bio'] as String?,
      mutualFriendsCount: (json['mutualFriendsCount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$FriendModelImplToJson(_$FriendModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'friendshipId': instance.friendshipId,
      'userId': instance.userId,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'avatarUrl': instance.avatarUrl,
      'isMaster': instance.isMaster,
      'bio': instance.bio,
      'mutualFriendsCount': instance.mutualFriendsCount,
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$SubscriptionModelImpl _$$SubscriptionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SubscriptionModelImpl(
      id: json['id'] as String,
      subscriberId: json['subscriberId'] as String,
      targetId: json['targetId'] as String,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      subscriber: json['subscriber'] == null
          ? null
          : UserModel.fromJson(json['subscriber'] as Map<String, dynamic>),
      target: json['target'] == null
          ? null
          : UserModel.fromJson(json['target'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$SubscriptionModelImplToJson(
        _$SubscriptionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'subscriberId': instance.subscriberId,
      'targetId': instance.targetId,
      'notificationsEnabled': instance.notificationsEnabled,
      'createdAt': instance.createdAt.toIso8601String(),
      'subscriber': instance.subscriber,
      'target': instance.target,
    };
