// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'friend_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FriendshipModelImpl _$$FriendshipModelImplFromJson(
        Map<String, dynamic> json) =>
    _$FriendshipModelImpl(
      id: json['id'] as String,
      requesterId: json['requester_id'] as String,
      addresseeId: json['addressee_id'] as String,
      status: json['status'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
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
      'requester_id': instance.requesterId,
      'addressee_id': instance.addresseeId,
      'status': instance.status,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'requester': instance.requester,
      'addressee': instance.addressee,
    };

_$FriendModelImpl _$$FriendModelImplFromJson(Map<String, dynamic> json) =>
    _$FriendModelImpl(
      id: json['id'] as String,
      friendshipId: json['friendship_id'] as String,
      userId: json['user_id'] as String,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      avatarUrl: json['avatar_url'] as String?,
      isMaster: json['is_master'] as bool? ?? false,
      bio: json['bio'] as String?,
      mutualFriendsCount: (json['mutual_friends_count'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$FriendModelImplToJson(_$FriendModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'friendship_id': instance.friendshipId,
      'user_id': instance.userId,
      'first_name': instance.firstName,
      'last_name': instance.lastName,
      'avatar_url': instance.avatarUrl,
      'is_master': instance.isMaster,
      'bio': instance.bio,
      'mutual_friends_count': instance.mutualFriendsCount,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$SubscriptionModelImpl _$$SubscriptionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$SubscriptionModelImpl(
      id: json['id'] as String,
      subscriberId: json['subscriber_id'] as String,
      targetId: json['target_id'] as String,
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
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
      'subscriber_id': instance.subscriberId,
      'target_id': instance.targetId,
      'notifications_enabled': instance.notificationsEnabled,
      'created_at': instance.createdAt.toIso8601String(),
      'subscriber': instance.subscriber,
      'target': instance.target,
    };
