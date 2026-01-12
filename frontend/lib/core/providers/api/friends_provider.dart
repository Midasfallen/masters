import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:service_platform/core/models/api/friend_model.dart';
import 'package:service_platform/core/repositories/friend_repository.dart';

part 'friends_provider.g.dart';

/// Friends List Provider
@riverpod
Future<List<FriendModel>> friendsList(
  FriendsListRef ref, {
  int page = 1,
  int limit = 50,
}) async {
  final repository = ref.watch(friendRepositoryProvider);
  return await repository.getFriends(page: page, limit: limit);
}

/// Incoming Friend Requests Provider
@riverpod
Future<List<FriendshipModel>> incomingFriendRequests(
  IncomingFriendRequestsRef ref, {
  int page = 1,
  int limit = 50,
}) async {
  final repository = ref.watch(friendRepositoryProvider);
  return await repository.getIncomingRequests(page: page, limit: limit);
}

/// Outgoing Friend Requests Provider
@riverpod
Future<List<FriendshipModel>> outgoingFriendRequests(
  OutgoingFriendRequestsRef ref, {
  int page = 1,
  int limit = 50,
}) async {
  final repository = ref.watch(friendRepositoryProvider);
  return await repository.getOutgoingRequests(page: page, limit: limit);
}

/// Friendship by ID Provider
@riverpod
Future<FriendshipModel> friendshipById(
  FriendshipByIdRef ref,
  String friendshipId,
) async {
  final repository = ref.watch(friendRepositoryProvider);
  return await repository.getFriendshipById(friendshipId);
}

/// Friend Notifier for mutations
@riverpod
class FriendNotifier extends _$FriendNotifier {
  @override
  FutureOr<FriendshipModel?> build() async {
    return null;
  }

  /// Send friend request
  Future<FriendshipModel> sendFriendRequest(String userId) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(friendRepositoryProvider);
      final friendship = await repository.sendFriendRequest(userId);

      // Invalidate outgoing requests list
      ref.invalidate(outgoingFriendRequestsProvider);

      return friendship;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }

  /// Accept friend request
  Future<FriendshipModel> acceptFriendRequest(String friendshipId) async {
    state = const AsyncValue.loading();

    return await AsyncValue.guard(() async {
      final repository = ref.read(friendRepositoryProvider);
      final friendship = await repository.acceptFriendRequest(friendshipId);

      // Invalidate relevant lists
      ref.invalidate(incomingFriendRequestsProvider);
      ref.invalidate(friendsListProvider);

      return friendship;
    }).then((asyncValue) {
      state = asyncValue;
      return asyncValue.requireValue;
    });
  }

  /// Decline friend request
  Future<void> declineFriendRequest(String friendshipId) async {
    state = const AsyncValue.loading();

    await AsyncValue.guard(() async {
      final repository = ref.read(friendRepositoryProvider);
      await repository.declineFriendRequest(friendshipId);

      // Invalidate incoming requests list
      ref.invalidate(incomingFriendRequestsProvider);
    }).then((asyncValue) {
      state = asyncValue as AsyncValue<FriendshipModel?>;
    });
  }

  /// Remove friend
  Future<void> removeFriend(String userId) async {
    state = const AsyncValue.loading();

    await AsyncValue.guard(() async {
      final repository = ref.read(friendRepositoryProvider);
      await repository.removeFriend(userId);

      // Invalidate friends list
      ref.invalidate(friendsListProvider);
    }).then((asyncValue) {
      state = asyncValue as AsyncValue<FriendshipModel?>;
    });
  }
}
