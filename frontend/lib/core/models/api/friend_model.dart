import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:service_platform/core/models/api/user_model.dart';

part 'friend_model.freezed.dart';
part 'friend_model.g.dart';

/// Friendship Model для API
@freezed
class FriendshipModel with _$FriendshipModel {
  const factory FriendshipModel({
    required String id,
    @JsonKey(name: 'requester_id') required String requesterId,
    @JsonKey(name: 'addressee_id') required String addresseeId,
    required String status, // pending, accepted, declined, blocked
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
    // Relations (optional, если backend их возвращает)
    UserModel? requester,
    UserModel? addressee,
  }) = _FriendshipModel;

  factory FriendshipModel.fromJson(Map<String, dynamic> json) =>
      _$FriendshipModelFromJson(json);
}

/// Friend Request Response (для списков друзей)
@freezed
class FriendModel with _$FriendModel {
  const factory FriendModel({
    required String id,
    @JsonKey(name: 'friendship_id') required String friendshipId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    @JsonKey(name: 'avatar_url') String? avatarUrl,
    @JsonKey(name: 'is_master') @Default(false) bool isMaster,
    String? bio,
    @JsonKey(name: 'mutual_friends_count') @Default(0) int mutualFriendsCount,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _FriendModel;

  factory FriendModel.fromJson(Map<String, dynamic> json) =>
      _$FriendModelFromJson(json);
}

/// Subscription Model для API
@freezed
class SubscriptionModel with _$SubscriptionModel {
  const factory SubscriptionModel({
    required String id,
    @JsonKey(name: 'subscriber_id') required String subscriberId,
    @JsonKey(name: 'target_id') required String targetId,
    @JsonKey(name: 'notifications_enabled') @Default(true) bool notificationsEnabled,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    // Relations (optional)
    UserModel? subscriber,
    UserModel? target,
  }) = _SubscriptionModel;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);
}
