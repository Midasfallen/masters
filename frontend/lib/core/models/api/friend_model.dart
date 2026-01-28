import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:service_platform/core/models/api/user_model.dart';

part 'friend_model.freezed.dart';
part 'friend_model.g.dart';

/// Friendship Model для API
@freezed
class FriendshipModel with _$FriendshipModel {
  const factory FriendshipModel({
    required String id,
    required String requesterId,
    required String addresseeId,
    required String status, // pending, accepted, declined, blocked
    required DateTime createdAt,
    required DateTime updatedAt,
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
    required String friendshipId,
    required String userId,
    required String firstName,
    required String lastName,
    String? avatarUrl,
    @Default(false) bool isMaster,
    String? bio,
    @Default(0) int mutualFriendsCount,
    required DateTime createdAt,
  }) = _FriendModel;

  factory FriendModel.fromJson(Map<String, dynamic> json) =>
      _$FriendModelFromJson(json);
}

/// Subscription Model для API
@freezed
class SubscriptionModel with _$SubscriptionModel {
  const factory SubscriptionModel({
    required String id,
    required String subscriberId,
    required String targetId,
    @Default(true) bool notificationsEnabled,
    required DateTime createdAt,
    // Relations (optional)
    UserModel? subscriber,
    UserModel? target,
  }) = _SubscriptionModel;

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionModelFromJson(json);
}
